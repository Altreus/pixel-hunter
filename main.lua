local geo = require 'geometry'
local Level = require 'level'
local Button = require 'ui.button'
local HUD = require 'hud'
require 'scaler'

function love.load()
    game = {}
    local windowRect = geo.Rect(
        love.graphics.getWidth(),
        love.graphics.getHeight()
    )

    startButton = Button(love.graphics.newImage('img/start-button.png'))
    startButton:centreIn(windowRect)
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
        game.hud:update(dt)

        if game.hud:timeUp() then
            game.level = nil
            game.hud = nil
        end
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

    local hud = HUD()
    local windowRect = geo.Rect(
        hud:getWidth(), 0,
        love.graphics.getWidth(),
        love.graphics.getHeight()
    )
    local mousePoint = geo.Vec(x,y)

    if game.level then
        game.level:onClick()
        if game.level:isBeaten() then
            game.level = Level{
                maxSize = windowRect:getDiagonalVec(),
                difficulty = game.level.difficulty + 1
            }
            game.level:translate(windowRect.topLeft)
            game.hud.timer = 30
        end
    elseif startButton:contains(mousePoint) then
        game.hud = hud
        game.level = Level{maxSize = windowRect:getDiagonalVec()}
        game.level:translate(windowRect.topLeft)
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
        game.hud:draw()
        game.level:draw()
    else
        startButton:draw()
        bgHelpText:draw()
    end
end
