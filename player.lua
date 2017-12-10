require('nodes')
require('sounds')

BLINDNESS_DELAY = 0.01 -- in seconds

player = {
    x = 0,
    y = 0,
    dead = false,
    blind = false,
    checkpoint = {
        x = 0,
        y = 0
    },
    coinsCollected = 0
}

local function getMovement(key)
    if key == "up" or key == "w" then
        return {
            x = player.x,
            y = player.y - 1
        }
    elseif key == "down" or key == "s" then
        return {
            x = player.x,
            y = player.y + 1
        }
    elseif key == "left" or key == "a" then
        return {
            x = player.x - 1,
            y = player.y
        }
    elseif key == "right" or key == "d" then
        return {
            x = player.x + 1,
            y = player.y
        }
    else
        return false
    end
end

function player:update(dt)
    if (player.blind) then
        if (player.blind < 0) then
            player.blind = false
        else
            player.blind = player.blind - dt
        end
    end
end

player.handleKey = function(key)
    local movement = getMovement(key)

    if (not player.blond) then
        player.blind = BLINDNESS_DELAY
    end

    if movement and player.blind then
        if (nodes.isWalkable(movement.x, movement.y)) then
            --sounds.normalWalk()

            if (not love.keyboard.isDown('lshift')) then
                player.x = movement.x
                player.y = movement.y

                local nextMovement = getMovement(key)

                if (nodes.isDeadly(nextMovement.x, nextMovement.y)) then
                    sounds.deadlyItem()
                end
            end

            if (nodes.isDeadly(player.x, player.y)) then
                player.dead = true
            end

            if (candles:contains(movement.x, movement.y)) then
                player.checkpoint.x = movement.x
                player.checkpoint.y = movement.y
                sounds.newCheckpoint()
            end

            if (coins:contains(movement.x, movement.y)) then
                player.coinsCollected = player.coinsCollected + 1
                coins:remove(movement.x, movement.y)
                sounds.collectCoin()
            end
        else
            sounds.walkIntoWall()
        end
    end
end