
importDevMode.enabled = true;

local Point = import("../core/Point");

local p1 = Point:new(1, 1);
local p2 = Point:new(2,3);

print("");
print(p1);
print(p2);
--print("");
--print("p1 + p2: " .. tostring(p1 + p2));
--print("");
--print("p1 - p2: " .. tostring(p1 - p2));
print("");
print("-p1: " .. tostring(p2 % 2));