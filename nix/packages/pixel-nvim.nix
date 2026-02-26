{ pkgs ? import <nixpkgs> {} }:

pkgs.vimUtils.buildVimPlugin {
  pname = "pixel-nvim";
  version = "master";

  src = pkgs.fetchFromGitHub {
    owner = "bjarneo";
    repo = "pixel.nvim";
    rev = "master";
    sha256 = "sha256-D4o5IkLsW4iq6ceeCHKHCNwxVpEV8fYPbpms+J7ZcJQ=";
  };
}
