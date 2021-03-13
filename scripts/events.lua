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
      local enemyType = IOTR.Enums.AngelRage[math.random(#IOTR.Enums.AngelRage)]
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
      local enemyType = IOTR.Enums.DevilRage[math.random(#IOTR.Enums.DevilRage)]
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
      Game():SpawnParticles(pos, EffectVariant.CRACK_THE_SKY, 1, math.random(), IOTR.Enums.Rainbow[math.random(#IOTR.Enums.Rainbow)], math.random())
      Game():SpawnParticles(pos, EffectVariant.PLAYER_CREEP_HOLYWATER, 1, 0, IOTR.Enums.Rainbow[math.random(#IOTR.Enums.Rainbow)], 0)
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
    IOTR.Shaders.IOTR_Bloody.enabled = true
    SFXManager():Play(IOTR.Sounds.list.attackOnTitan, 2, 0, false, 1)
  end,
  
  onEntityUpdate = function (entity)
    
    if (entity:IsActiveEnemy() and entity:ToNPC().Scale ~= 2.5) then
      entity:ToNPC().Scale = 2.5
      entity:ToNPC().MaxHitPoints = entity:ToNPC().MaxHitPoints*4
      entity:ToNPC().HitPoints = entity:ToNPC().HitPoints*4
    end
    
  end,
  
  onEnd = function ()
    IOTR.Shaders.IOTR_Bloody.enabled = false
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
  weights = {.9,1,1},
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
  duration = 20*30,
  
  onUpdate = function ()
    if (Game():GetFrameCount() % 2 ~= 0) then return end
    local p = Isaac.GetPlayer(0)
    p:AddCoins(math.random(-1,1))
    p:AddKeys(math.random(-1,1))
    p:AddBombs(math.random(-1,1))
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
  byTime = false,
  duration = 5,
  
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
    
    p:SetColor(IOTR.Enums.Rainbow[4], 0, 0, false, false)
    
    for i = 0, math.random(2,4) do
      local pos = room:GetRandomPosition(2)
      if (p.Position:Distance(pos) >= 65) then
        Game():SpawnParticles(pos, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 10, 0, IOTR.Enums.Rainbow[4], 0)
        Game():SpawnParticles(pos, EffectVariant.FART, 1, 0, IOTR.Enums.Rainbow[4], 0)
        Game():Spawn(IOTR.Enums.Buddies[4], 0, pos, Vector(0,0), p, 0, 0)
      end
    end
    
    for i = 0, math.random(5,10) do
      local pos = room:GetRandomPosition(2)
      if (p.Position:Distance(pos) >= 65) then
        Game():SpawnParticles(pos, EffectVariant.CREEP_GREEN, 1, 0, IOTR.Enums.Rainbow[4], 0)
      end
    end
    
    room:SetWallColor(Color(0.5,1,0,1,50,100,-20))
    room:SetFloorColor(Color(0.5,1,0,1,50,100,-20))
  end,
  
  onStart = function ()
    
    IOTR.Shaders.IOTR_ColorSides.enabled = true
    IOTR.Shaders.IOTR_ColorSides.params = {
      Intensity = 1,
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
  good = true,
  duration = 40*30,
  
  onUpdate = function ()
    local frame = Game():GetFrameCount()
    if (frame % 15 ~= 0) then return end
    
    local p = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    
    local doors = {}
    
    for i = DoorSlot.LEFT0, DoorSlot.DOWN1 do
      if (room:IsDoorSlotAllowed(i) and room:GetDoor(i) ~= nil) then
        local door = room:GetDoor(i)
        table.insert(doors, door)
        door:SetRoomTypes(room:GetType(), IOTR.Enums.Doors[math.random(#IOTR.Enums.Doors)])
      end
    end
    
    for i = 1, #doors do
      local door = doors[i]
      if (p.Position:Distance(door.Position) < 30) then
        p.Position = doors[math.random(#doors)].Position
        IOTR.Cmd.send("Door reached")
      end
    end
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
      Intensity = 1,
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
    if (entity:IsActiveEnemy() and entity:IsVulnerableEnemy()) then
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
        
        if (math.random(1,3) == 1) then
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
  weights = {.05,.4,1},
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
    
    local rng = RNG()
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
  weights = {.05,.4,1},
  good = false,
  duration = 10*30,
  
  onUpdate = function ()
    
    if (Isaac.GetFrameCount() % 60 ~= 0) then return end
    
    Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_CLICKER, true, true, true, false)
    
    local rng = RNG()
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
  duration = 5,
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
      and entity.Type > EntityType.ENTITY_PROJECTILE
      and entity.Type < EntityType.ENTITY_EFFECT
      and entity:IsDead() and math.random(1,1+bossDelay)
    ) then
      Game():Spawn(EntityType.ENTITY_THE_HAUNT, 10, entity.Position, Vector(0,0), entity, 0, 0)
    end
    
  end
  
}

return events