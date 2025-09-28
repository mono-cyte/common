add_rules("mode.debug","mode.release")

set_languages("cxx11")

namespace("xse", function () 
    target("common")
        set_kind("static")
        set_pcxxheader("include/IPrefix.h")
        add_files("src/*.cpp")
        add_includedirs("include")
        add_headerfiles("include/*.h","include/*.inc")
end)
