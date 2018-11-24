local Class = import("oop/Class");


local Point = Class("Point");

function Point:initialize(x, y)
    self._x = x;
    self._y = y;
end

function Point:get_x()
    return self._x;
end

function Point:set_x(val)
    self._x = val;
end

function Point:get_y()
    return self._y;
end

function Point:set_y(val)
    self._y = val;
end

function Point:__tostring()
    return "{x: " .. self._x .. ", y: " .. self._y .. "}";
end



function Point:__add(p2)
    if type(p2) == "number" then
        return Point:new(self.x + p2, self.y + p2);
    end
    return Point:new(self.x + p2.x, self.y + p2.y);
end

function Point:__sub(p2)
    if type(p2) == "number" then
        return Point:new(self.x - p2, self.y - p2);
    end
    return Point:new(self.x - p2.x, self.y - p2.y);
end

function Point:__mul(p2)
    if type(p2) == "number" then
        return Point:new(self.x * p2, self.y * p2);
    end
    return Point:new(self.x * p2.x, self.y * p2.y);
end

function Point:__div(p2)
    if type(p2) == "number" then
        return Point:new(self.x / p2, self.y / p2);
    end
    return Point:new(self.x / p2.x, self.y / p2.y);
end

function Point:__mod(p2)
    if type(p2) == "number" then
        return Point:new(self.x % p2, self.y % p2);
    end
    return Point:new(self.x % p2.x, self.y % p2.y);
end

function Point:__pow(p2)
    if type(p2) == "number" then
        return Point:new(self.x ^ p2, self.y ^ p2);
    end
    return Point:new(self.x ^ p2.x, self.y ^ p2.y);
end

function Point:__unm()
    return self * -1;
end

function Point:__len()
    return self.length;
end

function Point:__eq(p2)
    return self.x == point.x and self.y == point.y;
end

function Point:__lt(p2)
    if type(p2) == "number" then
        return self.length < p2;
    end
    return self.length < p2.length;
end

function Point:__le(p2)
    if type(p2) == "number" then
        return self.length <= p2;
    end
    return self.length <= p2.length;
end


function Point:get_length()
    return math.sqrt((self.x^2) + (self.y^2));
end



return Point;

