require('conf')
require('textures')
require('nodes')
require('player')
require('ghosts')
require('candles')
require('coins')
require('generator')
require("lib.console.console")
require('text')
require('menu')
require('triggers')
require('config')

------------------------
-- Load love
------------------------
DEFAULT_SCALE = 3

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter("nearest")
    config:load()
    textures.load()

    menu:main_menu()
    --generator:addCave(0, 0)
    --text:write("hello", 0, 0)
end

------------------------
-- Update
------------------------

function love.update(dt)
    ghosts:update(dt)
    player:update(dt)
    draw:updateFade(dt)
    generator:generate();
    triggers:update(dt)
end

------------------------
-- Draw
------------------------

draw = {}
draw.deathMessage = {}
draw.deathMessage.x = 0.5 + math.random()
draw.deathMessage.y = 0.5 + math.random()
draw.restartMessage = {}
draw.restartMessage.x = 0.5 + math.random()
draw.restartMessage.y = 0.5 + math.random()

draw.scale = DEFAULT_SCALE
draw.fade = 1
draw.fadeSpeed = 0
--(1 - math.sin(math.pi * (player.blind or 0) / BLINDNESS_DELAY))

function draw:fadeBegin(speed)
    -- debug: turn of the fade to stop eyes bleeding
    --draw.fadeSpeed = -speed
end

function draw:fadeEnd(speed)
    draw.fadeSpeed = speed
end

function draw:updateFade(dt)
    draw.fade = draw.fade + draw.fadeSpeed * dt
    if (draw.fade > 1) then
        draw.fade = 1
    end

    if (draw.fade < 0) then
        draw.fade = 0
    end
end

-- Put origin to the center of the window
local function updateOrigin()
    love.graphics.origin()
    love.graphics.translate(
        love.graphics.getWidth() / 2 - (player.x + 0.5) * SIZE * draw.scale,
        love.graphics.getHeight() / 2 - (player.y + 0.5) * SIZE * draw.scale
    )
end

function love.draw()
    if (not player.dead) then
        updateOrigin();

        -- need this to render textures properly
        love.graphics.setBackgroundColor(100, 100, 100)
        love.graphics.setColor(255, 255, 255, 255 * draw.fade)

        -- TODO: move nodes, candles, ghosts, etc. into one group so it's easier to iterate
        -- Draw nodes
        nodes:forEach(function(x, y, node)
            if (math.abs(x - player.x) * SIZE * draw.scale < love.graphics.getWidth()
                    and math.abs(y - player.y) * SIZE * draw.scale < love.graphics.getHeight()) then
                love.graphics.draw(node.texture.image, node.texture.quad, x * SIZE * draw.scale, y * SIZE * draw.scale, 0, draw.scale, draw.scale)
            end
        end)

        -- Draw text
        text:render()


        -- Draw candles
        candles:forEach(function(x, y)
            if (math.abs(x - player.x) * SIZE * draw.scale < love.graphics.getWidth()
                    and math.abs(y - player.y) * SIZE * draw.scale < love.graphics.getHeight()) then
                love.graphics.draw(textures.candle.image, textures.candle.quad, x * SIZE * draw.scale, y * SIZE * draw.scale, 0, draw.scale, draw.scale)
            end
        end)

        -- Draw coins
        coins:forEach(function(x, y)
            if (math.abs(x - player.x) * SIZE * draw.scale < love.graphics.getWidth()
                    and math.abs(y - player.y) * SIZE * draw.scale < love.graphics.getHeight()) then
                love.graphics.draw(textures.coin.image, textures.coin.quad, x * SIZE * draw.scale, y * SIZE * draw.scale, 0, draw.scale, draw.scale)
            end
        end)

        -- Draw ghosts
        for _, ghost in ipairs(ghosts) do
            if (math.abs(ghost.x - player.x) * SIZE * draw.scale < love.graphics.getWidth()
                    and math.abs(ghost.y - player.y) * SIZE * draw.scale < love.graphics.getHeight()) then
                love.graphics.draw(ghost.texture.image, ghost.texture.quad, ghost.x * SIZE * draw.scale, ghost.y * SIZE * draw.scale, 0, draw.scale, draw.scale)
            end
        end

        -- Draw player
        love.graphics.draw(textures.player.image, textures.player.quad, player.x * SIZE * draw.scale, player.y * SIZE * draw.scale, 0, draw.scale, draw.scale)
    else
        love.graphics.setBackgroundColor(
            50 * draw.deathMessage.x,
            50 * draw.deathMessage.y,
            50 * draw.restartMessage.x)
        love.graphics.setColor(255, 0, 0, 255)
        love.graphics.print(
            "You died.",
            love.graphics.getWidth() / 2 * draw.deathMessage.x,
            love.graphics.getHeight() / 2 * draw.deathMessage.y,
            0, 2, 2)
        love.graphics.setColor(255, 50, 100, 255)
        love.graphics.print(
            "Press C to restart at a checkpoint.",
            love.graphics.getWidth() / 2 * draw.restartMessage.x,
            love.graphics.getHeight() / 2 * draw.restartMessage.y,
            0, 2, 2)
        love.graphics.print(
            "Press R to restart at a random location.",
            love.graphics.getWidth() / 2 * draw.restartMessage.x,
            love.graphics.getHeight() / 2 * draw.restartMessage.y + 25,
            0, 2, 2)
    end

    love.graphics.origin()
    love.graphics.setColor(255, 90, 100, 255)
    love.graphics.print("Score: " .. player.coinsCollected, 0, 2, 0, 2, 2)
end

------------------------
-- Keypressed
------------------------

function love.keypressed(key)
    if key == "escape" or key == "q" then
        love.event.quit()
    elseif key == "f" then
        love.window.setFullscreen(not love.window.getFullscreen())
    end

    if key == "-" then
        draw.scale = draw.scale / 2
    elseif key == "=" or key == "+" then
        draw.scale = draw.scale * 2
    elseif key == "0" then
        draw.scale = DEFAULT_SCALE
    end

    if (key == "`") then console.Show() end

    player.handleKey(key)
    if (player.dead) then
        draw.deathMessage.x = 0.5 + math.random()
        draw.deathMessage.y = 0.5 + math.random()
        draw.restartMessage.x = 0.5 + math.random()
        draw.restartMessage.y = 0.5 + math.random()

        if (key == "C" or key == "c") then
            if (player.checkpoint) then
                player.x = player.checkpoint.x
                player.y = player.checkpoint.y

                player:ressurect()
            end
        elseif (key == "R" or key == "r") then
            local pos = candles:randomPosition()
            assert(pos)

            player.x = pos.x
            player.y = pos.y

            player:ressurect()
        end
    end
end