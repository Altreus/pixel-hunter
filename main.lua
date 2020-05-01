require('scaler')

function love.load()
    level = {
        height = 20,
        width = 10,
        pixel = { 5, 5 }
    }
end

function love.update()

end

function love.draw()
    local windowRect = { x = love.graphics.getWidth(), y = love.graphics.getHeight() }
    local rect = scaleToWindow(level.width, level.height)
    local offset = centreRect( rect, windowRect )

    love.graphics.rectangle("fill", offset.x, offset.y, rect.x, rect.y)
end
