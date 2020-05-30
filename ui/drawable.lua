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

    self.handlers = {}
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
    self:onMouseOut(geo.Vec(love.mouse.getX(), love.mouse.getY()))
    self.tangible = false
end

function Drawable:show()
    self.hidden = false
    self.tangible = true
    self:onMouseOver(geo.Vec(love.mouse.getX(), love.mouse.getY()))
end

-- Not sure if this should be based on parent's tangibility
function Drawable:isTangible()
    return self.tangible
end

function Drawable:setTangible()
    self.tangible = true
    self:onMouseOver(geo.Vec(love.mouse.getX(), love.mouse.getY()))
end

function Drawable:setIntangible()
    self:onMouseOut(geo.Vec(love.mouse.getX(), love.mouse.getY()))
    self.tangible = false
end

function Drawable:setDrawDirect()
    self.drawDirect = true
end

function Drawable:setOwnCanvas()
    self.drawDirect = false
end

function Drawable:draw()
    if not self:isVisible() then return end

    if self.drawDirect then
        self:doDraw()
    else
        self.canvas:renderTo( function()
            love.graphics.clear()
            love.graphics.setColor(1,1,1,1)
            self:doDraw()
        end)

        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(self.canvas, self.topLeft:getX(), self.topLeft:getY())

        if __DEBUG__ then
            love.graphics.setColor(unpack(self.__colour__))
            love.graphics.setLineWidth(2)
            love.graphics.rectangle('line',
                self.topLeft:getX(), self.topLeft:getY(),
                self:getWidth(), self:getHeight())

            love.graphics.print(self.__name__,
                self.topLeft:getX() + 5, self.topLeft:getY() + 5)
        end
    end
end

function Drawable:addHandler(event, func)
    self.handlers[event] = self.handlers[event] or {}

    table.insert(self.handlers[event], func)
end

function Drawable:handleGainedParent() end

function Drawable:update() end

function Drawable:onMouseOver(vec)
    __D("Mouse over " .. self.__name__ .. " at " .. vec:toString())
    if not self:isVisible() and not self:isTangible() then
        __D("... but intangible")
        return
    end

    if self.handlers.mouseover then
        for _,h in pairs(self.handlers.mouseover) do
            h(vec)
        end
    end
end

function Drawable:onMouseOut(vec)
    __D("Mouse out " .. self.__name__ .. " at " .. vec:toString())
    if not self:isVisible() and not self:isTangible() then
        __D("... but intangible")
        return
    end

    if self.handlers.mouseout then
        for _,h in pairs(self.handlers.mouseout) do
            h(vec)
        end
    end
end

function Drawable:onMouseDown(vec)
    __D("Mouse down " .. self.__name__ .. " at " .. vec:toString())
    if not self:isVisible() and not self:isTangible() then
        __D("... but intangible")
        return
    end

    if self.handlers.mousedown then
        for _,h in pairs(self.handlers.mousedown) do
            h(vec)
        end
    end
end

function Drawable:onMouseUp(vec)
    __D("Mouse up " .. self.__name__ .. " at " .. vec:toString())
    if not self:isVisible() and not self:isTangible() then
        __D("... but intangible")
        return
    end

    if self.handlers.mouseup then
        for _,h in pairs(self.handlers.mouseup) do
            h(vec)
        end
    end
end

return Drawable
