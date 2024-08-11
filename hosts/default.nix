{self, ...}: let
  # get inputs from self
  inherit (self) inputs;
  # get necessary inputs from self.inputs
  inherit (inputs) nixpkgs lanzaboote nur;
  inherit (inputs.home-manager.nixosModules) home-manager;  
  # get lib from nixpkgs and create and alias  for lib.nixosSystem
  # for potential future overrides & abstractions
  inherit (nixpkgs) lib;
  mkSystem = lib.nixosSystem;


  homes = ../homes;

  # define a sharedArgs variable that we can simply inherit
  # across all hosts to avoid traversing the file whenever
  # we need to add a common specialArg
  # if a host needs a specific arg that others do not need
  # then we can merge into the old attribute set as such:
  # specialArgs = commonArgs // { newArg = "value"; };

  commonArgs = {inherit self inputs;};

in {

  "Hyperion" = mkSystem {
     specialArgs = commonArgs;
     modules = [
       ./Hyperion/configuration.nix
       home-manager
       homes
       lanzaboote.nixosModules.lanzaboote
       nur.nixosModules.nur
     ];
  };

  "Absolution" = mkSystem {
    specialArgs = commonArgs;
    modules = [
      # this list defines which files will be imported to be used as "modules" in the system config
      ./Absolution/configuration.nix
      # use the nixos-module for home-manager
      home-manager
      homes
      lanzaboote.nixosModules.lanzaboote
      nur.nixosModules.nur
    ];
  };

  "Jupiter" = mkSystem {
     specialArgs = commonArgs;
     modules = [
       ./Jupiter/configuration.nix
       home-manager
       homes
       nur.nixosModules.nur
     ];
  };

  "Nomad" = mkSystem {
    specialArgs = commonArgs;
    modules = [
      # this list defines which files will be imported to be used as "modules" in the system config
      ./Nomad/configuration.nix
      # use the nixos-module for home-manager
      home-manager
      homes
      lanzaboote.nixosModules.lanzaboote
      nur.nixosModules.nur
    ];
  };
}
