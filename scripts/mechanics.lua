local mechanics = {}

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
        t.TearFlags = IOTR._.setbit(t.TearFlags, TearFlags.BLACK_HP_DROP)
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

return mechanics