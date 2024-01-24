<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [luajitImGui](#luajitimgui)
  - [Notice](#notice)
  - [Project](#project)
  - [Versions](#versions)
  - [Examples](#examples)
    - [glfw_opengl3](#glfw_opengl3)
    - [glfw_opengl3_implot](#glfw_opengl3_implot)
    - [glfw_opengl3_jp](#glfw_opengl3_jp)
    - [sdl2_opengl3](#sdl2_opengl3)
  - [Run examples](#run-examples)
  - [Other examples](#other-examples)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### luajitImGui

#### Notice 

---

This repository is under construction at this time.

#### Project

---

1. [Luajit](https://luajit.org/) + [ImGui](https://github.com/ocornut/imgui)  
Windows OS binaries project using [anima](https://github.com/sonoro1234/anima) project
   - Differencies from [anima](https://github.com/sonoro1234/anima) project,
      - Added GCC/Clang compilation option in [anima/Luajit-ImGui/CMakeLists.txt](anima/Luajit-ImGui/CMakeLists.txt)
         1. For IME (Imput method)  
            `"-DIMGUI_ENABLE_WIN32_DEFAULT_IME_FUNCTIONS"`
         1. For ImPlot  
            `"-DImDrawIdx=unsigned int"`


1. Added simple examples below like [imguin](https://github.com/dinau/imguin) project.

#### Versions

---

- ImGui v1.90.1
- LuaJIT 2.1.1697887905 -- Copyright (C) 2005-2023 Mike Pall. https://luajit.o

#### Examples

---

##### [glfw_opengl3](examples/glfw_opengl3/glfw_opengl3.lua)  

![glfw_opengl3](examples/img/glfw_opengl3.png)

##### [glfw_opengl3_implot](examples/glfw_opengl3/glfw_opengl3_implot.lua)  

![glfw_opengl3_implot](examples/img/glfw_opengl3_implot.png)  
See more example: [implot_sample.lua](bin/examples/LuaJIT-ImGui/examples/implot_sample.lua)

#####  [glfw_opengl3_jp](examples/glfw_opengl3_jp/glfw_opengl3_jp.lua)  

![glfw_opengl3_jp](examples/img/glfw_opengl3_jp.png)

#####  [sdl2_opengl3](examples/sdl2_opengl3/sdl2_opengl3.lua)  

![sdl2_opengl3](examples/img/sdl2_opengl3.png)


#### Run examples

---

On Windows OS first,

```sh
git clone https://github.com/dinau/luajitImGui
cd luajitImGui
```

For instance,

```sh
cd examples/glfw_opengl3
r.bat
```

#### Other examples 

---

Refer to nice exmaples: [bin/examples](bin/examples)
