{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.username = "fjara";
  home.homeDirectory = "/home/fjara";
  programs.home-manager.enable = true;
  home.stateVersion = "26.05";
  home.packages = with pkgs; [
    uv
    jq
    nil
    zip
    fd
    git
    tmux
    lsof
    tree
    tree
    htop
    clang
    unzip
    delta
    neovim
    ripgrep
    tree-sitter
    wl-clipboard
    unstable.codex
    unstable.claude-code
    unstable.opencode
    ttyp
  ];
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
    EDITOR = "nvim";
  };

  xdg.configFile."clangd".source = ../config/clangd;
  xdg.configFile."tmux".source = ../config/tmux;
  xdg.configFile."nvim".source = ../config/nvim;
  xdg.configFile."git".source = ../config/git;
}
