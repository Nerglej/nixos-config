{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nvf.homeManagerModules.default
  ];

  programs.nvf = {
    enable = true;
    enableManpages = true;
    settings.vim = {
      viAlias = false;
      vimAlias = true;

      # Style
      theme = {
        enable = true;
        name = "gruvbox";
        style = "dark";
        # style = "light";
      };

      globals.mapleader = " ";

      # Keymaps
      keymaps = [
        {
          mode = "v";
          key = "J";
          action = ":m '>+1<CR>gv=gv";
        }
        {
          mode = "v";
          key = "K";
          action = ":m '<-2<CR>gv=gv";
        }
        {
          mode = "n";
          key = "n";
          action = "nzzzv";
        }
        {
          mode = "n";
          key = "N";
          action = "Nzzzv";
        }
        {
          mode = "x";
          key = "<leader>p";
          action = "\"_dP";
        }
        {
          mode = [
            "n"
            "v"
          ];
          key = "<leader>y";
          action = "\"+y";
        }
        {
          mode = "v";
          key = "<leader>Y";
          action = "\"+Y";
        }
        {
          mode = [
            "n"
            "v"
          ];
          key = "<leader>d";
          action = "\"_d";
        }
        {
          mode = "n";
          key = "<C-j>";
          action = "<cmd>cprev<CR>zz";
        }
        {
          mode = "n";
          key = "<C-k>";
          action = "<cmd>cnext<CR>zz";
        }
        {
          mode = "n";
          key = "<leader>j";
          action = "<cmd>lprev<CR>zz";
        }
        {
          mode = "n";
          key = "<leader>k";
          action = "<cmd>lnext<CR>zz";
        }
        {
          mode = "n";
          key = "<leader>s";
          action = ":%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>";
        }
        {
          mode = "n";
          key = "-";
          action = "<Cmd>Oil<CR>";
        }
      ];

      # Vim options
      options = {
        number = true;
        relativenumber = true;

        tabstop = 4;
        shiftwidth = 0;
        expandtab = false;

        smartindent = true;

        wrap = false;

        swapfile = false;
        backup = false;
        undodir = lib.generators.mkLuaInline "os.getenv('HOME') .. '/.vim/undodir'";
        undofile = true;

        hlsearch = false;
        incsearch = true;

        termguicolors = true;

        scrolloff = 12;
        signcolumn = "yes";
        # vim.opt.isfname:append("@-@")

        updatetime = 50;

        colorcolumn = "80";
      };

      autocmds = [
        {
          event = [ "Filetype" ];
          pattern = [
            "nix"
            "dart"
          ];
          desc = "Set correct indent and tabs as spaces for some filestypes";
          callback = lib.generators.mkLuaInline ''
            function()
              vim.opt_local.tabstop = 2;
              vim.opt_local.expandtab = true;
            end
          '';
        }
        {
          event = [ "Filetype" ];
          pattern = [
            "html"
          ];
          desc = "Set correct indent for other files";
          callback = lib.generators.mkLuaInline ''
            function()
              vim.opt_local.tabstop = 2;
            end
          '';
        }
      ];

      # Navigation
      navigation.harpoon.enable = true;
      navigation.harpoon.mappings = {
        markFile = "<leader>a";
        listMarks = "<leader>h";
        file1 = "<C-1>";
        file2 = "<C-2>";
        file3 = "<C-3>";
        file4 = "<C-4>";
      };

      telescope.enable = true;
      telescope.mappings = {
        findFiles = "<leader>ff";
        liveGrep = "<leader>fg";
        buffers = "<leader>fb";
        helpTags = "<leader>fh";
        diagnostics = "<leader>fd";
        findProjects = "<leader>fp";
      };

      git.enable = true;
      git.gitsigns.enable = false;

      diagnostics = {
        enable = true;
        config = {
          underline = true;
          virtual_text = true;

          virtual_lines = false;
        };
      };

      # LSPs
      lsp = {
        enable = true;
        formatOnSave = false;
        inlayHints.enable = false;

        mappings = {
          hover = "K";
          goToDefinition = "gd";
          goToDeclaration = "gD";
          listImplementations = "gi";
          goToType = "go";
          listReferences = "gr";
          signatureHelp = "gs";
          renameSymbol = "<F2>";
          format = "gq";
          codeAction = "<F4>";
        };

        trouble.enable = true;
        trouble.mappings = {
          workspaceDiagnostics = "<leader>xx";
          documentDiagnostics = "<leader>xX";
          symbols = "<leader>cs";
          lspReferences = "<leader>cl";
          locList = "<leader>xL";
          quickfix = "<leader>xQ";
        };

        servers.dart.enable = lib.mkForce false;
        servers.dart.cmd = lib.mkForce [
          "dart"
          "language-server"
          "--protocol=lsp"
        ];

        servers.svelte.cmd = lib.mkForce [
          "svelteserver"
          "--stdio"
        ];
      };

      autocomplete.nvim-cmp = {
        enable = true;
        mappings = {
          previous = "<C-k>";
          next = "<C-j>";
          confirm = "<C-l>";
          # close = "<>";
        };
      };

      formatter.conform-nvim.setupOpts.format_on_save = null;
      formatter.conform-nvim.setupOpts.format_after_save = null;

      # Supported languages
      languages = {
        enableTreesitter = true;
        enableFormat = true;

        nix = {
          enable = true;
          lsp.enable = true;
        };

        rust = {
          enable = true;
          lsp.enable = true;
          lsp.package = [ "rust-analyzer" ];
          extensions.crates-nvim.enable = true;
        };

        go.enable = true;

        dart = {
          enable = true;

          flutter-tools.enable = true;
          flutter-tools.flutterPackage = null;
          # flutter-tools.enableNoResolvePatch = true;
        };

        csharp.enable = true;
        java.enable = true;
        lua.enable = true;

        sql.enable = true;

        html = {
          enable = true;
          lsp.enable = false;
          treesitter.autotagHtml = true;
        };
        css = {
          enable = true;
          lsp.enable = false;
        };
        ts = {
          enable = true;
          lsp.enable = true;
        };

        svelte = {
          enable = true;
          lsp.enable = true;
        };

        markdown.enable = true;
        typst.enable = true;
        typst.extensions.typst-preview-nvim.enable = true;
      };

      binds.whichKey.enable = true;
      mini.surround.enable = true;

      utility = {
        # Image-nvim doesn't work
        # images.image-nvim.enable = true;
        images.img-clip.enable = true;
        oil-nvim.enable = true;
        oil-nvim.setupOpts = {
          view_options.show_hidden = true;
        };
      };

      assistant.avante-nvim = {
        enable = true;

        setupOpts.behaviour.enable_cursor_planning_mode = true;
        setupOpts.behaviour.support_paste_from_clipboard = true;

        setupOpts.provider = "ollama";
        setupOpts.providers = {
          ollama = {
            model = "deepseek-coder-v2:16b";
            is_env_set = ''require("avante.providers.ollama").check_endpoint_alive'';
            disable_tools = false; # deepseek coder does not support tools

            extra_request_body.options = {
              temperature = 0.5;
              # num_ctx = 20480; # Default for deepseek-coder-v2
              num_ctx = 4096;
              keep_alive = "5m";
            };
          };
        };
      };

      # startPlugins = with pkgs.vimPlugins.nvim-treesitter; [
      #  ecma
      # ];

      lazy.plugins = {
        undotree = {
          package = pkgs.vimPlugins.undotree;

          cmd = [ "UndotreeToggle" ];

          keys = [
            {
              mode = "n";
              key = "<leader>u";
              action = "vim.cmd.UndotreeToggle";
              lua = true;
              desc = "Toggle undotree [Undotree]";
            }
          ];
        };
      };

      extraPlugins = with pkgs.vimPlugins; {
        markview-nvim = {
          package = markview-nvim;
        };
      };
    };
  };
}
