local Class = import("oop/Class");
local TextUtil = import("../../util/TextUtil");
local CssParser = Class("CssParser");
local serialization = import("serialization");

function CssParser:initialize()
    self.strings = {}
end


function CssParser:parse(css)
    self.source = css;
    css = self:_prepareCss(css);
    self:_parseStatements(css);
    --print(css);
end

function CssParser:_prepareCss(source)
    source = self:_pasrseQuotedSStrings(source);
    source = self:_deleteQuotes(source);
    return source;
   -- local newobjects = self:parse_statements(self.text)
    --print(self.source);
end

function CssParser:_pasrseQuotedSStrings(text)
    local this = self;
    local function replace_string(s)
        local count = #self.strings + 1;
        self.strings[count] = s:sub(2,-2);
        return "%%" .. count;
      end
      local text = text:gsub("(%b'')", replace_string);
      text = text:gsub('(%b"")', replace_string);
      return text;
end

function CssParser:_deleteQuotes(text)
    return text:gsub("/%*.-%*/", " ");
end


function CssParser:_parseStatements(text)
    local pos = 0 
    local objects = {} 
    local startpos, obj, at
    while pos do
        startpos, pos, at = string.find(text, "(@?)[%w.]+", pos + 1);
        if startpos then
            -- find start of the next statement and detect whether it is an at-rule
            if at == "@" then 
                obj, pos = self:_parseAtRule(text, startpos);
            else
                obj, pos = self:_parseRule(text, startpos)
            end
            table.insert(objects, obj)
        end
        os.sleep(0);
    end
end

function CssParser:_parseAtRule(text, startpos)

end

function CssParser:_parseRule(text, startpos)
    
    local startpos, pos, selector, block = string.find(text, "(.-)(%b{})", startpos);
    
    local obj = {
        type = "rule",
        selector = self:_parseSelectors(selector), 
        properties = self:_parseProperties(block:sub(2,-2)) -- remove the brackets using string.sub
    };
    
    return obj, pos

end

function CssParser:_parseSelectors(selector)
    -- TODO: TOKENIZE SELECTROE
    local selectorParts = TextUtil.split(selector, ",");
    local selectors = {};
    for _,s in ipairs(selectorParts) do
        local sel = self:_parseSelector(TextUtil.trim(s));
        if sel then
            table.insert(selectors, sel);
        end
        --[[
            
        local sels = TextUtil.split(TextUtil.trim(s), " ");
        local actualSels = {};
        for _,d in ipairs(sels) do
            if d then
                table.insert(actualSels, d);
            end
        end
        selectors[i] = actualSels;
        ]]--
    end

    print(serialization.serialize(selectors, true));


    return selectors;
end

function CssParser:_parseSelector(selector)
    local selectorParts = TextUtil.split(selector, " ");
    local selectors = {}
    for _,s in ipairs(selectorParts) do
        if s ~= "" then
            local property, value, v2,v3 = s:match("([\\.]%w+)");
            print(property, value,v2, v3);
            table.insert(selectors, s);
        end
    end
    return selectors;
end

function CssParser:_parseProperties(block)
    local rules = TextUtil.split(block, ";");
    
    local properties = {};
    for _, rule in ipairs(rules) do
        local property, value = rule:match("%s*(.+)%s*:%s*(.+)%s*");
        if property then
            properties[property] = value;
        end
    end
    return properties;
    
end

return CssParser;