callTest:
let
  loadTest = file: callTest (import file);
in
  {
    install = loadTest ./install.nix;
  }
