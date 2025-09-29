add_rules("mode.debug","mode.release")



namespace("xse", function () 
    target("common")
    
        set_languages("cxx11")
        set_plat("windows")
        set_arch("x64")

        set_kind("static")
        set_pcxxheader("include/IPrefix.h")
        add_files("src/*.cpp")
        add_includedirs("include")
        add_headerfiles("include/*.h","include/*.inc")
        set_version("2.0.0")

end)