
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./bash.nix
      ./case/torrent.nix
      ./case/ssh.nix
      #./case/iscsi.nix
      #./case/dropbox.nix	
      #./case/postgres.nix
      #./case/nextcloud.nix	
      #./case/listmonk.nix
      #./case/testing.nix		
    ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "aramaki"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "cs_CZ.UTF-8";
    LC_IDENTIFICATION = "cs_CZ.UTF-8";
    LC_MEASUREMENT = "cs_CZ.UTF-8";
    LC_MONETARY = "cs_CZ.UTF-8";
    LC_NAME = "cs_CZ.UTF-8";
    LC_NUMERIC = "cs_CZ.UTF-8";
    LC_PAPER = "cs_CZ.UTF-8";
    LC_TELEPHONE = "cs_CZ.UTF-8";
    LC_TIME = "cs_CZ.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;
  # Set correct video driver
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

   # enable also gnome
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "cz";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "cz-lat2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kubik = {
    isNormalUser = true;
    description = "kubik";
    extraGroups = [ "networkmanager" "wheel" "adbusers" "docker" "sonarr" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Enable automatic login for the user.
  #services.xserver.displayManager.autoLogin.enable = true;
  #services.xserver.displayManager.autoLogin.user = "kubik";

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # work
    pkgs.android-studio	
    pkgs.android-tools
    pkgs.git
    pkgs.slack
    pkgs.go
    pkgs.unzip
    pkgs.mitmproxy
    pkgs.mediainfo
    # personal
    #pkgs.libsForQt5.dolphin
    pkgs.kdePackages.dolphin
    pkgs.signal-desktop    
    pkgs.thunderbird	
    pkgs.steam
    pkgs.pciutils
    pkgs.bitwarden-desktop
    pkgs.geany
    pkgs.nmap   
    pkgs.dropbox
    pkgs.lm_sensors
    pkgs.gnumake
    pkgs.htop
    pkgs.jq
    # union
    pkgs.vscode
    pkgs.jetbrains.idea-community
    pkgs.dbeaver-bin
    pkgs.docker
    pkgs.docker-compose
    pkgs.nodejs
    pkgs.gnat
    pkgs._7zz
    pkgs.nix-prefetch
    pkgs.discord
    pkgs.scribus
    # ssh and keys
    #pkgs.openssh
    pkgs.gnupg
    pkgs.openssl
    # video
    pkgs.smplayer
    pkgs.mpv

    pkgs.webkitgtk_6_0
    pkgs.lshw
    pkgs.libreoffice
    pkgs.gimp
    pkgs.calibre
    pkgs.vim
    # NAS
    pkgs.openiscsi
    #gnome specific?
    pkgs.gnome-screenshot
    # gaming
    pkgs.lutris
    pkgs.wineWow64Packages.full
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # Extra fonts, needed by Scribus
  fonts.packages = with pkgs; [
    merriweather-sans
  ];

  # abd needs extra care
  programs.adb.enable = true;
  # steam needs extra care
  programs.steam.enable = true;

  # GnuPG
  #programs.gnupg.agent = {
  #  enable = true;
  #  enableSSHSupport = true;
  #  pinentryPackage = pkgs.pinentry-qt;
  #};
  services.pcscd.enable = true;
  # we need to turn off ssh-agent if we want to use gnupg agent with SSH support
 # programs.ssh.startAgent = false;

  virtualisation.docker.enable = true;

  # Enable the OpenSSH daemon.
  #services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 6881 51413 ];
    allowedUDPPorts = [ 8881 ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  system.autoUpgrade = {
      enable = true;
  };

  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    options = "--delete-older-than 10d";
  };

#  environment.shellInit = ''
#    gpg-connect-agent /bye
#    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
#  '';
}
