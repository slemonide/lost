------------------------
-- A graph representation of the world
------------------------

maze = {}
maze.connections = {}
maze.newNodes = {}

maze.makeNode = function (x, y)
    return {
        x = x,
        y = y
    }
end

maze.addNode = function (x, y)
    table.insert(maze, maze.makeNode(x, y))
end

maze.addConnection = function(from, to, open)
    table.insert(maze.connections, {
        x = from.x + to.x,
        y = from.y + to.y,
        open = open
    })
end

-- Add a new node that is not done generating
maze.addNewNode = function(x, y)
    table.insert(maze.newNodes, maze.makeNode(x, y))
end

-- Continue generating the maze
maze.generate = function()
    for _, node in ipairs(maze.newNodes) do
        -- TODO: finish
    end
end