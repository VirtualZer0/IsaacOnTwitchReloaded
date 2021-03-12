-- Update functions for Isaac API Callbacks
local json = require('json')
local _ = require('scripts.helper')

local callbacks = {}

-- Post Update callback
function callbacks:postUpdate ()
  
  -- Hide text if boss screen active
  if (Game():GetRoom():GetType() == RoomType.ROOM_BOSS and Game():GetRoom():GetFrameCount() == 0) then
    IOTR.GameState.renderSpecial = false
  else
    IOTR.GameState.renderSpecial = true
  end
  
  -- Call timers
  IOTR.Timers.tick()
  
  -- Update events countdown with byTime == true
  for key,value in pairs(IOTR.Storage.ActiveEvents) do
    if value.event.byTime or value.event.byTime == nil then
      
      if (value.currentTime > 0) then
        value.currentTime = value.currentTime - 1
      else
        -- Trigger onEnd callback, if it possible
        if value.event.onEnd ~= nil then value.event.onEnd() end
        
        -- Remove event and callbacks
        IOTR.DynamicCallbacks.unbind(IOTR.Events, value.name)
        IOTR.Storage.ActiveEvents[key] = nil
      end
      
    end
  end
end


-- Post Render Callback
function callbacks:postRender ()
  
  -- Delay between server check requests, for more performance
  if (Isaac.GetFrameCount() % 4 == 0) then
    IOTR.Server:update()
  end
  
  -- Update ScreenSize, because window can be resized during game
  if (Isaac.GetFrameCount() % 30 == 0) then
    IOTR.GameState.screenSize = (Isaac.WorldToScreen (Vector (320, 280)) - Game ():GetRoom ():GetRenderScrollOffset() - Game().ScreenShakeOffset) * 2
  end
  
  -- Render progress bar
  IOTR.ProgressBar.render()
  
  -- Render text
  IOTR.Text.render()
  
end

-- Room change callback
function callbacks:postNewRoom ()
  
  -- Update events countdown with byTime == false
  for key,value in pairs(IOTR.Storage.ActiveEvents) do
    if value.event.byTime == false then
      
      if (value.currentTime > 0) then
        value.currentTime = value.currentTime - 1
      else
        -- Trigger onEnd callback, if it possible
        if value.event.onEnd ~= nil then value.event.onEnd() end
        
        -- Remove event and callbacks
        IOTR.DynamicCallbacks.unbind(IOTR.Events, value.name)
        IOTR.Storage.ActiveEvents[key] = nil
      end
      
    end
  end
  
end

-- Evaluate Cache Callback
function callbacks:evaluateCache (player, cacheFlag)
  
  
  if (cacheFlag == CacheFlag.CACHE_DAMAGE) then
    player.Damage = player.Damage + IOTR.Storage.Stats.damage
  
  elseif (cacheFlag == CacheFlag.CACHE_FIREDELAY) then
    player.FireDelay = player.FireDelay + IOTR.Storage.Stats.tears
      
  elseif (cacheFlag == CacheFlag.CACHE_SHOTSPEED) then
    player.ShotSpeed = player.ShotSpeed + IOTR.Storage.Stats.tearspeed
      
  elseif (cacheFlag == CacheFlag.CACHE_SPEED) then
    player.MoveSpeed = player.MoveSpeed + IOTR.Storage.Stats.speed
  
  elseif (cacheFlag == CacheFlag.CACHE_LUCK) then
    player.Luck = player.Luck + IOTR.Storage.Stats.luck
      
  elseif (cacheFlag == CacheFlag.CACHE_ALL) then
    player.Damage = player.Damage + IOTR.Storage.Stats.damage
    player.FireDelay = player.FireDelay + IOTR.Storage.Stats.tears
    player.ShotSpeed = player.ShotSpeed + IOTR.Storage.Stats.tearspeed
    player.MoveSpeed = player.MoveSpeed + IOTR.Storage.Stats.speed
    player.Luck = player.Luck + IOTR.Storage.Stats.luck
  end
  
end

-- Start Game callback
function callbacks:postGameStarted (fromSave)
  
  -- Reset previous game state
  _.resetState()
  
  if (fromSave) then
    Save = json.decode(Isaac.LoadModData(IOTR))
    IOTR.Cmd.send("Checking save")
    
    if (Save ~= nil and Save.Storage ~= nil) then
      
      IOTR.Cmd.send("Loading from save")
      IOTR.Storage = Save.Storage
      
      for key,value in pairs(IOTR.Items.Passive) do
        IOTR.Items.Passive[key].count = Save.ItemsCount[key]
        if (Isaac.GetPlayer(0):GetCollectibleNum(IOTR.Items.Passive[key].id) > 0) then IOTR.DynamicCallbacks.bind(IOTR.Items.Passive, key) end
      end
      
      local player = Isaac.GetPlayer(0)
      player:AddCacheFlags(CacheFlag.CACHE_ALL)
      player:EvaluateItems()
    end
  end
  
  -- Running IOTR server
  IOTR.Server:run()
  
end

-- Exit Game callback
function callbacks:preGameExit (shouldSave)
  -- Stop IOTR server
  IOTR.Server:close()
  
  -- Reset dynamic callbacks
  for cname, cval in pairs(IOTR.DynamicCallbacks) do
    if (type(cval) ~= "function") then
      cval = nil
    end
  end
  
  -- Disable shaders
  for shaderName, shader in pairs(IOTR.Shaders) do
    shader.enabled = false
  end
  
  if shouldSave == false then
    
    -- Clear current collectible items count
    for key,value in pairs(IOTR.Items.Passive) do
      IOTR.Items.Passive[key].count = 0
    end
    
    -- Reset stats
    IOTR.Storage.Stats = {
      speed = 0,
      range = 0,
      tears = 0,
      tearspeed = 0,
      damage = 0,
      luck = 0
    }
    
    -- Reset hearts
    IOTR.Storage.Hearts = {
      twitch = 0,
      rainbow = 0
    }
  else
    IOTR.Cmd.send("Saving mod data")
    
    Save = {
      Storage = IOTR.Storage,
      ItemsCount = {}
    }
    
    for key,value in pairs(IOTR.Items.Passive) do
      Save.ItemsCount[key] = IOTR.Items.Passive[key].count
    end
    
    Isaac.SaveModData(IOTR, json.encode(Save))
  end
end

-- Gameover callback
function callbacks:postGameEnd (gameover)
  
  
  
end

-- Shaders callback
function callbacks:getShaderParams (name)
  if (IOTR.Shaders[name] == nil) then return end
  
  if shaderAPI then
    shaderAPI(name, IOTR.Shaders[name].pass())
  else
    return IOTR.Shaders[name].pass()
  end
end


return callbacks