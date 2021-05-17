local activeItems = {}


-- Example
--activeItems.ItemName= {
--  id = Isaac.GetItemIdByName("Item Name"), <-- Item Id
--  name = "Item Name"  <-- Item name, required for dynamic item loading on site
--  devOnly = false <-- If TRUE, not appear in polls
--  description = "Item description", <-- Item description for external item description mod
--  current = false, <-- This item is current spacebar item
--  onActivate = nil, <-- Function, called on activate item
--  onUpdate = nil <-- Function, called every update when player hold item
--}



-- Twitch Raid
activeItems.TwitchRaid = {
  
  id = Isaac.GetItemIdByName("Twitch Raid"),
  name = "Twitch Raid",
  
  description = {
    en = "Summon friendly buddies",
    ru = "Спавнит дружелюбных мобов"
  },
  
  onActivate = function ()
    
    local followers = {}
    local game = Game()
    local room = game:GetRoom()
    for i = 0, math.random(3,6) do
      followers[i] = Isaac.Spawn(IOTR.Enums.Buddies[math.random(#IOTR.Enums.Buddies)], 0,  0, room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20, true), Vector.Zero, Isaac.GetPlayer(0))
      followers[i]:AddCharmed(EntityRef(Isaac.GetPlayer()), -1)
      followers[i]:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
      
      local color = IOTR.Enums.ChatColors[math.random(#IOTR.Enums.ChatColors)]
      followers[i]:SetColor(color, 0, 0, false, false)
      
      if #IOTR.GameState.randomNames > 0 then
        local textId = 'buddy'..math.random(0,9999)
        IOTR.Text.add(textId, table.remove(IOTR.GameState.randomNames, math.random(#IOTR.GameState.randomNames)), nil, {r=color.R, g=color.G,b=color.B,a=1})
        IOTR.Text.follow(textId, followers[i])
      end
    end
    
  end,
  
  onUpdate = nil
  
}


-- TTours
activeItems.TTours = {
  
  id = Isaac.GetItemIdByName("TTours"),
  name = "TTours",
  
  description = {
    en = "Confuse all enemies in the room",
    ru = "Запутывает врагов в комнате"
  },
  
  onActivate = function ()
    
    local	player = Isaac.GetPlayer(0)
    local	entities = Isaac.GetRoomEntities()
    local game = Game()
    
    for i = 1, #entities do
      if entities[i]:IsActiveEnemy() then
        entities[i]:AddConfusion(EntityRef(player), 580, false)
        local ref = EntityRef(entities[i])
        game:SpawnParticles(ref.Position, EffectVariant.IMPACT, 2, math.random(), Color(1, 1, 1, 1, 0.196078, 0.196078, 0.196078), math.random())
      end
    end
    
  end,
  
  onUpdate = nil
  
}


-- Rip Pepperonis
activeItems.RipPepperonis = {
  
  id = Isaac.GetItemIdByName("Rip Pepperonis"),
  name = "Rip Pepperonis",
  
  description = {
    en = "Spawn multiple brimstone swirls",
    ru = "Спавнит несколько бримстоун-воронок"
  },
  
  onActivate = function ()
    
    local r = Game():GetRoom()
    local p = Isaac.GetPlayer(0)
    
    for i = r:GetTopLeftPos().Y + 10, r:GetBottomRightPos().Y - 10 do
      if (i % 30 == 0) then
        Game():SpawnParticles(Vector(r:GetTopLeftPos().X, i), EffectVariant.BRIMSTONE_SWIRL, 1, 0, Color(1, 1, 1, 1, 0, 0, 0), 0)
        EntityLaser.ShootAngle(1, Vector(r:GetTopLeftPos().X, i), 0, 5, Vector.Zero, p)
      end
    end
    
  end,
  
  onUpdate = nil
  
}

-- Nom nom
activeItems.NomNom = {
  
  id = Isaac.GetItemIdByName("Nom Nom"),
  name = "Nom Nom",
  
  description = {
    en = "Give you half red and 1 soul heart#Disappears after 6 uses",
    ru = "Дает половину красного и 1 синее сердца#Исчезает после 6 использований"
  },
  
  onActivate = function ()
    
    local p = Isaac.GetPlayer(0)
    if (p:HasFullHearts()) then
      Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART,  HeartSubType.HEART_HALF, p.Position, Vector.Zero, p)
    else
      p:AddHearts(1)
    end
    p:AddSoulHearts(2)
    
    IOTR.Sounds.play(IOTR.Sounds.list.nomNomEating)
    
    Isaac.GetPlayer(0):RemoveCollectible(Isaac.GetItemIdByName("Nom Nom"));
    p:AddCollectible(Isaac.GetItemIdByName("Bitten nom nom 1"), 0, true);
    
  end
  
}

-- Nom nom part 1
activeItems.NomNomPart1 = {
  
  id = Isaac.GetItemIdByName("Bitten nom nom 1"),
  name = "Bitten nom nom 1",
  devOnly = true,
  
  description = {
    en = "Give you half red and 1 soul heart#Disappears after 5 uses",
    ru = "Дает половину красного и 1 синее сердца#Исчезает после 5 использований"
  },
  
  onActivate = function ()
    
    local p = Isaac.GetPlayer(0)
    if (p:HasFullHearts()) then
      Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART,  HeartSubType.HEART_HALF, p.Position, Vector.Zero, p)
    else
      p:AddHearts(1)
    end
    p:AddSoulHearts(2)
    
    IOTR.Sounds.play(IOTR.Sounds.list.nomNomEating)
    p:RemoveCollectible(Isaac.GetItemIdByName("Bitten nom nom 1"));
    p:AddCollectible(Isaac.GetItemIdByName("Bitten nom nom 2"), 0, true);
    
  end
  
}

-- Nom nom part 2
activeItems.NomNomPart2 = {
  
  id = Isaac.GetItemIdByName("Bitten nom nom 2"),
  name = "Bitten nom nom 2",
  devOnly = true,
  
  description = {
    en = "Give you half red and 1 soul heart#Disappears after 4 uses",
    ru = "Дает половину красного и 1 синее сердца#Исчезает после 4 использований"
  },
  
  onActivate = function ()
    
    local p = Isaac.GetPlayer(0)
    if (p:HasFullHearts()) then
      Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART,  HeartSubType.HEART_HALF, p.Position, Vector.Zero, p)
    else
      p:AddHearts(1)
    end
    p:AddSoulHearts(2)
    
    IOTR.Sounds.play(IOTR.Sounds.list.nomNomEating)
    p:RemoveCollectible(Isaac.GetItemIdByName("Bitten nom nom 2"));
    p:AddCollectible(Isaac.GetItemIdByName("Bitten nom nom 3"), 0, true);
    
  end
  
}

-- Nom nom part 3
activeItems.NomNomPart3 = {
  
  id = Isaac.GetItemIdByName("Bitten nom nom 3"),
  name = "Bitten nom nom 3",
  devOnly = true,
  
  description = {
    en = "Give you half red and 1 soul heart#Disappears after 3 uses",
    ru = "Дает половину красного и 1 синее сердца#Исчезает после 3 использований"
  },
  
  onActivate = function ()
    
    local p = Isaac.GetPlayer(0)
    if (p:HasFullHearts()) then
      Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART,  HeartSubType.HEART_HALF, p.Position, Vector.Zero, p)
    else
      p:AddHearts(1)
    end
    p:AddSoulHearts(2)
    
    IOTR.Sounds.play(IOTR.Sounds.list.nomNomEating)
    p:RemoveCollectible(Isaac.GetItemIdByName("Bitten nom nom 3"));
    p:AddCollectible(Isaac.GetItemIdByName("Bitten nom nom 4"), 0, true);
    
  end
  
}

-- Nom nom part 4
activeItems.NomNomPart4 = {
  
  id = Isaac.GetItemIdByName("Bitten nom nom 4"),
  name = "Bitten nom nom 4",
  devOnly = true,
  
  description = {
    en = "Give you half red and 1 soul heart#Disappears after 2 uses",
    ru = "Дает половину красного и 1 синее сердца#Исчезает после 2 использований"
  },
  
  onActivate = function ()
    
    local p = Isaac.GetPlayer(0)
    if (p:HasFullHearts()) then
      Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART,  HeartSubType.HEART_HALF, p.Position, Vector.Zero, p)
    else
      p:AddHearts(1)
    end
    p:AddSoulHearts(2)
    
    IOTR.Sounds.play(IOTR.Sounds.list.nomNomEating)
    p:RemoveCollectible(Isaac.GetItemIdByName("Bitten nom nom 4"));
    p:AddCollectible(Isaac.GetItemIdByName("Bitten nom nom 5"), 0, true);
    
  end
  
}

-- Nom nom part 5
activeItems.NomNomPart5 = {
  
  id = Isaac.GetItemIdByName("Bitten nom nom 5"),
  name = "Bitten nom nom 5",
  devOnly = true,
  
  description = {
    en = "Give you half red and 1 soul heart#Disappears after 1 use",
    ru = "Дает половину красного и 1 синее сердца#Исчезает после 1 использования"
  },
  
  onActivate = function ()
    
    local p = Isaac.GetPlayer(0)
    if (p:HasFullHearts()) then
      Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART,  HeartSubType.HEART_HALF, p.Position, Vector.Zero, p)
    else
      p:AddHearts(1)
    end
    p:AddSoulHearts(2)
    
    IOTR.Sounds.play(IOTR.Sounds.list.nomNomEating)
    p:RemoveCollectible(Isaac.GetItemIdByName("Bitten nom nom 5"))
    
  end
  
}

-- Panic basket
activeItems.PanicBasket = {
  
  id = Isaac.GetItemIdByName("Panic Basket"),
  name = "Panic Basket",
  
  description = {
    en = "Throws fire",
    ru = "Раскидывает огонь"
  },
  
  onActivate = function ()
    
    local p = Isaac.GetPlayer(0)
    
    for i=1, math.random(5,14) do
      local flame = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.RED_CANDLE_FLAME, 0, p.Position, Vector(math.random(-10, 10), math.random(-10, 10)), p)
      flame.CollisionDamage = 5
    end
    
  end
  
}

-- Vote Yea
activeItems.VoteYea = {
  
  id = Isaac.GetItemIdByName("Vote Yea"),
  name = "Vote Yea",
  
  description = {
    en = "Immediately accepts current poll",
    ru = "Немедленно принимает текущее голосование"
  },
  
  onActivate = function ()
    
    IOTR.Server.addOutput({c = "acceptPoll"})
    
  end
  
}

-- Vote Nay
activeItems.VoteNay = {
  
  id = Isaac.GetItemIdByName("Vote Nay"),
  name = "Vote Nay",
  
  description = {
    en = "Skips current poll#One-time use",
    ru = "Пропускает текущее голосование#Исчезает после использования"
  },
  
  onActivate = function ()
    
    IOTR.Server.addOutput({c = "skipPoll"})
    Isaac.GetPlayer(0):RemoveCollectible(IOTR.Items.Active.VoteNay.id)
    
  end
  
}

-- Debug item
--[[activeItems.Debug = {
  
  id = Isaac.GetItemIdByName("DEBUG ITEM"),
  name = "DEBUG",
  
  description = {
    en = "Only for mod debugging",
    ru = "Только для разработки мода"
  },
  
  onActivate = function ()
    
    local p = Isaac.GetPlayer(0)
    Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.GB_BUG, 0, p.Position, Vector.Zero, p)
    
  end
  
}--]]

return activeItems