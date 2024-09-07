{
  nixpkgs,
  home-manager,
  defaultOverlays ? [ ],
  defaultModules ? [ ],
  ...
}:
{
  username,
  homeDirectory ? "/home/${username}",
  system ? "x86_64-linux",
  modules ? [ ],
  isNixOS ? false,
  overlays ? [ ],
  extraSpecialArgs ? { },
}:
home-manager.lib.homeManagerConfiguration {
  pkgs = import nixpkgs {
    inherit system;
    overlays = defaultOverlays ++ overlays;
    config.allowUnfree = true;
  };

  modules = [
    {
      home.stateVersion = "23.11";
      home.username = username;
      home.homeDirectory = homeDirectory;
    }
  ] ++ defaultModules ++ modules;

  extraSpecialArgs = {
    inherit isNixOS;
  } // extraSpecialArgs;
}
