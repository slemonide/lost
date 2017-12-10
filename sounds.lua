sounds = {}

-- taken from https://gist.github.com/BlackBulletIV/3904043
local function playSound(samples, noteChange, note, change, minimum)
    local data = love.sound.newSoundData(samples)

    for i = 0, samples * 2 - 1 do
        if i % noteChange == 0 then
            local factor = -1 + math.random(0, 2)
            if note <= minimum then factor = 1 end
            note = note + change * factor
        end

        data:setSample(i, math.sin(i % note / note / (math.pi * 2)))
    end

    love.audio.play(love.audio.newSource(data))
end

sounds.walkIntoWall = function()
    playSound(10000, 10000, 3, 50, 100)
end

sounds.normalWalk = function()
    playSound(10000, 10000, 800, 50, 100)
end

sounds.collectCoin = function()
    playSound(10000, 10000, 200, 100, 10)
end

sounds.newCheckpoint = function()
    playSound(10000, 10, 500, 400, 300)
end

sounds.deadlyItem = function()
    local data = love.sound.newSoundData(30000)

    for i = 0, 3000 do
        data:setSample(i * 10, math.sin(i + 200))
    end

    love.audio.play(love.audio.newSource(data))
end