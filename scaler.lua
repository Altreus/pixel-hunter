local geo = require('geometry')

-- Returns either the X ratio or the Y ratio of the two vectors, whichever is
-- smaller. Use this to determine how much to scale a rect in order to match
-- another one, by passing their diagonals as vectors.
function scaleFactor(vec1, vec2)
    local widthFactor = vec2:getX() / vec1:getX()
    local heightFactor = vec2:getY() / vec1:getY()

    return math.min(widthFactor, heightFactor)
end

-- Returns coordinates of vec1 centred in vec2, relative to rect2
function centreRect(vec1, vec2)
    return geo.Vec(
        (vec2:getX() - vec1:getX())  / 2,
        (vec2:getY() - vec1:getY()) / 2
    )
end

function scaleToWindow(rect)
    local windowRect = geo.Rect(love.graphics.getWidth(), love.graphics.getHeight())

    local k = scaleFactor(rect, windowRect);
    return rect:scaled(k)
end
