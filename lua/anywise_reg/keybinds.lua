local M = {}
local config = require('anywise_reg.config').config
local handlers = require('anywise_reg.handlers')
local normal = require('anywise_reg.cmd').normal

local function set_keymap(lhs, rhs)
    -- local opts = {noremap = false}
    local opts = {noremap = true}
    local mode = 'n'
    vim.api.nvim_buf_set_keymap(
        0,
        mode,
        lhs,
        rhs,
        opts
    )
end

local function format_str_args(str_args)
    local args_str = ''
    for _, str_arg in ipairs(str_args) do
        args_str = args_str..[[']]..str_arg..[[', ]]
    end
    return args_str:sub(1, -3)
end

local function remap(lhs)
    local rhs = vim.fn.maparg(lhs, 'o')
    if rhs == '' then
        return lhs
    else
        return rhs
    end
end

local current_textobject_keymaps = {}

local function save_current_textobject_keymap(buf, textobject)
    local current_rhs = remap(textobject)
    if current_rhs ~= textobject then
        current_textobject_keymaps[buf][textobject] = current_rhs
    end
end

local function save_current_textobject_keymaps()
    local buf = vim.api.nvim_get_current_buf()
    if current_textobject_keymaps[buf] == nil then
        current_textobject_keymaps[buf] = {}
    end
    for _, textobject in ipairs(config.textobjects) do
        save_current_textobject_keymap(textobject)
    end
end

local function remapped_textobject(textobject)
    local buf = vim.api.nvim_get_current_buf()
    local current_rhs = current_textobject_keymaps[buf][textobject]
    if current_rhs == nil then
        return textobject
    else
        return current_rhs
    end
end

M.perform_action = function(prefix, operator, textobject)
    handlers.before_action()
    print('normal', prefix..operator..remapped_textobject(textobject))
    normal(prefix..operator..remapped_textobject(textobject))
    handlers.handle_action(prefix, operator, textobject)
end

local function setup_yank_keymaps(prefix)
    for _, operator in ipairs(config.operators) do
        for _, textobject in ipairs(config.textobjects) do
            local lhs = prefix..operator..textobject
            local rhs = '<Cmd>lua require("anywise_reg.keybinds").perform_action('..format_str_args({prefix, operator, textobject})..')<CR>'
            set_keymap(lhs, rhs)
        end
    end
end

local function setup_paste_keymaps(prefix)
    local lhs = prefix..config.paste_key
    local rhs = '<Cmd>lua require("anywise_reg.handlers").handle_paste(\''..prefix..'\')<CR>'
    set_keymap(lhs, rhs)
end

local function setup_keymaps_for_prefix(prefix)
    setup_yank_keymaps(prefix)
    setup_paste_keymaps(prefix)
end

M.setup_keymaps = function()
    save_current_textobject_keymaps()
    if config.paste_key ~= nil then
        local prefixes = {'', '""'}
        for i=1,9 do
            table.insert(prefixes, '"'..string.format("%d", i))
        end
        for c=97,122 do
            table.insert(prefixes, '"'..string.char(c))
        end
        for _, prefix in ipairs(prefixes) do
            setup_keymaps_for_prefix(prefix)
        end
    end
end

return M
