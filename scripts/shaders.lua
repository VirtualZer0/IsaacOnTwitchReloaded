-- Shaders params storage

local shaders = {
  
  ITMR_Blink = {
    enabled = false,
    
    params = {
      Time = 0
    },
    
    pass = function ()
      if (ITMR.Shaders.ITMR_Blink.enabled) then
        return ITMR.Shaders.ITMR_Blink.params
      else
        return {Time = 0}
      end
    end
  },
  
  ITMR_ScreenMirror = {
    enabled = false,
    
    params = {
      Pos = 0
    },
    
    pass = function ()
      if (ITMR.Shaders.ITMR_ScreenMirror.enabled) then
        return ITMR.Shaders.ITMR_ScreenMirror.params
      else
        return {Pos = 0}
      end
    end
  },
  
  ITMR_VHS = {
    enabled = false,
    
    params = {
      Time = 0
    },
    
    pass = function ()
      if (ITMR.Shaders.ITMR_VHS.enabled) then
        return ITMR.Shaders.ITMR_VHS.params
      else
        return {Time = 0}
      end
    end
  },

  ITMR_ColorSides = {
  enabled = false,
  
  params = {
    Intensity = 0,
    VColor = {0,0,0}
  },
  
  pass = function ()
    if (ITMR.Shaders.ITMR_ColorSides.enabled) then
      return ITMR.Shaders.ITMR_ColorSides.params
    else
      return {
        Intensity = 0,
        VColor = {0,0,0}
      }
    end
  end
  },

  ITMR_Glitch = {
  enabled = false,
  
  params = {
    Time = 90000,
  },
  
  pass = function ()
    if (ITMR.Shaders.ITMR_Glitch.enabled) then
      if (ITMR.Shaders.ITMR_Glitch.params.Time < 100000) then
        ITMR.Shaders.ITMR_Glitch.params.Time = ITMR.Shaders.ITMR_Glitch.params.Time + 1
      else
        ITMR.Shaders.ITMR_Glitch.params.Time = 90000
      end
      return ITMR.Shaders.ITMR_Glitch.params
    else
      return {
        Time = -1
      }
    end
  end
  },

  ITMR_DeepDark = {
  enabled = false,
  
  params = {
    Intensity = 0.5,
    PlayerPos = {100,100}
  },
  
  pass = function ()
    if (ITMR.Shaders.ITMR_DeepDark.enabled) then
      local pos = Isaac.WorldToScreen(Isaac.GetPlayer(0).Position)
      ITMR.Shaders.ITMR_DeepDark.params.PlayerPos = {pos.X, pos.Y}
      return ITMR.Shaders.ITMR_DeepDark.params
    else
      return {
        Intensity = 0,
        PlayerPos = {0,0}
      }
    end
  end
  },

  ITMR_BrokenLens = {
  enabled = false,
  
  params = {
    Intensity = 0.5,
    CameraPos = {100,100}
  },
  
  selected = nil,
  
  pass = function ()
    if (ITMR.Shaders.ITMR_BrokenLens.enabled) then
      
      if (ITMR.Shaders.ITMR_BrokenLens.params.Intensity > 5) then
        ITMR.Shaders.ITMR_BrokenLens.params.Intensity = 0
      else
        if (math.abs(ITMR.Shaders.ITMR_BrokenLens.params.Intensity-2.5) >= 0 and math.abs(ITMR.Shaders.ITMR_BrokenLens.params.Intensity-2.5) <= 0.1) then
          local entities = Isaac.GetRoomEntities()
          
          for key, value in pairs(entities) do
            if (value:IsActiveEnemy(false) or value.Type == EntityType.ENTITY_PLAYER) then
              ITMR.Shaders.ITMR_BrokenLens.selected = value
            end
          end
        end
        
        ITMR.Shaders.ITMR_BrokenLens.params.Intensity = ITMR.Shaders.ITMR_BrokenLens.params.Intensity + 0.05
        
        if (ITMR.Shaders.ITMR_BrokenLens.selected == nil) then ITMR.Shaders.ITMR_BrokenLens.selected = Isaac.GetPlayer(0) end
        
        local pos = Isaac.WorldToScreen(ITMR.Shaders.ITMR_BrokenLens.selected.Position)
        ITMR.Shaders.ITMR_BrokenLens.params.CameraPos = {pos.X, pos.Y}
      end
      
      return ITMR.Shaders.ITMR_BrokenLens.params
    else
      return {
        Intensity = -1,
        PlayerPos = {0,0}
      }
    end
  end
  },

}

return shaders