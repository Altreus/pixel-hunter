local geo = require "geometry"

local Button = geo.Rect:extends()

function Button:new(image, x1, y1, x2, y2)
    x1 = x1 or 0
    y1 = y1 or 0
    x2 = x2 or image:getWidth()
    y2 = y2 or image:getHeight()
    Button.super.new(self, x1, y1, x2, y2)
    self.image = image
    self.hidden = false
end

function Button:update(dt)
    local mousePoint = geo.Vec(love.mouse.getX(), love.mouse.getY())
    local cursor = love.mouse.getSystemCursor('hand')

    if self:contains(mousePoint) then
        love.mouse.setCursor(cursor)
    end
end

function Button:draw()
    if self.hidden then return end

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
