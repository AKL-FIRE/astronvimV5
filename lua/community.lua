-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- lsp pack
  { import = "astrocommunity.pack.lua" },
  vim.fn.executable "go" == 1 and { import = "astrocommunity.pack.go" } or {},
  vim.fn.executable "thrift" == 1 and { import = "astrocommunity.pack.thrift" } or {},
  vim.fn.executable "protoc" == 1 and { import = "astrocommunity.pack.proto" } or {},
  vim.fn.executable "npm" == 1 and { import = "astrocommunity.pack.html-css" } or {},
  vim.fn.executable "npm" == 1 and { import = "astrocommunity.pack.tailwindcss" } or {},
  vim.fn.executable "npm" == 1 and { import = "astrocommunity.pack.typescript" } or {},
  vim.fn.executable "npm" == 1 and { import = "astrocommunity.pack.json" } or {},
  vim.fn.executable "npm" == 1 and { import = "astrocommunity.pack.yaml" } or {},
  vim.fn.executable "npm" == 1 and { import = "astrocommunity.pack.prisma" } or {},
  (vim.fn.executable "python" == 1 or vim.fn.executable "python3" == 1) and { import = "astrocommunity.pack.python" }
    or {},
  (vim.fn.executable "gcc" == 1 or vim.fn.executable "clang" == 1) and { import = "astrocommunity.pack.cpp" } or {},
  vim.fn.executable "cmake" == 1 and { import = "astrocommunity.pack.cmake" } or {},
  vim.fn.executable "rustc" == 1 and { import = "astrocommunity.pack.rust" } or {},
  vim.fn.executable "bash" == 1 and { import = "astrocommunity.pack.bash" } or {},
  vim.fn.executable "javac" == 1 and { import = "astrocommunity.pack.java" } or {},

  -- editting
  { import = "astrocommunity.editing-support.nvim-devdocs" },
  { import = "astrocommunity.editing-support.vim-visual-multi" },

  -- find and replace
  { import = "astrocommunity.search.grug-far-nvim" },

  -- motion
  { import = "astrocommunity.motion.nvim-surround" },
  { import = "astrocommunity.motion.flash-nvim" },

  -- test
  { import = "astrocommunity.test.neotest" },
}
