local TextUtil = {};

function TextUtil.split(s, delimiter, limit)
    local result = {};
    local c = 0;
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
        c = c + 1;
        if limit ~= nil and c >= limit then
            break;
        end
    end
    return result;
end

function TextUtil.splitLines(text, wrap)
    local lines =  TextUtil.split(text, '\n');
    if wrap == nil then
        return lines;
    end
    
end

function TextUtil.trim(text)
    local match = string.match;
    return match(text,'^()%s*$') and '' or match(text,'^%s*(.*%S)');
end


function TextUtil.padLeft(str, len, char)
    if char == nil then char = ' ' end
    return str .. string.rep(char, len - #str);
end

function TextUtil.padRight(str, len, char)
    if char == nil then char = ' ' end
    return string.rep(char, len - #str) .. str;
end

function TextUtil.padCenter(str, len, char)
    if char == nil then char = ' ' end
    local pad = (len - #str) / 2;
    return string.rep(char, math.ceil(pad)) .. str .. string.rep(char, math.floor(pad));
end

return TextUtil;