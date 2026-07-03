{ config, pkgs, inputs, ... }:

let
  unstable = import inputs.nixpkgs-unstable { system = pkgs.stdenv.hostPlatform.system; config.allowUnfree = true; };
in

{
  imports = [
    inputs.walker.homeManagerModules.default
  ];
  home.username = "fjara";
  home.homeDirectory = "/home/fjara";
  programs.home-manager.enable = true;
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    qbittorrent
    audacious
    ffmpeg
    yt-dlp
    alacritty
    obs-studio
    tree
    ansible
    neovim
    audacity
    go
    nodejs_24
    lsof
    gammastep
    wl-clipboard
    uv
    fd
    dmenu
    tree-sitter
    zip
    unzip
    discord
    vesktop
    stow
    google-cloud-sdk
    wrangler
    gemini-cli
    obsidian
    spotify
    davinci-resolve
    ripgrep
    cmake
    jq
    clipman
    numactl
    htop
    paraview
    cloudflared
    atuin
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
    vlc
    rofi
    wtype
    hledger
    hledger-web
  ] ++ [
    unstable.osu-lazer-bin
    unstable.opencode
    unstable.opencode-desktop
    unstable.playwright
    unstable.playwright-driver.browsers
    unstable.playwright-mcp
    unstable.playwright-test
    unstable.codex
    unstable.handy
  ];

  programs.zsh = {
    enable = true;
    initContent = builtins.readFile ./config/zsh/dot-zshrc;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
  };
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    forceOverwriteSettings = true;
    daemon.enable = true;
    flags = [
      "--disable-up-arrow"
    ];
    settings = {
      daemon.enabled = true;
      daemon.autostart = true;
      search_mode = "daemon-fuzzy";
      enter_accept = true;
    };
  };

  programs.walker = {
    enable = true;
    runAsService = true;
  };

  xdg.configFile."alacritty".source = ./config/alacritty;
  xdg.configFile."clangd".source = ./config/clangd;
  xdg.configFile."git".source = ./config/git;
  xdg.configFile."sway".source = ./config/sway;
  xdg.configFile."tmux".source = ./config/tmux;
  xdg.configFile."walker".source = ./config/walker;
  xdg.configFile."waybar".source = ./config/waybar;
  xdg.configFile."wlogout".source = ./config/wlogout;
  xdg.configFile."nvim".source = ./config/nvim;

}
