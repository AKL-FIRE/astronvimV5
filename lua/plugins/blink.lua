return { -- override blink.cmp plugin
  "Saghen/blink.cmp",
  opts = {
    completion = {
      documentation = {
        auto_show = true,
      },
    },
    signature = {
      enabled = true,
      trigger = {
        show_on_insert = true,
      },
    },
    cmdline = {
      completion = {
        menu = {
          auto_show = true,
        },
      },
    },
  },
}
