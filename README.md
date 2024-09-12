<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [LuaJITImGui](#luajitimgui)
  - [ImGui / CImGui Version](#imgui--cimgui-version)
  - [Examples](#examples)
    - [glfw_opengl3_simple](#glfw_opengl3_simple)
    - [glfw_opengl3](#glfw_opengl3)
    - [glfw_opengl3_implot](#glfw_opengl3_implot)
    - [glfw_opengl3_jp](#glfw_opengl3_jp)
    - [sdl2_opengl3](#sdl2_opengl3)
    - [ImGuizmo_sample.lua](#imguizmo_samplelua)
    - [imnodes_graph_sample.lua](#imnodes_graph_samplelua)
    - [delaunay_particles.lua](#delaunay_particleslua)
  - [Download Zip binary](#download-zip-binary)
  - [Running examples](#running-examples)
  - [Other examples](#other-examples)
  - [Build binaries from source](#build-binaries-from-source)
  - [History](#history)
  - [Similar project](#similar-project)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### LuaJITImGui

---

- [LuaJIT](https://luajit.org/) + [ImGui](https://github.com/ocornut/imgui) : The binaries project on Windows OS using [anima](https://github.com/sonoro1234/anima) project  
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
   1. Added `luajitw.exe` to hide console window.
   1. Added [simple examples](examples/) like [ImGuin](https://github.com/dinau/imguin) / [ImGuinZ](https://github.com/dinau/imguinz)  project.
- Support OS: Windows10 or later

#### ImGui / CImGui Version

---

- ImGui v1.91.1dock (2024/09)

#### Examples

---

##### [glfw_opengl3_simple](examples/glfw_opengl3_simple/glfw_opengl3_simple.lua)  

![glfw_opengl3_simple](examples/img/glfw_opengl3_simple.png)

##### [glfw_opengl3](examples/glfw_opengl3/glfw_opengl3.lua)  

![glfw_opengl3](examples/img/glfw_opengl3.png)

##### [glfw_opengl3_implot](examples/glfw_opengl3_implot/glfw_opengl3_implot.lua)  

![glfw_opengl3_implot](examples/img/glfw_opengl3_implot.png)  
See more example: [implot_sample.lua](bin/examples/LuaJIT-ImGui/examples/implot_sample.lua)

##### [glfw_opengl3_jp](examples/glfw_opengl3_jp/glfw_opengl3_jp.lua)  

![glfw_opengl3_jp](examples/img/glfw_opengl3_jp.png)

##### [sdl2_opengl3](examples/sdl2_opengl3/sdl2_opengl3.lua)  

![sdl2_opengl3](examples/img/sdl2_opengl3.png)

##### [ImGuizmo_sample.lua](bin/examples/LuaJIT-ImGui/examples/ImGuizmo_sample.lua)

This sample is attached by [anima](https://github.com/sonoro1234/anima) project. You can execute this sample using
[ImGuizmo_sample.bat](bin/examples/LuaJIT-ImGui/examples/ImGuizmo_sample.bat)
in [bin/examples/LuaJIT-ImGui/examples](bin/examples/LuaJIT-ImGui/examples) folder.

![ImGuizmo_sample](examples/img/ImGuizmo_sample.png)

##### [imnodes_graph_sample.lua](bin/examples/LuaJIT-ImGui/examples/imnodes_graph_sample.lua)

This sample is attached by [anima](https://github.com/sonoro1234/anima) project. You can execute this sample using
[imnodes_graph_sample.bat](bin/examples/LuaJIT-ImGui/examples/imnodes_graph_sample.bat)
in [bin/examples/LuaJIT-ImGui/examples](bin/examples/LuaJIT-ImGui/examples) folder.

![imnodes_graph_sample](examples/img/imnodes_graph_sample.png)


##### [delaunay_particles.lua](bin/examples/delaunay_particles.lua)

This sample is attached by [anima](https://github.com/sonoro1234/anima) project. You can execute this sample,

```sh
pwd
luajitImGui-1.91.0.0
cd bin/examples
../luajit.exe delaunay_particles.lua
```

![delaunay_particles](examples/img/delaunay_particles.png)

#### Download Zip binary

- WindowsOS 64bit  
[luajitImGui-1.91.0.3.zip](https://github.com/dinau/luajitImGui/archive/refs/tags/1.91.0.3.zip)  
- WindowsOS 32bit  
[luajitImGui-1.91.0.2.zip](https://github.com/dinau/luajitImGui/archive/refs/tags/1.91.0.2.zip)  

#### Running examples

---

First on WindowsOS extract zip file downloaded then  
for instance,

```sh
cd luajitImGui-1.91.0.0
cd examples/glfw_opengl3
glfw_opengl3.exe         # Double click on Windows file explore
```

#### Other examples 

---

Refer to nice exmaples: [bin/examples](bin/examples)

#### Build binaries from source

---

- Prerequisites
   - Gcc.exe (Rev1, Built by MSYS2 project) 14.2.0)
   - (Clang 18.1.8 (Current compiler))
   - (Microsoft Visual Studio 2019 C/C++)
   - CMake version 3.30.3
   - Git version 2.46.0.windows.1
   - Make: GNU Make 4.4.1
   - MSys/MinGW tools
   - Libraries: openMP ? etc
- Build

   ```sh
   git clone --recurse-submodules https://github.com/dinau/luajitImGui
   cd luajitImGui
   make
   ```

#### History

---

- WindowsOS 64bit versions
   - Updated to
      - 2024/09: ImGui v1.91.1 / LuaJITImGui v1.91.1.0
      - 2024/09: ImGui v1.91.0 / LuaJITImGui v1.91.0.3
- WindowsOS 32bit versions
   - Updated to
      - 2024/08: ImGui v1.91.0 / LuaJITImGui v1.91.0.2 last version
      - 2024/07: ImGui v1.90.9
      - 2024/06: ImGui v1.90.8
      - 2024/05: ImGui v1.90.7
      - 2024/05: ImGui v1.90.6
      - 2024/03: ImGui v1.90.4
      - 2024/02: Added: Button "Save window image" and combo box,  
      it can be saved as JPEG, PNG, TIFF, BMP file format
      - 2024/01: Added: Icon font demo


#### Similar project

---

| Language             | Project                                                                                                                                         |
| -------------------: | :----------------------------------------------------------------:                                                                              |
| **Nim**              | [ImGuin](https://github.com/dinau/imguin), [Nimgl_test](https://github.com/dinau/nimgl_test), [Nim_implot](https://github.com/dinau/nim_implot) |
| **Lua**              | [LuaJITImGui](https://github.com/dinau/luajitImGui)                                                                                             |
| **Python**           | [DearPyGui for 32bit WindowsOS Binary](https://github.com/dinau/DearPyGui32/tree/win32)                                                         |
| **Zig**, C lang.     | [Dear_Bindings_Build](https://github.com/dinau/dear_bindings_build)                                                                             |
| **Zig**              | [ImGuinZ](https://github.com/dinau/imguinz)                                                                                         |
