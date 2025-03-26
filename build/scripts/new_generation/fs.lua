local ffi = require "ffi"
local lfs = require "lfs"

ffi.cdef [[
  char *realpath(const char *path, char *resolved_path);
]]

local M = {}

---Calculates the full path for a relative path. On any fail returns nil.
---NOTE: for some reason this produce 'segmentation fault' on incorrect path
---@param relative_path string
---@return string?
function M.real_path(relative_path)
  local succeeded, c_real_path = pcall(function()
    return ffi.C.realpath(relative_path, nil)
  end)
  if not succeeded or c_real_path == nil then
    return nil
  end
  return ffi.string(c_real_path)
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

---Determines whether a provided path is a root directory.
---@param path string a directory path
---@return boolean
function M.is_root_directory(path)
  return path:match("^/$") or path:match("^\\\\\\\\[^<>:\"/\\|?*]*\\$") or path:match("\\\\[^<>:\"/\\|?*]*\\$") or
      path:match("^[A-Za-z]:\\$")
end

---Normalizes path. Substitutes all "." and ".." with their
---real paths. Returns on success normalized path, on fail
---nil and error message.
---@param path string
---@return string?
---@return string?
function M.normalize_path(path)
  if not M.is_absolute_path(path) then
    local current_dir_path = M.real_path(".")
    if not current_dir_path then
      error("RAWR: " .. "failed to get absolute path of \".\"")
    end
    path = current_dir_path .. "/" .. path
  end

  ---Check the name and try to concatenate with the prefix.
  ---On success returns normalized path.
  ---On fail returns nil and an error message.
  ---@param prefix string
  ---@param name string
  ---@return string?
  ---@return string?
  local function normalize_path(prefix, name)
    if name == "." then
      return prefix
    end

    if name == ".." then
      if M.is_root_directory(prefix) then
        return nil, "Invalid \"..\" path. Already in the root directory."
      end
      local _, _, new_prefix = prefix:find("^(%Z*/)%Z-/$")
      return new_prefix
    end

    return prefix .. "/" .. name
  end

  ---@type string|nil
  local prefix = ""
  for dir_name in path:gmatch("/(%Z-)/") do
    prefix = normalize_path(prefix, dir_name)
    if not prefix then
      return nil, "Failed to normalize path"
    end
  end
  -- TODO: get the last part of the path
  local normalized_path = normalize_path(prefix, path:match("/(%Z-)/$"))
end

---Check if a path is the absolute path.
---@param path string
---@return boolean
function M.is_absolute_path(path)
  return path:find("^/%Z-$") ~= nil
end

---Creates a directory recursively and returns its full path
---on success nil and error message on fail.
---@param path string the directory path
---@return string?
---@return string?
function M.create_recursive_dir(path)
  if not M.is_absolute_path(path) then
    local current_dir_path = M.real_path(".")
    if not current_dir_path then
      error("RAWR: " .. "failed to get absolute path of \".\"")
    end
    path = current_dir_path .. "/" .. path
    print("Absolute path: " .. path)
    print("Absolute path resolved: " .. M.real_path(path))
  end

  local accumulated_path = ""
  for parent_dir_name in string.gmatch(path, "/(%Z-)/") do
    accumulated_path = accumulated_path .. "/" .. parent_dir_name
    if not M.is_directory_path(accumulated_path) then
      local success, error_message = M.create_dir(accumulated_path)
      if not success then
        return nil, error_message
      end
    end
  end

  return M.create_dir(accumulated_path)
end

---Creates a directory and returns its full path on success
---or nil and error message on fail.
---@param path string the directory path
---@return string?
---@return string?
function M.create_dir(path)
  local success, error_message = lfs.mkdir(path)
  if not success then
    return nil, error_message
  end
  return M.real_path(path)
end

return M
