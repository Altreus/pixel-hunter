require 'scaler'
local geo = require 'geometry'
local Drawable = require 'ui.drawable'
local ui = require 'ui'
local GridDecals = require 'grid-decals'

local Grid = ui.Pane:extends()

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
    self.__name__ = "Grid"
end

function Grid:update(dt)
    if self:isBeaten() then return end

    Grid.super.update(self,dt)

    local mousePoint = geo.Vec(love.mouse.getX(), love.mouse.getY())
    local alphaStep = 0.8*dt*2

    if love.keyboard.isDown('p') then
        self:fadeToWhite(alphaStep)
    end
end

function Grid:onMouseUp(mousePoint)
    if self:pixelContains(mousePoint) then
        self.beaten = true
        love.mouse.setCursor()
    end
end

--------------------------
-- UI methods
--------------------------

function Grid:doDraw()
    local outerCanvas = love.graphics.getCanvas()
    love.graphics.setColor(1,1,1,1)
    Grid.super.doDraw(self)

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
    end


    love.graphics.setColor(1,1,1,1)
end

function Grid:handleGainedParent()
    local parentCanvas = love.graphics.getCanvas()
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
    love.graphics.setCanvas(parentCanvas)

    self:addItem(ui.Image(bigCanvas), 'image')
    self:addItem(ui.Button(love.graphics.newCanvas(scale,scale)), 'pixel')
    self:addItem(
        GridDecals(self:getWidth(), self:getHeight(), scale, self.pixel),
        'decals'
    )
    self:getItem('decals').__name__ = "Decals"
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

return Grid
