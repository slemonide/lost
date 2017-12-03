require('nodes')

player = {
    x = 0,
    y = 0,
    dead = false,
    blind = false
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

player.handleKey = function(key)
    local movement = getMovement(key)

    if movement and nodes.isWalkable(movement.x, movement.y) and player.blind then
        player.x = movement.x
        player.y = movement.y

        if (nodes.isDeadly(movement.x, movement.y)) then
            player.dead = true
        end
    end

    if key == "space" then
        player.blind = not player.blind
    end
end