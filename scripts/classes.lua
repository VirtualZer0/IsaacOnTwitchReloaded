-- Classes
local classes = {}

-- Event class
classes.Event = {}
function classes.Event:new (duration, byTime, triggerByRoom, ontrigger, onover)
  local obj= {}
  obj.duration = duration -- Event duration
  obj.byTime = byTime -- TRUE - timer decreased every second
  obj.triggerByRoom = triggerByRoom -- TRUE - trigger call after room changing. FALSE -- trigger call every postUpdate
  obj.ontrigger = ontrigger -- Trigger function
  obj.onover = onover -- Called after event
  
  
  setmetatable(obj, self)
  self.__index = self; return obj
end


-- Subscriber class
classes.Subscriber = {}
function classes.Subscriber:new (entity, name, time, color)
  local obj= {}
  obj.entity = entity -- Linked entity
  obj.name = name -- Sub nickname
  obj.time = time -- Time to disappear
  obj.color = color -- Sub color
  
  setmetatable(obj, self)
  self.__index = self; return obj
end

return classes