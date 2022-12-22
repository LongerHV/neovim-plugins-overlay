# Neovim plugins overlay

My personal selection of Neovim plugins,
available as a nixpkgs overlay.
Flake lock file is updated daily by Github Actions.

## Usage

Example usage with flakes and home-manager.

### flake.nix

```nix
{
    inputs = {
        flake-utils.url = "github:numtide/flake-utils";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
        neovim-plugins = "github:LongerHV/neovim-plugins-overlay";
    };
    outputs = { self, nixpkgs, neovim-plugins, flake-utils, home-manager, ... }@inputs:
    let
        forAllSystems = nixpkgs.lib.genAttrs flake-utils.lib.defaultSystems;
    in
    rec {
        overlays = {
            neovimPlugins = neovim-plugins.overlay;
        };

        legacyPackages = forAllSystems (system:
            import inputs.nixpkgs {
                inherit system;
                overlays = builtins.attrValues overlays;
            }
        );

        # home-manager as a NixOS module
        nixosConfigurations.some-system = nixpkgs.lib.nixosSystem {
            pkgs = legacyPackages.x86_64-linux;
            system = flake-utils.lib.system.x86_64-linux;
            modules = [
                ./configuration.nix
                home-manager.nixosModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.jdoe = import ./home.nix;
                }
            ];
        };

        # Standalone home-manager configuration
        homeConfigurations.some-home = home-manager.lib.homeManagerConfiguration {
            pkgs = legacyPackages.x86_64-linux;
            modules = [ ./home.nix ];
        };
    };
}
```

### home.nix

```nix
{ pkgs, ... }: {
    programs.neovim = {
        enable = true;
        plugins = with pkgs.nvimPlugins; [
            nvim-lspconfig
            nvim-cmp
            gitsigns
            lualine
        ];
    };
}
```
