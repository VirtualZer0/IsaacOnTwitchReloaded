local passiveItems = {}


--local PI_bcouch = Isaac.GetItemIdByName("BCouch")

-- Example
--passiveItems.ItemName= {
--  id = Isaac.GetItemIdByName("Item Name"),                    <-- Item Id
--  name = "Item Name"  <-- Item name, required for dynamic item loading on site
--  description = {en = "Item description", ru = "Описание" },  <-- Item description for external item description mod
--  count = 0,                                                  <-- Player items count
--  onPickup = nil,                                             <-- Function, called on pickup item
--  onRemove = nil                                              <-- Function, called when item removed
--  
--  Another callbacks equals DynamicCallbacks, you can see them on main.lua from line 497
--
--}



-- Kappa
passiveItems.PI_Kappa = {
  
  id = Isaac.GetItemIdByName("Kappa"),
  name = "Kappa",
  description = {
    en = "\1 +2.5 Damage Up",
    ru = "\1 +2.5 к урону"
  },
  count = 0,
  cacheFlag = CacheFlag.CACHE_DAMAGE,
  
  onCacheUpdate = function (obj, player, cacheFlag)
    if (cacheFlag == CacheFlag.CACHE_DAMAGE or cacheFlag == CacheFlag.CACHE_ALL) then
      player.Damage = player.Damage + player:GetCollectibleNum(IOTR.Items.Passive.PI_Kappa.id) * 2.5
    end
  end
}

-- Golden Kappa
passiveItems.PI_GoldenKappa = {
  
  id = Isaac.GetItemIdByName("Golden Kappa"),
  name = "Golden Kappa",
  
  description = {
    en = "\015 + 15 Coins#\189 + Golden bomb#\5 + Golden key#\6 + 2 Golden hearts",
    ru = "\015 + 15 монет#\5 + Золотая бомба#\5 + Золотой ключ#\6 + 2 золотых сердца"
  },
  
  count = 0,
  
  onPickup = function ()
    local player = Isaac.GetPlayer(0)
    player:AddGoldenKey();
    player:AddGoldenBomb();
    player:AddGoldenHearts(2);
    Game():GetRoom():TurnGold();
  end
}

-- Not Like This
passiveItems.PI_NotLikeThis = {
  
  id = Isaac.GetItemIdByName("Not Like This"),
  name = "Not Like This",
  
  description = {
    en = "Reroll enemies on every room",
    ru = "Реролит врагов в каждой комнате при входе в нее"
  },
  
  count = 0,
  
  onRoomChange = function ()
    local entities = Isaac.GetRoomEntities()
    for i = 1, #entities do
      if (entities[i]:IsEnemy() == true) then
        Game():RerollEnemy(entities[i])
      end
    end
  end
}

