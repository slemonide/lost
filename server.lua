require("players")
require("nodes")
local logger = require("log")

local socket = require "socket"

server = {}
server.started = false
server.udp = socket.udp()

server.clients = {}

local function log(msg)
    logger:write("Server: " .. msg)
end

function server:update_players(client_id, msg_or_ip, port_or_nil)
    -- remote players
    players:forEach(function(id, player)
        if (client_id ~= id) then
            server.udp:sendto(string.format("%s %s %d %d", id, 'move', player.x, player.y), msg_or_ip,  port_or_nil)
        end
    end)

    -- server player
    server.udp:sendto(string.format("%s %s %d %d", "admin", 'move', player.x, player.y), msg_or_ip,  port_or_nil)
end

function server:update_nodes(client_id, msg_or_ip, port_or_nil)
    nodes:forEach(function(x, y, node)
        if (not players:get(client_id).knownNodes:contains(x, y)) then
            server.udp:sendto(string.format("%s %s %d %d", node.name, 'addNode', x, y), msg_or_ip,  port_or_nil)

            players:get(client_id).knownNodes:add(x, y)
        end
    end)
end

function server:update()
    if (server.started) then
        local data, msg_or_ip, port_or_nil = server.udp:receivefrom()
        if data then
            local client_id, cmd, parms = data:match("^(%S*) (%S*) (.*)")
            if cmd == "register" then
                log("New client connected: " .. client_id)
                players:get(client_id)
            elseif cmd == "move" then
                local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
                assert(x and y) -- validation is better, but asserts will serve.
                x, y = tonumber(x), tonumber(y)

                local player = players:get(client_id)
                log(string.format("Player %s moved from %d %d to %d %d", client_id, player.x, player.y, x, y))

                player.x = x
                player.y = y
            elseif cmd == "update" then
                server:update_players(client_id, msg_or_ip, port_or_nil)
                server:update_nodes(client_id, msg_or_ip, port_or_nil)

            else
                log("unrecognised command: " .. cmd)
            end
        elseif msg_or_ip ~= 'timeout' then
            log("Unknown network error: "..tostring(msg))
        end

        socket.sleep(0.01)
    end
end

-- Start the server
function server:start()
    log("")
    log(os.date())
    log("Starting server...")

    server.udp:settimeout(0)
    server.udp:setsockname('*', 12345)
    server.started = true
end