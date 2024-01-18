@echo off
rem ----------------------------------------
rem Get current folder name as program name
rem ----------------------------------------
set DIR_CURRENT=%~dp0
for %%i in ("%DIR_CURRENT:~0,-1%") do set TARGET=%%~ni.lua

rem ---------------------------------
rem Set Lua libraries and *.dll path
rem ---------------------------------
set bin=..\..\bin
set LUA_PATH=;;..\lib\?.lua;%bin%\examples\LuaJIT-ImGui\examples\?.lua
set PATH=%path%;..\lib

rem ----------------
rem Execute program
rem ----------------
%bin%\luajit.exe %TARGET%
