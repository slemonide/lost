------------------------
-- A node representation of the world
------------------------

-- size of a node
SIZE = 100;

-- textures
textures = {}
textures.load = function()
    textures.floor = love.graphics.newImage("assets/block-unit.png")
    textures.wall = love.graphics.newImage("assets/wall-unit.png")
end

-- all nodes in the world
nodes = {}
nodes.collisionMap = {}

nodes.addNode = function (x, y, texture, walkable)
    if (not nodes.collisionMap[x]) then
        nodes.collisionMap[x] = {}
    end
    nodes.collisionMap[x][y] = walkable

    table.insert(nodes, {
        x = x,
        y = y,
        texture = texture,
        walkable = walkable
    })
end

nodes.addWall = function (x, y)
    nodes.addNode(x, y, textures.wall, false)
end

nodes.addFloor = function (x, y)
    nodes.addNode(x, y, textures.floor, true)
end

nodes.isWalkable = function(x, y)
    return (nodes.collisionMap[x] or {})[y]
end