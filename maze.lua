require('utils')
require('nodes')
require('ghosts')
require('candles')
require('coins')

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
        open = open,
        from = {
            x = x0,
            y = y0
        },
        to = {
            x = x1,
            y = y1
        }
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

        local generateRoom = math.random() > 0.9

        if (not maze.hasConnection(x, y, x + 1, y)) then
           maze.addConnection(x, y, x + 1, y, generateRoom or math.random() > 0.5)
        end

        if (not maze.hasConnection(x, y, x - 1, y)) then
            maze.addConnection(x, y, x - 1, y, generateRoom or math.random() > 0.5)
        end

        if (not maze.hasConnection(x, y, x, y + 1)) then
            maze.addConnection(x, y, x, y + 1, generateRoom or math.random() > 0.5)
        end

        if (not maze.hasConnection(x, y, x, y - 1)) then
            maze.addConnection(x, y, x, y - 1, generateRoom or math.random() > 0.5)
        end
    end
end

-- Writes the maze to the node map
maze.writeToMap = function()
    for _, node in ipairs(maze) do
        nodes.addFloor(node.x * 2, node.y * 2)

        if (math.random() > 0.96) then
            candles.addCandle(node.x * 2, node.y * 2)
        elseif (math.random() > 0.7) then
            coins.addCoin(node.x * 2, node.y * 2)
        end

        nodes.addWall(node.x * 2 + 1, node.y * 2 + 1)
        nodes.addWall(node.x * 2 - 1, node.y * 2 - 1)
        nodes.addWall(node.x * 2 - 1, node.y * 2 + 1)
        nodes.addWall(node.x * 2 + 1, node.y * 2 - 1)
    end

    for _, connection in ipairs(maze.connections) do
        if (connection.open) then
            if (math.random() > 0.97) then
                if (math.random() > 0.5) then
                    ghosts.addPinkGhost(connection.x, connection.y)
                else
                    ghosts.addGreyGhost(connection.x, connection.y)
                end
            end
            nodes.addFloor(connection.x, connection.y)
        else
            if (math.random() > 0.7) then
                nodes.addSpikes(connection.x, connection.y)
                if not (nodes.nodeMap[connection.from.x * 2] or {})[connection.from.y * 2] then
                    nodes.addWall(connection.from.x * 2, connection.from.y * 2)
                end

                if not (nodes.nodeMap[connection.to.x * 2] or {})[connection.to.y * 2] then
                    nodes.addWall(connection.to.x * 2, connection.to.y * 2)
                end
            else
                nodes.addWall(connection.x, connection.y)
            end
        end
    end
end