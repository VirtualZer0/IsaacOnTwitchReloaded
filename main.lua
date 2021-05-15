IOTR = {}
IOTR.Mod = RegisterMod("IsaacOnTwitchReloaded", 1)

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
IOTR.Mechanics = require('scripts.mechanics') -- Mod game mechanics
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
  paused = false,
  screenSize = (Isaac.WorldToScreen(Vector (320, 280)) - Game ():GetRoom ():GetRenderScrollOffset() - Game().ScreenShakeOffset) * 2,
  postStartRaised = false,
  firstRun = true,
  openSiteButtonState = nil,
  randomNames = {}
}

-- Settings
IOTR.Settings = {
  textpos = {
    --l1 = {X = IOTR.GameState.screenSize.X * .05, Y = IOTR.GameState.screenSize.Y * .70}, -- First line text position
    --l2 = {X = IOTR.GameState.screenSize.X * .05, Y = IOTR.GameState.screenSize.Y * .70 + 15}  -- Second line text position
    l1 = {X = 16, Y = 200},
    l2 = {X = 16, Y = 225}
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
    if text == nil then return end
    
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
    if not IOTR.GameState.renderSpecial then return end
    
    for name, text in pairs(IOTR.Text.Storage) do
      
      -- Check if the text bind to entity
      if (IOTR.Text.FollowStorage[name] ~= nil) then
        
        -- If entity not exists anymore
        if (not IOTR.Text.FollowStorage[name].entity:Exists()) then 
          
          -- then remove text
          IOTR.Text.remove(name)
          
        elseif IOTR._.checkEntityInvisible(IOTR.Text.FollowStorage[name].entity) then
          IOTR.Text.Storage[name].hide = true
        else
          -- else change text position to entity position
          IOTR.Text.Storage[name].hide = false
          for snum, stext in pairs(text.text) do
            local epos = IOTR.Text.FollowStorage[name].entity.Position - IOTR.Text.FollowStorage[name].entity.SpriteOffset
            local resPos = Isaac.WorldToRenderPosition(epos, true) + Game():GetRoom():GetRenderScrollOffset()
            stext.x = resPos.X-2 * #stext.text
            stext.y = resPos.Y - 40 - (snum * text.size * 10)
          end
          
        end
      end
      
      for snum, stext in pairs(text.text) do
        
        if (text.blink ~= nil and Isaac.GetFrameCount() % 10 == 0) then
          local swapColors = text.color;
          text.color = text.blink;
          text.blink = swapColors;
        end
        
        if (text.hide == nil or text.hide == false) then
          Isaac.RenderScaledText(stext.text, stext.x, stext.y, text.size, text.size, text.color.r, text.color.g, text.color.b, text.color.a)
        end
        
      end
    end
  end
}

----------- Poll frames rendering ---------------
IOTR.Pollframes = {
  
  enabled = false,
  frame1 = "gfx/items/collectibles/Collectibles_033_TheBible.png",
  frame2 = "gfx/items/collectibles/Collectibles_033_TheBible.png",
  frame3 = "gfx/items/collectibles/Collectibles_033_TheBible.png",
  
  render = function ()
    if not IOTR.Pollframes.enabled or not IOTR.GameState.renderSpecial then return end
    IOTR.Sprites.UI.PollFrame1:Render(Vector(IOTR.Settings.textpos.l2.X, IOTR.Settings.textpos.l2.Y) + Vector(12, 18), Vector.Zero, Vector.Zero)
    IOTR.Sprites.UI.PollFrame2:Render(Vector(IOTR.Settings.textpos.l2.X, IOTR.Settings.textpos.l2.Y) + Vector(102, 18), Vector.Zero, Vector.Zero)
    IOTR.Sprites.UI.PollFrame3:Render(Vector(IOTR.Settings.textpos.l2.X, IOTR.Settings.textpos.l2.Y) + Vector(192, 18), Vector.Zero, Vector.Zero)
  end,
  
  replaceGfx = function ()
    IOTR.Sprites.UI.PollFrame1:ReplaceSpritesheet(0, IOTR.Pollframes.frame1)
    IOTR.Sprites.UI.PollFrame2:ReplaceSpritesheet(0, IOTR.Pollframes.frame2)
    IOTR.Sprites.UI.PollFrame3:ReplaceSpritesheet(0, IOTR.Pollframes.frame3)
    
    IOTR.Sprites.UI.PollFrame1:LoadGraphics()
    IOTR.Sprites.UI.PollFrame2:LoadGraphics()
    IOTR.Sprites.UI.PollFrame3:LoadGraphics()
  end
  
}

----------- Progress Bar Rendering ---------------

IOTR.ProgressBar = {
  
  -- Progress bar parameters
  Storage = {
    barType = nil,
    title = "",
    visible = false,
    updated = true,
    sectors = 8,
    cropX = 0,
    min = 0,
    max = 100,
    value = 50
  },
  
  -- Create progress bar
  create = function (barType, title, min, max, value, sectors)
    -- 1% = 2.6px
    IOTR.ProgressBar.Storage.sectors = sectors
    IOTR.ProgressBar.Storage.barType = barType
    IOTR.ProgressBar.Storage.title = title
    IOTR.ProgressBar.Storage.visible = true
    IOTR.ProgressBar.Storage.min = min
    IOTR.ProgressBar.Storage.max = max
    IOTR.ProgressBar.Storage.value = value
    IOTR.ProgressBar.Storage.cropX = 260 - IOTR.ProgressBar.interpolate(value)
    IOTR.Text.add("progressbartitle", title, Vector(IOTR.GameState.screenSize.X/2, IOTR.Settings.textpos.l2.Y - 30), {r=1, g=1, b=0 ,a=1}, 1, true)
    
    local currentSector = math.ceil(IOTR.ProgressBar.Storage.value/IOTR.ProgressBar.Storage.max*IOTR.ProgressBar.Storage.sectors) - 1
    IOTR.Sprites.UI["ProgressBar"..barType]:PlayOverlay("Anim"..currentSector, true)
    
  end,
  
  -- Remove progress bar
  remove = function ()
    IOTR.ProgressBar.Storage.visible = false
    IOTR.Text.remove("progressbartitle")
  end,
  
  -- Set progress bar value
  set = function (value, min, max)
    
    if
      IOTR.ProgressBar.Storage.value == value
      and IOTR.ProgressBar.Storage.min == min
      and IOTR.ProgressBar.Storage.max == max
    then return end
    
    IOTR.ProgressBar.Storage.value = value
    IOTR.ProgressBar.Storage.min = min
    IOTR.ProgressBar.Storage.max = max
    IOTR.ProgressBar.Storage.cropX = 260 - IOTR.ProgressBar.interpolate(value)
    IOTR.ProgressBar.Storage.updated = true
    
    local currentSector = math.ceil(IOTR.ProgressBar.Storage.value/IOTR.ProgressBar.Storage.max*IOTR.ProgressBar.Storage.sectors) - 1
    IOTR.Sprites.UI["ProgressBar"..IOTR.ProgressBar.Storage.barType]:PlayOverlay("Anim"..currentSector, true)
    
  end,
  
  -- Interpolation
  interpolate = function (val)
    return 260* (val - IOTR.ProgressBar.Storage.min)/(IOTR.ProgressBar.Storage.max-IOTR.ProgressBar.Storage.min)
  end,
  
  updateText = function ()
    -- If progress bar not visible, end function
    if not IOTR.ProgressBar.Storage.visible then return end
    IOTR.Text.add("progressbartitle", IOTR.ProgressBar.Storage.title, Vector(IOTR.GameState.screenSize.X/2, IOTR.Settings.textpos.l2.Y - 30), {r=1, g=1, b=0 ,a=1}, 1, true)
  end,
  
  setTitle = function (title)
    if not IOTR.ProgressBar.Storage.visible then return end
    IOTR.ProgressBar.Storage.title = title
  end,
  
  -- Render progress bar
  render = function ()
    
    -- If progress bar not visible or need hide, end function
    if not IOTR.ProgressBar.Storage.visible or not IOTR.GameState.renderSpecial then return end
    
    -- Render progress bar background
    IOTR.Sprites.UI["ProgressBar"..IOTR.ProgressBar.Storage.barType]:Render(
      Vector(IOTR.GameState.screenSize.X/2 - 130, IOTR.Settings.textpos.l2.Y),
      Vector.Zero,
      Vector.Zero
    )
    
    
    -- Render progress bar line based on value
    IOTR.Sprites.UI.ProgressBarLine:Render(
      Vector(IOTR.GameState.screenSize.X/2 - 130, IOTR.Settings.textpos.l2.Y),
      Vector.Zero,
      Vector(IOTR.ProgressBar.Storage.cropX,0)
    )
    
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
  for key, value in ipairs(req) do
    if (not IOTR.Text.contains(value)) then
      IOTR.Cmd.send("Text not found: " .. value)
    end
    IOTR.Text.remove(value);
  end
  
end)

-- Clear all text
IOTR.Server:setHandler("clearText", function (req) 
  IOTR.Text.clear()
end)

-- Change text position
IOTR.Server:setHandler("textpos", function (req) 
  IOTR.Settings.textpos = req
end)

-- Enable poll frames
IOTR.Server:setHandler("addPollframes", function (req) 
    
  IOTR.Pollframes.frame1 = req.f1
  IOTR.Pollframes.frame2 = req.f2
  IOTR.Pollframes.frame3 = req.f3
  IOTR.Pollframes.replaceGfx()
  
  IOTR.Pollframes.enabled = true
  
end)

-- Disable poll frames
IOTR.Server:setHandler("removePollframes", function (req)
  
  IOTR.Pollframes.enabled = false
  
end)

-- Enable progress bar
IOTR.Server:setHandler("addProgressBar", function (req) 
    
  IOTR.ProgressBar.create(req.barType, req.title, req.min, req.max, req.value, req.sectors)
  
end)

-- Set progress bar value
IOTR.Server:setHandler("setProgressBar", function (req)
  
  IOTR.ProgressBar.set(req.value, req.min, req.max)
  IOTR.ProgressBar.setTitle(req.title)
  
end)

-- Remove progress bar
IOTR.Server:setHandler("removeProgressBar", function (req) 
  
  IOTR.ProgressBar.remove()
  
end)

-- Set settings
IOTR.Server:setHandler("settings", function (req) 
  
  IOTR.Settings = req;
  
end)

-- Return current player items
IOTR.Server:setHandler("getPlayerItems", function (req) 
  return { out = IOTR._.getPlayerItems() }
end)

-- Return type of current player
IOTR.Server:setHandler("getPlayerType", function (req)
  
  return {
    out = Isaac.GetPlayer(0):GetPlayerType()
  }
  
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
    player:RemoveCollectible(req.item)
    IOTR.Sounds.play(SoundEffect.SOUND_THUMBS_DOWN)
  else
    player:AddCollectible(req.item, 0, true)
    IOTR.Sounds.play(SoundEffect.SOUND_THUMBSUP)
  end
  
end)

-- Give trinket
IOTR.Server:setHandler("trinketAction", function (req) 
    
  IOTR._.giveTrinket(req.trinket)
  
end)

-- Launch event
IOTR.Server:setHandler("eventAction", function (req) 
  IOTR._.launchEvent("EV_"..req.id)
end)

-- Give or remove pickups
IOTR.Server:setHandler("pocketsAction", function (req) 
  
  local p = Isaac.GetPlayer(0)
  
  if (
      type(req.value) == "string" and (req.value == "none" or req.value == "half")
    )
    or (
      type(req.value) == "number" and (
        req.value == 0 or req.value < 0
      )
    ) then
    IOTR.Sounds.play(SoundEffect.SOUND_THUMBS_DOWN)
  else
    IOTR.Sounds.play(SoundEffect.SOUND_THUMBSUP)
  end
  
  if req.pickupType == "Hearts" then
    IOTR._.giveHeart(req.value)
    
  elseif req.pickupType == "Pockets" then
    IOTR._.givePocket(req.value)
    
  elseif req.pickupType == "Keys" then
    if (type(req.value) == "string" and req.value == "gold") then p:AddGoldenKey()
    elseif (type(req.value) == "string" and req.value == "half") then p:AddKeys(math.floor(p:GetNumKeys()/-2))
    else p:AddKeys(req.value) end
  
  elseif req.pickupType == "Bombs" then
    if (type(req.value) == "string" and req.value == "gold") then p:AddGoldenBomb()
    elseif (type(req.value) == "string" and req.value == "half") then p:AddBombs(math.floor(p:GetNumBombs()/-2))
    else p:AddBombs(req.value) end
  
  elseif req.pickupType == "Coins" then
    if (type(req.value) == "string" and req.value == "half") then p:AddCoins(math.floor(p:GetNumCoins()/-2))
    else p:AddCoins(req.value) end
  end
  
end)

-- Add subscriber
IOTR.Server:setHandler("subscriberAction", function (req) 
  local subtime
  if (req.time) then
    subtime = req.time
  else
    subtime = IOTR.Settings.subtime
  end
  
  IOTR.Mechanics.Subscribers._addSubscriber(req.name, req.time)
  IOTR.Sounds.play(SoundEffect.SOUND_THUMBSUP)
end)

-- Spawn bits
IOTR.Server:setHandler("bitsAction", function (req) 
  
  local player = Isaac.GetPlayer(0)
  local room = Game():GetRoom()
  local btype = IOTR.Mechanics.Bits.bitsA
  
  if req.type == 2 then
    btype = IOTR.Mechanics.Bits.bitsB
  elseif req.type == 3 then
    btype = IOTR.Mechanics.Bits.bitsC
  elseif req.type == 4 then
    btype = IOTR.Mechanics.Bits.bitsD
  elseif req.type == 5 then
    btype = IOTR.Mechanics.Bits.bitsE
  end
  
  for i = 1, req.amount do
    Isaac.Spawn(EntityType.ENTITY_PICKUP, btype, 0, room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0, true), Vector.Zero, p)
  end
  
  IOTR.Sounds.play(SoundEffect.SOUND_THUMBSUP)
end)

