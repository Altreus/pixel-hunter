require 'dumper'
local geo = require 'geometry'
local Drawable = require 'ui.drawable'
local Pane = Drawable:extends()

function Pane:new(...)
    local arg={...}
    Pane.super.new(self, unpack(arg))
    self.items = {}
end

function Pane:addItem(item, name)
    item.parent = self
    self.items[name] = item
    item:handleGainedParent()
end

function Pane:removeItem(name)
    self.items[name] = nil
end

function Pane:getScreenOffset()
    local offset = self.topLeft:deepcopy(self.topLeft)

    if self.parent then
        offset = offset + self.parent:getScreenOffset()
    end

    return offset
end

function Pane:onMouseDown(mousePoint)
    for _, k in pairs(self.items) do
        k:onMouseDown(mousePoint - self:getScreenOffset())
    end
end

function Pane:onMouseUp(mousePoint)
    for _, k in pairs(self.items) do
        k:onMouseUp(mousePoint - self:getScreenOffset())
    end
end

function Pane:update(dt)
    for _, k in pairs(self.items) do
        k:update(dt)
    end
end

function Pane:doDraw()
    local canvas = love.graphics.newCanvas(unpack(self:getDiagonalVec():getXY()))
    love.graphics.setCanvas(canvas)

    for _, k in pairs(self.items) do
        k:draw()
    end

    love.graphics.setCanvas()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(canvas, self.topLeft:getX(), self.topLeft:getY())
end

return Pane
