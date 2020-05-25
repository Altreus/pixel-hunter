local ui = require 'ui'
local GridDecals = ui.Pane:extends()

-- We know the size of this because we add it to the Grid when the Grid knows
-- its size
function GridDecals:new(w,h,pixelSize)
    GridDecals.super.new(self, w, h)
    self.pixelSize = pixelSize

    local outerCanvas = love.graphics.getCanvas()
    local background = love.graphics.newCanvas(self:getWidth(), self:getHeight())
    self:addItem(ui.Image(background), 'background')

    local target = love.graphics.newCanvas(pixelSize, pixelSize)
    love.graphics.setCanvas(target)
    love.graphics.setColor(1, .2, .2, 1)
    love.graphics.setLineWidth(4)
    love.graphics.rectangle('line', 0, 0, pixelSize, pixelSize)
    self:addItem(ui.Image(target), 'target')

    local pixel = love.graphics.newCanvas(pixelSize, pixelSize)
    love.graphics.setCanvas(pixel)
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle('fill', 0, 0, pixelSize, pixelSize)
    self:addItem(ui.Image(pixel), 'pixel')

    self:getItem('pixel'):hide()
    love.graphics.setCanvas(outerCanvas)
end

function GridDecals:update(dt)
    local mousePoint = geo.Vec(love.mouse.getX(), love.mouse.getY())
    local mousePointRel = mousePoint - self:getScreenOffset()

    if not self:contains(mousePointRel) then return end

    local gridPix = self:mousePointToGridCoords(mousePointRel)
    self:getItem('target'):translateTo(gridPix)
end

-- Don't call this if the object doesn't contain mousePoint or you'll get
-- nonsense results
function mousePointToGridCoords(mousePoint)
    local gridX = math.floor(mousePoint:getX() / self.pixelSize) * pixelSize
    local gridY = math.floor(mousePoint:getY() / self.pixelSize) * pixelSize

    return geo.Vec(gridX, gridY)
end

return GridDecals
