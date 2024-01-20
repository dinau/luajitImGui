<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [luajitImGui](#luajitimgui)
  - [Notice](#notice)
  - [Project](#project)
  - [Versions](#versions)
  - [Examples](#examples)
    - [glfw_opengl3](#glfw_opengl3)
    - [glfw_opengl3_jp](#glfw_opengl3_jp)
    - [sdl2_opengl3](#sdl2_opengl3)
  - [Run examples](#run-examples)
  - [Regenerate binaries and libraries](#regenerate-binaries-and-libraries)
  - [Tools version](#tools-version)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### luajitImGui

#### Notice 

---

This repository is under construction at this time.

#### Project

---

1. [Luajit](https://luajit.org/) + [ImGui](https://github.com/ocornut/imgui)  
Windows OS binaries project using [anima](https://github.com/sonoro1234/anima) project
1. Added simple examples like [imguin](https://github.com/dinau/imguin) project.

#### Versions

---

- ImGui v1.90.0
- LuaJIT 2.1.1697887905 -- Copyright (C) 2005-2023 Mike Pall. https://luajit.o

#### Examples

---

##### [glfw_opengl3](examples/glfw_opengl3/glfw_opengl3.lua)  

![glfw_opengl3](examples/img/glfw_opengl3.png)

#####  [glfw_opengl3_jp](examples/glfw_opengl3_jp/glfw_opengl3_jp.lua)  

![glfw_opengl3_jp](examples/img/glfw_opengl3_jp.png)

#####  [sdl2_opengl3](examples/sdl2_opengl3/sdl2_opengl3.lua)  

![sdl2_opengl3](examples/img/sdl2_opengl3.png)


#### Run examples

---

For instance on Windows OS, first

```sh
git clone https://github.com/dinau/luajitImGui
cd luajitImGui
```

```sh
cd examples/glfw_opengl3
r.bat
```

#### Regenerate binaries and libraries

----

```sh
git clone --recursive https://github.com/dinau/luajitImGui
cd luajitImGui
make clean
make
```

#### Tools version

---

- clang version 17.0.6
- cmake version 3.28.0-rc2
- gcc.exe (Rev3, Built by MSYS2 project) 13.2.0
- git version 2.41.0.windows.3
- make: GNU Make 4.2.1
