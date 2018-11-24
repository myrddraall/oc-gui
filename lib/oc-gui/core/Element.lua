local Class = import("oop/Class");
local Event = import("oop/Event");
local EventEmitter = import("oop/EventEmitter");
local ParentChangeEvent = import("./events/ParentChangeEvent");
local Canvas = import("./Canvas");
local Rect = import("./Rect");
local Point = import("./Point");
local Element = Class("Element"):include(EventEmitter);

function Element:initialize()
    
    self._rect = Rect:new();
    self._measuredRect = Rect:new();
    self._absRect = Rect:new();
    self._canvas = Canvas:new(self);
    self._visible = true;
    self._display = true;
    self._leftParsed = self:parseCoord(nil);
    self._rightParsed = self:parseCoord(nil);
    self._widthParsed = self:parseCoord(nil);
    self._topParsed = self:parseCoord(nil);
    self._bottomParsed = self:parseCoord(nil);
    self._heightParsed = self:parseCoord(nil);
    self._positionInvalidated = true;
    self._sizeInvalidated = true;
    self._displayInvalidated = true;
end


function Element:get_absoluteRect()
    return self._absRect;
end

function Element:get_isVisible()
    if not self.visible or not self.display then
        return false;
    end
    if self.parent then
        return self.parent.isVisible;
    end
    return true;
end

function Element:get_x()
    return self._left;
end

function Element:set_x(val)
    self.left = val;
end

function Element:get_left()
    return self._left;
end

function Element:set_left(val)
    if self._left ~= val then
        self._left = val;
        self._leftParsed = self:parseCoord(val);
        self:invalidatePosition();
    end
end



function Element:get_right()
    return self._right;
end

function Element:set_right(val)
    if self._right ~= val then
        self._right = val;
        self._rightParsed = self:parseCoord(val);
        self:invalidatePosition();
    end
end

function Element:get_width()
    return self._width;
end

function Element:set_width(val)
    if self._width ~= val then
        self._width = val;
        self._widthParsed = self:parseCoord(val);
        self:invalidateSize();
    end
end

function Element:get_minWidth(value)
    return self._minWidth;
end

function Element:set_minWidth(value)
    if self._minWidth ~= value then
        self._minWidth = value;
        self:invalidateSize();
    end
end

function Element:get_maxWidth(value)
    return self._maxWidth;
end

function Element:set_maxWidth(value)
    if self._maxWidth ~= value then
        self._maxWidth = value;
        self:invalidateSize();
    end
end




function Element:get_y()
    return self._top;
end

function Element:set_y(val)
    self.top = val;
end

function Element:get_top()
    return self._top;
end

function Element:set_top(val)
    if self._top ~= val then
        self._top = val;
        self._topParsed = self:parseCoord(val);
        self:invalidatePosition();
    end
end

function Element:get_bottom()
    return self._bottom;
end

function Element:set_bottom(val)
    if self._bottom ~= val then
        self._bottom = val;
        self._bottomParsed = self:parseCoord(val);
        self:invalidatePosition();
    end
end


function Element:get_height()
    return self._height;
end

function Element:set_height(val)
    if self._height ~= val then
        self._height = val;
        self._heightParsed = self:parseCoord(val);
        self:invalidateSize();
    end
end


function Element:get_minHeight(value)
    return self._minHeight;
end

function Element:set_minHeight(value)
    if self._minHeight ~= value then
        self._minHeight = value;
        self:invalidateSize();
    end
end

function Element:get_maxHeight(value)
    return self._maxHeight;
end

function Element:set_maxHeight(value)
    if self._maxHeight ~= value then
        self._maxHeight = value;
        self:invalidateSize();
    end
end

function Element:get_background()
    return self._canvas.background or self._parent.background;
end

function Element:set_background(val)
    if self._canvas.background ~= val then
        self._canvas.background = val;
        self:invalidateDisplay();
    end
end

function Element:get_foreground()
    return self._canvas.foreground  or self._parent.background;
end

function Element:set_foreground(val)
    if self._canvas.foreground ~= val then
        self._canvas.foreground = val;
        self:invalidateDisplay();
    end
end


function Element:get_root()
    if self.parent then
        return self.parent.root;
    end
    return nil;
end

function Element:get_parent()
    return self._parent;
end

function Element:set_parent(value)
    if self._parent ~= value then
        self:_setParentEventEmitter(value);
        local evt = ParentChangeEvent:new(value, self._parent);
        self._parent = value;
        self:invalidatePosition();
        self:emit(evt);
    end
