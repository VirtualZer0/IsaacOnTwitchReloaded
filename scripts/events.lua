local events = {}

-- Example

--events.EventName = {
--
--  name,       <-- Event name, using as key for locale, then sended to isaacontwitch.com when game connected
--  weights,    <-- Array with weights for gamemodes: [easy, normal, crazy]
--  good,       <-- If true, play happy animation, else - sad animation
--  duration,   <-- Event duration, by room or by seconds, it depends on the variable byTime. If not defined, equals 0
--  byTime,     <-- If TRUE, duration decrease every second, if FALSE - every room changing. If not defined, equals TRUE
--  onStart,    <-- This function call when event started
--  onEnd,      <-- This function call when event ended
--  
--  Another callbacks equals DynamicCallbacks, you can see them on main.lua from line 497
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
      poop:ToNPC().Scale = math.random(2, 7)/10
    end
    
    for i = 0, math.random(5, 8) do
      local max = room:GetBottomRightPos()
      local pos = Vector(math.random(math.floor(max.X)), math.random(math.floor(max.Y)))
      pos = room:FindFreeTilePosition(pos, 0.5)
      local poop = Isaac.Spawn(EntityType.ENTITY_DIP, 0, 1, pos, Vector(math.random(-20,20)*2, math.random(-20,20)*2), nil)
      poop:ToNPC().Scale = math.random(2, 7)/10
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
      if (player.Position:Distance(posv) >= 65) then
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
      local posv = Vector(math.random(math.floor(max.X)), math.random(math.floor(max.Y)))
      pos = room:FindFreeTilePosition(posv, 0.5)
      if (player.Position:Distance(posv) >= 65) then
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
  
  byTime = false,
  duration = 3,
  
  onRoomChange = function ()
    
    local g = Game()
    local	entities = Isaac.GetRoomEntities()
    local player = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    
    g:ShakeScreen(100)
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
    
  end
  
}

