local M = {}
local config = require('anywise_reg.config')
local autocmds = require('anywise_reg.autocmds') -- TODO can relative import be used?
local cmd = require('anywise_reg.cmd')

M.setup = function(opts)
    config.register_opts(opts)
    autocmds.setup_auto_command()
    cmd.setup_commands()
end

return M
