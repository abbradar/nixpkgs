/* This file defines the builds that constitute the Nixpkgs.
   Everything defined here ends up in the Nixpkgs channel.  Individual
   jobs can be tested by running:

   $ nix-build pkgs/top-level/release.nix -A <jobname>.<system>

   e.g.

   $ nix-build pkgs/top-level/release.nix -A coreutils.x86_64-linux
*/

{ nixpkgs ? { outPath = (import ./all-packages.nix {}).lib.cleanSource ../..; revCount = 1234; shortRev = "abcdef"; }
, officialRelease ? false
, # The platforms for which we build Nixpkgs.
  supportedSystems ? [ "x86_64-linux" "i686-linux" /* "x86_64-darwin" */ ]
}:

with import ./release-lib.nix {
  inherit supportedSystems;
  packageSet = args: import <nixpkgs> (args // {
    config.allowUnfree = true;
  });
};

mapTestOn {
  rPackages = packagesWithMetaPlatform pkgs.rPackages;
}
