{ config, lib, pkgs, ... }:
{
  # listmonk
  environment.systemPackages = [
    pkgs.listmonk    
  ];

  services.listmonk = { 
    enable = true;
    settings = (builtins.fromTOML (builtins.readFile ./config.toml));
  };

}
