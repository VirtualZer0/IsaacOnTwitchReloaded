-- Sprites storage
local sprites = {
  
  UI = {
    
    -- Events and bits indicators
    EventActive = Sprite(),
    GrayBitsActive = Sprite(),
    PurpleBitsActive = Sprite(),
    GreenBitsActive = Sprite(),
    BlueBitsActive = Sprite(),
    RedBitsActive = Sprite(),
    
    -- Hearts
    TwitchHeart = Sprite(),
    TwitchHeartHalf = Sprite(),
    RainbowHeart = Sprite(),
    RainbowHeartHalf = Sprite(),
    
    -- Progress Bar
    ProgressBarBg = Sprite(),
    ProgressBarLine = Sprite()
  }
  
}

-- Loading sprites
function sprites.load ()
  
  
  -- Loading sprites from anm2 files
  sprites.UI.EventActive:Load("gfx/ui/mod.twitch_uieffects.anm2", true)
  sprites.UI.GrayBitsActive:Load("gfx/ui/mod.twitch_uieffects.anm2", true)
  sprites.UI.PurpleBitsActive:Load("gfx/ui/mod.twitch_uieffects.anm2", true)
  sprites.UI.GreenBitsActive:Load("gfx/ui/mod.twitch_uieffects.anm2", true)
  sprites.UI.BlueBitsActive:Load("gfx/ui/mod.twitch_uieffects.anm2", true)
  sprites.UI.RedBitsActive:Load("gfx/ui/mod.twitch_uieffects.anm2", true)
  
  sprites.UI.TwitchHeart:Load("gfx/ui/ui_twitch_mod_hearts.anm2", true)
  sprites.UI.TwitchHeartHalf:Load("gfx/ui/ui_twitch_mod_hearts.anm2", true)
  sprites.UI.RainbowHeart:Load("gfx/ui/ui_twitch_mod_hearts.anm2", true)
  sprites.UI.RainbowHeartHalf:Load("gfx/ui/ui_twitch_mod_hearts.anm2", true)
  
  sprites.UI.ProgressBarBg:Load("gfx/ui/ui_twitch_mod_pollbar.anm2", true)
  sprites.UI.ProgressBarLine:Load("gfx/ui/ui_twitch_mod_pollbar.anm2", true)
  
  -- Activate sprites
  sprites.UI.EventActive:Play("Event", true)
  sprites.UI.GrayBitsActive:Play("Gray", true)
  sprites.UI.PurpleBitsActive:Play("Purple", true)
  sprites.UI.GreenBitsActive:Play("Green", true)
  sprites.UI.BlueBitsActive:Play("Blue", true)
  sprites.UI.RedBitsActive:Play("Red", true)
  
  sprites.UI.TwitchHeart:Play("TwitchHeartFull", false)
  sprites.UI.TwitchHeartHalf:Play("TwitchHeartHalf", false)
  sprites.UI.RainbowHeart:Play("RainbowHeartFull", false)
  sprites.UI.RainbowHeartHalf:Play("RainbowHeartHalf", false)
  
  sprites.UI.ProgressBarBg:PlayOverlay("BarBg", false)
  sprites.UI.ProgressBarLine:PlayOverlay("BarLine", false)
end

return sprites;