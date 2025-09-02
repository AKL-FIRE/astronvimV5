local M = {}

-- get the os name {"mac" or "linux" or "win"}
function M.get_os()
  local os
  if vim.fn.has "mac" == 1 then
    os = "mac"
  elseif vim.fn.has "unix" == 1 then
    os = "linux"
    if vim.fn.has "wsl" == 1 then os = os .. "-wsl" end
  elseif vim.fn.has "win32" == 1 then
    os = "win"
  else
    require("astrocore").notify("not valid os", vim.log.levels.ERROR)
  end
  return os
end

-- get current buf relative path
function M.get_buf_parent_directory_relative_path()
  local current_buf = vim.api.nvim_get_current_buf()
  local current_buf_name = vim.api.nvim_buf_get_name(current_buf)
  local relative_path = vim.fn.fnamemodify(current_buf_name, ":~:.")
  local parent_directory = vim.fn.fnamemodify(relative_path, ":h")
  return parent_directory
end

-- wsl clipboard provider config
function M.set_wsl_clipboard()
  local g = vim.g
  if M.get_os() == "linux-wsl" then
    local clipboard = {}
    local copy = {}
    copy["+"] = "clip.exe"
    copy["*"] = "clip.exe"
    local paste = {}
    paste["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))'
    paste["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))'
    clipboard["name"] = "'WslClipboard'"
    clipboard["copy"] = copy
    clipboard["paste"] = paste
    clipboard["cache_enabled"] = 0
    g.clipboard = clipboard
  end
end

-- osc52 clipboard provider config
function M.set_osc52_clipboard()
  local function copy(lines, _) require("osc52").copy(table.concat(lines, "\n")) end
  local function paste() return { vim.fn.split(vim.fn.getreg "", "\n"), vim.fn.getregtype "" } end
  vim.g.clipboard = {
    name = "osc52",
    copy = { ["+"] = copy, ["*"] = copy },
    paste = { ["+"] = paste, ["*"] = paste },
  }
end

-- set_component_left set heirline component on the left side of the statusline
function M.set_component_left(opts, component)
  local index = 1
  for i, v in ipairs(opts.statusline) do
    if v.provider == "%=" then
      index = i
      break
    end
  end
  local origin_provider = component.provider
  if origin_provider then
    local new_provider = function(self) return " " .. origin_provider(self) end
    component.provider = new_provider
  end
  table.insert(opts.statusline, index, component)
end

-- set_component_right set heirline component on the right side of the statusline
function M.set_component_right(opts, component)
  local index = 1
  for i = #opts.statusline, 1, -1 do
    if opts.statusline[i].provider == "%=" then
      index = i + 1
      break
    end
  end
  local origin_provider = component.provider
  if origin_provider then
    local new_provider = function(self) return " " .. origin_provider(self) end
    component.provider = new_provider
  end
  table.insert(opts.statusline, index, component)
end

-- get_current_buf_filetype get current open buf filetype
function M.get_current_buf_filetype()
  local bufnr = vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(bufnr) then return "" end
  local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
  return ft
end

return M
