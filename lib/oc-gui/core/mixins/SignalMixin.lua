local event = import("event");


local SignalMixin = {}

--[[ Signal Categories ]]--

function SignalMixin:getSignalCategory(signal)
    checkArg(1, signal, "string");
    if self.__signals__signalCategory then
        return self.__signals__signalCategory[signal];
    end
    return nil;
end

function SignalMixin:isSignalInCategory(signal, cat)
    checkArg(1, signal, "string");
    return self:getSignalCategory(signal) == cat;

end

function SignalMixin:isSignalCategoryEnabled(cat)
    checkArg(1, cat, "string");
    return self.__signals__categoryEnabled and self.__signals__categoryEnabled[cat] == true;
end

function SignalMixin:hasSignalCategory(cat)
    checkArg(1, cat, "string");
    return self.__signals__signalsByCategory and self.__signals__signalsByCategory[cat];
end


function SignalMixin:removeSignalFromCategory(signal)
    checkArg(1, signal, "string");
    local signalCat = self:getSignalCategory(signal);
    if signalCat then
        self.__signals__signalCategory[signal] = nil;
        local catSignals = self.__signals__signalsByCategory[signalCat];
        for i, v in ipairs(catSignals) do
            if v == signal then
                table.remove(catSignals, i);
                break;
            end
        end
    end
end

function SignalMixin:setSignalCategory(signal, cat)
    checkArg(1, signal, "string");
    checkArg(2, cat, "string");

    if self:hasSignal(signal) then
        local currCat = self:getSignalCategory(signal);
        if currCat ~= cat then
            local catEnabled = self:isSignalCategoryEnabled(cat);
            local wasOldCatEnabbled = not catEnabled;
            if currCat then
                wasOldCatEnabbled = self:isSignalCategoryEnabled(currCat);
                local catSignals = self.__signals__signalsByCategory[currCat];
                for i, v in ipairs(catSignals) do
                    if v == signal then
                        table.remove(catSignals, i);
                        break;
                    end
                end
            else
                self.__signals__signalCategory = self.__signals__signalCategory or {};
                self.__signals__signalsByCategory = self.__signals__signalsByCategory or {};
                self.__signals__categoryEnabled = self.__signals__categoryEnabled or {};
            end
            self.__signals__signalCategory[signal] = cat;

            self.__signals__signalsByCategory[cat] = self.__signals__signalsByCategory[cat] or {};
            table.insert(self.__signals__signalsByCategory[cat], signal);
            if catEnabled ~= wasOldCatEnabbled then
                self:setSignalEnabled(signal, catEnabled or false);
            end 
        end
    end
end

function SignalMixin:setSignalCategoryEnabled(cat, enabled)
    if self:hasSignalCategory(cat) then
        self.__signals__categoryEnabled[cat] = enabled;
        local sigList = self.__signals__signalsByCategory[cat];
        for _, signal in ipairs(sigList) do
            if self:isSignalEnabled(signal) ~= enabled then
                self:setSignalEnabled(signal, enabled);
            end
        end
    end
end

function SignalMixin:setAllSignalCategoriesEnabled(enabled)
    if self.__signals__signalsByCategory then
        for cat, _ in pairs(self.__signals__signalsByCategory) do
            self:setSignalCategoryEnabled(cat, enabled);
        end
    end
end

function SignalMixin:setSignalCategoriesEnabled(...)
    if self.__signals__signalsByCategory then
        if #arg == 1 and type(arg[1]) == "table" then
            arg = arg[1];
        end
        for _, cat in ipairs(arg) do
            self:setSignalCategoryEnabled(cat, enabled);
        end
    end
end

--[[ Signals ]]--

function SignalMixin:hasSignal(signal)
    return self.__signals__signalsEnabled and self.__signals__signalsEnabled[signal] ~= nil;
end

function SignalMixin:isSignalEnabled(signal)
    return self.__signals__signalsEnabled and self.__signals__signalsEnabled[signal] == true;
end

function SignalMixin:setSignalEnabled(signal, enabled)
    checkArg(1, signal, "string");
    checkArg(1, enabled, "boolean");
    if self:hasSignal(signal) then
        self.__signals__signalsEnabled[signal] = enabled;
        self:__signals__applyListener(signal);
    end
end

function SignalMixin:addSignal(signal, category)
    checkArg(1, signal, "string");
    if not self:hasSignal(signal) then
        self.__signals__signalsEnabled = self.__signals__signalsEnabled or {};
        self.__signals__signalsEnabled[signal] = false;
        if category then
            self:setSignalCategory(signal, category);
        end
    end
end

function SignalMixin:removeSignal(signal)
    checkArg(1, signal, "string");
    if self:hasSignal(signal) then
        self:setSignalEnabled(signal, false);
        self:removeSignalFromCategory();
        self.__signals__signalsEnabled[signal] = nil;
    end
end


function SignalMixin:__signals__getListenerCancelFn(signal)
    self.__signals__listenerCancelFns = self.__signals__listenerCancelFns or {};
    return self.__signals__listenerCancelFns[signal];
end

function SignalMixin:__signals__applyListener(signal)
    local currCancelFn = self:__signals__getListenerCancelFn(signal);
    local shouldEnable = self:isSignalEnabled(signal);

    if currCancelFn and not shouldEnable then
        -- disable
        currCancelFn();
    elseif not currCancelFn and shouldEnable then
        -- enable
        local this = self;
        local callback = self:__signals__createListenerCallback(signal);

        if callback then
            local cancel = function()
                event.ignore(signal, callback);
                this.__signals__listenerCancelFns[signal] = nil;
                this.__signals__signalsEnabled[signal] = false;
            end
            self.__signals__listenerCancelFns[signal] = cancel;
            event.listen(signal, callback);
        else 
            error("Class '" .. self.class.name .. "' needs to have a signal method listener", 3);
        end
    end

