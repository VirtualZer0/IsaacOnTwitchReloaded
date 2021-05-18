local passiveItems = {}
local json = require('json')

--local PI_bcouch = Isaac.GetItemIdByName("BCouch")

-- Example
--passiveItems.ItemName= {
--  id = Isaac.GetItemIdByName("Item Name"),                    <-- Item Id
--  famId = Isaac.GetEntityVariantByName("Entity Name")         <-  If this item is familiar, set familiar entity variant
--  famFollowPlayer = true                                      <- If TRUE, add familiar to familiars train
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
  
  onCacheUpdate = function (player, cacheFlag)
    if (IOTR._.hasbit(cacheFlag, CacheFlag.CACHE_DAMAGE)) then
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
    en = "Every tear have a chance to spawn 6 another tears with different effects#This tears deal 1/6 of your damage#100% chance on 15 luck",
    ru = "Каждая слеза имеет шанс заспавнить 6 других слез с разными эффектами#Эти слезы наносят 1/6 от вашего урона#100% шанс с удачей 15"
  },
  
  count = 0,
  
  onEntityUpdate = function (e)
    local p = Isaac.GetPlayer(0)
    
    if
      (
        p.Luck >= 15
        or math.random(math.ceil(p.Luck*5),80) == 80
      )
      and e.SpawnerType == EntityType.ENTITY_PLAYER
      and ((e.Type == EntityType.ENTITY_LASER and e.Variant ~= 7 and e.Visible) or e.Type == EntityType.ENTITY_KNIFE or e.Type == EntityType.ENTITY_TEAR)
      and Isaac.GetFrameCount() % 3 == 0
    then
      
      local pos
      local repeats = 1
      
      if (e.Type == EntityType.ENTITY_LASER) then
        repeats = 10
      end
      
      for i = 1, repeats do
        local pos = e.Position
        
        if (e.Type == EntityType.ENTITY_LASER) then
          pos = e.Position * (1 - i/10) + e:ToLaser():GetEndPoint() * (i/10)
        end
        
        local rotate = math.random(0,360)
        local t = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.MYSTERIOUS, 0, pos, Vector.One:Rotated(0 + rotate) * 5, e)
        t:SetColor(IOTR.Enums.TintedRainbow[1], 0, 0, false, false)
        t:ToTear().TearFlags = TearFlags.TEAR_STICKY | TearFlags.TEAR_SPECTRAL
        t:ToTear().Scale = 0.6
        t.CollisionDamage = p.Damage / 6
        
        t = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.MYSTERIOUS, 0, pos, Vector.One:Rotated(60 + rotate) * 5, e)
        t:SetColor(IOTR.Enums.TintedRainbow[2], 0, 0, false, false)
        t:ToTear().TearFlags = TearFlags.TEAR_BURN | TearFlags.TEAR_SPECTRAL
        t:ToTear().Scale = 0.6
        t.CollisionDamage = p.Damage / 6
        
        t = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.MYSTERIOUS, 0, pos, Vector.One:Rotated(120 + rotate) * 5, e)
        t:SetColor(IOTR.Enums.TintedRainbow[3], 0, 0, false, false)
        t:ToTear().TearFlags = TearFlags.TEAR_GREED_COIN | TearFlags.TEAR_SPECTRAL
        t:ToTear().Scale = 0.6
        t.CollisionDamage = p.Damage / 6
        
        t = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.MYSTERIOUS, 0, pos, Vector.One:Rotated(180 + rotate) * 5, e)
        t:SetColor(IOTR.Enums.TintedRainbow[4], 0, 0, false, false)
        t:ToTear().TearFlags = TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP | TearFlags.TEAR_SPECTRAL
        t:ToTear().Scale = 0.6
        t.CollisionDamage = p.Damage / 6
        
        t = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.MYSTERIOUS, 0, pos, Vector.One:Rotated(240 + rotate) * 5, e)
        t:SetColor(IOTR.Enums.TintedRainbow[6], 0, 0, false, false)
        t:ToTear().TearFlags = TearFlags.TEAR_FREEZE | TearFlags.TEAR_SPECTRAL
        t:ToTear().Scale = 0.6
        t.CollisionDamage = p.Damage / 6
        
        t = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.MYSTERIOUS, 0, pos, Vector.One:Rotated(300 + rotate) * 5, e)
        t:SetColor(IOTR.Enums.TintedRainbow[7], 0, 0, false, false)
        t:ToTear().TearFlags = TearFlags.TEAR_FEAR | TearFlags.TEAR_SPECTRAL
        t:ToTear().Scale = 0.6
        t.CollisionDamage = p.Damage / 6
      end
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
  
  onNPCDeath = function (entity)
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
      local rnd = math.random(0,4)
      if (rnd == 0) then IOTR.Storage.Stats.damage = IOTR.Storage.Stats.damage + 1 * IOTR.Items.Passive.PI_CurseLit.count
      elseif (rnd == 1 and p.MaxFireDelay > 2) then IOTR.Storage.Stats.tears = IOTR.Storage.Stats.tears - 1 * IOTR.Items.Passive.PI_CurseLit.count
      elseif (rnd == 2) then IOTR.Storage.Stats.tearspeed = IOTR.Storage.Stats.tearspeed + 0.2 * IOTR.Items.Passive.PI_CurseLit.count
      elseif (rnd == 3 and p.MoveSpeed < 2) then IOTR.Storage.Stats.speed = IOTR.Storage.Stats.speed + 0.2 * IOTR.Items.Passive.PI_CurseLit.count
      else p.Luck = p.Luck + 1; IOTR.Storage.Stats.luck = IOTR.Storage.Stats.luck + 1  * IOTR.Items.Passive.PI_CurseLit.count end
      p:AddCacheFlags(CacheFlag.CACHE_ALL)
      p:EvaluateItems()
    end
  end,
  
  onPickup = function ()
    IOTR.Items.Passive.PI_CurseLit.onStageChange()
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
  
  onCacheUpdate = function (player, cacheFlag)
    if (cacheFlag == CacheFlag.CACHE_SPEED or cacheFlag == CacheFlag.CACHE_ALL) then
      player.MoveSpeed = player.MoveSpeed + player:GetCollectibleNum(IOTR.Items.Passive.PI_DrinkPurple.id) * 0.35
    end
  end,
  
  onPickup = function ()
    local p = Isaac.GetPlayer(0)
    local room = Game():GetRoom()
    
    Isaac.Spawn(EntityType.ENTITY_PICKUP, IOTR.Mechanics.TwitchHearts.twitchHeart,  0, room:FindFreePickupSpawnPosition(p.Position, 0, true), Vector.Zero, p)
    if (math.random(1,2) == 1) then
      Isaac.Spawn(EntityType.ENTITY_PICKUP, IOTR.Mechanics.TwitchHearts.twitchHeart,  0, room:FindFreePickupSpawnPosition(p.Position, 0, true), Vector.Zero, p)
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
      if (entities[i]:IsActiveEnemy(false) == true and math.random(3) == 1) then
        local rnd = math.random(0,9)
        local ref = EntityRef(p)
        if (rnd == 0) then entities[i]:AddPoison(ref, math.random(30,300), math.random())
        elseif (rnd == 1) then entities[i]:AddFreeze(ref, math.random(30,300))
        elseif (rnd == 2) then entities[i]:AddSlowing(ref, math.random(30,300), math.random(), Color(1,1,1,1,0,0,0))
        elseif (rnd == 3) then entities[i]:AddCharmed(ref, math.random(30,300))
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
    local laser1 = EntityLaser.ShootAngle(5, p.Position, 0, 0, Vector.Zero, p)
    laser1:SetActiveRotation(1, 999360, p.ShotSpeed*8, true)
    laser1.CollisionDamage = p.Damage/20;
    laser1.CurveStrength = 0
    laser1.Visible = false
    -- This laser only for decoration
    local laser2 = EntityLaser.ShootAngle(7, p.Position, 0, 0, Vector.Zero, p)
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

