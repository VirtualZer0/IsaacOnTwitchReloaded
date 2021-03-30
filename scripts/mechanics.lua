local mechanics = {}
local json = require('json')

-- Twitch bits and Youtube superchat mechanics
mechanics.Bits = {
  
  bitsA = Isaac.GetEntityVariantByName ("Bits A"),
  bitsB = Isaac.GetEntityVariantByName ("Bits B"),
  bitsC = Isaac.GetEntityVariantByName ("Bits C"),
  bitsD = Isaac.GetEntityVariantByName ("Bits D"),
  bitsE = Isaac.GetEntityVariantByName ("Bits E"),
  
  onPickupCollision = function (pickup, collider, low)
    
    if (pickup:IsDead()) then return end
    
    if pickup.Variant == IOTR.Mechanics.Bits.bitsA then
      SFXManager():Play(IOTR.Sounds.list.bitsCollect, 2.5, 0, false, 1.1)
      pickup:GetSprite():Play("Collect", false)
      pickup:Die()
      IOTR.Storage.Bits.gray = IOTR.Storage.Bits.gray + (30 * 55)
      
    elseif pickup.Variant == IOTR.Mechanics.Bits.bitsB then
      SFXManager():Play(IOTR.Sounds.list.bitsCollect, 2.5, 0, false, 1.1)
      pickup:GetSprite():Play("Collect", false)
      pickup:Die()
      IOTR.Storage.Bits.purple = IOTR.Storage.Bits.purple + (30 * 55)
      
    elseif pickup.Variant == IOTR.Mechanics.Bits.bitsC then
      SFXManager():Play(IOTR.Sounds.list.bitsCollect, 2.5, 0, false, 1.1)
      pickup:GetSprite():Play("Collect", false)
      pickup:Die()
      IOTR.Storage.Bits.green = IOTR.Storage.Bits.green + (30 * 70)
      
    elseif pickup.Variant == IOTR.Mechanics.Bits.bitsD then
      SFXManager():Play(IOTR.Sounds.list.bitsCollect, 2.5, 0, false, 1.1)
      pickup:GetSprite():Play("Collect", false)
      pickup:Die()
      IOTR.Storage.Bits.blue = IOTR.Storage.Bits.blue + (30 * 85)
      
    elseif pickup.Variant == IOTR.Mechanics.Bits.bitsE then
      SFXManager():Play(IOTR.Sounds.list.bitsCollect, 2.5, 0, false, 1.1)
      pickup:GetSprite():Play("Collect", false)
      pickup:Die()
      IOTR.Storage.Bits.red = IOTR.Storage.Bits.red + (30 * 100)
    end
    
  end,
  
  onRenderUpdate = function ()
    local bitsuishift = 0
  
    if (#IOTR.Storage.ActiveEvents > 0 and IOTR.GameState.renderSpecial) then
      IOTR.Sprites.UI.EventActive:Update()
      IOTR.Sprites.UI.EventActive:Render(Vector(136 + 16*bitsuishift, 13), Vector(0,0), Vector(0,0))
      bitsuishift = bitsuishift + 1
    end
    
    if (IOTR.Storage.Bits.gray > 0 and IOTR.GameState.renderSpecial) then
      IOTR.Sprites.UI.GrayBitsActive:Update()
      IOTR.Sprites.UI.GrayBitsActive:Render(Vector(136 + 16*bitsuishift, 13), Vector(0,0), Vector(0,0))
      bitsuishift = bitsuishift + 1
    end
    
    if (IOTR.Storage.Bits.purple > 0 and IOTR.GameState.renderSpecial) then
      IOTR.Sprites.UI.PurpleBitsActive:Update()
      IOTR.Sprites.UI.PurpleBitsActive:Render(Vector(136 + 16*bitsuishift, 13), Vector(0,0), Vector(0,0))
      bitsuishift = bitsuishift + 1
    end
    
    if (IOTR.Storage.Bits.green > 0 and IOTR.GameState.renderSpecial) then
      IOTR.Sprites.UI.GreenBitsActive:Update()
      IOTR.Sprites.UI.GreenBitsActive:Render(Vector(136 + 16*bitsuishift, 13), Vector(0,0), Vector(0,0))
      bitsuishift = bitsuishift + 1
    end
    
    if (IOTR.Storage.Bits.blue > 0 and IOTR.GameState.renderSpecial) then
      IOTR.Sprites.UI.BlueBitsActive:Update()
      IOTR.Sprites.UI.BlueBitsActive:Render(Vector(136 + 16*bitsuishift, 13), Vector(0,0), Vector(0,0))
      bitsuishift = bitsuishift + 1
    end
    
    if (IOTR.Storage.Bits.red > 0 and IOTR.GameState.renderSpecial) then
      IOTR.Sprites.UI.RedBitsActive:Update()
      IOTR.Sprites.UI.RedBitsActive:Render(Vector(136 + 16*bitsuishift, 13), Vector(0,0), Vector(0,0))
      bitsuishift = bitsuishift + 1
    end
  end,
  
  onUpdate = function ()
    
    local p = Isaac.GetPlayer(0)
    
    if (IOTR.Storage.Bits.gray > 0) then
      IOTR.Storage.Bits.gray = IOTR.Storage.Bits.gray - 1
      if (math.random(1,35) == 1) and (p:GetFireDirection() ~= Direction.NO_DIRECTION) then
        local t = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, p.Position, Vector(p:GetShootingInput().X*10, p:GetShootingInput().Y*10), p):ToTear()
        t:ChangeVariant(TearVariant.METALLIC)
        t.TearFlags = IOTR._.setbit(t.TearFlags, TearFlags.TEAR_SPECTRAL)
        t.TearFlags = IOTR._.setbit(t.TearFlags, TearFlags.TEAR_PIERCING)
      end
    end
    
    if (IOTR.Storage.Bits.purple > 0) then
      IOTR.Storage.Bits.purple = IOTR.Storage.Bits.purple - 1
      if (math.random(1,30) == 1) and (p:GetFireDirection() ~= Direction.NO_DIRECTION) then
        local t = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, p.Position, Vector(p:GetShootingInput().X*10, p:GetShootingInput().Y*10), p):ToTear()
        t:ChangeVariant(TearVariant.METALLIC)
        t:SetColor(Color(0.741, 0.388, 1, 1, 37, 19, 50), 0, 0, false, false)
        t.TearFlags = IOTR._.setbit(t.TearFlags, TearFlags.TEAR_HOMING)
        t.TearFlags = IOTR._.setbit(t.TearFlags, TearFlags.TEAR_FEAR)
      end
    end
    
    if (IOTR.Storage.Bits.green > 0) then
      IOTR.Storage.Bits.green = IOTR.Storage.Bits.green - 1
      if (math.random(1,25) == 1) and (p:GetFireDirection() ~= Direction.NO_DIRECTION) then
        local t = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, p.Position, Vector(p:GetShootingInput().X*10, p:GetShootingInput().Y*10), p):ToTear()
        t:ChangeVariant(TearVariant.METALLIC)
        t:SetColor(Color(0.004, 0.898, 0.659, 1, 0, 44, 32), 0, 0, false, false)
        t.TearFlags = IOTR._.setbit(t.TearFlags, TearFlags.TEAR_POISON)
        t.TearFlags = IOTR._.setbit(t.TearFlags, TearFlags.TEAR_BLACK_HP_DROP)
        t.TearFlags = IOTR._.setbit(t.TearFlags, TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP)
        t.TearFlags = IOTR._.setbit(t.TearFlags, TearFlags.TEAR_BOUNCE)
      end
    end
    
    if (IOTR.Storage.Bits.blue > 0) then
      IOTR.Storage.Bits.blue = IOTR.Storage.Bits.blue - 1
      if (math.random(1,20) == 1) and (p:GetFireDirection() ~= Direction.NO_DIRECTION) then
        local t = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, p.Position, Vector(p:GetShootingInput().X*10, p:GetShootingInput().Y*10), p):ToTear()
        t:ChangeVariant(TearVariant.METALLIC)
        t:SetColor(Color(0.149, 0.416, 0.804, 1, 7, 20, 40), 0, 0, false, false)
        t.TearFlags = IOTR._.setbit(t.TearFlags, TearFlags.TEAR_WAIT)
        t.TearFlags = IOTR._.setbit(t.TearFlags, TearFlags.TEAR_GLOW)
      end
    end
    
    if (IOTR.Storage.Bits.red > 0) then
      IOTR.Storage.Bits.red = IOTR.Storage.Bits.red - 1
      if (math.random(1,15) == 1) and (p:GetFireDirection() ~= Direction.NO_DIRECTION) then
        local t = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, p.Position, Vector(p:GetShootingInput().X*10, p:GetShootingInput().Y*10), p):ToTear()
        t:ChangeVariant(TearVariant.METALLIC)
        t:SetColor(Color(0.988, 0.345, 0.306, 1, 49, 17, 15), 0, 0, false, false)
        t.TearFlags = IOTR._.setbit(t.TearFlags, TearFlags.TEAR_PERSISTENT)
        t.TearFlags = IOTR._.setbit(t.TearFlags, TearFlags.TEAR_QUADSPLIT)
        t.TearFlags = IOTR._.setbit(t.TearFlags, TearFlags.TEAR_BURN)
        t.TearFlags = IOTR._.setbit(t.TearFlags, TearFlags.TEAR_HORN)
        t.TearFlags = IOTR._.setbit(t.TearFlags, TearFlags.TEAR_BELIAL)
        t.TearFlags = IOTR._.setbit(t.TearFlags, TearFlags.TEAR_GROW)
      end
    end
  end
  
}

