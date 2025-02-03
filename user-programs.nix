{ pkgs, ... }: {
  users.users.adam = {
    isNormalUser = true;
    description = "Adam";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      appimage-run
      audacious
      bottles
      discord
      flameshot
      gearlever
      gimp
      google-chrome
      isoimagewriter
      kdePackages.filelight
      kdePackages.kate
      kdePackages.kcalc
      kdePackages.kolourpaint
      kdiskmark
      kodi
      lutris
      mediainfo
      microsoft-edge
      mpv
      plex-desktop
      protonup-qt
      qbittorrent
      quassel
      remmina
      svp
      smplayer
      vlc
      zoom-us
      zapzap
    ];
  };
}
