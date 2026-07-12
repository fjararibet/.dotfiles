{ config, lib, pkgs, ... }: 
{
  hardware.graphics.enable = true;

  # Required by OpenTabletDriver
  hardware.uinput.enable = true;
  hardware.opentabletdriver.enable = true;
  boot.kernelModules = [ "uinput" ];
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
  environment.sessionVariables = {
    GTK_THEME = "Adwaita:dark";
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_DESKTOP = "sway";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    EDITOR = "nvim";
  };

  xdg.icons.fallbackCursorThemes = [ "Adwaita" ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [ 
      commit-mono
      nerd-fonts.symbols-only
    ];

    fontconfig = {
      defaultFonts = {
        serif = [  "CommitMono" ];
        sansSerif = [ "CommitMono" ];
        monospace = [ 
          "CommitMono"
          ];
      };
    };
    fontDir.enable = true;
  };
  programs.firefox.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      adwaita-icon-theme
      slurp
      sway-contrib.grimshot
      swayr
      wlogout
      waybar
      walker
      netcat-openbsd
    ];
  };
  programs.sway.xwayland.enable = true;
  xdg.portal = {
    enable = true;
    config = {
      common.default = [ "gtk" ];
      sway.default = lib.mkForce [ "wlr" "gtk" ];
    };
    wlr.settings.screencast = {
      chooser_type = "simple";
      chooser_cmd = ''${pkgs.slurp}/bin/slurp -f 'Monitor: %o' -or'';
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };
  services.displayManager.ly = {
    enable = true;
    settings = {
      session_log = "null";
    };
  };
}
