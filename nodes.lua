require('textures')
require('xy_map')

------------------------
-- A node representation of the world
------------------------

-- all nodes in the world
nodes = newXYMap()
--nodes.nodeMap = newXYMap() -- contains all generated nodes
--nodes.collisionMap = newXYMap() -- contains solid nodes
--nodes.deathMap = newXYMap() -- contatins deadly nodes

function nodes:addNode(x, y, texture, walkable, deadly)
    assert(x)
    assert(y)

    nodes:add(x, y, {
        texture = texture,
        walkable = walkable,
        deadly = deadly
    })
end

function nodes:addWall(x, y)
    nodes:addNode(x, y, textures.wall, false, true)
end

function nodes:addFloor(x, y)
    assert(x)
    assert(y)

    nodes:addNode(x, y, textures.floor, true, false)
end

function nodes:addSpikes(x, y)
    nodes:addNode(x, y, textures.spikes, true, true)
end

function nodes:isWalkable(x, y)
    return nodes:get(x, y) and nodes:get(x, y).walkable
end

function nodes:isDeadly(x, y)
    return nodes:get(x, y) and nodes:get(x, y).deadly
end