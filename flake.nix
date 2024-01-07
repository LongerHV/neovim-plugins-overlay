{
  description = "Neovim plugin overlay";
  inputs = {
    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };
    plenary = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
    oceanic-next = {
      url = "github:mhartington/oceanic-next";
      flake = false;
    };
    telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
    telescope-file-browser = {
      url = "github:nvim-telescope/telescope-file-browser.nvim";
      flake = false;
    };
    mini = {
      url = "github:echasnovski/mini.nvim";
      flake = false;
    };
    indent-blankline = {
      url = "github:lukas-reineke/indent-blankline.nvim";
      flake = false;
    };
    devicons = {
      url = "github:nvim-tree/nvim-web-devicons";
      flake = false;
    };
    gitsigns = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
    dressing = {
      url = "github:stevearc/dressing.nvim";
      flake = false;
    };
    gen = {
      url = "github:David-Kunz/gen.nvim";
      flake = false;
    };
    fidget = {
      url = "github:j-hui/fidget.nvim";
      flake = false;
    };
    oil = {
      url = "github:stevearc/oil.nvim";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, ... }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "aarch64-linux" "x86_64-linux" ];
      overlay = final: prev:
        let
          mkPlugin = name: value:
            prev.pkgs.vimUtils.buildVimPlugin {
              pname = name;
              version = value.lastModifiedDate;
              src = value;
            };
          plugins = prev.lib.filterAttrs (name: _: name != "self" && name != "nixpkgs") inputs;
        in
        {
          nvimPlugins = builtins.mapAttrs mkPlugin plugins;
        };
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages."${system}".nixpkgs-fmt);
      legacyPackages = forAllSystems (system:
        import inputs.nixpkgs {
          inherit system;
          overlays = [ overlay ];
          config.allowUnfree = true;
        }
      );
      overlays.default = overlay;
      nixosConfigurations.test = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ pkgs, ... }: {
            boot.isContainer = true;
            nixpkgs.overlays = [ overlay ];
            system.stateVersion = "22.11";
            programs.neovim = {
              enable = true;
              configure.packages.myVimPackage = {
                opt = builtins.attrValues pkgs.nvimPlugins;
              };
            };
          })
        ];
      };
    };
}
