local Class = import("oop/Class");
local Group = import("./Group");

local Container = Class("Container", Group);


function Container:initialize()
    Group.initialize(self);
end


function Container:addChild(child)
    self:_addElement(child);
end

function Container:removeChild(child)
    self:_removeElement(child);
end

return Container;