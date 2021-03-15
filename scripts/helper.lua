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
helper.giveTrinket = function (name)
  local game = Game()
  local room = game:GetRoom()
  local p = Isaac.GetPlayer(0);
  local item = Isaac.GetTrinketIdByName(name)
  p:DropTrinket(room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0, true), true)
  p:AddTrinket(item);
end

-- Give heart function
helper.giveHeart = function (name)
  
  local p = Isaac.GetPlayer(0);
  
  if name == "Red" then p:AddHearts(2)
  elseif name == "Container" then p:AddMaxHearts(2, true)
  elseif name == "Soul" then p:AddSoulHearts(2)
  elseif name == "Golden" then p:AddGoldenHearts(1)
  elseif name == "Eternal" then p:AddEternalHearts(1)
  elseif name == "Bone" then p:AddBoneHearts(1)
  elseif name == "Twitch" then
  
    -- Copying black heart mechanic
    if ( p:GetSoulHearts() % 2 == 1) then
      p:AddSoulHearts(1)
      IOTR.Storage.Hearts.twitch = IOTR.Storage.Hearts.twitch + 1;
    else
      IOTR.Storage.Hearts.twitch = IOTR.Storage.Hearts.twitch + 2;
    end
    
  elseif name == "Black" then p:AddBlackHearts(2) end
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
      local c = Isaac.Spawn(EntityType.ENTITY_ATTACKFLY, 0,  0, room:GetCenterPos(), Vector(0, 0), p)
      c:ToNPC().MaxHitPoints = p.Damage * 5
      c:ToNPC().HitPoints = p.Damage * 5
    end
    
    helper.closeDoors()
    
  elseif name == "BadSpider" then
    
    for i = 0, 5 do
      local c = Isaac.Spawn(EntityType.ENTITY_SPIDER, 0,  0, room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0, true), Vector(0, 0), p)
      c:ToNPC().MaxHitPoints = p.Damage * 5
      c:ToNPC().HitPoints = p.Damage * 5
    end
    
    helper.closeDoors()
    
  elseif name == "PrettyFly" then p:AddPrettyFly() end
  
end

-- Give pocket or effect function
helper.givePocket = function (name)
  local p = Isaac.GetPlayer(0);
  if name == "LuckUp" then p:DonateLuck(1)
  elseif name == "LuckDown" then p:DonateLuck(-1)
  elseif name == "Pill" then p:AddPill(math.random(1, PillColor.NUM_PILLS))
  elseif name == "Card" then p:AddCard(math.random(1, Card.CARD_RANDOM))
  elseif name == "Spacebar" and p:GetActiveItem() ~= CollectibleType.COLLECTIBLE_NULL then p:UseActiveItem (p:GetActiveItem(), true, true, true, true)
  elseif name == "Charge" then p:FullCharge()
  elseif name == "Discharge" then p:DischargeActiveItem() end
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
  for i = 1, CollectibleType.NUM_COLLECTIBLES do
    local rawItem = iconf:GetCollectible(i)
    if rawItem == nil then goto skipIteration end
    
    -- Save only basic fields
    local item = {
      id = rawItem.ID,
      name = rawItem.Name,
      special = rawItem.Special
    }
    
    -- Check item type and push to storage
    if (rawItem.Type == ItemType.ITEM_PASSIVE) then table.insert(content.passive, item)
    elseif (rawItem.Type == ItemType.ITEM_ACTIVE) then table.insert(content.active, item)
    elseif (rawItem.Type == ItemType.ITEM_TRINKET) then table.insert(content.trinkets, item)
    elseif (rawItem.Type == ItemType.ITEM_FAMILIAR) then table.insert(content.familiars, item)
    end
  
  ::skipIteration::
  end
  
  -- Get all IOTR events
  for key, rawEvent in pairs(IOTR.Events) do
    local event = {
      name = IOTR.Locale[IOTR.Settings.lang]["ev" .. rawEvent.name .. "Name"],
      desc = IOTR.Locale[IOTR.Settings.lang]["ev" .. rawEvent.name .. "Desc"],
      weights = rawEvent.weights,
      good = rawEvent.good
    }
    
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
    Isaac.GetPlayer(0):AnimateHappy()
  else
    Isaac.GetPlayer(0):AnimateSad()
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

