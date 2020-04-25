ITMR = RegisterMod("TwitchModReloaded", 1)

require('mobdebug').start()
local json = require('json')

-- Creating subobjects
ITMR.Server = require('scripts.server')       -- ITMR Server
ITMR.Callbacks = require('scripts.callbacks') -- Callbacks
ITMR.Classes = require('scripts.classes')     -- Classes
ITMR.Enums = require('scripts.enums')         -- Enumerations
ITMR.Cmd = require('scripts.cmd')             -- Command line handler
ITMR.Sprites = require('scripts.sprites')     -- Sprites
ITMR.Shaders = require('scripts.shaders')     -- Shaders
ITMR.Events = require('scripts.events')       -- Events
ITMR._ = require('scripts.helper')            -- Helper functions

-- Items
ITMR.Items = {
  Active = require('scripts.activeItems'),    -- Active items
  Passive = require('scripts.passiveItems'),  -- Passive items
  Trinkets = require('scripts.trinkets'),     -- Trinkets
}

-- Settings
ITMR.Settings = {
  viewers = 0,              -- Viewers count
  textpos = {
    l1 = {X = 16, Y = 220}, -- Firstline text position
    l2 = {X = 16, Y = 235}  -- Secondline text position
  },
  subtime = 10*60*30,       -- Time to life for subscribers
  gift = nil                -- Gift trinket for streamer
}

