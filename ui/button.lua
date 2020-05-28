local setCursor = require 'ui.cursor'
local Image = require 'ui.image'
local Button = Image:extends()

function Button:new(...)
    Button.super.new(self, unpack({...}))
    self:addHandler('mouseover', function()
        setCursor(love.mouse.getSystemCursor('hand'))
    end)

    self:addHandler('mouseout', function()
        setCursor(nil)
    end)
end

function Button:contains(vec)
    if not self:isVisible() then
        return false
    end

    return Button.super.contains(self,vec)
end

return Button
