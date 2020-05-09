local vec2d = require('vectorial2')
local Vec = vec2d.Vector2D
local Class = require('class')
local module = {}
local Rect = Class:extends()

function Rect:new(x1, y1, x2, y2)
    if x2 == nil then
        x2 = x1
        y2 = y1
        x1 = 0
        y1 = 0
    end

    self.topLeft = Vec(x1, y1)
    self.bottomRight = Vec(x2, y2)
end

function Rect:getWidth()
    return self.bottomRight:getX() - self.topLeft:getX()
end

function Rect:getHeight()
    return self.bottomRight:getY() - self.topLeft:getY()
end

function Rect:getDiagonalVec()
    return self.bottomRight - self.topLeft
end

function Rect:asXYHW()
    return {
        self.topLeft:getX(),
        self.topLeft:getY(),
        self:getWidth(),
        self:getHeight()
    }
end

-- Don't like this function, rewrite it to just centre a copy
--function Rect:centredIn(rect2)
    --return Vec(
        --(rect2:getWidth()  - self:getWidth())  / 2,
        --(rect2:getHeight() - self:getHeight()) / 2
    --)
--end

function Rect:centreIn(rect2)
    local offset = (rect2:getDiagonalVec() - self:getDiagonalVec()) / 2
    self:translate(-self.topLeft)
    self:translate(offset + rect2.topLeft)
end

function Rect:translate(vec)
    self.topLeft = self.topLeft + vec
    self.bottomRight = self.bottomRight + vec
    return self
end

function Rect:translated(vec)
    local ret = self:deepcopy()
    ret.topLeft = ret.topLeft + vec
    ret.bottomRight = ret.bottomRight + vec
    return ret
end

function Rect:scale(x,y)
    local r = self:scaled(x,y)
    self.topLeft = r.topLeft
    self.bottomRight = r.bottomRight
    return self
end

function Rect:scaled(x,y)
    if y == nil then y = x end

    local rect = Rect(self:getWidth() * x, self:getHeight() * y)
    return rect:translate(self.topLeft)
end

function Rect:contains(vec)
    return (
        vec:getX() <= self.bottomRight:getX()
    and vec:getY() <= self.bottomRight:getY()
    and vec:getX() >= self.topLeft:getX()
    and vec:getY() >= self.topLeft:getY()
    )
end

---------------
-- Programmy functions
---------------

function Rect:deepcopy()
    return Rect(
        self.topLeft:getX(), self.topLeft:getY(),
        self.bottomRight:getX(), self.bottomRight:getY()
    )
end

function Rect:toString()
    return "Rect( " .. tostring(self.topLeft) .. " : " .. tostring(self.bottomRight) .. " )"
end

-- We add two rects by adding their corner vectors together
function Rect.__add(rect1, rect2)
    local out = rect1:deepcopy()
    out.topLeft = rect1.topLeft + rect2.topLeft
    out.bottomRight = rect1.bottomRight + rect2.bottomRight
    return out
end

function Rect.__tostring(rect)
    return rect:toString()
end

module.Vec = Vec
module.Rect = Rect

return module
