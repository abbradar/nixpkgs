{ stdenv, fetchurl, buildPythonApplication, pythonPackages
, python, cython, pkgconfig
, xorg, gtk, glib, pango, cairo, gdk_pixbuf, atk, pycairo
, makeWrapper, xkbcomp, xorgserver, getopt, xauth, utillinux, which, fontsConf, xkeyboard_config
, ffmpeg, x264, libvpx, libwebp
, libfakeXinerama }:

buildPythonApplication rec {
  name = "xpra-${version}";
  version = "0.16.2";

  namePrefix = "";
  src = fetchurl {
    url = "http://xpra.org/src/${name}.tar.xz";
    sha256 = "0h55rv46byzv2g8g77bm0a0py8jpz3gbr5fhr5jy9sisyr0vk6ff";
  };

  buildInputs = [
    cython pkgconfig

    xorg.libX11 xorg.renderproto xorg.libXrender xorg.libXi xorg.inputproto xorg.kbproto
    xorg.randrproto xorg.damageproto xorg.compositeproto xorg.xextproto xorg.recordproto
    xorg.xproto xorg.fixesproto xorg.libXtst xorg.libXfixes xorg.libXcomposite xorg.libXdamage
    xorg.libXrandr xorg.libxkbfile

    pango cairo gdk_pixbuf atk gtk glib

    ffmpeg libvpx x264 libwebp
  ];

  pythonPath = with pythonPackages; [
    pillow pygtk pygobject rencode
  ];

  postPatch = ''
    sed -i 's,"install","bdist_wheel",g' setup.py
    sed -i "s,/etc/xpra/xorg.conf,$out/etc/xpra/xorg.conf,g" xpra/scripts/config.py
  '';

  setupPyBuildFlags = [ "--with-Xdummy" "--without-strict" ];

  makeWrapperArgs = ''
    --set XKB_BINDIR "${xkbcomp}/bin" \
    --set FONTCONFIG_FILE "${fontsConf}" \
    --prefix LD_LIBRARY_PATH : ${libfakeXinerama}/lib \
    --prefix PATH : ${stdenv.lib.makeBinPath [ getopt xorgserver xauth which utillinux ]}
  '';

  postInstall = ''
    cp -r $out/${python.sitePackages}/${python}/* $out
    rm -rf $out/${python.sitePackages}/$(echo "${python}" | cut -d "/" -f2)
    sed -i "s,build/[^ ]*,$out/etc/xpra/xorg.conf,g" $out/etc/xpra/xpra.conf
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://xpra.org/;
    description = "Persistent remote applications for X";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with aintainers; [ tstrobel ];
  };
}
