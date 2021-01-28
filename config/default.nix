{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ./base
    ./de
    ./flakes.nix
  ];

  # add our stuff. take over the repos ^^
  nixpkgs.overlays = [
    (import ../pkgs/overlay.nix)
  ];

  # nixpkgs.config.allowUnfree will be activated by installer
  # we are NOT allowed to redistribute propriatery stuff in the ISO

  # add solar cache
  nix = {
    binaryCaches = [
      "https://solar.cachix.org"
    ];
    binaryCachePublicKeys = [
      "solar.cachix.org-1:7j5FItAzYXltOuKmDtHK6gw96LTPUxFs5OlTiRfklJg="
    ];
  };
}
