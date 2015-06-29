{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "filter_audio-20150628";

  src = fetchFromGitHub {
    owner  = "irungentoo";
    repo   = "filter_audio";
    rev    = "612c5a102550c614e4c8f859e753ea64c0b7250c";
    sha256 = "ca160b2ef6a55e7f075fb308d3f4622423d34bc39c6e6a86376b936c7b43ae2e";
  };

  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "An easy to use audio filtering library made from webrtc code";
    homepage    = https://github.com/irungentoo/filter_audio;
    license     = licenses.bsd3;
    maintainers = with maintainers; [ np ];
    platforms   = platforms.unix;
  };
}
