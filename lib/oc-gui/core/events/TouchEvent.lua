local Class = import("oop/Class");
local Event = import("oop/Event");


local TouchEvent = Class("TouchEvent", Event);


function TouchEvent:initialize(x, localX, y, localY, button, player)
    Event.initialize(self, "touch", true, true);
    self._x = x;
    self._y = y;
    self._localX = localX;
    self._localY = localY;
    self._button = button;
    self._player = player;
end


function TouchEvent:get_x()
    return self._x;
end

function TouchEvent:get_y()
    return self._y;
end

function TouchEvent:get_localX()
    return self._localX;
end

function TouchEvent:get_localY()
    return self._localY;
end

function TouchEvent:get_button()
    return self._button;
end

function TouchEvent:get_player()
    return self._player;
end

return TouchEvent;