require('player')
require('utils')
require('nodes')
require('textures')

MAX_ACTIVE_RANGE = 10 -- in blocks

ghosts = {}

ghosts.addGhost = function(x, y, texture, followPlayer)
    table.insert(ghosts, {
        x = x,
        y = y,
        speed = 3, -- in blocks per dt
        timer = 0,
        texture = texture,
        followPlayer = followPlayer
    })
end

ghosts.addPinkGhost = function(x, y)
    ghosts.addGhost(x, y, textures.ghostPink, false)
end

ghosts.addGreyGhost = function(x, y)
    ghosts.addGhost(x, y, textures.ghostGrey, true)
end

ghosts.update = function(dt)
    for _, ghost in ipairs(ghosts) do

        local dx = player.x - ghost.x
        local dy = player.y - ghost.y

        if (dx == 0 and dy == 0) then
            player.dead = true
        end

        if (math.abs(dx) < MAX_ACTIVE_RANGE and math.abs(dy) < MAX_ACTIVE_RANGE) then
            if (ghost.timer > 1) then
                ghost.timer = 0

                local next_try_x, next_try_y
                if (ghost.followPlayer) then
                    next_try_x = ghost.x + sign(dx)
                    next_try_y = ghost.y + sign(dy)
                else
                    next_try_x = ghost.x + sign(math.random() - 0.5)
                    next_try_y = ghost.y + sign(math.random() - 0.5)
                end


                local choice = math.random() > 0.5
                if choice and nodes.isWalkable(ghost.x, next_try_y) then
                    ghost.x = ghost.x
                    ghost.y = next_try_y
                end

                if not choice and nodes.isWalkable(next_try_x, ghost.y) then
                    ghost.x = next_try_x
                    ghost.y = ghost.y
                end
            else
                ghost.timer = ghost.timer + dt * ghost.speed
            end
        end
    end
end