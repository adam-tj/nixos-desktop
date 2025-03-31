{ config, pkgs, slippi, ... }:

{
  imports = [ slippi.nixosModules.default ];

  home-manager.users.adam = {
    imports = [ slippi.homeManagerModules.default ];
    slippi-launcher = {
      isoPath = "~/Games/ROMS/animelee.iso";
      rootSlpPath = "~/Games/Slippi";
      launchMeleeOnPlay = false;
      useMonthlySubfolders = true;
      enableJukebox = true;
      useNetplayBeta = false;
    };
  };
}
