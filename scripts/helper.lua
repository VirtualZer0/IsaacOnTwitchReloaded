local helper = {}

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
      ITMR.Storage.Hearts.twitch = ITMR.Storage.Hearts.twitch + 1;
    else
      ITMR.Storage.Hearts.twitch = ITMR.Storage.Hearts.twitch + 2;
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

-- Launch event function
helper.launchEvent = function (eventName)
  
  local event = ITMR.Events[eventName]
  
  -- Create new ActiveEvent
  local ev = ITMR.Classes.ActiveEvent:new(event, eventName)
  
  -- Trigger onStart and onRoomChange callbacks, if it possible
  if ev.event.onStart ~= nil then ev.event.onStart() end
  if ev.event.onRoomChange ~= nil then ev.event.onRoomChange() end
  
  -- Bind dynamic callbacks
  ITMR.DynamicCallbacks.bind(ITMR.Events, eventName)
  
  -- Add ActiveEvent to current events storage
  table.insert(ITMR.Storage.ActiveEvents, ev)
  
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
  
  -- Reset events
  ITMR.Storage.ActiveEvents = {}
  
  -- Reset familiars
  ITMR.Storage.ActiveEvents = {}
  
end

-- Fix text (check if Russian font available)
helper.fixtext = function (text)
  if (Isaac.GetTextWidth("®") ~= 5) then
    text = helper.translitrus(text)
  else
    text = helper.fixrus(text)
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
  str = str:gsub('–Å', 'Yo')
  str = str:gsub('–ñ', 'Zh')
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
  str = str:gsub('–ß', 'Ch')
  str = str:gsub('–®', 'Sh')
  str = str:gsub('–©', 'Sch')
  str = str:gsub('–™', '|')
  str = str:gsub('–´', 'I')
  str = str:gsub('–¨', '`')
  str = str:gsub('–≠', 'E')
  str = str:gsub('–Æ', 'Yu')
  str = str:gsub('–Ø', 'Ya')
  
  return str
end

return helper