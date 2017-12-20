require('textures')
require('xy_map')

------------------------
-- A node representation of the world
------------------------

-- all nodes in the world
nodes = {}
nodes.storage = newXYMap()
nodes.names = {}

function nodes:safeAddNode(x, y, name)
    nodes.storage:safeAdd(x, y, nodes.names[name])
end

function nodes:isWalkable(x, y)
    return not not (nodes.storage:get(x, y) and nodes.storage:get(x, y).walkable)
end

function nodes:isDeadly(x, y)
    return not not (nodes.storage:get(x, y) and nodes.storage:get(x, y).deadly)
end

function nodes:render()
    nodes.storage:forEach(function(x, y, node)
        if (math.abs(x - player.x) * SIZE * draw.scale < love.graphics.getWidth()
                and math.abs(y - player.y) * SIZE * draw.scale < love.graphics.getHeight()) then
            node.render(x, y)
        end
    end)
end

function nodes:forEach(fun)
    nodes.storage:forEach(fun)
end

function nodes:clear()
    nodes.storage:clear()
end

function nodes:remove(x, y)
    nodes.storage:remove(x, y)
end