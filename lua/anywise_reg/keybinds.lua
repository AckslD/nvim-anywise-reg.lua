local M = {}
local config = require('anywise_reg.config').config
local handlers = require('anywise_reg.handlers')
local feedkeys = require('anywise_reg.cmd').feedkeys

local function set_keymap(lhs, rhs)
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

M.perform_action = function(prefix, operator, textobject)
    handlers.before_action()
    feedkeys(prefix..operator..remap(textobject))
    handlers.handle_action(prefix, operator, textobject)
end

local function setup_yank_keymaps(prefix)
    for _, operator in ipairs(config.operators) do
        for _, textobject in ipairs(config.textobjects) do
            local lhs = prefix..operator..textobject
            local rhs = '<Cmd>lua require("anywise_reg.keybinds").perform_action('
                .. format_str_args({prefix, operator, textobject})
                .. ')<CR>'
            set_keymap(lhs, rhs)
        end
    end
end

local function setup_paste_keymaps(prefix, key, operator)
    local lhs = prefix .. key
    local rhs = '<Cmd>lua require("anywise_reg.handlers").handle_paste('
        .. format_str_args({ prefix, operator })
        .. ')<CR>'
    set_keymap(lhs, rhs)
end

M.setup_keymaps = function()
    local prefixes = { "", '""' }
    for i = 1, 9 do
        table.insert(prefixes, '"' .. string.format("%d", i))
    end
    for c = 97, 122 do
        table.insert(prefixes, '"' .. string.char(c))
    end
    for _, prefix in ipairs(prefixes) do
        setup_yank_keymaps(prefix)
        for key, operator in pairs(config.paste_keys) do
            setup_paste_keymaps(prefix, key, operator)
        end
    end
end

return M