-- Saave random names from chat
IOTR.Server:setHandler("randomNames", function (req) 
  IOTR.GameState.randomNames = req
end)

-- Give personal trinket
IOTR.Server:setHandler("gift", function (req) 
  local trinket = Isaac.GetTrinketIdByName(req.trinket)
  IOTR._.giveTrinket(trinket)
end)

-- Move player 
IOTR.Server:setHandler("movePlayer", function (req) 
  local p = Isaac.GetPlayer(0)
  
  IOTR.Cmd.send(req)
    
  if req == "l" then
    if math.abs(p.Velocity.X) < 10 then p:AddVelocity(Vector(-2,0)) end
  elseif req == "r" then
    if math.abs(p.Velocity.X) < 10 then p:AddVelocity(Vector(2,0)) end
  elseif req == "u" then
    if math.abs(p.Velocity.Y) < 10 then p:AddVelocity(Vector(0,-2)) end
  elseif req == "d" then
    if math.abs(p.Velocity.Y) < 10 then p:AddVelocity(Vector(0,2)) end
  end
end)

-- Say Jason
IOTR.Server:setHandler("jason", function (req) 
  IOTR.Sounds.play(IOTR.Sounds.list.jason)
end)

-- Set tables for external item description mod

if not __eidRusItemDescriptions then
  __eidRusItemDescriptions = {}