-- Check if Russian font available
helper.checkRussianFont = function ()
  if (Isaac.GetTextWidth("®") ~= 5) then
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
  str = str:gsub('–∞', '‡')
  str = str:gsub('–±', '·')
  str = str:gsub('–≤', '‚')
  str = str:gsub('–≥', '„')
  str = str:gsub('–¥', '‰')
  str = str:gsub('–µ', 'Â')
  str = str:gsub('—ë', '∏')
  str = str:gsub('–∂', 'Ê')
  str = str:gsub('–∑', 'Á')
  str = str:gsub('–∏', 'Ë')
  str = str:gsub('–π', 'È')
  str = str:gsub('–∫', 'Í')
  str = str:gsub('–ª', 'Î')
  str = str:gsub('–º', 'Ï')
  str = str:gsub('–Ω', 'Ì')
  str = str:gsub('–æ', 'Ó')
  str = str:gsub('–ø', 'Ô')
  str = str:gsub('—Ä', '')
  str = str:gsub('—Å', 'Ò')
  str = str:gsub('—Ç', 'Ú')
  str = str:gsub('—É', 'Û')
  str = str:gsub('—Ñ', 'Ù')
  str = str:gsub('—Ö', 'ı')
  str = str:gsub('—Ü', 'ˆ')
  str = str:gsub('—á', '˜')
  str = str:gsub('—à', '¯')
  str = str:gsub('—â', '˘')
  str = str:gsub('—ä', '˙')
  str = str:gsub('—ã', '˚')
  str = str:gsub('—å', '¸')
  str = str:gsub('—ç', '˝')
  str = str:gsub('—é', '˛')
  str = str:gsub('—è', 'ˇ')
  
  str = str:gsub('–ê', '¿')
  str = str:gsub('–ë', '¡')
  str = str:gsub('–í', '¬')
  str = str:gsub('–ì', '√')
  str = str:gsub('–î', 'ƒ')
  str = str:gsub('–ï', '≈')
  str = str:gsub('–Å', '®')
  str = str:gsub('–ñ', '∆')
  str = str:gsub('–ó', '«')
  str = str:gsub('–ò', '»')
  str = str:gsub('–ô', '…')
  str = str:gsub('–ö', ' ')
  str = str:gsub('–õ', 'À')
  str = str:gsub('–ú', 'Ã')
  str = str:gsub('–ù', 'Õ')
  str = str:gsub('–û', 'Œ')
  str = str:gsub('–ü', 'œ')
  str = str:gsub('–†', '–')
  str = str:gsub('–°', '—')
  str = str:gsub('–¢', '“')
  str = str:gsub('–£', '”')
  str = str:gsub('–§', '‘')
  str = str:gsub('–•', '’')
  str = str:gsub('–¶', '÷')
  str = str:gsub('–ß', '◊')
  str = str:gsub('–®', 'ÿ')
  str = str:gsub('–©', 'Ÿ')
  str = str:gsub('–™', '⁄')
  str = str:gsub('–´', '€')
  str = str:gsub('–¨', '‹')
  str = str:gsub('–≠', '›')
  str = str:gsub('–Æ', 'ﬁ')
  str = str:gsub('–Ø', 'ﬂ')
  
  return str
end

-- Convert russian letters to english translit. OH. MY. GOD.
helper.translitrus = function (str)
  str = str:gsub('–∞', 'a')
  str = str:gsub('–±', 'b')
  str = str:gsub('–≤', 'v')
  str = str:gsub('–≥', 'g')
  str = str:gsub('–¥', 'd')
  str = str:gsub('–µ', 'e')
  str = str:gsub('—ë', 'yo')
  str = str:gsub('–∂', 'zh')
  str = str:gsub('–∑', 'z')
  str = str:gsub('–∏', 'i')
  str = str:gsub('–π', 'y')
  str = str:gsub('–∫', 'k')
  str = str:gsub('–ª', 'l')
  str = str:gsub('–º', 'm')
  str = str:gsub('–Ω', 'n')
  str = str:gsub('–æ', 'o')
  str = str:gsub('–ø', 'p')
  str = str:gsub('—Ä', 'r')
  str = str:gsub('—Å', 's')
  str = str:gsub('—Ç', 't')
  str = str:gsub('—É', 'u')
  str = str:gsub('—Ñ', 'f')
  str = str:gsub('—Ö', 'h')
  str = str:gsub('—Ü', 'c')
  str = str:gsub('—á', 'ch')
  str = str:gsub('—à', 'sh')
  str = str:gsub('—â', 'sch')
  str = str:gsub('—ä', '|')
  str = str:gsub('—ã', 'i')
  str = str:gsub('—å', '`')
  str = str:gsub('—ç', 'e')
  str = str:gsub('—é', 'yu')
  str = str:gsub('—è', 'ya')
  
  str = str:gsub('–ê', 'A')
  str = str:gsub('–ë', 'B')
  str = str:gsub('–í', 'V')
  str = str:gsub('–ì', 'G')
  str = str:gsub('–î', 'D')
  str = str:gsub('–ï', 'E')
  str = str:gsub('–Å', 'YO')
  str = str:gsub('–ñ', 'ZH')
  str = str:gsub('–ó', 'Z')
  str = str:gsub('–ò', 'I')
  str = str:gsub('–ô', 'Y')
  str = str:gsub('–ö', 'K')
  str = str:gsub('–õ', 'L')
  str = str:gsub('–ú', 'M')
  str = str:gsub('–ù', 'N')
  str = str:gsub('–û', 'O')
  str = str:gsub('–ü', 'P')
  str = str:gsub('–†', 'R')
  str = str:gsub('–°', 'S')
  str = str:gsub('–¢', 'T')
  str = str:gsub('–£', 'U')
  str = str:gsub('–§', 'F')
  str = str:gsub('–•', 'H')
  str = str:gsub('–¶', 'C')
  str = str:gsub('–ß', 'CH')
  str = str:gsub('–®', 'SH')
  str = str:gsub('–©', 'SCH')
  str = str:gsub('–™', '|')
  str = str:gsub('–´', 'I')
  str = str:gsub('–¨', '`')
  str = str:gsub('–≠', 'E')
  str = str:gsub('–Æ', 'YU')
  str = str:gsub('–Ø', 'YA')
  
  return str
end

return helper