ITMR = RegisterMod("TwitchModReloaded", 1)

require('mobdebug').start()

-- Creating subobjects
ITMR.Server = require('scripts.server') -- ITMR Server
ITMR.Callbacks = require('scripts.callbacks') -- Callbacks
ITMR.Classes = require('scripts.classes') -- Classes
ITMR.Enums = require('scripts.enums') -- Enumerations
ITMR.Cmd = require('scripts.cmd') -- Command line handler
ITMR._ = require('scripts.helper') -- Helper functions

-- Items
ITMR.Items = {
  Active = require('scripts.activeItems'), -- Active items
  Passive = require('scripts.passiveItems'), -- Passive items
}

-- Settings
ITMR.Settings = {
  viewers = 0,
  textpos = {
    l1 = {x = 16, y = 241},
    l2 = {x = 16, y = 259}
  },
  subtime = 10*60*30,
  gift = nil
}

-- Current game storage
ITMR.Storage = {
 
  Subscribers = {},
  Familiars = {},
  
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
  
}

-- Dynamic callbacks storage
ITMR.DynamicCallbacks = {
  onUpdate = {},
  onCacheUpdate = {},
  onEntityUpdate = {},
  onRoomChange = {},
  onTearUpdate = {},
  onDamage = {},
  onNPCDeath = {},
  onStageChange = {},
}

----------- Bind server handlers ---------------

-- Change text on screen
ITMR.Server:setHandler("text", function (req) 
  
end)

-- Change text position
ITMR.Server:setHandler("textpos", function (req) 
  
end)

-- Give personal trinket
ITMR.Server:setHandler("gift", function (req) 
  
end)

-- Set subscribers remove time
ITMR.Server:setHandler("subtime", function (req) 
  
end)

-- Set tables for external item description mod
if not __eidItemDescriptions then
  __eidItemDescriptions = {};
end


-- Bind callbacks and descriptions for active items
for key,value in pairs(ITMR.Items.Active) do
  ITMR:AddCallback(ModCallbacks.MC_USE_ITEM, ITMR.Items.Active[key].onActivate, ITMR.Items.Active[key].id);
  
  __eidItemDescriptions[ITMR.Items.Active[key].id] = ITMR.Items.Active[key].description .. 
  "#\3 From Isaac On Twitch";
end
 

-- Adding function for bind/unbind items callbacks. This system using for less unusable conditions on postUpdate.

-- Bind callbacks
function ITMR.DynamicCallbacks.bind (from, key)
  
  Isaac.ConsoleOutput("ITMR: Added new dynamic callbacks for "..key.."\n")
  
  for callbackName, callbackValue in pairs(ITMR.DynamicCallbacks) do
    if (type(callbackValue) ~= "function") then
      if (from[key][callbackName] ~= nil and callbackValue[key] == nil) then
        callbackValue[key] = from[key][callbackName]
      end
    end
  end
end

-- Unbind callbacks
function ITMR.DynamicCallbacks.unbind (from, key)
  
  Isaac.ConsoleOutput("ITMR: Remove dynamic callbacks for "..key.."\n")
  
  for callbackName, callbackValue in pairs(ITMR.DynamicCallbacks) do
    if (type(callbackValue) ~= "function") then
      if (callbackValue[key] ~= nil) then
        callbackValue[key] = nil
      end
    end
  end
end



