{ lib, pkgs, ... }:
let
  installerSrcData = builtins.fromJSON (builtins.readFile ./nixinstall/source.json);
  installerSrc = pkgs.fetchFromGitHub {
    repo = "nixinstall";
    owner = "ssd-solar";
    rev = installerSrcData.rev;
    sha256 = installerSrcData.sha256;
  };

  recursiveIterateRecreate = set: iter:
    builtins.listToAttrs(
      builtins.concatMap iter (builtins.attrNames set)
    );
in
lib.makeScope pkgs.newScope (self: with self; {
  # src
  solarosNixpkgs = import ../lib/nixpkgs.nix;
  solarosNixosHardware = import ../lib/nixos-hardware.nix;
  solaros = lib.cleanSource ../.;
  nixNodePackage = callPackage ./nix-node-package.nix { };

  # util
  mkNode = callPackage "${nixNodePackage}/nix/default.nix" { };

  # a
  # b
  # c
  conf-tool = callPackage ./conf-tool { };
  # d
  # e
  # f
  # g
  # h
  # i
  # j
  # k
  # l
  # m
  makeIcon = callPackage ./make-icon {};
  # n
  nixinstall = callPackage "${installerSrc}/nix" { };
  # o
  # p
  # q
  # r
  # s
  solaros-skel-base = callPackage ./solaros-skel-base {};
  # depend on skel-base
  solaros-skel-cinnamon = callPackage ./solaros-skel-cinnamon { };
  solaros-skel-mate = callPackage ./solaros-skel-mate { };
  solaros-skel-xfce = callPackage ./solaros-skel-xfce { };

  solaros-installer = (nixinstall.nixinstall.override {
    # slideshowPackage = todo; # TODO: add slideshow support to elementary-installer
  }).overrideAttrs(pkg: pkg // {
    name = "solaros-installer";

    postFixup = ''
      ln -s $out/bin/io.elementary.installer $out/bin/solaros-installer
      sed -i "s|io.elementary.installer|solaros-installer|g" -i $out/share/applications/*
      sed -ir 's|( *)[eE]*lementary *[oO]*[sS]*|\0solarOS|g' -i $out/share/applications/*
    '';
  });

  solarosBundles = lib.makeScope newScope (self:
    let
      bundles = (import ../config/base/bundles.nix pkgs).config.solar.bundle;
    in
      recursiveIterateRecreate bundles (key:
        let
          value = bundles.${key};
        in
          [(lib.nameValuePair key (pkgs.symlinkJoin {
            name = "solaros-bundle-${key}";
            paths = value.pkgs;

            meta = {
              description = if lib.hasAttrByPath ["description"] value then value.description else null;
            };
          }))]));
  # t
  # u
  # v
  # w
  # x
  # y
  # z
})
