{ stdenv, lib, fetchFromGitHub, ipcalc, iproute2, utillinux }:

let
  dhclientDeps = [ ipcalc iproute2 ];

in stdenv.mkDerivation rec {
  pname = "google-guest-configs";
  version = "20210317.00";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "guest-configs";
    rev = version;
    sha256 = "sha256-UpZPYHuSzLL8dwhwla0QW1W/Fq3e0XNn8HEhJH0BGew=";
  };

  installPhase = ''
    mkdir -p $out/{bin,etc,lib}
    cp -r src/etc/{modprobe.d,sysctl.d} $out/etc
    cp -r src/lib/udev $out/lib
    cp -r src/sbin/* $out/bin
    cp -r src/usr/bin/* $out/bin

    for i in $out/lib/udev/rules.d/*.rules; do
      sed -i \
        -e "s,\"google_nvme_id,\"$out/lib/udev/google_nvme_id,g" \
        -e "s,/bin/sh,${stdenv.shell},g" \
        -e "s,/bin/umount,${utillinux}/bin/umount,g" \
        -e "s,/usr/bin/logger,${utillinux}/bin/logger,g" \
        "$i"
    done
    sed -i \
      -e 's,^PATH=.*,PATH=${lib.makeBinPath dhclientDeps},' \
      -e 's,/bin/ipcalc,ipcalc,' \
      $out/bin/google-dhclient-script
  '';

  meta = with lib; {
    homepage = "https://github.com/GoogleCloudPlatform/compute-image-packages";
    description = "OS Login Guest Environment for Google Compute Engine";
    license = licenses.asl20;
    maintainers = with maintainers; [ flokli ];
  };
}
