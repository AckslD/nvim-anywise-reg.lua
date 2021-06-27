local M = {}
local config = require('anywise_reg.config').config

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

M.setup_default_keymaps = function()
    for _, operator in ipairs(config.operators) do
        for _, textobject in ipairs(config.textobjects) do
            -- local lhs = operator..remap(textobject) TODO decide how to handle this
            local lhs = operator..textobject
            local rhs = lhs..'<Cmd>lua require("anywise_reg.handlers").handle_action('..format_str_args({operator, textobject})..')<CR>'
            set_keymap(lhs, rhs)
        end
    end

    if config.paste_key ~= nil then
        local lhs = config.paste_key
        local rhs = '<Cmd>lua require("anywise_reg.handlers").handle_paste()<CR>'
        set_keymap(lhs, rhs)
    end
end

return M
