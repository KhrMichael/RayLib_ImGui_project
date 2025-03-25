local fs = require "fs"
local tools_git = require "tools.git"

local script_path = fs.real_path(arg[0])
assert(script_path and fs.is_file_path(script_path),
  "Something go really wrong. Executed script path should be a valid file path.")

local script_dir_pat = fs.parent_dir(script_path)
assert(script_dir_pat and fs.is_directory_path(script_dir_pat),
  "Something go really wrong. Executed script directory path should be a valid directory path.")

-- There should be a list of dependencies
-- dependencies-list.txt
-- it's content should be something like this
-- "<dependency-name>": <version>
--
-- 🤔
-- deps
-- - ryalib --> <EOF>1.10 <EOF>
-- crates
-- - inclued
-- - lib

local project_dir_path = fs.real_path(script_dir_pat .. "../../../")
assert(project_dir_path and fs.is_directory_path(project_dir_path), "Failed to get the project dir path.")

local deps_dir_path = fs.real_path(project_dir_path .. "/deps")
assert(deps_dir_path and fs.is_directory_path(deps_dir_path), "Failed to get the project deps dir path.")


local git = tools_git.git()
if not git then
  error("Git isn't installed.")
end

print("Git version: " .. git.get_version())


if git.clone("hsaf") == "fail" then
  print("Failed to clone hsaf")
end