end

if not __eidRusTrinketDescriptions then
  __eidRusTrinketDescriptions = {}
end

----------- Bind items and trinkets ---------------

-- Bind callbacks and descriptions for active items
for key,value in pairs(IOTR.Items.Active) do
  IOTR.Mod:AddCallback(ModCallbacks.MC_USE_ITEM, IOTR.Items.Active[key].onActivate, IOTR.Items.Active[key].id);
  
  if EID then
    EID:addCollectible(IOTR.Items.Active[key].id, IOTR.Items.Active[key].description["ru"] .. "#\3 Предмет из Твич-мода", "ru")
    EID:addCollectible(IOTR.Items.Active[key].id, IOTR.Items.Active[key].description["en"] .. "#\3 From Twitch Mod")
  end
  
  __eidRusItemDescriptions[IOTR.Items.Active[key].id] = IOTR._.fixrus(IOTR.Items.Active[key].description["ru"] .. 
  "#\3 Предмет из Твич-мода")
end

-- Bind pickup/remove callbacks and descriptions for passive items
for key,value in pairs(IOTR.Items.Passive) do
  
  
  -- Add item pickup|remove callbacks
  local pickupRemoveCheck = function ()
    
    -- Check item pickup
    if (Isaac.GetPlayer(0):GetCollectibleNum(IOTR.Items.Passive[key].id) > IOTR.Items.Passive[key].count) then
      
      -- Call onPickup callback
      if IOTR.Items.Passive[key].onPickup ~= nil then IOTR.Items.Passive[key].onPickup() end
      
      -- Adding dynamic callback only if is first item
      if (IOTR.Items.Passive[key].count == 0) then IOTR.DynamicCallbacks.bind(IOTR.Items.Passive, key) end
      
      -- Change item counter
      IOTR.Items.Passive[key].count = Isaac.GetPlayer(0):GetCollectibleNum(IOTR.Items.Passive[key].id)
      
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
      
      -- Update cache if need
      if IOTR.Items.Passive[key].cacheFlag ~= nil then
        local player = Isaac.GetPlayer(0)
        player:AddCacheFlags(IOTR.Items.Passive[key].cacheFlag)
        player:EvaluateItems()
      end
    end
    
  end
    
  IOTR.Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, pickupRemoveCheck);
  
  -- Add External Item Description support
  if EID then
    EID:addCollectible(IOTR.Items.Passive[key].id, IOTR.Items.Passive[key].description["ru"] .. "#\3 Предмет из Твич-мода", "ru")
    EID:addCollectible(IOTR.Items.Passive[key].id, IOTR.Items.Passive[key].description["en"] .. "#\3 From Twitch Mod")
  end
  
  __eidRusItemDescriptions[IOTR.Items.Passive[key].id] = IOTR._.fixrus(IOTR.Items.Passive[key].description["ru"] .. 
  "#\3 Предмет из Твич-мода")
