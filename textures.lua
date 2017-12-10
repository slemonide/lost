-- textures
textures = {}

function textures:add(key, file_name)
    textures[key] = love.graphics.newImage("assets/" .. file_name)
end

function textures:load()
    textures:add("floor", "block-unit.png")
    textures:add("wall", "wall-unit.png")
    --textures.player = love.graphics.newImage("assets/blindwithandWheelchair.png")
    textures:add("player", "key.png")
    textures:add("spikes", "spike-unit.png")
    textures:add("ghostGrey", "ghostgrey-unit.png")
    textures:add("ghostPink", "ghostpink-unit.png")
    textures:add("coin", "coin.png")
    textures:add("candle", "candle-unit.png")
end