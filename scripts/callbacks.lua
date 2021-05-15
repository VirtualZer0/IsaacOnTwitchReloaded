-- Update functions for Isaac API Callbacks
local json = require('json')
local _ = require('scripts.helper')

local callbacks = {}

-- Post Update callback
function callbacks:postUpdate ()
  
  local room = Game():GetRoom()
  local level = Game():GetLevel()
  
  -- Hide text if boss screen active
  if (room:GetType() == RoomType.ROOM_BOSS and room:GetFrameCount() == 0 and not room:IsClear()) then
    IOTR.GameState.renderSpecial = false
  else
    IOTR.GameState.renderSpecial = true
  end
  
  -- Call timers
  IOTR.Timers.tick()
  
  -- Update text position on progress bar
  IOTR.ProgressBar.updateText()
  
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
  
  -- Check player trinkets
  local player = Isaac.GetPlayer(0)
  for key, trinket in pairs(IOTR.Items.Trinkets) do
    
    if (player:HasTrinket(trinket.id) and not trinket.hold) then
      
      IOTR.DynamicCallbacks.bind(IOTR.Items.Trinkets, key)
      
      trinket.hold = true
      if trinket.onPickup ~= nil then trinket.onPickup() end
      
    elseif (not player:HasTrinket(trinket.id) and trinket.hold) then
      
      IOTR.DynamicCallbacks.unbind(IOTR.Items.Trinkets, key)
      
      trinket.hold = false
      if trinket.onRemove ~= nil then trinket.onRemove() end
      
    end
    
  end
  
  -- Check if "Open site" button spawned and pressed
  if IOTR.GameState.openSiteButtonState == 0
    and level:GetStage() == LevelStage.STAGE1_1
    and level:GetStartingRoomIndex() == level:GetCurrentRoomIndex()
  then
    local button = room:GetGridEntityFromPos(Vector(510, 370))
    local textPos = Isaac.WorldToRenderPosition(button.Position, true) + Vector.Zero
    IOTR.Text.add("openSiteButton", "Open site", textPos, {r=.549,g=.27,b=.968,a=1}, nil, true)
    
    if (button.State == 3) then
      IOTR.GameState.openSiteButtonState = 1
      IOTR.Sounds.play(SoundEffect.SOUND_GOLD_HEART)
      
      for i = 1, 8 do
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.NAIL_PARTICLE,  0, button.Position, RandomVector()*2, nil)
      end
      
      IOTR.Text.remove("openSiteButton")
      room:RemoveGridEntity(button:GetGridIndex(), 0, false)
      
      IOTR.Timers.addTimeout(function ()
        local os = require("os")
        os.execute("start https://isaacontwitch.com")
        os.execute("open https://isaacontwitch.com")
      end, 25)
    end
  end
end


-- Post Render Callback
function callbacks:postRender ()
  
  -- Delay between server check requests, for more performance
  if (Isaac.GetFrameCount() % 4 == 0) then
    
    -- Check game state
    if (IOTR.GameState.paused and not Game():IsPaused()) then
      IOTR.GameState.paused = false
      IOTR.Server.addOutput({
        c = "changeGameState",
        d = { paused = false }
        
      })
    end
    
    if (not IOTR.GameState.paused and Game():IsPaused()) then
      IOTR.GameState.paused = true
      IOTR.Server.addOutput({
        c = "changeGameState",
        d = { paused = true }
      })
    end
  
    IOTR.Server:update()
  end
  
  -- Update ScreenSize, because window can be resized during game
  if (Isaac.GetFrameCount() % 30 == 0) then
    IOTR.GameState.screenSize = (Isaac.WorldToScreen (Vector (320, 280)) - Game ():GetRoom ():GetRenderScrollOffset() - Game().ScreenShakeOffset) * 2
  end
  
  -- Check boss screen
  if (Game():GetRoom():GetType() == RoomType.ROOM_BOSS and Game():GetRoom():GetFrameCount() == 0) then
    IOTR.GameState.renderSpecial = false
  else
    IOTR.GameState.renderSpecial = true
  end
  
  -- Render progress bar
  IOTR.ProgressBar.render()
  
  -- Render poll frames
  IOTR.Pollframes.render()
  
  -- Render text
  IOTR.Text.render()
  
end

