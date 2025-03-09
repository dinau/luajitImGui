--  Generate Windows batch files.
--    by dinau 2025/03
--  Exectution
--  $ ..\..\bin\luajit genbat.lua

---------------------------
--- Only for Windows OS ---
---------------------------

local lfs = require("lfs")

local allFiles = ""
lfs.chdir("..\\..\\bin\\examples")
local baseDir = lfs.currentdir()
local _, baseDirSepCount = baseDir:gsub("[/\\]", "")

--print(baseDirSepCount, "Current Directory: " .. baseDir)

local f = io.popen("dir /s /b \"*.lua\"")
if f then
  allFiles = f:read("*a")
  f:close()
else
  print("failed to read")
end

local function check(str)
  if nil ~= str:match("win:start")   then return true end
  if nil ~= str:match("shouldClose") then return true end
  if nil ~= str:match("GL:start")    then return true end
  if nil ~= str:match("pollEvent")   then return true end
  return false
end

for fileName in allFiles:gmatch("([^\n]*)\n?") do
  if string.len(fileName)> 2 then
    local fgen = false
    for line in io.lines(fileName) do
      if check(line) then
        fgen = true
        break
      end
    end
    if fgen then
      local batName, n = string.gsub(fileName,"%.lua$",".bat")
      local luaName = fileName:match("^.+[/\\](.+)$")
      local _, dirSepCount = fileName:gsub("[/\\]", "")
      --print(dirSepCount, batName)
      --print(luaName)
      local content = "@echo off\n"
      content = content .. string.rep("..\\",dirSepCount - baseDirSepCount) .. "luajit.exe"
      content = content .. " " .. luaName
      print("Generating: " .. batName)
      local fp = io.open(batName, "w")
      if fp then
        fp:write(content)
        fp:close()
      end
    end
  end
end
