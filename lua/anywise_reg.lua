local M = {}
M.test_str = "some here word other"  -- TODO remove

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

local function setup_default_keymaps()
    -- local lhs = 'daw'
    -- local rhs = lhs..'<Cmd>lua require("anywise_reg").handle_action("'..lhs..'")<CR>'
    -- set_keymap(lhs, rhs)

    local lhs = 'p'
    local rhs = '<Cmd>lua require("anywise_reg").handle_paste("'..lhs..'")<CR>'
    set_keymap(lhs, rhs)
end

local function get_reg_name(action)
    if action[1] == '"' then
        return action[2]
    else
        return '"'
    end
end

local reg_actions = {}

local function update_reg_actions(action)
    local reg = get_reg_name(action)
    reg_actions[reg] = action
end

local function get_reg_action(paste_action)
    local reg = get_reg_name(paste_action)
    return reg_actions[reg]
end

local function assert_second_to_last_string_entry_matches(str, match)
    assert(string.match(match, str:sub(-2, -2)) ~= nil)
end

local function assert_valid_action(action)
    assert_second_to_last_string_entry_matches(action, 'ia')
end

M.handle_action = function(action)
    assert_valid_action(action)
    print("handling action: ", action)
    update_reg_actions(action)
end

M.handle_paste = function(paste_action)
    print("handling paste: ", paste_action)
    local reg_action = get_reg_action(paste_action)
    if reg_action ~= nil then
        -- go to end of current text object
        normal('v'..reg_action:sub(-2), {noremap = false})
        normal('<Esc>')
    end
    normal('p')
end

M.handle_yank_post = function()
    local e = vim.v.event
    if e.visual then
        return -- TODO update numbered?
    end
    local op = e.operator
    local reg = e.regname
    if reg == '' then
        reg = '"'
    end
    print("handling operator", op, "with reg", reg)
    print(vim.v.event.inclusive)
    print(vim.v.event.operator)
    print(vim.v.event.regcontents)
    for k, v in pairs(vim.v.event.regcontents) do
        print(k, v)
    end
    print(vim.v.event.regname)
    print(vim.v.event.regtype)
    print(vim.v.event.visual)
end

local function setup_auto_command()
    vim.cmd('autocmd TextYankPost * :lua require("anywise_reg").handle_yank_post()')
end

M.setup = function()
    setup_auto_command()
    setup_default_keymaps()
end

return M
