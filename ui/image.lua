local Drawable = require 'ui.drawable'
local Image = Drawable:extends()

function Image:new(buf, x, y)
    x = x or 0
    y = y or 0

    local x2 = x + buf:getWidth()
    local y2 = y + buf:getHeight()
    Image.super.new(self, x, y, x2, y2)
    self.buf = buf
end

function Image:doDraw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.buf, self.topLeft:getX(), self.topLeft:getY())
end

return Image
