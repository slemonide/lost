candles = {}
candles.storage = {}
candles.size = 0

function candles:add(x, y)
    if (not candles.storage[x]) then
        candles.storage[x] = {}
    end
    candles.storage[x][y] = true
    candles.size = candles.size + 1
end

function candles:forEach(fun)
    for x, yArray in pairs(candles.storage) do
        for y, candle in pairs(yArray) do
            if (candle) then
                local result = fun(x, y, candle)

                if (result) then
                    return result
                end
            end
        end
    end
end

function candles:contains(x, y)
    return (candles.storage[x] or {})[y]
end

function candles:randomPosition()
    local function newFunction()
        local randomChoice = math.random(candles.size)
        local counter = 0
        return function(x, y)
            counter = counter + 1
            if (counter == randomChoice) then
                return {x = x, y = y }
            end
        end
    end

    return candles:forEach(newFunction())
end