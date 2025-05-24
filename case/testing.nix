{ config, lib, pkgs, ... }:
{
  services.postgresql = {
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [ 
      {
        name = "nextcloud";
        ensureDBOwnership = true;
        ensureClauses = {
          createrole = true;
          login = true;
        };
      } 
    ];
  };
}
