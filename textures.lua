-- textures
textures = {}

-- size of a node
SIZE = 16;

function textures:add(key, file_name, x, y)
    local img = love.graphics.newImage("assets/textures/" .. file_name .. ".png")

    textures[key] = {
        image = img,
        quad = love.graphics.newQuad(x * SIZE, y * SIZE, SIZE, SIZE, img:getDimensions())
    }
end

function textures:addBox(key, file_name, x, y, w, h)
    local img = love.graphics.newImage("assets/textures/" .. file_name .. ".png")

    textures[key] = {}

    for dx = 0, w - 1 do
        if not textures[key][dx + 1] then
            textures[key][dx + 1] = {}
        end

        for dy = 0, h - 1 do
            textures[key][dx + 1][dy + 1] = {
                image = img,
                quad = love.graphics.newQuad((x + dx) * SIZE, (y + dy) * SIZE, SIZE, SIZE, img:getDimensions())
            }
        end
    end
end

function textures:load()
    --textures:add("floor", "Objects/Floor", 15, 4)
    textures:addBox("floor", "Objects/Floor", 0, 18, 7, 3)
    textures:addBox("wall", "Objects/Wall", 0, 18, 6, 3)
    textures:add("player", "Characters/Player0", 0, 0)
    textures:add("spikes", "Objects/Trap0", 3, 2)
    textures:add("ghostGrey", "Characters/Undead0", 2, 4)
    textures:add("ghostPink", "Characters/Undead0", 2, 5)
    textures:add("coin", "Items/Money", 0, 0)
    textures:add("candle", "Items/Light", 0, 0)
end