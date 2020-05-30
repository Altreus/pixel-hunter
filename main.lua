local geo = require 'geometry'
local ui = require 'ui'
local Level = require 'level'
local HUD = require 'hud'

function __D(x)
    if __DEBUG__ then print(x) end
end

function love.load()
    game = ui.Pane(
        love.graphics.getWidth(),
        love.graphics.getHeight()
    )
    game.score = 0

    local menu = ui.Pane(game:getWidth(), game:getHeight())
    menu.__name__ = 'main menu'

    local startButton = makeStartButton()
    menu:addItem(startButton, 'start')
    startButton:centreIn(menu)

    local bgHelpText = makeBackgroundHelpText()
    bgHelpText:translate(geo.Vec(10,10))
    menu:addItem(bgHelpText,'helptext')

    game:addItem(menu,'menu')
end

function love.update(dt)
    game:update(dt)

    if gameRunning() then
        if game:getItem('hud'):timeUp() then
            game:removeItem('level')
            game:removeItem('hud')
            game:getItem('menu'):show()
        end
    end

    -- This comes from the UI - always set this.
    love.mouse.setCursor(__cursor)
end

function love.keyreleased(key)
    if key == 'd' then
        __DEBUG__ = not __DEBUG__
    end
end

function love.mousereleased(x,y,button)
    if button ~= 1 then return end

    local mousePoint = geo.Vec(x,y)
    game:onMouseUp(mousePoint)

    if game:getItem('level') then
        if game:getItem('level'):isBeaten() then
            game:getItem('hud'):pause()
        end
    end
end

function love.draw()
    game:draw()
end

function makeStartButton()
    local startButton = ui.Button(love.graphics.newImage('img/start-button.png'))
    startButton:addHandler('mouseup', function()
        local hud = HUD()
        local levelRect = geo.Rect(hud:getWidth(), 0, game:getWidth(), game:getHeight())
        local level = Level{rect = levelRect:getDiagonalVec():getXY()}

        game:addItem(hud, 'hud')
        game:addItem(level, 'level')

        level:translate(geo.Vec(hud:getWidth(), 0))

        game:getItem('menu'):hide()
    end)
    startButton.__name__ = 'start button'

    return startButton
end

function makeBackgroundHelpText()
    local bgHelpText = ui.Button(love.graphics.newText(
        love.graphics.getFont(),
        "Add custom backgrounds to "
        .. love.filesystem.getSaveDirectory()
        .. '/img/backgrounds'
    ))
    bgHelpText:addHandler('mouseup', function()
        local dir = love.filesystem.getSaveDirectory() .. '/img/backgrounds'

        if not love.filesystem.getInfo(dir) then
            love.filesystem.createDirectory(dir)
        end
        love.system.openURL(dir)
    end)

    bgHelpText.__name__ = 'help text'
    return bgHelpText
end

function gameRunning()
    return game:getItem('level') ~= nil
end
