local geo = require "geometry"
local Class = require "class"
local HUD = geo.Rect:extends()

function HUD:new()
    local timerFont = love.graphics.newFont('font/UbuntuMono-R.ttf', 40)
    self.timer = love.graphics.newText(timerFont, "00:00")

    HUD.super.new(
        self,
        0,0,
        self.timer:getWidth() + 20,
        love.graphics.getHeight()
    )
end

function HUD:draw()
    local drawBox = self:asXYHW()

    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.timer, drawBox[1]+10, 10)
end

return HUD
