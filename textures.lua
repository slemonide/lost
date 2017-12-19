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

function textures:load()
    textures:add("floor", "Objects/Floor", 15, 4)
    textures:add("wall", "Objects/Wall", 1, 19)
    textures:add("player", "Characters/Player0", 0, 0)
    textures:add("spikes", "Objects/Trap0", 0, 3)
    textures:add("ghostGrey", "Characters/Undead0", 2, 4)
    textures:add("ghostPink", "Characters/Undead0", 2, 5)
    textures:add("coin", "Items/Money", 0, 0)
    textures:add("candle", "Items/Light", 0, 0)
end