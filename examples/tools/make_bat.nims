import strutils

const exampleNameTbl = [
   "CTE_Objects_sample"
  ,"CTE_sample"
  ,"CTE_windows"
  ,"cimnodes_r_graph_sample"
  ,"cimnodes_r_sample"
  ,"dock"
  ,"fb_sample"
  ,"folder_sizes_gui"
  ,"font_loader_sample"
  ,"imGuizmo_sample"
  ,"imnodes_graph_sample"
  ,"imnodes_sample"
  ,"implot_sample"
  ,"listclipper"
  ,"minimal_main"
  ,"minimal_main_viewport"
  ,"minimal_sdl"
  ,"minimal_sdl_opengl2"
  ,"piemenu"
  ,"plotter_sample"
  ,"rotateText"
  ,"sdl_audio"
  ,"timeline_example"
  ,"widgets_sample"
  ,"window_drag_drop"
]

var template_bat = """
@echo off
call r.bat $1
"""

const examplesDir = "../../bin/examples/LuaJIT-ImGui/examples/"

for exampleName in exampleNameTbl:
  let content = template_bat % [exampleName & ".lua"]
  let saveName = examplesDir & exampleName & ".bat"
  echo saveName
  writeFile(saveName,content)
