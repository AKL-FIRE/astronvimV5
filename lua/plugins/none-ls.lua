-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize None-ls sources

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    -- opts variable is the default configuration table for the setup function call
    -- local null_ls = require "null-ls"

    -- Check supported formatters and linters
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics

    -- Only insert new sources, do not replace the existing ones
    -- (If you wish to replace, use `opts.sources = {}` instead of the `list_insert_unique` function)
    -- opts.sources = require("astrocore").list_insert_unique(opts.sources, {
    -- Set a formatter
    -- null_ls.builtins.formatting.stylua,
    -- null_ls.builtins.formatting.prettier,
    -- })
    local null_ls = require "null-ls"

    -- Check supported formatters and linters
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    opts.sources = require("astrocore").list_insert_unique(opts.sources, {
      -- go
      null_ls.builtins.diagnostics.golangci_lint.with {
        timeout = 180000,
        method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
        extra_args = function(_)
          local relative_path = require("utils").get_buf_parent_directory_relative_path()
          return { relative_path }
        end,
      },

      -- refactory
      null_ls.builtins.code_actions.refactoring,
    })
    return opts -- return final config table
  end,
}