-- Kappa Pride
passiveItems.PI_KappaPride = {
  
  id = Isaac.GetItemIdByName("Kappa Pride"),
  name = "Kappa Pride",
  
  description = {
    en = "Every tear have a chance to spawn 6 another tears with different effects#This tears deal 1/6 of your damage",
    ru = "Каждая слеза имеет шанс заспавнить 6 других слез с разными эффектами#Эти слезы наносят 1/6 от вашего урона"
  },
  
  count = 0,
  
  onTearUpdate = function (obj, e)
    
    local p = Isaac.GetPlayer(0)
    
    if (math.random(1,80) == 1 and e.SpawnerType == EntityType.ENTITY_PLAYER) then
      
      local rotate = math.random(0,360)
      local t = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.MYSTERIOUS, 0, e.Position, e.Velocity:Rotated(0 + rotate):__mul(0.4), e)
      t:SetColor(IOTR.Enums.Rainbow[1], 0, 0, false, false)
      t:ToTear().TearFlags = TearFlags.TEAR_STICKY + TearFlags.TEAR_SPECTRAL
      t:ToTear().Scale = 0.6
      t.CollisionDamage = p.Damage / 6
      
      t = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.MYSTERIOUS, 0, e.Position, e.Velocity:Rotated(60 + rotate):__mul(0.4), e)
      t:SetColor(IOTR.Enums.Rainbow[2], 0, 0, false, false)
      t:ToTear().TearFlags = TearFlags.TEAR_BURN + TearFlags.TEAR_SPECTRAL
      t:ToTear().Scale = 0.6
      t.CollisionDamage = p.Damage / 6
      
      t = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.MYSTERIOUS, 0, e.Position, e.Velocity:Rotated(120 + rotate):__mul(0.4), e)
      t:SetColor(IOTR.Enums.Rainbow[3], 0, 0, false, false)
      t:ToTear().TearFlags = TearFlags.TEAR_GREED_COIN + TearFlags.TEAR_SPECTRAL
      t:ToTear().Scale = 0.6
      t.CollisionDamage = p.Damage / 6
      
      t = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.MYSTERIOUS, 0, e.Position, e.Velocity:Rotated(180 + rotate):__mul(0.4), e)
      t:SetColor(IOTR.Enums.Rainbow[4], 0, 0, false, false)
      t:ToTear().TearFlags = TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP + TearFlags.TEAR_SPECTRAL
      t:ToTear().Scale = 0.6
      t.CollisionDamage = p.Damage / 6
      
      t = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.MYSTERIOUS, 0, e.Position, e.Velocity:Rotated(240 + rotate):__mul(0.4), e)
      t:SetColor(IOTR.Enums.Rainbow[6], 0, 0, false, false)
      t:ToTear().TearFlags = TearFlags.TEAR_FREEZE + TearFlags.TEAR_SPECTRAL
      t:ToTear().Scale = 0.6
      t.CollisionDamage = p.Damage / 6
      
      t = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.MYSTERIOUS, 0, e.Position, e.Velocity:Rotated(300 + rotate):__mul(0.4), e)
      t:SetColor(IOTR.Enums.Rainbow[7], 0, 0, false, false)
      t:ToTear().TearFlags = TearFlags.TEAR_FEAR + TearFlags.TEAR_SPECTRAL
      t:ToTear().Scale = 0.6
      t.CollisionDamage = p.Damage / 6
    end
  end
}

-- SSSsss
passiveItems.PI_SSSsss = {
  
  id = Isaac.GetItemIdByName("SSSsss"),
  name = "SSSsss",
  
  description = {
    en = "Enemies exploding after death",
    ru = "Враги взрываются при смерти"
  },
  
  count = 0,
  
  onNPCDeath = function (obj, entity)
    if entity:IsBoss() then
      Isaac.Explode(entity.Position, entity, 60.0)
      Isaac.Explode(entity.Position, entity, 60.0)
      Isaac.Explode(entity.Position, entity, 60.0)
    else
      Isaac.Explode(entity.Position, entity, 30.0)
    end
  end
}

-- Curse Lit
passiveItems.PI_CurseLit = {
  
  id = Isaac.GetItemIdByName("Curse Lit"),
  name = "Curse Lit",
  
  description = {
    en = "Curses give permanent random stats up",
    ru = "Проклятья навсегда увеличивают случайный стат"
  },
  
  count = 0,
  
  onStageChange = function ()
    
    local p = Isaac.GetPlayer(0)
    
    if Game():GetLevel():GetCurses() ~= LevelCurse.CURSE_NONE then
      local rnd = math.random(0,5)
      if (rnd == 0) then IOTR.Storage.Stats.damage = IOTR.Storage.Stats.damage + 0.5
      elseif (rnd == 1 and p.FireDelay > p.MaxFireDelay) then IOTR.Storage.Stats.tears = IOTR.Storage.Stats.tears - 1
      elseif (rnd == 2) then IOTR.Storage.Stats.tearspeed = IOTR.Storage.Stats.tearspeed + 0.2
      elseif (rnd == 3 and p.MoveSpeed < 2) then IOTR.Storage.Stats.speed = IOTR.Storage.Stats.speed + 0.2
      else p.Luck = p.Luck + 1; IOTR.Storage.Stats.luck = IOTR.Storage.Stats.luck + 1 end
      p:AddCacheFlags(CacheFlag.CACHE_ALL)
      p:EvaluateItems()
    end
  end,
  
  onPickup = function ()
    passiveItems.PI_CurseLit.onStageChange()
  end
}

