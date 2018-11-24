local Class = import("oop/Class");
local Group = import("../core/Group");
local InteractiveElementMixin = import("../core/mixins/InteractiveElementMixin");
local Label = import("../common/Label");

local Button = Class("Button", Group):include(InteractiveElementMixin);

function Button:initialize()
    Group.initialize(self);
    self._label = Label:new();
    self._label.left = 1;
    self._label.right = 1;
    self._label.top = 1;
    self._label.bottom = 1;
    self._label.textAlign = "center";
    self._label.vAlign = "middle";
    self.forground = 0x0;
    self.background = 0x666666;
    self.height = 3;
    self.width = 20;
    self:_addElement(self._label);
    self:usesTouchEvents();
    self:enableEvents();
end

function Button:get_text()
    return self._label.text;
end

function Button:set_text(value)
    self._label.text = value;
    self:invalidateDisplay();
end

function Button:set_background(value)
    Group.set_background(self, value);
    self._label.background =  value;
end

function Button:set_foreground(value)
    Group.set_foreground(self, value);
    self._label.foreground =  value;
end

return Button;
