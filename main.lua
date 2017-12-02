require('conf')
require('nodes')
require('maze')
require('player')

------------------------
-- Load love
------------------------
function love.load()
    maze.addNewNode(0,0);

    -- debug
    nodes.addFloor(0, 0)
    nodes.addFloor(1, 0)
    nodes.addFloor(-1, 0)
    nodes.addFloor(0, 1)
    nodes.addWall(0, -1)
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
    love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
end

function love.draw()
    updateOrigin();

    -- Draw nodes
    for _, node in ipairs(nodes) do
        love.graphics.setColor(node.color)
        love.graphics.rectangle("fill", node.x * SIZE, node.y * SIZE, SIZE, SIZE)
    end

    -- Draw player
    love.graphics.setColor(50,50,100)
    love.graphics.circle("fill", player.x + SIZE / 2, player.y + SIZE / 2, SIZE / 2)

    love.graphics.print(player.x, 100, 200)
end

------------------------
-- Keypressed
------------------------

function love.keypressed(key)
    if key == "escape" or key == "q" then
        love.event.quit()
    end



    player.handleKey(key)
end