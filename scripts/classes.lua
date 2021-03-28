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
function classes.Subscriber:new (entity, name, time, color, texture)
  local obj= {}
  obj.entity = entity   -- Linked entity
  obj.name = name       -- Sub nickname
  obj.time = time       -- Time to disappear
  obj.color = color     -- Sub color
  obj.texture = texture -- Subscriber texture
  
  setmetatable(obj, self)
  self.__index = self
  return obj
end


-- Storage class
classes.Storage = {}

function classes.Storage:new ()
  local obj= {
    Subscribers = {},   -- Current subscribers
    Familiars = {},     -- Current familiars
    ActiveEvents = {},  -- Current events
    
    Stats = {
      speed = 0,
      range = 0,
      tears = 0,
      tearspeed = 0,
      damage = 0,
      luck = 0
    },
    
    Hearts = {
      twitch = 0,
      rainbow = 0
    },
    
    Bits = {
      gray = 0,
      purple = 0,
      green = 0,
      blue = 0,
      red = 0
    },
    
    Special = {
      twitchRoomId = nil
    }
  }
  
  setmetatable(obj, self)
  self.__index = self
  return obj
end

-- Twitch room itempool class
classes.TwitchRoomPool = {}

function classes.TwitchRoomPool:new ()
  
  local obj = {
    items = {}
  }
  
  -- Load items into pool
  for key,value in pairs(IOTR.Items.Active) do
    if (value.devOnly == nil or value.devOnly == false) then
      table.insert(obj.items, value.id)
    end
  end
  
  for key,value in pairs(IOTR.Items.Passive) do
    if (value.devOnly == nil or value.devOnly == false) then
      table.insert(obj.items, value.id)
    end
  end
  
  setmetatable(obj, self)
  self.__index = self
  return obj
  
end

-- Dynamic callbacks storage class
classes.DynamicCallbacks = {}

function classes.DynamicCallbacks:new ()
  local obj= {
    onUpdate = {},
    onRenderUpdate = {},
    onCacheUpdate = {},
    onEntityUpdate = {},
    onRoomChange = {},
    onNewRoom = {},
    onTearUpdate = {},
    onTearInit = {},
    onProjectileUpdate = {},
    onDamage = {},
    onNPCInit = {},
    onNPCDeath = {},
    onStageChange = {},
    onPickupCollision = {},
    onFamiliarInit = {},
    onFamiliarCollision = {},
    onFamiliarUpdate = {},
    
    bind = function (from, key)
      Isaac.ConsoleOutput("IOTR: Added new dynamic callbacks for "..key.."\n")
      
      for callbackName, callbackValue in pairs(IOTR.DynamicCallbacks) do
        if (type(callbackValue) ~= "function") then
          if (from[key][callbackName] ~= nil and callbackValue[key] == nil) then
            callbackValue[key] = from[key][callbackName]
          end
        end
      end
    end,
    
    unbind = function (from, key)
      Isaac.ConsoleOutput("IOTR: Remove dynamic callbacks for "..key.."\n")
      
      for callbackName, callbackValue in pairs(IOTR.DynamicCallbacks) do
        if (type(callbackValue) ~= "function") then
          if (callbackValue[key] ~= nil) then
            callbackValue[key] = nil
          end
        end
      end
    end
  }
  
  setmetatable(obj, self)
  self.__index = self
  return obj
end

return classes