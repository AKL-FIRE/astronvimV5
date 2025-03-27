---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    options = {
      opt = { -- configure vim.opt options
        -- configure font
        guifont = "FiraCode Nerd Font,Hack Nerd Font:h16",
      },
      g = { -- configure variables
        -- configure scaling
        neovide_scale_factor = 1.0,
        -- configure padding
        neovide_padding_top = 0,
        neovide_padding_bottom = 0,
        neovide_padding_right = 0,
        neovide_padding_left = 0,
        -- 没有空闲
        neovide_no_idle = true,
        -- 退出需要确认
        neovide_confirm_quit = true,
        -- 是否全屏
        neovide_fullscreen = false,
        -- 记住以前窗口的大小
        neovide_remember_window_size = true,
        -- 使用super键位,比如<cmd>
        -- neovide_input_use_logo = true
        -- 开启Alt和Meta按键
        -- neovide_input_macos_alt_is_meta = true,
        -- 触控板死亡地带
        -- neovide_touch_deadzone = 6.0
        -- 触控板拖动超时
        -- neovide_touch_drag_timeout = 0.17
        -- 开启轨道动画
        neovide_cursor_vfx_mode = "railgun",
        -- 设置刷新率
        neovide_refresh_rate = 60,
        -- 空闲刷新率
        neovide_refresh_rate_idle = 5,
      },
    },
  },
}
