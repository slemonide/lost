-------------------------------------------------------------------------------
-- Keeps track of logs
-------------------------------------------------------------------------------

log = {}

function log:load()
    log.file = love.filesystem.newFile("lost.log")
end

function log:write(message)
    log.file:open("a")
    log.file:write(message .. "\n")
    log.file:close()
end

return log