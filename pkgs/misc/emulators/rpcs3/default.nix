{ stdenv, lib, fetchgit, cmake, pkgconfig, git                                                                      
, qt5, openal, glew, vulkan-loader, libpng, ffmpeg, libevdev, python27                                              
, pulseaudioSupport ? true, libpulseaudio                                                                           
, waylandSupport ? true, wayland                                                                                    
, alsaSupport ? true, alsaLib                                                                                       
}:                                                                                                                  
                                                                                                                    
let                                                                                                                 
  majorVersion = "0.0.5";                                                                                           
  gitVersion = "7439-4ab777b42";
in                                                                                                                  
stdenv.mkDerivation rec {                                                                                           
  name = "rpcs3-${version}";                                                                                        
  version = "${majorVersion}-${gitVersion}";                                                                        
                                                                                                                    
  src = fetchgit {                                                                                                  
    url = "https://github.com/RPCS3/rpcs3";                                                                         
    rev = "4ab777b429b3a659be33e8a21b6a446c1cad2780";
    sha256 = "1dcrhflc3g77kjkhdn944h2lnwfjbw21dvq2klfaazbw9h9kb0ci";
  };                                                                                                                
                                                                                                                    
  preConfigure = ''                                                                                                 
    cat > ./rpcs3/git-version.h <<EOF                                                                               
    #define RPCS3_GIT_VERSION "${gitVersion}"                                                                       
    #define RPCS3_GIT_BRANCH "HEAD"                                                                                 
    #define RPCS3_GIT_VERSION_NO_UPDATE 1                                                                           
    EOF
  '';

  cmakeFlags = [
    "-DUSE_SYSTEM_LIBPNG=ON"
    "-DUSE_SYSTEM_FFMPEG=ON"
    "-DUSE_NATIVE_INSTRUCTIONS=OFF"
  ];

  nativeBuildInputs = [ cmake pkgconfig git ];

  buildInputs = [
    qt5.qtbase qt5.qtquickcontrols openal glew vulkan-loader libpng ffmpeg libevdev python27
  ] ++ lib.optional pulseaudioSupport libpulseaudio
    ++ lib.optional alsaSupport alsaLib
    ++ lib.optional waylandSupport wayland;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "PS3 emulator/debugger";
    homepage = "https://rpcs3.net/";
    maintainers = with maintainers; [ abbradar nocent ];
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" ];
  };
}