-- Bind pickup/remove callbacks and descriptions for passive items
for key,value in pairs(ITMR.Items.Passive) do
  
  
  -- Add item pickup|remove callbacks
  local pickupRemoveCheck = function ()
    
    -- Check item pickup
    if (Isaac.GetPlayer(0):GetCollectibleNum(ITMR.Items.Passive[key].id) > ITMR.Items.Passive[key].count) then
      
      -- Increase item counter
      ITMR.Items.Passive[key].count = ITMR.Items.Passive[key].count + 1
      
      -- Adding dynamic callback
      if (Isaac.GetPlayer(0):GetCollectibleNum(ITMR.Items.Passive[key].id) > 0) then ITMR.DynamicCallbacks.bind(ITMR.Items.Passive, key) end
      
      -- Call onPickup callback
      if ITMR.Items.Passive[key].onPickup ~= nil then ITMR.Items.Passive[key].onPickup() end
      
      -- Update cache if need
      if ITMR.Items.Passive[key].cacheFlag ~= nil then
        local player = Isaac.GetPlayer(0)
        player:AddCacheFlags(ITMR.Items.Passive[key].cacheFlag)
        player:EvaluateItems()
      end
      
    -- Check item remove
    elseif (Isaac.GetPlayer(0):GetCollectibleNum(ITMR.Items.Passive[key].id) < ITMR.Items.Passive[key].count) then
      -- Decrease item counter
      ITMR.Items.Passive[key].count = ITMR.Items.Passive[key].count - 1
      
      -- Remove dynamic callbacks
      if (Isaac.GetPlayer(0):GetCollectibleNum(ITMR.Items.Passive[key].id) == 0) then ITMR.DynamicCallbacks.unbind(ITMR.Items.Passive, key) end
      
      -- Call onRemove callback
      if ITMR.Items.Passive[key].onRemove ~= nil then ITMR.Items.Passive[key].onRemove() end
    end
    
  end
    
  ITMR:AddCallback(ModCallbacks.MC_POST_UPDATE, pickupRemoveCheck);
  
  -- Add External Item Description support
  __eidItemDescriptions[ITMR.Items.Passive[key].id] = ITMR.Items.Passive[key].description .. 
  "#\3 From Isaac On Twitch";
end



-- Bind callbacks
ITMR:AddCallback(ModCallbacks.MC_EXECUTE_CMD, ITMR.Cmd.main)
ITMR:AddCallback(ModCallbacks.MC_POST_UPDATE, ITMR.Callbacks.postUpdate)
ITMR:AddCallback(ModCallbacks.MC_POST_RENDER, ITMR.Callbacks.postRender)
ITMR:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ITMR.Callbacks.evaluateCache)
ITMR:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, ITMR.Callbacks.postGameStarted)
ITMR:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, ITMR.Callbacks.preGameExit)
ITMR:AddCallback(ModCallbacks.MC_POST_GAME_END, ITMR.Callbacks.postGameEnd)

-- Set dynamic callbacks

-- onUpdate Callback
ITMR:AddCallback(ModCallbacks.MC_POST_UPDATE, 
  function ()
    for key,value in pairs(ITMR.DynamicCallbacks.onUpdate) do
      value()
    end
  end
)

-- onCacheUpdate Callback
ITMR:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, 
  function (obj, player, cacheFlag)
    for key,value in pairs(ITMR.DynamicCallbacks.onCacheUpdate) do
      value(obj, player, cacheFlag)
    end
  end
)

-- onEntityUpdate Callback
ITMR:AddCallback(ModCallbacks.MC_POST_UPDATE, 
  function ()
    local entities = Isaac.GetRoomEntities()
    
    for entityKey, entity in pairs(entities) do
      for key,value in pairs(ITMR.DynamicCallbacks.onEntityUpdate) do
        value(entity)
      end
    end
  end
)

-- onRoomChange Callback
ITMR:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, 
  function ()
    for key,value in pairs(ITMR.DynamicCallbacks.onRoomChange) do
      value()
    end
  end
)

-- onTearUpdate Callback
ITMR:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, 
  function (obj, e)
    for key,value in pairs(ITMR.DynamicCallbacks.onTearUpdate) do
      value(obj, e)
    end
  end
)

-- onDamage Callback
ITMR:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, 
  function (obj, p, damageAmnt, damageFlag, damageSource, damageCountdown)
    for key,value in pairs(ITMR.DynamicCallbacks.onDamage) do
      value(obj, p, damageAmnt, damageFlag, damageSource, damageCountdown)
    end
  end, EntityType.ENTITY_PLAYER
)

-- onNPCDeath Callback
ITMR:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, 
  function (obj, e)
    for key,value in pairs(ITMR.DynamicCallbacks.onNPCDeath) do
      value(obj, e)
    end
  end
)

-- onStageChange Callback
ITMR:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, 
  function ()
    for key,value in pairs(ITMR.DynamicCallbacks.onStageChange) do
      value()
    end
  end
)