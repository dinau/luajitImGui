# Generate Windows batch files with Nim language
# by dinau 2025/03
# Compilation
#  $ nim c -d:release -d:strip genbat.nim

import std/[dirs, paths, pegs, strutils, strformat, os]

const EXAMPLES_DIR_TOP = "../../bin/examples".Path

setCurrentDir(EXAMPLES_DIR_TOP)
for file in walkDirRec("."):
  let (dirParent, _, ext) = file.splitFile
  if ext == ".lua":
    for line in lines(file):
      if line.contains(peg"'win:start'") or
         line.contains(peg"'shouldClose\('") or
         line.contains(peg"'pollEvent\('") or
         line.contains(peg"'GL:start'"):
        let luaName = extractFilename(file)
        let batName = extractFilename(file).changeFileExt("bat")
        let sLuaJitExePath = (".." & DirSep).repeat(1 + dirParent.count( Dirsep)) & "luajit.exe"
        var content = &"@echo off\n{sLuaJitExePath} {luaName}"
        let outPath = os.joinPath(dirParent, batName)
        writeFile(outPath, content)
        echo "Generating: ", os.joinPath(EXAMPLES_DIR_TOP.string ,outPath)
