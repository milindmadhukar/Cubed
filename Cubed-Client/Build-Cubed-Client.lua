project "Cubed-Client"
kind "ConsoleApp"
language "C++"
cppdialect "C++20"
targetdir "bin/%{cfg.buildcfg}"
staticruntime "off"

files { "Source/**.h", "Source/**.cpp" }

includedirs
{
  "../Cubed-Common/Source",

  "../Walnut/vendor/imgui",
  "../Walnut/vendor/glfw/include",

  "../Walnut/Walnut/Source",
  "../Walnut/Walnut/Platform/GUI",

  "%{IncludeDir.VulkanSDK}",
  "%{IncludeDir.glm}",

  -- Walnut-Networking
  "../Walnut/Walnut-Modules/Walnut-Networking/Source",
  "../Walnut/Walnut-Modules/Walnut-Networking/vendor/GameNetworkingSockets/include"

}

links
{
  "Cubed-Common",
  "Walnut"
}

targetdir("../bin/" .. outputdir .. "/%{prj.name}")
objdir("../bin-int/" .. outputdir .. "/%{prj.name}")

filter "system:windows"
systemversion "latest"
defines { "WL_PLATFORM_WINDOWS" }
buildoptions { "/utf-8" }

postbuildcommands
{
  '{COPY} "../%{WalnutNetworkingBinDir}/GameNetworkingSockets.dll" "%{cfg.targetdir}"',
  '{COPY} "../%{WalnutNetworkingBinDir}/libcrypto-3-x64.dll" "%{cfg.targetdir}"',
  '{COPY} "../%{WalnutNetworkingBinDir}/libprotobufd.dll" "%{cfg.targetdir}"',
}

filter "system:linux"
system "linux"
kind "ConsoleApp"
defines { "WL_PLATFORM_LINUX" }

links {
  "GLFW",
  "vulkan",
  "dl",
  "pthread",
  "X11",
  "Xrandr",
  "Xi",
  "Xxf86vm",
  "Xcursor"
}

buildoptions {
  "-fPIC",
  "-Wno-deprecated-declarations"
}


filter "configurations:Debug"
defines { "WL_DEBUG" }
runtime "Debug"
symbols "On"

filter "configurations:Release"
defines { "WL_RELEASE" }
runtime "Release"
optimize "On"
symbols "On"

filter "configurations:Dist"
kind "WindowedApp"
defines { "WL_DIST" }
runtime "Release"
optimize "On"
symbols "Off"
