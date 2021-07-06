local M = {
    reg_data = {},
    will_handle_action = nil,
}

local function shift_num_regs()
    for i = 8, 1, -1 do
        M.reg_data[string.format('%d', i + 1)] = M.reg_data[string.format('%d', i)]
    end
end

local function update_reg_data(reg_name, content)
    local operator = content.operator
    if content.textobject == nil then
        content = nil
    end
    -- NOTE we do this first since if the reg_name is [1,9]
    -- then the numbered registers are actually shifted after
    M.reg_data[reg_name] = content
    if reg_name ~= '"' then
        M.reg_data['"'] = content -- always update unnamed
    end
    if operator == 'y' then
        if reg_name ~= '0' then
            M.reg_data['0'] = content -- always update 0 on yank
        end
    elseif string.match('cd', operator) ~= nil then
        -- TODO this doesn't do the right thing for `x` (and maybe `s`) since these
        -- don't update the numbered register it seems. Not sure how one can know
        -- this from TextYankPost. So the numbered registers will be wrong after doing
        -- `x` or `s`.
        shift_num_regs()
        if reg_name ~= '1' then
            M.reg_data['1'] = content -- always update 1 on delete/change
        end
    end
end

M.update_reg_data = function(reg_name, operator, textobject)
    update_reg_data(reg_name, { operator = operator, textobject = textobject })
end

M.print_reg_data = function()
    print(vim.inspect(M.reg_data))
end

return M
