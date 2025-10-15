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
      {
        "rebelot/heirline.nvim",
        opts = function(_, opts)
          local IsCodeCompanion = function() return package.loaded.codecompanion and vim.bo.filetype == "codecompanion" end
          local CodeCompanionCurrentContext = {
            static = {
              enabled = true,
            },
            condition = function(self)
              return IsCodeCompanion() and _G.codecompanion_current_context ~= nil and self.enabled
            end,
            provider = function()
              local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(_G.codecompanion_current_context), ":t")
              local metadata = _G.codecompanion_chat_metadata
                and _G.codecompanion_chat_metadata[vim.api.nvim_get_current_buf()]
              local adapter = metadata and metadata.adapter or nil
              local adapter_name = adapter and adapter.name or "unknown"
              local model = adapter and adapter.model or "unknown"
              return "[  " .. bufname .. " ]" .. " [ " .. adapter_name .. " - " .. model .. " ] "
            end,
            hl = { fg = "gray", bg = "bg" },
            update = {
              "User",
              pattern = {
                "CodeCompanionRequest*",
                "CodeCompanionContextChanged",
                "CodeCompanionChatAdapter",
                "CodeCompanionChatModel",
              },
              callback = vim.schedule_wrap(function(self, args)
                if args.match == "CodeCompanionRequestStarted" then
                  self.enabled = false
                elseif args.match == "CodeCompanionRequestFinished" then
                  self.enabled = true
                end
                vim.cmd "redrawstatus"
              end),
            },
          }
          require("utils").set_component_right(opts, CodeCompanionCurrentContext)
        end,
      },
    },
    opts = {
      adapters = {
        http = {
          openrouter = function() return require "others.openrouter" end,
          opts = {
            -- proxy = "http://localhost:10086",
            show_model_choices = true,
          },
        },
      },
      strategies = {
        chat = {
          adapter = "copilot",
          tools = {
            opts = {
              auto_submit_success = true,
            },
          },
        },
        inline = {
          adapter = "copilot",
          keymaps = {
            reject_change = {
              modes = {
                n = "gR",
              },
            },
          },
        },
        agent = {
          adapter = "copilot",
        },
        cmd = {
          adapter = "copilot",
        },
      },
      display = {
        chat = {
          render_headers = false,
          show_settings = false, -- Show LLM settings at the top of the chat buffer?
          show_token_count = true, -- Show the token count for each response?
          start_in_insert_mode = true,
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
