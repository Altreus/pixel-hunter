local geo = require('geometry')
require('scaler')
require('dumper')

function love.load()
    cursor = love.mouse.getSystemCursor('hand')
    level = {
        rect = geo.Rect(
            love.math.random(8,30),
            love.math.random(8,30)
        ),
        pixel = geo.Vec(5,5)
    }
    local windowRect = geo.Rect(
        love.graphics.getWidth(),
        love.graphics.getHeight()
    )
    local levelScale = scaleFactor(level.rect, windowRect)
    local levelRect = level.rect:scaled(levelScale)
    local levelOffset = centreRect(levelRect, windowRect)

    local pixelOrigin = level.pixel * levelScale

    local pixelArea = geo.Rect(
        pixelOrigin:getX(), pixelOrigin:getY(),
        pixelOrigin:getX() + levelScale, pixelOrigin:getY() + levelScale
    )

    level.rect  = levelRect:translated(levelOffset)
    level.pixel = pixelArea:translated(levelOffset)
end

function love.update()

end

function love.draw()
    love.graphics.rectangle(
        "fill",
        level.rect.topLeft:getX(),
        level.rect.topLeft:getY(),
        level.rect:getWidth(),
        level.rect:getHeight()
    )
end