-- Nightbot
passiveItems.PI_Nightbot = {
  
  id = Isaac.GetItemIdByName("Nightbot"),
  name = "Nightbot",
  
  description = {
    en = "If projectile hit Ngihtbot, all projectiles will be removed",
    ru = "При попадании по нему вражеской слезы убирает все вражеские слезы в комнате"
  },
  
  count = 0,
  
  famId = Isaac.GetEntityVariantByName("Twitch Nightbot"),
  famFollowPlayer = true,
  
  onFamiliarUpdate = function (entity)
    if (entity.Variant ~= IOTR.Items.Passive.PI_Nightbot.famId) then return end
    entity:FollowParent()
    
    local projectiles = Isaac.FindInRadius(entity.Position, 16, EntityPartition.BULLET)
    
    if #projectiles > 0 then
      
      for k, v in pairs(Isaac.GetRoomEntities()) do
        if v.Type == EntityType.ENTITY_PROJECTILE then
          v:Die()
        end
      end
      
      Game():Darken(-0.5, 7);
    end
    
  end,
}

-- Stinky Cheese
passiveItems.PI_StinkyCheese = {
  
  id = Isaac.GetItemIdByName("Stinky Cheese"),
  name = "Stinky Cheese",
  
  description = {
    en = "Can poison enemy when touched",
    ru = "Может отравить врага при прикосновении"
  },
  
  count = 0,
  
  famId = Isaac.GetEntityVariantByName("Twitch Stinky Cheese"),
  famFollowPlayer = true,
  
  onFamiliarUpdate = function (entity)
    if entity.Variant ~= IOTR.Items.Passive.PI_StinkyCheese.famId then return end
    entity:FollowParent()
    
    local sprite = entity:GetSprite()
    if (sprite:IsFinished("Float")) then sprite:Play("Float", false) end
  
    for k, v in pairs(Isaac.GetRoomEntities()) do
      if (v:IsActiveEnemy() and v:IsVulnerableEnemy() and not v:IsBoss() and not v:HasEntityFlags(EntityFlag.FLAG_POISON)) then
        if (not v:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and not v:IsDead() and entity.Position:Distance(v.Position) <= 64) then
          
          IOTR.Sounds.play(SoundEffect.SOUND_FART)
          v:AddPoison(EntityRef(entity), 30, .2)
          
        end
      end
    end
    
  end,
}

