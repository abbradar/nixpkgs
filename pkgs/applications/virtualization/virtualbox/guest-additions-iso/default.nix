{
  fetchurl,
  lib,
  virtualboxVersion,
}:
fetchurl {
  url = "http://download.virtualbox.org/virtualbox/${virtualboxVersion}/VBoxGuestAdditions_${virtualboxVersion}.iso";
  sha256 = "sha256-0DIX/LNh+oY0gH6eipnoGN21N/6LnEE+wm8VCfGgSKM=";
  meta = {
    description = "Guest additions ISO for VirtualBox";
    longDescription = ''
      ISO containing various add-ons which improves guests inside VirtualBox.
    '';
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.gpl2;
    maintainers = [
      lib.maintainers.sander
      lib.maintainers.friedrichaltheide
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
