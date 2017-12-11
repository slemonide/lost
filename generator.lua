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

function generator:generate()
    local toDoLater = {}

    generator:forEach(function(x,y,node)
        if (math.abs(x - player.x) < 10 and math.abs(y - player.y) < 10) then

            if (node.type == "maze") then
                if (math.random() > 0.97) then
                    nodes:addSpikes(x, y)
                else
                    nodes:addFloor(x,y)
                end
                nodes:addWall(x+1,y+1)
                nodes:addWall(x+1,y-1)
                nodes:addWall(x-1,y+1)
                nodes:addWall(x-1,y-1)
                -- add more stuff
                if (math.random() > 0.96) then
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
                -- done

                table.insert(toDoLater, function() generator:remove(x, y) end)

                local function generateNextNode(generate, dx, dy)
                    if (generate and not nodes:contains(x + dx, y + dy)) then
                        nodes:addFloor(x + dx / 2, y + dy / 2)
                        table.insert(toDoLater, function() generator:addMaze(x + dx, y + dy) end)
                    else
                        nodes:addWall(x + dx / 2, y + dy / 2)
                    end
                end

                local function generateNextNodeProbabilityDone(dx, dy)
                    generateNextNode(
                        math.random() < math.min(10 / generator.size, 0.9),
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
            elseif (node.type == "wall spawner") then
                -- TODO: finish
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

-- Spawn a wall at (x, y) if it will look nice
function generator:addWallSpawner(x, y)
    generator:add(x, y, {
        type = "wall spawner"
    })
end