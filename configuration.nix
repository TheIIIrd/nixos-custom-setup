# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Custom DNS
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "ru_RU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.theuser = {
    isNormalUser = true;
    description = "theuser";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = (with pkgs; [
      authenticator
      blackbox-terminal
      blender
      collision
      curtail
      darktable
      easyeffects
      eartag
      fragments
      g4music
      gnome-graphs
      gnome-obfuscate
      impression
      inkscape
      krita
      metadata-cleaner
      mission-center
      olive-editor
      onlyoffice-bin_latest
      pixelorama
      planify
      raider
      rnote
      scribus
      switcheroo
      sysprof
      tenacity
      vlc
      vscodium
    ]) ++ (with pkgs.gnome; [
      gnome-tweaks
    ]) ++ (with pkgs.gnomeExtensions; [
      blur-my-shell # blur look to different parts of the GNOME Shell
      quick-lang-switch # quickly switch layout
      appindicator # tray icons support
      clipboard-indicator # clipboard manager
      # caffeine # Disable the screensaver and auto suspend
      # dash-to-panel # icon taskbar
      # arcmenu # application menu
      # vitals # system monitor
      # just-perfection # tweak tool
    ]);
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    aria2 # download utility
    curl # transferring files
    git # version control system
    wget2 # website downloader

    clang # system C compiler
    clang-tools # cpp dev
    libgcc # gnu C compiler
    mono # dotnet dev framework
    pipx # python package manager
    python3Full # dynamically-typed language
    zulu # builds of openjdk

    fastfetch # like neofetch
    gparted # disk partitioning
    inxi # system information
    neovim # vim fork
    zsh # the z shell

    # tela-circle-icon-theme # colorful personality icon theme
    adw-gtk3 # theme from libadwaita ported to GTK-3
    meslo-lgs-nf # meslo nerd font
  ];

  # Not all applications that come pre-installed with the GNOME desktop
  # environment are desirable for everyone to have on their machines.
  # There's a way to edit configuration.nix to exclude these kinds of
  # packages, for example as follows:
  environment.gnome.excludePackages = (with pkgs; [
    # gnome-console
    gnome-tour
    snapshot # webcam tool
  ]) ++ (with pkgs.gnome; [
    # gnome-calendar
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-weather
    epiphany # web browser
    geary # email reader
    evince # document viewer
    totem # video player
  ]) ++ (with pkgs.gnomeExtensions; [
    applications-menu
    # removable-drive-menu
    native-window-placement
    places-status-indicator
    # screenshot-window-sizer
    system-monitor
    # user-themes
    window-list
    windownavigator
  ]);

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # The virt-manager application is a GUI for managing local and remote
  # virtual machines through libvirt. It primarily targets KVM VMs, but
  # also manages Xen and LXC (linux containers).
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # When running NixOS as a guest, enable the QEMU guest agent with:
  # services.qemuGuest.enable = true;
  # services.spice-vdagentd.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Flatpak is a Linux application sandboxing and distribution framework.
  services.flatpak.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable flakes permanently in NixOS
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
