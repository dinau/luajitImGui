@echo off

rem ---------------------------------
rem Set Lua libraries and *.dll path
rem ---------------------------------
set bin=..\..
set LUA_PATH=;;..\lib\?.lua;%bin%\examples\LuaJIT-ImGui\examples\?.lua
rem Clear PATH if you need.
set PATH=
set PATH=%path%;..\lib

rem ----------------
rem Execute program
rem ----------------
%bin%\luajit.exe julia.lua