end

function SignalMixin:__signals__createListenerCallback(signal)
    local this = self;
    local handleFn;

    if type(self['handle_signal_' .. signal]) == 'function' then
        handleFn = self['handle_signal_' .. signal];
    elseif type(self['handle_signals']) == 'function' then
        handleFn = self['handle_signals'];
    end

    if handleFn then
        return function(...)
            local arg = {...};
            local ret = handleFn(this, table.unpack(arg));
            if ret == false then
                this.__signals__listenerCancelFns[signal] = nil;
                this.__signals__signalsEnabled[signal] = false;
            end
            return ret;
        end;
    end
end

function SignalMixin:disableAllSignals()
    if self.__signals__signalsEnabled then
        for signal,_ in pairs(self.__signals__signalsEnabled) do
            self:setSignalEnabled(signal, false);
        end
    end
end


return SignalMixin;


--[[  --- OLD --- 



function SignalMixin:addSignalListener(signal, cat)
    cat = cat or "default";
    if not self:hasSignalListener(signal) then
        self.__signals__listenersettings = self.__signals__listenersettings or {};
        self.__signals__listeners = self.__signals__listeners or {};
        self.__signals__listeners[signal] = false;
        self.__signals__listenersettings[signal] = false;
        self:addSignalToCategory(signal, cat);
    end
end

function SignalMixin:__signal__apply_listener(signal)
    if self:hasSignalListener(signal) then
        local shouldEnable = self:isSignalEnabled();
        local isActive = self:__signal__isSignalActive(signal);
        if shouldEnable and not isActive then
            local cbFn = function(...)
                print(unpack(arg));
            end
            local cancelFn = function ()
                event.ignore(signal, cbFn);
            end
            event.listen(signal, cbFn);
            self.__signals__listeners[signal] = cancelFn;

        elseif not shouldEnable and isActive then
            self.__signals__listeners[signal]();
            self.__signals__listeners[signal] = false;
        end
    end
end

function SignalMixin:__signal__isSignalActive(signal)
    return self.__signals__listeners and self.__signals__listeners[signal];
end

function SignalMixin:addSignalToCategory(signal, cat)
    cat = cat or "default";
    if not self:isSignalInCategory(signal, cat) then
        self.__signals__signalsByCategory = self.__signals__signalsByCategory or {};
        self.__signals__signalsByCategory[cat] = self.__signals__signalsByCategory[cat] or {};
        table.insert(self.__signals__signalsByCategory[cat], signal);

        self.__signals__categoriesBySignal = self.__signals__categoriesBySignal or {};
        self.__signals__categoriesBySignal[signal] = self.__signals__categoriesBySignal[signal] or {};
        table.insert(self.__signals__categoriesBySignal[signal], cat);
        local catEnabled = self:isSignalCategoryEnabled(cat);
        self.__signals__listenersettings[signal] = catEnabled;
        self.

    end
end

function SignalMixin:hasSignalListener(signal)
    return self.__signals__listenersettings and self.__signals__listenersettings[signal] ~= nil;
end

function SignalMixin:isSignalEnabled(signal)
    return self.__signals__listenersettings and self.__signals__listenersettings[signal] == true;
end

function SignalMixin:isSignalInCategory(signal, cat)
    if not self.__signals__signalsByCategory or not self.__signals__signalsByCategory[cat] then
        return false;
    end

    for _, v in ipairs(self.__signals__signalsByCategory[cat]) do
        if v == signal then
            return true;
        end
    end
    return false;
end

function SignalMixin:removeSignalFromCategory(signal, cat)
    if self.__signals__categoriesBySignal and self.__signals__categoriesBySignal[signal] then
        for i,v in ipairs(self.__signals__categoriesBySignal[signal]) do
            if v == cat then
                table.remove(self.__signals__categoriesBySignal[signal], i);
                break;
            end
        end
    end
    if self.__signals__signalsByCategory and self.__signals__signalsByCategory[cat] then
        for i,v in ipairs(self.__signals__signalsByCategory[cat]) do
            if v == signal then
                table.remove(self.__signals__signalsByCategory[cat], i);
                break;
            end
        end
    end

end

function SignalMixin:removeSignalListener(signal)
    if self:hasSignalListener(signal) then
        self.__signals__listenersettings[signal] = nil;
        if self.__signals__listeners[signal] then
            self.__signals__listeners[signal]();
        end
        self.__signals__listeners[signal] = nil;
        for _,v in ipairs(self.__signals__categoriesBySignal[signal]) do
            self:removeSignalFromCategory(signal, v);
        end
    end
end

function SignalMixin:isSignalCategoryEnabled(cat)
    return self.__signals__catsEnabled and self.__signals__catsEnabled[cat] = true;
end

function SignalMixin:setSignalCategoryEnabled(cat, enabled)
    self.__signals__catsEnabled = self.__signals__catsEnabled or {};
    local current = self.__signals__catsEnabled[cat];
    if current ~= enabled then
        self.__signals__catsEnabled[cat] = enabled;
        if self.__signals__signalsByCategory and self.__signals__signalsByCategory[cat] then
            for _,signal in ipairs(self.__signals__signalsByCategory[cat]) do
                self.__signals__listenersettings[signal] = enabled;
                self:__signal__apply_listener(signal);
            end
        end
    end
end
 ]]--
