local setCursor = require 'ui.cursor'
local Image = require 'ui.image'
local Button = Image:extends()

function Button:onMouseOut(mousePoint)
    __D("Mouse out " .. self.__localname__)
    setCursor()
    Button.super.onMouseOut(self, mousePoint)
end

function Button:onMouseOver(mousePoint)
    __D("Mouse over " .. self.__localname__)
    if not self:isVisible() then
        __D("... but invisible")
        return
    end

    local cursor = love.mouse.getSystemCursor('hand')
    setCursor(cursor)
    Button.super.onMouseOver(self, mousePoint)
end

function Button:contains(vec)
    if not self:isVisible() then
        return false
    end

    return Button.super.contains(self,vec)
end

return Button
