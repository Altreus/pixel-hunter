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

function Rect:translated(vec)
    if type(vec) == "number" then
        vec = Vec(vec,vec)
    end
    return Rect(
        self.topLeft:getX() + vec:getX(),
        self.topLeft:getY() + vec:getY(),
        self.bottomRight:getX() + vec:getX(),
        self.bottomRight:getY() + vec:getY()
    )
end

function Rect:scaled(x,y)
    if y == nil then y = x end

    local rect = Rect(self:getWidth() * x, self:getHeight() * y)
    return rect:translated(self.topLeft:getX(), self.topLeft:getY())
end

function Rect:contains(vec)
    return (
        vec:getX() <= self.bottomRight:getX()
    and vec:getY() <= self.bottomRight:getY()
    and vec:getX() >= self.topLeft:getX()
    and vec:getY() >= self.topLeft:getY()
    )
end

function Rect:toString()
    return "Rect( " .. tostring(self.topLeft) .. " : " .. tostring(self.bottomRight) .. " )"
end

function Rect.__tostring(rect)
    return rect:toString()
end

module.Vec = Vec
module.Rect = Rect

return module
