local geo = require "geometry"

local Drawable = geo.Rect:extends()

function Drawable:new(...)
    Drawable.super.new(self,unpack({...}))
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

return Drawable
