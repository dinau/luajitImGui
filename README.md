<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [LuaJITImGui](#luajitimgui)
  - [ImGui / CImGui Version](#imgui--cimgui-version)
  - [Examples](#examples)
    - [implot3d_sample.lua](#implot3d_samplelua)
    - [glfw_opengl3_simple](#glfw_opengl3_simple)
    - [iconFontViewer](#iconfontviewer)
    - [glfw_opengl3](#glfw_opengl3)
    - [glfw_opengl3_implot](#glfw_opengl3_implot)
    - [glfw_opengl3_jp](#glfw_opengl3_jp)
    - [sdl2_opengl3](#sdl2_opengl3)
    - [ImGuizmo_sample.lua](#imguizmo_samplelua)
    - [imnodes_graph_sample.lua](#imnodes_graph_samplelua)
  - [Other samples](#other-samples)
    - [delaunay_particles.lua](#delaunay_particleslua)
    - [bacteria.lua](#bacterialua)
    - [house.lua](#houselua)
    - [corazon.lua](#corazonlua)
    - [CTE_windows.lua](#cte_windowslua)
    - [compute_shader.lua](#compute_shaderlua)
  - [Download Zip binary](#download-zip-binary)
  - [Running examples](#running-examples)
  - [Other examples](#other-examples)
  - [Build binaries from source](#build-binaries-from-source)
  - [My tools version](#my-tools-version)
  - [History](#history)
  - [Similar project ImGui / CImGui](#similar-project-imgui--cimgui)
  - [SDL game tutorial Platfromer](#sdl-game-tutorial-platfromer)
  - [Other link2](#other-link2)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

![alt](https://github.com/dinau/luajitimgui/actions/workflows/windows.yml/badge.svg)

### LuaJITImGui

---

- [LuaJIT](https://luajit.org/) + [ImGui](https://github.com/ocornut/imgui) : The binaries project on WindowsOS using [anima](https://github.com/sonoro1234/anima) project  
Differencies from [anima](https://github.com/sonoro1234/anima) project are as follows,
   1. Added compilation option for **IME (Imput method)**

      ```sh
      -DIMGUI_ENABLE_WIN32_DEFAULT_IME_FUNCTIONS
      ```

   1. Added compilation option for **ImPlot**

      ```sh
      -DImDrawIdx="unsigned int"
      ```

   1. Included newer [Font Awesome](https://fontawesome.com/search?m=free&o=r) Icon fonts.
   1. Added `*.bat` files to easily execute [example programs](bin/examples/LuaJIT-ImGui/examples). 
   1. Added `luajitw.exe` to hide console window on background.
   1. Added [simple examples](examples/) like [ImGuin](https://github.com/dinau/imguin) / [ImGuinZ](https://github.com/dinau/imguinz)  project.
- Support OS: Windows10 or later

#### ImGui / CImGui Version

---

- v1.91.8dock (2025/03)

#### Examples

---
##### [implot3d_sample.lua](bin/examples/LuaJIT-ImGui/examples/implot3d_sample.lua)

This sample is attached by [anima](https://github.com/sonoro1234/anima) project. You can execute this sample using
[implot3d_sample.bat](bin/examples/LuaJIT-ImGui/examples/implot3d_sample.bat)
in [bin/examples/LuaJIT-ImGui/examples](bin/examples/LuaJIT-ImGui/examples) folder.

![alt](examples/img/cimplot3d.gif)

##### [glfw_opengl3_simple](examples/glfw_opengl3_simple/glfw_opengl3_simple.lua)  

![alt](examples/img/glfw_opengl3_simple.png)

##### [iconFontViewer](examples/iconFontViewer/iconFontViewer.lua)  

![alt](examples/img/iconFontViewer.png)

##### [glfw_opengl3](examples/glfw_opengl3/glfw_opengl3.lua)  

This can load and save image file with magnifying glass. 

![alt](examples/img/glfw_opengl3.png)

##### [glfw_opengl3_implot](examples/glfw_opengl3_implot/glfw_opengl3_implot.lua)  

With magnifying glass.

![alt](examples/img/glfw_opengl3_implot.png)  
See more example: [implot_sample.lua](bin/examples/LuaJIT-ImGui/examples/implot_sample.lua)

##### [glfw_opengl3_jp](examples/glfw_opengl3_jp/glfw_opengl3_jp.lua)  

Showing font of local language with magnifying glass.

![alt](examples/img/glfw_opengl3_jp.png)

##### [sdl2_opengl3](examples/sdl2_opengl3/sdl2_opengl3.lua)  

With magnifying glass.

![alt](examples/img/sdl2_opengl3.png)

##### [ImGuizmo_sample.lua](bin/examples/LuaJIT-ImGui/examples/ImGuizmo_sample.lua)

This sample is attached by [anima](https://github.com/sonoro1234/anima) project. You can execute this sample using
[ImGuizmo_sample.bat](bin/examples/LuaJIT-ImGui/examples/ImGuizmo_sample.bat)
in [bin/examples/LuaJIT-ImGui/examples](bin/examples/LuaJIT-ImGui/examples) folder.

![alt](examples/img/ImGuizmo_sample.png)

##### [imnodes_graph_sample.lua](bin/examples/LuaJIT-ImGui/examples/imnodes_graph_sample.lua)

This sample is attached by [anima](https://github.com/sonoro1234/anima) project. You can execute this sample using
[imnodes_graph_sample.bat](bin/examples/LuaJIT-ImGui/examples/imnodes_graph_sample.bat)
in [bin/examples/LuaJIT-ImGui/examples](bin/examples/LuaJIT-ImGui/examples) folder.

![alt](examples/img/imnodes_graph_sample.png)


#### Other samples

---

These samples are attached by [anima](https://github.com/sonoro1234/anima) project. You can execute samples with \*.bat files.

##### [delaunay_particles.lua](bin/examples/delaunay_particles.lua)  

![alt](examples/img/delaunay_particles.png)

##### [bacteria.lua](bin/examples/shadertoy/bacteria.lua)  

![alt](examples/img/bacteria.png)

##### [house.lua](bin/examples/modeling/house/house.lua)  

![alt](examples/img/house.png)

##### [corazon.lua](bin/examples/modeling/heart/corazon.lua)  

![alt](examples/img/corazon.png)

##### [CTE_windows.lua](bin/examples/LuaJIT-ImGui/examples/CTE_windows.lua)  

![alt](examples/img/CTE_Windows.png)

##### [compute_shader.lua](bin/examples/compute_shader/compute_shader.lua)  

![alt](examples/img/compute_shader.png)

#### Download Zip binary

---

- WindowsOS 64bit  
- Latest  
[luajitImGui-1.91.8.2.zip](https://bitbucket.org/dinau/storage/downloads/luajitImGui-1.91.8.2.zip) 2025/03  

- Old  
[luajitImGui-1.91.8.1.zip](https://bitbucket.org/dinau/storage/downloads/luajitImGui-1.91.8.1.zip) 2025/03  
[luajitImGui-1.91.8.0.zip](https://bitbucket.org/dinau/storage/downloads/luajitImGui-1.91.8.0.zip) 2025/03  
[luajitImGui-1.91.6.0.zip](https://bitbucket.org/dinau/storage/downloads/luajitImGui-1.91.6.0.zip) 2025/01  
[luajitImGui-1.91.4.0.zip](https://bitbucket.org/dinau/storage/downloads/luajitImGui-1.91.4.0.zip) 2024/10  
[luajitImGui-1.91.2.0.zip](https://github.com/dinau/luajitImGui/archive/refs/tags/1.91.2.0.zip) 2024/10  
[luajitImGui-1.91.1.0.zip](https://github.com/dinau/luajitImGui/archive/refs/tags/1.91.1.0.zip) 2024/09  
[luajitImGui-1.91.0.3.zip](https://bitbucket.org/dinau/storage/downloads/luajitImGui-1.91.0.3.zip)  
- WindowsOS 32bit last version  
[luajitImGui-1.91.0.2.zip](https://bitbucket.org/dinau/storage/downloads/luajitImGui-1.91.0.2.zip)  

#### Running examples

---

First on WindowsOS extract zip file downloaded then  
for instance,

```sh
cd luajitImGui-1.91.0.0
cd examples/glfw_opengl3
glfw_opengl3.exe         # or double click on Windows file explore
```

#### Other examples 

---

Refer to nice exmaples: [bin/examples](bin/examples)

#### Build binaries from source

---

- Prerequisites  
   Install at least on MSys2/MinGW console,

   ```sh
   pacman -S mingw-w64-ucrt-x86_64-{cmake,gcc,clang,llvm-openmp} patch make git
  ```

- Build **on MSys2 console**,

   ```sh
   git clone --recurse-submodules https://github.com/dinau/luajitImGui
   cd luajitImGui
   make clean
   make
   ```

   That's all :-)

#### My tools version

---

- Clang 20.1.0 (Current compiler)
   - Libraries: OpenMP 
- Gcc.exe (Rev1, Built by MSYS2 project) 14.2.0)
- (Microsoft Visual Studio 2022 C/C++)
- CMake version 3.31.6
- Git version 2.46.0.windows.1
- Make: GNU Make 4.4.1

#### History

---

- WindowsOS 64bit versions
   | Date    | ImGui / CImGui | LuaJITImGui | Commemt |
   | ---     | -----------    | ---         | ---     |
   | 2025/03 | v1.91.8        | v1.91.8.2   |         |
   | 2025/01 | v1.91.6        | v1.91.6.0   |         |
   | 2024/10 | v1.91.4        | v1.91.4.0   |         |
   | 2024/10 | v1.91.2        | v1.91.2.0   |         |
   | 2024/09 | v1.91.1        | v1.91.1.0   |         |
   | 2024/09 | v1.91.0        | v1.91.0.3   |         |

- WindowsOS 32bit versions
   | Date    | ImGui / CImGui | LuaJITImGui | Commemt                                                                                              |
   | ---     | -----------    | ---         | ---                                                                                                  |
   | 2024/08 | v1.91.0        | v1.91.0.2   | Last version                                                                                                     |
   | 2024/07 | v1.90.9        | v1.90.9.0   |                                                                                                      |
   | 2024/06 | v1.90.8        | v1.90.8.0   |                                                                                                      |
   | 2024/05 | v1.90.7        | v1.90.7.0   |                                                                                                      |
   | 2024/05 | v1.90.6        | v1.90.6.2   |                                                                                                      |
   | 2024/03 | v1.90.4        | v1.90.4.0   |                                                                                                      |
   | 2024/02 | v1.90.1        | v1.90.1.3   | Added: Button "Save window image" and combo box, it can be saved as JPEG, PNG, TIFF, BMP file format |
   | 2024/01 | v1.90.1        | v1.90.1.0   | Added: Icon font demo                                                                                |

#### Similar project ImGui / CImGui

---

| Language [^order]    |          | Project                                                                                                                                         |
| -------------------: | :---:    | :----------------------------------------------------------------:                                                                              |
| **Lua**              | Script   | [LuaJITImGui](https://github.com/dinau/luajitImGui)                                                                                             |
| **NeLua**            | Compiler | [NeLuaImGui](https://github.com/dinau/neluaImGui)                                                                                               |
| **Nim**              | Compiler | [ImGuin](https://github.com/dinau/imguin), [Nimgl_test](https://github.com/dinau/nimgl_test), [Nim_implot](https://github.com/dinau/nim_implot) |
| **Python**           | Script   | [DearPyGui for 32bit WindowsOS Binary](https://github.com/dinau/DearPyGui32/tree/win32)                                                         |
| **Ruby**             | Script   | [igRuby_Examples](https://github.com/dinau/igruby_examples)                                                                                     |
| **Zig**, C lang.     | Compiler | [Dear_Bindings_Build](https://github.com/dinau/dear_bindings_build)                                                                             |
| **Zig**              | Compiler | [ImGuinZ](https://github.com/dinau/imguinz)                                                                                                     |


#### SDL game tutorial Platfromer

---

![ald](https://github.com/dinau/nelua-platformer/raw/main/img/platformer-nelua-sdl2.gif)


| Language    [^order] |          | SDL         | Project                                                                                                                                               |
| -------------------: | :---:    | :---:       | :----------------------------------------------------------------:                                                                                    |
| **LuaJIT**           | Script   | SDL2        | [LuaJIT-Platformer](https://github.com/dinau/luajit-platformer)
| **Nelua**            | Compiler | SDL2        | [NeLua-Platformer](https://github.com/dinau/nelua-platformer)
| **Nim**              | Compiler | SDL3 / SDL2 | [Nim-Platformer-sdl2](https://github.com/def-/nim-platformer)/ [Nim-Platformer-sdl3](https://github.com/dinau/sdl3_nim/tree/main/examples/platformer) |
| **Ruby**             | Script   | SDL3        | [Ruby-Platformer](https://github.com/dinau/ruby-platformer)                                                                                           |
| **Zig**              | Compiler | SDL2        | [Zig-Platformer](https://github.com/dinau/zig-platformer)                                                                                             |

[^order]: Alphabectial order

#### Other link2

---

- https://github.com/SpartanJ/SOIL2  
SOIL2 is a tiny C library used primarily for uploading textures into OpenGL. 
