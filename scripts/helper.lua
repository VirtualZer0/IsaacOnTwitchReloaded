local helper = {}

-- Helper storage
helper.Storage = {
  
  haveRussianFont = false
  
}

-- Give item function
helper.giveItem = function (name)
  local p = Isaac.GetPlayer(0);
  local item = Isaac.GetItemIdByName(name)
  p:AddCollectible(item, 0, true);
end

-- Give trinket function
helper.giveTrinket = function (id)
  local room = Game():GetRoom()
  local p = Isaac.GetPlayer(0);
  p:DropTrinket(room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0, true), true)
  p:AddTrinket(id);
end

-- Give heart function
helper.giveHeart = function (name)
  
  local p = Isaac.GetPlayer(0);
  
  if name == "halfred" then p:AddHearts(1)
  elseif name == "halfsoul" then p:AddSoulHearts(1)
  elseif name == "red" then p:AddHearts(2)
  elseif name == "soul" then p:AddSoulHearts(2)
  elseif name == "gold" then p:AddGoldenHearts(1)
  elseif name == "black" then p:AddBlackHearts(2)
  elseif name == "twitch" then IOTR.Storage.Hearts.twitch = IOTR.Storage.Hearts.twitch + 2
  elseif name == "bone" then p:AddBoneHearts(1)
  elseif name == "container" then p:AddMaxHearts(2, true)
  elseif name == "rainbow" then IOTR.Storage.Hearts.rainbow = IOTR.Storage.Hearts.rainbow + 2 end
end

-- Give pickup function
helper.givePickup = function (name, count)
  local p = Isaac.GetPlayer(0);
  if name == "Coin" then p:AddCoins(count)
  elseif name == "Bomb" then p:AddBombs(count)
  elseif name == "Key" then p:AddKeys(count) end
end

-- Give companion function
helper.giveCompanion = function (name, count)
  
  local p = Isaac.GetPlayer(0);
  local game = Game()
  local room = game:GetRoom()
  
  if name == "Spider" then
    for i = 0, 5 do
      p:AddBlueSpider(room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0, true))
    end
    
  elseif name == "Fly" then
    p:AddBlueFlies(5, room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0, true), p)
    
  elseif name == "BadFly" then
    
    for i = 0, 5 do
      local c = Isaac.Spawn(EntityType.ENTITY_ATTACKFLY, 0,  0, room:GetCenterPos(), Vector.Zero, p)
      c:ToNPC().MaxHitPoints = p.Damage * 5
      c:ToNPC().HitPoints = p.Damage * 5
    end
    
    helper.closeDoors()
    
  elseif name == "BadSpider" then
    
    for i = 0, 5 do
      local c = Isaac.Spawn(EntityType.ENTITY_SPIDER, 0,  0, room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0, true), Vector.Zero, p)
      c:ToNPC().MaxHitPoints = p.Damage * 5
      c:ToNPC().HitPoints = p.Damage * 5
    end
    
    helper.closeDoors()
    
  elseif name == "PrettyFly" then p:AddPrettyFly() end
  
end