end

function Element:get_zIndex(value)
    return self._zIndex;
end

function Element:set_zIndex(value)
    if self._zIndex ~= value then
        self._zIndex = value;
        self:invalidateDisplay(true);
    end
end

function Element:get_visible(value)
    return self._visible;
end

function Element:set_visible(value)
    if self._visible ~= value then
        self._visible = value;
        self:invalidateDisplay(true);
    end
end

function Element:get_display(value)
    return self._display;
end

function Element:set_display(value)
    if self._display ~= value then
        self._display = value;
        self:invalidateSize();
        self:invalidatePosition();
    end
end

function Element:invalidateSize()
    self._sizeInvalidated = true;
    self:invalidateDisplay(true);
end

function Element:invalidatePosition()
    self._positionInvalidated = true;
    self:invalidateDisplay(true);
end

function Element:invalidateDisplay(invalidateParent)
   -- print("invalidateDisplay", self)
    if not self._displayInvalidated then
        self._displayInvalidated = true;
        if invalidateParent and self.parent then
            self.parent:invalidateDisplay(invalidateParent);
        end
    end
end


function Element:parseCoord(coord)
    if coord == nil then
        return {"unset", nil};
    elseif type(coord) == "string" then
        if coord == "auto" then
            return {"auto", nil};
        elseif coord:sub(coord:len()) == "%" then
            return {"%", tonumber(coord:sub(1, coord:len() - 1))};
        end
    end
    return {"number", (tonumber(coord) or 0)};
end

function Element:getSizeAndPosDeps(dir)
    if not dir then
        local pDepH, cDepH = self:getSizeAndPosDeps("h");
        local pDepV, cDepV = self:getSizeAndPosDeps("v");
        return (pDepH or pDepV), (pDepV or cDepV);
    end

    local pL, pR, pW;
    if dir == "v" then
        pL = self._topParsed[1];
        pR = self._bottomParsed[1];
        pW = self._heightParsed[1];
    else
        pL = self._leftParsed[1];
        pR = self._rightParsed[1];
        pW = self._widthParsed[1];
    end
   

    local ldep = 0;

    if pL == "number" then
        ldep = 1;
    elseif pL == "auto" or pL == "%" then
        ldep = 2;
    end

    local rdep = 0;

    if pR == "number" then
        rdep = 1;
    elseif pR == "auto" or pR == "%" then
        rdep = 2;
    end

    local wdep = 0;

    if pW == "number" then
        wdep = 1;
    elseif pW == "%" then
        wdep = 2;
    elseif pW == "auto" then
        rwdep = 4;
    end
    if not (pL == "auto" and pR == "auto" and wdep < 4) then
        if ldep > 0 and wdep > 0 and wdep < 4 then
            rdep = 0;
        elseif ldep > 0 and rdep > 0 and wdep == 4 then
            wdep = 0;
        end
    end

    local hasParentDep = false;
    local hasChildDep = false;

    if ldep > 1 or rdep > 1 or (wdep > 1 and wdep < 4) then
        hasParentDep = true;
    end

    if ldep > 0 and rdep > 0 then
        hasParentDep = true;
    end

    if wdep == 4 then 
        hasChildDep = true;
    end

    return hasParentDep, hasChildDep, ldep, wdep, rdep;

end

function Element:measureHorizontal()
    if not self._display then
        return;
    end
    if self._positionInvalidated or self._sizeInvalidated then
        local mesuredRect = self._measuredRect;
        local hasParentDep, hasChildDep, ldep, wdep, rdep = self:getSizeAndPosDeps("h");
    -- print("H", hasParentDep, hasChildDep, ldep, wdep, rdep);
        if not hasChildDep then
            local lV = self._leftParsed[2];
            local rV = self._rightParsed[2];
            local wV = self._widthParsed[2];

            local parentM;
            if hasParentDep then
                parentM = self:getParentMesuredRect();
                if ldep == 2 then
                    lV = math.floor(parentM.width * ((lV or 0)/100) + 0.5);
                end

                if rdep == 2 then
                    rV = math.floor(parentM.width * ((rV or 0)/100) + 0.5);
                end

                if wdep == 2 then
                    wV = math.floor(parentM.width * ((wV or 0)/100) + 0.5);
                end
            end

    --     print(lV, wV, rV)

            -- left aligned
            if  
                (rdep == 0 and (ldep ~= 0 or wdep ~= 0)) or 
                (ldep == 0 and rdep == 0 and wdep == 0)
            then
                mesuredRect.x = lV;
                mesuredRect.width = wV;
            -- right aligned
            elseif ldep == 0 and (rdep ~= 0 or wdep ~= 0) then
                mesuredRect.x = parentM.width - wV - rV;
                mesuredRect.width = wV;
            -- constrained
            elseif ldep ~= 0 and rdep ~= 0 then
                if self._leftParsed[1] == "auto" and  self._rightParsed[1] == "auto" then
                    mesuredRect.width = wV;
                    mesuredRect.x = parentM.width/2 - wV/2;
                else
                    mesuredRect.x = lV;
                    mesuredRect.width = parentM.width - lV - rV;
                end
            else
                print("UNACCOUNTED!!!")
            end
        end
    end
