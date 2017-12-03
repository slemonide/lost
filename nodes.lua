require('textures')

------------------------
-- A node representation of the world
------------------------

-- size of a node
SIZE = 100;

-- all nodes in the world
nodes = {}
nodes.nodeMap = {} -- contains all generated nodes
nodes.collisionMap = {} -- contains solid nodes
nodes.deathMap = {} -- contatins deadly nodes

nodes.addNode = function (x, y, texture, walkable, deadly)
    if (not nodes.nodeMap[x]) then
        nodes.nodeMap[x] = {}
    end
    nodes.nodeMap[x][y] = true

    if (not nodes.collisionMap[x]) then
        nodes.collisionMap[x] = {}
    end
    nodes.collisionMap[x][y] = walkable

    if (not nodes.deathMap[x]) then
        nodes.deathMap[x] = {}
    end
    nodes.deathMap[x][y] = deadly

    table.insert(nodes, {
        x = x,
        y = y,
        texture = texture,
        walkable = walkable
    })
end

nodes.addWall = function (x, y)
    nodes.addNode(x, y, textures.wall, false, true)
end

nodes.addFloor = function (x, y)
    nodes.addNode(x, y, textures.floor, true, false)
end

nodes.addSpikes = function (x, y)
    nodes.addNode(x, y, textures.spikes, true, true)
end

nodes.isWalkable = function (x, y)
    return (nodes.collisionMap[x] or {})[y]
end

nodes.isDeadly = function (x, y)
    return (nodes.deathMap[x] or {})[y]
end