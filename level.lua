require('scaler')
local geo = require('geometry')
local Class = require('class')
local module = {}
local Level = Class:extends()

function sizeRange(difficulty)
    local min = 10
    local max = 30
    min = min * (1 + (0.2 * difficulty))
    max = max * (1 + (0.2 * difficulty))

    return {min, max}
end

function Level:new(params)
    local difficulty = params.difficulty or 1

    assert(params.windowRect, "Must pass windowRect to Level()")

    local sizeRange = sizeRange(difficulty)
    local h = params.height or love.math.random(unpack(sizeRange))
    local w = params.width or love.math.random(unpack(sizeRange))
    self.rect = geo.Rect( h,w )

    print(tostring(self.rect))

    self.pixel = geo.Vec(
        love.math.random(1, self.rect:getWidth()),
        love.math.random(1, self.rect:getHeight())
    )

    self.scale = scaleFactor(self.rect, params.windowRect)
    local drawRect = self.rect:scaled(self.scale)
    self.offset = centreRect(drawRect, params.windowRect)
    self.drawRect = drawRect:translated(self.offset)

    local drawPixel = self.pixel * self.scale
    drawPixel = geo.Rect(
        drawPixel:getX(), drawPixel:getY(),
        drawPixel:getX() + self.scale, drawPixel:getY() + self.scale
    )
    self.drawPixel = drawPixel:translated(self.offset)
end

function Level:pixelContains(vec)
    return self.drawPixel:contains(vec)
end

function Level:getGridDrawBox()
    return {
        self.drawRect.topLeft:getX(),
        self.drawRect.topLeft:getY(),
        self.drawRect:getWidth(),
        self.drawRect:getHeight()
    }
end

function Level:getPixelDrawBox()
    return {
        self.drawPixel.topLeft:getX(),
        self.drawPixel.topLeft:getY(),
        self.drawPixel:getWidth(),
        self.drawPixel:getHeight()
    }
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
