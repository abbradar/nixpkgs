{ stdenv, lib, fetchFromGitHub, fetchpatch, autoreconfHook, python2, pkgconfig, libX11, libXext, xorgproto, patchelf }:

let
  driverLink = "/run/opengl-driver" + lib.optionalString stdenv.isi686 "-32";
in stdenv.mkDerivation rec {
  name = "libglvnd-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "libglvnd";
    rev = "v${version}";
    sha256 = "1a126lzhd2f04zr3rvdl6814lfl0j077spi5dsf2alghgykn5iif";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig python2 patchelf ];
  buildInputs = [ libX11 libXext xorgproto ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/GLX/Makefile.am \
      --replace "-Wl,-Bsymbolic " ""
    substituteInPlace src/EGL/Makefile.am \
      --replace "-Wl,-Bsymbolic " ""
  '';

  NIX_CFLAGS_COMPILE = [
    "-UDEFAULT_EGL_VENDOR_CONFIG_DIRS"
    # FHS paths are added so that non-NixOS applications can find vendor files.
    "-DDEFAULT_EGL_VENDOR_CONFIG_DIRS=\"${driverLink}/share/glvnd/egl_vendor.d:/etc/glvnd/egl_vendor.d:/usr/share/glvnd/egl_vendor.d\""
  ] ++ lib.optional stdenv.cc.isClang "-Wno-error";

  # Indirectly: https://bugs.freedesktop.org/show_bug.cgi?id=35268
  configureFlags  = stdenv.lib.optional stdenv.hostPlatform.isMusl "--disable-tls";

  # Upstream patch fixing use of libdl, should be in next release.
  patches = [
    (fetchpatch {
      url = "https://github.com/NVIDIA/libglvnd/commit/0177ade40262e31a80608a8e8e52d3da7163dccf.patch";
      sha256 = "1rnz5jw2gvx4i1lcp0k85jz9xgr3dgzsd583m2dlxkaf2a09j89d";
    })
  ] ++ stdenv.lib.optional stdenv.isDarwin
    (fetchpatch {
      url = "https://github.com/NVIDIA/libglvnd/commit/294ccb2f49107432567e116e13efac586580a4cc.patch";
      sha256 = "01339wg27cypv93221rhk3885vxbsg8kvbfyia77jmjdcnwrdwm2";
    });
  outputs = [ "out" "dev" ];

  # Set RUNPATH so that driver libraries in /run/opengl-driver(-32)/lib can be found.
  # This is needed to not rely on LD_LIBRARY_PATH which does not work with setuid
  # executables. Fixes https://github.com/NixOS/nixpkgs/issues/22760. It must be
  # in postFixup because RUNPATH stripping in fixup would undo it. Note that patchelf
  # actually sets RUNPATH not RPATH, which applies only to dependencies of the binary
  # it set on (including for dlopen), so the RUNPATH must indeed be set on these
  # libraries and would not work if set only on executables.
  postFixup = ''
    for library in $out/lib/libGLX.so $out/lib/libEGL.so; do
      origRpath=$(patchelf --print-rpath "$library")
      patchelf --set-rpath "$origRpath:${driverLink}/lib" "$library"
    done
  '';

  passthru = { inherit driverLink; };

  meta = with stdenv.lib; {
    description = "The GL Vendor-Neutral Dispatch library";
    homepage = https://github.com/NVIDIA/libglvnd;
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
