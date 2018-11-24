local Element = import('../Element');

local SignalMixin = import("./SignalMixin");
local Class = import("oop/Class");
local process = import("process");
local TouchEvent = import("../events/TouchEvent");

local SignalListener = Class("SignalListener"):include(SignalMixin);

local InteractiveElementMixin = {};

function InteractiveElementMixin:included(klass)
    if not klass:isSubclassOf(Element) then
        error("InteractiveElementMixin can only be applied to a class that is derived from " .. tostring(Element), 4);
    end
end

function InteractiveElementMixin:__interactive_elm__createListener()
    if not self.__interactive_elm__signalListener then
        local sl = SignalListener:new();
        self.__interactive_elm__signalListener = sl;
    end
    return self.__interactive_elm__signalListener;
end

function InteractiveElementMixin:usesTouchEvents()
    local sl = self:__interactive_elm__createListener();
    local this = self;
    sl.handle_signal_touch = function(...)
        local arg = {...};
        table.remove(arg, 1);
        table.remove(arg, 1);
        return this.handle_signal_touch(self, table.unpack(arg));
    end
    sl:addSignal('touch', '_elm_interactive');
end

function InteractiveElementMixin:enableEvents()
    local sl = self:__interactive_elm__createListener();
    sl:setSignalCategoryEnabled('_elm_interactive', true);
end

function InteractiveElementMixin:handle_signal_touch(screen, x, y, button, player)
    if self.isVisible and self.absoluteRect:hitTest(x,y) then
        local localX = x - self.absoluteRect.x -1;
        local localY = y - self.absoluteRect.y - 1;
        self:emit(TouchEvent:new(x, localX, y, localY, button, player));
    end
end


return InteractiveElementMixin;