return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      codelens = { enabled = true },
      servers = {
        ocamllsp = {
          mason = false,
          settings = {
            codelens = { enable = true },
            extendedHover = { enable = true },
            duneDiagnostics = { enable = true },
            syntaxDocumentation = { enable = true },
            merlinJumpCodeActions = { enable = true },
            inlayHints = {
              enable = true,
              hintPatternVariables = true,
              hintLetBindings = true,
              hintFunctionParams = true,
            },
          },
        },
      },
      setup = {
        ocamllsp = function(_, _)
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            pattern = { "*.ml", "*.mli" },
            callback = function()
              vim.lsp.codelens.enable()
            end,
          })
        end,
      },
    },
  },
  {
    "tarides/ocaml.nvim",
    ft = { "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune" },
    opts = {},
  },
}
