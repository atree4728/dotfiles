return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        julials = {
          -- SymbolServer bundled with julia-lsp fails to precompile on Julia 1.13
          cmd_env = { JULIAUP_CHANNEL = "1.12" },
        },
      },
    },
  },
}
