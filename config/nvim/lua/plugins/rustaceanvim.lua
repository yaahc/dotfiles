return {
  "mrcjkb/rustaceanvim",
  opts = {
    server = {
      default_settings = {
        -- rust-analyzer language server configuration
        ["rust-analyzer"] = {
          -- Enable diagnostics if using rust-analyzer
          diagnostics = {
            disabled = { "inactive_code" },
          },
        },
      },
    },
  },
}
