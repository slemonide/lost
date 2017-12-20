
-------------------------------------------------------------------------------
-- Contains all players besides the local player
-------------------------------------------------------------------------------

players = {}
players.collection = {}

function players:get(id)
    if (not players.collection[id]) then
        players.collection[id] = {
            x = 0,
            y = 0,
            knownNodes = newXYMap()
        }
    end

    return players.collection[id]
end

function players:render()
    for _, remote_player in pairs(players.collection) do
        if (math.abs(remote_player.x - player.x) * SIZE * draw.scale < love.graphics.getWidth()
                and math.abs(remote_player.y - player.y) * SIZE * draw.scale < love.graphics.getHeight()) then
            love.graphics.draw(textures.player.image, textures.player.quad,
                remote_player.x * SIZE * draw.scale,
                remote_player.y * SIZE * draw.scale, 0, draw.scale, draw.scale)
        end
    end
end

function players:forEach(fun)
    for id, remote_player in pairs(players.collection) do
        fun(id, remote_player)
    end
end