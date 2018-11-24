local Class = import("oop/Class");
local Rect = import("./Rect");
local Point = import("./Point");
local Surface = import("./Surface");

local Canvas = Class("Canvas");

function Canvas:initialize(parent)
    self._absRect = Rect:new();
    self._rect = Rect:new();
    self._surface = Surface:new();
    self.parent = parent;
end



function Canvas:get_x()
    return self._rect.x;
end

function Canvas:set_x(val)
    if self._rect.x ~= val then
        self._rect.x = val;
    end
end

function Canvas:get_y()
    return self._rect.y;
end

function Canvas:set_y(val)
    if self._rect.y ~= val then
        self._rect.y = val;
    end
end

function Canvas:get_width()
    return self._rect.width;
end

function Canvas:set_width(val)
    if self._rect.width ~= val then
        self._rect.width = val;
    end
end

function Canvas:get_height()
    return self._rect.height;
end

function Canvas:set_height(val)
    if self._rect.height ~= val then
        self._rect.height = val;
    end
end

function Canvas:get_background()
    return self._surface.background;
end

function Canvas:set_background(val)
    self._surface.background = val;
end

function Canvas:get_foreground()
    return self._surface.foreground;
end

function Canvas:set_foreground(val)
    self._surface.foreground = val;
end


function Canvas:get_parent()
    return self._parent;
end

function Canvas:set_parent(value)
    self._parent = value;
end

function Canvas:updatePositionAndSize()
    self._absRect = self._parent.absoluteRect;
    if self.parent.parent then
        self._surface.viewPort = self.parent.parent.absoluteRect:intersect( Rect:new(self._absRect.x, self._absRect.y, self._rect.width, self._rect.height));
    else
        self._surface.viewPort = Rect:new(self._absRect.x, self._absRect.y, self._rect.width, self._rect.height);
    end
end


function Canvas:clear()
    self._surface:clear();
end

function Canvas:fillChar(rect, char, fgColor, bgColor)
    self._surface:fillChar(self:_getRect(rect), char, fgColor, bgColor);
end

function Canvas:fill(rect, bgColor)
    self._surface:fill(self:_getRect(rect), bgColor);
end

function Canvas:set(x, y, string, vertical,  fgColor, bgColor)
    local pos = self:_getPos(Point:new(x, y));
    self._surface:set(pos.x, pos.y, string, vertical, fgColor, bgColor);
end

function Canvas:_getRect(rect)
    rect = rect:clone();
    rect.pos = self:_getPos(rect.pos);
    return rect;
end

function Canvas:_getPos(pos)
    return self._absRect.pos + self._rect.pos + pos;
end

function Canvas:destroy()
  
end

return Canvas;