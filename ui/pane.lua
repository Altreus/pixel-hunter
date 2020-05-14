require 'dumper'
local geo = require 'geometry'
local Drawable = require 'ui.drawable'
local Pane = Drawable:extends()

function Pane:new(...)
    local arg={...}
    Pane.super.new(self, unpack(arg))
    self.items = {}
    self.mouseOvers = {}
end

function Pane:addItem(item, name)
    item.parent = self
    self.items[name] = item
    item:handleGainedParent()
end

function Pane:removeItem(name)
    self.items[name] = nil
end

function Pane:fitToSize()
    local maxH = 0
    local maxW = 0

    for _, i in pairs(self.items) do
        maxH = math.max(maxH, i.bottomRight:getY())
        maxW = math.max(maxW, i.bottomRight:getX())
    end

    if maxH == 0 or maxW == 0 then
        error("Could not determine size of pane. Is it empty?")
    end

    self.bottomRight:setX(self.topLeft:getX() + maxW)
    self.bottomRight:setY(self.topLeft:getY() + maxH)
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
    local mousePoint = geo.Vec(love.mouse.getX(), love.mouse.getY())
    local mousePointRel = mousePoint - self:getScreenOffset()

    for item, k in pairs(self.items) do
        if k:contains(mousePointRel) then
            self.mouseOvers[item] = mousePoint
            k:onMouseOver(mousePointRel)
        end
    end

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
