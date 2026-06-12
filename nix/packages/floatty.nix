{pkgs ? import <nixpkgs> {}}:
pkgs.vimUtils.buildVimPlugin {
  pname = "floatty";
  version = "master";

  src = pkgs.fetchFromGitHub {
    owner = "grphq1";
    repo = "floatty.nvim";
    rev = "feat/configurable-escape-behavior";
    sha256 = "sha256-zVpot3N/pRVDS/+ZMH6LKGVpWZvQVAbUM/Mo5zgr9jM=";
  };
}
