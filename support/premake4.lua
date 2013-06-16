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
     "../external/lua/src",
     "../source",
     "../external/ivss/addons/ivss_sim_lua",
     "../external/ivss/addons/ivss_sim_gldisplay",
   }
   files {
     "../source/**",
     "../external/ivss/addons/ivss_sim_lua/**",
     "../external/ivss/addons/ivss_sim_gldisplay/**",
   }
   links { "simc", "ivss", "lua" }
