{ config, pkgs, inputs, ... }:

let
  unstablePkgs = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };

  stablePackages = with pkgs; [
    inputs.ttyp.packages.${pkgs.stdenv.hostPlatform.system}.default
    nil
    delta
    neovim
    wl-clipboard
    uv
    git
    fd
    ripgrep
    tree
    tree-sitter
    tmux
    jq
    clang
    lsof
    tree
    zip
    unzip
  ];

  unstablePackages = with unstablePkgs; [
    claude-code
    codex
    opencode
  ];
in
{
  home.username = "fjara";
  home.homeDirectory = "/home/fjara";
  programs.home-manager.enable = true;
  home.stateVersion = "26.05";
  home.packages = stablePackages ++ unstablePackages;

  programs.zsh = {
    enable = true;
    envExtra = ''
      ZSH_DISABLE_COMPFIX="true"
    '';
    initContent = builtins.readFile ../config/zsh/dot-zshrc;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "refined";
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

  home.sessionVariables = {
    EDITOR="nvim";
  };

  xdg.configFile."clangd".source = ../config/clangd;
  xdg.configFile."tmux".source = ../config/tmux;
  xdg.configFile."nvim".source = ../config/nvim;
  xdg.configFile."git".source = ../config/git;
}
