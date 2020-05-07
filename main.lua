local geo = require 'geometry'
local Level = require 'level'
local Button = require 'ui.button'
require 'scaler'
require 'dumper'

function love.load()
    cursor = love.mouse.getSystemCursor('hand')
    game = {}
    local windowRect = geo.Rect(
        love.graphics.getWidth(),
        love.graphics.getHeight()
    )

    startButton = Button(love.graphics.newImage('img/start-button.png'))
    startButton:translate(centreRect(startButton, windowRect))
end

function love.update()
    local mousePoint = geo.Vec(love.mouse.getX(), love.mouse.getY())
    if game.level then
        if game.level:pixelContains(mousePoint) then
            love.mouse.setCursor(cursor)
            game.pixelFound = true
        else
            love.mouse.setCursor()
            game.pixelFound = false
        end
    else
        if startButton:contains(mousePoint) then
            love.mouse.setCursor(cursor)
        else
            love.mouse.setCursor()
        end
    end
end

function love.mousereleased(x,y,button)
    if button ~= 1 then return end

    local windowRect = geo.Rect(
        love.graphics.getWidth(),
        love.graphics.getHeight()
    )
    local mousePoint = geo.Vec(x,y)

    if game.level then
        if game.pixelFound then
            game.level = Level{
                windowRect = windowRect,
                difficulty = game.level.difficulty + 1
            }
        end
    elseif startButton:contains(mousePoint) then
        game.level = Level{windowRect = windowRect}

        print("Created new level:\n" .. tostring(game.level))
    end
end

function love.draw()
    if game.level then
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
    else
        startButton:draw()
    end
end
