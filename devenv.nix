{ pkgs, lib, config, inputs, ... }:

{
  languages.java.enable = true;
  languages.java.maven.enable = true;
  languages.javascript.enable = true;

  cachix.enable = false;

  packages = with pkgs; [
    osmctools
  ];

  pre-commit.hooks = {
    conform.enable = true;
  };
}
