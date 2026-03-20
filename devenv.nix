{ pkgs, ... }:

{
  devenv.warnOnNewVersion = false;

  languages.java.enable = true;
  languages.java.maven.enable = true;
  languages.javascript.enable = true;

  cachix.enable = false;

  packages = with pkgs; [
    osmctools
  ];

  git-hooks.hooks.conform.enable = true;
}
