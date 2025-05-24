{ config, lib, pkgs, ... }:
{
  # torrent
  environment.systemPackages = [
    pkgs.libsForQt5.ktorrent    
    pkgs.transmission_4-qt
    pkgs.jackett
    pkgs.radarr 
    pkgs.sonarr
  ];
  
  services.transmission = { 
    enable = true; #Enable transmission daemon
    user = "sonarr";
    group = "sonarr";
    openRPCPort = true; #Open firewall for RPC
    settings = { #Override default settings
      rpc-bind-address = "0.0.0.0"; #Bind to own IP
      rpc-whitelist = "127.0.0.1,10.0.0.1"; #Whitelist your remote machine (10.0.0.1 in this example)
    };
  };

  services.sonarr = {
    enable = true;
    openFirewall = true;
    group = "sonarr";
  };

  services.radarr = {
    enable = true;
    openFirewall = true;
    group = "sonarr";
  };

  nixpkgs.overlays = [ 
    (final: prev: { 
      jackett = prev.jackett.overrideAttrs { doCheck = false; }; 
    })
  ];

  services.jackett = {
    enable = true;
    openFirewall = true;
  };

  # hot fix for depraceted dotnet SDK in nixos-24.11
  nixpkgs.config.permittedInsecurePackages = [
      "aspnetcore-runtime-6.0.36"
      "aspnetcore-runtime-wrapped-6.0.36"
      "dotnet-sdk-6.0.428"
      "dotnet-sdk-wrapped-6.0.428"
    ];
}
