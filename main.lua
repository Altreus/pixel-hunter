local geo = require('geometry')
local Level = require('level')
require('dumper')

function love.load()
    cursor = love.mouse.getSystemCursor('hand')
    game = {}
    game.windowRect = geo.Rect(
        love.graphics.getWidth(),
        love.graphics.getHeight()
    )
    game.level = Level{windowRect = game.windowRect}

    print("Created new level:\n" .. tostring(game.level))
end

function love.update()
    if game.level:pixelContains(geo.Vec(love.mouse.getX(), love.mouse.getY())) then
        love.mouse.setCursor(cursor)
        game.pixelFound = true
    else
        love.mouse.setCursor()
        game.pixelFound = false
    end
end

function love.draw()
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle(
        "fill",
        unpack(game.level:getGridDrawBox())
    )

    local pointedAt = game.level:getGridPixelContaining(
        geo.Vec(love.mouse.getX(), love.mouse.getY())
    )

    if game.pixelFound then
        love.graphics.setColor(0,0,0,255)
        love.graphics.rectangle(
            "fill",
            unpack(game.level:getPixelDrawBox())
        )
    end

    if pointedAt then
        love.graphics.setColor(1, .2, .2, 1)
        love.graphics.setLineWidth(4)
        love.graphics.rectangle(
            "line",
            unpack( game.level:getPixelDrawBox(pointedAt) )
        )
    end
end
