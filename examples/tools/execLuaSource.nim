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

import std/[osproc]
const LUAJIT_EXE = r"..\..\bin\luajitw.exe"
quit execCmd( LUAJIT_EXE & " " & GUI_SRC)
