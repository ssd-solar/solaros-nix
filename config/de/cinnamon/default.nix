{ config, lib, pkgs, ... }:

with lib;

mkIf config.services.xserver.desktopManager.cinnamon.enable {
  # TODO: skel, gsettings override for branding, other branding

  environment.systemPackages = with pkgs; [

  ];

  # needs upstream port @mkg20001
  environment.skel = pkgs.solaros-skel-cinnamon;

  # set pam skel
  security.pam.makeHomeDir.skelDirectory = pkgs.solaros-skel-cinnamon;
}