-- Bleed purple
passiveItems.PI_BleedPurple = {
  
  id = Isaac.GetItemIdByName("Bleed Purple"),
  name = "Bleed Purple",
  
  description = {
    en = "If you have Twitch hearts, all your familiars will shoot#Give 1 Twitch heart",
    ru = "Все ваши спутники будут стрелять, пока у вас есть Твич-сердца#Дает 1 Твич-сердце"
  },
  
  count = 0,
  
  onPickup = function ()
    IOTR.Storage.Hearts.twitch = IOTR.Storage.Hearts.twitch + 2
  end,
  
  onFamiliarUpdate = function (entity)
    if IOTR.Storage.Hearts.twitch <= 0 or entity.FrameCount % 30 ~= 0 then return end
    local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0, entity.Position, Vector(10, 0):Rotated(entity.FrameCount), entity):ToTear()
    tear:SetColor(IOTR.Enums.Rainbow[7], 0, 0, false, false)
    
  end,
}

-- Old Pog Champ
passiveItems.PI_PogChamp = {
  
  id = Isaac.GetItemIdByName("P?gC???p"),
  name = "P?gC???p",
  
  description = {
    en = "Enemy can lose half of their HP with a 66% chance#Enemy can double their HP with a 33% chance",
    ru = "Враг может потерять половину своего здоровья с шансом 66%#Враг может удвоить свое здоровье с шансом 33%"
  },
  
  count = 0,
  
  onNPCInit = function (npc)
    
    if not npc:IsActiveEnemy(false) or not npc:IsVulnerableEnemy() then return end
    
    if math.random(1,3) == 1 then
      
      npc.MaxHitPoints = npc.MaxHitPoints * 2
      npc.HitPoints = npc.HitPoints * 2
      
    else
      npc.HitPoints = npc.HitPoints / 2
    end
    
  end,
}

