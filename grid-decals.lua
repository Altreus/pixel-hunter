local ui = require 'ui'
local geo = require 'geometry'
local GridDecals = ui.Image:extends()

-- We know the size of this because we add it to the Grid when the Grid knows
-- its size
function GridDecals:new(w,h,pixelSize,pixelPos)
    local buf = love.graphics.newCanvas(w,h)
    GridDecals.super.new(self, buf, 0, 0)
    self.pixelSize = pixelSize
    self.pixelPos = pixelPos
    self.fadeInAlpha = 0

    -- Leave space for the target box to go outside the image itself
    -- If this goes outside the level itself, the level's canvas will cut it off
    --self:translate(geo.Vec(-2, 0))
    --self.bottomRight = self.bottomRight + geo.Vec(4,0)
end

function GridDecals:fadeIn(dt)
    local alphaStep = 0.8*dt*2
    if self.fadeInAlpha < 0.8 then
        self.fadeInAlpha = self.fadeInAlpha + alphaStep
    end
    if self.fadeInAlpha > 0.8 then
        self.fadeInAlpha = 0.8
    end
end

function GridDecals:fadeOut(dt)
    local alphaStep = 0.8*dt*2
    if self.fadeInAlpha >= 0 then
        self.fadeInAlpha = self.fadeInAlpha - alphaStep
    end
    if self.fadeInAlpha < 0 then
        self.fadeInAlpha = 0
    end
end

function GridDecals:update(dt)
    local mousePoint = geo.Vec(love.mouse.getX(), love.mouse.getY())
    local mousePointRel = mousePoint - self.parent:getScreenOffset()
    self.found = self.found or love.keyboard.isDown('p')

    if self.found then
        self:fadeIn(dt)
    else
        self:fadeOut(dt)
    end

    self.buf:renderTo( function()
        love.graphics.clear()

        -- Always want to clear it - so we can't do this earlier
        if not self:contains(mousePointRel) then return end
        local gridPixel = self:pointToGridCoords(mousePointRel)

        if self.fadeInAlpha then
            love.graphics.setColor(1,1,1,self.fadeInAlpha)
            love.graphics.rectangle(
                "fill",
                0, 0, self:getWidth(), self:getHeight()
            )
        end

        if self.found or love.keyboard.isDown('p') then
            local pixelVec = self:pointToGridCoords(self.pixelPos)
            love.graphics.setColor(0,0,0,1)
            love.graphics.rectangle(
                "fill",
                gridPixel:getX(), gridPixel:getY(),
                self.pixelSize, self.pixelSize
            )
        end

        love.graphics.setColor(1, .2, .2, 1)
        love.graphics.setLineWidth(8)
        love.graphics.rectangle('line', gridPixel:getX(), gridPixel:getY(),
            self.pixelSize, self.pixelSize)

        if __DEBUG__ then
            love.graphics.setColor(unpack(self.__colour__))
            love.graphics.setLineWidth(1)
            love.graphics.rectangle('line', 0, 0, self:getWidth(), self:getHeight())
        end
    end)
end

function GridDecals:setFound()
    self.found = true
end

function GridDecals:setNotFound()
    self.found = false
end

-- Don't call this if the object doesn't contain mousePoint or you'll get
-- nonsense results
function GridDecals:pointToGridCoords(mousePoint)
    local gridX = math.floor(mousePoint:getX() / self.pixelSize) * self.pixelSize
    local gridY = math.floor(mousePoint:getY() / self.pixelSize) * self.pixelSize

    return geo.Vec(gridX, gridY)
end

return GridDecals
