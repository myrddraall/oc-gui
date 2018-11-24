local Class = import("oop/Class");
local thread = import("thread");
local event = import("event");
local GuiApplication = Class('GuiApplication');
local process = import("process");

function GuiApplication:initialize()
    self._isRunning = false;
    self._activeGui = nil;

    self._guiUpdateRate = 0.1;
    self._updateRate = 1;
    self._guiThread = nil;
    self._updateThread = nil;
end

function GuiApplication:createGuis(guiTable)

end

function GuiApplication:update()
    
end

function GuiApplication:_updateGui()
    if self._activeGui then
        self._activeGui:update();
    end
end

function GuiApplication:setActiveGui(name)
    if self._guis[name] then
        self._activeGui = self._guis[name];
    end
end

function GuiApplication:start()
    if not self.isRunning then
        local err = nil;
        local mainTread = thread.create(function(app)
            local succes, error = xpcall(app.run, function(err) 
                return err;
            end, app);
            if not success then
                err = error;
            end
        end, self);
        thread.waitForAny({mainTread});
        if err then
            error("\ncaused by: " .. err);
        else
            print("Exiting...");
        end
    end
end

function GuiApplication:runUpdates()
    while self.isRunning do
        self:update();
        os.sleep(self._updateRate);
    end
end


function GuiApplication:run()
    print("Starting...");
    self._isRunning = true;
    self._guis = {};
    self:createGuis(self._guis);
    
    local updateError = nil;
    local updateThread = thread.create(function(app)
        local succes, error = xpcall(app.runUpdates, function(err) 
            return err .. "\n" .. debug.traceback();
        end, app);
        if not succes then
            updateError = error;
        end
    end, self);
   
    while self.isRunning and updateThread:status() == "running" do
        self:_updateGui();
        os.sleep(self._guiUpdateRate);
    end
    if updateError then
        error("\ncaused by: " .. updateError)
    end
end

function GuiApplication:get_isRunning()
    return self._isRunning;
end

function GuiApplication:get_updateRate()
    return self._updateRate;
end

function GuiApplication:set_updateRate(value)
    self._updateRate = value;
end

function GuiApplication:stop()
    self._isRunning = false;
end

return GuiApplication;