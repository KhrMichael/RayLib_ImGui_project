require "tools.strings"
local fs      = require "fs"
local expects = require "testing.expects"

local suite   = expects.create_suite()

suite:expect_true(function() return fs.is_root_directory("/") end, 'fs.is_root_directory("/")')

if fs.is_root_directory("D:\\") then
  print(" -> " .. "D:\\ is a base directory")
else
  print("FAILED: " .. "D:\\ is a base directory")
end

if fs.is_root_directory("\\\\\\\\wsl\\") then
  print(" -> " .. "\\\\\\\\wsl\\ is a base directory")
else
  print("FAILED: " .. "\\\\\\\\wsl\\ is a base directory")
end

if fs.is_root_directory("\\\\wsl.localhost\\") then
  print(" -> " .. "\\\\wsl.localhost\\ is a base directory")
else
  print("FAILED: " .. "\\\\wsl.localhost\\ is a base directory")
end

print ""
print "Is NOT a base directory: "

if not fs.is_root_directory("\\\\\\\\wsl*\\") then
  print(" -> " .. "\\\\\\\\wsl*\\ isn't a base directory")
else
  print("FAILED: " .. "\\\\\\\\wsl*\\ isn't a base directory")
end

print ""
print "Regex tests:"

local path = "/home/bebra/bobra/shmobra/"

local _, _, paren_dir = path:find("^(%Z*/)%Z-/$")
if paren_dir then
  print(" -> Parent dir: " .. paren_dir)
else
  print("FAILED: " .. "path:find(\"^(%Z*/)%Z-/$\")")
end
