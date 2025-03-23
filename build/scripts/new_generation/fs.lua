local ffi = require "ffi"
local lfs = require "lfs"

ffi.cdef [[
  char *realpath(const char *path, char *resolved_path);
]]

local M = {}

---Calculates the full path for a relative path.
---@param relative_path string
---@return string
function M.real_path(relative_path)
  return ffi.string(ffi.C.realpath(relative_path, nil))
end

---Returns a path to the parent directory of a file or a directory.
---If provided path isn't a valid path then returns nil.
---@param path string a valid path to a file or a directory.
---@return string? parent_dir_path a full path to the parent directory.
function M.parent_dir(path)
  local start_index, end_index = string.find(path, "^([%Z]*/)")

  if not start_index then
    if string.find(path, "^/[%Z]/?$") then
      return "/"
    else
      return "Not a valid path"
    end
  end

  ---@cast start_index -nil
  ---@cast end_index -nil
  return string.sub(path, start_index, end_index)
end

---Check whether a provided path is a directory path
---If the path isn't a valid path then nil returns.
---@param path string the path
---@return boolean?
function M.is_directory_path(path)
  local mode = lfs.attributes(path, "mode")
  if not mode then
    return nil
  end
  return mode == "directory"
end

---Check whether a provided path is a file path
---If the path isn't a valid path then nil returns.
---@param path string the path
---@return boolean?
function M.is_file_path(path)
  local mode = lfs.attributes(path, "mode")
  if not mode then
    return nil
  end
  return mode == "file"
end

return M
