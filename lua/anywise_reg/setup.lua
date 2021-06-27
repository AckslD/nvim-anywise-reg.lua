local M = {}
local config = require("anywise_reg.config")
local autocmds = require("anywise_reg.autocmds")  -- TODO can relative import be used?
local keybinds = require("anywise_reg.keybinds")

M.setup = function(opts)
    config.register_opts(opts)
    autocmds.setup_auto_command()
    keybinds.setup_default_keymaps()
end

return M
