require('scaler')
local geo = require('geometry')
local Class = require('class')
local module = {}
local Level = Class:extends()

function sizeRange(difficulty)
    local min = 10
    local max = 22
    min = min * (1 + (0.2 * difficulty))
    max = max * (1 + (0.2 * difficulty))

    return {min, max}
end

function Level:new(params)
    self.difficulty = params.difficulty or 1

    assert(params.windowRect, "Must pass windowRect to Level()")

    local sizeRange = sizeRange(self.difficulty)
    local h = params.height or love.math.random(unpack(sizeRange))
    local w = params.width or love.math.random(unpack(sizeRange))
    self.rect = geo.Rect( h,w )

    self.pixel = geo.Vec(
        love.math.random(0, self.rect:getWidth() - 1),
        love.math.random(0, self.rect:getHeight() - 1)
    )

    self.scale = scaleFactor(self.rect, params.windowRect)
    local drawRect = self.rect:scaled(self.scale)
    self.offset = centreRect(drawRect, params.windowRect)
    drawRect:translate(self.offset)
    self.drawRect = drawRect
end

function Level:pixelContains(vec)
    return self:getPixelRect(self.pixel):contains(vec)
end

function Level:getGridPixelContaining(vec)
    local x = vec:getX() - self.offset:getX()
    local y = vec:getY() - self.offset:getY()

    local gridX = math.floor(x / self.scale)
    local gridY = math.floor(y / self.scale)

    if gridX < 0
    or gridY < 0
    or gridX >= self.rect:getWidth()
    or gridY >= self.rect:getHeight()
        then
            return nil
        end

    return geo.Vec(gridX, gridY)
end

function Level:getDrawBox(rect)
    return {
        rect.topLeft:getX(),
        rect.topLeft:getY(),
        rect:getWidth(),
        rect:getHeight()
    }
end

function Level:getGridDrawBox()
    return self:getDrawBox(self.drawRect)
end

function Level:getPixelDrawBox(px)
    if px == nil then
        px = self.pixel
    end

    return self:getDrawBox(self:getPixelRect(px))
end

function Level:getPixelRect(px)
    local drawPixel = px * self.scale
    drawPixel = geo.Rect(
        drawPixel:getX(), drawPixel:getY(),
        drawPixel:getX() + self.scale, drawPixel:getY() + self.scale
    )
    drawPixel:translate(self.offset)
    return drawPixel
end

function Level:toString()
    return (
" Rect:   " .. tostring(self.rect) .. "\n" ..
" Pixel:  " .. tostring(self.pixel) .. "\n" ..
"(Offset: " .. tostring(self.offset) .. " Scale: " .. tostring(self.scale) .. ")"
)
end

function Level.__tostring(level)
    return level:toString()
end

return Level
