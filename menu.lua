require('nodes')
require('player')
require('utils')
require('triggers')

menu = {}

function menu:main_menu()
    local file = assert(io.open("assets/menu/main_menu", "r"))

    local structure = {}
    for line in file:lines() do
        table.insert(structure, line)
    end

    -- Parse structure
    for y = 1, #structure do
        local line = structure[y]
        for x = 1, line:len() do
            local material = line:sub(x, x)
            if (material == " ") then
                -- do nothing
            elseif (material == "#") then
                nodes:addWall(x, y)
            else
                nodes:addFloor(x, y)
                if (material == "x") then
                    player.x = x
                    player.y = y
                elseif (material == "0") then
                    text:write("Main Menu", x, y, 1, 1, 3)
                elseif (material == "1") then
                    text:write("Play Offline", x, y, 1, 1, 2)
                    triggers:onPlayerWalkAt(x + 3, y, function()
                        nodes:remove(10,4)
                        nodes:addFloor(8,4)
                        generator:addCave(9,4)
                    end)
                elseif (material == "2") then
                    text:write("Play Online", x, y, 1, 1, 2)
                elseif (material == "3") then
                    text:write("Settings ->", x, y, 1, 1, 2)
                elseif (material == "4") then
                    text:write("Exit ->", x, y, 1, 1, 2)
                    triggers:onPlayerWalkAt(x + 3, y, love.event.quit)
                end
            end
        end
    end
end