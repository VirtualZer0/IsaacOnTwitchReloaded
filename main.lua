IOTR = RegisterMod("IsaacOnTwitchReloaded", 1)

--require('mobdebug').start()
--StartDebug()
local json = require('json')

-- Creating subobjects
IOTR.Server = require('scripts.server')       -- IOTR Server
IOTR.Callbacks = require('scripts.callbacks') -- Callbacks
IOTR.Classes = require('scripts.classes')     -- Classes
IOTR.Enums = require('scripts.enums')         -- Enumerations
IOTR.Sounds = require('scripts.sounds')       -- Sounds
IOTR.Cmd = require('scripts.cmd')             -- Command line handler
IOTR.Sprites = require('scripts.sprites')     -- Sprites
IOTR.Shaders = require('scripts.shaders')     -- Shaders
IOTR.Events = require('scripts.events')       -- Events
IOTR.Mechanics = require('scripts.mechanics')       -- Events
IOTR.Locale = require('locale.main')          -- Localization
IOTR._ = require('scripts.helper')            -- Helper functions

-- Items
IOTR.Items = {
  Active = require('scripts.activeItems'),    -- Active items
  Passive = require('scripts.passiveItems'),  -- Passive items
  Trinkets = require('scripts.trinkets'),     -- Trinkets
}

-- Additional game state
IOTR.GameState = {
  renderSpecial = true,
  screenSize = (Isaac.WorldToScreen(Vector (320, 280)) - Game ():GetRoom ():GetRenderScrollOffset() - Game().ScreenShakeOffset) * 2
}

-- Settings
IOTR.Settings = {
  textpos = {
    l1 = {X = IOTR.GameState.screenSize.X * .05, Y = IOTR.GameState.screenSize.Y * .70}, -- First line text position
    l2 = {X = IOTR.GameState.screenSize.X * .05, Y = IOTR.GameState.screenSize.Y * .70 + 15}  -- Second line text position
  },
  subtime = 10*60*30,       -- Time to life for subscribers
  lang = "en"               -- Current language
}

-- Current game session storage
IOTR.Storage = IOTR.Classes.Storage:new()

-- Dynamic callbacks storage
IOTR.DynamicCallbacks = IOTR.Classes.DynamicCallbacks:new()

----------- Timers system ---------------
IOTR.Timers = {
  
  Storage = {}, -- Current timers
  _timerId = 1,
  
  addTimeout = function (func, interval)
    
    local timerId = IOTR.Timers._timerId
    IOTR.Timers._timerId = IOTR.Timers._timerId + 1
    
    table.insert(IOTR.Timers.Storage, {
      id = timerId,
      func = func,
      interval = interval,
      currentInterval = interval,
      repeats = 1
    })
  
    return timerId
    
  end,
  
  addInterval = function (func, interval, repeats)
    
    local timerId = IOTR.Timers._timerId
    IOTR.Timers._timerId = IOTR.Timers._timerId + 1
    
    if (repeats == nil) then repeats = -1 end
    
    table.insert(IOTR.Timers.Storage, {
      id = timerId,
      func = func,
      interval = interval,
      currentInterval = interval,
      repeats = repeats
    })
  
    return timerId
    
  end,
  
  stop = function (id)
    for key, timer in pairs(IOTR.Timers.Storage) do
      if timer.id == id then IOTR.Timers.Storage[key] = nil end
    end
  end,
  
  tick = function ()
    for key, timer in pairs(IOTR.Timers.Storage) do
      timer.currentInterval = timer.currentInterval - 1
      
      if timer.currentInterval == 0 then
        timer.repeats = timer.repeats - 1
        timer.currentInterval = timer.interval
        timer.func()
      end
      
      if timer.repeats == 0 then
        IOTR.Timers.Storage[key] = null
      end
    end
  end
  
}

----------- Text Rendering ---------------

