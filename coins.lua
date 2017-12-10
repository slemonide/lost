coins = {}
coins.storage = {}

function coins:add(x, y)
    if (not coins.storage[x]) then
        coins.storage[x] = {}
    end
    coins.storage[x][y] = true
end

function coins:forEach(fun)
    for x, yArray in pairs(coins.storage) do
        for y, candle in pairs(yArray) do
            if (candle) then
                fun(x, y, candle)
            end
        end
    end
end

function coins:contains(x, y)
    return (coins.storage[x] or {})[y]
end

function coins:remove(x, y)
    if (coins.storage[x] or {})[y] then
        coins.storage[x][y] = nil

        -- clean up if coins[x] is empty
        if (not coins.storage[x]) then
            coins.storage[x] = nil
        end
    end
end