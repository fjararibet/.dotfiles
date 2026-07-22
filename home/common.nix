{ config, pkgs, inputs, ... }:

let
unstable = import inputs.nixpkgs-unstable { system = pkgs.stdenv.hostPlatform.system; config.allowUnfree = true; };
in

{
  home.username = "fjara";
  home.homeDirectory = "/home/fjara";
  programs.home-manager.enable = true;
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
      nil
      delta
      neovim
      wl-clipboard
      uv
      git
      fd
      ripgrep
      tree-sitter
      tmux
      jq
      clang
      lsof
      tree
  ] ++ 
  [
      unstable.claude-code
  ];

  programs.zsh = {
    enable = true;
    envExtra = ''ZSH_DISABLE_COMPFIX="true"'';
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

  xdg.configFile."git".source = ../config/git;
  xdg.configFile."tmux".source = ../config/tmux;
  xdg.configFile."nvim".source = ../config/nvim;
}
