local geo = require "geometry"

local Drawable = geo.Rect:extends()

__drawableno__ = 1

function Drawable:new(...)
    Drawable.super.new(self,unpack({...}))
    self.__colour__ = { love.math.random(), love.math.random(), love.math.random(), 1 }
    self.__name__ = "Drawable " .. __drawableno__
    __drawableno__ = __drawableno__ + 1
    self.hidden = false
    self.canvas = love.graphics.newCanvas(self:getWidth(), self:getHeight())
end

function Drawable:isVisible()
    if self.parent then
        return self.parent:isVisible() and not self.hidden
    else
        return not self.hidden
    end
end

function Drawable:hide()
    self.hidden = true
end

function Drawable:show()
    self.hidden = false
end

function Drawable:draw()
    if not self:isVisible() then return end

    self.canvas:renderTo( function()
        love.graphics.clear()
        love.graphics.setColor(1,1,1,1)
        self:doDraw()
        if __DEBUG__ then
            love.graphics.setColor(unpack(self.__colour__))
            love.graphics.setLineWidth(2)
            love.graphics.rectangle('line',
                self.topLeft:getX(), self.topLeft:getY(),
                self:getWidth(), self:getHeight())

            love.graphics.print(self.__name__,
                self.topLeft:getX() + 5, self.topLeft:getY() + 5)
        end
    end)

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.canvas, self.topLeft:getX(), self.topLeft:getY())
end

function Drawable:handleGainedParent() end

function Drawable:update() end

function Drawable:onMouseOver() end

function Drawable:onMouseOut() end

function Drawable:onMouseDown() end

function Drawable:onMouseUp() end

return Drawable
