{ stdenv, fetchFromGitHub, cmake, python, pyqt5, numpy }:

assert python.isPy3 or false;

stdenv.mkDerivation rec {
  name = "Uranium-${version}";
  version = "15.06.03";
  
  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "Uranium";
    rev = version;
    sha256 = "00s3k1li7x8xihvdzfba3k64x4hrq1z76j8grm1g90h5a6d1d6w3";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ python ];
  propagatedBuildInputs = [ pyqt5 numpy ];

  patches = [ ./fix_paths.patch ];

  postPatch = ''
    # For some reason substituteInPlace fails
    sed -i -e "s,@out@,$out,g" UM/Application.py
  '';

  postInstall = ''
    mkdir -p $out/${python.sitePackages}
    mv $out/lib/python?/dist-packages/* $out/${python.sitePackages}
    rm -rf $out/lib/python?
  '';

  passthru.pyqt5 = pyqt5;

  meta = with stdenv.lib; {
    description = " A Python framework for building Desktop applications";
    homepage = https://github.com/Ultimaker/Uranium;
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ abbradar ];
  };
}
