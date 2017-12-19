require('xy_map')
require('player')

---------------------------------------
-- Writtable in-game text
---------------------------------------

text = {}
text.content = xy_map.newXYMap()

TEXT_SCALE = SIZE * 3 / 100

-- Write text at (x,y), taking w x h nodes
function text:write(string, x, y, w, h, size, color)
    text.content:add(x, y, {
        text = string,
        w = w or 1,
        h = h or 1,
        size = size or 1,
        color = color -- todo: finish
    })
end

-- Remove text item at (x, y)
function text:remove(x, y)
    text.content:remove(x,y)
end

-- Render text at given position
function text:render()
    text.content:forEach(function(x, y, text)
        if (math.abs(x - player.x) * SIZE * draw.scale < love.graphics.getWidth()
                and math.abs(y - player.y) * SIZE * draw.scale < love.graphics.getHeight()) then
            love.graphics.print(text.text, x * SIZE * draw.scale, y * SIZE * draw.scale, 0,
                TEXT_SCALE * draw.scale * text.size, TEXT_SCALE * draw.scale * text.size)
        end
    end)
end

function text:clear()
    text.content:clear()
end