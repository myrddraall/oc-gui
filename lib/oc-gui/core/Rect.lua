local Class = import("oop/Class");
local Point = import("./Point");

local Rect = Class("Rect");

function Rect:initialize(x, y, width, height)
    self._tl = Point:new(x or 0, y or 0);
    local r = self._tl.x + (width or 0);
    local b = self._tl.y + (height or 0);
    self._br = Point:new (r, b);
end


function Rect:get_x()
    return self._tl.x;
end

function Rect:set_x(val)
    local w = self.width;
    self._tl.x = val or 0;
    self._br.x = self._tl.x + w;
end

function Rect:get_y()
    return self._tl._y;
end

function Rect:set_y(val)
    local h = self.height;
    self._tl._y = val or 0;
    self._br.y = self._tl.y + h;
end



function Rect:get_width()
    return self._br.x - self._tl.x;
end

function Rect:set_width(val)
    self._br.x = self._tl.x + (val or 0);
end

function Rect:get_height()
    return self._br.y - self._tl.y;
end

function Rect:set_height(val)
    self._br.y = self._tl.y + (val or 0);
end

function Rect:get_left()
    return self.x;
end

function Rect:set_left(val)
    self._x = val;
end

function Rect:get_top()
    return self.y;
end

function Rect:set_top(val)
    self.y = val;
end

function Rect:get_right()
    return self._br.x;
end

function Rect:set_right(val)
    self._br.x = val or 0;
end

function Rect:get_bottom()
    return self._br.y;
end

function Rect:set_bottom(val)
    self._br.y = val or 0;
end


function Rect:get_rightTo()
    return self.right;
end

function Rect:set_rightTo(val)
    val = val or 0;
    self.x = val - self.width;
    self.right = val;
end

function Rect:get_bottomTo()
    return self.bottom;
end

function Rect:set_bottomTo(val)
    val = val or 0;
    self.y = val - self.height;
    self.bottom = val;
end

function Rect:hitTest(x, y)
    return x > self.x and x <= self.right and y > self.y and y <= self.bottom;
end

function Rect:__tostring()
    return "{x: " .. self.x .. ", y: " .. self.y .. ", width: " .. self.width .. ", height: " .. self.height .. "}"; 
end

function Rect:get_pos()
    return self._tl;
end

function Rect:set_pos(value)
    self.x = value.x;
    self.y = value.y;
end


function Rect:clone()
    return Rect:new(self._tl.x, self._tl.y, self.width, self.height);
end

function Rect:intersect(r2)
    local l = math.min(math.max(self.x, r2.x), self.right);
    local t = math.min(math.max(self.y, r2.y), self.bottom);

    local r = math.max(math.min(self.right, r2.right), self.x);
    local b = math.max(math.min(self.bottom, r2.bottom), self.y);

    return Rect:new(l, t, r - l, b - t);

end

return Rect;