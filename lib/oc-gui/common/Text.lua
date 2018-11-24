local Class = import("oop/Class");
local Element = import("../core/Element");
local TextUtil = import("../util/TextUtil");

local Text = Class("Text", Element);

function Text:initialize()
    Element.initialize(self);
    self._text = "";
    self._lines = {};
end

function Text:get_text()
    return self._text;
end

function Text:set_text(value)
    if self._text ~= value then
        self._text = value;
        self._lines = TextUtil.splitLines(value);
        self:invalidateDisplay();
    end
end

function Text:get_altBackground()
    return self._altBackground;
end

function Text:set_altBackground(value)
    if self._altBackground ~= value then
        self._altBackground = value;
        self:invalidateDisplay();
    end
end

function Text:get_textAlign()
    return self._textAlign;
end

function Text:set_textAlign(value)
    if self._textAlign ~= value then
        self._textAlign = value;
        self:invalidateDisplay();
    end
end


function Text:drawMidground()
    local rect = self._measuredRect;
    local hAlign = self._textAlign or "left";
    local bgColors = {self.background, self.altBackground or self.background};
    local useAlt = self.altBackground ~= nil;

    for line, value in ipairs(self._lines) do
        value = value or "";
        local hOffset = 0;
        if hAlign == "right" then
            if useAlt then
                value = TextUtil.padRight(value, rect.width);
            else
                hOffset = rect.width - value:len();
            end
        elseif hAlign == "center" then
            if useAlt then
                value = TextUtil.padCenter(value, rect.width);
            else
                hOffset = (rect.width - value:len()) / 2;
            end
        else
            if useAlt then
                value = TextUtil.padLeft(value, rect.width);
            end
        end
        
        local evenOdd = (line - 1) % 2 + 1;

        self._canvas:set(hOffset, line - 1, tostring(value), false, self.foreground, bgColors[evenOdd]);
    end
    --[[

        local text = self._text or "";
        local hAlign = self._textAlign or "left";
        local vAlign = self._vAlign or "top";
        local rect = self._measuredRect;
    
        local hOffset = 0;
        if hAlign == "right" then
            hOffset = rect.width - text:len();
        elseif hAlign == "center" then
            hOffset = (rect.width - text:len()) / 2;
        end
    
        local vOffset = 0;
        if vAlign == "bottom" then
            vOffset = rect.height - 1;
        elseif vAlign == "middle" then
            vOffset = math.floor(((rect.height - 1) / 2));
        end
    
        self._canvas:set(hOffset, vOffset, tostring(text), false, self.foreground, self.background);
    ]]
end

return Text;
