require('utils')
require('nodes')

------------------------
-- A graph representation of the world
------------------------

maze = {}
maze.connections = {
    open = {},
    closed = {}
}
maze.newNodes = {}

maze.makeNode = function (x, y)
    return {
        x = x,
        y = y
    }
end

maze.addNode = function (x, y)
    table.insert(maze, maze.makeNode(x, y))
    maze.addConnection(x, y, x + 1, y, math.random() > 0.5)
    maze.addConnection(x, y, x - 1, y, math.random() > 0.5)
    maze.addConnection(x, y, x, y + 1, math.random() > 0.5)
    maze.addConnection(x, y, x + 1, y, math.random() > 0.5)
end

maze.addConnection = function(x0, y0, x1, y1, open)
    local connectionsTable = maze.connections[(open and "open" or "closed")]

    if (not connectionsTable[x0 + x1]) then
        connectionsTable[x0 + x1] = {}
    end
    connectionsTable[x0 + x1][y0 + y1] = true

    table.insert(maze.connections, {
        x = x0 + x1,
        y = y0 + y1,
        open = open
    })

    if (open) then
        maze.addNewNode(x0,y0)
        maze.addNewNode(x1,y1)
    end
end

maze.hasConnection = function(x0, y0, x1, y1)
    return (maze.connections.open[x0 + x1] or {})[y0 + y1]
            or (maze.connections.closed[x0 + x1] or {})[y0 + y1]
end

-- Add a new node that is not done generating
maze.addNewNode = function(x, y)
    if (not (maze[x] or {})[y]) then
        table.insert(maze.newNodes, maze.makeNode(x, y))
        table.insert(maze, maze.makeNode(x, y))

        if (not maze[x]) then
            maze[x] = {}
        end
        maze[x][y] = true
    end
end

-- Continue generating the maze
maze.generate = function()
    local nextNodes = shallowcopy(maze.newNodes)

    for _, node in ipairs(nextNodes) do
        local x = node.x
        local y = node.y

        if (not maze.hasConnection(x, y, x + 1, y)) then
           maze.addConnection(x, y, x + 1, y, math.random() > 0.5)
        end

        if (not maze.hasConnection(x, y, x - 1, y)) then
            maze.addConnection(x, y, x - 1, y, math.random() > 0.5)
        end

        if (not maze.hasConnection(x, y, x, y + 1)) then
            maze.addConnection(x, y, x, y + 1, math.random() > 0.5)
        end

        if (not maze.hasConnection(x, y, x, y - 1)) then
            maze.addConnection(x, y, x, y - 1, math.random() > 0.5)
        end
    end
end

-- Writes the maze to the node map
maze.writeToMap = function()
    for _, node in ipairs(maze) do
        nodes.addFloor(node.x * 2, node.y * 2)

        nodes.addWall(node.x * 2 + 1, node.y * 2 + 1)
        nodes.addWall(node.x * 2 - 1, node.y * 2 - 1)
        nodes.addWall(node.x * 2 - 1, node.y * 2 + 1)
        nodes.addWall(node.x * 2 + 1, node.y * 2 - 1)
    end

    for _, connection in ipairs(maze.connections) do
        if (connection.open) then
            nodes.addFloor(connection.x, connection.y)
        else
            nodes.addWall(connection.x, connection.y)
        end
    end
end