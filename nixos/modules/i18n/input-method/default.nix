{ config, pkgs, pkgs_multiarch, lib, ... }:

with lib;
let
  cfg = config.i18n.inputMethod;

  gtk2_cache = system: pkgs.runCommand "gtk2-immodule.cache"
    { preferLocalBuild = true;
      allowSubstitutes = false;
      buildInputs = map (x: x.${system}) [ pkgs_multiarch.gtk2 cfg.package ];
    }
    ''
      mkdir -p $out/etc/gtk-2.0/
      GTK_PATH=${cfg.package.${system}}/lib/gtk-2.0 gtk-query-immodules-2.0 > $out/etc/gtk-2.0/immodules-${system}.cache
    '';

  gtk3_cache = system: pkgs.runCommand "gtk3-immodule.cache"
    { preferLocalBuild = true;
      allowSubstitutes = false;
      buildInputs = map (x: x.${system}) [ pkgs_multiarch.gtk3 cfg.package ];
    }
    ''
      mkdir -p $out/etc/gtk-3.0/
      GTK_PATH=${cfg.package.${system}}/lib/gtk-3.0 gtk-query-immodules-3.0 > $out/etc/gtk-3.0/immodules-${system}.cache
    '';

in
{
  options.i18n = {
    inputMethod = {
      enabled = mkOption {
        type    = types.nullOr (types.enum [ "ibus" "fcitx" "nabi" "uim" ]);
        default = null;
        example = "fcitx";
        description = ''
          Select the enabled input method. Input methods is a software to input symbols that are not available on standard input devices.

          Input methods are specially used to input Chinese, Japanese and Korean characters.

          Currently the following input methods are available in NixOS:

          <itemizedlist>
          <listitem><para>ibus: The intelligent input bus, extra input engines can be added using <literal>i18n.inputMethod.ibus.engines</literal>.</para></listitem>
          <listitem><para>fcitx: A customizable lightweight input method, extra input engines can be added using <literal>i18n.inputMethod.fcitx.engines</literal>.</para></listitem>
          <listitem><para>nabi: A Korean input method based on XIM. Nabi doesn't support Qt 5.</para></listitem>
          <listitem><para>uim: The universal input method, is a library with a XIM bridge. uim mainly support Chinese, Japanese and Korean.</para></listitem>
          </itemizedlist>
        '';
      };

      package = mkOption {
        internal = true;
        type     = types.attrsOf types.package;
        default  = null;
        description = ''
          The input method method package function.
        '';
      };
    };
  };

  config = mkIf (cfg.enabled != null) {
    environment.systemPackages = [ cfg.package.${pkgs.stdenv.system} ];
    libraries.packages = map (cache: mapAttrs (system: stdenv: cache system) pkgs_multiarch.stdenv) [ gtk2_cache gtk3_cache ];
  };

  meta = {
    maintainers = with lib.maintainers; [ ericsagnes ];
    doc = ./default.xml;
  };

}
