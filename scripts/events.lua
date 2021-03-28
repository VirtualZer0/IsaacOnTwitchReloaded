local events = {}
local json = require('json')
-- Example

--events.EventName = {
--
--  name,           <-- Event name, using as key for locale, then sended to isaacontwitch.com when game connected
--  weights,        <-- Array with weights for gamemodes: [easy, normal, crazy]
--  good,           <-- If true, play happy animation, else - sad animation
--  specialTrigger, <-- Contains name of special modificator dor next poling, like "russianHackers" (optionally)
--  duration,       <-- Event duration, by room or by seconds, it depends on the variable byTime. If not defined, equals 0
--  byTime,         <-- If TRUE, duration decrease every second, if FALSE - every room changing. If not defined, equals TRUE
--  onlyNewRoom     <-- if TRUE, event duration decreased only in new rooms
--  onStart,        <-- This function call when event started
--  onEnd,          <-- This function call when event ended
--  
--  Another callbacks equals DynamicCallbacks, you can see them in main.lua from line 497
--
--}

-- Richy
events.EV_Richy = {
  
  name = "Richy",
  weights = {1,1,1},
  good = true,
  
  onStart = function ()
    
    local player = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    
    room:TurnGold()
    
   for i = 0, math.random(10, 25) do
      Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN,  CoinSubType.COIN_PENNY, room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20, true), Vector(0, 0), player)
      player:DonateLuck(1)
    end
    
  end
  
}


-- Poop
events.EV_Poop = {
  
  name = "Poop",
  weights = {1,1,1},
  good = false,
  
  onStart = function ()
    
    local p = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    
    room:SetFloorColor(Color(0.424,0.243,0.063,1,-50,-50,-50))
    room:SetWallColor(Color(0.424,0.243,0.063,1,-50,-50,-50))
    
    for i = 0, math.random(20, 40) do
      local max = room:GetBottomRightPos()
      local pos = Vector(math.random(math.floor(max.X)), math.random(math.floor(max.Y)))
      pos = room:FindFreeTilePosition(pos, 0.5)
      local poop = Isaac.Spawn(EntityType.ENTITY_POOP, 0, 1, pos, Vector(math.random(-20,20)*2, math.random(-20,20)*2), nil)
      poop:ToNPC().Scale = math.random(4, 7)/10
    end
    
    for i = 0, math.random(5, 8) do
      local max = room:GetBottomRightPos()
      local pos = Vector(math.random(math.floor(max.X)), math.random(math.floor(max.Y)))
      pos = room:FindFreeTilePosition(pos, 0.5)
      local poop = Isaac.Spawn(EntityType.ENTITY_DIP, 0, 1, pos, Vector(math.random(-20,20)*2, math.random(-20,20)*2), nil)
      poop:ToNPC().Scale = math.random(4, 7)/10
    end
    
    SFXManager():Play(SoundEffect.SOUND_FART, 1, 0, false, 1)
  end
  
}


-- Hell
events.EV_Hell = {
  
  name = "Hell",
  weights = {0.9,1,1},
  good = false,
  
  onStart = function ()
    
    local entities = Isaac.GetRoomEntities()
    local player = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    
    for i = 1, #entities do
      if entities[i]:IsActiveEnemy( ) then
        entities[i]:AddBurn(EntityRef(player), 120, 0.05)
        entities[i]:AddFear(EntityRef(player), 400)
      end
    end
    
    for i = 0, room:GetGridSize()/7 do
      local max = room:GetBottomRightPos()
      local posv = Vector(math.random(math.floor(max.X)), math.random(math.floor(max.Y)))
      pos = room:FindFreeTilePosition(posv, 0.5)
      if (player.Position:Distance(posv) >= 100) then
        Isaac.GridSpawn(GridEntityType.GRID_FIREPLACE , math.random(2), pos, false)
      end
    end
    
    SFXManager():Play(SoundEffect.SOUND_DEVILROOM_DEAL, 1, 0, false, 1)
    room:EmitBloodFromWalls (60, 2)
    room:SetFloorColor(Color(0.900,0.010,0.010,1,50,-20,-20))
    room:SetWallColor(Color(0.900,0.010,0.010,1,50,-20,-20))
    
  end
  
}

-- Spiky
events.EV_Spiky = {
  
  name = "Spiky",
  weights = {0.9,1,1},
  good = false,
  
  onStart = function ()
    
    local player = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    
    for i = 0, room:GetGridSize()/7 do
      local max = room:GetBottomRightPos()
      local posv = Vector(math.random(math.floor(max.X-10)), math.random(math.floor(max.Y-10)))
      pos = room:FindFreeTilePosition(posv, 0.5)
      if (player.Position:Distance(posv) >= 100) then
        Isaac.GridSpawn(GridEntityType.GRID_SPIKES_ONOFF, math.random(2), pos, false)
      end
    end
    
    room:SetFloorColor(Color(0.4,0.4,0.4,1,50,50,50))
    room:SetWallColor(Color(0.4,0.4,0.4,1,50,50,50))
    SFXManager():Play(SoundEffect.SOUND_METAL_BLOCKBREAK, 1, 0, false, 1)
    
  end
  
}

-- Earthquake
events.EV_Earthquake = {
  
  name = "Earthquake",
  weights = {1,1,1},
  good = false,
  
  onlyNewRoom = true,
  byTime = false,
  duration = 5,
  
  onRoomChange = function ()
    Game():ShakeScreen(100)
  end,
  
  onNewRoom = function ()
    
    local g = Game()
    local	entities = Isaac.GetRoomEntities()
    local player = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    
    for i = 0, room:GetGridSize()/2 do
      local ind = math.random(room:GetGridSize())
      local pos = room:GetGridPosition(ind)
      room:DestroyGrid(ind)
      g:SpawnParticles(pos, EffectVariant.ROCK_PARTICLE, math.random(6), math.random(), Color(0.235, 0.176, 0.122, 1, 25, 25, 25), math.random())
    end
    
    for i = 1, #entities do
      if entities[i]:IsActiveEnemy() and math.random(1,3) == 2 then
        local ref = EntityRef(entities[i])
        g:SpawnParticles(ref.Position, EffectVariant.SHOCKWAVE_RANDOM, 1, math.random(), Color(1, 1, 1, 1, 50, 50, 50), math.random())
      end
    end
    
  end,
  
  onEntityUpdate = function (entity)
    
  end
  
}