-- Current game session storage
ITMR.Storage = {
 
  Subscribers = {}, -- Current subscribers
  Familiars = {},   -- Current familiars
  ActiveEvents = {},-- Current events
  
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

-- Additional game state
ITMR.GameState = {
  renderSpecial = true
}

-- Dynamic callbacks storage
ITMR.DynamicCallbacks = {
  onUpdate = {},
  onCacheUpdate = {},
  onEntityUpdate = {},
  onRoomChange = {},
  onTearUpdate = {},
  onProjectileUpdate = {},
  onDamage = {},
  onNPCDeath = {},
  onStageChange = {},
}

----------- Timers system ---------------
ITMR.Timers = {
  
  Storage = {}, -- Current timers
  _timerId = 1,
  
  addTimeout = function (func, interval)
    
    local timerId = ITMR.Timers._timerId
    ITMR.Timers._timerId = ITMR.Timers._timerId + 1
    
    table.insert(ITMR.Timers.Storage, {
      id = timerId,
      func = func,
      interval = interval,
      currentInterval = interval,
      repeats = 1
    })
  
    return timerId
    
  end,
  
  addInterval = function (func, interval, repeats)
    
    local timerId = ITMR.Timers._timerId
    ITMR.Timers._timerId = ITMR.Timers._timerId + 1
    
    if (repeats == nil) then repeats = -1 end
    
    table.insert(ITMR.Timers.Storage, {
      id = timerId,
      func = func,
      interval = interval,
      currentInterval = interval,
      repeats = repeats
    })
  
    return timerId
    
  end,
  
  stop = function (id)
    for key, timer in pairs(ITMR.Timers.Storage) do
      if timer.id == id then ITMR.Timers.Storage[key] = nil end
    end
  end,
  
  tick = function ()
    for key, timer in pairs(ITMR.Timers.Storage) do
      timer.currentInterval = timer.currentInterval - 1
      
      if timer.currentInterval == 0 then
        timer.repeats = timer.repeats - 1
        timer.currentInterval = timer.interval
        timer.func()
      end
      
      if timer.repeats == 0 then
        ITMR.Timers.Storage[key] = null
      end
    end
  end
  
}

----------- Text Rendering ---------------

ITMR.Text = {
  
  Storage = {},       -- Current texts for render
  FollowStorage = {}, -- Entities for binding text position
  
  -- Add new text to render
  add = function (name, text, pos, color, size, isCenter)
    -- Too lazy for writing this every time
    if (pos == nil) then pos = ITMR.Settings.textpos.l2 end
    if (color == nil) then color = {r = 1, g = 1, b = 1, a = 1} end
    if (size == nil) then size = 1.5 end
    if (isCenter == nil) then isCenter = false end
    
    -- If text is not array, make array
    if (type(text) == "string") then text = {text} end
    
    -- Split text on strings
    local strings = {}
    local line = 1
    
    for ns, s in pairs(text) do
      
      -- Replace symbols if it's needed
      s = ITMR._.fixtext(s)
      
      local sx = pos.X
      
      if (isCenter) then
        sx = pos.X - Isaac.GetTextWidth(s)/2*size
      end
      
      table.insert(strings, {
        text = s,
        x = sx,
        y = pos.Y + (line * size * 10)
      })
      
      line = line +1
    end
    
    ITMR.Text.Storage[name] = {
      text = strings,
      isCenter = isCenter,
      color = color,
      size = size
    }
  end,
  
  -- Bind text to entity position
  follow = function (name, entity)
    ITMR.Text.FollowStorage[name] = {
      entity = entity
    }
  end,
  
  -- Remove text
  remove = function (name)
    ITMR.Text.Storage[name] = nil
    ITMR.Text.FollowStorage[name] = nil
  end,
  
  -- Render all current texts
  render = function ()
    
    -- Check if render not allowed
    if (ITMR.GameState.renderSpecial == false) then return end
    
    for name, text in pairs(ITMR.Text.Storage) do
      
      -- Check if the text bind to entity
      if (ITMR.Text.FollowStorage[name] ~= nil) then
        
        -- If entity not exists anymore
        if (ITMR.Text.FollowStorage[name].entity:Exists() ~= true) then 
          
          -- then remove text
          ITMR.Text.remove(name)
          
        else
          
          -- else change text position to entity position
          for snum, stext in pairs(text.text) do
            local epos = Isaac.WorldToRenderPosition(ITMR.Text.FollowStorage[name].entity.Position, true) + Game():GetRoom():GetRenderScrollOffset()
            stext.x = epos.X-3 * #stext.text
            stext.y = epos.Y - 40 - (snum * text.size * 10)
          end
          
        end
      end
      
      for snum, stext in pairs(text.text) do
        
        Isaac.RenderScaledText(stext.text, stext.x, stext.y, text.size, text.size, text.color.r, text.color.g, text.color.b, text.color.a)
        
      end
    end
  end
}

----------- Progress Bar Rendering ---------------

ITMR.ProgressBar = {
  
  -- Progress bar parameters
  Storage = {
    visible = false,
    updated = true,
    cropX = 0,
    min = 0,
    max = 100,
    value = 50
  },
  
  -- Create progress bar
  create = function (title, min, max, value, signs)
    -- 1% = 2.6px
    ITMR.ProgressBar.Storage.visible = true
    ITMR.ProgressBar.Storage.min = min
    ITMR.ProgressBar.Storage.max = max
    ITMR.ProgressBar.Storage.value = value
    ITMR.ProgressBar.Storage.cropX = 260 - ITMR.ProgressBar.interpolate(value)
    ITMR.Text.add("progressbartitle", title, Isaac.WorldToScreen(Vector(300, 380)), nil, 1, true)
  end,
  
  -- Set progress bar value
  set = function (value)
    ITMR.ProgressBar.Storage.value = value
    ITMR.ProgressBar.Storage.cropX = 260 - ITMR.ProgressBar.interpolate(value)
    ITMR.ProgressBar.Storage.updated = true
  end,
  
  -- Interpolation
  interpolate = function (val)
    return 260* (val - ITMR.ProgressBar.Storage.min)/(ITMR.ProgressBar.Storage.max-ITMR.ProgressBar.Storage.min)
  end,
  
  -- Render progress bar
  render = function ()
    
    -- If progress bar not visible, end function
    if not ITMR.ProgressBar.Storage.visible then return end
    
    -- Render progress bar background
    ITMR.Sprites.UI.ProgressBarBg:Render(Isaac.WorldToScreen(Vector(100, 420)), Vector(0,0), Vector(0,0))
    
    -- Render progress bar line based on value
    ITMR.Sprites.UI.ProgressBarLine:Render(Isaac.WorldToScreen(Vector(100, 420)), Vector(0,0), Vector(ITMR.ProgressBar.Storage.cropX,0))
    
    -- If value will be updated, play animation
    if ITMR.ProgressBar.Storage.updated then
      ITMR.ProgressBar.Storage.updated = false
      ITMR.Sprites.UI.ProgressBarLine:PlayOverlay("BarLine", true)
    end
    
    ITMR.Sprites.UI.ProgressBarLine:Update()
    
  end
}

----------- Bind server handlers ---------------
-- Server handler receive deserialized JSON object
-- from request body and return respoonse object

-- Ping answer
ITMR.Server:setHandler("ping", function (req)
  return { out = "pong" }
end)

-- Set connection
ITMR.Server:setHandler("connect", function (req) 
  ITMR.Text.remove("siteMessage")
  ITMR.Text.add("connectionDone", {"Connection done!"})
  return { out = "success" }
end)

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

-- Give something
ITMR.Server:setHandler("give", function (req) 
  
  if (req.give == "item") then
    ITMR._.giveItem(req.name)
  elseif (req.give == "trinket") then
    ITMR._.giveTrinket(req.name)
  elseif (req.give == "heart") then
    ITMR._.giveHeart(req.name)
  elseif (req.give == "pickup") then
    ITMR._.givePickup(req.name, req.count)
  elseif (req.give == "companion") then
    ITMR._.giveCompanion(req.name)
  elseif (req.give == "pocket") then
    ITMR._.giveTrinket(req.name)
  end
  
  local p = Isaac.GetPlayer(0)
  
  if (req.emote ~= nil) then
    if (req.emote == "h") then p:AnimateHappy() else p:AnimateSad() end
  end
  
  return {res = "ok"}
end)

-- Set tables for external item description mod
if not __eidItemDescriptions then
  __eidItemDescriptions = {};
end

if not __eidRusItemDescriptions then
  __eidRusItemDescriptions = {};
end

if not __eidTrinketDescriptions then
  __eidTrinketDescriptions = {};
end

if not __eidRusTrinketDescriptions then
  __eidRusTrinketDescriptions = {};
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

----------- Bind items and trinkets ---------------

-- Bind callbacks and descriptions for active items
for key,value in pairs(ITMR.Items.Active) do
  ITMR:AddCallback(ModCallbacks.MC_USE_ITEM, ITMR.Items.Active[key].onActivate, ITMR.Items.Active[key].id);
  
  __eidItemDescriptions[ITMR.Items.Active[key].id] = ITMR.Items.Active[key].description["en"] .. 
  "#\3 From Twitch Mod"
  
  __eidRusItemDescriptions[ITMR.Items.Active[key].id] = ITMR._.fixtext(ITMR.Items.Active[key].description["ru"] .. 
  "#\3 Предмет из Твич-мода")
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
  __eidItemDescriptions[ITMR.Items.Passive[key].id] = ITMR.Items.Passive[key].description["en"] .. 
  "#\3 From Twitch Mod"
  
  __eidRusItemDescriptions[ITMR.Items.Passive[key].id] = ITMR._.fixtext(ITMR.Items.Passive[key].description["ru"] .. 
  "#\3 Предмет из Твич-мода")
end

-- Bind callbacks and descriptions for trinkets
for key,value in pairs(ITMR.Items.Trinkets) do
  
  __eidTrinketDescriptions[ITMR.Items.Trinkets[key].id] = ITMR.Items.Trinkets[key].description["en"] .. 
  "#\3 From Twitch Mod"
  
  __eidRusTrinketDescriptions[ITMR.Items.Trinkets[key].id] = ITMR._.fixtext(ITMR.Items.Trinkets[key].description["ru"] .. 
  "#\3 Предмет из Твич-мода")
end


-- Bind callbacks to Isaac
ITMR:AddCallback(ModCallbacks.MC_EXECUTE_CMD, ITMR.Cmd.main)
ITMR:AddCallback(ModCallbacks.MC_POST_UPDATE, ITMR.Callbacks.postUpdate)
ITMR:AddCallback(ModCallbacks.MC_POST_RENDER, ITMR.Callbacks.postRender)
ITMR:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, ITMR.Callbacks.postNewRoom)
ITMR:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ITMR.Callbacks.evaluateCache)
ITMR:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, ITMR.Callbacks.postGameStarted)
ITMR:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, ITMR.Callbacks.preGameExit)
ITMR:AddCallback(ModCallbacks.MC_POST_GAME_END, ITMR.Callbacks.postGameEnd)
ITMR:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, ITMR.Callbacks.getShaderParams)

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

-- onProjectileUpdate Callback
ITMR:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, 
  function (obj, e)
    for key,value in pairs(ITMR.DynamicCallbacks.onProjectileUpdate) do
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

-- Initialize game launch
ITMR.Sprites.load()
ITMR.Text.add("siteMessage", "Go to IsaacOnTwitch.com and select Start!")