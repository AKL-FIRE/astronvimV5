return {
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
      {
        "rebelot/heirline.nvim",
        opts = function(_, opts)
          local mcphub = {
            static = {
              servers = 0,
              status = "starting",
            },
            update = {
              "User",
              pattern = "MCPHubStateChange",
              callback = function(self, args)
                if args.data then
                  self.servers = args.data.active_servers
                  self.status = args.data.state
                end
                vim.cmd "redrawstatus"
              end,
            },
            provider = function(self)
              local status = self.status == nil and "unknown" or self.status
              local count = self.servers == nil and 0 or self.servers
              return "󰐻" .. " " .. status .. " " .. count
            end,
            hl = function(self)
              local is_connected = self.status == "ready" or self.status == "restarted"
              local is_connecting = self.status == "starting" or self.status == "restarting"
              return is_connected and "DiagnosticInfo" or is_connecting and "DiagnosticWarn" or "DiagnosticError"
            end,
          }
          require("utils").set_component_right(opts, mcphub)
          return opts
        end,
      },
    },
    -- uncomment the following line to load hub lazily
    cmd = "MCPHub", -- lazy load
    build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
    -- uncomment this if you don't want mcp-hub to be available globally or can't use -g
    -- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
    config = function() require("mcphub").setup() end,
  },
}
