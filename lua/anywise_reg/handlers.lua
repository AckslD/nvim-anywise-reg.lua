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

M.handle_paste_behind = function(prefix)
    local reg = get_register(prefix)
    local d = data.reg_data[reg]
    if d ~= nil then
        -- go to start of current text object
        cmd.normal('v' .. d.textobject, {noremap = false})
        cmd.normal('o<Esc>')
    end
    cmd.normal(prefix .. 'P')
end

M.handle_paste = function(prefix, operator)
    local reg = get_register(prefix)
    local d = data.reg_data[reg]
    if d ~= nil then
        -- go to end of current text object
        cmd.normal('v' .. d.textobject, {noremap = false})
        cmd.normal('<Esc>')
    end
    cmd.normal(prefix .. operator)
end

M.handle_yank_post = function()
    local reg_name = vim.v.event.regname
    local operator = vim.v.event.operator
    if reg_name == '' then
        reg_name = '"'
    end
    if not data.will_handle_action then
        data.update_reg_data(reg_name, operator, nil)
    end
    data.will_handle_action = nil
end

return M
