{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  inInitrd = config.boot.initrd.supportedFilesystems.ntfs or config.boot.initrd.supportedFilesystems.ntfs-3g or false;
in
{
  config =
    mkIf (config.boot.supportedFilesystems.ntfs or config.boot.supportedFilesystems.ntfs-3g or false)
      {

        system.fsPackages = [ pkgs.ntfs3g ];

        boot.initrd.availableKernelModules = mkIf inInitrd [
          "ntfs3"
        ];

      };
}
