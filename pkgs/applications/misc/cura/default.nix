{ stdenv, fetchFromGitHub, curaengine, cmake, pythonPackages, gettext }:

let
  inherit (pythonPackages) python;
  inherit (pythonPackages.uranium.pyqt5) qt5;

in stdenv.mkDerivation rec {
  name = "cura-${version}";
  version = "15.06.03";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "Cura";
    rev = version;
    sha256 = "0l58c6sg4q8vwhihbjz6v542klf0k3c0fl9ria7dbmx2hn5h0mx3";
  };

  nativeBuildInputs = [ cmake qt5.qttools pythonPackages.wrapPython qt5.makeQtWrapper ];

  buildInputs = [ python gettext qt5.qtquickcontrols ];

  cmakeFlags = [ "-DURANIUM_SCRIPTS_DIR=${pythonPackages.uranium.src}/scripts" ];

  pythonPath = with pythonPackages; [ uranium libarcus protobuf3_0 pyserial ];

  patches = [ ./fix_paths.patch ];

  postPatch = ''
    sed -i 's,@curaengine@,${curaengine},g' plugins/CuraEngineBackend/CuraEngineBackend.py
  '';

  postFixup = ''
    mkdir -p $out/${python.sitePackages}
    mv $out/lib/python?/dist-packages/* $out/${python.sitePackages}
    rm -rf $out/lib/python?

    wrapPythonPrograms

    mv $out/bin/cura_app.py $out/bin/cura
    sed -i -e "s,/usr/,$out,g" -e "s,cura_app.py,cura,g" $out/share/applications/cura.desktop

    wrapQtProgram $out/bin/cura

    sed -i "2icd $out/bin" $out/bin/cura
  '';

  meta = with stdenv.lib; {
    description = "3D printing host software";
    homepage = https://github.com/Ultimaker/Cura;
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
