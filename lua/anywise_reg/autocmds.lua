local M = {}

M.setup_auto_command = function()
    vim.cmd 'autocmd TextYankPost * :lua require("anywise_reg.handlers").handle_yank_post()'
    vim.cmd 'autocmd BufEnter * :lua require("anywise_reg.keybinds").setup_keymaps()'
end

return M
