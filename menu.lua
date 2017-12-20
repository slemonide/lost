require('nodes')
require('player')
require('utils')
require('triggers')

menu = {}

local clear_menu = function()
    player.x = 0
    player.y = 0
    triggers:clear()
    nodes:clear()
    text:clear()
end

local play_offline = function()
    clear_menu()
    generator:addMaze(0,0)
end

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
                nodes:addNode(x, y, "dirt_wall")
            else
                nodes:addNode(x, y, "dirt_floor")
                if (material == "x") then
                    player.x = x
                    player.y = y
                elseif (material == "0") then
                    text:write("Main Menu", x, y, 1, 1, 3)
                elseif (material == "1") then
                    text:write("Play Offline", x, y, 1, 1, 2)
                    triggers:onPlayerWalkAt(x + 3, y, play_offline)
                elseif (material == "2") then
                    text:write("Play Online", x, y, 1, 1, 2)
                    triggers:onPlayerWalkAt(x + 3, y, function()
                        nodes:addNode(x+5, y, "dirt_floor")
                        menu:online_menu(x+5,y-2)
                    end)
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

function menu:online_menu(x0, y0)
    local file = assert(io.open("assets/menu/online_menu", "r"))

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
                nodes:addNode(x0 + x, y0 + y, "dirt_wall")
            else
                nodes:addNode(x0 + x, y0 + y, "dirt_floor")
                if (material == "1") then
                    text:write("Start Server", x0 + x, y0 + y, 1, 1, 2)
                    triggers:onPlayerWalkAt(x0 + x + 1, y0 + y, function()
                        play_offline()
                        server:start()
                    end)
                elseif (material == "2") then
                    text:write("Connect to Server", x0 + x, y0 + y, 1, 1, 2)
                    triggers:onPlayerWalkAt(x0 + x + 1, y0 + y, function()
                        clear_menu()
                        client:connect()
                    end)
                end
            end
        end
    end
end