-- Twitch hearts mechanics
mechanics.TwitchHearts = {
  
  twitchHeart = Isaac.GetEntityVariantByName("Twitch Heart"),
  rainbowHeart = Isaac.GetEntityVariantByName("Twitch Rainbow Heart"),
  
  cooldown = 0,
  
  onUpdate = function ()
    
    if (IOTR.Mechanics.TwitchHearts.cooldown > 0) then
      IOTR.Mechanics.TwitchHearts.cooldown = IOTR.Mechanics.TwitchHearts.cooldown - 1
    end
    
    local p = Isaac.GetPlayer(0)
    if (IOTR.Storage.Hearts.twitch > 0) then
      
      if ((p:GetMaxHearts()+ p:GetBoneHearts() + p:GetSoulHearts() + IOTR.Storage.Hearts.twitch) /2 > 12) then
        IOTR.Storage.Hearts.twitch = (12 - (p:GetBoneHearts() + (p:GetMaxHearts() + p:GetSoulHearts())/2))*2
      end
      if (p:GetSoulHearts()%2 == 1) then
        p:AddSoulHearts(1)
        IOTR.Storage.Hearts.twitch = IOTR.Storage.Hearts.twitch - 1
      end
      
    end
    
    if (IOTR.Storage.Hearts.rainbow > 0) then
      
      IOTR.Shaders.IOTR_Rainbow.enabled = true
      
      if ((p:GetMaxHearts()+ p:GetBoneHearts() + p:GetSoulHearts() + IOTR.Storage.Hearts.twitch + IOTR.Storage.Hearts.rainbow) /2 > 12) then
        IOTR.Storage.Hearts.rainbow = (12 - (p:GetBoneHearts() + (p:GetMaxHearts() + p:GetSoulHearts() + IOTR.Storage.Hearts.twitch)/2))*2
        local p = Isaac.GetPlayer(0)
        p:AddCacheFlags(CacheFlag.CACHE_ALL)
        p:EvaluateItems()
      end
      
      if (IOTR.Storage.Hearts.twitch%2 == 1) then
        IOTR.Storage.Hearts.twitch = IOTR.Storage.Hearts.twitch + 1
        IOTR.Storage.Hearts.rainbow = IOTR.Storage.Hearts.rainbow - 1
      end
      
      if (p:GetSoulHearts()%2 == 1 and IOTR.Storage.Hearts.rainbow > 0) then
        p:AddSoulHearts(1)
        IOTR.Storage.Hearts.rainbow = IOTR.Storage.Hearts.rainbow - 1
      end
    else
      IOTR.Shaders.IOTR_Rainbow.enabled = false
    end
  end,
  
  onRenderUpdate = function ()
    if (IOTR.Storage.Hearts.twitch > 0 and Game():GetLevel():GetCurses () ~= LevelCurse.CURSE_OF_THE_UNKNOWN and IOTR.GameState.renderSpecial) then
      local p = Isaac.GetPlayer(0)
      local twfull = IOTR.Storage.Hearts.twitch/2
      local ishalf = (IOTR.Storage.Hearts.twitch % 2 == 1)
      local hearts = (p:GetMaxHearts() + p:GetSoulHearts()) /2 + p:GetBoneHearts()
      local zv = Vector(0,0)
      local TopVector = zv
      
      if (hearts > 6) then line = 1 end
      if (ishalf) then twfull = twfull + 1 end
      if (line == 1) then offset = hearts - 6 else offset = hearts end
      
      for i=hearts+1, (hearts+twfull) do
        if (i < 7) then
          TopVector = Vector((i-1)*12 + 48, 12)
        else
          TopVector = Vector((i-7)*12 + 48, 22)
        end
          
        if (not ishalf or i < hearts+twfull-1) then
          IOTR.Sprites.UI.TwitchHeart:Render(TopVector, zv, zv)
        else
          IOTR.Sprites.UI.TwitchHeartHalf:Render(TopVector, zv, zv)
        end
      end
    end
    
    if (IOTR.Storage.Hearts.rainbow > 0 and Game():GetLevel():GetCurses () ~= LevelCurse.CURSE_OF_THE_UNKNOWN and IOTR.GameState.renderSpecial) then
      local p = Isaac.GetPlayer(0)
      local twfull = IOTR.Storage.Hearts.rainbow/2
      local ishalf = (IOTR.Storage.Hearts.rainbow % 2 == 1)
      local hearts = (IOTR.Storage.Hearts.twitch + p:GetMaxHearts() + p:GetSoulHearts()) /2 + p:GetBoneHearts()
      local zv = Vector(0,0)
      local TopVector = zv
      
      if (hearts > 6) then line = 1 end
      if (ishalf) then twfull = twfull + 1 end
      if (line == 1) then offset = hearts - 6 else offset = hearts end
      
      for i=hearts+1, (hearts+twfull) do
        if (i < 7) then
          TopVector = Vector((i-1)*12 + 48, 12)
        else
          TopVector = Vector((i-7)*12 + 48, 22)
        end
          
        if (not ishalf or i < hearts+twfull-1) then
          IOTR.Sprites.UI.RainbowHeart:Render(TopVector, zv, zv)
        else
          IOTR.Sprites.UI.RainbowHeartHalf:Render(TopVector, zv, zv)
        end
      end
    end
    
    if (Isaac.GetFrameCount() % 5 == 0) then
      IOTR.Sprites.UI.RainbowHeart:Update()
      IOTR.Sprites.UI.RainbowHeartHalf:Update()
    end
  end,
  
  onPickupCollision = function(pickup, collider, low)
    local p = Isaac.GetPlayer(0)
    
    -- Pickup twitch heart
    if pickup.Variant == IOTR.Mechanics.TwitchHearts.twitchHeart
    and p:GetPlayerType() ~= PlayerType.PLAYER_THELOST
    and p:GetPlayerType() ~= PlayerType.PLAYER_KEEPER
    and not ((p:GetMaxHearts() + p:GetSoulHearts() + IOTR.Storage.Hearts.twitch + p:GetBoneHearts()) >= 24)
    and not pickup:IsDead()
    then
      SFXManager():Play(SoundEffect.SOUND_BOSS2_BUBBLES, 1, 0, false, 1)
      pickup:GetSprite():Play("Collect", true)
      pickup:Die()
      if ((p:GetMaxHearts() + p:GetSoulHearts()) /2 ~= 12) then
        if ( p:GetSoulHearts() % 2 == 1) then
          p:AddSoulHearts(1)
          IOTR.Storage.Hearts.twitch = IOTR.Storage.Hearts.twitch + 1;
        else
          IOTR.Storage.Hearts.twitch = IOTR.Storage.Hearts.twitch + 2;
        end
      end
      
    -- Pickup rainbow heart
    elseif pickup.Variant == IOTR.Mechanics.TwitchHearts.rainbowHeart
    and p:GetPlayerType() ~= PlayerType.PLAYER_THELOST
    and p:GetPlayerType() ~= PlayerType.PLAYER_KEEPER
    and not ((p:GetMaxHearts() + p:GetSoulHearts() + IOTR.Storage.Hearts.twitch + p:GetBoneHearts() + IOTR.Storage.Hearts.rainbow) >= 24)
    and not pickup:IsDead()
    then
      SFXManager():Play(SoundEffect.SOUND_BOSS2_BUBBLES, 1, 0, false, 1)
      pickup:GetSprite():Play("Collect", true)
      pickup:Die()
      if ((IOTR.Storage.Hearts.twitch + p:GetMaxHearts() + p:GetSoulHearts()) /2 ~= 12) then
        local heartAmount = 2
        
        if (IOTR.Storage.Hearts.twitch % 2 == 1) then
          IOTR.Storage.Hearts.twitch = IOTR.Storage.Hearts.twitch + 1
          heartAmount = heartAmount - 1
        end
        
        if (p:GetSoulHearts() % 2 == 1) then
          p:AddSoulHearts(1)
          heartAmount = heartAmount - 1
        end
        
        IOTR.Storage.Hearts.rainbow = IOTR.Storage.Hearts.rainbow + heartAmount
      end
      
      p:AddCacheFlags(CacheFlag.CACHE_ALL)
      p:EvaluateItems()
    end
    
  end,
  
  onDamage = function (entity, damageAmnt, damageFlag, damageSource, damageCountdown)
    
    if (entity.Type ~= EntityType.ENTITY_PLAYER) then return end
    
    if (damageFlag == DamageFlag.DAMAGE_FAKE and damageAmnt < 1) then
      return true
    end
  
    if (IOTR.Mechanics.TwitchHearts.cooldown > 0) then return false end
    
    local resultDamage = damageAmnt
    local getDamage = true
    
    if (IOTR.Storage.Hearts.rainbow > 0) then
      
      getDamage = false
      
      -- Remove half of heart and round damage
      if (resultDamage % 2 == 1 and IOTR.Storage.Hearts.rainbow % 2 == 1) then
        IOTR.Mechanics.TwitchHearts._launchRainbowHeartBreak()
        IOTR.Storage.Hearts.rainbow = IOTR.Storage.Hearts.rainbow - 1
        resultDamage = resultDamage - 1
      elseif (resultDamage % 2 == 1) then
        IOTR.Storage.Hearts.rainbow = IOTR.Storage.Hearts.rainbow - 1
        resultDamage = resultDamage - 1
      end
      
      if (resultDamage > 0) then
        local lostHearts = 0
        
        if (resultDamage > IOTR.Storage.Hearts.rainbow) then
          lostHearts = math.ceil(IOTR.Storage.Hearts.rainbow/2)
          resultDamage = resultDamage - IOTR.Storage.Hearts.rainbow
          IOTR.Storage.Hearts.rainbow = 0
        else
          lostHearts = math.ceil(resultDamage / 2)
          IOTR.Storage.Hearts.rainbow = IOTR.Storage.Hearts.rainbow - resultDamage
          resultDamage = 0
          IOTR.Mechanics.TwitchHearts.cooldown = 45
        end
        
        for i = 0, lostHearts-1 do
          IOTR.Mechanics.TwitchHearts._launchRainbowHeartBreak()
        end
      else
        getDamage = false
        IOTR.Mechanics.TwitchHearts.cooldown = 45
      end
      
      entity:ToPlayer():AddCacheFlags(CacheFlag.CACHE_ALL)
      entity:ToPlayer():EvaluateItems()
      
    end
    
    if (IOTR.Storage.Hearts.twitch > 0) then
      
      getDamage = false
      
      -- Remove half of heart and round damage
      if (resultDamage % 2 == 1 and IOTR.Storage.Hearts.twitch % 2 == 1) then
        IOTR.Mechanics.TwitchHearts._launchTwitchHeartBreak()
        IOTR.Storage.Hearts.twitch = IOTR.Storage.Hearts.twitch - 1
        resultDamage = resultDamage - 1
      elseif (resultDamage % 2 == 1) then
        IOTR.Storage.Hearts.twitch = IOTR.Storage.Hearts.twitch - 1
        resultDamage = resultDamage - 1
      end
      
      if (resultDamage > 0) then
        local lostHearts = 0
        
        if (resultDamage > IOTR.Storage.Hearts.twitch) then
          lostHearts = math.ceil(IOTR.Storage.Hearts.twitch/2)
          resultDamage = resultDamage - IOTR.Storage.Hearts.twitch
          IOTR.Storage.Hearts.twitch = 0
        else
          lostHearts = math.ceil(resultDamage / 2)
          IOTR.Storage.Hearts.twitch = IOTR.Storage.Hearts.twitch - resultDamage
          resultDamage = 0
          IOTR.Mechanics.TwitchHearts.cooldown = 45
        end
        
        for i = 0, lostHearts-1 do
          IOTR.Mechanics.TwitchHearts._launchTwitchHeartBreak()
        end
      else
        getDamage = false
        IOTR.Mechanics.TwitchHearts.cooldown = 45
      end
      
      
    end
    
    if (resultDamage == 0 and not getDamage) then
      entity:ToPlayer():TakeDamage(0, DamageFlag.DAMAGE_FAKE, EntityRef(entity), damageCountdown)
    elseif (resultDamage > 0 and not getDamage) then
      entity:ToPlayer():TakeDamage(resultDamage, damageFlag, damageSource, damageCountdown)
    end
    
    return getDamage
    
  end,
  
  _launchRainbowHeartBreak = function ()
    local p = Isaac.GetPlayer(0)
    
    for i=1,#IOTR.Enums.Rainbow do
      local laser = EntityLaser.ShootAngle(8, p.Position, i*51.42, 15*30, Vector(0,0), p)
      laser:SetActiveRotation(1, 999360, 5, false)
      laser.CollisionDamage = 1;
      laser:SetColor(IOTR.Enums.Rainbow[i], 0, 0, false, false)
      
      Game():SpawnParticles(
        p.Position,
        EffectVariant.HALLOWED_GROUND,
        1, 0, IOTR.Enums.Rainbow[i], 0
      )
      
      for j = 1, 10 do
        Game():SpawnParticles(
          p.Position:__add(Vector(math.random(-60, 60), math.random(-60, 60))),
          EffectVariant.BUTTERFLY,
          1, 0, IOTR.Enums.Rainbow[i], 0
        )
      end
    end
  end,

  _launchTwitchHeartBreak = function ()
    local p = Isaac.GetPlayer(0)
    
    for i=0,4 do
      local spider = Isaac.Spawn(EntityType.ENTITY_SPIDER, 0,  0, p.Position, Vector(0, 0), p)
      spider.CollisionDamage = p.Damage * 3
      spider:AddCharmed(-1)
      spider:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
      spider:SetColor(Color(0.392, 0.255, 0.643, 1, 39, 25, 64), 0, 0, false, false)
      
      local ball = Isaac.Spawn(EntityType.ENTITY_LITTLE_HORN, 1,  0, p.Position, Vector(0, 0), p)
      ball:ToNPC().Scale = .8
      ball.MaxHitPoints = ball.MaxHitPoints * 3
      ball.HitPoints = ball.HitPoints * 3
      ball.CollisionDamage = p.Damage * 3
      ball:AddCharmed(-1)
      ball:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
      ball:SetColor(Color(0.392, 0.255, 0.643, 1, 39, 25, 64), 0, 0, false, false)
    end
    
    Game():SpawnParticles(p.Position, EffectVariant.PLAYER_CREEP_HOLYWATER, 1, 0, Color(0.392, 0.255, 0.643, 1, 1, 1, 1), 0)
    
    for i = 0, 15 do
      Game():SpawnParticles(p.Position, EffectVariant.WISP, 1, 0, Color(0.392, 0.255, 0.643, 1, 1, 1, 1), 0)
    end
  end,
}

