local M = {}

M.setup_auto_command = function()
    vim.cmd('autocmd TextYankPost * :lua require("anywise_reg.handlers").handle_yank_post()')
end

return M
