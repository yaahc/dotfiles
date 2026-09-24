return {
  "nvim-telescope/telescope.nvim",
  opts = function(_, opts)
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    local function select_or_qflist(prompt_bufnr)
      local picker = action_state.get_current_picker(prompt_bufnr)
      if #picker:get_multi_selection() > 0 then
        actions.send_selected_to_qflist(prompt_bufnr)
        actions.open_qflist(prompt_bufnr)
        vim.cmd("cfirst")
      else
        actions.select_default(prompt_bufnr)
      end
    end

    opts.defaults = opts.defaults or {}
    opts.defaults.mappings = vim.tbl_deep_extend("force", opts.defaults.mappings or {}, {
      i = { ["<CR>"] = select_or_qflist },
      n = { ["<CR>"] = select_or_qflist },
    })
  end,
}
