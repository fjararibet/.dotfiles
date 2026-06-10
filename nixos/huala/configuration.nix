# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
let
  unstable = import <unstable> {
    config.allowUnfree = true;
  };
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];
  nixpkgs.config.allowUnfree = true;

  # Required by OpenTabletDriver
  hardware.uinput.enable = true;
  hardware.opentabletdriver.enable = true;
  boot.kernelModules = [ "uinput" ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
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

  # Optimization: Prevent systemd from waiting for network online 
  # (Optional but recommended for faster boot with VPNs)
  systemd.network.wait-online.enable = false; 
  boot.initrd.systemd.network.wait-online.enable = false;

  # Set your time zone.
  time.timeZone = "America/Santiago";


  # Select internationalisation properties.
  i18n.defaultLocale = "es_CL.UTF-8";

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

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
  };
  programs.atuin = {
    enable = true;
    daemon.enable = true;
    flags = [
      "--disable-up-arrow"
    ];
    settings = {
      daemon.enabled = true;
      daemon.autostart = true;
      search_mode = "daemon_fuzzy";
      enter_accept = true;
    };
  };

  programs.fzf = {
    keybindings = true;
    fuzzyCompletion = true;
  };

  services.cloudflared = {
    enable = true;
  };

  environment.sessionVariables = {
    SSH_AUTH_SOCK = "/run/user/1000/gcr/ssh";
    SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  users.users.fjara = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio"];
    packages = with pkgs; [
      obs-studio
      tree
      ansible
      neovim
      audacity
      zsh 
      go
      nodejs_24
      lsof
      gammastep
      wl-clipboard
      uv
      fd
      dmenu
      zip
      unzip
      discord
      stow
      google-cloud-sdk
      wlogout
      waybar
      wrangler
      gemini-cli
      sway-contrib.grimshot
      obsidian
      spotify
      davinci-resolve
      ripgrep
      cmake
      swayr
      rofi
      jq
      clipman
      numactl
      htop
      paraview
      cloudflared
      atuin
      unstable.osu-lazer-bin
      unstable.opencode
      unstable.opencode-desktop
      unstable.playwright
      unstable.playwright-driver.browsers
      unstable.playwright-mcp
      unstable.playwright-test
      unstable.codex
    wget
    curl
    git
    tmux
    gcc
    pavucontrol
    playerctl
    pamixer
    alsa-utils
    gnumake
    numactl
    ];
    shell = pkgs.zsh;
  };
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [ 
      ubuntu-classic
      liberation_ttf
      nerd-fonts.jetbrains-mono
    ];

    fontconfig = {
      defaultFonts = {
        serif = [  "Liberation Serif" ];
        sansSerif = [ "Ubuntu" ];
        monospace = [ "JetBrainsMono Nerd Font Mono" ];
      };
      allowBitmaps = true;
    };
    fontDir.enable = true;
  };
  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
  ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      adwaita-icon-theme
    ];
  };
  programs.sway.xwayland.enable = true;
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

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

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

