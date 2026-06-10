{ config, pkgs, lib, ... }:
let
  unstable = import <unstable> {
     config = {
       allowUnfree = true;
     };
  };
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  services.tailscale.enable = true;
  networking.nftables.enable = true;
  networking.firewall = {
    enable = false;
    # Always allow traffic from your Tailscale network
    trustedInterfaces = [ "tailscale0" ];
    # Allow the Tailscale UDP port through the firewall
    allowedTCPPorts = [ 8000 4096 3000 ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  # 2. Force tailscaled to use nftables (Critical for clean nftables-only systems)
  # This avoids the "iptables-compat" translation layer issues.
  systemd.services.tailscaled.serviceConfig.Environment = [ 
    "TS_DEBUG_FIREWALL_MODE=nftables" 
  ];

  # 3. Optimization: Prevent systemd from waiting for network online 
  # (Optional but recommended for faster boot with VPNs)
  systemd.network.wait-online.enable = false; 
  boot.initrd.systemd.network.wait-online.enable = false;
  environment.sessionVariables = {
	  SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  };
  hardware.opentabletdriver.enable = true;
  hardware.uinput.enable = true;
  boot.kernelModules = [ "uinput" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;
  networking.hostName = "fragata";

  networking.networkmanager.enable = true;

  time.timeZone = "America/Santiago";
  systemd.services.opencode = {
	  enable = true;
	  after = [ "network.target" ];
	  wantedBy = [ "multi-user.target" ];
	  serviceConfig = {
		  ExecStart = "/etc/profiles/per-user/fjara/bin/opencode serve --port 4096 --hostname 0.0.0.0";
		  Restart = "on-failure";
		  User = "fjara";
		  Environment = [
			  "PATH=/run/current-system/sw/bin:$PATH"
		  ];
	  };
  };


  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CL.UTF-8";
    LC_IDENTIFICATION = "es_CL.UTF-8";
    LC_MEASUREMENT = "es_CL.UTF-8";
    LC_MONETARY = "es_CL.UTF-8";
    LC_NAME = "es_CL.UTF-8";
    LC_NUMERIC = "es_CL.UTF-8";
    LC_PAPER = "es_CL.UTF-8";
    LC_TELEPHONE = "es_CL.UTF-8";
    LC_TIME = "es_CL.UTF-8";
  };

  # services.xserver.xkb = {
  #   layout = "us";
  #   variant = "altgr-intl";
  # };

  # nixpkgs.config.allowUnfreePredicate = pkg:
  #   builtins.elem (lib.getName pkg) [
  #     "steam"
  #     "steam-unwrapped"
  #     "nvidia-x11"
  #     "nvidia-settings"
  #     "nvidia-persistenced"
  # ];



  hardware.graphics = {
    enable = true;
  };
  services.xserver.videoDrivers = ["nvidia" "modesetting"];
  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
# Make sure to use the correct Bus ID values for your system!
# sudo lshw -c display
intelBusId = "PCI:0:2:0";
nvidiaBusId = "PCI:1:0:0";
};


  users.users.fjara = {
    isNormalUser = true;
    description = "Felipe Jara";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      davinci-resolve
      playwright-mcp
      mdbtools
      unzip
      llvmPackages_20.clang-unwrapped
      typescript-language-server
      pavucontrol
      neovim
      tmux
      ripgrep
      git
      uv
      stow
      alacritty
      atuin
      gcc
      clang
      fd
      unstable.valhalla
      paraview
      wlogout
      cloudflared
      unstable.opencode
      unstable.opencode-desktop
      unstable.claude-code
      unstable.bun
      unstable.nodejs
      unstable.osu-lazer-bin
      unstable.discord
      rPackages.opentripplanner
    ];
  };
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font Mono" ];
      };
    };
  };
  programs.nix-ld.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraOptions = [
      "--unsupported-gpu"
    ];
    extraPackages = with pkgs; [
      brightnessctl foot grim pulseaudio swayidle swaylock wmenu
      waybar
      swayr
      wofi
      dmenu
      bibata-cursors
    ];
  };
  programs.fzf = {
    keybindings = true;
    fuzzyCompletion = true;
  };
  programs.firefox.enable = true;
  programs.steam.enable = true;
  programs.steam.extraCompatPackages = with pkgs; [
    proton-ge-bin
  ];

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "refined";
    };
  };
  # services.displayManager.ly.enable = true;
  # services.displayManager.gdm.enable = true;
  # services.desktopManager.gnome.enable = true;

  # To disable installing GNOME's suite of applications
  # and only be left with GNOME shell.

  # services.gnome.core-apps.enable = false;
  # services.gnome.core-developer-tools.enable = false;
  # services.gnome.games.enable = false;
  # environment.gnome.excludePackages = with pkgs; [ gnome-tour gnome-user-docs ];
  services.displayManager.ly = {
	  enable = true;
	  settings = {
		  logfile = "/dev/null";
	  };
  };


  programs.ssh.startAgent = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];

  services.openssh.enable = true;
  services.libinput.enable = true;

  # Open ports in the firewall.

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
