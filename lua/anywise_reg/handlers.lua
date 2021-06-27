local M = {}
local cmd = require("anywise_reg.cmd")
local data = require("anywise_reg.data")

M.handle_action = function(operator, textobject)
    data.update_reg_data(operator, textobject)
end

local function get_register(prefix)
    if prefix == '' then
        return '"'
    end
    return string.sub(prefix, 2, 3)
end

M.handle_paste = function(prefix)
    local reg = get_register(prefix)
    local d = data.reg_data[reg]
    if d ~= nil then
        -- go to end of current text object
        cmd.normal('v'..d.textobject, {noremap = false})
        cmd.normal('<Esc>')
    end
    cmd.normal('p')
end

M.handle_yank_post = function()
    data.last_reg_name = vim.v.event.regname
end

return M
