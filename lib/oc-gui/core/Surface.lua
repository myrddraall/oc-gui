local Class = import("oop/Class");
local Rect = import("./Rect");


local Surface = Class("Surface");

function Surface:initialize(gpu, viewPort)
    self._gpu = gpu or require("component").gpu;
    self.viewPort = viewPort;
end

function Surface:get_viewPort()
    return self._viewPort;
end

function Surface:set_viewPort(val)
    self._viewPort = val or Rect:new();
end


function Surface:fillChar(rect, char,  fgColor, bgColor)
    self:_fill(rect, bgColor, char, fgColor);
end

function Surface:fill(rect, bgColor)
    self:_fill(rect, bgColor);
end

function Surface:_fill(rect, bgColor, char,  fgColor)
    local iRect = self.viewPort:intersect(rect);
    if iRect.width < 1 or iRect.height < 1 then return end

    char = char or " ";
    fgColor = fgColor or self.foreground;
    bgColor = bgColor or self.background;

    self._gpu.setBackground(bgColor);
    self._gpu.setForeground(fgColor);
    self._gpu.fill(iRect.x + 1, iRect.y + 1, iRect.width, iRect.height, char);
end

function Surface:set(x, y, string, vertical,  fgColor, bgColor)
    local len = string:len();
    local rect = Rect:new(x, y, 1, 1);

    if vertical then
        rect.height = len;
    else
        rect.width = len;
    end

    local iRect = self.viewPort:intersect(rect);
    
    if iRect.width < 1 or iRect.height < 1 then return end

    fgColor = fgColor or self.foreground;
    bgColor = bgColor or self.background;
    self._gpu.setBackground(bgColor);
    self._gpu.setForeground(fgColor);

    local start;

    if vertical then
        start = iRect.y - y + 1;
        len = iRect.height - 1;
    else
        start = iRect.x - x + 1;
        len = iRect.width - 1;
    end
  
    string = string:sub(start, start + len );
    self._gpu.set(iRect.x + 1, iRect.y + 1, string, vertical);
end


function Surface:clear()
   self._gpu.setBackground(self.background);
   self._gpu.fill(self.viewPort.x + 1, self.viewPort.y + 1, self.viewPort.width, self.viewPort.height, " ");
end


function Surface:get_background()
    return self._background or 0x0;
end

function Surface:set_background(val)
    self._background = val;
end

function Surface:get_foreground()
    return self._foreground or 0x0;
end

function Surface:set_foreground(val)
    self._foreground = val;
end

return Surface;
