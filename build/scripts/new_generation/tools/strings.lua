---Wraps provided string in double quotes.
---@param str string
---@return string
function string.quote(str)
  return "\"" .. str .. "\""
end

local M = {}

return M