-- Give pocket or effect function
helper.givePocket = function (name)  
  local p = Isaac.GetPlayer(0);
  
  if name == "pill" then p:AddPill(math.random(1, PillColor.NUM_PILLS-1))
  elseif name == "card" then p:AddCard(IOTR.Enums.BasicCards[math.random(#IOTR.Enums.BasicCards)])
  elseif name == "redcard" then p:AddCard(IOTR.Enums.RedCards[math.random(#IOTR.Enums.RedCards)])
  elseif name == "momcard" then p:AddCard(Card.CARD_EMERGENCY_CONTACT)
  elseif name == "humanitycard" then p:AddCard(Card.CARD_HUMANITY)
  elseif name == "rune" then p:AddCard(IOTR.Enums.Runes[math.random(#IOTR.Enums.Runes)])
  elseif name == "blackrune" then p:AddCard(Card.RUNE_BLACK)
  elseif name == "holycard" then p:AddCard(Card.CARD_HOLY)
  elseif name == "diceshard" then p:AddCard(Card.CARD_DICE_SHARD)
  elseif name == "creditcard" then p:AddCard(Card.CARD_CREDIT) end
end

-- Get all game items, trinkets and events
helper.getAllContent = function ()
  
  -- Get ItemConfig
  local iconf = Isaac.GetItemConfig()
  
  -- Create content storage
  local content = {
    passive = {},
    active = {},
    trinkets = {},
    familiars = {},
    events = {}
  }
  
  -- Get every collectible item in game
  
  -- This thing works like shit. But nothing new, whole API works like bugged undocumented shit
  -- This is the worst thing I've ever worked with
  local allItems = iconf:GetCollectibles()
  
  for i = 1, allItems.Size-1 do
    local value = iconf:GetCollectible(i)
    if value == nil then goto skipIteration end
    
    -- Save only basic fields
    local item = {
      id = value.ID,
      name = value.Name,
      special = value.Special,
      gfx = value.GfxFileName,
    }
    
    -- Check item type and push to storage
    if (value.Type == ItemType.ITEM_PASSIVE) then table.insert(content.passive, item)
    elseif (value.Type == ItemType.ITEM_ACTIVE) then table.insert(content.active, item)
    elseif (value.Type == ItemType.ITEM_FAMILIAR) then table.insert(content.familiars, item)
    end
  
    ::skipIteration::
  end


  -- Get every trinket in game
  local allTrinkets = iconf:GetTrinkets()
  for i = 1, allTrinkets.Size-1 do
    local value = iconf:GetTrinket(i)
    if value == nil then goto skipIteration end
    
    -- Save only basic fields
    local trinket = {
      id = value.ID,
      name = value.Name,
      special = value.Special,
      gfx = value.GfxFileName,
    }
    
    table.insert(content.trinkets, trinket)
  
    ::skipIteration::
  end

  
  -- Get all IOTR events
  for key, rawEvent in pairs(IOTR.Events) do
    local event = {
      id = rawEvent.name,
      name = IOTR.Locale[IOTR.Settings.lang]["ev" .. rawEvent.name .. "Name"],
      desc = IOTR.Locale[IOTR.Settings.lang]["ev" .. rawEvent.name .. "Desc"],
      weights = rawEvent.weights,
      good = rawEvent.good,
      specialTrigger = false,
      msgTrigger = false
    }
    
    if event.name == nil then
      event.name = rawEvent.name
    end
    
    if rawEvent.specialTrigger ~= nil then
      event.specialTrigger = rawEvent.specialTrigger
    end
    
    if rawEvent.msgTrigger ~= nil then
      event.msgTrigger = rawEvent.msgTrigger
    end
    
    table.insert(content.events, event)
  end
  
  return content
end

-- Get all player items
helper.getPlayerItems = function ()
  local p = Isaac.GetPlayer(0);
  if p:GetCollectibleCount() > 0 then --If the player has collectibles
      local items = {}
      for i=1, CollectibleType.NUM_COLLECTIBLES do --Iterate over all collectibles to see if the player has it
          if p:HasCollectible(i) then --If they have it add it to the table
              table.insert(items, i)
          end
      end
      
      return items;
  else
    return {};
  end
end

-- Get last available tile on line
helper.getLastAvailableCord = function (pos, direction, room)
  
  local stepX = 0
  local stepY = 0
  local curPos = Vector(pos.X, pos.Y)
  
  if      direction == Direction.LEFT   then stepX = -1
  elseif  direction == Direction.RIGHT  then stepX = 1
  elseif  direction == Direction.UP     then stepY = -1
  else    stepY = 1
  end
    
  while room:GetGridEntityFromPos(curPos) == nil and room:IsPositionInRoom(curPos, 1) do
    curPos.X = curPos.X + stepX
    curPos.Y = curPos.Y + stepY
  end
  
  curPos.X = curPos.X - stepX
  curPos.Y = curPos.Y - stepY
  
  return curPos
  
end

-- Check if entity visible and not hiding underground
helper.checkEntityInvisible = function (entity)

  local etype = entity.Type
  local sprite = entity:GetSprite()
  
  return not entity:IsVisible()
  or (entity:IsBoss() and entity.EntityCollisionClass == 0)

end
-- Launch event function
helper.launchEvent = function (eventName)
  
  local event = IOTR.Events[eventName]
  
  -- Create new ActiveEvent
  local ev = IOTR.Classes.ActiveEvent:new(event, eventName)
  
  -- Trigger onStart and onRoomChange callbacks, if it possible
  if ev.event.onStart ~= nil then ev.event.onStart() end
  if ev.event.onRoomChange ~= nil then ev.event.onRoomChange() end
  if ev.event.onNewRoom ~= nil then ev.event.onNewRoom() end
  
  -- Bind dynamic callbacks
  IOTR.DynamicCallbacks.bind(IOTR.Events, eventName)
  
  -- Add ActiveEvent to current events storage
  table.insert(IOTR.Storage.ActiveEvents, ev)
  
  -- Launch happy or bad animation
  if ev.event.good then
    IOTR.Sounds.play(SoundEffect.SOUND_THUMBSUP)
  else
    IOTR.Sounds.play(SoundEffect.SOUND_THUMBS_DOWN)
  end
  
end

-- Close doors function
helper.closeDoors = function ()
  local room = Game():GetRoom()
  
  room:SetClear(false)
  for i = 0,DoorSlot.NUM_DOOR_SLOTS-1 do
    local door = room:GetDoor(i)
    if door ~= nil then
      door:Close() 
    end
  end
end

-- Open doors function
helper.openDoors = function ()
  local room = Game():GetRoom()
  
  room:SetClear(true)
  for i = 0,DoorSlot.NUM_DOOR_SLOTS-1 do
    local door = room:GetDoor(i)
    if door ~= nil then
      door:Open() 
    end
  end
end

-- Stop all events and kill all enemies
  helper.killAllEnemiesAndStopEvents = function ()
    for k, v in pairs(IOTR.Storage.ActiveEvents) do
      v.currentTime = 0
    end
    
    for k, v in pairs(Isaac.GetRoomEntities()) do
      if (v:Exists() and v:IsActiveEnemy(false) and v.Type ~= EntityType.ENTITY_BEAST and v.Type ~= EntityType.ENTITY_DOGMA) then
        v:Die()
      end
    end
  end

-- Reset mod state
helper.resetState = function ()
  
  -- Reset stats
  IOTR.Storage = IOTR.Classes.Storage:new()
  
  -- Reset dynamic callbacks
  IOTR.DynamicCallbacks = IOTR.Classes.DynamicCallbacks:new()
  
  -- Disable shaders
  for shaderName, shader in pairs(IOTR.Shaders) do
    shader.enabled = false
  end
  
  -- Clear current collectible items count
  for key,value in pairs(IOTR.Items.Passive) do
    IOTR.Items.Passive[key].count = 0
  end
    
  
  
end

-- Spawn "Open site" button
helper.spawnOpenSite = function ()
  if not IOTR.GameState.firstRun then
    
    if (IOTR.Text.contains("openSiteButton")) then
      IOTR.Text.remove("openSiteButton")
    end
    
    IOTR.GameState.openSiteButtonState = 1
    
    return
  end
  
  local ok, socket = pcall(require, 'os')
  if ok then
    IOTR.GameState.openSiteButtonState = 0
    Isaac.GridSpawn(GridEntityType.GRID_PRESSURE_PLATE, 0, Vector(510, 370), true)
  end
  
end

-- Screen positioning
helper.getScreenCenter = function ()
  
  local room = Game():GetRoom()
  local centerOffset = (room:GetCenterPos()) - room:GetTopLeftPos()
  local pos = room:GetCenterPos()
  if centerOffset.X > 260 then
    pos.X = pos.X - 260
  end
  if centerOffset.Y > 140 then
    pos.Y = pos.Y - 140
  end
  return Isaac.WorldToRenderPosition(pos, false)
  
end

helper.getScreenBottomRight = function (offset)
  
  local pos = helper.getScreenCenter * 2
		
  if offset then
    local hudOffset = Vector(-offset * 1.6, -offset * 0.6)
    pos = pos + hudOffset
  end

  return pos
  
end

helper.getScreenBottomLeft = function (offset)
  
  local pos = Vector(0, helper.getScreenBottomRight().Y)
		
  if offset then
    local hudOffset = Vector(offset * 2.2, -offset * 1.6)
    pos = pos + hudOffset
  end
  
  return pos
  
end

helper.getScreenBottomRight = function (offset)
  
  local pos = Vector(piber20HelperMod:getScreenBottomRight().X, 0)
		
  if offset then
    local hudOffset = Vector(-offset * 2.2, offset * 1.2)
    pos = pos + hudOffset
  end

  return pos
  
end

helper.getScreenTopLeft = function (offset)
  local pos = Vector.Zero
  
  if offset then
    local hudOffset = Vector(offset * 2, offset * 1.2)
    pos = pos + hudOffset
  end
  
  return pos
end

-- Check if Russian font available
helper.checkRussianFont = function ()
  if (Isaac.GetTextWidth("¨") ~= 5) then
    helper.Storage.haveRussianFont = false;
  else
    helper.Storage.haveRussianFont = true;
  end
end

-- Fix text if Russian font available
helper.fixtext = function (text)
  if (helper.Storage.haveRussianFont) then
    text = helper.fixrus(text);
  else
    text = helper.translitrus(text);
  end
  
  return text
end


-- Convert russian letters from utf-8 to win-1251. Oh my god...
helper.fixrus = function (str)
  str = str:gsub('Ð°', 'à')
  str = str:gsub('Ð±', 'á')
  str = str:gsub('Ð²', 'â')
  str = str:gsub('Ð³', 'ã')
  str = str:gsub('Ð´', 'ä')
  str = str:gsub('Ðµ', 'å')
  str = str:gsub('Ñ‘', '¸')
  str = str:gsub('Ð¶', 'æ')
  str = str:gsub('Ð·', 'ç')
  str = str:gsub('Ð¸', 'è')
  str = str:gsub('Ð¹', 'é')
  str = str:gsub('Ðº', 'ê')
  str = str:gsub('Ð»', 'ë')
  str = str:gsub('Ð¼', 'ì')
  str = str:gsub('Ð½', 'í')
  str = str:gsub('Ð¾', 'î')
  str = str:gsub('Ð¿', 'ï')
  str = str:gsub('Ñ€', 'ð')
  str = str:gsub('Ñ', 'ñ')
  str = str:gsub('Ñ‚', 'ò')
  str = str:gsub('Ñƒ', 'ó')
  str = str:gsub('Ñ„', 'ô')
  str = str:gsub('Ñ…', 'õ')
  str = str:gsub('Ñ†', 'ö')
  str = str:gsub('Ñ‡', '÷')
  str = str:gsub('Ñˆ', 'ø')
  str = str:gsub('Ñ‰', 'ù')
  str = str:gsub('ÑŠ', 'ú')
  str = str:gsub('Ñ‹', 'û')
  str = str:gsub('ÑŒ', 'ü')
  str = str:gsub('Ñ', 'ý')
  str = str:gsub('ÑŽ', 'þ')
  str = str:gsub('Ñ', 'ÿ')
  
  str = str:gsub('Ð', 'À')
  str = str:gsub('Ð‘', 'Á')
  str = str:gsub('Ð’', 'Â')
  str = str:gsub('Ð“', 'Ã')
  str = str:gsub('Ð”', 'Ä')
  str = str:gsub('Ð•', 'Å')
  str = str:gsub('Ð', '¨')
  str = str:gsub('Ð–', 'Æ')
  str = str:gsub('Ð—', 'Ç')
  str = str:gsub('Ð˜', 'È')
  str = str:gsub('Ð™', 'É')
  str = str:gsub('Ðš', 'Ê')
  str = str:gsub('Ð›', 'Ë')
  str = str:gsub('Ðœ', 'Ì')
  str = str:gsub('Ð', 'Í')
  str = str:gsub('Ðž', 'Î')
  str = str:gsub('ÐŸ', 'Ï')
  str = str:gsub('Ð ', 'Ð')
  str = str:gsub('Ð¡', 'Ñ')
  str = str:gsub('Ð¢', 'Ò')
  str = str:gsub('Ð£', 'Ó')
  str = str:gsub('Ð¤', 'Ô')
  str = str:gsub('Ð¥', 'Õ')
  str = str:gsub('Ð¦', 'Ö')
  str = str:gsub('Ð§', '×')
  str = str:gsub('Ð¨', 'Ø')
  str = str:gsub('Ð©', 'Ù')
  str = str:gsub('Ðª', 'Ú')
  str = str:gsub('Ð«', 'Û')
  str = str:gsub('Ð¬', 'Ü')
  str = str:gsub('Ð­', 'Ý')
  str = str:gsub('Ð®', 'Þ')
  str = str:gsub('Ð¯', 'ß')
  
  return str
end

-- Convert russian letters to english translit. OH. MY. GOD.
helper.translitrus = function (str)
  str = str:gsub('Ð°', 'a')
  str = str:gsub('Ð±', 'b')
  str = str:gsub('Ð²', 'v')
  str = str:gsub('Ð³', 'g')
  str = str:gsub('Ð´', 'd')
  str = str:gsub('Ðµ', 'e')
  str = str:gsub('Ñ‘', 'yo')
  str = str:gsub('Ð¶', 'zh')
  str = str:gsub('Ð·', 'z')
  str = str:gsub('Ð¸', 'i')
  str = str:gsub('Ð¹', 'y')
  str = str:gsub('Ðº', 'k')
  str = str:gsub('Ð»', 'l')
  str = str:gsub('Ð¼', 'm')
  str = str:gsub('Ð½', 'n')
  str = str:gsub('Ð¾', 'o')
  str = str:gsub('Ð¿', 'p')
  str = str:gsub('Ñ€', 'r')
  str = str:gsub('Ñ', 's')
  str = str:gsub('Ñ‚', 't')
  str = str:gsub('Ñƒ', 'u')
  str = str:gsub('Ñ„', 'f')
  str = str:gsub('Ñ…', 'h')
  str = str:gsub('Ñ†', 'c')
  str = str:gsub('Ñ‡', 'ch')
  str = str:gsub('Ñˆ', 'sh')
  str = str:gsub('Ñ‰', 'sch')
  str = str:gsub('ÑŠ', '|')
  str = str:gsub('Ñ‹', 'i')
  str = str:gsub('ÑŒ', '`')
  str = str:gsub('Ñ', 'e')
  str = str:gsub('ÑŽ', 'yu')
  str = str:gsub('Ñ', 'ya')
  
  str = str:gsub('Ð', 'A')
  str = str:gsub('Ð‘', 'B')
  str = str:gsub('Ð’', 'V')
  str = str:gsub('Ð“', 'G')
  str = str:gsub('Ð”', 'D')
  str = str:gsub('Ð•', 'E')
  str = str:gsub('Ð', 'YO')
  str = str:gsub('Ð–', 'ZH')
  str = str:gsub('Ð—', 'Z')
  str = str:gsub('Ð˜', 'I')
  str = str:gsub('Ð™', 'Y')
  str = str:gsub('Ðš', 'K')
  str = str:gsub('Ð›', 'L')
  str = str:gsub('Ðœ', 'M')
  str = str:gsub('Ð', 'N')
  str = str:gsub('Ðž', 'O')
  str = str:gsub('ÐŸ', 'P')
  str = str:gsub('Ð ', 'R')
  str = str:gsub('Ð¡', 'S')
  str = str:gsub('Ð¢', 'T')
  str = str:gsub('Ð£', 'U')
  str = str:gsub('Ð¤', 'F')
  str = str:gsub('Ð¥', 'H')
  str = str:gsub('Ð¦', 'C')
  str = str:gsub('Ð§', 'CH')
  str = str:gsub('Ð¨', 'SH')
  str = str:gsub('Ð©', 'SCH')
  str = str:gsub('Ðª', '|')
  str = str:gsub('Ð«', 'I')
  str = str:gsub('Ð¬', '`')
  str = str:gsub('Ð­', 'E')
  str = str:gsub('Ð®', 'YU')
  str = str:gsub('Ð¯', 'YA')
  
  return str
end

-- Bitmask functions
helper.bit = function (p)
  return 2 ^ (p - 1)  -- 1-based indexing
end

helper.hasbit = function (x,p)
  return x % (p + p) >= p
end

helper.setbit = function (x,p)
  return x | p
end

helper.clearbit = function (x,p)
  return IOTR._.hasbit(x, p) and x - p or x
end

return helper