function callbacks:postNPCInit (entity)
  
  if entity:IsBoss() and #IOTR.GameState.randomNames > 0 then
    
    entity = entity:ToNPC()
      
      if
      (entity.SpawnerEntity ~= nil and entity.SpawnerEntity:IsBoss())
      or (entity.ParentNPC ~= nil and entity.ParentNPC:IsBoss())
      or (entity.Type == EntityType.ENTITY_BIG_HORN and entity.Variant ~= 0)
      then return end
      
      local color = {
        r = IOTR.Enums.Rainbow[1].R,
        g = IOTR.Enums.Rainbow[1].G,
        b = IOTR.Enums.Rainbow[1].B,
        a = 1
      }
      
      local textId = 'boss'..math.random(0,9999)..entity.Type;      
      
      IOTR.Text.add(textId, table.remove(IOTR.GameState.randomNames, math.random(#IOTR.GameState.randomNames)), nil, color)
      IOTR.Text.follow(textId, entity)
      
    end
end

-- Room change callback
function callbacks:postNewRoom ()
  local level = Game():GetLevel()
  local room = Game():GetRoom()
  
  -- Update events countdown with byTime == false
  for key,value in pairs(IOTR.Storage.ActiveEvents) do
    if value.event.byTime == false then
      
      if (value.currentTime > 0) then
        if (value.event.onlyNewRoom ~= nil and value.event.onlyNewRoom) then
          if (not Game():GetRoom():IsClear()) then value.currentTime = value.currentTime - 1 end
        else
          value.currentTime = value.currentTime - 1
        end
      else
        -- Trigger onEnd callback, if it possible
        if value.event.onEnd ~= nil then value.event.onEnd() end
        
        -- Remove event and callbacks
        IOTR.DynamicCallbacks.unbind(IOTR.Events, value.name)
        IOTR.Storage.ActiveEvents[key] = nil
      end
      
    end
  end
  
  -- Set clear for starting room, if open site button spawned
  if IOTR.GameState.openSiteButtonState == 0
    and level:GetStage() == LevelStage.STAGE1_1
    and level:GetStartingRoomIndex() == level:GetCurrentRoomIndex()
  then
    IOTR._.openDoors()
  elseif IOTR.GameState.openSiteButtonState == 0
    and level:GetStage() == LevelStage.STAGE1_1
    and level:GetStartingRoomIndex() ~= level:GetCurrentRoomIndex()
  then
    IOTR.Text.remove("openSiteButton")
  end
  
end

-- Evaluate Cache Callback
function callbacks:evaluateCache (player, cacheFlag)  
  
  
  if (IOTR._.hasbit(cacheFlag, CacheFlag.CACHE_DAMAGE)) then
    player.Damage = player.Damage + IOTR.Storage.Stats.damage + IOTR.Storage.Hearts.rainbow/2
  end
  
  if (IOTR._.hasbit(cacheFlag, CacheFlag.CACHE_FIREDELAY)) then
    player.MaxFireDelay = player.MaxFireDelay - IOTR.Storage.Stats.tears
    
    if (IOTR.Storage.Hearts.rainbow > 1 and player.MaxFireDelay > 3) then
      player.MaxFireDelay = player.MaxFireDelay - 1
    end
    
    if (IOTR.Storage.Hearts.rainbow > 4 and player.MaxFireDelay > 3) then
      player.MaxFireDelay = player.MaxFireDelay - 2
    end
    
  end
    
  if (IOTR._.hasbit(cacheFlag, CacheFlag.CACHE_RANGE)) then
    player.TearHeight = player.TearHeight + IOTR.Storage.Stats.range - IOTR.Storage.Hearts.rainbow*1.5
  end
  
  if (IOTR._.hasbit(cacheFlag, CacheFlag.CACHE_SHOTSPEED)) then
    player.ShotSpeed = player.ShotSpeed + IOTR.Storage.Stats.tearspeed + IOTR.Storage.Hearts.rainbow/12
  end
  
  if (IOTR._.hasbit(cacheFlag, CacheFlag.CACHE_SPEED)) then
    player.MoveSpeed = player.MoveSpeed + IOTR.Storage.Stats.speed + IOTR.Storage.Hearts.rainbow/12
  end
  
  if (IOTR._.hasbit(cacheFlag, CacheFlag.CACHE_LUCK)) then
    player.Luck = player.Luck + IOTR.Storage.Stats.luck + IOTR.Storage.Hearts.rainbow/1.5
  end
  
  if (IOTR._.hasbit(cacheFlag, CacheFlag.CACHE_FAMILIARS)) then
    for _, item in pairs(IOTR.Items.Passive) do
      if (item ~= nil and item.famId ~= nil) then
        player:CheckFamiliar(item.famId, player:GetCollectibleNum(item.id), player:GetCollectibleRNG(item.id))        
      end
    end
  end
  
end

-- Start Game callback
function callbacks:postGameStarted (fromSave)
  
  IOTR.GameState.postStartRaised = true
  
  -- Reset previous game state
  IOTR._.resetState()
  
  if (fromSave) then
    Save = json.decode(Isaac.LoadModData(IOTR.Mod))
    IOTR.Cmd.send("Checking save")
    
    if (Save ~= nil and Save.Storage ~= nil) then
      
      IOTR.Cmd.send("Loading from save")
      IOTR.Storage = Save.Storage
      
      local player = Isaac.GetPlayer(0)
      
      -- Restore items count
      for iKey, item in pairs(IOTR.Items.Passive) do
        item.count = player:GetCollectibleNum(item.id)
        
        if (item.count > 0) then
          IOTR.DynamicCallbacks.bind(IOTR.Items.Passive, iKey)
        end
      end
      
      -- Restore trinkets status
      for tKey, trinket in pairs(IOTR.Items.Trinkets) do
        trinket.hold = player:HasTrinket(trinket.id)
        
        if (trinket.hold) then
          IOTR.DynamicCallbacks.bind(IOTR.Items.Trinkets, tKey)
        end
      end
      
      -- Restore subscribers
      local entities = Isaac.GetRoomEntities()
    
      for entityKey, entity in pairs(entities) do
        if (entity.Type == EntityType.ENTITY_FAMILIAR and entity.Variant == IOTR.Mechanics.Subscribers.subscriber) then
          entity:Remove()
        end
      end
      
      for key, subscriber in pairs(IOTR.Storage.Subscribers) do
        
        local colorObj = IOTR.Enums.ChatColors[subscriber.color]
        
        subscriber.entity = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, IOTR.Mechanics.Subscribers.subscriber, 0, player.Position, Vector.Zero, player):ToFamiliar()
        subscriber.entity:GetSprite():ReplaceSpritesheet(0, "gfx/Familiar/subs/familiar_shooters_twitch_subscriber_"..subscriber.texture..".png")
        subscriber.entity:GetSprite():LoadGraphics()
        subscriber.entity:SetColor(colorObj, 0, 0, false, false)
        
        local textId = "s"..math.random(1,999)..subscriber.name
        IOTR.Text.add(textId, subscriber.name, nil, {r=colorObj.R, g=colorObj.G, b=colorObj.B, a=colorObj.A}, nil, true)
        IOTR.Text.follow(textId, subscriber.entity)
        
      end
      
      player:AddCacheFlags(CacheFlag.CACHE_ALL)
      player:EvaluateItems()
    end
  else
    -- Generate Twtich room for first floor
    IOTR.Mechanics.TwitchRoom._genTwitchRoom()
    if (not IOTR.GameState.firstRun) then
      IOTR.Text.clear()
      IOTR.ProgressBar.remove()
      IOTR.Pollframes.enabled = false
      
      IOTR.Server.addOutput({c = "newRun"})
      IOTR.Cmd.send("Request new run on Web-client")
    end
    
    IOTR._.spawnOpenSite()
  end
  
  -- Running IOTR server
  IOTR.Server:run()  
  
end

-- Exit Game callback
function callbacks:preGameExit (shouldSave)
  
  -- Stop IOTR server
  IOTR.Server:close()
  
  IOTR.GameState.firstRun = false
  IOTR.GameState.postStartRaised = false
  
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
    
    IOTR._.resetState()
    
  else
    IOTR.Cmd.send("Saving mod data")
    
    Save = {
      Storage = IOTR.Storage
    }
    
    Isaac.SaveModData(IOTR.Mod, json.encode(Save))
  end
end

-- Shaders callback
function callbacks:stageChanged ()
  if IOTR.Text.contains("openSiteButton") then
    IOTR.Text.remove("openSiteButton")
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