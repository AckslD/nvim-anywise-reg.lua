local M = {}
M.test_str = "yanking and pasting words functions etc without worries"  -- TODO remove

local replace_termcodes = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local normal = function(str, opts)
    if opts == nil then
        opts = {noremap = true}
    end
    local flag = ''
    if opts.noremap == true then
        flag = '!'
    end
    vim.cmd(replace_termcodes("normal"..flag.." "..str))
end

local function set_keymap(lhs, rhs)
    local opts = {noremap = false}
    local mode = 'n'
    vim.api.nvim_set_keymap(
        mode,
        lhs,
        rhs,
        opts
    )
end

local function format_str_args(str_args)
    local args_str = ''
    for _, str_arg in ipairs(str_args) do
        args_str = args_str..'"'..str_arg..'", '
    end
    return args_str:sub(1, -3)
end

local function remap(lhs)
    local rhs = vim.fn.maparg(lhs)
    if rhs == '' then
        return lhs
    else
        return rhs
    end
end

local operators = {'y', 'd', 'c'}
local text_objects = {'w', 'f'}

local function setup_default_keymaps()
    for _, operator in ipairs(operators) do
        for _, text_object in ipairs(text_objects) do
            for _, scope in ipairs({'i', 'a'}) do
                local lhs = operator..remap(scope..text_object)
                local rhs = lhs..'<Cmd>lua require("anywise_reg").handle_action('..format_str_args({operator, scope, text_object})..')<CR>'
                set_keymap(lhs, rhs)
            end
        end
    end

    local lhs = 'p'
    local rhs = '<Cmd>lua require("anywise_reg").handle_paste()<CR>'
    set_keymap(lhs, rhs)
end

local reg_data = {}
local last_reg_name

local function pop_last_reg_name()
    local reg_name = last_reg_name
    last_reg_name = nil
    if reg_name == '' then
        reg_name = '"'
    end
    return reg_name
end

local function update_reg_data(operator, scope, text_object)
    local reg_name = pop_last_reg_name()
    -- assert(reg_name ~= nil)
    reg_data[reg_name] = {operator = operator, scope = scope, text_object = text_object}
end

local function assert_valid_operator(operator)
    assert(operator:len() == 1)
    assert(table.concat(operators):match(operator) ~= nil)
end

local function assert_valid_scope(scope)
    assert(scope:len() == 1)
    assert(string.match('ia', scope) ~= nil)
end

local function assert_valid_text_object(text_object)
    assert(text_object:len() == 1)
    assert(table.concat(text_objects):match(text_object) ~= nil)
end

M.handle_action = function(operator, scope, text_object)
    assert_valid_operator(operator)
    assert_valid_scope(scope)
    assert_valid_text_object(text_object)
    -- print("handling action: ", operator..scope..text_object)
    update_reg_data(operator, scope, text_object)
end

M.handle_paste = function()
    -- TODO for now can only handle paste from unnamed
    local reg = '"'
    local d = reg_data[reg]
    -- print("handling paste for reg ", reg, vim.inspect(reg_data))
    if d ~= nil then
        -- go to end of current text object
        normal('v'..d.scope..d.text_object, {noremap = false})
        normal('<Esc>')
    end
    normal('p')
end

M.handle_yank_post = function()
    -- print(last_reg_name)
    -- assert(last_reg_name == nil)
    last_reg_name = vim.v.event.regname
    -- local e = vim.v.event
    -- if e.visual then
    --     return -- TODO update numbered?
    -- end
    -- local op = e.operator
    -- local reg = e.regname
    -- if reg == '' then
    --     reg = '"'
    -- end
    -- print("handling operator", op, "with reg", reg)
    -- print(vim.v.event.inclusive)
    -- print(vim.v.event.operator)
    -- print(vim.v.event.regcontents)
    -- for k, v in pairs(vim.v.event.regcontents) do
    --     print(k, v)
    -- end
    -- print(vim.v.event.regname)
    -- print(vim.v.event.regtype)
    -- print(vim.v.event.visual)
end

local function setup_auto_command()
    vim.cmd('autocmd TextYankPost * :lua require("anywise_reg").handle_yank_post()')
end

M.setup = function()
    setup_auto_command()
    setup_default_keymaps()
end

return M
