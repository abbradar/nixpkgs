{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.i18n.inputMethod.fcitx;
  fcitxPackage = pkgs: pkgs.fcitx.override { plugins = cfg.engines pkgs; };
  fcitxEngines = types.function types.attrs (types.listOf types.package) // {
    name  = "fcitxEngines";
    check = x: isFunction x && (all (attrByPath ["meta" "isFcitxEngine"] false) (x pkgs));
  };
in
{
  options = {

    i18n.inputMethod.fcitx = {
      engines = mkOption {
        type    = fcitxEngines;
        default = [];
        example = literalExample "pkgs: with pkgs.fcitx-engines; [ mozc hangul ]";
        description =
          let
            enginesDrv = filterAttrs (const isDerivation) pkgs.fcitx-engines;
            engines = concatStringsSep ", "
              (map (name: "<literal>${name}</literal>") (attrNames enginesDrv));
          in
            "Enabled Fcitx engines. Available engines are: ${engines}.";
      };
    };

  };

  config = mkIf (config.i18n.inputMethod.enabled == "fcitx") {
    i18n.inputMethod.package = fcitxPackage;

    environment.variables = {
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE  = "fcitx";
      XMODIFIERS    = "@im=fcitx";
    };
    services.xserver.displayManager.sessionCommands = "${fcitxPackage pkgs}/bin/fcitx";
  };
}
