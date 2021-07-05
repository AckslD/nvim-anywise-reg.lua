local M = {}

M.config = {
    operators = {},
    textobjects = {},
    paste_keys = {},
    register_print_cmd = false
}

local function product(textobjects)
    if textobjects[1] == nil then
        return {''}
    end
    local textobject = table.remove(textobjects, 1)
    local expanded_textobjects = product(textobjects)
    local new_expanded_textobjects = {}
    for _, start in ipairs(textobject) do
        for _, rest in ipairs(expanded_textobjects) do
            table.insert(new_expanded_textobjects, start..rest)
        end
    end
    return new_expanded_textobjects
end

local function expand_textobjects()
    local textobjects = M.config.textobjects
    for i, textobject in ipairs(textobjects) do
        if type(textobject) == "string" then
            textobjects[i] = {textobject}
        end
    end
    M.config.textobjects = product(textobjects)
end

M.register_opts = function(opts)
    if opts == nil then
        opts = {}
    end
    for key, value in pairs(opts) do
        M.config[key] = value
    end

    expand_textobjects()
end

return M
