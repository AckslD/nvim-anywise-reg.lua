local M = {
    reg_data = {},
    last_reg_name = nil,
    will_handle_action = nil,
}

local function pop_last_reg_name()
    local reg_name = M.last_reg_name
    print('reg_name', reg_name)
    M.last_reg_name = nil
    return reg_name
end

M.update_reg_data = function(operator, textobject)
    local reg_name = pop_last_reg_name()
    print('reg_name', reg_name)
    M.reg_data[reg_name] = {operator = operator, textobject = textobject}
end

M.reset_reg_data = function(reg_name)
    M.reg_data[reg_name] = nil
end

M.print_reg_data = function()
    print(vim.inspect(M.reg_data))
end

return M
