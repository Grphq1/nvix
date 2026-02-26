{ pkgs ? import <nixpkgs> {} }:

pkgs.vimUtils.buildVimPlugin {
  pname = "tabline-framework-nvim";
  version = "f0d229c";

  doCheck = false;

  src = pkgs.fetchFromGitHub {
    owner = "rafcamlet";
    repo = "tabline-framework.nvim";
    rev = "f0d229cc2c103bbc356d26c928eff02be40b230f";
    sha256 = "sha256-xt7elL7D4udiYuAisRIH2FxLtiVnv0bKhp12/HllGm8=";
  };
}