IOTR.Text = {
  
  Storage = {},       -- Current texts for render
  FollowStorage = {}, -- Entities for binding text position
  
  -- Add new text to render
  add = function (name, text, pos, color, size, isCenter, blink)
        
    -- Too lazy for writing this every time
    if (pos == nil) then pos = IOTR.Settings.textpos.l2 end
    if (color == nil) then color = {r = 1, g = 1, b = 1, a = 1} end
    if (size == nil) then size = 1 end
    if (isCenter == nil) then isCenter = false end
    if (blink == nil) then blink = nil end
    
    -- If text is not array, make array
    if (type(text) == "string") then text = {text} end
    
    -- Split text on strings
    local strings = {}
    local line = 1
    
    for ns, s in pairs(text) do
      
      -- Replace symbols if it's needed
      s = IOTR._.fixtext(s)
      
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
    
    IOTR.Text.Storage[name] = {
      text = strings,
      isCenter = isCenter,
      color = color,
      size = size,
      blink = blink
    }
  end,
  
  -- Bind text to entity position
  follow = function (name, entity)
    IOTR.Text.FollowStorage[name] = {
      entity = entity
    }
  end,
  
  -- Remove text
  remove = function (name)
    IOTR.Text.Storage[name] = nil
    IOTR.Text.FollowStorage[name] = nil
  end,
  
  -- Clear text
  clear = function ()
    IOTR.Text.Storage = {}
    IOTR.Text.FollowStorage = {}
  end,
  
  -- Contain text
  contains = function (name)
    if (IOTR.Text.Storage[name] ~= nil) then return true end
    if (IOTR.Text.FollowStorage[name] ~= nil) then return true end
    return false
  end,
  
  -- Render all current texts
  render = function ()
    
    -- Check if render not allowed
    if (IOTR.GameState.renderSpecial == false) then return end
    
    for name, text in pairs(IOTR.Text.Storage) do
      
      -- Check if the text bind to entity
      if (IOTR.Text.FollowStorage[name] ~= nil) then
        
        -- If entity not exists anymore
        if (IOTR.Text.FollowStorage[name].entity:Exists() ~= true) then 
          
          -- then remove text
          IOTR.Text.remove(name)
          
        else
          
          -- else change text position to entity position
          for snum, stext in pairs(text.text) do
            local epos = Isaac.WorldToRenderPosition(IOTR.Text.FollowStorage[name].entity.Position, true) + Game():GetRoom():GetRenderScrollOffset()
            stext.x = epos.X-3 * #stext.text
            stext.y = epos.Y - 40 - (snum * text.size * 10)
          end
          
        end
      end
      
      for snum, stext in pairs(text.text) do
        
        if (text.blink ~= nil and Isaac.GetFrameCount() % 10 == 0) then
          local swapColors = text.color;
          text.color = text.blink;
          text.blink = swapColors;
        end
        
        Isaac.RenderScaledText(stext.text, stext.x, stext.y, text.size, text.size, text.color.r, text.color.g, text.color.b, text.color.a)
        
      end
    end
  end
}

----------- Progress Bar Rendering ---------------

IOTR.ProgressBar = {
  
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
    IOTR.ProgressBar.Storage.visible = true
    IOTR.ProgressBar.Storage.min = min
    IOTR.ProgressBar.Storage.max = max
    IOTR.ProgressBar.Storage.value = value
    IOTR.ProgressBar.Storage.cropX = 260 - IOTR.ProgressBar.interpolate(value)
    IOTR.Text.add("progressbartitle", title, Isaac.WorldToScreen(Vector(300, 380)), nil, 1, true)
  end,
  
  -- Set progress bar value
  set = function (value)
    IOTR.ProgressBar.Storage.value = value
    IOTR.ProgressBar.Storage.cropX = 260 - IOTR.ProgressBar.interpolate(value)
    IOTR.ProgressBar.Storage.updated = true
  end,
  
  -- Interpolation
  interpolate = function (val)
    return 260* (val - IOTR.ProgressBar.Storage.min)/(IOTR.ProgressBar.Storage.max-IOTR.ProgressBar.Storage.min)
  end,
  
  -- Render progress bar
  render = function ()
    
    -- If progress bar not visible, end function
    if not IOTR.ProgressBar.Storage.visible then return end
    
    -- Render progress bar background
    IOTR.Sprites.UI.ProgressBarBg:Render(Isaac.WorldToScreen(Vector(100, 420)), Vector(0,0), Vector(0,0))
    
    -- Render progress bar line based on value
    IOTR.Sprites.UI.ProgressBarLine:Render(Isaac.WorldToScreen(Vector(100, 420)), Vector(0,0), Vector(IOTR.ProgressBar.Storage.cropX,0))
    
    -- If value will be updated, play animation
    if IOTR.ProgressBar.Storage.updated then
      IOTR.ProgressBar.Storage.updated = false
      IOTR.Sprites.UI.ProgressBarLine:PlayOverlay("BarLine", true)
    end
    
    IOTR.Sprites.UI.ProgressBarLine:Update()
    
  end
}

----------- Bind server handlers ---------------
-- Server handler receive deserialized JSON object
-- from request body and return respoonse object

-- Ping answer
IOTR.Server:setHandler("ping", function (req)
  return { out = "pong" }
end)

