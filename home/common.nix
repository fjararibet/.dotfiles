{ pkgs, paths, ... }:

{
  home.username = "fjara";
  home.homeDirectory = "/home/fjara";
  programs.home-manager.enable = true;
  home.stateVersion = "26.05";
  home.packages = with pkgs; [
    uv
    jq
    fd
    git
    nil
    zip
    tmux
    tree
    tree
    lsof
    ttyp
    htop
    clang
    unzip
    delta
    neovim
    ripgrep
    tree-sitter
    wl-clipboard
    unstable.codex
    unstable.opencode
    unstable.claude-code
  ];
  programs.zsh = {
    enable = true;
    envExtra = ''
      ZSH_DISABLE_COMPFIX="true"
    '';
    initContent = builtins.readFile (paths.config + "/zsh/dot-zshrc");

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

  xdg.configFile.clangd.source = paths.config + "/clangd";
  xdg.configFile.tmux.source = paths.config + "/tmux";
  xdg.configFile.nvim.source = paths.config + "/nvim";
  xdg.configFile.git.source = paths.config + "/git";
}
