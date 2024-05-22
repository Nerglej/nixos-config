return {
  "folke/trouble.nvim",
  branch = "dev",
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
  },
}