-- Set connection
IOTR.Server:setHandler("connect", function (req) 
  IOTR.Text.remove("siteMessage");
  IOTR.Sounds.play(SoundEffect.SOUND_THUMBSUP);
  IOTR.Cmd.send("Web-client connected")
  return { out = "success" }
end)

-- Add text to screen
IOTR.Server:setHandler("addText", function (req) 
  
  for key, value in ipairs(req) do
    local tpos = IOTR.Settings.textpos.l1;
    if (value.pos ~= nil and value.pos ~= "empty") then
      tpos = value.pos;
    end
    IOTR.Text.add(value.name, value.value, tpos, value.color, value.size, value.isCenter, value.blink);
  end
  
end)

-- Remove text from screen
IOTR.Server:setHandler("removeText", function (req) 
  if (not IOTR.Text.contains(req.name)) then
    IOTR.Cmd.send("Text not found: " .. req.name)
  end
  IOTR.Text.remove(req.name);
end)

-- Clear all text
IOTR.Server:setHandler("clearText", function (req) 
  IOTR.Text.clear()
end)

-- Change text position
IOTR.Server:setHandler("textpos", function (req) 
  
end)

-- Set settings
IOTR.Server:setHandler("settings", function (req) 
  
  IOTR.Settings = req;
  
end)

-- Return current player items
IOTR.Server:setHandler("getPlayerItems", function (req) 
  return { out = IOTR._.getPlayerItems() }
end)

-- Return items from IOTR
IOTR.Server:setHandler("getItems", function (req) 
    
  return {
    out = IOTR._.getAllContent()
  }
  
end)

-- Give or remove item
IOTR.Server:setHandler("itemAction", function (req) 
    
  local player = Isaac.GetPlayer(0);  
  
  if (req.remove == true) then
    player:RemoveCollectible(req.item);
    player:AnimateSad();
  else
    player:AddCollectible(req.item, 0, true);
    player:AnimateHappy();
  end
  
end)

-- Launch event
IOTR.Server:setHandler("eventAction", function (req) 
  IOTR._.launchEvent("EV_"..req.id)
end)

-- Give personal trinket
IOTR.Server:setHandler("gift", function (req) 
  
end)

-- Set subscribers remove time
IOTR.Server:setHandler("subtime", function (req) 
  
end)

-- Give something
IOTR.Server:setHandler("give", function (req) 
  
  if (req.give == "item") then
    IOTR._.giveItem(req.name)
  elseif (req.give == "trinket") then
    IOTR._.giveTrinket(req.name)
  elseif (req.give == "heart") then
    IOTR._.giveHeart(req.name)
  elseif (req.give == "pickup") then
    IOTR._.givePickup(req.name, req.count)
  elseif (req.give == "companion") then
    IOTR._.giveCompanion(req.name)
  elseif (req.give == "pocket") then
    IOTR._.giveTrinket(req.name)
  end
  
  local p = Isaac.GetPlayer(0)
  
  if (req.emote ~= nil) then
    if (req.emote == "h") then p:AnimateHappy() else p:AnimateSad() end
  end
  
  return {res = "ok"}
end)

-- Set tables for external item description mod
if not __eidItemDescriptions then
  __eidItemDescriptions = {}
end

if not __eidRusItemDescriptions then
  __eidRusItemDescriptions = {}
end

if not __eidTrinketDescriptions then
  __eidTrinketDescriptions = {}
end

if not __eidRusTrinketDescriptions then
  __eidRusTrinketDescriptions = {}
end

----------- Bind items and trinkets ---------------

-- Bind callbacks and descriptions for active items
for key,value in pairs(IOTR.Items.Active) do
  IOTR:AddCallback(ModCallbacks.MC_USE_ITEM, IOTR.Items.Active[key].onActivate, IOTR.Items.Active[key].id);
  
  __eidItemDescriptions[IOTR.Items.Active[key].id] = IOTR.Items.Active[key].description["en"] .. 
  "#\3 From Twitch Mod"
  
  __eidRusItemDescriptions[IOTR.Items.Active[key].id] = IOTR._.fixrus(IOTR.Items.Active[key].description["ru"] .. 
  "#\3 Предмет из Твич-мода")
end

