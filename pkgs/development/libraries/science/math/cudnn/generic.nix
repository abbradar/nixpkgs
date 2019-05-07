{ version
, srcName
, sha256
}:

{ stdenv
, lib
, cudatoolkit
, fetchurl
, patchelf
, libGL_driver
}:

stdenv.mkDerivation rec {
  name = "cudatoolkit-${cudatoolkit.majorVersion}-cudnn-${version}";

  inherit version;
  src = fetchurl {
    # URL from NVIDIA docker containers: https://gitlab.com/nvidia/cuda/blob/centos7/7.0/runtime/cudnn4/Dockerfile
    url = "https://developer.download.nvidia.com/compute/redist/cudnn/v${version}/${srcName}";
    inherit sha256;
  };

  nativeBuildInputs = [ patchelf ];

  installPhase = ''
    function fixRunPath {
      p=$(patchelf --print-rpath $1)
      patchelf --set-rpath "$p:${lib.makeLibraryPath [ stdenv.cc.cc ]}" $1
    }
    fixRunPath lib64/libcudnn.so

    mkdir -p $out
    cp -a include $out/include
    cp -a lib64 $out/lib64
  '';

  # Set RUNPATH so that libcuda in /run/opengl-driver(-32)/lib can be found.
  # See the explanation in libglvnd. 
  postFixup = ''
    for library in $out/lib/lib*.so; do
      origRpath=$(patchelf --print-rpath "$library")
      patchelf --set-rpath "$origRpath:${libGL_driver.driverLink}/lib" "$library"
    done
  '';

  propagatedBuildInputs = [
    cudatoolkit
  ];

  passthru = {
    inherit cudatoolkit;
    majorVersion = lib.head (lib.splitString "." version);
  };

  meta = with stdenv.lib; {
    description = "NVIDIA CUDA Deep Neural Network library (cuDNN)";
    homepage = "https://developer.nvidia.com/cudnn";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ mdaiter ];
  };
}
