local Class = import("oop/Class");
local Element = import("../core/Element");
local Rect = import("../core/Rect");
local unicode = import("unicode")

local RIGHT_FRACTIONAL_CHARS  = {
    unicode.char(0x258F),
    unicode.char(0x258E),
    unicode.char(0x258D),
    unicode.char(0x258C),
    unicode.char(0x258B),
    unicode.char(0x258A),
    unicode.char(0x2589)
};

local TOP_FRACTIONAL_CHARS  = {
    unicode.char(0x2581),
    unicode.char(0x2582),
    unicode.char(0x2583),
    unicode.char(0x2584),
    unicode.char(0x2585),
    unicode.char(0x2586),
    unicode.char(0x2587)
};

local Progressbar = Class("Progressbar", Element);


function Progressbar:initialize()
    Element.initialize(self);
    self._minValue = 0;
    self._maxValue = 100;
    self._value = 0;
    self._barBgColor = 0x0;
    self._barColor = 0x0000ff;
end

function Progressbar:get_minValue()
    return self._minValue;
end

function Progressbar:set_minValue(value)
    if self._minValue ~= value then
        self._minValue = value;
        self:invalidateDisplay();
    end
end

function Progressbar:get_maxValue()
    return self._maxValue;
end

function Progressbar:set_maxValue(value)
    if self._maxValue ~= value then
        self._maxValue = value;
        self:invalidateDisplay();
    end
end

function Progressbar:get_value()
    return self._value;
end

function Progressbar:set_value(value)
    if self._value ~= value then
        self._value = value;
        self:invalidateDisplay();
    end
end

function Progressbar:get_vertical()
    return self._vertical;
end

function Progressbar:set_vertical(value)
    if self._vertical ~= value then
        self._vertical = value;
        self:invalidateDisplay();
    end
end

function Progressbar:get_barColor()
    return self._barColor;
end
function Progressbar:set_barColor(value)
    if self._barColor ~= value then
        self._barColor = value;
        self:invalidateDisplay();
    end
end

function Progressbar:get_barBgColor()
    return self._barBgColor;
end

function Progressbar:set_barBgColor(value)
    if self._barBgColor ~= value then
        self._barBgColor = value;
        self:invalidateDisplay();
    end
end

function Progressbar:drawMidground()
    local min = self._minValue;
    local max = self._maxValue;
    local val = self._value;
    if val < min then
        val = min;
    end
    if val > max then
        val = max;
    end

    local total =  max - min;
    val = val - min;
    local p = val / total;

    local rect = self._measuredRect;

    if self._vertical then
        local barHeight = rect.height;
        self._canvas:fill(Rect:new(0, rect.height - barHeight, rect.width, barHeight), self._barBgColor);
        local barw = barHeight * p;
        local fullbar = math.floor(barw);
        local fraction = math.floor(((barw - fullbar) * 8));
        self._canvas:fill(Rect:new(0, rect.height - fullbar, rect.width, fullbar), self._barColor);
        if fraction > 0 then
            self._canvas:fillChar(Rect:new(0, rect.height - fullbar - 1, rect.width, 1), TOP_FRACTIONAL_CHARS[fraction], self._barColor, self._barBgColor);
           -- self._canvas:fillChar(Rect:new(0, rect.height - fullbar - 1, 1, 1), tostring(fraction), 0xff0000, self.background);
        end
    else
        local barWidth = rect.width;
        self._canvas:fill(Rect:new(0, 0, barWidth, rect.height), self._barBgColor);
        local barw = barWidth * p;
        local fullbar = math.floor(barw);
        local fraction = math.floor(((barw - fullbar) * 8));
        self._canvas:fill(Rect:new(0, 0, fullbar, rect.height), self._barColor);
        if fraction > 0 then
            self._canvas:fillChar(Rect:new(fullbar, 0, 1, rect.height), RIGHT_FRACTIONAL_CHARS[fraction], self._barColor, self._barBgColor);
            --self._canvas:fillChar(Rect:new(fullbar, 0, 1, 1), tostring(fraction), 0xff0000, self.background);
        end
    end
    
end

return Progressbar;