require('nodes')
require('sounds')

BLINDNESS_DELAY = 3 -- in seconds

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
            draw:fadeEnd(1/BLINDNESS_DELAY)
        else
            player.blind = player.blind - dt
        end
    end
end

-- The proper way to kill a player
function player:kill()
    player.dead = true
    sounds.youDied:play()
end

function player:ressurect()
    player.dead = false
    sounds.youAreAlive:play()
end

player.handleKey = function(key)
    local movement = getMovement(key)

    if (movement and not player.blind) then
        player.blind = BLINDNESS_DELAY
        draw:fadeBegin(1/BLINDNESS_DELAY)
    end

    if movement and player.blind then
        local dx = player.x
        local dy = player.y
        if (nodes:isWalkable(movement.x, movement.y)) then
            player.x = movement.x
            player.y = movement.y

            if (nodes:isDeadly(player.x, player.y)) then
                player:kill()
            end

            if (candles:contains(movement.x, movement.y)) then
                player.checkpoint.x = movement.x
                player.checkpoint.y = movement.y
                sounds.newCheckpoint:play()
                draw:fadeEnd(1/BLINDNESS_DELAY)
            end

            if (coins:contains(movement.x, movement.y)) then
                player.coinsCollected = player.coinsCollected + 1
                coins:remove(movement.x, movement.y)
                sounds.coinCollected:play()
                draw:fadeEnd(1/BLINDNESS_DELAY)
            end

            dx = player.x - dx
            dy = player.y - dy

            if (not nodes:isWalkable(player.x + dx, player.y + dy)) then
                sounds.wall:play()
            elseif (nodes:isDeadly(player.x + dx, player.y + dy)) then
                sounds.deadly:play()
            end
        else
            sounds.wall:play()
        end
    end
end