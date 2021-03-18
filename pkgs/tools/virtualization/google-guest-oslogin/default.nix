{ stdenv, lib, fetchFromGitHub, pam, curl, json_c, bashInteractive }:

stdenv.mkDerivation rec {
  pname = "google-guest-oslogin";
  version = "20210316.00";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "guest-oslogin";
    rev = version;
    sha256 = "08a8y3xq7gbxj5c457yn50431zzd8kixbf6kzyb9174ym5nh0fqz";
  };

  buildInputs = [ pam curl json_c ];

  VERSION = version;

  NIX_CFLAGS_COMPILE = [ "-I" "${json_c.dev}/include/json-c" ];

  postPatch = ''
    # change sudoers dir from /var/google-sudoers.d to /run/google-sudoers.d (managed through systemd-tmpfiles)
    substituteInPlace src/pam/pam_oslogin_admin.cc --replace /var/google-sudoers.d /run/google-sudoers.d
    # fix "User foo not allowed because shell /bin/bash does not exist"
    substituteInPlace src/include/compat.h --replace /bin/bash /run/current-system/sw/bin/bash
  '';

  installFlags = [
    "PREFIX=$(out)"
    "MANDIR=$(out)/share/man"
    "SYSTEMDDIR=$(out)/etc/systemd/system"
    "PRESETDIR=$(out)/etc/systemd/system-preset"
  ];

  postInstall = ''
    sed -i "s,/usr/bin/,$out/bin/,g" $out/etc/systemd/system/google-oslogin-cache.service
  '';

  meta = with lib; {
    homepage = "https://github.com/GoogleCloudPlatform/compute-image-packages";
    description = "OS Login Guest Environment for Google Compute Engine";
    license = licenses.asl20;
    maintainers = with maintainers; [ flokli ];
  };
}
