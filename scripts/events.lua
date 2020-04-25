local events = {}

-- Example

--events.EventName = {
--
--  duration,   <-- Event duration, by room or by seconds, it depends on the variable byTime. If not defined, equals 0
--  byTime,     <-- If TRUE, duration decrease every second, if FALSE - every room changing. If not defined, equals TRUE
--  onStart,    <-- This function call when event started
--  onEnd,      <-- This function call when event ended
--  
--  Another callbacks equals DynamicCallbacks, you can see them on main.lua from line 497
--
--}

-- Debug event

events.EV_Debug = {
  
  duration = 5*30,
  byTime = true,
  
  onStart = function ()
    
    local player = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    
    player:AnimateHappy()
    
  end,
  
  onEnd = function ()
    
    local player = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    
    player:AnimateSad()
    
    Isaac.ConsoleOutput("Debug event end")
    
  end,
  
  onUpdate = function ()
    
    Isaac.ConsoleOutput(" bump ")
    
  end
  
}

-- Richy
events.EV_Richy = {
  
  onStart = function ()
    
    local player = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    
    room:TurnGold()
    
   for i = 0, 25 do
      Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN,  CoinSubType.COIN_PENNY, room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20, true), Vector(0, 0), player)
    end
    
  end
  
}


-- Poop
events.EV_Poop = {
  
  onStart = function ()
    
    local p = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    
    room:SetFloorColor(Color(0.424,0.243,0.063,1,-50,-50,-50))
    room:SetWallColor(Color(0.424,0.243,0.063,1,-50,-50,-50))
    
    for i = 0, math.random(3, 5) do
      local max = room:GetBottomRightPos()
      local pos = Vector(math.random(math.floor(max.X)), math.random(math.floor(max.Y)))
      pos = room:FindFreeTilePosition(pos, 0.5)
      Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_BUTT,  0, p.Position, Vector(math.random(-30,30), math.random(-30,30)), p)
      Isaac.GridSpawn(GridEntityType.GRID_POOP, 0, pos, false)
    end
    
    SFXManager():Play(SoundEffect.SOUND_FART, 1, 0, false, 1)
  end
  
}


-- Hell
events.EV_Hell = {
  
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
  
  byTime = false,
  duration = 5,
  
  onRoomChange = function ()
    
    local g = Game()
    local player = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    local entities = Isaac.GetRoomEntities()
    for i = 1, #entities do
      if entities[i]:IsActiveEnemy() and math.random(1,3) == 2 then
        local ref = EntityRef(entities[i])
        g:SpawnParticles(ref.Position, EffectVariant.CRACK_THE_SKY, 3, math.random(), Color(1, 1, 1, 1, 50, 50, 50), math.random())
        g:SpawnParticles(ref.Position, EffectVariant.BLUE_FLAME, 1, math.random(), Color(1, 1, 1, 1, 50, 50, 50), math.random())
      end
    end
      
    SFXManager():Play(SoundEffect.SOUND_HOLY, 1, 0, false, 1)
    room:SetFloorColor(Color(1,1,1,1,150,150,150))
    room:SetWallColor(Color(1,1,1,1,150,150,150))
    g:Darken(-1, 40);
  
  end
  
}

-- Devil Rage
events.EV_DevilRage = {
  
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
      
    SFXManager():Play(SoundEffect.SOUND_SATAN_APPEAR, 1, 0, false, 1)
    room:SetFloorColor(Color(0,0,0,1,-50,-50,-50))
    room:SetWallColor(Color(0,0,0,1,-50,-50,-50))
    Game():Darken(1, 60);
    
  end
  
}

-- Rainbow Rain
events.EV_RainbowRain = {
  
  onStart = function ()
    
    local player = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    
    for i = 0, room:GetGridSize()/5 do
      local max = room:GetBottomRightPos()
      local pos = Vector(math.random(math.floor(max.X)), math.random(math.floor(max.Y)))
      pos = room:FindFreeTilePosition(pos, 0.5)
      Game():SpawnParticles(pos, EffectVariant.CRACK_THE_SKY, 1, math.random(), ITMR.Enums.Rainbow[math.random(#ITMR.Enums.Rainbow)], math.random())
      Game():SpawnParticles(pos, EffectVariant.PLAYER_CREEP_HOLYWATER, 1, 0, ITMR.Enums.Rainbow[math.random(#ITMR.Enums.Rainbow)], 0)
    end
    
    SFXManager():Play(SoundEffect.SOUND_WATER_DROP, 1, 0, false, 1)
    
  end
  
}


return events