require('textures')
require('xy_map')

------------------------
-- A node representation of the world
------------------------

-- all nodes in the world
nodes = newXYMap()

function nodes:addNode(x, y, walkable, deadly, render)
    assert(x)
    assert(y)

    nodes:add(x, y, {
        texture = texture,
        walkable = walkable,
        deadly = deadly,
        render = render
    })
end

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
    return not not (nodes:isWalkable(x,y) or not nodes:contains(x,y))
end

function nodes:addWall(x, y)
    nodes:addNode(x, y, false, true, function(x, y)
        local textureMap = binaryTree(4)
        --[[
        --  2
        -- 1 3
        --  4
         ]]
        -- true means walkable
        textureMap[false][false][false][false] = function(x,y) put_on_screen(textures.wall[5][2], x, y) end
        textureMap[false][false][false][true] = function(x,y) put_on_screen(textures.wall[5][3], x, y) end
        textureMap[false][false][true][false] = function(x,y) put_on_screen(textures.wall[6][2], x, y) end
        textureMap[false][false][true][true] = function(x,y) put_on_screen(textures.wall[3][3], x, y) end
        textureMap[false][true][false][false] = function(x,y) put_on_screen(textures.wall[5][1], x, y) end
        textureMap[false][true][false][true] = function(x,y) put_on_screen(textures.wall[2][1], x, y) end
        textureMap[false][true][true][false] = function(x,y) put_on_screen(textures.wall[3][1], x, y) end
        textureMap[false][true][true][true] = function(x,y) put_on_screen(textures.wall[3][3], x, y) end
        textureMap[true][false][false][false] = function(x,y) put_on_screen(textures.wall[4][2], x, y) end
        textureMap[true][false][false][true] = function(x,y) put_on_screen(textures.wall[1][3], x, y) end
        textureMap[true][false][true][false] = function(x,y) put_on_screen(textures.wall[1][2], x, y) end
        textureMap[true][false][true][true] = function(x,y) put_on_screen(textures.wall[2][2], x, y) end
        textureMap[true][true][false][false] = function(x,y) put_on_screen(textures.wall[1][1], x, y) end
        textureMap[true][true][false][true] = function(x,y) put_on_screen(textures.wall[1][3], x, y) end
        textureMap[true][true][true][false] = function(x,y) put_on_screen(textures.wall[1][2], x, y) end
        textureMap[true][true][true][true] = function(x,y) put_on_screen(textures.wall[2][2], x, y) end

        textureMap[try(x-1,y)][try(x,y-1)][try(x+1,y)][try(x,y+1)](x, y)
    end)
end

function nodes:addFloor(x, y)
    nodes:addNode(x, y, true, false, function(x, y)
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

        textureMap[try(x-1,y)][try(x,y-1)][try(x+1,y)][try(x,y+1)](x, y, textures.floor)
    end)
end

function nodes:addSpikes(x, y)
    nodes:addNode(x, y, true, true,
        function(x, y)
            put_on_screen(textures.spikes, x, y)
        end)
end

function nodes:isWalkable(x, y)
    return not not (nodes:get(x, y) and nodes:get(x, y).walkable)
end

function nodes:isDeadly(x, y)
    return not not (nodes:get(x, y) and nodes:get(x, y).deadly)
end

function nodes:render()
    nodes:forEach(function(x, y, node)
        if (math.abs(x - player.x) * SIZE * draw.scale < love.graphics.getWidth()
                and math.abs(y - player.y) * SIZE * draw.scale < love.graphics.getHeight()) then
            --love.graphics.draw(node.texture.image, node.texture.quad, x * SIZE * draw.scale, y * SIZE * draw.scale, 0, draw.scale, draw.scale)
            --node.render(x * SIZE * draw.scale, y * SIZE * draw.scale, 0, draw.scale, draw.scale)
            node.render(x, y)
        end
    end)
end