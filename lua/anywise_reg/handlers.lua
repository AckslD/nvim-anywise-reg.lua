local M = {}
local cmd = require("anywise_reg.cmd")
local data = require("anywise_reg.data")

M.handle_action = function(operator, textobject)
    data.update_reg_data(operator, textobject)
end

M.handle_paste = function()
    -- TODO for now can only handle paste from unnamed
    local reg = '"'
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
