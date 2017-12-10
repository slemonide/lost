-------------------------------------------------------------------------------
-- A collection that maps (x,y) coordinates to arbitrary objects
-------------------------------------------------------------------------------

function newXYMap()
    local xy_map = {}
    xy_map.storage = {}
    xy_map.size = 0

    function xy_map:add(x, y)
        if (not xy_map.storage[x]) then
            xy_map.storage[x] = {}
        end
        xy_map.storage[x][y] = true

        xy_map.size = xy_map.size + 1
    end

    function xy_map:forEach(fun)
        local index = 1
        for x, yArray in pairs(xy_map.storage) do
            for y, thing in pairs(yArray) do
                assert (thing)
                local result = fun(x, y, thing, index)
                if (result) then
                    return result
                end
                index = index + 1
            end
        end
    end

    function xy_map:contains(x, y)
        return (xy_map.storage[x] or {})[y]
    end

    function xy_map:remove(x, y)
        if (xy_map.storage[x] or {})[y] then
            xy_map.storage[x][y] = nil

            -- clean up if xy_map[x] is empty
            if (not xy_map.storage[x]) then
                xy_map.storage[x] = nil
            end
        end

        xy_map.size = xy_map.size - 1
    end

    function xy_map:randomPosition()
        local function newFunction()
            local randomChoice = math.random(xy_map.size)
            return function(x, y, _, index)
                if (index == randomChoice) then
                    return {x = x, y = y}
                end
            end
        end

        return xy_map:forEach(newFunction())
    end

    return xy_map
end