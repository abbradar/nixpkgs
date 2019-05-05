{ stdenv, fetchFromGitHub, cmake, python3, vulkan-headers, pkgconfig
, xlibsWrapper, libxcb, libXrandr, libXext, wayland, libGL_driver, patchelf }:

let
  version = "1.1.106";
in

assert version == vulkan-headers.version;
stdenv.mkDerivation rec {
  name = "vulkan-loader-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Loader";
    rev = "sdk-${version}";
    sha256 = "0zhrwj1gi90x2w8gaaaw5h4b969a8gfy244kn0drrplhhb1nqz3b";
  };

  nativeBuildInputs = [ pkgconfig patchelf ];
  buildInputs = [ cmake python3 xlibsWrapper libxcb libXrandr libXext wayland ];
  enableParallelBuilding = true;

  cmakeFlags = [
    "-DFALLBACK_DATA_DIRS=${libGL_driver.driverLink}/share:/usr/local/share:/usr/share"
    "-DVULKAN_HEADERS_INSTALL_DIR=${vulkan-headers}"
  ];

  outputs = [ "out" "dev" ];

  # Set RUNPATH so that driver libraries in /run/opengl-driver(-32)/lib can be found.
  # See the explanation in libglvnd.
  postFixup = ''
    for library in $out/lib/libvulkan.so; do
      origRpath=$(patchelf --print-rpath "$library")
      patchelf --set-rpath "$origRpath:${libGL_driver.driverLink}/lib" "$library"
    done
  '';

  meta = with stdenv.lib; {
    description = "LunarG Vulkan loader";
    homepage    = https://www.lunarg.com;
    platforms   = platforms.linux;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
