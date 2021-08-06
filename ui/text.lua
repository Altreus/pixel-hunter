local Image = require 'ui.image'
local Text = Image:extends()

function Text:new(font, size, text, colour)
    self.font = love.graphics.newFont(font, size)
    self.text = love.graphics.newText(self.font, text)
    Text.super.new(self, self.text)

    -- Drawable gives us self.colour
    self.colour = colour or self.colour
end

function Text:setFont(font, size)
    self.font = love.graphics.newFont(font, size)
    self.text:setFont(self.font)
end

function Text:setText(text)
    self.text:set(text)
end

function Text:refit()
    self:resize(self.buf:getWidth(), self.buf:getHeight())
end

return Text
