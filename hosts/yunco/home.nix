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
      delta
      neovim
      wl-clipboard
      uv
      oracle-instantclient
      (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.cloud-firestore-emulator ])
      git
      stow
      fd
      ripgrep
      tree-sitter
      postgresql
      tmux
      terraform
      jq
      openjdk21
      clang
      nix-direnv
      rclone
      nodejs_24
      go
      lsof
      tree
      ansible
      usbutils
  ] ++ 
  [
      unstable.claude-code
      unstable.wrangler
  ];

  programs.zsh = {
    enable = true;
    initContent = builtins.readFile ../../config/zsh/dot-zshrc;
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

  xdg.configFile."git".source = ../../config/git;
  xdg.configFile."tmux".source = ../../config/tmux;
  xdg.configFile."nvim".source = ../../config/nvim;
}
