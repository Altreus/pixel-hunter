-- How much bigger is rect2 than rect1?
-- IOW, how do we scale rect1 up so that it meets rect2?
-- They don't have to have the same aspect ratio - we return the smallest scale
-- factor that will make either dimension the same.
function scaleFactor(rect1, rect2)
    local widthFactor = rect2.x / rect1.x
    local heightFactor = rect2.y / rect1.y

    return math.min(widthFactor, heightFactor)
end

-- Returns coordinates of rect1 centred in rect2, relative to rect2
function centreRect(rect1, rect2)
    return {
        x = (rect2.x - rect1.x) / 2,
        y = (rect2.y - rect1.y) / 2
    }
end

function scaleToWindow(width, height)
    local rectRect = { x = width, y = height }
    local windowRect = { x = love.graphics.getWidth(), y = love.graphics.getHeight() }

    local k = scaleFactor(rectRect, windowRect);

    return { x = width * k, y = height * k }
end
