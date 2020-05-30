local Pane = require 'ui/pane'
local Button = require "ui/button"
local NextLevel = Pane:extends()

function NextLevel:new()
    local nextButton = Button(love.graphics.newImage('img/next-level.png'))
    NextLevel.super.new(self, unpack(nextButton:asXYHW()))

    self:addItem(nextButton, 'nextbutton')
    self:hide()

    self:fitToSize()
end

function NextLevel:doDraw()
    love.graphics.setColor(0,0,0,1)
    local asfsdf = self:asXYHW()
    love.graphics.rectangle('fill', 0, 0, self:getWidth(), self:getHeight())
    NextLevel.super.doDraw(self)
end

return NextLevel

