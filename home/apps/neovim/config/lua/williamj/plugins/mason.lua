return {
  {
    "williamboman/mason.nvim",
    name = "mason",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    opts = {},
    config = true,
  },

  --- LSP ---
  {
    "williamboman/mason-lspconfig.nvim",
    name = "mason-lspconfig",
    dependencies = { "mason" },
    opts = {},
    config = true,
  },
  {
    "neovim/nvim-lspconfig",
    name = "lspconfig",
    dependencies = { "mason", "mason-lspconfig" },
  },

  --- DAP ---
  {
    "mfussenegger/nvim-dap",
    name = "dap",
    dependencies = { "mason" },
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mason", "dap" },
    opts = {},
    config = true,
  },

  --- Linting ---
  {
    "mfussenegger/nvim-lint",
    dependencies = { "mason" },
  },

  --- Formatter ---
  {
    "mhartington/formatter.nvim",
    dependencies = { "mason" },
    opts = {},
    config = true,
  },

  --- Autocomplete ---
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies =  {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path"
    },
    opts = {
      completion = {
        completeopt = "menu,menuone,preview,noselect",
      },
      mapping = {
      },
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,preview,noselect",
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" }
        })
      })
    end,
  }
}
