candles = {}

candles.addCandle = function (x, y)
    table.insert(candles, {
        x = x,
        y = y
    })

    if (not candles[x]) then
        candles[x] = {}
    end
    candles[x][y] = true
end