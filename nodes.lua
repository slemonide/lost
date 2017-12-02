------------------------
-- A node representation of the world
------------------------

-- size of a node
SIZE = 10;

-- all nodes in the world
nodes = {}
nodes.collisionMap = {}

nodes.addNode = function (x, y, color, walkable)
    if (not nodes.collisionMap[x]) then
        nodes.collisionMap[x] = {}
    end
    nodes.collisionMap[x][y] = walkable

    table.insert(nodes, {
        x = x,
        y = y,
        color = color,
        walkable = walkable
    })
end

nodes.addWall = function (x, y)
    nodes.addNode(x, y, {255, 0, 0}, false)
end

nodes.addFloor = function (x, y)
    nodes.addNode(x, y, {200, 180, 220}, true)
end

nodes.isWalkable = function(x, y)
    return (nodes.collisionMap[x] or {})[y]
end