end

function Element:measureVertical()
    if not self._display then
        return;
    end
    if self._positionInvalidated or self._sizeInvalidated then
        local mesuredRect = self._measuredRect;
        
        local hasParentDep, hasChildDep, tdep, hdep, bdep = self:getSizeAndPosDeps("v");
    --  print("V", hasParentDep, hasChildDep, tdep, hdep, bdep);
        if not hasChildDep then
            local tV = self._topParsed[2];
            local bV = self._bottomParsed[2];
            local hV = self._heightParsed[2];

            local parentM;
            if hasParentDep then
                parentM = self:getParentMesuredRect();
                if tdep == 2 then
                    tV = math.floor(parentM.height * ((tV or 0)/100) + 0.5);
                end

                if bdep == 2 then
                    bV = math.floor(parentM.height * ((bV or 0)/100) + 0.5);
                end

                if hdep == 2 then
                    hV = math.floor(parentM.height * ((hV or 0)/100) + 0.5);
                end
            end

    --     print(tV, hV, bV)

            -- top aligned
            if 
                (bdep == 0 and (tdep ~= 0 or hdep ~= 0)) or
                (tdep == 0 and bdep == 0 and hdep == 0)
            then
                mesuredRect.y = tV;
                mesuredRect.height = hV;
            -- bottom aligned
            elseif tdep == 0 and (bdep ~= 0 or hdep ~= 0) then
                mesuredRect.y = parentM.height - hV - bV;
                mesuredRect.height = hV;
            -- constrained
            elseif tdep ~= 0 and bdep ~= 0 then
                if self._topParsed[1] == "auto" and  self._bottomParsed[1] == "auto" then
                    mesuredRect.height = hV;
                    mesuredRect.y = parentM.height/2 - hV/2;
                else
                    mesuredRect.y = tV;
                    mesuredRect.height = parentM.height - tV - bV;
                end
            else
                print("UNACCOUNTED!!!")
            end
        end
    end
end


function Element:getParentMesuredRect()
    if self._parent then
        return self._parent._measuredRect;
    end
end

function Element:startMeasure()
    if self._positionInvalidated or self._sizeInvalidated then
        self._oMesuredRect = self._measuredRect;
        self._measuredRect = Rect:new();
    end
end

function Element:endMeasure()
    if self._positionInvalidated or self._sizeInvalidated then
        local mesuredRect = self._measuredRect;
        local parentAbsPos;
        if self._parent then
            parentAbsPos = self._parent.absoluteRect.pos;
        else
            parentAbsPos = Point:new(0, 0);
        end

        local absPos = parentAbsPos + mesuredRect.pos;
        self._absRect = Rect:new(absPos.x, absPos.y, mesuredRect.width, mesuredRect.height);
        self._canvas.width = mesuredRect.width;
        self._canvas.height = mesuredRect.height;
        self._canvas:updatePositionAndSize();
        
        self._positionInvalidated = false;
        self._sizeInvalidated = false;
    end
end

function Element:doLayout()
   
end

function Element:draw()
    if self._displayInvalidated then
        if self._visible and self._display then
            self:drawBackground();
            self:drawMidground();
            self:drawForeground();
        end
        self._displayInvalidated = false;
    end
end

function Element:drawBackground()
    self._canvas:clear();
end

function Element:drawMidground()
    
end

function Element:drawForeground()
    
end

--[[

    function Element:update()
        if self._positionInvalidated or self._sizeInvalidated  then
            self:measure();
            self:doLayout();
            self._positionInvalidated = false;
            self._sizeInvalidated = false;
        end
        if self._displayInvalidated then
            self:draw();
            self._displayInvalidated = false;
        end
    end
]]

return Element;