-- Twitch room generation
mechanics.TwitchRoom = {
  twitchRoomPool = nil,
  twitchRoomChance = 25,
  
  onRoomChange = function ()
    local level = Game():GetLevel()
    local room = Game():GetRoom()
    
    if level:GetCurrentRoomIndex() == IOTR.Storage.Special.twitchRoomId then
      IOTR.Mechanics.TwitchRoom._createTwitchRoom(room:IsFirstVisit())
    end
    
  end,
  
  onStageChange = function ()
    
    if not IOTR.GameState.postStartRaised then return end
    IOTR.Mechanics.TwitchRoom._genTwitchRoom()
    
  end,
  
  _genTwitchRoom = function ()
    if (math.random(1,100) <= IOTR.Mechanics.TwitchRoom.twitchRoomChance) then
      local rooms = Game():GetLevel():GetRooms()
      local roomCandidates = {}
      
      for i = 0, rooms.Size - 1 do
        
        local room = rooms:Get(i).Data
        
        if (room.Type == RoomType.ROOM_DEFAULT)
        and (Game():GetLevel():GetStartingRoomIndex() ~= rooms:Get(i).GridIndex)
        and (room.Shape == RoomShape.ROOMSHAPE_1x1)
        then
          table.insert(roomCandidates, rooms:Get(i))
        end
        
      end
      
      if #roomCandidates == 0 then
        IOTR.Cmd.send("Twitch room gen is impossible")
        return
      end
      
      local selectedRoom = roomCandidates[math.random(#roomCandidates)]
      IOTR.Storage.Special.twitchRoomId = selectedRoom.GridIndex
      IOTR.Cmd.send("Twitch room gen on " .. IOTR.Storage.Special.twitchRoomId)
    else
      IOTR.Cmd.send("Twitch room gen skipped")
    end
  end,
  
  _createTwitchRoom = function (firstVisit)
    
    local room = Game():GetRoom()
    
    if room:GetType() ~= RoomType.ROOM_DEFAULT then return end
    
    for _, entity in ipairs(Isaac.GetRoomEntities()) do
      
      -- Disable if this is boss room
      if (entity.Type == EntityType.ENTITY_MOM or entity.Type == EntityType.ENTITY_MOMS_HEART) then
        IOTR.Storage.Special.twitchRoomId = nil
        return
      end
      
      if ((entity.Type > 8 or entity.Type == 3) and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)) then
        entity:Remove()
      end
    end
    
    local g = Game()
    
    for index = 1, room:GetGridSize() do
      local grid = room:GetGridEntity(index)
      if grid then
        local type = grid.Desc.Type
        if type ~= GridEntityType.GRID_DOOR and type ~= GridEntityType.GRID_WALL then
          room:RemoveGridEntity(index, 0, false)
        end
      end
    end
    
    room:SetFloorColor(Color(0, 0, 0, 1, -40, -40, 40))
    room:SetWallColor(Color(0, 0, 0, 1, -40, -40, 40))
    
    -- Flames
    g:SpawnParticles(room:GetGridPosition(16), EffectVariant.BLUE_FLAME, 1, 0, Color(0.392, 0.255, 0.643, 1, 392, 255, 643), 0)
    g:SpawnParticles(room:GetGridPosition(28), EffectVariant.BLUE_FLAME, 1, 0, Color(0.392, 0.255, 0.643, 1, 392, 255, 643), 0)
    g:SpawnParticles(room:GetGridPosition(106), EffectVariant.BLUE_FLAME, 1, 0, Color(0.392, 0.255, 0.643, 1, 392, 255, 643), 0)
    g:SpawnParticles(room:GetGridPosition(118), EffectVariant.BLUE_FLAME, 1, 0, Color(0.392, 0.255, 0.643, 1, 392, 255, 643), 0)
    
    --Beetles
    for i = 0, 2 do
      g:SpawnParticles(room:GetGridPosition(52), EffectVariant.WISP, 1, 0, IOTR.Enums.Rainbow[math.random(#IOTR.Enums.Rainbow)], 0)
      g:SpawnParticles(room:GetGridPosition(82), EffectVariant.WISP, 1, 0, IOTR.Enums.Rainbow[math.random(#IOTR.Enums.Rainbow)], 0)
      g:SpawnParticles(room:GetGridPosition(68), EffectVariant.WISP, 1, 0, IOTR.Enums.Rainbow[math.random(#IOTR.Enums.Rainbow)], 0)
      g:SpawnParticles(room:GetGridPosition(66), EffectVariant.WISP, 1, 0, IOTR.Enums.Rainbow[math.random(#IOTR.Enums.Rainbow)], 0)
    end
    
    if (not firstVisit) then return end
    
    IOTR.Sounds.play(IOTR.Sounds.list.twitchRoomAppear)
    g:SpawnParticles(room:GetGridPosition(67), EffectVariant.FIREWORKS, 1, 0, Color(1, 1, 1, 1, 0, 0, 0), 0)
      
    if (IOTR.Mechanics.TwitchRoom.twitchRoomPool == nil or #IOTR.Mechanics.TwitchRoom.twitchRoomPool.items == 0) then
      IOTR.Mechanics.TwitchRoom.twitchRoomPool = IOTR.Classes.TwitchRoomPool:new()
    end
    
    local itemnum = math.random(#IOTR.Mechanics.TwitchRoom.twitchRoomPool.items)
    local item = IOTR.Mechanics.TwitchRoom.twitchRoomPool.items[itemnum]
    IOTR.Mechanics.TwitchRoom.twitchRoomPool.items[itemnum] = nil
    
    Isaac.Spawn(5, 100, item, room:GetGridPosition(67), Vector(0,0), nil, 0)
    
    g:Spawn(EntityType.ENTITY_PICKUP, IOTR.Enums.TwitchRoomPickups[math.random(#IOTR.Enums.TwitchRoomPickups)], room:GetGridPosition(32), Vector(0,0), nil, 0, 0)
    g:Spawn(EntityType.ENTITY_PICKUP, IOTR.Enums.TwitchRoomPickups[math.random(#IOTR.Enums.TwitchRoomPickups)], room:GetGridPosition(42), Vector(0,0), nil, 0, 0)
    g:Spawn(EntityType.ENTITY_PICKUP, IOTR.Enums.TwitchRoomPickups[math.random(#IOTR.Enums.TwitchRoomPickups)], room:GetGridPosition(92), Vector(0,0), nil, 0, 0)
    g:Spawn(EntityType.ENTITY_PICKUP, IOTR.Enums.TwitchRoomPickups[math.random(#IOTR.Enums.TwitchRoomPickups)], room:GetGridPosition(102), Vector(0,0), nil, 0, 0)
  end
}

-- Subscribers control
mechanics.Subscribers = {
  subscriber = Isaac.GetEntityVariantByName("Twitch Subscriber"),
  
  onUpdate = function ()
    local lastFamPos = Isaac.GetPlayer(0).Position
    for key, value in pairs(IOTR.Storage.Subscribers) do
      -- Update subscribers position
      value.entity:FollowPosition(lastFamPos)
      lastFamPos = value.entity.Position
      
      -- Remove old subscribers
      if (value.time > 0) then
        value.time = value.time - 1
      else
        local v = math.random(1,4)*10
        Isaac.Spawn(EntityType.ENTITY_PICKUP, v,  0, value.entity.Position, Vector(0, 0), Isaac.GetPlayer(0))
        
        for i = 1, 3 do
          Game():SpawnParticles(value.entity.Position, EffectVariant.GOLD_PARTICLE, 10, 0, value.entity.Color, 0)
        end
        
        value.entity:Die()
        IOTR.Storage.Subscribers[key] = nil
      end
      
    end
  end,
  
  onFamiliarUpdate = function (entity)
    if entity.Variant ~= IOTR.Mechanics.Subscribers.subscriber then return end
    
    local	player = Isaac.GetPlayer(0)
    sprite = entity:GetSprite()
    
    if (player:GetFireDirection() ~= Direction.NO_DIRECTION) and (Game():GetFrameCount() % 35 == 0 or Game():GetFrameCount() % 35 < 12) then
      if player:GetHeadDirection() == Direction.LEFT then
        currentAnim = "ShootLeft"
        if (Game():GetFrameCount() % 35 == 0) then IOTR.Mechanics.Subscribers._shotSubscriber(entity, player:GetHeadDirection()) end
      elseif player:GetHeadDirection() == Direction.RIGHT then
        currentAnim = "ShootRight"
        if (Game():GetFrameCount() % 35 == 0) then IOTR.Mechanics.Subscribers._shotSubscriber(entity, player:GetHeadDirection()) end
      elseif player:GetHeadDirection() == Direction.UP then
        currentAnim = "ShootUp"
        if (Game():GetFrameCount() % 35 == 0) then IOTR.Mechanics.Subscribers._shotSubscriber(entity, player:GetHeadDirection()) end
      elseif player:GetHeadDirection() == Direction.DOWN then
        currentAnim = "ShootDown"
        if (Game():GetFrameCount() % 35 == 0) then IOTR.Mechanics.Subscribers._shotSubscriber(entity, player:GetHeadDirection()) end
      end
    else
      if player:GetHeadDirection() == Direction.LEFT then
        currentAnim = "FloatLeft"
      elseif player:GetHeadDirection() == Direction.RIGHT then
        currentAnim = "FloatRight"
      elseif player:GetHeadDirection() == Direction.UP then
        currentAnim = "FloatUp"
      elseif player:GetHeadDirection() == Direction.DOWN then
        currentAnim = "FloatDown"
      end
    end
    sprite:Play(currentAnim, true)
    
  end,
  
  _addSubscriber = function (name, time)
    local p = Isaac.GetPlayer(0)
    local fam = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, IOTR.Mechanics.Subscribers.subscriber, 0, p.Position, Vector(0,0), p):ToFamiliar()
    
    -- Select random texture and color
    local texture = math.random(1,7)
    local color = math.random(#IOTR.Enums.ChatColors)
    local colorObj = IOTR.Enums.ChatColors[color]
    fam:GetSprite():ReplaceSpritesheet(0, "gfx/Familiar/subs/familiar_shooters_twitch_subscriber_"..texture..".png")
    fam:GetSprite():LoadGraphics()
    fam:SetColor(colorObj, 0, 0, false, false)
    
    -- Add subscriber in table
    table.insert(IOTR.Storage.Subscribers, IOTR.Classes.Subscriber:new(fam, name, time, color, texture))
    
    -- Add follow text
    local textId = "s"..math.random(1,999)..name
    IOTR.Text.add(textId, name, nil, {r=colorObj.R, g=colorObj.G, b=colorObj.B, a=colorObj.A}, nil, true)
    IOTR.Text.follow(textId, fam)
  end,
  
  _shotSubscriber = function (familiar, dt)
    direct = Vector(0,0)
  
    if (dt == Direction.LEFT) then direct = Vector(-10, 0)
    elseif (dt == Direction.RIGHT) then direct = Vector(10, 0)
    elseif (dt == Direction.UP) then direct = Vector(0, -10)
    else direct = Vector(0, 10) end

    local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0, familiar.Position, direct, familiar):ToTear()
    tear:SetColor(familiar:GetColor(), 0, 0, false, false)
  end
}

return mechanics