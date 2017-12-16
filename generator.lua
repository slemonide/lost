require('xy_map')
require('nodes')
require('player')
require('generator_helpers')

-------------------------------------------------------------------------------
-- World generator
-------------------------------------------------------------------------------

generator = newXYMap()
generator.toDoLater = {}

GENERATOR_DISTANCE = 50
STONE_FILL_DISTANCE = 20

generator._add = generator.add
generator._remove = generator.remove

function generator:add(x, y, data)
    table.insert(generator.toDoLater, function() generator:_add(x, y, data) end)
end

function generator:remove(x, y)
    table.insert(generator.toDoLater, function() generator:_remove(x, y) end)
end

function generator:generate()
    generator:forEach(function(x,y,node)
        if (node.ignore_player or math.abs(x - player.x) < GENERATOR_DISTANCE and math.abs(y - player.y) < GENERATOR_DISTANCE) then
            node.action(x,y,node)
        end
    end)

    for _, func in ipairs(generator.toDoLater) do
        func()
    end
    generator.toDoLater = {}
end

function generator:placeWall(x, y)
    nodes:addWall(x, y)
end

function generator:placeFloor(x, y)
    if (math.random() > 0.01) then
        nodes:addFloor(x, y)

        if (math.random() > 0.999) then
            candles:add(x, y)
        elseif (math.random() > 0.98) then
            coins:add(x, y)
        end
        if (math.random() > 0.992) then
            if (math.random() > 0.8) then
                ghosts:addGreyGhost(x, y)
            else
                ghosts:addPinkGhost(x, y)
            end
        end
    else
        nodes:addSpikes(x, y)
    end
end

-- Begin generating a maze at (x, y)
function generator:addMaze(x, y)
    generator:add(x, y, {
        action = function()
            generator:remove(x, y)

            for dx = -1,1 do
                for dy = -1,1 do
                    generator:placeFloor(x + dx,y + dy)
                end
            end
            generator:placeWall(x+2,y+2)
            generator:placeWall(x+2,y-2)
            generator:placeWall(x-2,y+2)
            generator:placeWall(x-2,y-2)

            local function generateNextNode(generate, dx, dy)
                local function generateBorders(wall)
                    local func = function(x,y)
                        if (wall) then
                            generator:placeWall(x,y)
                        else
                            generator:placeFloor(x,y)
                        end
                    end

                    if (math.random() > 0.4) then
                        if (dx == 0) then
                            func(x, y + dy / 2)
                            func(x - 1, y + dy / 2)
                            func(x + 1, y + dy / 2)
                        else
                            func(x + dx / 2, y)
                            func(x + dx / 2, y - 1)
                            func(x + dx / 2, y + 1)
                        end
                    else
                        if (dx == 0) then
                            func(x, y + dy / 2)
                            generator:placeWall(x - 1, y + dy / 2)
                            generator:placeWall(x + 1, y + dy / 2)
                        else
                            func(x + dx / 2, y)
                            generator:placeWall(x + dx / 2, y - 1)
                            generator:placeWall(x + dx / 2, y + 1)
                        end
                    end
                end

                if (generate and not nodes:contains(x + dx, y + dy)) then
                    generateBorders(false)
                    generator:addMaze(x + dx, y + dy)
                else
                    generateBorders(true)
                end

                return generate
            end

            local generated_nodes = 1
            local function generateNextNodeProbabilityDone(dx, dy)
                local generate
                if (generator.size < 20) then
                    generate = math.random() < 1 / generated_nodes
                elseif (generator.size < 10) then
                    generate = true
                else
                    generate = math.random() < 0.6 / generated_nodes
                end
                if (generate) then
                    if (generator.size < 20) then
                        generated_nodes = generated_nodes + 1
                    else
                        generated_nodes = generated_nodes * 3
                    end
                end

                return generateNextNode(
                    generate,
                    4 * dx,
                    4 * dy
                )
            end

            local generationQueue = {
                function() generateNextNodeProbabilityDone(1, 0) end,
                function() generateNextNodeProbabilityDone(-1,0) end,
                function() generateNextNodeProbabilityDone(0, 1) end,
                function() generateNextNodeProbabilityDone(0,-1) end
            }

            while (#generationQueue ~= 0) do
                local index = math.random(#generationQueue)
                generationQueue[index]()
                table.remove(generationQueue, index)
            end
        end
    })
end

function generator:addCave(x, y, points)
    generator:add(x, y, {
        ignore_player = false,
        points = points or math.pow(2, 50),
        action = function(x, y, node)
            if (nodes:get(x,y)) then
                generator:remove(x, y)
            end

            local points = node.points

            if (points == 1) then

                --nodes:addWall(x,y)
                generator:remove(x, y)
                if (x % 4 == 0 and y % 4 == 0) then
                    generator:addMaze(x,y)
                elseif (math.random() < 1 * math.exp(-generator.size/20)) then
                    generator:addCave(x, y, math.pow(2, math.random(60) + 10))
                end
            else
                nodes:addFloor(x, y)
                node.points = points / 2

                local generatorOptions = {
                    function() generator:addCave(x+1, y, points / 2) end,
                    function() generator:addCave(x-1, y, points / 2) end,
                    function() generator:addCave(x, y+1, points / 2) end,
                    function() generator:addCave(x, y-1, points / 2) end
                }

                generatorOptions[math.random(#generatorOptions)]()
            end
        end
    })
end