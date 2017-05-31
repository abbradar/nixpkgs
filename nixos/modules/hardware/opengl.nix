{ config, lib, pkgs, pkgs_i686, ... }:

with lib;

let

  cfg = config.hardware.opengl;

  kernelPackages = config.boot.kernelPackages;

  videoDrivers = config.services.xserver.videoDrivers;

  makePackage = p: p.buildEnv {
    name = "mesa-drivers+txc-${p.mesa_drivers.version}";
    paths = [
      p.mesa_drivers
      p.mesa_drivers.out # mainly for libGL
      (if cfg.s3tcSupport then p.libtxc_dxtn else p.libtxc_dxtn_s2tc)
    ];
  };

in

{
  options = {
    hardware.opengl.enable = mkOption {
      description = "Whether this configuration requires OpenGL.";
      type = types.bool;
      default = false;
      internal = true;
    };

    hardware.opengl.s3tcSupport = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Make S3TC(S3 Texture Compression) via libtxc_dxtn available
        to OpenGL drivers instead of the patent-free S2TC replacement.

        Using this library may require a patent license depending on your location.
      '';
    };

    hardware.opengl.package = mkOption {
      type = types.function types.attrs types.package;
      internal = true;
      description = ''
        The package function that provides the OpenGL implementation.
      '';
    };

  };

  config = mkIf cfg.enable {

    hardware.opengl.package = mkDefault makePackage;

    boot.extraModulePackages = optional (elem "virtualbox" videoDrivers) kernelPackages.virtualboxGuestAdditions;

    libraries.unsafePackages = pkgs: [ (cfg.package pkgs) ];

    # Backwards compatibility.
    system.activationScripts.setup-opengl =
      ''
        if [ -L /run/opengl-driver ]; then
          ln -sfn /run/current-system/${pkgs.stdenv.system}-lib /run/opengl-driver
        fi
        if [ -L /run/opengl-driver-32 ]; then
          ln -sfn /run/current-system/${pkgs.pkgsi686Linux.stdenv.system}-lib /run/opengl-driver-32
        fi
      '';

  };
}
