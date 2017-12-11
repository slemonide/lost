require('textures')
require('xy_map')

------------------------
-- A node representation of the world
------------------------

-- size of a node
SIZE = 100;

-- all nodes in the world
nodes = {}
nodes.nodeMap = newXYMap() -- contains all generated nodes
nodes.collisionMap = newXYMap() -- contains solid nodes
nodes.deathMap = newXYMap() -- contatins deadly nodes

function nodes:addNode(x, y, texture, walkable, deadly)
    assert(x)
    assert(y)

    nodes.nodeMap:add(x, y, {
        texture = texture
    })

    if (walkable) then
        nodes.collisionMap:add(x, y)
    end

    if (deadly) then
        nodes.deathMap:add(x, y)
    end
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
    return nodes.collisionMap:contains(x, y)
end

function nodes:isDeadly(x, y)
    return nodes.deathMap:contains(x, y)
end