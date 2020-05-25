local geo = require "geometry"

local Drawable = geo.Rect:extends()

__drawableno__ = 1

function Drawable:new(...)
    Drawable.super.new(self,unpack({...}))
    self.__colour__ = { love.math.random(), love.math.random(), love.math.random(), 1 }
    self.__name__ = "Drawable " .. __drawableno__
    __drawableno__ = __drawableno__ + 1
    self.hidden = false
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

    self:doDraw()
end

function Drawable:handleGainedParent() end

function Drawable:update() end

function Drawable:onMouseOver() end

function Drawable:onMouseOut() end

function Drawable:onMouseDown() end

function Drawable:onMouseUp() end

return Drawable
