importDevMode.enabled = true;

local Rect = import("../core/Rect");
local Surface = import("../core/Surface");
local gpu = require("component").gpu;
local unicode = require("unicode")

local vW, vH = gpu.getResolution();
gpu.setBackground(0x000000);
gpu.fill(1, 1, vW, vH, " ");


local surface = Surface:new(gpu, Rect:new(1, 1, 10, 10));

surface.background = 0xffffff;
surface.foreground = 0x0;


local pos = 5;
local drawRect = Rect:new(2, 2, 1, 1);



while true do
    surface:clear();
    surface:set(5, pos, "this is a really long string that wont fit"  , false, 0x0000ff, 0x00ff00);

    --pos = pos + 1;
    --surface:fillChar(drawRect,  unicode.char(0x256d), 0x0 , 0xffff00);
    --char = char + 1;
    --print(char .. " ->  "  .. unicode.char(char));
    --drawRect.y = drawRect.y + 1;
    gpu.setBackground(0x000000);
    os.sleep(1);
    gpu.setBackground(0x000000);
end
