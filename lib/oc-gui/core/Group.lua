local Class = import("oop/Class");
local Element = import("./Element");


local Group = Class("Group", Element);

function Group:initialize()
    Element.initialize(self);
    self._elements = {};
end

function Group:_addElement(element)
    if element.parent then
        element.parent:_removeElement(element);
    end

    table.insert(self._elements, element);
    element.parent = self;
    self:invalidateSize();
end

function Group:_removeElement(element)
    for i = 1, #self._elements do
        if self._elements[i] == element then
            table.remove(self._elements, i);
            element.parent = nil;
            self:invalidateSize();
            break;
        end
    end
end

function Group:invalidateDisplay(invalidateParent)
    if not self._displayInvalidated then
        Element.invalidateDisplay(self, invalidateParent);
        for i = 1, #self._elements do
            self._elements[i]:invalidateDisplay();
        end
    end
end

function Group:measureHorizontal()
    for i = 1, #self._elements do
        local element = self._elements[i];
        local hasParentDep = element:getSizeAndPosDeps("h");
        if not hasParentDep then
            element:measureHorizontal();
        end
    end
    if self._positionInvalidated or self._sizeInvalidated then
        Element.measureHorizontal(self);
    end
    for i = 1, #self._elements do
        local element = self._elements[i];
        local hasParentDep = element:getSizeAndPosDeps("h");
        if hasParentDep then
            element:measureHorizontal();
        end
    end

end

function Group:measureVertical()
    for i = 1, #self._elements do
        local element = self._elements[i];
        local hasParentDep = element:getSizeAndPosDeps("v");
        if not hasParentDep then
            element:measureVertical();
        end
    end
    if self._positionInvalidated or self._sizeInvalidated then
        Element.measureVertical(self);
    end
    for i = 1, #self._elements do
        local element = self._elements[i];
        local hasParentDep = element:getSizeAndPosDeps("v");
        if hasParentDep then
            element:measureVertical();
        end
    end
    
end

function Group:startMeasure()
    if self._positionInvalidated or self._sizeInvalidated then
        Element.startMeasure(self);
    end
    for i = 1, #self._elements do
        self._elements[i]:startMeasure();
    end
    
end

function Group:endMeasure()
    if self._positionInvalidated or self._sizeInvalidated then
        Element.endMeasure(self);
    end
    for i = 1, #self._elements do
        self._elements[i]:endMeasure();
    end
end

function Group:doLayout()
    Element.doLayout(self);
end

function Group:draw()
    if self._visible and self._display then
        if self._displayInvalidated then
            table.sort(self._elements, function(a, b)
                local aZ = a.zIndex or 0;
                local bZ = b.zIndex or 0;
                return aZ < bZ;
            end);
            self:drawBackground();
        end
        self:drawMidground();
        if self._displayInvalidated then
            self:drawForeground();
        end
    end
    self._displayInvalidated = false;
end

function Group:drawMidground()
    for i = 1, #self._elements do
        self._elements[i]:draw();
    end
end


return Group;