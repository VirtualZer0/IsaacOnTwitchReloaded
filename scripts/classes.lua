-- Classes
local classes = {}

-- Event class
classes.ActiveEvent = {}
function classes.ActiveEvent:new (event, name)
  local obj= {}
  obj.name = name                          -- Event name for dynamic callbacks
  obj.event = event                        -- Original event link
  obj.currentTime = event.duration or 0    -- Event countdown
  
  setmetatable(obj, self)
  self.__index = self
  return obj
end


-- Subscriber class
classes.Subscriber = {}
function classes.Subscriber:new (entity, name, time, color)
  local obj= {}
  obj.entity = entity -- Linked entity
  obj.name = name     -- Sub nickname
  obj.time = time     -- Time to disappear
  obj.color = color   -- Sub color
  
  setmetatable(obj, self)
  self.__index = self
  return obj
end

return classes