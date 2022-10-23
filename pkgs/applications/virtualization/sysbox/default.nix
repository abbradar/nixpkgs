{ stdenv, lib
, fetchurl, runCommand, gitMinimal, cacert
, go, protobuf, go-protobuf, autoconf, automake, libtool, pkg-config
, bash, coreutils, iptables, utillinux
, libseccomp
}:

let
  version = "0.6.6";

  src = runCommand "sysbox-src-${version}" {
    nativeBuildInputs = [
      gitMinimal go cacert
      # For temporary build of protobufs.
      protobuf go-protobuf
    ];

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-IXK/lfmiMu/zksyWJVwV5hlRUH/l6f9tOXt37z6Y+qw=";
  } ''
    # Fetch the repository.
    git clone --depth 1 -b "v${version}" https://github.com/nestybox/sysbox
    cd sysbox

    syncWithSubmodules() {
      if sed -i 's,git@github.com:,https://github.com/,g' .gitmodules 2>/dev/null; then
        git submodule update --init --depth 1
        git submodule foreach syncWithSubmodules
      fi
      rm -rf .git
    }
    export -f syncWithSubmodules
    syncWithSubmodules
    cp -r . "$out"

    # Fetch vendored Go modules.
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH="$TMPDIR/go"

    for pkg in sysbox-ipc sysbox-runc sysbox-fs sysbox-mgr; do
      echo "Vendoring $pkg"
      cd "$pkg"
      go mod download
      cd - >/dev/null
    done

    rm -rf "$GOPATH/pkg/mod/cache/download/sumdb"
    cp -r "$GOPATH/pkg/mod/cache/download" "$out/go-download"
  '';

in stdenv.mkDerivation {
  pname = "sysbox";
  inherit version src;

  data = fetchurl {
    url = "https://downloads.nestybox.com/sysbox/releases/v${version}/sysbox-ce_${version}-0.linux_amd64.deb";
    sha256 = "sha256-h8+lytl9xdwaJD1tiL4Tk751uTpRfcFYDs2KKAHCd3o=";
  };

  nativeBuildInputs = [ go protobuf go-protobuf autoconf automake libtool pkg-config ];
  buildInputs = [ libseccomp ];

  enableParallelBuilding = true;

  buildFlags = [ "sysbox-local" ];
  installFlags = [ "DESTDIR=$(out)/bin" ];

  GOSUMDB = "off";
  inherit (go) GOOS GOARCH;

  postUnpack = ''
    ar x $data
    mkdir data
    tar -xaf data.tar.xz -C data
  '';

  postPatch = ''
    cd sysbox-runc
    patch -p1 < ${./nixos-utils.patch}
    substituteInPlace libcontainer/rootfs_init_linux.go \
      --subst-var-by iptables ${iptables} \
      --subst-var-by utillinux ${utillinux}
    cd -
  '';

  preBuild = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH="$TMPDIR/go"
    export GOPROXY=file://$src/go-download
  '';

  postInstall = ''
    mkdir -p "$out/lib/systemd/system"
    for svc in "$NIX_BUILD_TOP/data/lib/systemd/system/"*; do
      substitute "$svc" "$out/lib/systemd/system/$(basename "$svc")" \
        --replace "/bin/sh" "${bash}/bin/sh" \
        --replace "/bin/sleep" "${coreutils}/bin/sleep" \
        --replace "/usr/bin/sysbox-" "$out/bin/sysbox-"
    done
  '';
}
