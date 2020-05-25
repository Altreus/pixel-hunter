local geo = require 'geometry'
local ui = require 'ui'
local Level = require 'level'
local HUD = require 'hud'

function __D(x)
    if __DEBUG__ then print(x) end
end

require 'scaler'

function love.load()
    game = {
        score = 0
    }
    local windowRect = geo.Rect(
        love.graphics.getWidth(),
        love.graphics.getHeight()
    )

    local menu = ui.Pane(windowRect:getWidth(), windowRect:getHeight())
    startButton = ui.Button(love.graphics.newImage('img/start-button.png'))
    menu:addItem(startButton, 'start')
    startButton:centreIn(menu)
    game.menu = menu

    startButton.__name__ = 'start button'
    menu.__name__ = 'main menu'

    bgHelpText = ui.Button(love.graphics.newText(
        love.graphics.getFont(),
        "Add custom backgrounds to "
        .. love.filesystem.getSaveDirectory()
        .. '/img/backgrounds'
    ))
    bgHelpText:translate(geo.Vec(10,10))
    bgHelpText.__name__ = 'help text'
end

function love.update(dt)
    if game.level then
        game.level:update(dt)
        game.hud:update(dt)

        if game.hud:timeUp() then
            game.level = nil
            game.hud = nil
            startButton:show()
        end
    end
    game.menu:update(dt)
    love.mouse.setCursor(__cursor)
end

function love.keyreleased(key)
    if key == 'd' then
        __DEBUG__ = not __DEBUG__
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
        game.level:onMouseUp(mousePoint)
        if game.level:isBeaten() then
            game.hud:pause()
        end
    elseif startButton:contains(mousePoint) then
        game.hud = hud
        game.level = Level{rect = windowRect:getDiagonalVec():getXY()}
        game.level:translate(windowRect.topLeft)
        game.menu:hide()
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

    bgHelpText:draw()
    game.menu:draw()
end
