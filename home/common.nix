{ pkgs, paths, ... }:

let
  ohMyZsh = pkgs.fetchFromGitHub {
    owner = "ohmyzsh";
    repo = "ohmyzsh";
    rev = "52d93f18d61f11db69b4591d7fc7bd5578954d30";
    hash = "sha256-fGFPVHbJFtXvuiR0yOc9Qt1TUuIfNAYezGQtESt9REA=";
  };
in

{
  imports = [ (paths.home + "/neovim.nix") ];

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
    initContent = ''
      source ${ohMyZsh}/plugins/git/git.plugin.zsh
      ${builtins.readFile (paths.config + "/zsh/refined.zsh-theme")}
      ${builtins.readFile (paths.config + "/zsh/dot-zshrc.zsh")}
    '';
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
  xdg.configFile.git.source = paths.config + "/git";
}
