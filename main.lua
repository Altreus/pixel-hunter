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
    love.mouse.setCursor()
    if game.level then
        game.level:update(dt)
        game.hud:update(dt)

        if game.hud:timeUp() then
            game.level = nil
            game.hud = nil
            startButton:show()
        end
    end
    startButton:update(dt)
    bgHelpText:update(dt)
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
        game.level:onMouseUp(mousePoint)
        if game.level:isBeaten() then
            game.hud:pause()
        end
    elseif startButton:contains(mousePoint) then
        game.hud = hud
        game.level = Level{rect = windowRect:getDiagonalVec():getXY()}
        game.level:translate(windowRect.topLeft)
        startButton:hide()
        bgHelpText:hide()
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
    end

    startButton:draw()
    bgHelpText:draw()
end
