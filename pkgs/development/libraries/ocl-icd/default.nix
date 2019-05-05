{stdenv, fetchurl, ruby, opencl-headers, libGL_driver, patchelf }:

stdenv.mkDerivation rec {
  name = "ocl-icd-${version}";
  version = "2.2.10";

  src = fetchurl {
    url = "https://forge.imag.fr/frs/download.php/810/${name}.tar.gz";
    sha256 = "0f14gpa13sdm0kzqv5yycp4pschbmi6n5fj7wl4ilspzsrqcgqr2";
  };

  nativeBuildInputs = [ ruby patchelf ];

  buildInputs = [ opencl-headers ];

  postPatch = ''
    sed -i 's,"/etc/OpenCL/vendors","${libGL_driver.driverLink}/etc/OpenCL/vendors",g' ocl_icd_loader.c
  '';

  # Set RUNPATH so that driver libraries in /run/opengl-driver(-32)/lib can be found.
  # See the explanation in libglvnd.
  postFixup = ''
    for library in $out/lib/libOpenCL.so; do
      origRpath=$(patchelf --print-rpath "$library")
      patchelf --set-rpath "$origRpath:${libGL_driver.driverLink}/lib" "$library"
    done
  '';

  meta = with stdenv.lib; {
    description = "OpenCL ICD Loader for ${opencl-headers.name}";
    homepage    = https://forge.imag.fr/projects/ocl-icd/;
    license     = licenses.bsd2;
    platforms = platforms.linux;
  };
}
