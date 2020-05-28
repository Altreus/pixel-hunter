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
end

function Drawable:show()
    self.hidden = false
end

function Drawable:setDrawDirect()
    self.drawDirect = true
end

function Drawable:setOwnCanvas()
    self.drawDirect = false
end

function Drawable:draw()
    if not self:isVisible() then return end

    local draw = function()
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
    end

    if self.drawDirect then
        draw()
    else
        self.canvas:renderTo( function()
            love.graphics.clear()
            love.graphics.setColor(1,1,1,1)
            draw()
        end)

        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(self.canvas, self.topLeft:getX(), self.topLeft:getY())
    end
end

function Drawable:addHandler(event, func)
    self.handlers[event] = self.handlers[event] or {}

    table.insert(self.handlers[event], func)
end

function Drawable:handleGainedParent() end

function Drawable:update() end

function Drawable:onMouseOver(vec)
    __D("Mouse over " .. self.__localname__)
    if not self:isVisible() then
        __D("... but invisible")
        return
    end

    if self.handlers.mouseover then
        for _,h in pairs(self.handlers.mouseover) do
            h(vec)
        end
    end
end

function Drawable:onMouseOut(vec)
    __D("Mouse out " .. self.__localname__)
    if not self:isVisible() then
        __D("... but invisible")
        return
    end

    if self.handlers.mouseout then
        for _,h in pairs(self.handlers.mouseout) do
            h(vec)
        end
    end
end

function Drawable:onMouseDown(vec)
    __D("Mouse down " .. self.__localname__)
    if not self:isVisible() then
        __D("... but invisible")
        return
    end

    if self.handlers.mousedown then
        for _,h in pairs(self.handlers.mousedown) do
            h(vec)
        end
    end
end

function Drawable:onMouseUp(vec)
    __D("Mouse up " .. self.__localname__)
    if not self:isVisible() then
        __D("... but invisible")
        return
    end

    if self.handlers.mouseup then
        for _,h in pairs(self.handlers.mouseup) do
            h(vec)
        end
    end
end

return Drawable
