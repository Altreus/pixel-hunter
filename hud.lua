local geo = require "geometry"
local Class = require "class"
local HUD = geo.Rect:extends()

function HUD:new()
    local timerFont = love.graphics.newFont('font/UbuntuMono-R.ttf', 40)
    -- Have to have 5 chars here so it knows how wide the HUD is
    self.timerText = love.graphics.newText(timerFont, "00:00")
    self.timer = 30

    HUD.super.new(
        self,
        0,0,
        self.timerText:getWidth() + 20,
        love.graphics.getHeight()
    )
    self:update(0)
    self.level = 1
    self.isPaused = false
end

function HUD:timeUp()
    return self.timer <= 0
end

function HUD:pause()
    self.isPaused = true
end

function HUD:unpause()
    self.isPaused = false
end

function HUD:update(dt)
    if self.isPaused then return end

    self.timer = self.timer - dt
    local seconds = math.ceil(self.timer)
    local minutes = math.floor(seconds / 60)
    seconds = seconds % 60

    local text = string.format("%02d:%02d", minutes, seconds)
    self.timerText:set(text)
end

function HUD:draw()
    local drawBox = self:asXYHW()

    -- It renders as 10 when it's between 10 and 11. This is not the same as
    -- <= 10 because it's a float
    if self.timer < 11 then
        -- TODO fix these colours
        if self.timer % 1 < 0.5 then
            love.graphics.setColor(1,0.9,0.1)
        else
            love.graphics.setColor(1,0.2,0.2)
        end
    else
        love.graphics.setColor(1,1,1)
    end
    love.graphics.draw(self.timerText, drawBox[1]+10, 10)

    love.graphics.setColor(1,1,1,1)
    love.graphics.print(
        "Level " .. self.level,
        10,
        drawBox[1] + 10 + self.timerText:getHeight() + 10
    )
end

return HUD
