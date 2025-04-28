if false then
  return {}
else
  ---@type LazySpec
  return {
    "olimorris/codecompanion.nvim",
    event = 'User AstroFile',
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
      {
        "rebelot/heirline.nvim",
        opts = function(_, opts)
          local CodeCompanion = {
            static = {
              processing = false,
            },
            update = {
              "User",
              pattern = "CodeCompanionRequest*",
              callback = function(self, args)
                if args.match == "CodeCompanionRequestStarted" then
                  self.processing = true
                elseif args.match == "CodeCompanionRequestFinished" then
                  self.processing = false
                end
                vim.cmd "redrawstatus"
              end,
            },
            {
              condition = function(self) return self.processing end,
              provider = " ",
              hl = { fg = "yellow" },
            },
          }
          require("utils").set_component_left(opts, CodeCompanion)
          return opts
        end,
      },
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
        openrouter = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "https://openrouter.ai/api",
              api_key = "OPENROUTER_API_KEY",
              chat_url = "/v1/chat/completions",
            },
            schema = {
              model = {
                default = "anthropic/claude-3.7-sonnet",
                choices = {
                  "anthropic/claude-3.7-sonnet",
                  "anthropic/claude-3.5-sonnet",
                  "deepseek/deepseek-chat-v3-0324",
                  "deepseek/deepseek-r1",
                },
              },
            },
          })
        end,
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "claude-3.5-sonnet",
              },
              max_tokens = {
                default = 8192,
              },
            },
          })
        end,
        opts = {
          -- proxy = "http://localhost:10086",
        },
      },
      strategies = {
        chat = {
          adapter = "openrouter",
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
    },
  }
end
