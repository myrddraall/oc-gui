local Class = import("oop/Class");
local ChangeEvent = import("./ChangeEvent");


local ParentChangeEvent = Class("ParentChangeEvent", ChangeEvent);


function ParentChangeEvent:initialize(newParent, oldParent)
    ChangeEvent.initialize(self, "parentChange", newParent, oldParent);
   
end

return ParentChangeEvent;