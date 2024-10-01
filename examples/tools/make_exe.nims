import os, strformat

const src = "execLuaSource.nim"
const dirTbl = [
    "glfw_opengl3"
  , "glfw_opengl3_implot"
  , "glfw_opengl3_jp"
  , "glfw_opengl3_simple"
  , "sdl2_opengl3"
]

let argv = os.commandLineParams()
let argc = argv.len
echo argv
echo argc
var CC = "gcc"
if argc == 3:
  CC = argv[argc - 1]

let OPT = "--passL:-static"

for dir in dirTbl:
  withDir os.joinPath("..", dir):
    withDir "res":
      exec("make")
    let cmd = fmt"nim c --cc:{CC} --app:gui -d:strip -d:release --opt:size {OPT} -o:{dir}.exe {src}"
    echo cmd
    exec( cmd )
