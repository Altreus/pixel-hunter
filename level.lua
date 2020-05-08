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

    self.fadeInAlpha = 0
    local sizeRange = sizeRange(self.difficulty)
    local h = params.height or love.math.random(unpack(sizeRange))
    local w = params.width or love.math.random(unpack(sizeRange))
    self.rect = geo.Rect(w, h)

    self.pixel = geo.Vec(
        love.math.random(0, self.rect:getWidth() - 1),
        love.math.random(0, self.rect:getHeight() - 1)
    )

    self.scale = scaleFactor(self.rect, params.windowRect)
    local drawRect = self.rect:scaled(self.scale)
    self.offset = centreRect(drawRect, params.windowRect)
    drawRect:translate(self.offset)
    self.drawRect = drawRect

    local imageList = love.filesystem.getDirectoryItems('img/backgrounds')
    local image = love.graphics.newImage(
        'img/backgrounds/' .. imageList[love.math.random(#imageList)]
    )
    local imageRect = geo.Rect(image:getPixelWidth(), image:getPixelHeight())
    local imageScale = 1/scaleFactor(self.rect, imageRect)
    imageRect:scale(imageScale)

    local canvas = love.graphics.newCanvas(
        self.rect:getWidth(), self.rect:getHeight()
    )
    -- this will give us the image position, i.e. a negative number.
    local canvasOffset = centreRect(
        imageRect, self.rect
    )
    local canvasScale = scaleFactor(self.rect, self.drawRect)

    love.graphics.setColor(1,1,1,1)
    love.graphics.setCanvas(canvas)
    love.graphics.draw(image, canvasOffset:getX(), canvasOffset:getY(), 0, imageScale)

    local bigCanvas = love.graphics.newCanvas(
        drawRect:getWidth(), drawRect:getHeight()
    )
    local canvasScale = scaleFactor(self.rect, self.drawRect)

    love.graphics.setCanvas(bigCanvas)
    canvas:setFilter('nearest', 'nearest')
    love.graphics.draw(canvas, 0, 0, 0, canvasScale)
    love.graphics.setCanvas()

    self.image = bigCanvas
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

function Level:isBeaten()
    return self.beaten
end

function Level:onClick()
    local mousePoint = geo.Vec(love.mouse.getX(), love.mouse.getY())
    if self:pixelContains(mousePoint) then
        self.beaten = true
    end
end

function Level:update(dt)
    local mousePoint = geo.Vec(love.mouse.getX(), love.mouse.getY())
    local cursor = love.mouse.getSystemCursor('hand')
    local alphaStep = 0.8*dt*2

    if love.keyboard.isDown('p') then
        self:fadeToWhite(alphaStep)
    elseif self:pixelContains(mousePoint) then
        love.mouse.setCursor(cursor)
        self:fadeToWhite(alphaStep)
    else
        love.mouse.setCursor()
        self:fadeToColour(alphaStep)
    end
end

function Level:fadeToWhite(alphaStep)
    if self.fadeInAlpha < 0.8 then
        self.fadeInAlpha = self.fadeInAlpha + alphaStep
    end
    if self.fadeInAlpha > 0.8 then
        self.fadeInAlpha = 0.8
    end
end

function Level:fadeToColour(alphaStep)
    if self.fadeInAlpha >= 0 then
        self.fadeInAlpha = self.fadeInAlpha - alphaStep
    end
    if self.fadeInAlpha < 0 then
        self.fadeInAlpha = 0
    end
end

function Level:draw()
    local drawBox = self:getGridDrawBox()

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.image, drawBox[1], drawBox[2])

    if self.fadeInAlpha then
        love.graphics.setColor(1,1,1,self.fadeInAlpha)
        love.graphics.rectangle(
            "fill",
            unpack(drawBox)
        )
    end

    local mousePoint = geo.Vec(love.mouse.getX(), love.mouse.getY())
    if self:pixelContains(mousePoint) or love.keyboard.isDown('p') then
        love.graphics.setColor(0,0,0,1)
        love.graphics.rectangle(
            "fill",
            unpack(self:getPixelDrawBox())
        )
    end

    local pointedAt = self:getGridPixelContaining(mousePoint)
    if pointedAt then
        love.graphics.setColor(1, .2, .2, 1)
        love.graphics.setLineWidth(4)
        love.graphics.rectangle(
            "line",
            unpack( self:getPixelDrawBox(pointedAt) )
        )
    end
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
