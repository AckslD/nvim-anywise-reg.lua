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
    local lhs = 'daw'
    local rhs = lhs..'<Cmd>lua require("anywise_reg").handle_action("'..lhs..'")<CR>'
    set_keymap(lhs, rhs)

    lhs = 'p'
    rhs = '<Cmd>lua require("anywise_reg").handle_paste("'..lhs..'")<CR>'
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
    -- go to end of current text object
    normal('v'..reg_action:sub(-2), {noremap = false})
    normal('<Esc>p')
end

M.setup = function()
    -- setup_default_keymaps()
end

return M
