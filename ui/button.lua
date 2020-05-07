local geo = require "geometry"

local Button = geo.Rect:extends()

function Button:new(image, x1, y1, x2, y2)
    x1 = x1 or 0
    y1 = y1 or 0
    x2 = x2 or image:getWidth()
    y2 = y2 or image:getHeight()
    Button.super.new(self, x1, y1, x2, y2)
    self.image = image
end

function Button:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.image, self.topLeft:getX(), self.topLeft:getY())
end

return Button
