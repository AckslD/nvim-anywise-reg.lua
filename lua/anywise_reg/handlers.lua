local M = {}
local cmd = require("anywise_reg.cmd")
local data = require("anywise_reg.data")

M.before_action = function()
    data.will_handle_action = true
end

local function get_register(prefix)
    if prefix == '' then
        return '"'
    end
    return string.sub(prefix, 2, 3)
end

M.handle_action = function(prefix, operator, textobject)
    local reg_name = get_register(prefix)
    data.update_reg_data(reg_name, operator, textobject)
end

M.handle_paste = function(prefix)
    local reg = get_register(prefix)
    local d = data.reg_data[reg] -- TODO bump number regs
    if d ~= nil then
        -- go to end of current text object
        cmd.normal('v'..d.textobject, {noremap = false})
        cmd.normal('<Esc>')
    end
    cmd.normal(prefix..'p')
end

M.handle_yank_post = function()
    print(vim.inspect(vim.v.event))
    local reg_name = vim.v.event.regname
    if reg_name == '' then
        reg_name = '"'
    end
    if data.will_handle_action then
        -- data.last_reg_name = reg_name
    else
        data.reset_reg_data(reg_name) -- TODO bump number regs
    end
    data.will_handle_action = nil
end

return M
