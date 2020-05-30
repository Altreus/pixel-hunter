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
end

--------------------------
-- UI methods
--------------------------

function Grid:handleGainedParent()
    local scale = scaleFactor(self.gridSize, self.parent:getDiagonalVec())
    self.bottomRight = self.bottomRight * scale
    -- Drawable gives us a canvas but it didn't know how big. Now we know.
    self.canvas = love.graphics.newCanvas(self:getWidth(), self:getHeight())
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

    canvas:renderTo( function()
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(image, imageOffset:getX(), imageOffset:getY(), 0, imageScale)
    end)

    -- bigCanvas is the drawable one. It's the same size as Level, so we can use
    -- the existing scale to go from small canvas -> big canvas
    local bigCanvas = love.graphics.newCanvas(
        self:getWidth(), self:getHeight()
    )

    bigCanvas:renderTo( function()
        canvas:setFilter('nearest', 'nearest')
        love.graphics.draw(canvas, 0, 0, 0, scale)
    end)
    local decals = GridDecals(self:getWidth(), self:getHeight(), scale, self.pixel)
    decals.__name__ = "Decals"
    local button = ui.Button(love.graphics.newCanvas(scale,scale))
    button:translate(self.pixel * scale)
    button:addHandler('mouseup', function()
        self.beaten = true
        button:setIntangible()
    end)
    button:addHandler('mouseover', function()
        decals:setFound()
    end)
    button:addHandler('mouseout', function()
        if not self.beaten then
            decals:setNotFound()
        end
    end)
    local image = ui.Image(bigCanvas)
    image:setDrawDirect()
    button:setDrawDirect()
    decals:setDrawDirect()
    button.__name__ = 'pixelbutton'
    image.__name__ = 'pixelimage'

    self:addItem(image, 'image')
    self:addItem(button, 'pixel')
    self:addItem(decals, 'decals')
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
