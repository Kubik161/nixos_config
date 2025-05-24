{ config, lib, pkgs, ... }:
{
  # nextcloud
  environment.systemPackages = [
    pkgs.nextcloud30    
  ];

  environment.etc."nextcloud-admin-pass".text = "pw123456";
  environment.etc."nextcloud-db-pass".text = "dbpw123456";

  # PostgreSQL service configuration
  #services.postgresql = {
    #enable = true;
    #package = pkgs.postgresql_14;  # Adjust the PostgreSQL version as needed
    #initialScript = pkgs.writeText "nextcloud-db-init.sql" ''
    #  CREATE ROLE nextcloud WITH LOGIN PASSWORD (builtins.readFile /etc/nextcloud-db-pass);
    #  CREATE DATABASE nextcloud WITH OWNER nextcloud;
    #'';
  #};

  # PHP-FPM service configuration for Nextcloud
  services.phpfpm.pools.nextcloud = {
    user = "nextcloud";
    group = "nextcloud";
    phpOptions = ''
      upload_max_filesize = 1G
      post_max_size = 1G
      memory_limit = 512M
      max_execution_time = 300
      date.timezone = "Europe/Prague"
    '';
  }; 

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud30;
    hostName = "nixos-server";
    config = {
      dbtype = "pgsql";
      dbname = "nextcloud";
      dbuser = "nextcloud";
      dbpassFile = "/etc/nextcloud-db-pass"; # Reference to the DB password file
      adminpassFile = "/etc/nextcloud-admin-pass";
      # Additional Nextcloud configuration...
    };
    maxUploadSize = "1G"; # Adjust for max upload size
  };
}
    
