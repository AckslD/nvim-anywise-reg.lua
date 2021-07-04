local M = {}
local config = require("anywise_reg.config").config

local replace_termcodes = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

M.normal = function(str, opts)
    if opts == nil then
        opts = {noremap = true}
    end
    local flag = ''
    if opts.noremap == true then
        flag = '!'
    end
    print('cmd', replace_termcodes("normal"..flag.." "..str))
    vim.cmd(replace_termcodes("normal"..flag.." "..str))
end

M.setup_commands = function()
    if config.register_print_cmd then
        vim.cmd('command! RegData lua require("anywise_reg.data").print_reg_data()')
    end
end

return M
