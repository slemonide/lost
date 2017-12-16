-- textures
textures = {}

function textures:add(key, file_name)
    textures[key] = love.graphics.newImage("assets/textures/" .. file_name)
end

function textures:load()
    textures:add("floor", "block-unit.png")
    textures:add("wall", "wall-unit.png")
    textures:add("player", "blindguyv2.png")
    textures:add("spikes", "spike-unit.png")
    textures:add("ghostGrey", "ghostgrey-unit.png")
    textures:add("ghostPink", "ghostpink-unit.png")
    textures:add("coin", "coin.png")
    textures:add("candle", "candle2-unit.png")
end