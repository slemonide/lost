local logger = require("log")
local socket = require "socket"

client = {}
client.connected = false
client.address, client.port = "localhost", 12345

client.updaterate = 0.1

-- Some caching data
client.data = {}

local function log(msg)
    logger:write("Client: " .. msg)
end

function client:update(dt)
    if (client.connected) then
        client.t = client.t + dt

        if (client.t > client.updaterate) then
            if (client.data.prev_x ~= player.x or client.data.prev_y ~= player.y) then
                client.udp:send(string.format("%s %s %f %f", client.id, 'move', player.x, player.y))

                client.data.prev_x = player.x
                client.data.prev_y = player.y
            end

            client.udp:send(string.format("%s %s %d %d %d %d", client.id, 'update', player.x - 10, player.y - 10, 20, 20))
            client.t = client.t - client.updaterate
        end

        repeat
            local data, msg = client.udp:receive()
            if data then
                ent, cmd, parms = data:match("^(%S*) (%S*) (.*)")
                if cmd == 'move' then
                    local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
                    assert(x and y)
                    x, y = tonumber(x), tonumber(y)
                    players:get(ent).x = x
                    players:get(ent).y = y
                elseif cmd == "addNode" then
                    local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
                    assert(x and y)
                    x, y = tonumber(x), tonumber(y)
                    nodes:addNode(x, y, ent)
                elseif cmd == "addItem" then
                    local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
                    assert(x and y)
                    x, y = tonumber(x), tonumber(y)
                    --else
                    --    log("addItem: unknown item: " .. ent)
                    --end
                elseif cmd == "removeItem" then
                    local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
                    assert(x and y)
                    x, y = tonumber(x), tonumber(y)

                    --else
                    --    log("removeItem: unknown item: " .. ent)
                    --end
                else
                    log("unrecognised command: " .. cmd)
                end
            elseif msg ~= 'timeout' then
                log("Network error: " .. tostring(msg))
                client:disconnect()
            end
        until not data
    end
end

function client:connect()
    client.udp = socket.udp()
    client.udp:settimeout(0)
    client.udp:setpeername(client.address, client.port)
    log("Connecting to server " .. client.address .. " " .. client.port)

    client.id = tostring(math.random(99999))
    client.t = 0 -- update delay

    client.udp:send(string.format("%s %s $", client.id, 'register'))

    client.data = {
        prev_x = player.x,
        prev_y = player.y
    }

    client.connected = true
end

function client:disconnect()
    client.connected = false
end