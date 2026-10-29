return {
  "mrcjkb/rustaceanvim",
  opts = {
    server = {
      default_settings = {
        -- rust-analyzer language server configuration
        ["rust-analyzer"] = {
          check = {
            command = "clippy",
            extraArgs = { "--no-deps" },
            features = {},
          },
          -- Enable diagnostics if using rust-analyzer
          diagnostics = {
            disabled = { "inactive_code" },
          },
        },
      },
    },
  },
}
