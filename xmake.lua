add_rules("mode.debug","mode.release")

namespace("xse", function () 
    target("common")
        set_kind("static")
        set_languages("c++11")
        set_plat("windows")
        set_arch("x64")
        set_toolchains("msvc")

        set_pcxxheader("include/IPrefix.h")
        add_files("src/*.cpp")
        add_headerfiles("include/(**)")
        add_includedirs("include")

end)