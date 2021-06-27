local M = {
    reg_data = {},
    last_reg_name = nil,
}

local function pop_last_reg_name()
    local reg_name = M.last_reg_name
    M.last_reg_name = nil
    if reg_name == '' then
        reg_name = '"'
    end
    return reg_name
end

M.update_reg_data = function(operator, textobject)
    local reg_name = pop_last_reg_name()
    M.reg_data[reg_name] = {operator = operator, textobject = textobject}
end

return M
