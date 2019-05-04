local activeItems = {}


--local AI_voteYea = Isaac.GetItemIdByName("Vote Yea")
--local AI_voteNay = Isaac.GetItemIdByName("Vote Nay")
--local AI_DEBUG = Isaac.GetItemIdByName("DEBUG ITEM")


-- Example
--activeItems.ItemName= {
--  id = Isaac.GetItemIdByName("Item Name"), <-- Item Id
--  description = "Item description", <-- Item description for external item description mod
--  current = false, <-- This item is current spacebar item
--  onActivate = nil, <-- Function, called on activate item
--  onUpdate = nil <-- Function, called every update when player hold item
--}



-- Twitch Raid
activeItems.TwitchRaid = {
  
  id = Isaac.GetItemIdByName("Twitch Raid"),
  
  description = {
    en = "Summon friendly buddies",
    ru = "Спавнит дружелюбных мобов"
  },
  
  onActivate = function ()
    
    local followers = {}
    local game = Game()
    local room = game:GetRoom()
    for i = 0, math.random(3,6) do
      followers[i] = Isaac.Spawn(ITMR.Enums.Buddies[math.random(#ITMR.Enums.Buddies)], 0,  0, room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20, true), Vector(0, 0), Isaac.GetPlayer(0))
      followers[i]:AddCharmed(-1)
      followers[i]:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
    end
    
  end,
  
  onUpdate = nil
  
}


-- TTours
activeItems.TTours = {
  
  id = Isaac.GetItemIdByName("TTours"),
  
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
        game:SpawnParticles(ref.Position, EffectVariant.IMPACT, 2, math.random(), Color(1, 1, 1, 1, 50, 50, 50), math.random())
      end
    end
    
  end,
  
  onUpdate = nil
  
}


-- Humble Life
activeItems.HumbleLife = {
  
  id = Isaac.GetItemIdByName("Humble Life"),
  
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
      end
    end
    
  end,
  
  onUpdate = nil
  
}



return activeItems