return {
  name = "restart-lsp",
  builder = function()
    vim.cmd.LspRestart()
    return {
      cmd = { "echo" },
      args = { "succ" },
    }
  end,
}
