# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:
let
  unstable = import inputs.nixpkgs-unstable { system = pkgs.stdenv.hostPlatform.system; config.allowUnfree = true; };
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  services.plex = {
    enable = true;
    openFirewall = true;
  };
  nix.settings.auto-optimise-store = true;
  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;
  hardware.graphics.enable = true;

  # Required by OpenTabletDriver
  hardware.uinput.enable = true;
  hardware.opentabletdriver.enable = true;
  boot.kernelModules = [ "uinput" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };


  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
    grub.enable = true;
    grub.device = "nodev";
    grub.useOSProber = true;
    grub.efiSupport = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.hostName = "huala";
  services.tailscale.enable = true;
  networking.networkmanager.enable = true;
  networking.nftables.enable = true;
  networking.firewall = {
    enable = false;
    allowedTCPPorts = [ 8000 22 4096 ];
    trustedInterfaces = [ config.services.tailscale.interfaceName ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
  # Force tailscaled to use nftables (Critical for clean nftables-only systems)
  # This avoids the "iptables-compat" translation layer issues.
  systemd.services.tailscaled.serviceConfig.Environment = [ 
    "TS_DEBUG_FIREWALL_MODE=nftables" 
  ];
  programs.steam = {
    enable = true;
  };

  i18n.defaultLocale = "es_CL.UTF-8";
  i18n.extraLocaleSettings = {
    LC_MESSAGES = "en_US.UTF-8";
  };

  # Optimization: Prevent systemd from waiting for network online 
  # (Optional but recommended for faster boot with VPNs)
  systemd.network.wait-online.enable = false; 
  boot.initrd.systemd.network.wait-online.enable = false;

  # Set your time zone.
  time.timeZone = "America/Santiago";


  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    wireplumber = {
      enable = true;
      package = pkgs.wireplumber;
    };
  };


  programs.zsh.enable = true;

  # programs.fzf = {
  #   keybindings = true;
  #   fuzzyCompletion = true;
  # };

  services.cloudflared = {
    enable = true;
  };

  environment.sessionVariables = {
    GTK_THEME = "Adwaita:dark";
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
    SSH_AUTH_SOCK = "/run/user/1000/gcr/ssh";
  };

  xdg.icons.fallbackCursorThemes = [ "Adwaita" ];

  users.users.fjara = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio"];
    shell = pkgs.zsh;
  };
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [ 
      ubuntu-classic
      liberation_ttf
      nerd-fonts.commit-mono
    ];

    fontconfig = {
      defaultFonts = {
        serif = [  "Liberation Serif" ];
        sansSerif = [ "Ubuntu" ];
        monospace = [ 
          "CommitMono Nerd Font Mono"
          ];
      };
      allowBitmaps = true;
    };
    fontDir.enable = true;
  };
  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    vim
    wget
    curl
  ];

  services.elephant.enable = true;
  systemd.user.services.elephant = {
    after = [ "sway-session.target" ];
    wantedBy = lib.mkForce [ "sway-session.target" ];
    partOf = [ "sway-session.target" ];

    path = [ pkgs.bash pkgs.xdg-utils config.programs.steam.package config.system.path ];
    environment.XDG_DATA_DIRS = lib.makeSearchPathOutput "out" "share" (
      [ pkgs.elephant config.programs.steam.package config.system.path ]
    );
  };
  systemd.user.services.walker = {
    description = "Walker";
    path = [ pkgs.elephant config.programs.steam.package config.system.path ];

    environment.XDG_DATA_DIRS = lib.makeSearchPathOutput "out" "share" (
      [ pkgs.walker pkgs.elephant config.programs.steam.package config.system.path ]
    );

    after = [ "sway-session.target" "elephant.service" ];
    requires = [ "elephant.service" ];
    partOf = [ "sway-session.target" ];
    wantedBy = [ "sway-session.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.walker}/bin/walker --gapplication-service";
      Restart = "on-failure";
    };
  };
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      adwaita-icon-theme
      slurp
      sway-contrib.grimshot
      swayr
      wlogout
      waybar
      walker
      netcat-openbsd
    ];
  };
  programs.sway.xwayland.enable = true;
  xdg.portal = {
    enable = true;
    config.common.default = [ "gtk" ];
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  services.displayManager.ly = {
    enable = true;
    settings = {
      logfile = "/dev/null";
    };
  };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.ly.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}
