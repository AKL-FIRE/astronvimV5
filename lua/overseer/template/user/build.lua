local overseer = require "overseer"

---@type overseer.TemplateFileDefinition
return {
  name = "default build",
  params = {
    cwd = {
      optional = true,
      default = vim.fn.getcwd(),
    },
    args = {
      optional = true,
      type = "list",
      delimiter = " ",
    },
  },
  condition = {
    callback = function() return vim.fn.filereadable(vim.fn.getcwd() .. "/build.sh") == 1 end,
  },
  builder = function(params)
    return {
      cmd = { "bash", params.cwd .. "/build.sh" },
      cwd = params.cwd,
      args = params.args,
    }
  end,
  desc = "Use build.sh to build project",
  tags = { overseer.TAG.BUILD },
}
