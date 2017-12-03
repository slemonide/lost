-- textures
textures = {}
textures.load = function()
    textures.floor = love.graphics.newImage("assets/block-unit.png")
    textures.wall = love.graphics.newImage("assets/wall-unit.png")
    textures.player = love.graphics.newImage("assets/blindguyv2.png")
    textures.spikes = love.graphics.newImage("assets/spike-unit.png")
end