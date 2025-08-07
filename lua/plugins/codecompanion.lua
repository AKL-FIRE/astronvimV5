if false then
  return {}
else
  ---@type LazySpec
  return {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions", "CodeCompanionCmd" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        lazy = true,
        opts = function(_, opts)
          opts.file_types = require("astrocore").list_insert_unique(opts.file_types, { "codecompanion" })
        end,
      },
      { "echasnovski/mini.diff", opts = {} },
      { "franco-ruggeri/codecompanion-spinner.nvim" },
      {
        "AstroNvim/astrocore",
        ---@param opts AstroCoreOpts
        opts = function(_, opts)
          local maps = opts.mappings
          maps.n["<leader>a"] = { desc = "󰚩 " .. "AI" }
          maps.v["<leader>a"] = { desc = "󰚩 " .. "AI" }
          maps.n["<leader>at"] = { "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle code companion" }
          maps.v["<leader>at"] = { "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle code companion" }
          maps.n["<leader>aa"] = { "<cmd>CodeCompanionActions<cr>", desc = "code companion actions" }
          maps.v["<leader>aa"] = { "<cmd>CodeCompanionActions<cr>", desc = "code companion actions" }
          maps.v["ga"] = { "<cmd>codecompanionAdd<cr>", desc = "add selected content as chat context" }
        end,
      },
    },
    opts = {
      adapters = {
        openrouter = function() return require "others.openrouter" end,
        opts = {
          -- proxy = "http://localhost:10086",
        },
      },
      strategies = {
        chat = {
          adapter = "openrouter",
          tools = {
            opts = {
              auto_submit_success = true,
            },
          },
        },
        inline = {
          adapter = "openrouter",
          keymaps = {
            reject_change = {
              modes = {
                n = "gR",
              },
            },
          },
        },
        agent = {
          adapter = "openrouter",
        },
        cmd = {
          adapter = "openrouter",
        },
      },
      display = {
        chat = {
          render_headers = false,
          show_settings = true, -- Show LLM settings at the top of the chat buffer?
          show_token_count = true, -- Show the token count for each response?
          start_in_insert_mode = true,
        },
        diff = {
          provider = "mini_diff",
        },
      },
      opts = {
        log_level = "ERROR",
        language = "中文",
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
        spinner = {},
      },
    },
  }
end