-- Bind pickup/remove callbacks and descriptions for passive items
for key,value in pairs(IOTR.Items.Passive) do
  
  
  -- Add item pickup|remove callbacks
  local pickupRemoveCheck = function ()
    
    -- Check item pickup
    if (Isaac.GetPlayer(0):GetCollectibleNum(IOTR.Items.Passive[key].id) > IOTR.Items.Passive[key].count) then
      
      -- Increase item counter
      IOTR.Items.Passive[key].count = IOTR.Items.Passive[key].count + 1
      
      -- Adding dynamic callback
      if (Isaac.GetPlayer(0):GetCollectibleNum(IOTR.Items.Passive[key].id) > 0) then IOTR.DynamicCallbacks.bind(IOTR.Items.Passive, key) end
      
      -- Call onPickup callback
      if IOTR.Items.Passive[key].onPickup ~= nil then IOTR.Items.Passive[key].onPickup() end
      
      -- Update cache if need
      if IOTR.Items.Passive[key].cacheFlag ~= nil then
        local player = Isaac.GetPlayer(0)
        player:AddCacheFlags(IOTR.Items.Passive[key].cacheFlag)
        player:EvaluateItems()
      end
      
    -- Check item remove
    elseif (Isaac.GetPlayer(0):GetCollectibleNum(IOTR.Items.Passive[key].id) < IOTR.Items.Passive[key].count) then
      -- Decrease item counter
      IOTR.Items.Passive[key].count = IOTR.Items.Passive[key].count - 1
      
      -- Remove dynamic callbacks
      if (Isaac.GetPlayer(0):GetCollectibleNum(IOTR.Items.Passive[key].id) == 0) then IOTR.DynamicCallbacks.unbind(IOTR.Items.Passive, key) end
      
      -- Call onRemove callback
      if IOTR.Items.Passive[key].onRemove ~= nil then IOTR.Items.Passive[key].onRemove() end
    end
    
  end
    
  IOTR:AddCallback(ModCallbacks.MC_POST_UPDATE, pickupRemoveCheck);
  
  -- Add External Item Description support
  __eidItemDescriptions[IOTR.Items.Passive[key].id] = IOTR.Items.Passive[key].description["en"] .. 
  "#\3 From Twitch Mod"
  
  __eidRusItemDescriptions[IOTR.Items.Passive[key].id] = IOTR._.fixrus(IOTR.Items.Passive[key].description["ru"] .. 
  "#\3 Предмет из Твич-мода")
end

-- Bind callbacks and descriptions for trinkets
for key,value in pairs(IOTR.Items.Trinkets) do
  
  __eidTrinketDescriptions[IOTR.Items.Trinkets[key].id] = IOTR.Items.Trinkets[key].description["en"] .. 
  "#\3 From Twitch Mod"
  
  __eidRusTrinketDescriptions[IOTR.Items.Trinkets[key].id] = IOTR._.fixrus(IOTR.Items.Trinkets[key].description["ru"] .. 
  "#\3 Предмет из Твич-мода")
end


-- Bind callbacks to Isaac
IOTR:AddCallback(ModCallbacks.MC_EXECUTE_CMD, IOTR.Cmd.main)
IOTR:AddCallback(ModCallbacks.MC_POST_UPDATE, IOTR.Callbacks.postUpdate)
IOTR:AddCallback(ModCallbacks.MC_POST_RENDER, IOTR.Callbacks.postRender)
IOTR:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, IOTR.Callbacks.postNewRoom)
IOTR:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, IOTR.Callbacks.evaluateCache)
IOTR:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, IOTR.Callbacks.postGameStarted)
IOTR:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, IOTR.Callbacks.preGameExit)
IOTR:AddCallback(ModCallbacks.MC_POST_GAME_END, IOTR.Callbacks.postGameEnd)
IOTR:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, IOTR.Callbacks.getShaderParams)

-- Set dynamic and mechanics callbacks

-- onUpdate Callback
IOTR:AddCallback(ModCallbacks.MC_POST_UPDATE, 
  function ()
    for key,value in pairs(IOTR.DynamicCallbacks.onUpdate) do
      value()
    end
    
    for key,value in pairs(IOTR.Mechanics) do
      if value.onUpdate ~= nil then value.onUpdate() end
    end
  end
)

-- onRenderUpdate Callback
IOTR:AddCallback(ModCallbacks.MC_POST_RENDER, 
  function ()
    for key,value in pairs(IOTR.DynamicCallbacks.onRenderUpdate) do
      value()
    end
    
    for key,value in pairs(IOTR.Mechanics) do
      if value.onRenderUpdate ~= nil then value.onRenderUpdate() end
    end
  end
)

-- onCacheUpdate Callback
IOTR:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, 
  function (obj, player, cacheFlag)
    for key,value in pairs(IOTR.DynamicCallbacks.onCacheUpdate) do
      value(obj, player, cacheFlag)
    end
    
    for key,value in pairs(IOTR.Mechanics) do
      if value.onCacheUpdate ~= nil then value.onCacheUpdate(obj, player, cacheFlag) end
    end
  end
)

