local setCursor = require 'ui.cursor'
local Image = require 'ui.image'
local Button = Image:extends()

function Button:onMouseOut(mousePoint)
    setCursor()
end

function Button:onMouseOver(mousePoint)
    if not self:isVisible() then return end

    local cursor = love.mouse.getSystemCursor('hand')
    setCursor(cursor)
end

function Button:contains(vec)
    if not self:isVisible() then return false end

    return Button.super.contains(self,vec)
end

function Button:contains(point)
    if self.hidden then return false end
    return self.super.contains(self, point)
end

return Button
