coins = {}

coins.addCoin = function(x, y)
    table.insert(coins, {
        x = x,
        y = y
    })

    if (not coins[x]) then
        coins[x] = {}
    end
    coins[x][y] = true
end