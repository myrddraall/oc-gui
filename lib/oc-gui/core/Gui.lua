local Class = import("oop/Class");
local Container = import("./Container");
local component = require("component");
local Rect = import("./Rect");


local Gui = Class("Gui", Container);

function Gui:initialize(screen, gpu)
    Container.initialize(self);
    self.screen = screen or component.screen;
    self.gpu = gpu or component.gpu;
    self.width = "100%";
    self.height = "100%";
end

function Gui:set_screen(screen)
    if type(screen) == "string" then
        screen = component.proxy(screen);
    end
    if self._screen ~= screen then
        self._screen = screen;
        self:invalidateGPUBinging();
    end
end

function Gui:get_screen()
    return self._screen;
end

function Gui:set_gpu(gpu)
    if type(gpu) == "string" then
        gpu = component.proxy(gpu);
    end
    if self._gpu ~= gpu then
        self._gpu = gpu;
        self:invalidateGPUBinging();
    end
end

function Gui:get_gpu()
    return self._gpu;
end

function Gui:invalidateGPUBinging()
    self._gpuBindingInvalid = true;
end

function Gui:_bindScreenToGPU()
    local screenAddress = self._gpu.getScreen();
    if screenAddress ~= self._screen.address then
        self._gpu.bind(self._screen.address);
        self._screenMeasuredRect = nil;
        self._gpuBindingInvalid = false;
    end
end


function Gui:get_root()
    return self;
end

function Gui:get_parent()
    return nil;
end

function Gui:set_parent() 
    error("Gui cannot have a parent", 2);
end


function Gui:getParentMesuredRect()
    if not self._screenMeasuredRect then
        if self.gpu then
            local w, h = self.gpu.getResolution()
            self._screenMeasuredRect = Rect:new(0, 0, w, h);
        else
            self._screenMeasuredRect = Rect:new();
        end
    end
    return self._screenMeasuredRect;
end

function Gui:update() 
    if self._gpuBindingInvalid then
        self:_bindScreenToGPU();
    end

    self:startMeasure();
    self:measureHorizontal();
    self:measureVertical();
    self:endMeasure();

    self:draw();
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
    
return Gui;