-- Angel Rage
events.EV_AngelRage = {
  
  name = "AngelRage",
  weights = {1,1,1},
  good = true,
  
  byTime = false,
  duration = 5,
  
  onRoomChange = function ()
    
    local g = Game()
    local player = Isaac.GetPlayer(0)
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
    room:SetFloorColor(Color(1,1,1,1,150,150,150))
    room:SetWallColor(Color(1,1,1,1,150,150,150))
    g:Darken(-1, 40);
    
    for i = 1, math.random(1,3) do
      local max = room:GetBottomRightPos()
      local pos = Vector(math.random(math.floor(max.X)), math.random(math.floor(max.Y)))
      pos = room:FindFreeTilePosition(pos, 0.5)
      local enemyType = ITMR.Enums.AngelRage[math.random(#ITMR.Enums.AngelRage)]
      local enemy = Isaac.Spawn(enemyType, 0,  0, pos, Vector(math.random(-20, 20), math.random(-20, 20)), p)
      enemy:AddCharmed(-1)
      enemy:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
    end
  
  end
  
}

-- Devil Rage
events.EV_DevilRage = {
  
  name = "DevilRage",
  weights = {0.9,1,1},
  good = false,
  
  byTime = false,
  duration = 5,
  
  onRoomChange = function ()
    
    local player = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    
    for i = 1, math.random(3,7) do
        local pos = room:GetRandomPosition(1)
        Game():SpawnParticles(pos, EffectVariant.CRACK_THE_SKY, 3, math.random(), Color(1, 0, 0, 1, 50, 0, 0), math.random())
        Game():SpawnParticles(pos, EffectVariant.LARGE_BLOOD_EXPLOSION, 1, math.random(), Color(1, 0, 0, 1, 50, 0, 0), math.random())
    end
    
    for i = 1, math.random(1,3) do
      local max = room:GetBottomRightPos()
      local pos = Vector(math.random(math.floor(max.X)), math.random(math.floor(max.Y)))
      pos = room:FindFreeTilePosition(pos, 0.5)
      local enemyType = ITMR.Enums.DevilRage[math.random(#ITMR.Enums.DevilRage)]
      local enemy = Isaac.Spawn(enemyType, 0,  0, pos, Vector(math.random(-20, 20), math.random(-20, 20)), p)
    end
      
    SFXManager():Play(SoundEffect.SOUND_SATAN_APPEAR, 1, 0, false, 1)
    room:SetFloorColor(Color(0,0,0,1,-50,-50,-50))
    room:SetWallColor(Color(0,0,0,1,-50,-50,-50))
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
      Game():SpawnParticles(pos, EffectVariant.CRACK_THE_SKY, 1, math.random(), ITMR.Enums.Rainbow[math.random(#ITMR.Enums.Rainbow)], math.random())
      Game():SpawnParticles(pos, EffectVariant.PLAYER_CREEP_HOLYWATER, 1, 0, ITMR.Enums.Rainbow[math.random(#ITMR.Enums.Rainbow)], 0)
    end
    
    SFXManager():Play(SoundEffect.SOUND_WATER_DROP, 1, 0, false, 1)
    
  end
  
}

-- RUN
events.EV_RUN = {
  
  name = "RUN",
  weights = {0.9,1,1},
  good = false,
  
  duration = 15*30,
  
  onRoomChange = function ()
    
    local room = Game():GetRoom()
    local max = room:GetBottomRightPos()
    local pos = Vector(math.random(math.floor(max.X)), math.random(math.floor(max.Y)))
    pos = room:FindFreeTilePosition(pos, 0.5)
    Game():SpawnParticles(pos, EffectVariant.HUSH_LASER, 1, math.random(), ITMR.Enums.Rainbow[math.random(#ITMR.Enums.Rainbow)], math.random())
    
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
  weights = {1,1,1},
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
  
  name = "AttckOnTitan",
  weights = {0.9,1,1},
  good = false,
  
  duration = 45*30,
  
  onStart = function ()
    ITMR.Shaders.ITMR_Bloody.enabled = true
    SFXManager():Play(ITMR.Sounds.attackOnTitan, 2, 0, false, 1)
  end,
  
  onEntityUpdate = function (entity)
    
    if (entity:IsActiveEnemy() and entity:ToNPC().Scale ~= 2.5) then
      entity:ToNPC().Scale = 2.5
      entity:ToNPC().MaxHitPoints = entity:ToNPC().MaxHitPoints*4
      entity:ToNPC().HitPoints = entity:ToNPC().HitPoints*4
    end
    
  end,
  
  onEnd = function ()
    ITMR.Shaders.ITMR_Bloody.enabled = false
    local e = Isaac.GetRoomEntities()
    
    for k, v in pairs(e) do
      if (v:IsActiveEnemy() and v:ToNPC().Scale == 2.5) then
        v:ToNPC().Scale = 1
        v:ToNPC().MaxHitPoints = v:ToNPC().MaxHitPoints/4
        v:ToNPC().HitPoints = v:ToNPC().HitPoints/4
      end
    end
  end
  
}

-- Diarrhea
events.EV_Diarrhea = {
  
  name = "Diarrhea",
  weights = {1,1,1},
  good = false,
  
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
  weights = {0.8,1,1},
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
  weights = {0.2,1,1},
  good = true,
  
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
      player:AddSoulHearts(-player:GetSoulHearts() + 1)
    end
    
  end
  
}

-- DDoS
events.EV_DDoS  = {
  
  name = "DDoS",
  weights = {0.4,0.8,1},
  good = false,
  
  duration = 30*30,
  
  onStart = function ()
    ITMR.Shaders.ITMR_Glitch.enabled = true
    ITMR.Shaders.ITMR_Glitch.params.time = 10000
    
    SFXManager():Play(ITMR.Sounds.ddosDialup, 1, 0, false, 1)
  end,
  
  onUpdate = function ()
    
    ITMR.Shaders.ITMR_Glitch.params.time = ITMR.Shaders.ITMR_Glitch.params.time + 1
    
    if (Game():GetFrameCount() % 10 == 0) then
      local room = Game():GetRoom()
      local p = Isaac.GetPlayer(0)
      local pos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20, true)
      local fly = Isaac.Spawn(EntityType.ENTITY_DART_FLY, 0,  0, pos, Vector(0, 0), p)
      ITMR.Text.add(
        "ddos" .. tostring(ITMR.Shaders.ITMR_Glitch.params.time), 
        tostring(math.random(1,255)).."."..tostring(math.random(1,255)).."."..tostring(math.random(1,255)).."."..tostring(math.random(1,255))
      )
      ITMR.Text.follow("ddos" .. tostring(ITMR.Shaders.ITMR_Glitch.params.time), fly)
    end
    
  end,
  
  onEnd = function ()
    ITMR.Shaders.ITMR_Glitch.enabled = false
  end
  
}

-- Interstellar
events.EV_Interstellar  = {
  
  name = "Interstellar",
  weights = {0.8,1,1},
  good = false,
  
  duration = 30*30,
  
  onStart = function ()
    ITMR.Shaders.ITMR_Swirl.enabled = true
    
    SFXManager():Play(ITMR.Sounds.interstellar, 1, 0, false, 1)
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
    for k, v in pairs(e) do
      if (v.Type ~= EntityType.ENTITY_EFFECT and v.Variant ~= 1100) then
        local vec = Vector(v.Position.X - room:GetCenterPos().X, v.Position.Y - room:GetCenterPos().Y):Normalized()
        
        if (v.Type == EntityType.ENTITY_PLAYER) then
          v:AddVelocity(Vector(-vec.X*0.8, -vec.Y*0.8))
        else
          v:AddVelocity(Vector(-vec.X*5, -vec.Y*5))
        end
        
        if (room:GetCenterPos():Distance(v.Position) <= 40) then
          if (v.Type == EntityType.ENTITY_PICKUP or v.Type == EntityType.ENTITY_TEAR or v.Type == EntityType.ENTITY_PROJECTILE or (v.Type == EntityType.ENTITY_EFFECT and v.Variant == 103)) then
            v:Die()
          elseif (v.Type == EntityType.ENTITY_PLAYER) then
            v:TakeDamage(0.5, DamageFlag.DAMAGE_LASER, EntityRef(p), 30)
          else
            v:TakeDamage(2, DamageFlag.DAMAGE_LASER, EntityRef(p), 10)
          end
        end
        
      end
      
      if (v.Type == 1000 and v.Variant == 1100) then
        sbh = true
      end
    end
    
    if (not sbh) then
      local bh = Isaac.Spawn(1000, 1100,  0, room:GetCenterPos(), Vector(0, 0), p)
      bh:GetSprite():Play("Default", true)
      for i = 0, 3 do
        local l = EntityLaser.ShootAngle(7, room:GetCenterPos(), 90*i, 0, Vector(0,0), bh)
        l:SetActiveRotation(1, 999360, 10, true)
      end
    end
    
  end,
  
  onEnd = function ()
    ITMR.Shaders.ITMR_Glitch.enabled = false
    
    local e = Isaac.GetRoomEntities()
    for k, v in pairs(e) do
      if (v.Type == EntityType.ENTITY_EFFECT and v.Variant == 1100) then
        v:GetSprite():Play("Disappear", true)
        v:Die()
      end
    end
  end
  
}

return events