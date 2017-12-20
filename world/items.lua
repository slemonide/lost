items = {}

local function put_on_screen(texture, x, y)
    love.graphics.draw(texture.image, texture.quad, x * SIZE * draw.scale, y * SIZE * draw.scale, 0, draw.scale, draw.scale)
end

-- Generates a boolean binary tree of depth n
local function binaryTree(n)
    assert(n >= 0)

    if (n ~= 0) then
        local out = {}
        out[true] = binaryTree(n - 1)
        out[false] = binaryTree(n - 1)

        return out
    else
        return function() end
    end
end

local function try(x, y)
    return not not (world:isWalkable(x,y) or not world:contains(x,y))
end

local function floorTextureRender(texture)
    local textureMap = binaryTree(4)
    --[[
    --  2
    -- 1 3
    --  4
    ]]
    -- true means walkable
    textureMap[false][false][false][false] = function(x,y, texture) put_on_screen(texture[6][1], x, y) end
    textureMap[false][false][false][true] = function(x,y, texture) put_on_screen(texture[4][1], x, y) end
    textureMap[false][false][true][false] = function(x,y, texture) put_on_screen(texture[5][2], x, y) end
    textureMap[false][false][true][true] = function(x,y, texture) put_on_screen(texture[1][1], x, y) end
    textureMap[false][true][false][false] = function(x,y, texture) put_on_screen(texture[4][2], x, y) end
    textureMap[false][true][false][true] = function(x,y, texture) put_on_screen(texture[4][2], x, y) end
    textureMap[false][true][true][false] = function(x,y, texture) put_on_screen(texture[1][3], x, y) end
    textureMap[false][true][true][true] = function(x,y, texture) put_on_screen(texture[1][2], x, y) end
    textureMap[true][false][false][false] = function(x,y, texture) put_on_screen(texture[7][2], x, y) end
    textureMap[true][false][false][true] = function(x,y, texture) put_on_screen(texture[3][1], x, y) end
    textureMap[true][false][true][false] = function(x,y, texture) put_on_screen(texture[6][2], x, y) end
    textureMap[true][false][true][true] = function(x,y, texture) put_on_screen(texture[2][1], x, y) end
    textureMap[true][true][false][false] = function(x,y, texture) put_on_screen(texture[3][3], x, y) end
    textureMap[true][true][false][true] = function(x,y, texture) put_on_screen(texture[3][2], x, y) end
    textureMap[true][true][true][false] = function(x,y, texture) put_on_screen(texture[2][3], x, y) end
    textureMap[true][true][true][true] = function(x,y, texture) put_on_screen(texture[2][2], x, y) end

    return function(x,y)
        textureMap[try(x-1,y)][try(x,y-1)][try(x+1,y)][try(x,y+1)](x, y, texture)
    end
end

local function wallTextureRender(texture)
    local textureMap = binaryTree(4)
    --[[
    --  2
    -- 1 3
    --  4
    ]]
    -- true means walkable
    textureMap[false][false][false][false] = function(x,y) put_on_screen(texture[5][2], x, y) end
    textureMap[false][false][false][true] = function(x,y) put_on_screen(texture[5][3], x, y) end
    textureMap[false][false][true][false] = function(x,y) put_on_screen(texture[6][2], x, y) end
    textureMap[false][false][true][true] = function(x,y) put_on_screen(texture[3][3], x, y) end
    textureMap[false][true][false][false] = function(x,y) put_on_screen(texture[5][1], x, y) end
    textureMap[false][true][false][true] = function(x,y) put_on_screen(texture[2][1], x, y) end
    textureMap[false][true][true][false] = function(x,y) put_on_screen(texture[3][1], x, y) end
    textureMap[false][true][true][true] = function(x,y) put_on_screen(texture[3][3], x, y) end
    textureMap[true][false][false][false] = function(x,y) put_on_screen(texture[4][2], x, y) end
    textureMap[true][false][false][true] = function(x,y) put_on_screen(texture[1][3], x, y) end
    textureMap[true][false][true][false] = function(x,y) put_on_screen(texture[1][2], x, y) end
    textureMap[true][false][true][true] = function(x,y) put_on_screen(texture[2][2], x, y) end
    textureMap[true][true][false][false] = function(x,y) put_on_screen(texture[1][1], x, y) end
    textureMap[true][true][false][true] = function(x,y) put_on_screen(texture[1][3], x, y) end
    textureMap[true][true][true][false] = function(x,y) put_on_screen(texture[1][2], x, y) end
    textureMap[true][true][true][true] = function(x,y) put_on_screen(texture[2][2], x, y) end

    return function(x,y)
        textureMap[try(x-1,y)][try(x,y-1)][try(x+1,y)][try(x,y+1)](x, y, texture)
    end
end

function items:load()
    world:registerItem({
        name = "dirt_floor",
        type = "floor",
        walkable = true,
        deadly = false,
        render = floorTextureRender(textures["dirt_floor"])
    })

    world:registerItem({
        name = "dirt_wall",
        type = "wall",
        walkable = false,
        deadly = true,
        render = wallTextureRender(textures["dirt_wall"])
    })

    world:registerItem({
        name = "stone_floor",
        type = "floor",
        walkable = true,
        deadly = false,
        render = floorTextureRender(textures["stone_floor"])
    })

    world:registerItem({
        name = "stone_wall",
        type = "wall",
        walkable = false,
        deadly = true,
        render = wallTextureRender(textures["stone_wall"])
    })

    world:registerItem({
        name = "spikes",
        type = "floor",
        walkable = true,
        deadly = true,
        render = function(x, y)
            put_on_screen(textures.spikes, x, y)
        end
    })
end