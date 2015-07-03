{ buildRubyGem, coreutils, fetchgit }:

buildRubyGem {
  name = "bundler-2015-07-03";
  src = fetchgit {
    url = "https://github.com/bundler/bundler.git";
    rev = "fafd671635036cb74c4bb28e3c1d25ce63a9d400";
    sha256 = "664edaa9ec3e824f20031298693f6c3dd609cdf68ca8c8ac5996acd4388e0bee";
    leaveDotGit = true;
  };
  dontPatchShebangs = true;
  postInstall = ''
    find $out -type f -perm +0100 | while read f; do
      substituteInPlace $f \
         --replace "/usr/bin/env" "${coreutils}/bin/env"
    done
  '';
}
