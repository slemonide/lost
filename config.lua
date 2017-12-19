---------------------------------------
-- User configarable options
---------------------------------------

config = {}
config.NAME = "user_config.lua"

-- Default config
config.enable_tts = true

-- Load config
function config:load()
    -- For now, just parse a lua file, todo: make it safer later
    if (love.filesystem.exists(config.NAME)) then
        love.filesystem.load(config.NAME)()
    end
end