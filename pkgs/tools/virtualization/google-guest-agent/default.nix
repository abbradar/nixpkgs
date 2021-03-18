{ buildGoModule, fetchFromGitHub, lib, coreutils }:

buildGoModule rec {
  pname = "guest-agent";
  version = "20210223.01";
  owner = "GoogleCloudPlatform";
  rev = version;

  src = fetchFromGitHub {
    inherit owner rev;
    repo = pname;
    sha256 = "sha256-cXHptxxOLpMm/NYg/gTajbX/dfyvK5/FcJj06mawPZ8=";
  };

  vendorSha256 = "sha256-YcWKSiN715Z9lmNAQx+sHEgxWnhFhenCNXBS7gdMV4M=";

  # Skip tests which require networking.
  preCheck = ''
    rm google_guest_agent/wsfc_test.go
  ''; 

  postInstall = ''
    mkdir -p $out/etc/systemd/system
    for i in *.service; do
      sed \
        -e "s,/usr/bin/,$out/bin/,g" \
        -e "s,/bin/true,${coreutils}/bin/true,g" \
        "$i" > "$out/etc/systemd/system/$i"
    done
    install -Dm644 instance_configs.cfg $out/etc/default/instance_configs.cfg
  '';

  meta = with lib; {
    description = "Commandline app to create and edit releases on Github (and upload artifacts)";
    longDescription = ''
      A small commandline app written in Go that allows you to easily create and
      delete releases of your projects on Github.
      In addition it allows you to attach files to those releases.
    '';

    license = licenses.mit;
    homepage = "https://github.com/github-release/github-release";
    maintainers = with maintainers; [ ardumont j03 ];
    platforms = with platforms; unix;
  };
}
