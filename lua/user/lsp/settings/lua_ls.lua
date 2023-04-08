return {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim", "awesome", "screen", "tag", "client", "mouse" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.stdpath "config" .. "/lua"] = true,
        },
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