-- onEntityUpdate Callback
IOTR:AddCallback(ModCallbacks.MC_POST_UPDATE, 
  function ()
    local entities = Isaac.GetRoomEntities()
    
    for entityKey, entity in pairs(entities) do
      for key,value in pairs(IOTR.DynamicCallbacks.onEntityUpdate) do
        value(entity)
      end
      
      for key,value in pairs(IOTR.Mechanics) do
        if value.onEntityUpdate ~= nil then value.onEntityUpdate(entity) end
      end
    end
  end
)

-- onRoomChange and onNewRoom Callback
IOTR:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, 
  function ()
    for key,value in pairs(IOTR.DynamicCallbacks.onRoomChange) do
      value()
    end
    
    for key,value in pairs(IOTR.Mechanics) do
      if value.onRoomChange ~= nil then value.onRoomChange() end
    end
    
    if not Game():GetRoom():IsClear() then
      for key,value in pairs(IOTR.DynamicCallbacks.onNewRoom) do
        value()
      end
      
      for key,value in pairs(IOTR.Mechanics) do
        if value.onNewRoom ~= nil then value.onNewRoom() end
      end
    end
  end
)

-- onTearUpdate Callback
IOTR:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, 
  function (obj, e)
    for key,value in pairs(IOTR.DynamicCallbacks.onTearUpdate) do
      value(obj, e)
    end
    
    for key,value in pairs(IOTR.Mechanics) do
      if value.onTearUpdate ~= nil then value.onTearUpdate(obj, e) end
    end
  end
)

-- onProjectileUpdate Callback
IOTR:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, 
  function (obj, e)
    for key,value in pairs(IOTR.DynamicCallbacks.onProjectileUpdate) do
      value(obj, e)
    end
    
    for key,value in pairs(IOTR.Mechanics) do
      if value.onProjectileUpdate ~= nil then value.onProjectileUpdate(obj, e) end
    end
  end
)

-- onDamage Callback
IOTR:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, 
  function (obj, entity, damageAmnt, damageFlag, damageSource, damageCountdown)
    
    local res = nil
    
    for key,value in pairs(IOTR.DynamicCallbacks.onDamage) do
      if(value(entity, damageAmnt, damageFlag, damageSource, damageCountdown) == false) then
        res = false
      end
    end
    
    for key,value in pairs(IOTR.Mechanics) do
      if value.onDamage ~= nil then
        if(value(entity, damageAmnt, damageFlag, damageSource, damageCountdown) == false) then
          res = false
        end
      end
    end
    
    return res
  end
)

-- onNPCDeath Callback
IOTR:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, 
  function (obj, e)
    for key,value in pairs(IOTR.DynamicCallbacks.onNPCDeath) do
      value(obj, e)
    end
    
    for key,value in pairs(IOTR.Mechanics) do
      if value.onNPCDeath ~= nil then value.onNPCDeath(obj, e) end
    end
  end
)

-- onStageChange Callback
IOTR:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, 
  function ()
    for key,value in pairs(IOTR.DynamicCallbacks.onStageChange) do
      value()
    end
    
    for key,value in pairs(IOTR.Mechanics) do
      if value.onStageChange ~= nil then value.onStageChange() end
    end
  end
)

-- onPickupCollision Callback
IOTR:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, 
  function (obj, pickup, collider, low)
    local result = nil
    
    for key,value in pairs(IOTR.DynamicCallbacks.onPickupCollision) do
      result = value(pickup, collider, low)
    end
    
    for key,value in pairs(IOTR.Mechanics) do
      if value.onPickupCollision ~= nil then result = value.onPickupCollision(pickup, collider, low) end
    end
    
    return result
  end
)

-- onFamiliarCollision Callback
IOTR:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, 
  function (obj, familiar, collider, low)
    local result = nil
    
    for key,value in pairs(IOTR.DynamicCallbacks.onFamiliarCollision) do
      result = value(familiar, collider, low)
    end
    
    for key,value in pairs(IOTR.Mechanics) do
      if value.onFamiliarCollision ~= nil then result = value.onFamiliarCollision(familiar, collider, low) end
    end
    
    return result
  end
)

-- Initialize game launch
IOTR._.checkRussianFont()
IOTR.Sprites.load()
IOTR.Text.add("siteMessage", IOTR.Locale[IOTR.Settings.lang].welcomeMessage)