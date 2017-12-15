require('candles')
require('coins')
require('ghosts')

generator_helpers = {}

-- Return a list of nodes that are safely accesible from (x, y)
-- I.e. is walkable and not deadly
local function getConnections(x, y)
    local out = {}

    local function checkNeighbour(dx, dy)
        local x = x + dx
        local y = y + dy
        if (nodes:isWalkable(x, y) and not nodes:isDeadly(x, y)) then
            table.insert(out, {
                x = x,
                y = y
            })
        end
    end

    checkNeighbour(1, 0)
    checkNeighbour(-1, 0)
    checkNeighbour(0, 1)
    checkNeighbour(0, -1)

    return out
end

-- Checks if given position can be walked around, if it is blocking path
function generator_helpers.canWalkAround(x, y)
    local connections = getConnections(x, y)

    if (#connections == 1) then
        return true
    end
    -- TODO: add more complicated path searching algorithm. Might want to try to run it in parallel.
end