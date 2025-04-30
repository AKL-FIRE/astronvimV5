local overseer = require "overseer"
return {
  name = "default build",
  condition = {
    callback = function(search) return vim.fn.filereadable(vim.fn.getcwd() .. "/build.sh") end,
  },
  builder = function()
    local workspace_path = vim.fn.getcwd()
    return {
      cmd = { "bash", workspace_path .. "/build.sh" },
      cwd = workspace_path,
    }
  end,
  desc = "Use build.sh to build project",
  tags = { overseer.TAG.BUILD },
}
