---@type LazySpec
return {
  "stevearc/overseer.nvim",
  cmd = {
    "OverseerOpen",
    "OverseerClose",
    "OverseerToggle",
    "OverseerSaveBundle",
    "OverseerLoadBundle",
    "OverseerDeleteBundle",
    "OverseerRunCmd",
    "OverseerRun",
    "OverseerInfo",
    "OverseerBuild",
    "OverseerQuickAction",
    "OverseerTaskAction ",
    "OverseerClearCache",
  },
  opts = {
    templates = { "builtin", "user.restart_lsp" },
  },
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["<leader>X"] = { desc = " " .. "Task" },
            ["<leader>Xr"] = { "<cmd>:OverseerRun<cr>", desc = "Run task" },
            ["<leader>Xt"] = { "<cmd>:OverseerToggle<cr>", desc = "Toggle task log" },
          }
        }
      }
    }
  },
  specs = {
    {
      "rebelot/heirline.nvim",
      opts = function(_, opts)
        local Spacer = { provider = " " }
        local function rpad(child)
          return {
            condition = child.condition,
            child,
            Spacer,
          }
        end
        local function OverseerTasksForStatus(status)
          return {
            condition = function(self) return self.tasks[status] end,
            provider = function(self) return string.format("%s%d", self.symbols[status], #self.tasks[status]) end,
            hl = function(_)
              return {
                fg = require("heirline.utils").get_highlight(string.format("Overseer%s", status)).fg,
              }
            end,
          }
        end
        local overseer = {
          condition = function() return package.loaded.overseer end,
          init = function(self)
            local tasks = require("overseer.task_list").list_tasks { unique = true }
            local tasks_by_status = require("overseer.util").tbl_group_by(tasks, "status")
            self.tasks = tasks_by_status
          end,
          static = {
            symbols = {
              ["CANCELED"] = " ",
              ["FAILURE"] = "󰅚 ",
              ["SUCCESS"] = "󰄴 ",
              ["RUNNING"] = "󰑮 ",
            },
          },

          rpad(OverseerTasksForStatus "CANCELED"),
          rpad(OverseerTasksForStatus "RUNNING"),
          rpad(OverseerTasksForStatus "SUCCESS"),
          rpad(OverseerTasksForStatus "FAILURE"),
        }
        require("utils").set_component_left(opts, overseer)
        return opts
      end,
    },
  },
}
