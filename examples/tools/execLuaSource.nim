# Launcher for luajitw.exe to hide console window.
# 2014/08 by audin
# nim-2.0.8
# Refer to: ../Makefile for compilation
# Refer to:
#   How to build windowless LuaJIT for Windows
#     https://gist.github.com/Egor-Skriptunoff/22bf55c1abe44d7825605e132e48c084
#

import std/[os]
include res/resource

let GUI_SRC =  getAppFilename().lastPathPart().changeFileExt(".lua")

when true:
  import std/[osproc]
  const LUAJIT_EXE = r"..\..\bin\luajitw.exe"
  quit execCmd( LUAJIT_EXE & " " & GUI_SRC)

else:
  import std/[os, osproc ,envvars, strtabs]
  const LUAJIT_EXE = r"..\..\bin\luajitw.exe"
  const LUA_PATH = r";;..\lib\?.lua;"


  discard execCmdEx( LUAJIT_EXE & " " & GUI_SRC
                    ,workingDir = "."
                    ,env = newStringTable({"LUA_PATH":  LUA_PATH
                                          ,"PATH" :     getEnv("PATH") & r";..\lib"
                                          ,"LANG" :     getEnv("LANG")
                                          ,"LC_ALL" :   getEnv("LC_ALL")
                                          ,"LC_CTYPE" : getEnv("LC_CTYPE")
                                          ,"windir" :   getEnv("windir")
                                          })
                    )
