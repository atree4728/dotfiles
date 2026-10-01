return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        hls = { enabled = false },
      },
    },
  },
  {
    "mrcjkb/haskell-tools.nvim",
    version = "^10",
    keys = {
      {
        "<leader>hs",
        function()
          require("haskell-tools").hoogle.hoogle_signature()
        end,
        ft = "haskell",
        desc = "Hoogle Signature",
      },
      {
        "<leader>ea",
        function()
          require("haskell-tools").lsp.buf_eval_all()
        end,
        ft = "haskell",
        desc = "Evaluate All",
      },
      {
        "<leader>rr",
        function()
          require("haskell-tools").repl.toggle()
        end,
        ft = "haskell",
        desc = "REPL (Package)",
      },
      {
        "<leader>rf",
        function()
          require("haskell-tools").repl.toggle(vim.api.nvim_buf_get_name(0))
        end,
        ft = "haskell",
        desc = "REPL (Buffer)",
      },
      {
        "<leader>rq",
        function()
          require("haskell-tools").repl.quit()
        end,
        ft = "haskell",
        desc = "REPL Quit",
      },
    },
  },
}
