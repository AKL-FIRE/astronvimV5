return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  event = "InsertEnter",
  opts = {
    suggestion = {
      auto_trigger = true,
      keymap = {
        accept = false, -- handled by completion engine
        dismiss = "<C-x>",
      },
    },
    nes = {
      enabled = false,
      auto_trigger = true,
      keymap = {
        accept_and_goto = "<tab>", -- use tab to accept suggestion and go to next in normal mode
        dismiss = "<Esc>",
      },
    },
    server_opts_overrides = {
      settings = {
        nextEditSuggestions = {
          enabled = true,
        },
      },
    },
    filetypes = {
      ["*"] = false,
      lua = true,
      python = true,
      go = true,
      cpp = true,
      java = true,
      thrift = true,
      protobuf = true,
      json = true,
      yaml = true,
      toml = true,
    },
  },
  specs = {
    {
      "AstroNvim/astrocore",
      opts = {
        options = {
          g = {
            -- set the ai_accept function
            ai_accept = function()
              if require("copilot.suggestion").is_visible() then
                require("copilot.suggestion").accept()
                return true
              end
            end,
            copilot_proxy = "http://127.0.0.1:20122",
          },
        },
      },
    },
    {
      "Saghen/blink.cmp",
      optional = true,
      opts = function(_, opts)
        if not opts.keymap then opts.keymap = {} end
        opts.keymap["<Tab>"] = {
          "snippet_forward",
          function()
            if vim.g.ai_accept then return vim.g.ai_accept() end
          end,
          "fallback",
        }
        opts.keymap["<S-Tab>"] = { "snippet_backward", "fallback" }
      end,
    },
  },
}
