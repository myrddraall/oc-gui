local Class = import("oop/Class");
local Event = import("oop/Event");


local ChangeEvent = Class("ChangeEvent", Event);


function ChangeEvent:initialize(type, newValue, oldValue, cancelable, bubbles)
    Event.initialize(self, type, cancelable, bubbles);
    self._newValue = newValue;
    self._oldValue = oldValue;
end


function ChangeEvent:get_newValue()
    return self._newValue;
end

function ChangeEvent:get_oldValue()
    return self._oldValue;
end

return ChangeEvent;