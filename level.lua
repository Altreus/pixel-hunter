require('scaler')
local geo = require('geometry')
-- The Level rect is the drawable one. It is backed by a grid, which is simply
-- an XY grid size in a vector
local Level = geo.Rect:extends()

function makeGrid(difficulty)
    -- Basically, the grid should be approximately 10x10 at level 1, 11x11 at
    -- level 2, etc
    local gridSide = (10 + math.floor(difficulty/2))

    -- But we don't want it to be square so perturb one dimension
    local gridOtherSide = gridSide * (love.math.random(60,166) / 100)

    -- Now scale the original side to approximate the original total area
    gridSide = (gridSide ^ 2) / gridOtherSide

    return geo.Vec(
        math[ love.math.random(0,1) and "floor" or "ceil" ](gridSide),
        math[ love.math.random(0,1) and "floor" or "ceil" ](gridOtherSide)
    )
end

function getAnImage()
    local imageList = love.filesystem.getDirectoryItems('img/backgrounds')
    return love.graphics.newImage(
        'img/backgrounds/' .. imageList[love.math.random(#imageList)]
    )
end

function Level:new(params)
    self.difficulty = params.difficulty or 1

    assert(params.maxSize, "Must pass maxSize to Level()")

    self.fadeInAlpha = 0

    local grid = makeGrid(self.difficulty)

    if params.height then
        grid:setY(params.height)
    end
    if params.width then
        grid:setX(params.width)
    end

    self.pixel = geo.Vec(
        love.math.random(0, grid:getX() - 1),
        love.math.random(0, grid:getY() - 1)
    )

    local scale = scaleFactor(grid, params.maxSize)
    Level.super.new(self, grid:getX() * scale, grid:getY() * scale)
    self:centreIn(geo.Rect(params.maxSize:getX(), params.maxSize:getY()))
    self.grid = grid

    -- Get an image, then shrink it down to our grid size. That's imageScale
    local image = getAnImage()
    local imageVec = geo.Vec(image:getPixelWidth(), image:getPixelHeight())
    local imageScale = 1/scaleFactor(grid, imageVec)

    -- When scaled the image will be bigger in one direction. Canvas is the
    -- right pixel size; imageOffset will be negative, so the canvas chops a
    -- window out of the middle of the image
    local canvas = love.graphics.newCanvas( grid:getX(), grid:getY() )
    local imageOffset = (grid - (imageVec * imageScale)) / 2

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

function Level:pixelContains(vec)
    local pointedAt = self:getGridPixelContaining(vec)
    if not pointedAt then return false end
    return pointedAt:equals(self.pixel)
end

function Level:getGridPixelContaining(vec)
    local x = vec:getX() - self.topLeft:getX()
    local y = vec:getY() - self.topLeft:getY()
    local scale = scaleFactor(self.grid, self:getDiagonalVec())

    local gridX = math.floor(x / scale)
    local gridY = math.floor(y / scale)

    if gridX < 0
    or gridY < 0
    or gridX >= self.grid:getX()
    or gridY >= self.grid:getY()
        then
            return nil
        end

    return geo.Vec(gridX, gridY)
end

function Level:getPixelDrawBox(px)
    if px == nil then
        px = self.pixel
    end

    return self:getPixelRect(px):asXYHW()
end

function Level:getPixelRect(px)
    local scale = scaleFactor(self.grid, self:getDiagonalVec())
    local drawPixel = px * scale
    drawPixel = geo.Rect(
        drawPixel:getX(), drawPixel:getY(),
        drawPixel:getX() + scale, drawPixel:getY() + scale
    )
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
    local canvas = love.graphics.newCanvas(unpack(self:getDiagonalVec():getXY()))
    love.graphics.setCanvas(canvas)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.image, 0, 0)

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

    love.graphics.setCanvas()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(canvas, self.topLeft:getX(), self.topLeft:getY())
end

function Level:toString()
    return (
"Rect:   " .. tostring(self.grid) .. "\n" ..
"Pixel:  " .. tostring(self.pixel) .. "\n" ..
"Draw:   " .. Level.super.toString(self)
)
end

function Level.__tostring(level)
    return level:toString()
end

return Level
