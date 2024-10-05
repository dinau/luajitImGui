/* Just simple launcher for ../bin/luajitw.exe to hide console window.
 *
 * This program executes
 *
 *  ../bin/luajitw.exe "thisProgramName.lua"
 *
 *  if thisProgramName[.exe] is renamed to glfw_opengl3[.exe] then,
 *  glfw_opengl3.exe just executes
 *
 *  ../bin/luajitw.exe "glfw_opengl3.lua"
 *
 * 2024-10: by dinau
 */

#include <windows.h>
#include <stdio.h>
#include <string.h>

const char* sLuajitwExe = "..\\..\\bin\\luajitw.exe";

int main(int argc,char** argv){
  const int MAX_STR = 2048;
  char sFname[MAX_STR];
  char sLuaNameEx[MAX_STR];
  GetModuleFileName(NULL, sFname, sizeof(sFname));
  printf("Exe = %s\n",sFname);

  strrchr(sFname,'.')[0] = '\0'; // Delete ".exe"

  sprintf_s(sFname, MAX_STR, "%s%s", sFname, ".lua"); // Add Lua extension
  sprintf_s(sLuaNameEx, MAX_STR, "\"%s\"", sFname);   // Guard string with ""

  printf("LuaName = %s\n", sFname);
  printf("LuaNameEx = %s\n", sLuaNameEx);


  HINSTANCE ret = ShellExecute(NULL, NULL, sLuajitwExe, sLuaNameEx, NULL, SW_NORMAL);

  if ((INT_PTR)ret > 32){
    return 0;
  }else{
    printf("Error!: execLuaSource.c\n");
    return 1;
  }
}
