local M = {}
function M.Class(typetbl)
    typetbl.__index = typetbl
    setmetatable(typetbl, {
        __call = function(cls, ...)
            return cls.new(...)
        end,
    })
    return typetbl
end

-- local function shallow_copy(table)
--     local copy = {}
--     for k, v in pairs(table) do
--         copy[k] = v
--     end
--     return copy
-- end

--- A Constructor Util
---@param typeclass any
---@param object any
---@return any
function M.NewInstance(typeclass, object)
    return setmetatable(object or {}, typeclass)
end

return M
