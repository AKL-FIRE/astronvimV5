return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        n = {
          -- overseer
          ["<leader>X"] = { desc = " " .. "Task" },
          ["<leader>Xr"] = { "<cmd>:OverseerRun<cr>", desc = "Run task" },
          ["<leader>Xt"] = { "<cmd>:OverseerToggle<cr>", desc = "Toggle task log" },

          -- compiler
          ["<leader>Xx"] = { "<cmd>:CompilerOpen<cr>", desc = "Open code runner" },

          -- dap
          ["<leader>dl"] = { "<cmd>:DapLoadLaunchJSON<cr>", desc = "Load launch.json" },

          -- flash
          ["<leader>j"] = {
            function() require("flash").jump() end,
            desc = "Flash",
          },
        },
      },
    },
  },
}
