{
  description = "R9000P configuration";
  nixConfig = {
    extra-substituters = ["https://noctalia.cachix.org"];
    extra-trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="];
    substituters = [
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # AI agents / ChatGPT / Herdr
    llm-agents.url = "github:numtide/llm-agents.nix";

    noctalia.url = "github:noctalia-dev/noctalia/cachix";

    # CookNxivim 配置完整版
    CookNixvim = {
      url = "github:Youthdreamer/CookNixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix/release-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    CookNixvim,
    catppuccin,
    noctalia,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      r9000p = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs pkgs-unstable;
        };

        modules = [
          ./configuration.nix
          inputs.sops-nix.nixosModules.sops
          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # 第一次接管已有 Home 时，保留原配置而不是直接覆盖
            home-manager.backupFileExtension = "hm-backup";
            home-manager.extraSpecialArgs = {inherit inputs pkgs-unstable;};
            home-manager.users.charles = {
              imports = [
                catppuccin.homeModules.catppuccin
                noctalia.homeModules.default
                ./home/charles
              ];
              home.packages = [
                CookNixvim.packages.${system}.default
              ];
            };
          }
        ];
      };
    };
  };
}
