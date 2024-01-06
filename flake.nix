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
  };
  outputs =
    { self
    , nixpkgs
    , nvim-lspconfig
    , plenary
    , oceanic-next
    , telescope
    , telescope-file-browser
    , mini
    , indent-blankline
    , devicons
    , gitsigns
    , dressing
    , gen
    , fidget
    }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "aarch64-linux" "x86_64-linux" ];
    in

    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages."${system}".nixpkgs-fmt);
      overlays.default = final: prev: {
        nvimPlugins = {
          nvim-lspconfig = prev.pkgs.vimUtils.buildVimPlugin rec {
            pname = "nvim-lspconifg";
            version = src.lastModifiedDate;
            src = nvim-lspconfig;
          };
          plenary = prev.pkgs.vimUtils.buildVimPlugin rec {
            pname = "plenary";
            version = src.lastModifiedDate;
            src = plenary;
          };
          oceanic-next = prev.pkgs.vimUtils.buildVimPlugin rec {
            pname = "oceanic-next";
            version = src.lastModifiedDate;
            src = oceanic-next;
          };
          telescope = prev.pkgs.vimUtils.buildVimPlugin rec {
            pname = "telescope";
            version = src.lastModifiedDate;
            src = telescope;
          };
          telescope-file-browser = prev.pkgs.vimUtils.buildVimPlugin rec {
            pname = "telescope-file-browser";
            version = src.lastModifiedDate;
            src = telescope-file-browser;
          };
          mini = prev.pkgs.vimUtils.buildVimPlugin rec {
            pname = "mini";
            version = src.lastModifiedDate;
            src = mini;
          };
          indent-blankline = prev.pkgs.vimUtils.buildVimPlugin rec {
            pname = "indent-blankline";
            version = src.lastModifiedDate;
            src = indent-blankline;
          };
          devicons = prev.pkgs.vimUtils.buildVimPlugin rec {
            pname = "devicons";
            version = src.lastModifiedDate;
            src = devicons;
          };
          gitsigns = prev.pkgs.vimUtils.buildVimPlugin rec {
            pname = "gitsigns";
            version = src.lastModifiedDate;
            src = gitsigns;
          };
          dressing = prev.pkgs.vimUtils.buildVimPlugin rec {
            pname = "dressing";
            version = src.lastModifiedDate;
            src = dressing;
          };
          gen = prev.pkgs.vimUtils.buildVimPlugin rec {
            pname = "gen";
            version = src.lastModifiedDate;
            src = gen;
          };
          fidget = prev.pkgs.vimUtils.buildVimPlugin rec {
            pname = "fidget";
            version = src.lastModifiedDate;
            src = fidget;
          };
        };
      };
      nixosConfigurations.test = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ pkgs, ... }: {
            boot.isContainer = true;
            nixpkgs.overlays = [ self.overlays.default ];
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
