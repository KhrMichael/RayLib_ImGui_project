local fs = require "fs"

local M = {}

---Try to get git version. If succeeded returns version as a string
---otherwise returns nil and error message.
---@return string? version git version or nil
---@return string? error_message an error message
function M.get_git_version()
  local git_version_handler = io.popen("git --version")
  if not git_version_handler then
    return nil, "Failed to get git version."
  end

  ---@type string
  local git_version_result = git_version_handler:read("*l")
  assert(git_version_handler:close(), "RAWR")
  if #git_version_result == 0 then
    return nil, "git not found. Install git to continue."
  end

  local git_version_start, git_version_end = string.find(git_version_result, "%S-$")
  if not git_version_start then
    return nil, "Failed to get git version."
  end

  ---@cast git_version_end -nil
  return string.sub(git_version_result, git_version_start, git_version_end)
end

return M
