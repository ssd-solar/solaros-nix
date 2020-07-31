{ config, lib, pkgs, ... }:

with lib;
# with (import ./util.nix lib);

{
  config = {
    boot.plymouth = {
      enable = true;
    };

    boot.kernelPackages = if config.solaros.libre then pkgs.linuxPackages-libre else pkgs.linuxPackages; # uses latest LTS (currently 5.4)
    hardware.enableRedistributableFirmware = !config.solaros.libre;

    services.xserver = {
      enable = true;

      # touchpad
      libinput.enable = true;

      # you know, for login
      displayManager.lightdm = {
        enable = true;
      };
    };

    channels = {
      /* links = ''
        https://github.com/mkg20001/nixpkgs/archive/mkg-patch-a.tar.gz nixos
        https://github.com/mercode-org/solaros-nix/archive/master.tar.gz solaros
        https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
      ''; */

      links = ''
        https://nix.mercode.org/dev/nixos nixos
        https://nix.mercode.org/dev/nixos-hardware nixos-hardware
        https://nix.mercode.org/dev/solaros solaros
      '';
    };
  };

  options = {
    solaros.libre = mkOption {
      type = types.bool;
      description = "Enable libre kernel & remove unfree software";
      default = false;
    };
  };
}
