# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

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
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8000 22 ];
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
  # systemd.services.tailscaled.serviceConfig.Environment = [ 
  #   "TS_DEBUG_FIREWALL_MODE=nftables" 
  # ];
  systemd.network.wait-online.enable = false; 
  boot.initrd.systemd.network.wait-online.enable = false;
  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = false;
    settings = {
      address = [
        "/code.home/100.106.210.10"
        "/seafile.home/100.106.210.10"
        "/filebrowser.home/100.106.210.10"
      ];
      listen-address = "100.106.210.10";
      bind-interfaces = true;
      except-interface = "lo";
      no-resolv = true;
      no-hosts = true;
    };
  };
  services.tailscale.permitCertUid = "caddy";
  services.caddy = {
    enable = true;
    virtualHosts."http://code.home" = {
      extraConfig = ''
        reverse_proxy http://localhost:4096
      '';
    };
    virtualHosts."https://nixos.triceratops-corn.ts.net" = {
      extraConfig = ''
        reverse_proxy http://localhost:5435 {
          header_up Host seafile.home
        }
      '';
    };
    virtualHosts."http://seafile.home" = {
      extraConfig = ''
        reverse_proxy http://localhost:5435
      '';
    };
    virtualHosts."http://filebrowser.home" = {
      extraConfig = ''
        reverse_proxy http://localhost:4173
      '';
    };
  };

  services.filebrowser = {
    enable = true;
    settings =  {
      port = 4173;
      root = "/var/lib/filebrowser/data";
    };
  };

  # Set your time zone.
  time.timeZone = "America/Santiago";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.pulseaudio.enable = false;
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
  programs.fzf = {
    keybindings = true;
    fuzzyCompletion = true;
  };
  # Enable touchpad support
  services.libinput.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  services.cloudflared = {
    enable = true;
    tunnels = {
      "ba400f6f-b34e-40c0-bd40-18a302990cb7" = {
        credentialsFile = "/home/fjara/.cloudflared/ba400f6f-b34e-40c0-bd40-18a302990cb7.json";
        default = "http_status:404";
        ingress = {
        "code.fjara.cl" = "http://localhost:80";
        };
      };
    };
  };
  services.tailscale = {
    enable = true;
    # Enable tailscale at startup

    # If you would like to use a preauthorized key
    #authKeyFile = "/run/secrets/tailscale_key";

  };
  environment.sessionVariables = {
    SSH_AUTH_SOCK = "/run/user/1000/gcr/ssh";
  };
  systemd.services.opencode = {
    enable = true;
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "/home/fjara/.opencode/bin/opencode web --port 4096 --hostname 0.0.0.0";
      Restart = "on-failure";
      User = "fjara";
      Environment = [
        "PATH=/run/current-system/sw/bin:$PATH"
      ];
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "discord"
      "obsidian"
      "spotify"
  ];
  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];


  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      zlib zstd stdenv.cc.cc curl openssl attr libssh bzip2 libxml2 acl libsodium util-linux xz systemd openssl.dev
    ];
  };
  users.users.fjara = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio"];

    packages = with pkgs; [
      tree
      ansible
      neovim
      zsh 
      # nodejs_24
      nodejs_22
      gammastep
      wl-clipboard
      uv
      fd
      pipx
      dmenu
      zip
      unzip
      discord
      stow
      adwaita-icon-theme
      google-cloud-sdk
      wlogout
      waybar
      wrangler
      gemini-cli
      sway-contrib.grimshot
      obsidian
      spotify
      ripgrep
      llvmPackages_20.clang-unwrapped
      cmake
      element-desktop
      nheko
      swayr
      wofi
      jq
      bitcoin
      clipman
      numactl
      htop
      paraview
      cloudflared
    ];
    shell = pkgs.zsh;
  };
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [ 
      ubuntu-classic
      liberation_ttf
      nerd-fonts.jetbrains-mono
      xorg.fontmiscmisc
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
    alacritty
    curl
    git
    tmux
    python313
    gcc
    pavucontrol
    playerctl
    pamixer
    alsa-utils
    gnumake
    numactl
    openssl
    openssl.dev
    filebrowser
    (pkgs.writeShellScriptBin "python" ''
      export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
      exec ${pkgs.python3}/bin/python "$@"
    '')
  ]  ++ (with pkgs.rocmPackages; [
  clr
  rocm-core
  rocm-runtime
  rocm-smi
  rocminfo
  hipcc
  rocblas
  miopen
  rccl
  rocsolver
  hipblas
  rocrand
  rocfft
  amdsmi
]);
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      adwaita-icon-theme
    ];
  };
  programs.sway.xwayland.enable = true;
  services.displayManager = {
    ly = {
      enable = true;
      # settings = {
      #   auto_login_session = "sway";
      #   auto_login_user = "fjara";
      # };
    };
    # autoLogin = {
    #   user = "fjara";
    #   enable = true;
    # };
  };
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.ly.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;
  # programs.ssh.startAgent = true;
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "noria" ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
    '';
    };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

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

