-- textures
textures = {}
textures.load = function()
    textures.floor = love.graphics.newImage("assets/block-unit.png")
    textures.wall = love.graphics.newImage("assets/wall-unit.png")
    textures.player = love.graphics.newImage("assets/blindwithandWheelchair.png")
    textures.spikes = love.graphics.newImage("assets/spike-unit.png")
    textures.ghostGrey = love.graphics.newImage("assets/ghostgrey-unit.png")
    textures.ghostPink = love.graphics.newImage("assets/ghostpink-unit.png")
    textures.candle = love.graphics.newImage("assets/candle2-unit.png")
    textures.coin = love.graphics.newImage("assets/coin.png")
end