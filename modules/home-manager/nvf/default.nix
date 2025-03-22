{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.nvf.settings.vim = {
    nvf.enable = true;
    nvf.enableManpages = true;

    viAlias = true;
    vimAlias = false;

    # Style
    theme = {
      enable = true;
      name = "gruvbox";
      style = "dark";
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
        action = "nzzzv";
      }
      {
        mode = "x";
        key = "<leader>p";
        action = "\"_dP";
      }
      {
        mode = ["n" "v"];
        key = "<leader>y";
        action = "\"+y";
      }
      {
        mode = "v";
        key = "<leader>Y";
        action = "\"+Y";
      }
      {
        mode = ["n" "v"];
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
        action = "[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]";
      }
    ];

    # Vim options
    options = {
      number = true;
      relativenumber = true;

      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
      expandtab = true;

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

    # Navigation
    navigation.harpoon.enable = true;
    navigation.harpoon.mappings = {
      markFile = "<leader>a";
      listMarks = "<leader>h";
      file1 = "<C-j>";
      file2 = "<C-k>";
      file3 = "<C-l>";
      file4 = "<C-;>";
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

    # LSPs
    lsp = {
      enable = true;
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
    };

    autocomplete.nvim-cmp.enable = true;

    # Supported languages
    languages = {
      enableLSP = true;
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;

      rust.enable = true;
      nix.enable = true;
      sql.enable = true;
      java.enable = true;
      html.enable = true;
      markdown.enable = true;
      dart.enable = true;
      go.enable = true;
      lua.enable = true;
      typst.enable = true;

      wgsl.enable = false;
    };

    binds.whichKey.enable = true;
    mini.surround.enable = true;
  };
}
