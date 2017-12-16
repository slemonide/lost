require('xy_map')

---------------------------------------
-- In-game event triggers
---------------------------------------

triggers = {}
triggers.onPlayerWalkAtCollection = xy_map.newXYMap()

-- Updates triggers
function triggers:update(dt)
    if triggers.onPlayerWalkAtCollection:get(player.x, player.y) then
        triggers.onPlayerWalkAtCollection:get(player.x, player.y).action()
    end
end

-- Adds a trigger activated when a player walks on (x, y)
function triggers:onPlayerWalkAt(x, y, func)
    triggers.onPlayerWalkAtCollection:add(x, y, {
        action = func
    })
end