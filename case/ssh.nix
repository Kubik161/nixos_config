{ config, lib, pkgs, ... }:
{
  # DO NOT FORGET TO ADD KEY BY ssh-add on new system

  # hotfix for SSH key popup dialog
  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.libsForQt5.ksshaskpass.out}/bin/ksshaskpass";

  # GnuPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-qt;
    settings = {
      default-cache-ttl = 14400;
      default-cache-ttl-ssh = 14400;	
    };
  };

  # we need to turn off ssh-agent if we want to use gnupg agent with SSH support
  programs.ssh.startAgent = false;

  environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';

}
