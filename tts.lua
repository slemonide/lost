-------------------------------------------------------------------------------
-- TTS support using Google TTS API
-------------------------------------------------------------------------------

local http = require('socket.http')

tts = {}
tts.sources = {}


-- Taken from https://gist.github.com/ignisdesign/4323051
-- Thanks!
local function urlencode(str)
    if (str) then
        str = string.gsub (str, "\n", "\r\n")
        str = string.gsub (str, "([^%w ])",
            function (c) return string.format ("%%%02X", string.byte(c)) end)
        str = string.gsub (str, " ", "+")
    end
    return str
end

local function download_file(string, file_name)
    local file = love.filesystem.newFile(file_name)
    file:open("w")
    http.request{
        url = "https://translate.google.com/translate_tts?ie=UTF-8&q=" .. urlencode(string) .. "&tl=en&client=tw-ob",
        headers = {
            "Referer: http://translate.google.com/",
            "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:57.0) Gecko/20100101 Firefox/57.0"
        },
        sink = ltn12.sink.file(file)
    }
    file:close()
end

-- Say the given string
function tts:say(string)

    if (not tts.sources[string]) then
        if (not love.filesystem.exists("cache")) then
            love.filesystem.createDirectory("cache")
        end

        local file_name = "cache/" .. string:gsub("%s", "_") .. ".mp3"

        if (not love.filesystem.exists(file_name)) then
            download_file(string, file_name)
        end

        tts.sources[string] = love.audio.newSource(file_name, "static")
    end

    tts.sources[string]:play()
end