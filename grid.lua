require 'scaler'
local geo = require 'geometry'
local Drawable = require 'ui.drawable'

local Grid = Drawable:extends()

--------------------------
-- Love methods
--------------------------

function Grid:new(gridSize)
    Grid.super.new(self, gridSize:getX(), gridSize:getY())
    self.gridSize = gridSize
    self.pixel = geo.Vec(
        love.math.random(0, gridSize:getX() - 1),
        love.math.random(0, gridSize:getY() - 1)
    )
    self.fadeInAlpha = 0

end

function Grid:update(dt)
    if self:isBeaten() then return end

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

function Grid:draw()
    local outerCanvas = love.graphics.getCanvas()
    local canvas = love.graphics.newCanvas(unpack(self:getDiagonalVec():getXY()))
    love.graphics.setCanvas(canvas)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.image, 0, 0)

    if self:isBeaten() then
        love.graphics.setColor(1,1,1,self.fadeInAlpha)
        love.graphics.rectangle(
            "fill",
            0, 0, self:getWidth(), self:getHeight()
        )
        love.graphics.setColor(0,0,0,1)
        love.graphics.rectangle(
            "fill",
            unpack(self:getPixelDrawBox())
        )
    else
        if self.fadeInAlpha then
            love.graphics.setColor(1,1,1,self.fadeInAlpha)
            love.graphics.rectangle(
                "fill",
                0, 0, self:getWidth(), self:getHeight()
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

    love.graphics.setColor(1,1,1,1)
    love.graphics.setCanvas(outerCanvas)
    love.graphics.draw(canvas, unpack(self.topLeft:getXY()))
end

function Grid:onMousedown() end

function Grid:onMouseUp(mousePoint)
    if self:pixelContains(mousePoint) then
        self.beaten = true
        love.mouse.setCursor()
    end
end

--------------------------
-- UI methods
--------------------------

function Grid:handleGainedParent()
    print(self.parent:toString())
    local scale = scaleFactor(self.gridSize, self.parent:getDiagonalVec())
    self.bottomRight = self.bottomRight * scale
    self:centreIn(self.parent)
    -- (We can't do this until we know how big the parent is!)
    -- Get an image, then shrink it down to our grid size. That's imageScale
    local image = getAnImage()
    local imageVec = geo.Vec(image:getPixelWidth(), image:getPixelHeight())
    local imageScale = 1/scaleFactor(self.gridSize, imageVec)

    -- When scaled the image will be bigger in one direction. Canvas is the
    -- right pixel size; imageOffset will be negative, so the canvas chops a
    -- window out of the middle of the image
    local canvas = love.graphics.newCanvas(self:getWidth(), self:getHeight())
    local imageOffset = (self.gridSize - (imageVec * imageScale)) / 2

    love.graphics.setColor(1,1,1,1)
    love.graphics.setCanvas(canvas)
    love.graphics.draw(image, imageOffset:getX(), imageOffset:getY(), 0, imageScale)

    -- bigCanvas is the drawable one. It's the same size as Level, so we can use
    -- the existing scale to go from small canvas -> big canvas
    local bigCanvas = love.graphics.newCanvas(
        self:getWidth(), self:getHeight()
    )

    love.graphics.setCanvas(bigCanvas)
    canvas:setFilter('nearest', 'nearest')
    love.graphics.draw(canvas, 0, 0, 0, scale)
    love.graphics.setCanvas()

    self.image = bigCanvas
end

--------------------------
-- Grid methods
--------------------------

function Grid:fadeToWhite(alphaStep)
    if self.fadeInAlpha < 0.8 then
        self.fadeInAlpha = self.fadeInAlpha + alphaStep
    end
    if self.fadeInAlpha > 0.8 then
        self.fadeInAlpha = 0.8
    end
end

function Grid:fadeToColour(alphaStep)
    if self.fadeInAlpha >= 0 then
        self.fadeInAlpha = self.fadeInAlpha - alphaStep
    end
    if self.fadeInAlpha < 0 then
        self.fadeInAlpha = 0
    end
end

function Grid:isBeaten()
    return self.beaten
end

function Grid:pixelContains(mousePoint)
    local pointedAt = self:getGridPixelContaining(mousePoint)
    if not pointedAt then return false end
    return pointedAt:equals(self.pixel)
end

function Grid:getGridPixelContaining(vec)
    vec = vec - self.parent:getScreenOffset()
    local x = vec:getX() - self.topLeft:getX()
    local y = vec:getY() - self.topLeft:getY()
    local scale = scaleFactor(self.gridSize, self:getDiagonalVec())

    local gridX = math.floor(x / scale)
    local gridY = math.floor(y / scale)

    if gridX < 0
    or gridY < 0
    or gridX >= self.gridSize:getX()
    or gridY >= self.gridSize:getY()
        then
            return nil
        end

    return geo.Vec(gridX, gridY)
end

function Grid:getPixelDrawBox(px)
    if px == nil then
        px = self.pixel
    end

    return self:getPixelRect(px):asXYHW()
end

function Grid:getPixelRect(px)
    local scale = scaleFactor(self.gridSize, self:getDiagonalVec())
    local drawPixel = px * scale
    drawPixel = geo.Rect(
        drawPixel:getX(), drawPixel:getY(),
        drawPixel:getX() + scale, drawPixel:getY() + scale
    )
    return drawPixel
end

function Grid:toString()
    return (
"Rect:   " .. tostring(self.gridSize) .. "\n" ..
"Pixel:  " .. tostring(self.pixel) .. "\n" ..
"Draw:   " .. Level.super.toString(self)
)
end

function Grid.__tostring(level)
    return level:toString()
end


return Grid
