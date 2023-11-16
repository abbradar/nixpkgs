{ stdenv, lib, fetchgit, fetchFromGitHub
, gn, ninja, python3, glib, pkg-config, icu
, xcbuild, darwin
, fetchpatch
, llvmPackages
, symlinkJoin
}:

# Use update.sh to update all checksums.

let
  version = "11.9.169.6";
  v8Src = fetchgit {
    url = "https://chromium.googlesource.com/v8/v8";
    rev = version;
    sha256 = "1128h8996rr2i20w9kbf3l1nf8iw1j5wwlmad5jwij4b5y989lw7";
  };

  git_url = "https://chromium.googlesource.com";

  # This data is from the DEPS file in the root of a V8 checkout.
  deps = {
    "base/trace_event/common" = fetchgit {
      url    = "${git_url}/chromium/src/base/trace_event/common.git";
      rev    = "29ac73db520575590c3aceb0a6f1f58dda8934f6";
      sha256 = "1c25i8gyz3z36gp192g3cshaj6rd6yxi6m7j8mhw7spaarprzq12";
    };
    "build" = fetchgit {
      url    = "${git_url}/chromium/src/build.git";
      rev    = "b3ac98b5aa5333fa8b1059b5bf19885923dfe050";
      sha256 = "1mlmk9pq36iw1q1nif773ismvdgyc9ppy1wzdmz1wqanx9v7za70";
    };
    "third_party/googletest/src" = fetchgit {
      url    = "${git_url}/external/github.com/google/googletest.git";
      rev    = "af29db7ec28d6df1c7f0f745186884091e602e07";
      sha256 = "0f7g4v435xh830npqnczl851fac19hhmzqmvda2qs3fxrmq6712m";
    };
    "third_party/icu" = fetchgit {
      url    = "${git_url}/chromium/deps/icu.git";
      rev    = "985b9a6f70e13f3db741fed121e4dcc3046ad494";
      sha256 = "13rzzajqc4q1w4v9w7jx8bsmcbklngv7sa2lk2vcf22lvigkpnp9";
    };
    "third_party/zlib" = fetchgit {
      url    = "${git_url}/chromium/src/third_party/zlib.git";
      rev    = "3f0af7f1d5ca6bb9d247f40b861346627c3032a1";
      sha256 = "0m4spq3670mkjsm9yl3ysz63zd1gqjd2dyzxd3l35nb03y1pr2jk";
    };
    "third_party/jinja2" = fetchgit {
      url    = "${git_url}/chromium/src/third_party/jinja2.git";
      rev    = "515dd10de9bf63040045902a4a310d2ba25213a0";
      sha256 = "0gh8xpnbl9lq82ggxpv0q7a67pvcdmcrl7r8z3hk9awdjq4dbvvy";
    };
    "third_party/markupsafe" = fetchgit {
      url    = "${git_url}/chromium/src/third_party/markupsafe.git";
      rev    = "006709ba3ed87660a17bd4548c45663628f5ed85";
      sha256 = "1ql3sdwjwc0b19hbz4v55m81sf3capl9xc5ya9nq1l7kclj72m06";
    };
  };

  # See `gn_version` in DEPS.
  gnSrc = fetchgit {
    url = "https://gn.googlesource.com/gn";
    rev = "991530ce394efb58fcd848195469022fa17ae126";
    sha256 = "1zpbaspb2mncbsabps8n1iwzc67nhr79ndc9dnqxx1w1qfvaldg2";
  };

  myGn = gn.overrideAttrs (oldAttrs: {
    version = "for-v8";
    src = gnSrc;
  });

in

stdenv.mkDerivation rec {
  pname = "v8";
  inherit version;

  doCheck = true;

  patches = [
    ./darwin.patch
  ];

  src = v8Src;

  postUnpack = ''
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (n: v: ''
        mkdir -p $sourceRoot/${n}
        cp -r ${v}/* $sourceRoot/${n}
      '') deps)}
    chmod u+w -R .
  '';

  postPatch = ''
    ${lib.optionalString stdenv.isAarch64 ''
      substituteInPlace build/toolchain/linux/BUILD.gn \
        --replace 'toolprefix = "aarch64-linux-gnu-"' 'toolprefix = ""'
    ''}
    ${lib.optionalString stdenv.isDarwin ''
      substituteInPlace build/config/compiler/compiler.gni \
        --replace 'strip_absolute_paths_from_debug_symbols = true' \
                  'strip_absolute_paths_from_debug_symbols = false'
      substituteInPlace build/config/compiler/BUILD.gn \
        --replace 'current_toolchain == host_toolchain || !use_xcode_clang' \
                  'false'
    ''}
    ${lib.optionalString (stdenv.isDarwin && stdenv.isx86_64) ''
      substituteInPlace build/config/compiler/BUILD.gn \
        --replace "-Wl,-fatal_warnings" ""
    ''}
    touch build/config/gclient_args.gni
    sed '1i#include <utility>' -i src/heap/cppgc/prefinalizer-handler.h # gcc12
  '';

  llvmCcAndBintools = symlinkJoin { name = "llvmCcAndBintools"; paths = [ stdenv.cc llvmPackages.llvm ]; };

  gnFlags = [
    "use_custom_libcxx=false"
    "is_clang=${lib.boolToString stdenv.cc.isClang}"
    "use_sysroot=false"
    # "use_system_icu=true"
    "clang_use_chrome_plugins=false"
    "is_component_build=false"
    "v8_use_external_startup_data=false"
    "v8_monolithic=true"
    "is_debug=true"
    "is_official_build=false"
    "treat_warnings_as_errors=false"
    "v8_enable_i18n_support=true"
    "use_gold=false"
    # ''custom_toolchain="//build/toolchain/linux/unbundle:default"''
    ''host_toolchain="//build/toolchain/linux/unbundle:default"''
    ''v8_snapshot_toolchain="//build/toolchain/linux/unbundle:default"''
  ] ++ lib.optional stdenv.cc.isClang ''clang_base_path="${llvmCcAndBintools}"''
  ++ lib.optional stdenv.isDarwin ''use_lld=false'';

  env.NIX_CFLAGS_COMPILE = "-O2";
  FORCE_MAC_SDK_MIN = stdenv.targetPlatform.sdkVer or "10.12";

  nativeBuildInputs = [
    myGn
    ninja
    pkg-config
    python3
  ] ++ lib.optionals stdenv.isDarwin [
    xcbuild
    llvmPackages.llvm
    python3.pkgs.setuptools
  ];
  buildInputs = [ glib icu ];

  ninjaFlags = [ ":d8" "v8_monolith" ];

  enableParallelBuilding = true;

  installPhase = ''
    install -D d8 $out/bin/d8
    install -D -m644 obj/libv8_monolith.a $out/lib/libv8.a
    install -D -m644 icudtl.dat $out/share/v8/icudtl.dat
    ln -s libv8.a $out/lib/libv8_monolith.a
    cp -r ../../include $out

    mkdir -p $out/lib/pkgconfig
    cat > $out/lib/pkgconfig/v8.pc << EOF
    Name: v8
    Description: V8 JavaScript Engine
    Version: ${version}
    Libs: -L$out/lib -lv8 -pthread
    Cflags: -I$out/include
    EOF
  '';

  meta = with lib; {
    homepage = "https://v8.dev/";
    description = "Google's open source JavaScript engine";
    maintainers = with maintainers; [ proglodyte matthewbauer ];
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
}
