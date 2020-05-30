-- Returns either the X ratio or the Y ratio of the two vectors, whichever is
-- smaller. Use this to determine how much to scale a rect in order to match
-- another one, by passing their diagonals as vectors.
function scaleFactor(vec1, vec2)
    local widthFactor = vec2:getX() / vec1:getX()
    local heightFactor = vec2:getY() / vec1:getY()

    return math.min(widthFactor, heightFactor)
end
