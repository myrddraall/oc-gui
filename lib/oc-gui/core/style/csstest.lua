import.clearCache();

local parser = import("./css-parser");
local tu = import("../../util/TextUtil")
local serialization = import("serialization");

local CssParser = import("./CssParser")


function string:explode(delim, limit)
    return tu.split(self, delim, limit);
end


local p = parser.new();

local css =[[
    /* asdf
    
    */

    button, .button, button.asdf, button.asdf.qwerty {
        background: #ffffff;
    }
    
]];

--p:parse(css);

--print(serialization.serialize(p.objects));



local cp = CssParser:new();
print("-------------");
cp:parse(css);
print("-------------");