-- Glitch Lit
passiveItems.PI_GlitchLit = {
  
  id = Isaac.GetItemIdByName("Glitch Lit"),
  name = "Glitch Lit",
  
  description = {
    en = "Being near a fireplace will increase your stats#You don't take damage from fireplaces",
    ru = "Нахождение рядом с кострами увеличит ваши статы#Вы не получаете урон от костров"
  },
  
  count = 0,
  
  _getFireplaceBonus = false,
  
  onUpdate = function ()
    
    local p = Isaac.GetPlayer(0)
    local enemies = Isaac.FindInRadius(p.Position, 70, EntityPartition.ENEMY)
    local fireFounded = false
    
    
    for _, enemy in pairs(enemies) do
      if enemy.Type == EntityType.ENTITY_FIREPLACE then
        fireFounded = true
        
        if (enemy.Variant == 0) then
          Game():SpawnParticles(enemy.Position + RandomVector()*30, EffectVariant.ULTRA_GREED_BLING, 1, 0, IOTR.Enums.Rainbow[2], 0)
        elseif (enemy.Variant == 1) then
          Game():SpawnParticles(enemy.Position + RandomVector()*30, EffectVariant.ULTRA_GREED_BLING, 1, 0, IOTR.Enums.Rainbow[1], 0)
        elseif (enemy.Variant == 2) then
          Game():SpawnParticles(enemy.Position + RandomVector()*30, EffectVariant.ULTRA_GREED_BLING, 1, 0, IOTR.Enums.Rainbow[5], 0)
        elseif (enemy.Variant == 3) then
          Game():SpawnParticles(enemy.Position + RandomVector()*30, EffectVariant.ULTRA_GREED_BLING, 1, 0, IOTR.Enums.Rainbow[7], 0)
        end
        
      end
    end
    
    if not IOTR.Items.Passive.PI_GlitchLit._getFireplaceBonus and fireFounded then
      IOTR.Items.Passive.PI_GlitchLit._getFireplaceBonus = true
      IOTR.Storage.Stats.speed = IOTR.Storage.Stats.speed + .2
      IOTR.Storage.Stats.damage = IOTR.Storage.Stats.damage + 2
      IOTR.Storage.Stats.tears = IOTR.Storage.Stats.tears + 1
      p:AddCacheFlags(CacheFlag.CACHE_ALL)
      p:EvaluateItems()
    elseif IOTR.Items.Passive.PI_GlitchLit._getFireplaceBonus and not fireFounded then
      IOTR.Items.Passive.PI_GlitchLit._getFireplaceBonus = false
      IOTR.Storage.Stats.speed = IOTR.Storage.Stats.speed - .2
      IOTR.Storage.Stats.damage = IOTR.Storage.Stats.damage - 2
      IOTR.Storage.Stats.tears = IOTR.Storage.Stats.tears - 1
      p:AddCacheFlags(CacheFlag.CACHE_ALL)
      p:EvaluateItems()
    end
    
  end,
  
  onDamage = function (entity, damageAmnt, damageFlag, damageSource, damageCountdown)
    return not (damageSource ~= nil and damageSource.Type ~= nil and damageSource.Type == EntityType.ENTITY_FIREPLACE)
  end
}

return passiveItems