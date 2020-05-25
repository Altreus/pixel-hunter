local geo = require 'geometry'
local Button = require 'ui.button'
local Drawable = require 'ui.drawable'
local Pane = Drawable:extends()

__paneno__ = 1
function Pane:new(...)
    Pane.super.new(self, unpack({...}))
    self.items = {}
    self.mouseOvers = {}
    self.__name__ = "Pane " .. __paneno__
    __paneno__ = __paneno__ + 1
end

function Pane:addItem(item, name)
    item.parent = self
    self.items[name] = item
    item.__localname__ = name
    item:handleGainedParent()
end

function Pane:removeItem(name)
    self.items[name].__localname__ = nil
    self.items[name] = nil
end

function Pane:getItem(name)
    return self.items[name]
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
        if k:contains(mousePointRel) and not self.mouseOvers[item] then
            self.mouseOvers[item] = mousePoint
            k:onMouseOver(mousePointRel)
        end

        if not k:contains(mousePoint) and self.mouseOvers[item] then
            k:onMouseOut(mousePointRel)
            self.mouseOvers[item] = nil
        end
    end

    for _, k in pairs(self.items) do
        k:update(dt)
    end
end

function Pane:doDraw()
    local parentCanvas = love.graphics.getCanvas()
    local canvas = love.graphics.newCanvas(unpack(self:getDiagonalVec():getXY()))
    love.graphics.setCanvas(canvas)

    for item, k in pairs(self.items) do
        k:draw()
    end

    love.graphics.setCanvas(parentCanvas)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(canvas, self.topLeft:getX(), self.topLeft:getY())

    if __DEBUG__ then
        love.graphics.setColor(unpack(self.__colour__))
        love.graphics.rectangle('line', self.topLeft:getX(), self.topLeft:getY(), self:getWidth(), self:getHeight())
        love.graphics.print(self.__name__, self.topLeft:getX() + 5, self.topLeft:getY() + 5)

        local x = 12
        for item, _ in pairs(self.items) do
            love.graphics.print(item, self.topLeft:getX() + 5, self.topLeft:getY() + 5 + x)
            x = x + 12
        end
    end
end

return Pane
