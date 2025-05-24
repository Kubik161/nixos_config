{ config, pkgs, ... }:

{
  programs.bash.shellAliases = {
    l = "ls -alh";
    screenshot = "adb exec-out screencap -p > screen.png";
  };
}