end

-- Bind callbacks and descriptions for trinkets
for key,value in pairs(IOTR.Items.Trinkets) do
  
  if EID then
    EID:addTrinket(IOTR.Items.Trinkets[key].id, IOTR.Items.Trinkets[key].description["ru"] .. "#\3 Тринкет из Твич-мода", "ru")
    EID:addTrinket(IOTR.Items.Trinkets[key].id, IOTR.Items.Trinkets[key].description["en"] .. "#\3 From Twitch Mod")
  end
  
  __eidRusTrinketDescriptions[IOTR.Items.Trinkets[key].id] = {IOTR.Items.Trinkets[key].name, IOTR._.fixrus(IOTR.Items.Trinkets[key].description["ru"] .. 
  "#\3 Тринкет из Твич-мода")}
end


-- Bind callbacks to Isaac
IOTR.Mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, IOTR.Cmd.main)
IOTR.Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, IOTR.Callbacks.postUpdate)
IOTR.Mod:AddCallback(ModCallbacks.MC_POST_RENDER, IOTR.Callbacks.postRender)
IOTR.Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, IOTR.Callbacks.postNewRoom)
IOTR.Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, IOTR.Callbacks.stageChanged)
IOTR.Mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, IOTR.Callbacks.postNPCInit)
IOTR.Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, IOTR.Callbacks.evaluateCache)
IOTR.Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, IOTR.Callbacks.postGameStarted)
IOTR.Mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, IOTR.Callbacks.preGameExit)
IOTR.Mod:AddCallback(ModCallbacks.MC_POST_GAME_END, IOTR.Callbacks.postGameEnd)
IOTR.Mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, IOTR.Callbacks.getShaderParams)

