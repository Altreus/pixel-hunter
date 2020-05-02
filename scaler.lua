local geo = require('geometry')

-- How much bigger is rect2 than rect1?
-- IOW, how do we scale rect1 up so that it meets rect2?
-- They don't have to have the same aspect ratio - we return the smallest scale
-- factor that will make either dimension the same.
function scaleFactor(rect1, rect2)
    local widthFactor = rect2:getWidth() / rect1:getWidth()
    local heightFactor = rect2:getHeight() / rect1:getHeight()

    return math.min(widthFactor, heightFactor)
end

-- Returns coordinates of rect1 centred in rect2, relative to rect2
function centreRect(rect1, rect2)
    return geo.Vec(
        (rect2:getWidth()  - rect1:getWidth())  / 2,
        (rect2:getHeight() - rect1:getHeight()) / 2
    )
end

function scaleToWindow(rect)
    local windowRect = geo.Rect(love.graphics.getWidth(), love.graphics.getHeight())

    local k = scaleFactor(rect, windowRect);
    return rect:scaled(k)
end
