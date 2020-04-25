-- Update functions for Isaac API Callbacks
local json = require('json')
local _ = require('scripts.helper')

local callbacks = {}

-- Post Update callback
function callbacks:postUpdate ()
  
  -- Hide text if boss screen active
  if (Game():GetRoom():GetType() == RoomType.ROOM_BOSS and Game():GetRoom():GetFrameCount() == 0) then
    ITMR.GameState.renderSpecial = false
  else
    ITMR.GameState.renderSpecial = true
  end
  
  -- Call timers
  ITMR.Timers.tick()
  
  -- Update events countdown with byTime == true
  for key,value in pairs(ITMR.Storage.ActiveEvents) do
    if value.event.byTime or value.event.byTime == nil then
      
      if (value.currentTime > 0) then
        value.currentTime = value.currentTime - 1
        Isaac.ConsoleOutput(tostring(value.currentTime) .. " ")
      else
        -- Trigger onEnd callback, if it possible
        if value.event.onEnd ~= nil then value.event.onEnd() end
        
        -- Remove event and callbacks
        ITMR.DynamicCallbacks.unbind(ITMR.Events, value.name)
        ITMR.Storage.ActiveEvents[key] = nil
      end
      
    end
  end
end


-- Post Render Callback
function callbacks:postRender ()
  
  -- Delay between server check requests, for more performance
  if (Isaac.GetFrameCount() % 4 == 0) then
    ITMR.Server:update()
  end
  
  -- Render progress bar
  ITMR.ProgressBar.render()
  
  -- Render text
  ITMR.Text.render()
  
end

-- Room change callback
function callbacks:postNewRoom ()
  
  -- Update events countdown with byTime == false
  for key,value in pairs(ITMR.Storage.ActiveEvents) do
    if value.event.byTime == false then
      
      if (value.currentTime > 0) then
        value.currentTime = value.currentTime - 1
      else
        -- Trigger onEnd callback, if it possible
        if value.event.onEnd ~= nil then value.event.onEnd() end
        
        -- Remove event and callbacks
        ITMR.DynamicCallbacks.unbind(ITMR.Events, value.name)
        ITMR.Storage.ActiveEvents[key] = nil
      end
      
    end
  end
  
end

-- Evaluate Cache Callback
function callbacks:evaluateCache (player, cacheFlag)
  
  
  if (cacheFlag == CacheFlag.CACHE_DAMAGE) then
    player.Damage = player.Damage + ITMR.Storage.Stats.damage
  
  elseif (cacheFlag == CacheFlag.CACHE_FIREDELAY) then
    player.FireDelay = player.FireDelay + ITMR.Storage.Stats.tears
      
  elseif (cacheFlag == CacheFlag.CACHE_SHOTSPEED) then
    player.ShotSpeed = player.ShotSpeed + ITMR.Storage.Stats.tearspeed
      
  elseif (cacheFlag == CacheFlag.CACHE_SPEED) then
    player.MoveSpeed = player.MoveSpeed + ITMR.Storage.Stats.speed
  
  elseif (cacheFlag == CacheFlag.CACHE_LUCK) then
    player.Luck = player.Luck + ITMR.Storage.Stats.luck
      
  elseif (cacheFlag == CacheFlag.CACHE_ALL) then
    player.Damage = player.Damage + ITMR.Storage.Stats.damage
    player.FireDelay = player.FireDelay + ITMR.Storage.Stats.tears
    player.ShotSpeed = player.ShotSpeed + ITMR.Storage.Stats.tearspeed
    player.MoveSpeed = player.MoveSpeed + ITMR.Storage.Stats.speed
    player.Luck = player.Luck + ITMR.Storage.Stats.luck
  end
  
end

-- Start Game callback
function callbacks:postGameStarted (fromSave)
  
  -- Reset previous game state
  _.resetState()
  
  if (fromSave) then
    Save = json.decode(Isaac.LoadModData(ITMR))
    ITMR.Cmd.send("Checking save")
    
    if (Save ~= nil and Save.Storage ~= nil) then
      
      ITMR.Cmd.send("Loading from save")
      ITMR.Storage = Save.Storage
      
      for key,value in pairs(ITMR.Items.Passive) do
        ITMR.Items.Passive[key].count = Save.ItemsCount[key]
        if (Isaac.GetPlayer(0):GetCollectibleNum(ITMR.Items.Passive[key].id) > 0) then ITMR.DynamicCallbacks.bind(ITMR.Items.Passive, key) end
      end
      
      local player = Isaac.GetPlayer(0)
      player:AddCacheFlags(CacheFlag.CACHE_ALL)
      player:EvaluateItems()
    end
  end
  
  -- Running ITMR server
  ITMR.Server:run()
  
end

-- Exit Game callback
function callbacks:preGameExit (shouldSave)
  -- Stop ITMR server
  ITMR.Server:close()
  
  -- Reset dynamic callbacks
  for cname, cval in pairs(ITMR.DynamicCallbacks) do
    if (type(cval) ~= "function") then
      cval = nil
    end
  end
  
  -- Disable shaders
  for shaderName, shader in pairs(ITMR.Shaders) do
    shader.enabled = false
  end
  
  if shouldSave == false then
    
    -- Clear current collectible items count
    for key,value in pairs(ITMR.Items.Passive) do
      ITMR.Items.Passive[key].count = 0
    end
    
    -- Reset stats
    ITMR.Storage.Stats = {
      speed = 0,
      range = 0,
      tears = 0,
      tearspeed = 0,
      damage = 0,
      luck = 0
    }
    
    -- Reset hearts
    ITMR.Storage.Hearts = {
      twitch = 0,
      rainbow = 0
    }
  else
    ITMR.Cmd.send("Saving mod data")
    
    Save = {
      Storage = ITMR.Storage,
      ItemsCount = {}
    }
    
    for key,value in pairs(ITMR.Items.Passive) do
      Save.ItemsCount[key] = ITMR.Items.Passive[key].count
    end
    
    Isaac.SaveModData(ITMR, json.encode(Save))
  end
end

-- Gameover callback
function callbacks:postGameEnd (gameover)
  
  
  
end

-- Shaders callback
function callbacks:getShaderParams (name)
  if (ITMR.Shaders[name] == nil) then return end
  
  if shaderAPI then
    shaderAPI(name, ITMR.Shaders[name].pass())
  else
    return ITMR.Shaders[name].pass()
  end
end


return callbacks