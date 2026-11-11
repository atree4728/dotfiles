return {
  {
    "lervag/vimtex",
    init = function()
      vim.g.vimtex_syntax_conceal_disable = 1
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        tex = { "tex-fmt" },
      },
    },
  },
}
