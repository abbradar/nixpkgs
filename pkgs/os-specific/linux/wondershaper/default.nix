{ lib, stdenv, fetchFromGitHub, iproute, kmod, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "wondershaper";
  version = "1.4.1";

  nativeBuildInputs = [ makeWrapper ];
  binPath = lib.makeBinPath [ iproute kmod ];

  src = fetchFromGitHub {
    owner = "magnific0";
    repo = pname;
    rev = "d6ae10524ce38d815772e4e1204dbecf08271646"; # Update ChangeLog.
    sha256 = "136jwlvz5l3wkp23hxg2s7p2dfq2gn2nx4z7niddxkap06bwky5i";
  };

  installPhase = ''
    install -Dm755 wondershaper $out/bin/wondershaper
    wrapProgram $out/bin/wondershaper \
      --prefix PATH ":" $binPath
  '';

  meta = with stdenv.lib; {
    description = "Command-line utility for limiting an adapter's bandwidth";
    homepage = "https://github.com/magnific0/wondershaper";
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
  };
}
