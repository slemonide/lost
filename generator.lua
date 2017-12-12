require('xy_map')
require('nodes')
require('utils')
require('player')
require('candles')
require('coins')
require('ghosts')

-------------------------------------------------------------------------------
-- World generator
-------------------------------------------------------------------------------

generator = newXYMap()

MAX_ROOM_SIZE = 20

-- Return a list of nodes that are safely accesible from (x, y)
-- I.e. is walkable and not deadly
local function getConnections(x, y)
    local out = {}

    local function checkNeighbour(dx, dy)
        local x = x + dx
        local y = y + dy
        if (nodes:isWalkable(x, y) and not nodes:isDeadly(x, y)) then
            table.insert(out, {
                x = x,
                y = y
            })
        end
    end

    checkNeighbour(1, 0)
    checkNeighbour(-1, 0)
    checkNeighbour(0, 1)
    checkNeighbour(0, -1)

    return out
end

-- Checks if given position can be walked around, if it is blocking path
local function canWalkAround(x, y)
    local connections = getConnections(x, y)

    if (#connections == 1) then
        return true
    end
    -- TODO: add more complicated path searching algorithm. Might want to try to run it in parallel.
end

local function spawnStuff(toDoLater, x, y)
    if (math.random() > 0.3) then
        table.insert(toDoLater, function() generator:addSpikeSpawner(x, y) end)
    elseif (math.random() > 0.96) then
        candles:add(x, y)
    elseif (math.random() > 0.7) then
        coins:add(x, y)
    end

    if (math.random() > 0.95) then
        if (math.random() > 0.8) then
            ghosts:addGreyGhost(x, y)
        else
            ghosts:addPinkGhost(x, y)
        end
    end
end

function generator:generate()
    local toDoLater = {}

    generator:forEach(function(x,y,node)
        if (math.abs(x - player.x) < 50 and math.abs(y - player.y) < 50) then

            if (node.type == "maze") then
                table.insert(toDoLater, function() generator:remove(x, y) end)

                nodes:addFloor(x,y)
                nodes:addWall(x+1,y+1)
                nodes:addWall(x+1,y-1)
                nodes:addWall(x-1,y+1)
                nodes:addWall(x-1,y-1)

                spawnStuff(toDoLater, x, y)

                local function generateNextNode(generate, dx, dy)
                    if (generate and not nodes:contains(x + dx, y + dy)) then
                        nodes:addFloor(x + dx / 2, y + dy / 2)
                        if (generator.size < 30 or math.random() > 0.01) then
                            table.insert(toDoLater, function() generator:addMaze(x + dx, y + dy) end)
                        else
                            table.insert(toDoLater, function() generator:addRoom(x + dx, y + dy) end)
                        end
                    else
                        nodes:addWall(x + dx / 2, y + dy / 2)
                    end
                end

                local prevProbability = 0.6
                local function generateNextNodeProbabilityDone(dx, dy)
                    if (math.random() > 0.8) then
                        prevProbability = math.random() * 0.9 + 0.1
                    end
                    generateNextNode(
                        math.random() < prevProbability,
                        2 * dx,
                        2 * dy
                    )
                end

                generateNextNodeProbabilityDone(1, 0)
                generateNextNodeProbabilityDone(-1,0)
                generateNextNodeProbabilityDone(0, 1)
                generateNextNodeProbabilityDone(0,-1)
            elseif (node.type == "cave") then
                -- TODO: finish
            elseif (node.type == "room") then
                table.insert(toDoLater, function() generator:remove(x, y) end)
                local height = math.random(MAX_ROOM_SIZE)
                local width = math.random(MAX_ROOM_SIZE)
                for dx = -width, width do
                    for dy = -height, height do
                        if math.abs(dx) == width or math.abs(dy) == height then
                            nodes:addWall(x + dx, y + dy)
                        else
                            nodes:addFloor(x + dx, y + dy)
                            --spawnStuff(toDoLater, x + dx, y + dy)
                        end
                    end
                end
            elseif (node.type == "wall spawner") then
                -- TODO: finish
            elseif (node.type == "spike spawner") then
                if (node.age == 0) then
                    table.insert(toDoLater, function() generator:remove(x, y) end)

                    if (canWalkAround(x, y)) then
                        nodes:remove(x, y)
                        nodes:addSpikes(x, y)
                    end
                else
                    node.age = node.age - 1
                end
            end
        end
    end)

        for _, func in ipairs(toDoLater) do
            func()
        end
end

-- Begin generating a maze at (x, y)
function generator:addMaze(x, y)
    generator:add(x, y, {
        type = "maze"
    })
end

-- Begin generating a cave at (x, y)
function generator:addCave(x, y)
    generator:add(x, y, {
        type = "cave"
    })
end

-- Begin generating a room at (x, y)
function generator:addRoom(x, y)
    generator:add(x, y, {
        type = "room"
    })
end

-- Spawn a wall at (x, y) if it will look nice
function generator:addWallSpawner(x, y)
    generator:add(x, y, {
        type = "wall spawner"
    })
end

-- Spawns spikes at (x, y) when the time is right
function generator:addSpikeSpawner(x, y)
    generator:add(x, y, {
        type = "spike spawner",
        age = 10
    })
end