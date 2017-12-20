require('xy_map')
require('player')
require('items')

-------------------------------------------------------------------------------
-- Everything is inside the world
-------------------------------------------------------------------------------

world = {}

world.storage = newXYMap()
world.storage._get = world.storage.get

function world.storage:get(x, y)
    if (not world.storage:contains(x, y)) then
        world.storage:add(x, y, initNewPosition())
    end
end

-- maps names of items to items
world.items = {}

function world:registerItem(fields)
    world.items[fields.name] = fields
end

function world:load()
    items:load()
end

function world:contains(x, y)
    return world.storage:contains(x, y)
end

function world:add(x, y, name)
    if world.items[name] then
        world.storage:get(x, y)[world.items[name].type] = name
    else
        error("Node " .. name .. " doesn't exist")
    end
end

function world:safeAdd(x, y, name)
    if world.items[name] then
        if (not world.storage:get(x, y)[world.items[name].type]) then
            world.storage:get(x, y)[world.items[name].type] = name
        end
    else
        error("Node " .. name .. " doesn't exist")
    end
end

local function initNewPosition()
    return {
        floor = "dirt floor",
        small_items = {
            current_item = 0
        },
        big_items = {
            current_item = 0
        },
        wall = false
    }
end

-- Render world
function world:render()
    world.storage:forEach(function(x, y, node)
        if (math.abs(x - player.x) * SIZE * draw.scale < love.graphics.getWidth()
                and math.abs(y - player.y) * SIZE * draw.scale < love.graphics.getHeight()) then
            node.render(x, y)
        end
    end)
end

-- Add thing with the given name at (x, y)
function world:add(x, y, name)
    world.storage:get(x, y)
end

-- Remove everything from (x, y)
function world:remove(x, y)

end

-- Iterate over all things in the world
function world:forEach(fun)

end