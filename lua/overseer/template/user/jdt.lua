return {
  name = "java-build",
  builder = function()
    vim.cmd.JdtCompile()
    return { cmd = { "echo", "done" } }
  end,
  condition = {
    filetype = { "java" },
  },
}
