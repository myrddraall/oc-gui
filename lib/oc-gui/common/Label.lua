local Class = import("oop/Class");
local Element = import("../core/Element");


local Label = Class("Label", Element);

function Label:initialize()
    Element.initialize(self);
    self._text = "";
end

function Label:get_text()
    return self._text;
end

function Label:set_text(value)
    if self._text ~= value then
        self._text = value;
        self:invalidateDisplay();
    end
end

function Label:get_textAlign()
    return self._textAlign;
end

function Label:set_textAlign(value)
    if self._textAlign ~= value then
        self._textAlign = value;
        self:invalidateDisplay();
    end
end

function Label:get_vAlign()
    return self._vAlign;
end

function Label:set_vAlign(value)
    if self._vAlign ~= value then
        self._vAlign = value;
        self:invalidateDisplay();
    end
end

function Label:drawMidground()
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
end

return Label;
