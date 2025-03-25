require "tools.strings"

---@type string?
local git_version = nil

---@class Git
---@field get_version fun(): string?, string?
---@field clone fun(uri: string, location: string?): "success"|"fail"
local git = {
  ---Tries to get the version of git. If succeeded returns version as a string
  ---otherwise returns nil and error message.
  ---@return string? version git version or nil
  ---@return string? error_message an error message
  get_version = function()
    if git_version then
      return git_version
    end

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
    local version = string.sub(git_version_result, git_version_start, git_version_end)
    git_version = version
    ---@cast git_version string
    return git_version
  end,

  ---comment
  ---@param uri string
  ---@param location string?
  ---@return "fail"|"success"
  clone = function(uri, location)
    local command = "git clone " .. uri:quote()
    if location then
      command = command .. " " .. location:quote()
    end
    local success, clone_handler = pcall(function() return io.popen(command) end)
    if not success or not clone_handler:close() then
      return "fail"
    end

    return "success"
  end
}

local M = {}

---Returns table that represents git operations.
---If git ins't installed then returns nil
---@return Git?
function M.git()
  local version = git.get_version()
  if not version then
    return nil
  end
  return git
end

return M
