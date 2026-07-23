{ inputs, lib, pkgs, paths, ... }:

let
  nvimTreesitter = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
  nvimTreesitterWithGrammars = pkgs.symlinkJoin {
    name = "nvim-treesitter-with-all-grammars";
    paths = [ nvimTreesitter ] ++ nvimTreesitter.dependencies;
  };

  nvimPlugins = with pkgs.vimPlugins; {
    "folke/lazy.nvim" = lazy-nvim;
    "tpope/vim-sleuth" = vim-sleuth;
    "folke/which-key.nvim" = which-key-nvim;
    "Vimjas/vim-python-pep8-indent" = vim-python-pep8-indent;
    "hrsh7th/nvim-cmp" = nvim-cmp;
    "L3MON4D3/LuaSnip" = luasnip;
    "saadparwaiz1/cmp_luasnip" = cmp_luasnip;
    "hrsh7th/cmp-path" = cmp-path;
    "hrsh7th/cmp-buffer" = cmp-buffer;
    "hrsh7th/cmp-nvim-lsp" = cmp-nvim-lsp;
    "Jezda1337/nvim-html-css" = pkgs.vimUtils.buildVimPlugin {
      pname = "nvim-html-css";
      version = "510223bdd5533ed49cad5d8a13ec8b40ab16dcda";
      src = inputs.nvim-html-css;
    };
    "navarasu/onedark.nvim" = onedark-nvim;
    "rose-pine/neovim" = rose-pine;
    "rebelot/kanagawa.nvim" = kanagawa-nvim;
    "stevearc/oil.nvim" = oil-nvim;
    "nvim-tree/nvim-web-devicons" = nvim-web-devicons;
    "mbbill/undotree" = undotree;
    "lewis6991/gitsigns.nvim" = gitsigns-nvim;
    "nvim-telescope/telescope.nvim" = telescope-nvim;
    "nvim-lua/plenary.nvim" = plenary-nvim;
    "nvim-telescope/telescope-fzf-native.nvim" = telescope-fzf-native-nvim;
    "nvim-lualine/lualine.nvim" = lualine-nvim;
    "stevearc/conform.nvim" = conform-nvim;
    "neovim/nvim-lspconfig" = nvim-lspconfig;
    "nvim-treesitter/nvim-treesitter" = nvimTreesitterWithGrammars;
    "nvim-treesitter/nvim-treesitter-textobjects" = nvim-treesitter-textobjects;
  };

  nvimConfig = pkgs.runCommand "nvim-config" { } ''
    cp -r ${paths.config + "/nvim"} "$out"
    chmod -R u+w "$out"
    mkdir -p "$out/lua/config"
    cat > "$out/lua/config/nix-plugins.lua" <<'EOF'
    return ${lib.generators.toLua { } (builtins.mapAttrs (_: builtins.toString) nvimPlugins)}
    EOF
  '';
in
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
  xdg.configFile.nvim.source = nvimConfig;
  xdg.configFile.git.source = paths.config + "/git";
}
