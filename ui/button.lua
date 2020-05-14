local Drawable = require "ui.drawable"

local Button = Drawable:extends()

function Button:new(image, x1, y1, x2, y2)
    x1 = x1 or 0
    y1 = y1 or 0
    x2 = x2 or image:getWidth()
    y2 = y2 or image:getHeight()
    Button.super.new(self, x1, y1, x2, y2)
    self.image = image
    self.hidden = false
end

function Button:onMouseOver(mousePoint)
    if not self:isVisible() then return end

    local cursor = love.mouse.getSystemCursor('hand')

    love.mouse.setCursor(cursor)
end

function Button:doDraw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.image, self.topLeft:getX(), self.topLeft:getY())
end

function Button:contains(point)
    if self.hidden then return false end
    return self.super.contains(self, point)
end

function Button:hide()
    self.hidden = true
end

function Button:show()
    self.hidden = false
end

return Button
