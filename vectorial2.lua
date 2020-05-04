--[[
   vectorial2.lua ver 0.2 - A library for 2D vectors.
   Copyright (C) 2015 Leo Tindall

   ---
    All operators work as expected except modulo (%) which is vector distance and concat (..) which is linear distance.
   ---

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software Foundation,
   Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
]]

local module = {}
      module.Vector2D = function (ix, iy)
    local v2d = {}
          v2d.v = {}
          v2d.v.x = ix
          v2d.v.y = iy
          mt ={} --Metatable

    function v2d:deepcopy(orig) --Deeply copy a table. This is for the operation metatables.
        local orig_type = type(orig)
        local copy
        if orig_type == 'table' then
            copy = {}
            for orig_key, orig_value in next, orig, nil do
                    copy[self:deepcopy(orig_key)] = self:deepcopy(orig_value)
            end
            setmetatable(copy, self:deepcopy(getmetatable(orig)))
        else -- number, string, boolean, etc
                copy = orig
        end
        return copy
    end

    --Vector Specific Math

    function v2d:getAngle() --Return the 2D angle of the vector IN RADIANS!.
        return math.atan2(self:getY(), self:getX())
    end

    function v2d:getLength()
        return math.sqrt((self:getX() ^ 2) + (self:getY() ^ 2))
    end

    function module.average (vectors)
        local n = #vectors
        local tmp = module.Vector2D(0, 0)
        local j = 1 --Position in new_vectors
        if n == 0 then
            error("average() called with 0 inputs!")
        end
        for i, vector in ipairs(vectors) do
            tmp = tmp + vector
        end
        return tmp / module.Vector2D(n, n):getLength()
    end

    --Comparisons

    mt.__eq = function(lhs, rhs)
        --Equal To operator for vector2Ds. Compares values precisely
        return (lhs:getX() == rhs:getX()) and (lhs:getY() == rhs:getY())
    end

    mt.__lt = function(lhs, rhs)
        --Less Than operator for vector2Ds. Compares lengths.
        return lhs:getLength() < rhs:getLength()
    end

    mt.__le = function(lhs, rhs)
        --Less Than Or Equal To operator for vector2Ds. Compares lengths.
        return lhs:getLength() <= rhs:getLength()
    end

    --Operations

    function v2d:setX(x)
        self.v.x = x
    end

    function v2d:setY(y)
        self.v.y = y
    end

    function v2d:getX()
        return self.v.x
    end

    function v2d:getY()
        return self.v.y
    end

    mt.__unm = function(rhs)
        --Unary Minus (negation) operator for Vector2Ds
        local out = rhs:deepcopy(rhs)
        out:setX(-rhs:getX())
        out:setY(-rhs:getY())
        return out
    end

    mt.__add = function(lhs, rhs)
        --Addition operator for Vector2Ds
        local out = lhs:deepcopy(lhs)
        out:setX(lhs:getX() + rhs:getX())
        out:setY(lhs:getY() + rhs:getY())
        return out
    end

    mt.__sub = function(lhs, rhs)
        --Subtraction operator for Vector2Ds
        local out = lhs:deepcopy(lhs)
        out:setX(lhs:getX() - rhs:getX())
        out:setY(lhs:getY() - rhs:getY())
        return out
    end

    mt.__mul = function(lhs, k)
        -- "Multiplying" vectors is silly. Use dot product or cross product.
        -- This returns a scaled copy.
        local out = lhs:deepcopy(lhs)
        out:setX(lhs:getX() * k)
        out:setY(lhs:getY() * k)
        return out
    end

    mt.__div = function(lhs, k)
        -- You can't divide two vectors. This returns a scaled copy.
        local out = lhs:deepcopy(lhs)
        out:setX(lhs:getX() / k)
        out:setY(lhs:getY() / k)
        return out
    end

    mt.__mod = function(lhs, rhs)
        --Vector distance operator for Vector2Ds. Denoted by modulo (%)
        local out = lhs:deepcopy(lhs)
        out:setX(math.abs(rhs:getX() - lhs:getX()))
        out:setY(math.abs(rhs:getY() - lhs:getY()))
        return out
    end

    mt.__concat = function(lhs, rhs)
        --Linear distance operator for Vector2Ds. Denoted by concat (..)
        return lhs:getLength() + rhs:getLength()
    end

    function v2d:toString()
        return "[(X:"..self:getX().."),(Y:"..self:getY()..")]"
    end

    mt.__tostring = function(self)
        return self:toString()
    end

    setmetatable(v2d, mt)

    return v2d
end
return module