-- Set dynamic and mechanics callbacks

-- onUpdate Callback
IOTR.Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, 
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
IOTR.Mod:AddCallback(ModCallbacks.MC_POST_RENDER, 
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
IOTR.Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, 
  function (obj, player, cacheFlag)
    for key,value in pairs(IOTR.DynamicCallbacks.onCacheUpdate) do
      value(player, cacheFlag)
    end
    
    for key,value in pairs(IOTR.Mechanics) do
      if value.onCacheUpdate ~= nil then value.onCacheUpdate(obj, player, cacheFlag) end
    end
  end
)

-- onEntityUpdate Callback
IOTR.Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, 
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
IOTR.Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, 
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

-- onTearInit Callback
IOTR.Mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, 
  function (obj, e)
    for key,value in pairs(IOTR.DynamicCallbacks.onTearInit) do
      value(e)
    end
    
    for key,value in pairs(IOTR.Mechanics) do
      if value.onTearInit ~= nil then value.onTearInit(e) end
    end
  end
)

-- onTearUpdate Callback
IOTR.Mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, 
  function (obj, e)
    for key,value in pairs(IOTR.DynamicCallbacks.onTearUpdate) do
      value(e)
    end
    
    for key,value in pairs(IOTR.Mechanics) do
      if value.onTearUpdate ~= nil then value.onTearUpdate(e) end
    end
  end
)