-- Drink Purple
passiveItems.PI_DrinkPurple = {
  
  id = Isaac.GetItemIdByName("Drink Purple"),
  name = "Drink Purple",
  
  description = {
    en = "\1 +0.35 Speed Up#Spawn 1-2 Twtich hearts on pickup",
    ru = "\1 +0.35 к скорости#Спавнит 1-2 Твич-сердца при поднятии"
  },
  
  count = 0,
  cacheFlag = CacheFlag.CACHE_SPEED,
  
  onCacheUpdate = function (obj, player, cacheFlag)
    if (cacheFlag == CacheFlag.CACHE_SPEED or cacheFlag == CacheFlag.CACHE_ALL) then
      player.MoveSpeed = player.MoveSpeed + player:GetCollectibleNum(IOTR.Items.Passive.PI_DrinkPurple.id) * 0.35
    end
  end,
  
  onPickup = function ()
    local p = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    
    Isaac.Spawn(EntityType.ENTITY_PICKUP, 1000,  0, room:FindFreePickupSpawnPosition(p.Position, 0, true), Vector(0, 0), p)
    if (math.random(0,2) == 1) then
      Isaac.Spawn(EntityType.ENTITY_PICKUP, 1000,  0, room:FindFreePickupSpawnPosition(p.Position, 0, true), Vector(0, 0), p)
    end
  end
}

-- Kreygasm
passiveItems.PI_Kreygasm = {
  
  id = Isaac.GetItemIdByName("Kreygasm"),
  name = "Kreygasm",
  
  description = {
    en = "Random effect for enemies in room",
    ru = "Накладывает случайный эффект на часть врагов в комнате"
  },
  
  count = 0,
  
  onRoomChange = function ()
    local p = Isaac.GetPlayer(0)
    local entities = Isaac.GetRoomEntities()
    for i = 1, #entities do
      if (entities[i]:IsActiveEnemy(false) == true and math.random() > 0.5) then
        local rnd = math.random(0,9)
        local ref = EntityRef(p)
        if (rnd == 0) then entities[i]:AddPoison(ref, math.random(30,300), math.random())
        elseif (rnd == 1) then entities[i]:AddFreeze(ref, math.random(30,300))
        elseif (rnd == 2) then entities[i]:AddSlowing(ref, math.random(30,300), math.random(), Color(1,1,1,1,0,0,0))
        elseif (rnd == 3) then entities[i]:AddCharmed(math.random(30,300))
        elseif (rnd == 4) then entities[i]:AddConfusion(ref, math.random(30,300), false)
        elseif (rnd == 5) then entities[i]:AddMidasFreeze(ref, math.random(30,300))
        elseif (rnd == 6) then entities[i]:AddFear(ref, math.random(30,300))
        elseif (rnd == 7) then entities[i]:AddBurn(ref, math.random(30,300), math.random())
        else entities[i]:AddShrink(ref, math.random(30,300)) end
      end
    end
  end
}

-- Future Man
passiveItems.PI_FutureMan = {
  
  id = Isaac.GetItemIdByName("Future Man"),
  name = "Future Man",
  
  description = {
    en = "Spawn rotating beam#Beam deals 5% of player damage",
    ru = "Спавнит вращающийся луч#Луч наносит 5% от вашего урона"
  },
  
  count = 0,
  
  onRoomChange = function ()
    local p = Isaac.GetPlayer(0)
    -- This laser give damage
    local laser1 = EntityLaser.ShootAngle(5, p.Position, 0, 0, Vector(0,0), p)
    laser1:SetActiveRotation(1, 999360, p.ShotSpeed*8, true)
    laser1.CollisionDamage = p.Damage/20;
    laser1.CurveStrength = 0
    laser1.Visible = false
    -- This laser only for decoration
    local laser2 = EntityLaser.ShootAngle(7, p.Position, 0, 0, Vector(0,0), p)
    laser2:SetActiveRotation(1, 999360, p.ShotSpeed*8, true)
    laser2.CurveStrength = 0
    laser2.CollisionDamage = 0
  end,
  
  onPickup = function ()
    passiveItems.PI_FutureMan.onRoomChange()
  end
}

-- Brain Slug
passiveItems.PI_BrainSlug = {
  
  id = Isaac.GetItemIdByName("Brain Slug"),
  name = "Brain Slug",
  
  description = {
    en = "Enemies move to player shot direction",
    ru = "Враги смещаются в сторону вашего выстрела"
  },
  
  count = 0,
  
  onEntityUpdate = function (entity)
    if (entity:IsActiveEnemy() and entity:IsVulnerableEnemy()) then
      entity = entity:ToNPC()
      local p = Isaac.GetPlayer(0)
      if (p:GetFireDirection() ~= Direction.NO_DIRECTION and not entity:IsBoss()) then
        entity:AddVelocity(Vector(p:GetShootingJoystick().X*0.9, p:GetShootingJoystick().Y*0.9))
      end
    end
  end
}

return passiveItems