# This module defines the packages that appear in
# /run/current-system/sw.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.libraries;

  pathsToLink = [ "/lib" "/share" "/etc" ];
  mkLibPath = pkgs: pkgs.buildEnv {
    name = "libraries";
    paths = cfg.unsafePackages pkgs;
    inherit pathsToLink;
    ignoreCollisions = true;
  };
  mkSanitized = pkgs: pkgs.buildEnv {
    name = "sanitized-libraries";
    paths = cfg.packages pkgs;
    inherit pathsToLink;
    ignoreCollisions = true;
    postBuild = ''
      for i in $out/lib/*; do
        if [ -f "$(readlink -f "$i")" ]; then
          rm "$i"
        fi
      done
    '';
  };

  libPath = mkLibPath pkgs;
  libPath32 = mkLibPath pkgs.pkgsi686Linux;

  # We use more "stable" absolute paths in systemd environment and symlinks for users.
  mkEnv = path: path32: mapAttrs (name: concatMap (suffix: [ "${path}/${suffix}" ] ++ optional cfg.support32Bit "${path32}/${suffix}")) cfg.environment;

in

{
  options = {

    libraries = {

      packages = mkOption {
        type = types.function types.attrs (types.listOf types.package);
        default = pkgs: [];
        example = literalExample "pkgs: [ pkgs.mesa ]";
        description = ''
          The set of packages that appear in
          <filename>/run/current-system/''${system}-lib</filename>
          for each supported architecture. They are supposed
          to be arch-dependent library plugins, like DRI drivers,
          input methods etc.

	  <note><para>Packages placed here are stripped of files in
          <filename>/lib</filename> to avoid library path contamination.</para></note>
        '';
      };

      unsafePackages = mkOption {
        type = types.function types.attrs (types.listOf types.package);
        default = pkgs: [];
        internal = true;
        description = ''
          Packages which get into <literal>LD_LIBRARY_PATH</literal>.
        '';
      };

      environment = mkOption {
        type = types.attrsOf (types.listOf types.str);
        default = {};
        example = { "LD_LIBRARY_PATH" = [ "lib" ]; };
        description = ''
          Relative environment variables that need to be pointed to the libraries.
	  Each entry has path to libraries prepended for each architecture and
          concatenated with a colon.
        '';
      };

      support32Bit = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to support 32-bit binaries on a 64-bit system.
        '';
      };

    };

  };

  config = {

    assertions = lib.singleton {
      assertion = cfg.support32Bit -> pkgs.stdenv.isx86_64;
      message = "Option support32Bit only makes sense on a 64-bit system.";
    };

    systemd.globalEnvironment = mkEnv libPath libPath32;
    environment.sessionVariables = mkEnv "/run/current-system/${pkgs.stdenv.system}-lib" "/run/current-system/${pkgs.pkgsi686Linux.stdenv.system}-lib";

    libraries.environment."LD_LIBRARY_PATH" = [ "lib" ]; # FIXME: remove when libglvnd allows us to have fully dynamic OpenGL dispatch.
    libraries.unsafePackages = pkgs: [ (mkSanitized pkgs) ];

    system.extraSystemBuilderCmds = ''
      ln -s ${mkLibPath pkgs} $out/${pkgs.stdenv.system}-lib
      ${optionalString cfg.support32Bit ''
        ln -s ${mkLibPath pkgs.pkgsi686Linux} $out/${pkgs.pkgsi686Linux.stdenv.system}-lib
      ''}
    '';

  };
}
