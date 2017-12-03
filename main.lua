require('conf')
require('nodes')
require('maze')
require('player')

------------------------
-- Load love
------------------------
function love.load()
    math.randomseed(os.time())
    textures.load()

    maze.addNewNode(0,0);
    for i = 0, 100 do
        maze.generate();
    end
    maze.writeToMap();

    -- debug
    lastKey = ""
end

------------------------
-- Update
------------------------

function love.update(dt)
    -- TODO: finish
end

------------------------
-- Draw
------------------------

-- Put origin to the center of the window
local function updateOrigin()
    love.graphics.origin()
    love.graphics.translate(
        love.graphics.getWidth() / 2 - player.x * SIZE,
        love.graphics.getHeight() / 2 - player.y * SIZE
    )
end

function love.draw()
    updateOrigin();

    -- Draw nodes
    for _, node in ipairs(nodes) do
        if (math.abs(node.x - player.x) * SIZE < love.graphics.getWidth()
                and math.abs(node.y - player.y) * SIZE < love.graphics.getHeight()) then
            love.graphics.setColor(255, 255, 255)
            love.graphics.draw(node.texture, node.x * SIZE, node.y * SIZE)
        end
    end

    -- Draw player
    love.graphics.setColor(50,50,100)
    love.graphics.circle(
        "fill",
        player.x * SIZE + SIZE / 2,
        player.y * SIZE + SIZE / 2,
        SIZE / 2
    )

    -- debug
    love.graphics.print(lastKey, 100, 200)
end

------------------------
-- Keypressed
------------------------

function love.keypressed(key)
    if key == "escape" or key == "q" then
        love.event.quit()
    end

    player.handleKey(key)

    -- debug
    lastKey = key
end