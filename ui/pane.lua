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

    -- This mouse point is already relative to the parent!
    self:addHandler('mousedown', function(mousePoint)
        local mousePointRel = mousePoint - self.topLeft
        local mousePointRel = mousePoint - self:getScreenOffset()
        for _, k in pairs(self.items) do
            if k:contains(mousePointRel) then
                k:onMouseDown(mousePointRel)
            end
        end
    end)

    self:addHandler('mouseup', function(mousePoint)
        local mousePointRel = mousePoint - self.topLeft
        for _, k in pairs(self.items) do
            if k:contains(mousePointRel) then
                k:onMouseUp(mousePointRel)
            end
        end
    end)
end

function Pane:addItem(item, name)
    item.parent = self
    self.items[name] = item
    item.__localname__ = name
    item:handleGainedParent()
end

function Pane:removeItem(name)
    if self.items[name] then
        self.items[name].__localname__ = nil
        self.items[name] = nil
    end
end

function Pane:getItem(name)
    return self.items[name]
end

function Pane:getBoundingBox()
    local maxH = 0
    local maxW = 0

    for _, i in pairs(self.items) do
        maxH = math.max(maxH, i.bottomRight:getY())
        maxW = math.max(maxW, i.bottomRight:getX())
    end

    if maxH == 0 or maxW == 0 then
        error("Could not determine size of pane. Is it empty?")
    end

    return geo.Vec(maxW, maxH)
end

function Pane:fitToSize()
    self:resize(unpack(self:getBoundingBox():getXY()))
end

function Pane:getScreenOffset()
    local offset = self.topLeft:deepcopy(self.topLeft)

    if self.parent then
        offset = offset + self.parent:getScreenOffset()
    end

    return offset
end


function Pane:update(dt)
    local mousePoint = geo.Vec(love.mouse.getX(), love.mouse.getY())
    local mousePointRel = mousePoint - self:getScreenOffset()

    for item, k in pairs(self.items) do
        if k:contains(mousePointRel) and not self.mouseOvers[item] then
            self.mouseOvers[item] = mousePoint
            k:onMouseOver(mousePointRel)
        end

        if not k:contains(mousePointRel) and self.mouseOvers[item] then
            k:onMouseOut(mousePointRel)
            self.mouseOvers[item] = nil
        end
    end

    for _, k in pairs(self.items) do
        k:update(dt)
    end
end

function Pane:doDraw()
    for item, k in pairs(self.items) do
        k:draw()
    end
end

return Pane
