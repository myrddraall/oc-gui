importDevMode.enabled = true;

local gpu = require("component").gpu;

local Container = import("../core/Container");

local Element = import("../core/Element");
local Progressbar = import("../common/Progressbar");
local Label = import("../common/Label");
local Gui = import("../core/Gui");


local gui = Gui:new();

local vW, vH = gpu.getResolution();
gpu.setBackground(0x000000);
gpu.fill(1, 1, vW, vH, " ");

--gui.left = 1;
--gui.right = 1;
--gui.width = "auto";


--gui.top = 1;
--gui.bottom = 1;
--gui.height = "auto";
--gui.y = 1;
--gui.width = "100%";
--gui.height = "50%";
--gui.height = vH - 2;

gui.background = 0x00ff00;

local element = Element:new();
element.x = 80;
element.y = 0;
element.width = 10;
element.height = 10;
element.background = 0xffff00;
element.forground = 0xff;
--element.zIndex = 10;
--gui:addChild(element);

local element2 = Element:new();
element2.x = 30;
element2.y = 5;
element2.width = "50%";
element2.height = 10;
element2.background = 0xffffff;
element2.forground = 0xff;
--gui:addChild(element2);
--element2.visible = false;
--[[

    element.x = 5;
    element.y = 5;
    element.width = 10;
    element.height = 10;
    element.background = 0xffff00;
    ]]

local pb = Progressbar:new();
pb.x = 1;
pb.y = 1;
pb.width = 1;
pb.height = 40;
pb.background = 0x00ffff;
pb.foreground = 0xff0000;
pb.vertical = true;
pb.maxValue = 320;
gui:addChild(pb);

local label = Label:new();
label.left = "auto";
label.right = "auto";
label.y = 1;
label.width = 24;
label.height = 10;
label.background = 0x00ffff;
label.foreground = 0xff0000;
label.vertical = true;
label.textAlign = "center";
label.vAlign = "middle";

label.text = "testing... ";

gui:addChild(label);

local c = 0;

while true do
    gui:update();
    c = c + 1;
    pb.value = c;
    label.text = "testing... " .. tostring(c);
   -- element.x = element.x - 1;
  --  element2.x = element2.x + 1;
    os.sleep(0.25);
end