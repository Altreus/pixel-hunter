local geo = require('geometry')
require('scaler')
require('dumper')

function love.load()
    cursor = love.mouse.getSystemCursor('hand')
    game = {}
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
    if level.pixel:contains(geo.Vec(love.mouse.getX(), love.mouse.getY())) then
        love.mouse.setCursor(cursor)
        game.pixelFound = true
    else
        love.mouse.setCursor()
        game.pixelFound = false
    end
end

function love.draw()
    love.graphics.setColor(255,255,255,255)
    love.graphics.rectangle(
        "fill",
        level.rect.topLeft:getX(),
        level.rect.topLeft:getY(),
        level.rect:getWidth(),
        level.rect:getHeight()
    )
    if game.pixelFound then
        love.graphics.setColor(0,0,0,255)
        love.graphics.rectangle(
            "fill",
            level.pixel.topLeft:getX(),
            level.pixel.topLeft:getY(),
            level.pixel:getWidth(),
            level.pixel:getHeight()
        )
    end
end
