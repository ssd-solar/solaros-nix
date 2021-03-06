{ config, lib, pkgs, ... } @ args:

with (import ../lib args);

mkFeatureFlag { name = "bluetooth"; desc = "Bluetooth support"; enabled = true; } {
  hardware.bluetooth = {
    enable = true;
  };

  services.blueman = {
    enable = true;
  };
}
