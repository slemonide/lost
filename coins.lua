require('xy_map')
require('client')

coins = newXYMap()

coins._remove = coins.remove

function coins:remove(x, y)
    if (client.connected) then
        client.udp:send(string.format("%s %s %f %f", client.id, 'removeCoin', x, y))
    end

    coins:_remove(x, y)
end