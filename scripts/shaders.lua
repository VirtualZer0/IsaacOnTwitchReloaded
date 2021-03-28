-- Shaders params storage

local shaders = {
  
  IOTR_Blink = {
    enabled = false,
    
    params = {
      Time = 0
    },
    
    pass = function ()
      if (IOTR.Shaders.IOTR_Blink.enabled) then
        return IOTR.Shaders.IOTR_Blink.params
      else
        return {Time = 0}
      end
    end
  },
  
  
  
  IOTR_ScreenMirror = {
    enabled = false,
    
    params = {
      Pos = 0
    },
    
    pass = function ()
      if (IOTR.Shaders.IOTR_ScreenMirror.enabled) then
        return IOTR.Shaders.IOTR_ScreenMirror.params
      else
        return {Pos = 0}
      end
    end
  },
  
  
  
  IOTR_VHS = {
    enabled = false,
    
    params = {
      Time = 0
    },
    
    pass = function ()
      if (IOTR.Shaders.IOTR_VHS.enabled) then
        return IOTR.Shaders.IOTR_VHS.params
      else
        return {Time = 0}
      end
    end
  },



  IOTR_ColorSides = {
    enabled = false,
    
    params = {
      Intensity = 0,
      VColor = {1,0,0}
    },
    
    pass = function ()
      if (IOTR.Shaders.IOTR_ColorSides.enabled) then
        return IOTR.Shaders.IOTR_ColorSides.params
      else
        return {
          Intensity = 0,
          VColor = {0,0,0}
        }
      end
    end
  },



  IOTR_Glitch = {
    enabled = false,
    
    params = {
      Time = 1000,
    },
    
    pass = function ()
      if (IOTR.Shaders.IOTR_Glitch.enabled) then
        
        if (IOTR.Shaders.IOTR_Glitch.params.Time < 10000) then
          IOTR.Shaders.IOTR_Glitch.params.Time = IOTR.Shaders.IOTR_Glitch.params.Time + 1
        else
          IOTR.Shaders.IOTR_Glitch.params.Time = 1000
        end
        
        return IOTR.Shaders.IOTR_Glitch.params
      else
        return {
          Time = -1
        }
      end
    end
  },



  IOTR_DeepDark = {
    enabled = false,
    
    params = {
      Intensity = 0.5,
      PlayerPos = {100,100}
    },
    
    pass = function ()
      if (IOTR.Shaders.IOTR_DeepDark.enabled) then
        return IOTR.Shaders.IOTR_DeepDark.params
      else
        return {
          Intensity = 0,
          PlayerPos = {0,0}
        }
      end
    end
  },



  IOTR_BrokenLens = {
    enabled = false,
    
    params = {
      Intensity = 0.5,
      CameraPos = {100,100}
    },
    
    selected = nil,
    
    pass = function ()
      if (IOTR.Shaders.IOTR_BrokenLens.enabled and not Game():IsPaused()) then      
        return IOTR.Shaders.IOTR_BrokenLens.params
      else
        return {
          Intensity = -1,
          PlayerPos = {0,0}
        }
      end
    end
  },



  IOTR_Swirl = {
    enabled = false,
    
    params = {
      Angle = 1,
      Radius = 0.15,
      SwirlPos = {0.5,0.5}
    },
    
    selected = nil,
    
    pass = function ()
      if (IOTR.Shaders.IOTR_Swirl.enabled and not Game():IsPaused()) then
        
        local center = Isaac.WorldToScreen(Game():GetRoom():GetCenterPos())
        IOTR.Shaders.IOTR_Swirl.params.SwirlPos = {center.X, center.Y}
        
        
        return IOTR.Shaders.IOTR_Swirl.params
      else
        return {
          Angle = 0,
          Radius = 0,
          SwirlPos = {0,0}
        }
      end
    end
  },

  IOTR_Bloody = {
    enabled = false,
    
    params = {
      Intensity = 0.6
    },
    
    selected = nil,
    
    pass = function ()
      if (IOTR.Shaders.IOTR_Bloody.enabled) then
        return IOTR.Shaders.IOTR_Bloody.params
      else
        return {
          Intensity = 0
        }
      end
    end
  },
  
  IOTR_Rainbow = {
    enabled = false,
    
    params = {
      Time = 0
    },
    
    pass = function ()
      if (IOTR.Shaders.IOTR_Rainbow.enabled) then
        return {
          Time = Isaac.GetFrameCount()
        }
      else
        return {
          Time = 0
        }
      end
    end
  },

  IOTR_OneColor = {
    enabled = false,
    
    params = {
      EnabledColor = 0,
      Intensity = 0
    },
    
    pass = function ()
      if (IOTR.Shaders.IOTR_OneColor.enabled) then
        return IOTR.Shaders.IOTR_OneColor.params
      else
        return {
          EnabledColor = 0,
          Intensity = 0
        }
      end
    end
  }

}

return shaders