-- Angel Rage
events.EV_AngelRage = {
  
  name = "AngelRage",
  weights = {1,1,1},
  good = true,
  
  onlyNewRoom = true,
  byTime = false,
  duration = 5,
  
  onStart = function ()
    Game():GetLevel():AddAngelRoomChance(.05)
  end,
  
  onNewRoom = function ()
    local g = Game()
    local p = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    local entities = Isaac.GetRoomEntities()
    for i = 1, #entities do
      if entities[i]:IsActiveEnemy() and math.random(1,3) == 2 and not entities[i]:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
        local ref = EntityRef(entities[i])
        g:SpawnParticles(ref.Position, EffectVariant.CRACK_THE_SKY, 3, math.random(), Color(1, 1, 1, 1, 50, 50, 50), math.random())
        g:SpawnParticles(ref.Position, EffectVariant.BLUE_FLAME, 1, math.random(), Color(1, 1, 1, 1, 50, 50, 50), math.random())
      end
    end
    
    SFXManager():Play(SoundEffect.SOUND_HOLY, 1, 0, false, 1)
    g:Darken(-1, 40);
    
    for i = 1, math.random(1,3) do
      local max = room:GetBottomRightPos()
      local pos = Vector(math.random(math.floor(max.X)), math.random(math.floor(max.Y)))
      local enemyType = IOTR.Enums.AngelRage[math.random(#IOTR.Enums.AngelRage)]
      IOTR.Cmd.send(enemyType)
      local enemy = Isaac.Spawn(enemyType, 0,  0, room:FindFreeTilePosition(pos, 0.5), Vector(math.random(-20, 20), math.random(-20, 20)), p)
      enemy:AddCharmed(-1)
      enemy:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
    end
  end,
  
  onRoomChange = function ()
    local room = Game():GetRoom()
    room:SetFloorColor(Color(1,1,1,1,150,150,150))
    room:SetWallColor(Color(1,1,1,1,150,150,150))
  end
  
}

-- Devil Rage
events.EV_DevilRage = {
  
  name = "DevilRage",
  weights = {0.9,1,1},
  good = false,
  
  onlyNewRoom = true,
  byTime = false,
  duration = 5,
  
  onStart = function ()
    Game():GetLevel():AddAngelRoomChance (-.05)
  end,
  
  onRoomChange = function ()
    
    local room = Game():GetRoom()
    room:SetFloorColor(Color(0,0,0,1,-50,-50,-50))
    room:SetWallColor(Color(0,0,0,1,-50,-50,-50))
    
  end,
  
  onNewRoom = function ()
    
    local player = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    
    for i = 1, math.random(3,7) do
        local pos = room:GetRandomPosition(1)
        if (pos:Distance(player.Position) > 100) then
          Game():SpawnParticles(pos, EffectVariant.CRACK_THE_SKY, 3, math.random(), Color(1, 0, 0, 1, 50, 0, 0), math.random())
          Game():SpawnParticles(pos, EffectVariant.LARGE_BLOOD_EXPLOSION, 1, math.random(), Color(1, 0, 0, 1, 50, 0, 0), math.random())
        end
    end
    
    for i = 1, math.random(1,3) do
      local max = room:GetBottomRightPos()
      local pos = Vector(math.random(math.floor(max.X)), math.random(math.floor(max.Y)))
      pos = room:FindFreeTilePosition(pos, 0.5)
      local enemyType = IOTR.Enums.DevilRage[math.random(#IOTR.Enums.DevilRage)]
      local enemy = Isaac.Spawn(enemyType, 0,  0, pos, Vector(math.random(-20, 20), math.random(-20, 20)), p)
    end
      
    SFXManager():Play(SoundEffect.SOUND_SATAN_APPEAR, 1, 0, false, 1)
    Game():Darken(1, 60);
    
  end
  
}

-- Rainbow Rain
events.EV_RainbowRain = {
  
  name = "RainbowRain",
  weights = {1,1,1},
  good = true,
  
  onStart = function ()
    
    local player = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    
    for i = 0, room:GetGridSize()/6 do
      local max = room:GetBottomRightPos()
      local pos = Vector(math.random(math.floor(max.X)), math.random(math.floor(max.Y)))
      pos = room:FindFreeTilePosition(pos, 0.5)
      if (pos:Distance(player.Position) > 100) then
        Game():SpawnParticles(pos, EffectVariant.CRACK_THE_SKY, 1, math.random(), IOTR.Enums.TintedRainbow[math.random(#IOTR.Enums.Rainbow)], math.random())
        Game():SpawnParticles(pos, EffectVariant.PLAYER_CREEP_HOLYWATER, 1, 0, IOTR.Enums.TintedRainbow[math.random(#IOTR.Enums.Rainbow)], 0)
      end
    end
    
    SFXManager():Play(SoundEffect.SOUND_WATER_DROP, 1, 0, false, 1)
    
  end
  
}

-- RUN
events.EV_RUN = {
  
  name = "RUN",
  weights = {0.7,1,1},
  good = false,
  
  duration = 15*30,
  
  onRoomChange = function ()
    
    local room = Game():GetRoom()
    local max = room:GetBottomRightPos()
    local pos = Vector(math.random(math.floor(max.X)), math.random(math.floor(max.Y)))
    pos = room:FindFreeTilePosition(pos, 0.5)
    Game():SpawnParticles(pos, EffectVariant.HUSH_LASER, 1, math.random(), IOTR.Enums.Rainbow[math.random(#IOTR.Enums.Rainbow)], math.random())
    
  end,
  
  onEnd = function ()
    local e = Isaac.GetRoomEntities()
    
    for k, v in pairs(e) do
      if (v.Type == 1000 and v.Variant == 96) then
        v:Die()
      end
    end
  end
  
}

-- Flash Jump
events.EV_FlashJump = {
  
  name = "FlashJump",
  weights = {1,1,1},
  good = true,
  
  duration = 7,
  byTime = false,
  
  onRoomChange = function ()
  
    Game():MoveToRandomRoom(false, math.random(0, 99999))
    
  end
  
}

-- Enemy Regen
events.EV_EnemyRegen = {
  
  name = "EnemyRegen",
  weights = {.9,1,1},
  good = false,
  
  duration = 50*30,
  
  onEntityUpdate = function (entity)
  
    if (Game():GetFrameCount() % 3 == 0) then
      if (entity:IsActiveEnemy() and entity.HitPoints < entity.MaxHitPoints) then
        entity:AddHealth(0.5)
        Game():SpawnParticles(Vector(entity.Position.X + math.random()*20, entity.Position.Y + math.random()*20), EffectVariant.ULTRA_GREED_BLING, 1, 0, Color(0.5,1,0,1,0,0,0), 0)
      end
    end
    
  end
  
}

-- Flasmob
events.EV_Flashmob = {
  
  name = "Flashmob",
  weights = {1,1,1},
  good = true,
  
  duration = 45*30,
  
  onEntityUpdate = function (entity)
    
    local p = Isaac.GetPlayer(0)
  
    if (
      entity.Type ~= EntityType.ENTITY_PLAYER and
      entity.Type ~= EntityType.ENTITY_LASER and
      entity.Type ~= EntityType.ENTITY_EFFECT and
      entity.Type ~= EntityType.ENTITY_TEXT
    )
    then
      entity:AddVelocity(Vector(-p.Velocity.X, -p.Velocity.Y))
    end
    
  end
  
}

-- Attack on titan
events.EV_AttackOnTitan = {
  
  name = "AttackOnTitan",
  weights = {0.8,1,1},
  good = false,
  
  byTime = false,
  onlyNewRoom = true,
  duration = 4,
  
  onStart = function ()
    IOTR.Shaders.IOTR_Bloody.enabled = true
    SFXManager():Play(IOTR.Sounds.list.attackOnTitan, 2, 0, false, 1)
  end,
  
  onEntityUpdate = function (entity)
    
    if (entity:IsActiveEnemy() and entity:IsVulnerableEnemy() and entity:ToNPC().Scale ~= 2.5) then
      entity:ToNPC().Scale = 2.5
      entity:ToNPC().MaxHitPoints = entity:ToNPC().MaxHitPoints*5
      entity:ToNPC().HitPoints = entity:ToNPC().HitPoints*5
    end
    
  end,
  
  onEnd = function ()
    IOTR.Shaders.IOTR_Bloody.enabled = false
    local e = Isaac.GetRoomEntities()
    
    for k, v in pairs(e) do
      if (v:IsActiveEnemy() and v:IsVulnerableEnemy() and v:ToNPC().Scale >= 2.5) then
        v:ToNPC().Scale = 1
        v:ToNPC().MaxHitPoints = v:ToNPC().MaxHitPoints/5
        v:ToNPC().HitPoints = v:ToNPC().HitPoints/5
      end
    end
  end
  
}

-- Diarrhea
events.EV_Diarrhea = {
  
  name = "Diarrhea",
  weights = {1,1,1},
  good = true,
  
  duration = 45*30,
  
  onUpdate = function (entity)
    
    local e = Isaac.GetRoomEntities()
    local p = Isaac.GetPlayer(0)
  
    if (Game():GetFrameCount() % 20 == 0) then
      local f = Isaac.Spawn(EntityType.ENTITY_DIP, 0,  0, p.Position, Vector(math.random(-20, 20), math.random(-20, 20)), p)
      f:AddCharmed(-1)
      f:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
      SFXManager():Play(SoundEffect.SOUND_FART, 1, 0, false, 1)
    end
    
  end
  
}

-- Blade storm
events.EV_BladeStorm = {
  
  name = "BladeStorm",
  weights = {0.7,1,1},
  good = false,
  
  duration = 40*30,
  
  onUpdate = function (entity)
    
    local e = Isaac.GetRoomEntities()
    local p = Isaac.GetPlayer(0)
  
    if (Game():GetFrameCount() % 8 ~= 0) then return end
    
    local r = Game():GetRoom()
    local min = r:GetTopLeftPos().X
    local max = r:GetBottomRightPos().X
    local height = r:GetTopLeftPos().Y - 50
    local ef = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPEAR_OF_DESTINY, 0, Vector(math.random(min, max), height), Vector(0, 12), p)
      
    if (Game():GetFrameCount() % 30 ~= 0) then return end
    
  end,
  
  onEntityUpdate = function (entity)
    local p = Isaac.GetPlayer(0)
    
    if (entity.Type == EntityType.ENTITY_EFFECT and entity.Variant == EffectVariant.SPEAR_OF_DESTINY and p.Position:Distance(entity.Position) < 30) then
      p:TakeDamage(0.5, DamageFlag.DAMAGE_LASER, EntityRef(entity), 30)
    end
    
    if (entity.Type == EntityType.ENTITY_EFFECT and entity.Variant == EffectVariant.SPEAR_OF_DESTINY and entity.Position.Y > Game():GetRoom():GetBottomRightPos().Y + 50) then
      entity:Remove()
    end
  end
  
}

-- More awards
events.EV_MoreAwards = {
  
  name = "MoreAwards",
  weights = {1,1,1},
  good = true,
  
  duration = 5,
  byTime = false,
  
  onRoomChange = function (entity)
    
    local room = Game():GetRoom()
    if (room:GetType() == RoomType.ROOM_DEFAULT) then
      room:SpawnClearAward()
      room:SpawnClearAward()
    end
    
  end
  
}

-- Stanley Parable
events.EV_StanleyParable = {
  
  name = "StanleyParable",
  weights = {1,1,1},
  good = true,
  
  onStart = function ()
    
    local g = Game()
    local player = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
  
    for i = 0, room:GetGridSize()/7 do
      local max = room:GetBottomRightPos()
      local pos = Vector(math.random(math.floor(max.X)), math.random(math.floor(max.Y)))
      pos = room:FindFreeTilePosition(pos, 0.5)
      Isaac.GridSpawn(GridEntityType.GRID_PRESSURE_PLATE, 1, pos, false)
    end
    
    SFXManager():Play(SoundEffect.SOUND_1UP, 1, 0, false, 1)
    
  end
  
}

-- Supernova
events.EV_Supernova  = {
  
  name = "Supernova",
  weights = {.2,.6,1},
  good = true,
  
  onlyNewRoom = true,
  duration = 5,
  byTime = false,
  
  onStart = function ()
    SFXManager():Play(SoundEffect.SOUND_SUPERHOLY, 1, 0, false, 1)
  end,
  
  onRoomChange = function ()
    
    local player = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    local ppos = player.Position
    Game():GetRoom():MamaMegaExplossion()
    
    for i = 0, 3 do
      local mlaser = EntityLaser.ShootAngle(6, ppos, 90*i, 0, Vector(0,0), player)
      mlaser:SetActiveRotation(1, 999360, 2, true)
      mlaser.CollisionDamage = player.Damage*100;
      
      local laser = EntityLaser.ShootAngle(5, ppos, 90*i, 0, Vector(0,0), player)
      laser:SetActiveRotation(1, -999360, 10, true)
      laser.CollisionDamage = player.Damage*25;
    end
    
    if (player:GetHearts() >= 1) then
      player:AddHearts((-player:GetHearts())+1)
      player:AddSoulHearts(-player:GetSoulHearts())
    else
      player:AddSoulHearts(-player:GetSoulHearts() + 4)
    end
    
  end
  
}

-- DDoS
events.EV_DDoS  = {
  
  name = "DDoS",
  weights = {.3,.8,1},
  good = false,
  
  duration = 30*30,
  
  onStart = function ()
    IOTR.Shaders.IOTR_Glitch.enabled = true
    IOTR.Shaders.IOTR_Glitch.params.time = 10000
    
    SFXManager():Play(IOTR.Sounds.list.ddosDialup, 1, 0, false, 1)
  end,
  
  onUpdate = function ()
    
    IOTR.Shaders.IOTR_Glitch.params.time = IOTR.Shaders.IOTR_Glitch.params.time + 1
    
    if (Game():GetFrameCount() % 10 == 0) then
      local room = Game():GetRoom()
      local p = Isaac.GetPlayer(0)
      local pos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20, true)
      local fly = Isaac.Spawn(EntityType.ENTITY_DART_FLY, 0,  0, pos, Vector(0, 0), p)
      IOTR.Text.add(
        "ddos" .. tostring(IOTR.Shaders.IOTR_Glitch.params.time), 
        tostring(math.random(1,255)).."."..tostring(math.random(1,255)).."."..tostring(math.random(1,255)).."."..tostring(math.random(1,255))
      )
      IOTR.Text.follow("ddos" .. tostring(IOTR.Shaders.IOTR_Glitch.params.time), fly)
    end
    
  end,
  
  onEnd = function ()
    IOTR.Shaders.IOTR_Glitch.enabled = false
  end
  
}

-- Interstellar
events.EV_Interstellar  = {
  
  name = "Interstellar",
  weights = {0.8,1,1},
  good = false,
  duration = 30*30,
  
  onStart = function ()
    IOTR.Shaders.IOTR_Swirl.enabled = true
    
    SFXManager():Play(IOTR.Sounds.list.interstellar, 1, 0, false, 1)
    Game():Darken(-1, 30*30)
  end,
  
  onUpdate = function ()
    
    local room = Game():GetRoom()
    local p = Isaac.GetPlayer(0)
    
    local e = Isaac.GetRoomEntities()
    local sbh = false
    local pv = Vector(math.random(room:GetTopLeftPos().X, room:GetBottomRightPos().X), math.random(room:GetTopLeftPos().Y, room:GetBottomRightPos().Y))
    local sv = Vector(room:GetCenterPos().X - pv.X, room:GetCenterPos().Y - pv.Y):Normalized()
    local bl = Isaac.Spawn(EntityType.ENTITY_EFFECT, 103,  0, pv, Vector(sv.X*6, sv.Y*6), p)
    bl:SetColor(Color(0.149, 0.416, 0.804, 1, 7, 20, 40), 0, 0, false, false)
    
    IOTR.Shaders.IOTR_Swirl.params.Radius = IOTR.GameState.screenSize.Y/1500
    
    for k, v in pairs(e) do
      if (v.Type ~= EntityType.ENTITY_EFFECT and v.Variant ~= 5730) then
        local vec = Vector(v.Position.X - room:GetCenterPos().X, v.Position.Y - room:GetCenterPos().Y):Normalized()
        
        if (v.Type == EntityType.ENTITY_PLAYER) then
          v:AddVelocity(Vector(-vec.X*0.8, -vec.Y*0.8))
        else
          v:AddVelocity(Vector(-vec.X*5, -vec.Y*5))
        end
        
        if (room:GetCenterPos():Distance(v.Position) <= 40) then
          if (
              v.Type == EntityType.ENTITY_PICKUP
              or v.Type == EntityType.ENTITY_TEAR
              or v.Type == EntityType.ENTITY_PROJECTILE
              or (v.Type == EntityType.ENTITY_EFFECT and v.Variant == 103)
              )
          then
            v:Die()
          elseif (v.Type == EntityType.ENTITY_PLAYER) then
            v:TakeDamage(0.5, DamageFlag.DAMAGE_LASER, EntityRef(p), 30)
          else
            v:TakeDamage(2, DamageFlag.DAMAGE_LASER, EntityRef(p), 10)
          end
        end
        
      end
      
      if (v.Type == 1000 and v.Variant == 5730) then
        sbh = true
      end
    end
    
    if (not sbh) then
      local bh = Isaac.Spawn(1000, 5730,  0, room:GetCenterPos(), Vector(0, 0), p)
      bh:GetSprite():Play("Default", true)
      for i = 0, 3 do
        local l = EntityLaser.ShootAngle(7, room:GetCenterPos(), 90*i, 0, Vector(0,0), bh)
        l:SetActiveRotation(1, 999360, 10, true)
      end
    end
    
  end,
  
  onEnd = function ()
    IOTR.Shaders.IOTR_Swirl.enabled = false
    
    local e = Isaac.GetRoomEntities()
    for k, v in pairs(e) do
      if (v.Type == EntityType.ENTITY_EFFECT and v.Variant == 5730) then
        v:GetSprite():Play("Disappear", true)
        v:Die()
      end
    end
  end
  
}

-- Invisible
events.EV_Invisible = {
  
  name = "Invisible",
  weights = {1,1,1},
  good = false,
  duration = 40*30,
  
  onUpdate = function ()
    Isaac.GetPlayer(0).Visible = false
    
  end,
  
  onEnd = function ()
    Isaac.GetPlayer(0).Visible = true
  end
  
}

-- Good Music
events.EV_GoodMusic = {
  
  name = "GoodMusic",
  weights = {1,1,1},
  good = false,
  duration = 14*30,
  
  onStart = function ()
    SFXManager():Play(IOTR.Sounds.list.goodMusic, 2, 0, false, 1)
  end,
  
  onEntityUpdate = function (entity)
    entity:AddVelocity(Vector(math.random(-3,3), math.random(-3,3)))
  end
  
}

-- Strabismus
events.EV_Strabismus = {
  
  name = "Strabismus",
  weights = {1,1,1},
  good = false,
  duration = 40*30,
  
  onEntityUpdate = function (entity)
    if (entity.Type == EntityType.ENTITY_TEAR) then
      entity:AddVelocity(Vector(math.random(-10,10), math.random(-10,10)))
    elseif (entity.Type == EntityType.ENTITY_KNIFE) then
      local knife = entity:ToKnife()
      knife.Rotation = knife.Rotation + math.random(-15,15)
    elseif (entity.Type == EntityType.ENTITY_LASER and entity.Parent.Type == EntityType.ENTITY_PLAYER) then
      local laser = entity:ToLaser()
      laser.Angle = laser.Angle + math.random(-20,20)
    end
  end
  
}

-- Inverse
events.EV_Inverse = {
  
  name = "Inverse",
  weights = {1,1,1},
  good = false,
  duration = 45*30,
  
  onUpdate = function ()
    local p = Isaac.GetPlayer(0)
    p:AddVelocity(Vector(-p:GetMovementJoystick().X, -p:GetMovementJoystick().Y)*2)
  end,
  
  onEntityUpdate = function (entity)
    if (entity.Type == EntityType.ENTITY_TEAR and entity.FrameCount < 1) then
      entity:AddVelocity(Vector(-entity.Velocity.X, -entity.Velocity.Y)*2)
    end
  end
  
}

-- Slip
events.EV_Slip = {
  
  name = "Slip",
  weights = {1,1,1},
  good = false,
  duration = 45*30,
  
  onUpdate = function ()
    -- Change player velocity
    local p = Isaac.GetPlayer(0)
    p:AddVelocity(Vector(p:GetMovementJoystick().X, p:GetMovementJoystick().Y))
    p:MultiplyFriction(1.2)
    
    -- Add shining effect to floor
    if (Game():GetFrameCount() % 3 == 0) then
      local room = Game():GetRoom()
      local pv = Vector(math.random(room:GetTopLeftPos().X, room:GetBottomRightPos().X), math.random(room:GetTopLeftPos().Y, room:GetBottomRightPos().Y))
      if (room:IsPositionInRoom(pv, 0)) then
        Isaac.Spawn(EntityType.ENTITY_EFFECT, 103,  0, pv, Vector(0, 0), p)
      end
    end
  end
  
}

-- No damage
events.EV_NoDMG = {
  
  name = "NoDMG",
  weights = {.7,1,1},
  good = false,
  duration = 40*30,
  
  onStart = function ()
    local p = Isaac.GetPlayer(0)
    IOTR.Storage.Stats.damage = IOTR.Storage.Stats.damage - 100
    p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    p:EvaluateItems()
  end,
  
  onEnd = function ()
    local p = Isaac.GetPlayer(0)
    IOTR.Storage.Stats.damage = IOTR.Storage.Stats.damage + 100
    p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    p:EvaluateItems()
  end
  
}

-- Whirlwind
events.EV_Whirlwind = {
  
  name = "Whirlwind",
  weights = {1,1,1},
  good = true,
  duration = 40*30,
  
  onUpdate = function ()
    local frame = Game():GetFrameCount()
    if (frame % 2 ~= 0) then return end
    local p = Isaac.GetPlayer(0)
    p:FireTear(p.Position, Vector(math.cos(frame*0.2) * 8, math.sin(frame*0.2) * 8), false, false, false)
  end
  
}

-- Russian Hackers
events.EV_RussianHackers = {
  
  name = "RussianHackers",
  weights = {1,1,1},
  good = false,
  specialTrigger = "russianHackers",
  duration = 20*30,
  
  onUpdate = function ()
    if (Game():GetFrameCount() % 2 ~= 0) then return end
    local p = Isaac.GetPlayer(0)
    p:AddCoins(math.random(-3,2))
    p:AddKeys(math.random(-3,2))
    p:AddBombs(math.random(-3,2))
    Game().TimeCounter = Game().TimeCounter + math.random(-20, 20)
  end
  
}

-- Machine Gun
events.EV_MachineGun = {
  
  name = "MachineGun",
  weights = {1,1,1},
  good = true,
  duration = 30*30,
  
  onUpdate = function ()
    local p = Isaac.GetPlayer(0)
    if (p:GetFireDirection() == Direction.NO_DIRECTION) then return end
    
    for i = 0, 3 do
      local t = p:FireTear(p.Position, Vector(p:GetShootingInput().X*15+math.random(-3,3), p:GetShootingInput().Y*15+math.random(-3,3)), false, false, false)
      t.Scale = 0.2
      t.CollisionDamage = p.Damage/10
      t:ChangeVariant(TearVariant.METALLIC)
      t.KnockbackMultiplier = 10
    end
    
    if (Game():GetFrameCount() % 2 == 0) then
      SFXManager():Play(IOTR.Sounds.list.machineGunShot, .85, 0, false, 1)
    end
  end
  
}

-- Toxic
events.EV_Toxic = {
  
  name = "Toxic",
  weights = {1,1,1},
  good = false,
  
  onlyNewRoom = true,
  byTime = false,
  duration = 4,
  
  onRoomChange = function ()
    local room = Game():GetRoom()
    room:SetWallColor(Color(0.5,1,0,1,50,100,-20))
    room:SetFloorColor(Color(0.5,1,0,1,50,100,-20))
    Isaac.GetPlayer(0):SetColor(IOTR.Enums.Rainbow[4], 0, 0, false, false)
  end,
  
  onRoomChange = function ()
    local p = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    
    local entities = Isaac.GetRoomEntities()
    for i = 1, #entities do
      if (entities[i]:IsActiveEnemy()) then
        local ref = EntityRef(p)
        entities[i]:AddPoison(ref, math.random(100,300), 0.25)
      end
    end
    
    for i = 0, math.random(2,4) do
      local pos = room:GetRandomPosition(2)
      if (p.Position:Distance(pos) >= 100) then
        Game():SpawnParticles(pos, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 10, 0, IOTR.Enums.Rainbow[4], 0)
        Game():SpawnParticles(pos, EffectVariant.FART, 1, 0, IOTR.Enums.Rainbow[4], 0)
        Game():Spawn(IOTR.Enums.Buddies[4], 0, pos, Vector(0,0), p, 0, 0)
      end
    end
    
    for i = 0, math.random(5,10) do
      local pos = room:GetRandomPosition(2)
      if (p.Position:Distance(pos) >= 100) then
        Game():SpawnParticles(pos, EffectVariant.CREEP_GREEN, 1, 0, IOTR.Enums.Rainbow[4], 0)
      end
    end
    
  end,
  
  onStart = function ()
    
    IOTR.Shaders.IOTR_ColorSides.enabled = true
    IOTR.Shaders.IOTR_ColorSides.params = {
      Intensity = .6,
      VColor = {0,1,0}
    }
  end,
  
  onEnd = function ()
    IOTR.Shaders.IOTR_ColorSides.enabled = false
  end
  
}

-- Crazy Doors
events.EV_CrazyDoors = {
  
  name = "CrazyDoors",
  weights = {1,1,1},
  good = false,
  duration = 40*30,
  
  rooms = {},
  roomTypes = {},
  
  onUpdate = function ()
    
    local p = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    
    for i = DoorSlot.LEFT0, DoorSlot.DOWN1 do
      if (room:IsDoorSlotAllowed(i) and room:GetDoor(i) ~= nil) then
        local door = room:GetDoor(i)
        if (p.Position:Distance(door.Position) < 18) then
          if (IOTR.Events.EV_CrazyDoors.rooms[door.TargetRoomType] ~= nil) then
            Game():ChangeRoom(IOTR.Events.EV_CrazyDoors.rooms[door.TargetRoomType][math.random(#IOTR.Events.EV_CrazyDoors.rooms[door.TargetRoomType])])
          end
        end
      end
    end
    
    if (Game():GetFrameCount() % 25 ~= 0) then return end
    
    for i = DoorSlot.LEFT0, DoorSlot.DOWN1 do
      if (room:IsDoorSlotAllowed(i) and room:GetDoor(i) ~= nil) then
        local doorType = IOTR.Events.EV_CrazyDoors.roomTypes[math.random(#IOTR.Events.EV_CrazyDoors.roomTypes)]
        room:GetDoor(i):SetRoomTypes(doorType, doorType)
        room:GetDoor(i):Open()
      end
    end
    
  end,
  
  -- Collect all rooms
  onStart = function ()
    local rooms = Game():GetLevel():GetRooms()
    IOTR.Events.EV_CrazyDoors.rooms = {}
    IOTR.Events.EV_CrazyDoors.roomTypes = {}
      
    for i = 0, rooms.Size - 1 do
      
      local room = rooms:Get(i).Data
      if (IOTR.Events.EV_CrazyDoors.rooms[room.Type] == nil) then IOTR.Events.EV_CrazyDoors.rooms[room.Type] = {} end
      table.insert(IOTR.Events.EV_CrazyDoors.rooms[room.Type], rooms:Get(i).GridIndex)
      
    end
    
    for key, value in pairs(IOTR.Events.EV_CrazyDoors.rooms) do
      if (value ~= nil and #value > 0) then
        table.insert(IOTR.Events.EV_CrazyDoors.roomTypes, key)
      end
    end
  end,
  
  -- Recollect rooms if stage was change
  onStageChange = function ()
    IOTR.Events.EV_CrazyDoors.onStart()
  end
  
}

-- Tenet
events.EV_Tenet = {
  
  name = "Tenet",
  weights = {1,1,1},
  good = false,
  
  duration = 40*30,
  
  storageVel = {},
  storageTears = {},
  isBack = false,
  
  onUpdate = function ()
    local p = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    local s = SFXManager()
    local entities = Isaac.GetRoomEntities()
    
    if (#IOTR.Events.EV_Tenet.storageVel < 20*30 and not IOTR.Events.EV_Tenet.isBack) then
      
      -- Write player movements
      table.insert(IOTR.Events.EV_Tenet.storageVel, p.Velocity:__mul(-1))
      
      -- Write all new tears
      for i = 1, #entities do
        if entities[i].Type == EntityType.ENTITY_TEAR then
          if entities[i].FrameCount == 5 then
            table.insert(IOTR.Events.EV_Tenet.storageTears, {
              origin = entities[i],
              tearFrom = nil,
              tearVelocity = entities[i].Velocity:__mul(-1),
              tearTime = #IOTR.Events.EV_Tenet.storageVel
            })
          end
        end
      end
      
      -- Write tears dead place
      for i = 1, #IOTR.Events.EV_Tenet.storageTears do
        
        local tear = IOTR.Events.EV_Tenet.storageTears[i]
        if (tear.origin ~= nil and tear.origin:IsDead()) then
          tear.tearFrom = tear.origin.Position
          tear.origin = nil
        end
        
      end
      
      
    elseif (not IOTR.Events.EV_Tenet.isBack) then
      IOTR.Events.EV_Tenet.isBack = true
      IOTR.Shaders.IOTR_VHS.enabled = true
      p.ControlsEnabled = false
      s:Play(IOTR.Sounds.list.rewind, 1, 0, false, 1)
    end
    
    if (#IOTR.Events.EV_Tenet.storageVel ~= 0 and IOTR.Events.EV_Tenet.isBack) then
      Game().TimeCounter = Game().TimeCounter - 2
      
      p.Velocity = table.remove(IOTR.Events.EV_Tenet.storageVel, #IOTR.Events.EV_Tenet.storageVel)
      
      IOTR.Shaders.IOTR_VHS.params.Time = (Isaac.GetFrameCount()%150)/150
      
      -- Fire tears
      for i = 1, #IOTR.Events.EV_Tenet.storageTears do
        
        local tear = IOTR.Events.EV_Tenet.storageTears[i]
        if (tear.tearTime == #IOTR.Events.EV_Tenet.storageVel) then
          if (tear.tearFrom ~= nil) then
            local newTear = p:FireTear(tear.tearFrom, tear.tearVelocity, false, false, false)
          end
        end
        
      end
      
      -- Remove tears near player
      for i = 1, #entities do
        if entities[i].Type == EntityType.ENTITY_TEAR then
          if entities[i].Position:Distance(p.Position) < 20 then
            entities[i]:Die()
          end
        end
      end
    end
    
  end,
  
  onEnd = function ()
    IOTR.Shaders.IOTR_VHS.enabled = false
    IOTR.Events.EV_Tenet.isBack = false
    IOTR.Events.EV_Tenet.storageVel = {}
    IOTR.Events.EV_Tenet.storageTears = {}
    Isaac.GetPlayer(0).ControlsEnabled = true
  end
  
}

-- Superhot
events.EV_Superhot = {
  
  name = "Superhot",
  weights = {1,1,1},
  good = true,
  duration = 40*30,
  
  onStart = function ()
    SFXManager():Play(IOTR.Sounds.list.superhotVoice, 1, 0, false, 1)
    IOTR.Shaders.IOTR_ColorSides.enabled = true
    IOTR.Shaders.IOTR_ColorSides.params = {
      Intensity = .6,
      VColor = {1,1,1}
    }
  end,
  
  onRoomChange = function ()
    local room = Game():GetRoom()
    
    room:SetFloorColor(Color(1,1,1,1,150,150,150))
    room:SetWallColor(Color(1,1,1,1,150,150,150))
  end,
  
  onEntityUpdate = function (entity)
    local p = Isaac.GetPlayer(0)
    if (entity:IsActiveEnemy(false) and entity:IsVulnerableEnemy()) then
      if (math.abs(p.Velocity.X) < 0.2 and math.abs(p.Velocity.Y) < 0.2 and p:GetFireDirection() == Direction.NO_DIRECTION) then
        entity:AddFreeze(EntityRef(p), 1)
        entity.Velocity = Vector(0,0)
      else
        if (Game():GetFrameCount() % math.random(1,2) == 0) then
          entity:Update()
        end
      end
      
      if (not entity:IsBoss() and entity.HitPoints < entity.MaxHitPoints) then
        Game():SpawnParticles(entity.Position, EffectVariant.SPIKE, 20, math.random()*2, IOTR.Enums.Rainbow[1], math.random()*5)
        entity:Die()
        SFXManager():Play(IOTR.Sounds.list.superhotBreak, 1, 0, false, 1)
        
        if (math.random(1,4) == 1) then
          SFXManager():Play(IOTR.Sounds.list.superhotVoice, 1, 0, false, 1)
        end
      end
      
      entity:SetColor(IOTR.Enums.Rainbow[1], 0, 0, false, false)
    end
  end,
  
  onEnd = function ()
    local room = Game():GetRoom()
    local entities = Isaac.GetRoomEntities()
    
    room:SetFloorColor(Color(1,1,1,1,0,0,0))
    room:SetWallColor(Color(1,1,1,1,0,0,0))
    
    for i = 1, #entities do
      if (entities[i]:IsActiveEnemy() and entities[i]:IsVulnerableEnemy()) then
        entities[i]:SetColor(Color(1,1,1,1,0,0,0), 0, 0, false, false)
      end
    end
    
    IOTR.Shaders.IOTR_ColorSides.enabled = false
    
  end
  
}

-- SCP-173
events.EV_SCP173 = {
  
  name = "SCP173",
  weights = {1,1,1},
  good = false,
  duration = 30*30,
  
  direction = 1,
  
  onStart = function ()
    IOTR.Shaders.IOTR_Blink.params.Time = 0
    IOTR.Shaders.IOTR_Blink.enabled = true
  end,
  
  onEntityUpdate = function (entity)
    if (entity:IsActiveEnemy()) then
      if (IOTR.Shaders.IOTR_Blink.params.Time >= 1) then
        for a = 0, 4 do
          entity:Update()
        end
      else
        entity:AddFreeze(EntityRef(Isaac.GetPlayer(0)), 1)
        entity.Velocity = Vector(0,0)
      end
    end
  end,
  
  onUpdate = function ()
    
    if (IOTR.Events.EV_SCP173.direction == 1 and IOTR.Shaders.IOTR_Blink.params.Time < 1.07) then
      IOTR.Shaders.IOTR_Blink.params.Time = IOTR.Shaders.IOTR_Blink.params.Time + 0.015
    elseif (IOTR.Events.EV_SCP173.direction == 1) then
      IOTR.Events.EV_SCP173.direction = -1
    elseif (IOTR.Events.EV_SCP173.direction == -1 and IOTR.Shaders.IOTR_Blink.params.Time > 0) then
      IOTR.Shaders.IOTR_Blink.params.Time = IOTR.Shaders.IOTR_Blink.params.Time - 0.015
    else
      IOTR.Events.EV_SCP173.direction = 1
    end
    
  end,
  
  onEnd = function ()
    IOTR.Events.EV_SCP173.direction = 1
    IOTR.Shaders.IOTR_Blink.params.Time = 0
    IOTR.Shaders.IOTR_Blink.enabled = false
  end
  
}

-- Point of view
events.EV_PointOfView = {
  
  name = "PointOfView",
  weights = {1,1,1},
  good = false,
  
  byTime = false,
  duration = 8,
  
  direction = 1,
  
  onStart = function ()
    IOTR.Shaders.IOTR_ScreenMirror.enabled = true
  end,
  
  onRoomChange = function ()
    IOTR.Shaders.IOTR_ScreenMirror.params.Pos = math.random(1,3)
  end,
  
  onEnd = function ()
    IOTR.Shaders.IOTR_ScreenMirror.enabled = false
    IOTR.Shaders.IOTR_ScreenMirror.params.Pos = 0
  end
  
}

-- Radioactive
events.EV_Radioactive = {
  
  name = "Radioactive",
  weights = {1,1,1},
  good = false,
  duration = 45*30,
  
  onStart = function ()
    IOTR.Shaders.IOTR_ColorSides.enabled = true
    IOTR.Shaders.IOTR_ColorSides.params = {
      Intensity = 0,
      VColor = {1,1,0}
    }
  end,
  
  onUpdate = function ()
    if (IOTR.Shaders.IOTR_ColorSides.params.Intensity > 0) then
      IOTR.Shaders.IOTR_ColorSides.params.Intensity = IOTR.Shaders.IOTR_ColorSides.params.Intensity - 0.005
      if (Isaac.GetFrameCount() % 240 and math.random(1,2) == 2) then
        SFXManager():Play(IOTR.Sounds.list.radioactive, IOTR.Shaders.IOTR_ColorSides.params.Intensity * 1.5, 0, false, 1)
      end
    end
  end,
  
  onEntityUpdate = function (entity)
    local p = Isaac.GetPlayer(0)
    
    if (entity:IsActiveEnemy() and entity:IsVulnerableEnemy()) then
      for n = 1, 2 do
        local angle = math.random(0,360);
        local x = entity.Position.X + 5 * math.cos(-angle*3.14/180) * 14;
        local y = entity.Position.Y + 5 * math.sin(-angle*3.14/180) * 14;
        Game():SpawnParticles(Vector(x,y), EffectVariant.BLOOD_DROP, 1, 0, Color(1,1,0,1,255,255,0), 0)
      end
      
      if (entity.Position:Distance(p.Position) < 80) then
        
        if (IOTR.Shaders.IOTR_ColorSides.params.Intensity < 0.8) then
          IOTR.Shaders.IOTR_ColorSides.params.Intensity = IOTR.Shaders.IOTR_ColorSides.params.Intensity + 0.04
        else
          p:TakeDamage (0.5, DamageFlag.DAMAGE_FIRE, EntityRef(p), 30)
        end
      end
      
    end
  end,
  
  onEnd = function ()
    IOTR.Shaders.IOTR_ColorSides.enabled = false
  end
  
}

-- Rerun
events.EV_Rerun = {
  
  name = "Rerun",
  weights = {0,.2,1},
  good = true,
  duration = 10*30,
  
  onStart = function ()
    SFXManager():Play(IOTR.Sounds.list.rerunCharging, 1, 0, false, 1)
    Game():ShakeScreen(10*30)
    Game():Darken(-1,10*30)
  end,
  
  onUpdate = function ()
    
    local p = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    
    local pv = Vector(math.random(room:GetTopLeftPos().X, room:GetBottomRightPos().X), math.random(room:GetTopLeftPos().Y, room:GetBottomRightPos().Y))
    local sv = Vector(p.Position.X - pv.X, p.Position.Y - pv.Y):Normalized()
    local bl = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT,  0, pv, Vector(sv.X*6, sv.Y*6), p)
    bl:SetColor(IOTR.Enums.Rainbow[3], 0, 0, false, false)
    
  end,
  
  onEnd = function ()
    Game():GetRoom():MamaMegaExplossion()
    
    local seeds = Game():GetSeeds()
    local seed = seeds:GetNextSeed()

    seeds:SetStartSeed(seed)
    
    local stype = math.random(0,2);
    
    if (stype == 0) then Isaac.ExecuteCommand ("stage 1") end
    if (stype == 1) then Isaac.ExecuteCommand ("stage 1a") end
    if (stype == 2) then Isaac.ExecuteCommand ("stage 1b") end
  end
  
}

-- Switch the channel
events.EV_SwitchTheChannel = {
  
  name = "SwitchTheChannel",
  weights = {0,.2,1},
  good = false,
  duration = 10*30,
  
  onUpdate = function ()
    
    if (Isaac.GetFrameCount() % 60 ~= 0) then return end
    
    Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_CLICKER, true, true, true, false)
    
    local seeds = Game():GetSeeds()
    local seed = seeds:GetNextSeed()

    seeds:SetStartSeed(seed)
    local level = Game():GetLevel()
    local stype = math.random(0,1)
    local nl = nil
    
    if (Game():IsGreedMode()) then nl = math.random(1,7) else nl = math.random(1,12) end
    
    if (stype == 0) then Isaac.ExecuteCommand ("stage " .. nl) end
    if (stype == 1) then Isaac.ExecuteCommand ("stage " .. nl .. "a") end
    
  end
  
}

-- Flying Banana
events.EV_FlyingBanana = {
  
  name = "FlyingBanana",
  weights = {1,1,1},
  good = true,
  duration = 30*30,
  
  onUpdate = function ()
    
    local p = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    
    local bananas = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BOOMERANG, 0, false, true)
    for i = 1, #bananas do
      local enems = Isaac.FindInRadius(bananas[i].Position, 16, EntityPartition.ENEMY)
      for i = 1, #enems do
        enems[i]:TakeDamage (0.2, 0, EntityRef(p), 10)
      end
    end
    
    
    if (Isaac.GetFrameCount() % 4 == 0) then
      local pv = Vector(math.random(room:GetTopLeftPos().X, room:GetBottomRightPos().X), math.random(room:GetTopLeftPos().Y, room:GetBottomRightPos().Y))
      local sv = Vector(p.Position.X - pv.X, p.Position.Y - pv.Y):Normalized()
      local bl = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOOMERANG,  0, pv, Vector(sv.X*6, sv.Y*6), p)
      bl:SetColor(IOTR.Enums.Rainbow[3], 0, 0, false, false)
    end
    
  end
  
}

-- Pyrosis
events.EV_Pyrosis = {
  
  name = "Pyrosis",
  weights = {1,1,1},
  good = true,
  
  onlyNewRoom = true,
  duration = 4,
  byTime = false,
  
  onEntityUpdate = function (entity)
    
    if (entity:IsActiveEnemy() and entity:IsVulnerableEnemy() and not entity:IsBoss()) then
      Isaac.GridSpawn(GridEntityType.GRID_POOP, 1, entity.Position, true)
      Game():SpawnParticles(entity.Position, EffectVariant.PLAYER_CREEP_RED, 1, 0, IOTR.Enums.Rainbow[1], 0)
    end
    
  end
  
}

-- Tears = Spiders
events.EV_TearsEqualsSpiders = {
  
  name = "TearsEqualsSpiders",
  weights = {1,1,1},
  good = true,
  duration = 50*30,
  
  onEntityUpdate = function (entity)
    
    local p = Isaac.GetPlayer(0)
    
    if (entity.Type == EntityType.ENTITY_TEAR) then
        
      local spider
      
      if (math.random(5) == 1) then
        spider = Isaac.Spawn(EntityType.ENTITY_SPIDER, 0, 0, entity.Position:__add(entity.Velocity:__mul(4)), Vector(0,0), p)
        spider.HitPoints = entity:ToTear().BaseDamage*2
      else
        spider = p:AddBlueSpider (entity.Position)
        spider.HitPoints = entity:ToTear().BaseDamage
      end
      
      spider:AddVelocity(entity.Velocity)
      entity:Remove()
      
    end
    
  end
  
}

-- Ipecac for all
events.EV_IpecacForAll = {
  
  name = "IpecacForAll",
  weights = {.5,1,1},
  good = false,
  duration = 50*30,
  
  onEntityUpdate = function (entity)
    
    if (entity.Type == EntityType.ENTITY_PROJECTILE and entity:IsDead ()) then
        
      Isaac.Explode(entity.Position, entity, 30.0)
      
    end
    
  end
  
}

-- Ghostbusters
events.EV_Ghostbusters = {
  
  name = "Ghostbusters",
  weights = {.5,1,1},
  good = false,
  duration = 50*30,
  
  onEntityUpdate = function (entity)
    
    local bossDelay = 0
    if entity:IsBoss() then bossDelay = 7 end
    
    if (
      entity.Type ~= EntityType.ENTITY_THE_HAUNT
      and entity.Type ~= EntityType.ENTITY_WIZOOB
      and entity.Type > EntityType.ENTITY_PROJECTILE
      and entity.Type < EntityType.ENTITY_EFFECT
      and entity:IsDead() and math.random(1,1+bossDelay)
    ) then 
      if math.random(1,3) <= 2 then
        Game():Spawn(EntityType.ENTITY_THE_HAUNT, 10, entity.Position, Vector(0,0), entity, 0, 0)
      else
        Game():Spawn(EntityType.ENTITY_WIZOOB, 0, entity.Position, Vector(0,0), entity, 0, 0)
      end
    end
    
  end
  
}

-- Telesteps
events.EV_Telesteps = {
  
  name = "Telesteps",
  weights = {1,1,1},
  good = false,
  duration = 45*30,
  
  delay = 20,
  
  onUpdate = function ()
    
    local p = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    
    
    if (p:GetMovementDirection() ~= Direction.NO_DIRECTION and IOTR.Events.EV_Telesteps.delay == 0) then
      
      Game():SpawnParticles(p.Position, EffectVariant.CROSS_POOF, 1, 0, IOTR.Enums.Rainbow[2], 0)
      
      if (p:GetMovementDirection() == Direction.UP) then
        if (p.CanFly) then
          p.Position = room:GetClampedPosition(p.Position:__add(Vector(0, math.random(-200, 0))), 1)
        else
          local maxTile = IOTR._.getLastAvailableCord(p.Position, p:GetMovementDirection(), room)
          
          local min = math.ceil(math.min(p.Position.Y, maxTile.Y))
          local max = math.ceil(math.max(p.Position.Y, maxTile.Y))
          
          p.Position = room:GetClampedPosition(Vector(p.Position.X, math.random(min, max)), 0)
        end
      end
      
      if (p:GetMovementDirection() == Direction.DOWN) then
        if (p.CanFly) then
          p.Position = room:GetClampedPosition(p.Position:__add(Vector(0, math.random(0, 200))), 1)
        else
          local maxTile = IOTR._.getLastAvailableCord(p.Position, p:GetMovementDirection(), room)
          
          local min = math.ceil(math.min(p.Position.Y, maxTile.Y))
          local max = math.ceil(math.max(p.Position.Y, maxTile.Y))
          
          p.Position = room:GetClampedPosition(Vector(p.Position.X, math.random(min, max)), 0)
        end
      end
      
      if (p:GetMovementDirection() == Direction.LEFT) then
        if (p.CanFly) then
          p.Position = room:GetClampedPosition(p.Position:__add(Vector(math.random(-200, 0), 0)), 1)
        else
          local maxTile = IOTR._.getLastAvailableCord(p.Position, p:GetMovementDirection(), room)
          
          local min = math.ceil(math.min(p.Position.X, maxTile.X))
          local max = math.ceil(math.max(p.Position.X, maxTile.X))
          
          p.Position = room:GetClampedPosition(Vector(math.random(min, max), p.Position.Y), 0)
        end
      end
      
      if (p:GetMovementDirection() == Direction.RIGHT) then
        if (p.CanFly) then
          p.Position = room:GetClampedPosition(p.Position:__add(Vector(math.random(0, 200), 0)), 1)
        else
          local maxTile = IOTR._.getLastAvailableCord(p.Position, p:GetMovementDirection(), room)
          
          local min = math.ceil(math.min(p.Position.X, maxTile.X))
          local max = math.ceil(math.max(p.Position.X, maxTile.X))
          
          p.Position = room:GetClampedPosition(Vector(math.random(min, max), p.Position.Y), 0)
        end
      end
      
      Game():SpawnParticles(p.Position, EffectVariant.CROSS_POOF, 1, 0, IOTR.Enums.Rainbow[5], 0)
      
      IOTR.Sounds.play(SoundEffect.SOUND_HELL_PORTAL1)
      IOTR.Events.EV_Telesteps.delay = 20
    end
    
    if (IOTR.Events.EV_Telesteps.delay ~= 0) then IOTR.Events.EV_Telesteps.delay = IOTR.Events.EV_Telesteps.delay - 1 end
    
    
  end,
  
  onEnd = function ()
    IOTR.Events.EV_Telesteps.delay = 20
  end
  
}

-- Flash
events.EV_Flash = {
  
  name = "Flash",
  weights = {1,1,1},
  good = true,
  duration = 50*30,
  
  onStart = function ()
    local p = Isaac.GetPlayer(0)
    IOTR.Storage.Stats.speed = IOTR.Storage.Stats.speed + 10
    p:AddCacheFlags(CacheFlag.CACHE_SPEED)
    p:EvaluateItems()
  end,
  
  onUpdate = function (entity)
    
    local p = Isaac.GetPlayer(0)   
    p.Velocity = p.Velocity:__mul(1.1)
    
    if (p:GetMovementDirection () ~= Direction.NO_DIRECTION and Isaac.GetFrameCount() % 3 == 0) then
      Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HOT_BOMB_FIRE, 0, p.Position, Vector(0,0), p)
    end
    
    local entities = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.HOT_BOMB_FIRE, 0, false, false)
    
    for i = 1, #entities do
      if (entities[i].FrameCount > 30) then
        entities[i]:Die()
      end
    end
    
    if (math.random(1,2) == 1) then
      local bolt = p:FireTechLaser(
        p.Position:__add(Vector(math.random(-25, 25), math.random(-25, 25))),
        LaserOffset.LASER_TECH5_OFFSET,
        Vector(math.random(-1, 1), math.random(-1, 1)),
        false,
        true
      )
      
      bolt:SetColor(Color(1,1,0,1,255,255,0), -1, 10, false, true)
      bolt:SetMaxDistance(math.random(1,45))
    end
    
  end,
  
  onEnd = function ()
    local p = Isaac.GetPlayer(0)
    IOTR.Storage.Stats.speed = IOTR.Storage.Stats.speed - 10
    p:AddCacheFlags(CacheFlag.CACHE_SPEED)
    p:EvaluateItems()
    
    local entities = Isaac.FindByType (EntityType.ENTITY_EFFECT, EffectVariant.HOT_BOMB_FIRE, 0, false, false)
    
    for i = 1, #entities do
      entities[i]:Die()
    end
  end
  
}

-- Shadow clones
events.EV_ShadowClones = {
  
  name = "ShadowClones",
  weights = {1,1,1},
  good = false,
  byTime = false,
  duration = 4,
  
  onEntityUpdate = function (entity)
    
    if (entity:IsActiveEnemy() and entity:IsVulnerableEnemy() and not entity:IsBoss() and entity.HitPoints > 1 and math.random(0,20) == 0 and Isaac.GetFrameCount() % 15 == 0) then
      IOTR.Sounds.play(IOTR.Sounds.list.shadowClones)
      for i = 0, math.random(1,3) do
        local clone = Isaac.Spawn(entity.Type, entity.Variant, entity.SubType, entity.Position:__add(Vector(math.random(-30,30),math.random(-30,30))), Vector(0,0), entity)
        clone:SetColor(Color(0, 0, 0, 1, 0, 0, 0), 0, 0, false, false)
        clone.HitPoints = 0.1
      end
    end
    
  end
  
}

-- Isaac Of Isaac
events.EV_IsaacOfIsaac = {
  
  name = "IsaacOfIsaac",
  weights = {1,1,1},
  good = false,
  
  duration = 50*30,
  
  onStart = function ()
    IOTR.Sounds.play(IOTR.Sounds.list.isaacOfIsaac)
  end,
  
  onRoomChange = function ()
    local entities = Isaac.GetRoomEntities()
    
    
    for i = 1, #entities do
      if (
          entities[i].Type > 8
          and not entities[i]:IsBoss()
          and entities[i].Type < 1000
          and entities[i].FrameCount < 2
          and entities[i].Type ~= EntityType.ULCER
          and entities[i].Type ~= EntityType.ENTITY_MOBILE_HOST
          and entities[i].Type ~= EntityType.ENTITY_MOMS_HAND
          and entities[i].Type ~= EntityType.ENTITY_ROUND_WORM
          and entities[i].Type ~= EntityType.ENTITY_NIGHT_CRAWLER
        ) then
        local sprite = entities[i]:GetSprite()
        sprite:Load("gfx/mod.twitch_isaac.anm2", true)
        sprite:Play("Appear", true)
      end
    end
  end
  
}

-- Static electricity
events.EV_StaticElectricity = {
  
  name = "StaticElectricity",
  weights = {.9,1,1},
  good = false,
  
  duration = 40*30,
  
  onUpdate = function ()
    local entities = Isaac.GetRoomEntities()
    local p = Isaac.GetPlayer(0)
    
    entity1 = entities[math.random(#entities)]
    entity2 = entities[math.random(#entities)]
    
    if (math.random(1,20) ~= 5 or entity1.Type == EntityType.ENTITY_PLAYER or entity2.Type == EntityType.ENTITY_PLAYER) then return end
    
    local laser = EntityLaser.ShootAngle(2, entity1.Position, entity2.Position:__sub(entity1.Position):GetAngleDegrees(), 5, Vector(0,0), nil)
    laser.MaxDistance = entity2.Position:Distance(entity1.Position)
    laser:SetColor(Color(0.4,0.4,1,1,30,30,200), 0, 0, false, false)
  end
  
}

-- Bleeding
events.EV_Bleeding = {
  
  name = "Bleeding",
  weights = {.8,1,1},
  good = false,
  
  onlyNewRoom = true,
  byTime = false,
  duration = 4,
  
  onEntityUpdate = function (entity)
    if (Isaac.GetFrameCount() % 30 ~= 0) then return end
    
    if (entity:IsActiveEnemy() and entity:IsVulnerableEnemy()) then
      
      Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, entity.Position, Isaac.GetPlayer(0).Position:__sub(entity.Position):Normalized():__mul(10), entity)
      Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, entity.Position, Vector(0,0), entity)
    end
  end
  
}

-- Parasitic infection
events.EV_ParasiticInfection = {
  
  name = "ParasiticInfection",
  weights = {.9,1,1},
  good = false,
  
  onlyNewRoom = true,
  byTime = false,
  duration = 4,
  
  onEntityUpdate = function (entity)
    if
      entity:IsDead()
      and entity.Type ~= EntityType.ENTITY_ATTACKFLY
      and entity.Type ~= EntityType.ENTITY_SPIDER
      and entity.Type ~= EntityType.ENTITY_MAGGOT
      and entity.Type > EntityType.ENTITY_PROJECTILE
      and entity.Type < EntityType.ENTITY_EFFECT
    then
      IOTR.Cmd.send("HIT")
      if entity:IsBoss() then
        if (math.random(0,7) ~= 1) then return end
      end
      
      Isaac.Spawn(EntityType.ENTITY_SPIDER, 0, 0, entity.Position, Vector(0,0), entity)
      Isaac.Spawn(EntityType.ENTITY_ATTACKFLY, 0, 0, entity.Position, Vector(0,0), entity)
      Isaac.Spawn(EntityType.ENTITY_MAGGOT, 0, 0, entity.Position, Vector(0,0), entity)
        
    end
  end,
  
  onDamage = function (entity, damageAmnt, damageFlag, damageSource, damageCountdown)
    
    if entity.Type == EntityType.ENTITY_PLAYER then
      local fly = Isaac.Spawn(EntityType.ENTITY_ATTACKFLY, 0,  0, entity.Position, Vector(0, 0), entity)
      fly:AddCharmed(-1)
      fly:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
      
      fly = Isaac.Spawn(EntityType.ENTITY_SPIDER, 0,  0, entity.Position, Vector(0, 0), entity)
      fly:AddCharmed(-1)
      fly:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
      
      fly = Isaac.Spawn(EntityType.ENTITY_MAGGOT, 0,  0, entity.Position, Vector(0, 0), entity)
      fly:AddCharmed(-1)
      fly:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
    end
    
  end
  
}

-- I am Lost
events.EV_IAmLost = {
  
  name = "IAmLost",
  weights = {0,.5,1},
  good = false,
  
  duration = 30*30,
  
  onUpdate = function ()
    Game():SpawnParticles(Isaac.GetPlayer(0).Position:__add(Vector(0, -25)), EffectVariant.TEAR_POOF_SMALL, 1, 0, Color(1,1,1,1,255,255,255), 0)
  end,
  
  onDamage = function (entity, damageAmnt, damageFlag, damageSource, damageCountdown)
    
    if entity.Type == EntityType.ENTITY_PLAYER then
      entity:Die()
    end
    
  end
  
}

-- Deep Dark
events.EV_DeepDark = {
  
  name = "DeepDark",
  weights = {.5,.9,1},
  good = false,
  
  duration = 40*30,
  
  onStart = function ()
    IOTR.Shaders.IOTR_DeepDark.enabled = true
  end,
  
  onUpdate = function ()
    local pos = Isaac.WorldToScreen(Isaac.GetPlayer(0).Position)
    IOTR.Shaders.IOTR_DeepDark.params.PlayerPos = {pos.X, pos.Y}
  end,
  
  onEnd = function ()
    IOTR.Shaders.IOTR_DeepDark.enabled = false
  end
  
}

-- Broken Lens
events.EV_BrokenLens = {
  
  name = "BrokenLens",
  weights = {.8,1,1},
  good = false,
  
  duration = 40*30,
  
  onStart = function ()
    IOTR.Shaders.IOTR_BrokenLens.enabled = true
  end,
  
  onUpdate = function ()
    local pos = Isaac.WorldToScreen(Isaac.GetPlayer(0).Position)
    IOTR.Shaders.IOTR_BrokenLens.params.CameraPos = {pos.X, pos.Y}
    
    if (IOTR.Shaders.IOTR_BrokenLens.params.Intensity > 5) then
      IOTR.Shaders.IOTR_BrokenLens.params.Intensity = 0.1
    else      
      IOTR.Shaders.IOTR_BrokenLens.params.Intensity = IOTR.Shaders.IOTR_BrokenLens.params.Intensity + 0.05  
    end
  end,
  
  onEnd = function ()
    IOTR.Shaders.IOTR_BrokenLens.enabled = false
  end
  
}

-- Floor is lava
events.EV_FloorIsLava = {
  
  name = "FloorIsLava",
  weights = {1,1,1},
  good = false,
  
  duration = 40*30,
  
  onUpdate = function ()
    local p = Isaac.GetPlayer(0)
    
    if (Isaac.GetFrameCount() % 5 ~= 0) then return end
    local room = Game():GetRoom()
    local max = room:GetBottomRightPos()
    local posv = Vector(math.random(math.floor(max.X)), math.random(math.floor(max.Y)))
    pos = room:FindFreeTilePosition(posv, 0.5)
    if (p.Position:Distance(posv) >= 100) then
      Game():SpawnParticles(pos, EffectVariant.CREEP_RED, 1, 0, Color(1,1,1,1,255,128,0), 0)
      Game():SpawnParticles(pos, EffectVariant.PLAYER_CREEP_RED, 1, 0, Color(1,1,1,1,255,128,0), 0)
    end
  end
  
}

-- Reroll
events.EV_Reroll = {
  
  name = "Reroll",
  weights = {0,.4,1},
  good = true,
  
  onStart = function ()
    Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_D4, true, true, true, false)
  end
  
}

-- Matrix
events.EV_Matrix = {
  
  name = "Matrix",
  weights = {1,1,1},
  good = true,
  
  duration = 50*30,
  
  onStart = function ()
    IOTR.Shaders.IOTR_ColorSides.enabled = true
    IOTR.Shaders.IOTR_ColorSides.params = {
      Intensity = .5,
      VColor = {0,1,0}
    }
  end,
  
  onEntityUpdate = function (entity)
    
    local p = Isaac.GetPlayer(0)
    local r = Game():GetRoom()
    
    if ((entity:IsActiveEnemy() and entity:IsVulnerableEnemy())) then
      entity.Velocity = entity.Velocity / 2
    elseif (entity.Type == EntityType.ENTITY_PROJECTILE and entity.Position:Distance(p.Position) < 65) then
      entity.Velocity = Vector(0,0)
    elseif (entity.Type == EntityType.ENTITY_EFFECT and entity.Variant == 1105 and entity.Position.Y > r:GetBottomRightPos().Y + 50 and Game():GetFrameCount() % 30 == 0) then
      entity:Remove()
    end
    
  end,
  
  onUpdate = function ()
    
    if (Game():GetFrameCount() % 8 ~= 0) then return end
    local r = Game():GetRoom()
    local min = r:GetTopLeftPos().X
    local max = r:GetBottomRightPos().X
    local height = r:GetTopLeftPos().Y - 50
    local ef = Isaac.Spawn(EntityType.ENTITY_EFFECT, 5745, 0, Vector(math.random(min, max), height), Vector(0, 12), Isaac.GetPlayer(0))
    
  end,
  
  onEnd = function ()
    IOTR.Shaders.IOTR_ColorSides.enabled = false
  end
  
}

-- Danger
events.EV_Danger = {
  
  name = "Danger",
  weights = {.8,1,1},
  good = true,

  byTime = false,
  onlyNewRoom = true,
  duration = 5,
  
  onStart = function ()
    IOTR.Shaders.IOTR_ColorSides.enabled = true
    IOTR.Shaders.IOTR_ColorSides.params = {
      Intensity = .6,
      VColor = {1,0,0}
    }
  end,
  
  onRoomChange = function ()
    
    local entities = Isaac.GetRoomEntities()
    for i = 1, #entities do
      if (entities[i]:IsActiveEnemy() and entities[i]:IsVulnerableEnemy() and not entities[i]:IsBoss()) then
        local clone = Isaac.Spawn(entities[i].Type, entities[i].Variant, entities[i].SubType, entities[i].Position:__add(Vector(20,0)), Vector(0,0), entities[i])
        clone:ToNPC():MakeChampion(Game():GetSeeds():GetNextSeed())
        clone:ToNPC().MaxHitPoints = clone:ToNPC().MaxHitPoints * 2
        clone:ToNPC().HitPoints = clone:ToNPC().HitPoints * 2
        
        entities[i]:ToNPC():MakeChampion(Game():GetSeeds():GetNextSeed())
        entities[i]:ToNPC().MaxHitPoints = entities[i]:ToNPC().MaxHitPoints * 2
        entities[i]:ToNPC().HitPoints = entities[i]:ToNPC().HitPoints * 2
      end
    end
    
  end,
  
  onEnd = function ()
    IOTR.Shaders.IOTR_ColorSides.enabled = false
  end
  
}

-- Torn Pockets
events.EV_TornPockets = {
  
  name = "TornPockets",
  weights = {.9,1,1},
  good = false,
  duration = 40*30,
  
  onUpdate = function ()
    
    if (Isaac.GetFrameCount() % 15 ~= 0) then return end
    local p = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    pos = room:FindFreeTilePosition(p.Position:__add(Vector(math.random(-60,60), math.random(-60,60))), 10)
    
    if (p:GetNumCoins() > 0 and math.random(1,10) == 1) then
      p:AddCoins(-1)
      Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN,  CoinSubType.COIN_PENNY, pos, Vector(0, 0), player)
    end
    
    if (p:GetNumBombs() > 0 and math.random(1,10) == 1) then
      p:AddBombs(-1)
      Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB,  BombSubType.BOMB_NORMAL, pos, Vector(0, 0), player)
    end
    
    if (p:GetNumKeys() > 0 and math.random(1,10) == 1) then
      p:AddKeys(-1)
      Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY,  KeySubType.KEY_NORMAL, pos, Vector(0, 0), player)
    end
    
    if (p:GetHearts () > 2 and math.random(1,10) == 1) then
      p:AddHearts(-2)
      Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART,  HeartSubType.HEART_FULL, pos, Vector(0, 0), player)
    end
    
    if (math.random(1,7) == 1) then
      p:DropTrinket(pos, true)
    end
    
  end
  
}

-- Gravity
events.EV_Gravity = {
  
  name = "Gravity",
  weights = {1,1,1},
  good = false,
  duration = 40*30,
  
  direct = math.random(0,3),
  
  onUpdate = function ()
    
    local p = Isaac.GetPlayer(0)
    
    local r = Game():GetRoom()
    local entities = Isaac.GetRoomEntities()
    
    if (IOTR.Events.EV_Gravity.direct == 0) then
      for i = r:GetTopLeftPos().Y + 10, r:GetBottomRightPos().Y - 10 do
        if (i % 30 == 0) then
          Game():SpawnParticles(Vector(r:GetTopLeftPos().X, i), EffectVariant.ULTRA_GREED_BLING, 1, 0, IOTR.Enums.Rainbow[5], 0)
        end
      end
      
      for i = 1, #entities do
        if (Isaac.GetFrameCount() % 2 == 0 and entities[i].Type ~= EntityType.ENTITY_EFFECT) then entities[i]:AddVelocity(Vector(-0.6, 0)) end
      end
      
    elseif (IOTR.Events.EV_Gravity.direct == 1) then
      for i = r:GetTopLeftPos().X + 10, r:GetBottomRightPos().X - 10 do
        if (i % 30 == 0) then
          Game():SpawnParticles(Vector(i, r:GetBottomRightPos().Y), EffectVariant.ULTRA_GREED_BLING, 1, 0, IOTR.Enums.Rainbow[5], 0)
        end
      end
      
      for i = 1, #entities do
        if (Isaac.GetFrameCount() % 2 == 0 and entities[i].Type ~= EntityType.ENTITY_EFFECT) then entities[i]:AddVelocity(Vector(0, 0.6)) end
      end
      
    elseif (IOTR.Events.EV_Gravity.direct == 2) then
      for i = r:GetTopLeftPos().Y + 10, r:GetBottomRightPos().Y - 10 do
        if (i % 30 == 0) then
          Game():SpawnParticles(Vector(r:GetBottomRightPos().X, i), EffectVariant.ULTRA_GREED_BLING, 1, 0, IOTR.Enums.Rainbow[5], 0)
        end
      end
      
      for i = 1, #entities do
        if (Isaac.GetFrameCount() % 2 == 0 and entities[i].Type ~= EntityType.ENTITY_EFFECT) then entities[i]:AddVelocity(Vector(0.6, 0)) end
      end
      
    elseif (IOTR.Events.EV_Gravity.direct == 3) then
      for i = r:GetTopLeftPos().X + 10, r:GetBottomRightPos().X - 10 do
        if (i % 30 == 0) then
          Game():SpawnParticles(Vector(i, r:GetTopLeftPos().Y), EffectVariant.ULTRA_GREED_BLING, 1, 0, IOTR.Enums.Rainbow[5], 0)
        end
      end
      
      for i = 1, #entities do
        if (Isaac.GetFrameCount() % 2 == 0 and entities[i].Type ~= EntityType.ENTITY_EFFECT) then entities[i]:AddVelocity(Vector(0, -0.6)) end
      end
    end
    
    if (Isaac.GetFrameCount() % 120 == 0) then IOTR.Events.EV_Gravity.direct = math.random(0,3) end
    
  end
  
}

-- Allergia
events.EV_Allergia = {
  
  name = "Allergia",
  weights = {1,1,1},
  good = false,
  duration = 40*30,
  
  onUpdate = function ()
    
    if (Isaac.GetFrameCount() % 110 == 0) then
      SFXManager():Play(IOTR.Sounds.list.allergia, 1.6, 0, false, 1)
      Game():ShakeScreen(30)
      local p = Isaac.GetPlayer(0)
      
      Game():SpawnParticles(p.Position, EffectVariant.IMPACT, 2, 0, Color(1, 1, 1, 1, 255, 255, 255), 0)
      local e = Isaac.GetRoomEntities()
      
      for k, v in pairs(e) do
          e[k]:AddVelocity(Vector(math.random(-20,20), math.random(-20,20)))
      end
      
      for i = 0, math.random(5,15) do
        p:FireTear(p.Position, Vector(math.random(-6,6), math.random(-6,6)), false, false, false)
      end
    end
    
  end
  
}

-- Heavy Rain
events.EV_HeavyRain = {
  
  name = "HeavyRain",
  weights = {1,1,1},
  good = true,
  duration = 40*30,
  
  onStart = function ()
    IOTR.Sounds.play(IOTR.Sounds.list.heavyrain)
  end,
  
  onUpdate = function ()
    
    Game():Darken(0.7, 10)
    local p = Isaac.GetPlayer(0)
    local e = Isaac.GetRoomEntities()
    
    
    local r = Game():GetRoom()
    local min = r:GetTopLeftPos().X - 400
    local max = r:GetBottomRightPos().X
    local height = r:GetTopLeftPos().Y - 50
    local speed = math.random(10, 15)
    local ef = Isaac.Spawn(EntityType.ENTITY_EFFECT, 5746, 0, Vector(math.random(min, max), height), Vector(speed, speed), p)
    ef:GetSprite():Play("Rain" .. math.random(1,3), true)
    
    Isaac.Spawn(
      EntityType.ENTITY_EFFECT,
      EffectVariant.WATER_SPLASH,
      0,
      r:GetClampedPosition(Vector(math.random(min, max), math.random(r:GetTopLeftPos().Y, r:GetBottomRightPos().Y)), 0),
      Vector(0, 0), p
    )
      
    if (Game():GetFrameCount() % 30 ~= 0) then return end
    
    if (math.random(1,3) == 2) then
      Isaac.Spawn(
        EntityType.ENTITY_EFFECT,
        EffectVariant.PLAYER_CREEP_HOLYWATER,
        0, r:GetClampedPosition(Vector(math.random(min, max), math.random(r:GetTopLeftPos().Y, r:GetBottomRightPos().Y)), 20),
        Vector(0, 0),
        p
      )
    end
  
    for k, v in pairs(e) do
      if (v.Type == EntityType.ENTITY_EFFECT and v.Variant == 5746 and v.Position.Y > r:GetBottomRightPos().Y + 50) then
        v:Remove()
      end
      
      if (v.Type == 33 and math.random(1,3) == 2) then
        v:TakeDamage (10, DamageFlag.DAMAGE_FIRE, EntityRef(p), 30)
      end
    end
    
  end
  
}

-- Marble Balls
events.EV_MarbleBalls = {
  
  name = "MarbleBalls",
  weights = {1,1,1},
  good = false,
  
  byTime = false,
  onlyNewRoom = true,
  duration = 4,
  
  onNewRoom = function ()
    
    local r = Game():GetRoom()
    local p = Isaac.GetPlayer(0)
    local min = r:GetTopLeftPos().X
    local max = r:GetBottomRightPos().X
    
    local colors = { IOTR.Enums.Rainbow[math.random(1,7)], IOTR.Enums.Rainbow[math.random(1,7)], IOTR.Enums.Rainbow[math.random(1,7)] }
    
    for i = 1, math.random(30, 70) do
      local b = Isaac.Spawn(5, math.random(5750, 5753), 0, r:FindFreePickupSpawnPosition(Vector(math.random(min, max), math.random(r:GetTopLeftPos().Y, r:GetBottomRightPos().Y)), 2, true), Vector(math.random(-10,10), math.random(-10,10)), p)
      b:SetColor(colors[math.random(1,3)], 0, 0, false, false)
    end
    
  end,
  
  onEntityUpdate = function (entity)
    if (entity.Type == 5 and entity.Variant >= 5750 and entity.Variant <= 5753) then
      entity:AddVelocity(Vector(math.random(-2,2), math.random(-2,2)))
    end
  end
  
  
}

-- We hate you
events.EV_WeHateYou = {
  
  name = "WeHateYou",
  weights = {.8,1,1},
  good = false,
  
  duration = 40*30,
  
  onEntityUpdate = function (entity)
    
    local p = Isaac.GetPlayer(0)
    
    if
      entity.Type == EntityType.ENTITY_PICKUP
      or entity.Type == EntityType.ENTITY_BOMBDROP
      or entity.Type == EntityType.ENTITY_SLOT
      or entity.Type == EntityType.ENTITY_FIREPLACE
      or entity.Type == EntityType.ENTITY_SHOPKEEPER
      or entity.Type == EntityType.ETERNAL_FLY
    then
      
      local dist = entity.Position:Distance(p.Position)
      local direct = entity.Position:__sub(p.Position):Normalized()
      
      if (dist > 130) then
        entity.Velocity = -direct:__mul(3)
      elseif (dist < 90) then
        entity.Velocity = direct:__mul(5)
      end
      
      if entity.FrameCount % 25 == 0 and math.random(0,1) == 1 then
        Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, entity.Position, Isaac.GetPlayer(0).Position:__sub(entity.Position):Normalized():__mul(10), entity)
      end
      
    end
  end
  
  
}

-- Call to the dark
events.EV_CallToDark = {
  
  name = "CallToDark",
  weights = {1,1,1},
  good = true,
  
  byTime = false,
  onlyNewRoom = true,
  duration = 5,
  
  onNewRoom = function ()
    local player = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    
    for i = 0, math.random(1,3) do
      local pos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20, true)
      local unit = Isaac.Spawn(EntityType.ENTITY_IMP, 0,  0, pos, Vector(0, 0), player)
      unit:AddCharmed(-1)
      unit:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
      Game():SpawnParticles(pos, EffectVariant.LARGE_BLOOD_EXPLOSION, 1, 0, Color(1,1,1,1,0,0,0), 0)
      Game():Darken(1, 90);
      IOTR.Sounds.play(SoundEffect.SOUND_SUMMONSOUND)
    end
    
  end
  
  
}

-- Five spaces
events.EV_FiveSpaces = {
  
  name = "FiveSpaces",
  weights = {.2,1,1},
  good = true,
  
  onStart = function ()
    
    local activeItems = {}
    
    local iconf = Isaac.GetItemConfig()
    
    for i = 1, CollectibleType.NUM_COLLECTIBLES do
      local rawItem = iconf:GetCollectible(i)
      if rawItem == nil then goto skipIteration end
      
      -- Check item type and push to storage
      if (rawItem.Type == ItemType.ITEM_ACTIVE) then table.insert(activeItems, i) end
      ::skipIteration::
    end
    
    for i = 1, 5 do
      Isaac.GetPlayer(0):UseActiveItem(activeItems[math.random(#activeItems)], true, true, true, false)
    end
    
  end
  
}

-- Bossfight
events.EV_Bossfight = {
  
  name = "Bossfight",
  weights = {.8,1,1},
  good = false,
  
  onStart = function ()
    local p = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    IOTR._.closeDoors()
    Isaac.Spawn(IOTR.Enums.Bosses[math.random(1, #IOTR.Enums.Bosses)], 0,  0, room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20, true), Vector(0, 0), p)
    
  end
  
}

-- Give Me Your Money
events.EV_GiveMeYourMoney = {
  
  name = "GiveMeYourMoney",
  weights = {.8,1,1},
  good = false,
  
  byTime = false,
  onlyNewRoom = true,
  duration = 4,
  
  cd = 60,
  
  onEntityUpdate = function (entity)
    local p = Isaac.GetPlayer(0)
    
    if (
      entity.Type == EntityType.ENTITY_SPIDER
      and entity.SubType == 500
      and p.Position:Distance(entity.Position) < 30
      and IOTR.Events.EV_GiveMeYourMoney.cd == 60
      and p:GetNumCoins() > 0
    ) then
      p:UseActiveItem(CollectibleType.COLLECTIBLE_PORTABLE_SLOT, false, false, false, false)
      entity:GetSprite():Play("Initiate", true)
      for i = 0, 4 do
        Game():SpawnParticles(entity.Position:__add(Vector(math.random(-25,25), math.random(-25,25))), EffectVariant.TEAR_POOF_SMALL, 1, 0, Color(1,1,0,1,255,255,0), 0)
      end
      IOTR.Sounds.play(SoundEffect.SOUND_COIN_SLOT)
      IOTR.Events.EV_GiveMeYourMoney.cd = 0
      
      -- Force stop animation
      p:AnimateAppear()
      p:StopExtraAnimation()
    end
  end,
  
  onUpdate = function ()
    if (IOTR.Events.EV_GiveMeYourMoney.cd < 60) then
      IOTR.Events.EV_GiveMeYourMoney.cd = IOTR.Events.EV_GiveMeYourMoney.cd + 1
    end
  end,
  
  onRoomChange = function ()
    
    local room = Game():GetRoom()
    local p = Isaac.GetPlayer(0)
    local haveSlot = Isaac.FindByType(EntityType.ENTITY_SPIDER, 0, 500, false, false)
    
    if #haveSlot == 0 then
      local slot = Isaac.Spawn(EntityType.ENTITY_SPIDER, 0,  500, room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20, true), Vector(0, 0), p)
      slot:GetSprite():Load("gfx/006.001_Slot Machine.anm2", true)
      slot:GetSprite():Play("Idle", true)
      slot:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
    end
    
  end,
  
  onEnd = function ()
    local haveSlot = Isaac.FindByType(EntityType.ENTITY_SPIDER, 0, 500, false, false)
    if (#haveSlot > 0) then
      haveSlot[1]:Remove()
    end
  end
  
}

-- Wall of tears
events.EV_WallOfTears = {
  
  name = "WallOfTears",
  weights = {1,1,1},
  good = true,
  
  duration = 45*30,
  
  
  onUpdate = function ()
    
    local p = Isaac.GetPlayer(0)
    local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, Game():GetRoom():GetRandomPosition(1), Vector(-20, 0), p):ToTear()
    tear.TearFlags = IOTR._.setbit(tear.TearFlags, TearFlags.TEAR_SPECTRAL)
    tear.TearFlags = IOTR._.setbit(tear.TearFlags, TearFlags.TEAR_PIERCING)
    tear.TearFlags = IOTR._.setbit(tear.TearFlags, TearFlags.TEAR_CONTINUUM)
    tear.CollisionDamage = 1
    
  end,
  
  
}

-- Flies and flies
events.EV_FliesAndFlies = {
  
  name = "FliesAndFlies",
  weights = {.8,1,1},
  good = false,
  
  duration = 40*30,
  
  
  onProjectileUpdate = function (entity)
    
    if (entity.FrameCount > 15 and Isaac.CountEntities(EntityType.ENTITY_ATTACKFLY, 0, 0) < 35) then
      local fly = Isaac.Spawn(EntityType.ENTITY_ATTACKFLY, 0, 0, entity.Position, entity.Velocity, entity):ToNPC()
      fly:SetColor(entity:GetColor(), 0, 0, false, false)
      fly.HitPoints = .2
      entity:Remove()
    end
    
  end,
  
  onNewRoom = function ()
    
    for i = 1, math.random(30,50) do
      Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BEETLE, 0, Game():GetRoom():GetRandomPosition(1), Vector(0,0), nil)
    end
    
    for i = 1, math.random(0,3) do
      Isaac.Spawn(EntityType.ENTITY_ATTACKFLY, 0, 0, Game():GetRoom():GetRandomPosition(1), Vector(0,0), nil)
    end
    
    for i = 1, math.random(0,2) do
      Isaac.Spawn(EntityType.ENTITY_FLY_L2, 0, 0, Game():GetRoom():GetRandomPosition(1), Vector(0,0), nil)
    end
    
    for i = 1, math.random(0,2) do
      Isaac.Spawn(EntityType.ENTITY_FULL_FLY, 0, 0, Game():GetRoom():GetRandomPosition(1), Vector(0,0), nil)
    end
    
    for i = 1, math.random(0,2) do
      Isaac.Spawn(EntityType.ENTITY_HUSH_FLY, 0, 0, Game():GetRoom():GetRandomPosition(1), Vector(0,0), nil)
    end
    
  end
  
  
}

-- Kill player
events.EV_KillPlayer = {
  
  name = "KillPlayer",
  weights = {1,1,1},
  good = true,
  
  onStart = function ()
    
    local player = Isaac.GetPlayer(0)
    player:AddHearts(24)
    player:AddSoulHearts(2)
    player:AddBlackHearts(2)
    
  end
  
}

-- C U R S E D
events.EV_Cursed = {
  
  name = "Cursed",
  weights = {.6,.8,1},
  good = false,
  
  onStart = function ()
    
    Game():GetLevel():AddCurse(
      LevelCurse.CURSE_OF_DARKNESS + LevelCurse.CURSE_OF_THE_LOST + LevelCurse.CURSE_OF_THE_UNKNOWN
      + LevelCurse.CURSE_OF_MAZE + LevelCurse.CURSE_OF_BLIND
    )
    
  end
  
}

-- Auto Aim
events.EV_AutoAim = {
  
  name = "AutoAim",
  weights = {.9,1,1},
  good = false,
  duration = 45*30,
  
  selectedEnemy = nil,
  targetEffect = nil,
  
  onEntityUpdate = function (entity)
    
    if (IOTR.Events.EV_AutoAim.selectedEnemy == nil or not IOTR.Events.EV_AutoAim.selectedEnemy:Exists()) and entity:IsVulnerableEnemy() and entity:IsActiveEnemy(false) then
      
      IOTR.Events.EV_AutoAim.selectedEnemy = entity
      
    end
    
  end,
  
  onUpdate = function ()
    
    if 
      (IOTR.Events.EV_AutoAim.targetEffect == nil or not IOTR.Events.EV_AutoAim.targetEffect:Exists())
      and (IOTR.Events.EV_AutoAim.selectedEnemy ~= nil and IOTR.Events.EV_AutoAim.selectedEnemy:Exists())
    then
      
      IOTR.Events.EV_AutoAim.targetEffect = Isaac.Spawn(
        EntityType.ENTITY_EFFECT, EffectVariant.TARGET, 150, 
        IOTR.Events.EV_AutoAim.selectedEnemy.Position, Vector(0,0),
        IOTR.Events.EV_AutoAim.selectedEnemy
      )
      
      IOTR.Events.EV_AutoAim.targetEffect:SetColor(IOTR.Enums.TintedRainbow[7], 0, 0, false, false)
      
    elseif IOTR.Events.EV_AutoAim.selectedEnemy ~= nil and IOTR.Events.EV_AutoAim.selectedEnemy:Exists() then
      IOTR.Events.EV_AutoAim.targetEffect.Position = IOTR.Events.EV_AutoAim.selectedEnemy.Position
    elseif IOTR.Events.EV_AutoAim.targetEffect ~= nil and IOTR.Events.EV_AutoAim.targetEffect:Exists() then
      IOTR.Events.EV_AutoAim.targetEffect:Die()
    end
    
  end,
  
  onTearUpdate = function (tear)
    
    if IOTR.Events.EV_AutoAim.selectedEnemy ~= nil and IOTR.Events.EV_AutoAim.selectedEnemy:Exists() then
      tear.Velocity = (IOTR.Events.EV_AutoAim.selectedEnemy.Position - tear.Position):Normalized()*20
    end
    
  end

  
}

-- Finger snap
events.EV_FingerSnap = {
  
  name = "FingerSnap",
  weights = {1,1,1},
  good = true,
  
  byTime = false,
  onlyNewRoom = true,
  duration = 5,
  
  gems = {},
  
  onUpdate = function ()
    
    for i = 1, #IOTR.Events.EV_FingerSnap.gems do
      
      local gem = IOTR.Events.EV_FingerSnap.gems[i]
      gem.TearFlags = IOTR._.setbit(gem.TearFlags, TearFlags.TEAR_WAIT)
      gem.Position = Isaac.GetPlayer(0).Position + Vector(80, 0):Rotated(360/6*i + gem.FrameCount)
      
    end
    
  end,
  
  onRoomChange = function ()
    IOTR.Events.EV_FingerSnap._spawnGems()
  end,
  
  onNewRoom = function ()
    IOTR.Sounds.play(SoundEffect.SOUND_ULTRA_GREED_COIN_DESTROY)
    
    for _, entity in pairs(Isaac.GetRoomEntities()) do
      
      if entity:IsActiveEnemy(false) and entity:IsVulnerableEnemy() and not entity:IsBoss() and math.random(1,2) == 2 then
        
        for i = 1, 10 do
          Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TOOTH_PARTICLE, 0, entity.Position + RandomVector()*8, RandomVector()*10, entity)
        end
        
        for i = 1, 3 do
          Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_BLACKPOWDER, 0, entity.Position + RandomVector()*3, Vector(0,0), entity)
        end
        
        entity:Die()
        
      end
      
    end
  end,
  
  _spawnGems = function ()
    local p = Isaac.GetPlayer(0)
    IOTR.Events.EV_FingerSnap.gems = {}
    
    for i = 1, 6 do
      local pos = p.Position + Vector(80, 0):Rotated(360/6*i)
      local gem = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.MYSTERIOUS, 0, pos, Vector(0,0), p):ToTear()
      
      if i < 5 then
        gem:SetColor(IOTR.Enums.TintedRainbow[i], 0, 0, false, false)
      else
        gem:SetColor(IOTR.Enums.TintedRainbow[i+1], 0, 0, false, false)
      end
      
      gem.TearFlags = IOTR._.setbit(gem.TearFlags, TearFlags.TEAR_SPECTRAL)
      gem.TearFlags = IOTR._.setbit(gem.TearFlags, TearFlags.TEAR_PIERCING)
      gem.TearFlags = IOTR._.setbit(gem.TearFlags, TearFlags.TEAR_WAIT)
      
      table.insert(IOTR.Events.EV_FingerSnap.gems, gem)
    end
  end
  
  
}

-- You belong to us
events.EV_YouBelongToUs = {
  
  name = "YouBelongToUs",
  weights = {.3,1,1},
  good = false,
  
  duration = 40*30,
  
  onStart = function ()
    Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS, false, true, false, false)
    IOTR.Server.addOutput({
      c = "toggleMovePlayer",
      d = {enable = true}
    })
  end,
  
  onEnd = function ()
    IOTR.Server.addOutput({
      c = "toggleMovePlayer",
      d = {enable = false}
    })
  end
  
  
}

-- Blue screen
events.EV_BlueScreen = {
  
  name = "BlueScreen",
  weights = {.9,1,1},
  good = false,
  
  duration = 45*30,
  
  currentText = {},
  
  onRoomChange = function ()
    Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_D6, false, false, false, false)
    Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_D10, false, false, false, false)
    Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_D12, false, false, false, false)
    Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_D20, false, false, false, false)
  end,
  
  onUpdate = function ()
    
    if (Game():GetFrameCount() % 15 ~= 0) then return end
    
    if (#IOTR.Events.EV_BlueScreen.currentText == 0) then
      table.insert(IOTR.Events.EV_BlueScreen.currentText, "A problem has been detected and Isaac has been shut down")
      table.insert(IOTR.Events.EV_BlueScreen.currentText, "")
    elseif (#IOTR.Events.EV_BlueScreen.currentText == 2) then
      table.insert(IOTR.Events.EV_BlueScreen.currentText, "The problem seems to be caused by the following file: Isaac.exe")
      table.insert(IOTR.Events.EV_BlueScreen.currentText, "")
    elseif (#IOTR.Events.EV_BlueScreen.currentText == 4) then
      table.insert(IOTR.Events.EV_BlueScreen.currentText, "ISAAC_MOD_API_IS_A_BIG_SHIT")
      table.insert(IOTR.Events.EV_BlueScreen.currentText, "")
    elseif (#IOTR.Events.EV_BlueScreen.currentText == 6) then
      table.insert(IOTR.Events.EV_BlueScreen.currentText, "If this is the first time you've seen this stop error screen, kill yourself")
      table.insert(IOTR.Events.EV_BlueScreen.currentText, "If this screen appears again, follow these steps:")
      table.insert(IOTR.Events.EV_BlueScreen.currentText, "")
    elseif (#IOTR.Events.EV_BlueScreen.currentText == 9) then
      table.insert(IOTR.Events.EV_BlueScreen.currentText, "1. Delete your game")
      table.insert(IOTR.Events.EV_BlueScreen.currentText, "")
    elseif (#IOTR.Events.EV_BlueScreen.currentText == 11) then
      table.insert(IOTR.Events.EV_BlueScreen.currentText, "2. DelEte your gAme")
      table.insert(IOTR.Events.EV_BlueScreen.currentText, "")
    elseif (#IOTR.Events.EV_BlueScreen.currentText == 13) then
      table.insert(IOTR.Events.EV_BlueScreen.currentText, "3. DEl3t3 y0ur g4m3")
      table.insert(IOTR.Events.EV_BlueScreen.currentText, "")
    elseif (#IOTR.Events.EV_BlueScreen.currentText == 15) then
      table.insert(IOTR.Events.EV_BlueScreen.currentText, "4. Dd EElefle te 444 Gaam33")
      table.insert(IOTR.Events.EV_BlueScreen.currentText, "")
    elseif (#IOTR.Events.EV_BlueScreen.currentText == 17) then
      table.insert(IOTR.Events.EV_BlueScreen.currentText, "Technical Information:")
      table.insert(IOTR.Events.EV_BlueScreen.currentText, "")
    elseif (#IOTR.Events.EV_BlueScreen.currentText == 19) then
      table.insert(IOTR.Events.EV_BlueScreen.currentText, "*** STOP: 0x1000007e (0xffffffffc0000005, 0xfffff80002e55151, 0xfffff880009a99d8)")
    elseif (#IOTR.Events.EV_BlueScreen.currentText == 20) then
      table.insert(IOTR.Events.EV_BlueScreen.currentText, "*** Isaac.exe - Address 0xfffff80002e55151 base at Edmund0x4ce7951a")
    else
      IOTR.Events.EV_BlueScreen.currentText = {}
    end
    
    IOTR.Text.add("blueScreen", IOTR.Events.EV_BlueScreen.currentText, Vector(45,10), nil, 1, nil, nil)
    
  end,
  
  onStart = function ()
    IOTR.Events.EV_BlueScreen.currentText = {}
    IOTR.Shaders.IOTR_OneColor.enabled = true
    IOTR.Shaders.IOTR_OneColor.params = {
      Intensity = 1,
      EnabledColor = 3
    }
    IOTR.Sounds.play(IOTR.Sounds.list.blueScreen)
  end,
  
  onEnd = function ()
    IOTR.Shaders.IOTR_OneColor.enabled = false
    IOTR.Text.remove("blueScreen")
  end
  
  
}

return events