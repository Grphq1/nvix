{ pkgs ? import <nixpkgs> {} }:

pkgs.vimUtils.buildVimPlugin {
  pname = "pixel-nvim";
  version = "master";

  src = pkgs.fetchFromGitHub {
    owner = "bjarneo";
    repo = "pixel.nvim";
    rev = "master";
    sha256 = pkgs.lib.fakeSha256;
  };
}
