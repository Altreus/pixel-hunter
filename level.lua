require('scaler')
local geo = require('geometry')
local Grid = require 'grid'
local Pane = require 'ui/pane'
-- The Level rect is the drawable one. It is backed by a grid, which is simply
-- an XY grid size in a vector
local Level = Pane:extends()

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
    Level.super.new(self, unpack(params.rect))

    self.difficulty = params.difficulty or 1

    self.__name__ = "Level"

    local grid = makeGrid(self.difficulty)

    if params.height then
        grid:setY(params.height)
    end
    if params.width then
        grid:setX(params.width)
    end

    self:addItem(Grid(grid), 'grid')
end

function Level:isBeaten()
    return self.items.grid:isBeaten()
end

return Level
