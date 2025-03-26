local function is_base_directory(path)
  return path:match("^/$") or path:match("^\\\\\\\\[^<>:\"/\\|?*]*\\$") or path:match("\\\\[^<>:\"/\\|?*]*\\$") or
      path:match("^[A-Za-z]:\\$")
end

print "Is a base directory: "

if is_base_directory("/") then
  print(" -> " .. "/ is a base directory")
else
  print("FAILED: " .. "/ is a base directory")
end

if is_base_directory("D:\\") then
  print(" -> " .. "D:\\ is a base directory")
else
  print("FAILED: " .. "D:\\ is a base directory")
end

if is_base_directory("\\\\\\\\wsl\\") then
  print(" -> " .. "\\\\\\\\wsl\\ is a base directory")
else
  print("FAILED: " .. "\\\\\\\\wsl\\ is a base directory")
end

if is_base_directory("\\\\wsl.localhost\\") then
  print(" -> " .. "\\\\wsl.localhost\\ is a base directory")
else
  print("FAILED: " .. "\\\\wsl.localhost\\ is a base directory")
end

print ""
print "Is NOT a base directory: "

if not is_base_directory("\\\\\\\\wsl*\\") then
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
