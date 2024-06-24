{ lib
, buildGo121Module
, fetchFromGitHub
, stdenv
}:

# JuiceFS 1.1.2 doesn't build with Go 1.22. Fixed in upstream. This can be
# reverted in future releases. https://github.com/juicedata/juicefs/issues/4339
buildGo121Module rec {
  pname = "juicefs";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "juicedata";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qPdrcWCD8BYwRwnynNhcti7eUskgHP1kAS6KiS0LHsc=";
  };

  vendorHash = "sha256-tKbn/dFnYTc0fYwYUrrpdN1hzx047yQSFdTG94CifhM=";

  ldflags = [ "-s" "-w" ];

  doCheck = false; # requires network access

  # we dont need the libjfs binary
  postFixup = ''
    rm $out/bin/libjfs
  '';

  postInstall = ''
    ln -s $out/bin/juicefs $out/bin/mount.juicefs
  '';

  meta = with lib; {
    description = "Distributed POSIX file system built on top of Redis and S3";
    homepage = "https://www.juicefs.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
    broken = stdenv.isDarwin;
  };
}
