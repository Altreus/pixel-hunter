local geo = require 'geometry'
local Level = require 'level'
local Button = require 'ui.button'
require 'scaler'

function love.load()
    game = {}
    local windowRect = geo.Rect(
        love.graphics.getWidth(),
        love.graphics.getHeight()
    )

    startButton = Button(love.graphics.newImage('img/start-button.png'))
    startButton:translate(centreRect(startButton, windowRect))
    bgHelpText = Button(love.graphics.newText(
        love.graphics.getFont(),
        "Add custom backgrounds to "
        .. love.filesystem.getSaveDirectory()
        .. '/img/backgrounds'
    ))
    bgHelpText:translate(geo.Vec(10,10))
end

function love.update(dt)
    local mousePoint = geo.Vec(love.mouse.getX(), love.mouse.getY())
    local cursor = love.mouse.getSystemCursor('hand')
    if game.level then
        game.level:update(dt)
    else
        if startButton:contains(mousePoint) or bgHelpText:contains(mousePoint) then
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
        level:onClick()
        if level:isBeaten() then
            game.level = Level{
                windowRect = windowRect,
                difficulty = game.level.difficulty + 1
            }
        end
    elseif startButton:contains(mousePoint) then
        game.level = Level{windowRect = windowRect}
    elseif bgHelpText:contains(mousePoint) then
        local dir = love.filesystem.getSaveDirectory() .. '/img/backgrounds'

        if not love.filesystem.getInfo(dir) then
            love.filesystem.createDirectory(dir)
        end
        love.system.openURL(dir)
    end
end

function love.draw()
    if game.level then
        game.level:draw()
    else
        startButton:draw()
        bgHelpText:draw()
    end
end
