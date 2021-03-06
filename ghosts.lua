require('player')
require('utils')
require('nodes')
require('textures')
require('tts')

MAX_ACTIVE_RANGE = 20 -- in blocks

ghosts = {}

function ghosts:addGhost(x, y, texture, followPlayer)
    table.insert(ghosts, {
        x = x,
        y = y,
        speed = 3, -- in blocks per dt
        timer = 0,
        texture = texture,
        followPlayer = followPlayer
    })
end

function ghosts:addPinkGhost(x, y)
    ghosts:addGhost(x, y, textures.ghostPink, false)
end

function ghosts:addGreyGhost(x, y)
    ghosts:addGhost(x, y, textures.ghostGrey, true)
end

function ghosts:update(dt)
    for _, ghost in ipairs(ghosts) do

        local dx = player.x - ghost.x
        local dy = player.y - ghost.y

        if (math.abs(dx) < 3 and math.abs(dy) < 3) then
            local string = "RUN away from "
            if (dy > 0) then
                string = string .. "north-"
            end
            if (dy < 0) then
                string = string .. "south-"
            end
            if (dx > 0) then
                string = string .. "west"
            end
            if (dx < 0) then
                string = string .. "east"
            end

            tts:say(string)
        end

        if (dx == 0 and dy == 0) then
            player:kill()
        end

        if (math.abs(dx) < MAX_ACTIVE_RANGE and math.abs(dy) < MAX_ACTIVE_RANGE) then
            if (ghost.timer > 1) then
                ghost.timer = 0

                local next_try_x, next_try_y
                if (ghost.followPlayer and math.random() > 0.2) then
                    next_try_x = ghost.x + sign(dx)
                    next_try_y = ghost.y + sign(dy)
                else
                    next_try_x = ghost.x + sign(math.random() - 0.5)
                    next_try_y = ghost.y + sign(math.random() - 0.5)
                end


                local choice = math.random() > 0.5
                if choice and nodes:isWalkable(ghost.x, next_try_y) then
                    ghost.x = ghost.x
                    ghost.y = next_try_y
                end

                if not choice and nodes:isWalkable(next_try_x, ghost.y) then
                    ghost.x = next_try_x
                    ghost.y = ghost.y
                end
            else
                ghost.timer = ghost.timer + dt * ghost.speed
            end
        end
    end
end