-- onProjectileUpdate Callback
IOTR.Mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, 
  function (obj, e)
    for key,value in pairs(IOTR.DynamicCallbacks.onProjectileUpdate) do
      value(e)
    end
    
    for key,value in pairs(IOTR.Mechanics) do
      if value.onProjectileUpdate ~= nil then value.onProjectileUpdate(e) end
    end
  end
)

-- onDamage Callback
IOTR.Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, 
  function (obj, entity, damageAmnt, damageFlag, damageSource, damageCountdown)
    
    local res = nil
    
    for key,value in pairs(IOTR.DynamicCallbacks.onDamage) do
      if(value(entity, damageAmnt, damageFlag, damageSource, damageCountdown) == false) then
        res = false
      end
    end
    
    for key,value in pairs(IOTR.Mechanics) do
      if value.onDamage ~= nil then
        if(value.onDamage(entity, damageAmnt, damageFlag, damageSource, damageCountdown) == false) then
          res = false
        end
      end
    end
    
    return res
  end
)

-- onNPCInit Callback
IOTR.Mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, 
  function (obj, e)
    for key,value in pairs(IOTR.DynamicCallbacks.onNPCInit) do
      value(e)
    end
    
    for key,value in pairs(IOTR.Mechanics) do
      if value.onNPCInit ~= nil then value.onNPCInit(e) end
    end
  end
)

-- onNPCDeath Callback
IOTR.Mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, 
  function (obj, e)
    for key,value in pairs(IOTR.DynamicCallbacks.onNPCDeath) do
      value(e)
    end
    
    for key,value in pairs(IOTR.Mechanics) do
      if value.onNPCDeath ~= nil then value.onNPCDeath(e) end
    end
  end
)

-- onStageChange Callback
IOTR.Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, 
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
IOTR.Mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, 
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

-- onFamiliarInit Callback

IOTR.Mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, 
  function (obj, familiar)
    
    for key,value in pairs(IOTR.Items.Passive) do
      if (value.famFollowPlayer ~= nil and value.famFollowPlayer == true and value.famId == familiar.Variant) then
        familiar:AddToFollowers()
      end
    end
    
    for key,value in pairs(IOTR.DynamicCallbacks.onFamiliarInit) do
      value(familiar)
    end
    
    for key,value in pairs(IOTR.Mechanics) do
      if value.onFamiliarInit ~= nil then value.onFamiliarInit(familiar) end
    end
  end
)

-- onFamiliarCollision Callback
IOTR.Mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, 
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

-- onFamiliarUpdate Callback
IOTR.Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, 
  function (obj, familiar)
    
    for key,value in pairs(IOTR.DynamicCallbacks.onFamiliarUpdate) do
      value(familiar)
    end
    
    for key,value in pairs(IOTR.Mechanics) do
      if value.onFamiliarUpdate ~= nil then value.onFamiliarUpdate(familiar) end
    end
  end
)

-- Initialize game launch
IOTR._.checkRussianFont()
IOTR.Sprites.load()

if IOTR.Server.isOk then
  IOTR.Text.add("siteMessage", IOTR.Locale[IOTR.Settings.lang].welcomeMessage)
else
  IOTR.Text.add("ludebugErrorEng", IOTR.Locale["en"].luadebugMessage, IOTR.Settings.textpos.l1, nil, nil, nil, {r=1,g=0,b=0,a=1})
  IOTR.Text.add("ludebugErrorRus", IOTR.Locale["ru"].luadebugMessage, IOTR.Settings.textpos.l2, nil, nil, nil, {r=1,g=0,b=0,a=1})
end