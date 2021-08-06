local geo = require 'geometry'
local ui = require 'ui'
local NextLevel = ui.Pane:extends()

function NextLevel:new()
    local nextButton = ui.Button(love.graphics.newImage('img/next-level.png'))
    nextButton:setDrawDirect()
    NextLevel.super.new(self, unpack(nextButton:asXYHW()))

    self.__name__ = "Next Level"
    self:hide()

    self:addItem(nextButton, 'nextbutton')

    local font = love.graphics.newFont()
    local scoreTitle = ui.Text('font/UbuntuMono-R.ttf', 40, "Score")
    local score = ui.Text('font/UbuntuMono-R.ttf', 40, "0")

    self:addItem(scoreTitle, 'scoretitle')
    self:addItem(score, 'score')

    scoreTitle:centreIn(self)
    score:centreIn(self)

    scoreTitle:translate(geo.Vec(0, nextButton:getHeight() + 10))
    score:translate(geo.Vec(0, nextButton:getHeight() + 10 + scoreTitle:getHeight() + 10))

    local bBox = self:getBoundingBox()
    self:resize(bBox:getX(), bBox:getY() + 20)
end

function NextLevel:show(score)
    local item = self:getItem('score')
    item:setText(score)
    item:refit()

    local top = item.topLeft():getY()
    NextLevel.super.show(self)
end

function NextLevel:doDraw()
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle('fill', 0, 0, self:getWidth(), self:getHeight())
    NextLevel.super.doDraw(self)
end

return NextLevel

