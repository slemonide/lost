-- from http://lua-users.org/wiki/CopyTable
function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function sign(number)
    if (number > 0) then
        return 1
    elseif (number < 0) then
        return -1
    else
        return 0
    end
end

-- Split the string at two at the pattern
function split(string, pattern)
    local splitter_start, splitter_end = string:find(pattern)

    return string:sub(1, splitter_start), string:sub(splitter_end + 1)
end