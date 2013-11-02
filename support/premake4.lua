SIMC_STANDALONE = false
IVSS_STANDALONE = false
solution "standalone_ivss"
   debugdir "../debug"
   dofile("./../external/simc/support/premake4_common.lua")
   dofile("./../external/simc/support/premake4.lua")
   dofile("./../external/ivss/support/premake4.lua")

-- Create working directory
if not os.isdir("../debug") then os.mkdir("../debug") end


--------------------------------------------------------------------------------
-- Lua
--------------------------------------------------------------------------------
local USE_LUAJIT = true
if not USE_LUAJIT then
   project "lua"
      uuid "CE2BC989-5641-194B-A3B7-01020475664D"
      kind "StaticLib"
      language "C"
      includedirs { "../external/lua/src" }
      files { "../external/lua/src/**" }
      excludes {
        "../external/lua/src/lua.c",
        "../external/lua/src/luac.c",
        "../external/lua/src/print.c",
      }
end


--------------------------------------------------------------------------------
-- GLFW
--------------------------------------------------------------------------------
if os.is("windows") then
   project "glfw"
      uuid "D15A53B8-EDE5-8C4E-90AF-09F47C48DA45"
      kind "StaticLib"
      language "C"
      includedirs { "../external/glfw/include" }
      includedirs { "../external/glfw/deps" }
      files {
        "../external/glfw/src/internal.h",
        
        "../external/glfw/src/clipboard.c",
        "../external/glfw/src/context.c",
        "../external/glfw/src/gamma.c",
        "../external/glfw/src/init.c",
        "../external/glfw/src/input.c",
        "../external/glfw/src/joystick.c",
        "../external/glfw/src/monitor.c",
        "../external/glfw/src/time.c",
        "../external/glfw/src/window.c",
      }
      configuration { "windows" }
        files { "../external/glfw/src/win32_*.c" }
        files { "../external/glfw/src/wgl_*.c" }
        includedirs { "../external/config/glfw_win32" }
      configuration { "linux" }
        files { "../external/glfw/src/x11_*.c" }
        includedirs { "../external/config/glfw_x11" }
end
   

--------------------------------------------------------------------------------
-- Standalone simulator
--------------------------------------------------------------------------------
project "standalone_ivss"
   uuid "62FCF23A-66A2-43EF-BADA-A371523BEF57"
   kind "ConsoleApp"
   language "C"
   includedirs {
     "../include",
     "../external/ivss/include",
     "../external/simc/include",
     "../external/glfw/include",
     "../external/glfw/deps/GL",
     "../source",
     "../external/ivss/addons/ivss_sim_lua",
     "../external/ivss/addons/ivss_win_lcdscreen",
   }
   files {
     "../source/**",
     "../external/ivss/addons/ivss_sim_lua/**",
     "../external/ivss/addons/ivss_win_lcdscreen/**",
   }
   links { "simc", "ivss", "glfw" }
   
   if USE_LUAJIT then
     links "luajit"
     includedirs "../external/luajit"
     configuration { "windows", "x32" }
        libdirs "../external/luajit/win32"
     configuration { "windows", "x64" }
        libdirs "../external/luajit/win64"
   else
     links "lua"
     includedirs "../external/lua/src"
   end
   
   configuration "windows"
      links { "opengl32","wsock32" }
