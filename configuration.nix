# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# Test edit

{ config, pkgs, ... }:

{

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./flatpak.nix
    ];


    # Flatpak
    services.flatpak.enable = true;

    # Flakes and home-manager
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Slippi
    services.udev.packages = [ pkgs.dolphin-emu ];
    boot.extraModulePackages = [
    config.boot.kernelPackages.gcadapter-oc-kmod
    ];
    # to autoload at boot:
    boot.kernelModules = [
    "gcadapter_oc"
   ];

    # Bootloader.
    boot.kernelPackages = pkgs.linuxPackages_6_12;
#   boot.loader.systemd-boot.enable = true;
#   boot.loader.efi.canTouchEfiVariables = true;

  boot = {

    plymouth = {
      enable = true;
      theme = "colorful_loop";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "colorful_loop" ];
        })
      ];
    };

    # Enable "Silent Boot"
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "nvidia.NVreg_EnableGpuFirmware=0"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 3;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

  };

  networking.hostName = "desktop"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
  discover
  elisa
];


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "eu";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs.steam = {
  enable = true;
  remotePlay.openFirewall = true;
  dedicatedServer.openFirewall = true;
  localNetworkGameTransfers.openFirewall = true;
  gamescopeSession.enable = true;
};
  programs.gamemode.enable = true;


  # Xbox controller
  hardware.xone.enable = true;

  users.users.adam = {
    isNormalUser = true;
    description = "Adam";
    extraGroups = [ "networkmanager" "wheel" "audio" "input"];
    packages = with pkgs; [
    ];
  };


  # Plex stuff
  xdg.portal = {
    extraPortals = [
    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-kde
    ];
    xdgOpenUsePortal = true;
  };


  # OpenRGB rules
#   services.hardware.openrgb.enable = true;

  # Piper rules
  services.ratbagd.enable = true;

  # Install firefox.
  programs.firefox = {
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
    btop
    distrobox
    fastfetch
    fish
    git
    gnugrep
    htop
    killall
    kdePackages.partitionmanager
    mlocate
    ocl-icd
    opencl-headers
#     openrgb-with-all-plugins
    pciutils
    usbutils
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    rar
    linuxPackages.nvidia_x11
#     umu-launcher
    vulkan-tools
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  services.locate.enable = true;
  services.locate.package = pkgs.mlocate;

  # Distrobox setup
  virtualisation.podman = {
  enable = true;
  dockerCompat = true;
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?


  # NVIDIA

  # Enable OpenGL

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

  # Modesetting is required
  modesetting.enable = true;
  powerManagement.enable = true;
  powerManagement.finegrained = false;
  open = false;
  nvidiaSettings = true;
  package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # GPU fan curve
  #security.polkit.enable = true;
  programs.coolercontrol = {
    enable = true;
    nvidiaSupport = true;
  };

}
