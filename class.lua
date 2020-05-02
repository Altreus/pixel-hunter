local Class = {}
Class.__index = Class

-- initializer
function Class:new() end

function Class:extends()
  local cls = {}
  cls["__call"] = Class.__call
  cls.__index = cls
  cls.super = self
  setmetatable(cls, self)
  return cls
end

function Class:__call(...)
  local inst = setmetatable({}, self)
  inst:new(...)
  return inst
end

return Class
