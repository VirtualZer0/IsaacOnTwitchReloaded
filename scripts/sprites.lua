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
    ProgressBarHearts = Sprite(),
    ProgressBarPockets = Sprite(),
    ProgressBarKeys = Sprite(),
    ProgressBarBombs = Sprite(),
    ProgressBarCoins = Sprite(),
    ProgressBarLine = Sprite(),
    
    -- Poll frames
    PollFrame1 = Sprite(),
    PollFrame2 = Sprite(),
    PollFrame3 = Sprite()
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
  
  sprites.UI.ProgressBarHearts:Load("gfx/ui/pollbars/ui_twitch_mod_pollbar_hearts.anm2", true)
  sprites.UI.ProgressBarPockets:Load("gfx/ui/pollbars/ui_twitch_mod_pollbar_pockets.anm2", true)
  sprites.UI.ProgressBarKeys:Load("gfx/ui/pollbars/ui_twitch_mod_pollbar_keys.anm2", true)
  sprites.UI.ProgressBarBombs:Load("gfx/ui/pollbars/ui_twitch_mod_pollbar_bombs.anm2", true)
  sprites.UI.ProgressBarCoins:Load("gfx/ui/pollbars/ui_twitch_mod_pollbar_coins.anm2", true)
  sprites.UI.ProgressBarLine:Load("gfx/ui/pollbars/ui_twitch_mod_pollbar_line.anm2", true)
  
  sprites.UI.PollFrame1:Load("gfx/ui/ui_twitch_mod_pollframe.anm2", true)
  sprites.UI.PollFrame2:Load("gfx/ui/ui_twitch_mod_pollframe.anm2", true)
  sprites.UI.PollFrame3:Load("gfx/ui/ui_twitch_mod_pollframe.anm2", true)
  
  -- Activate sprites
  sprites.UI.EventActive:Play("Event", true)
  sprites.UI.GrayBitsActive:Play("Gray", true)
  sprites.UI.PurpleBitsActive:Play("Purple", true)
  sprites.UI.GreenBitsActive:Play("Green", true)
  sprites.UI.BlueBitsActive:Play("Blue", true)
  sprites.UI.RedBitsActive:Play("Red", true)
  
  sprites.UI.TwitchHeart:Play("TwitchHeartFull", false)
  sprites.UI.TwitchHeartHalf:Play("TwitchHeartHalf", false)
  sprites.UI.RainbowHeart:Play("RainbowHeartFull", true)
  sprites.UI.RainbowHeartHalf:Play("RainbowHeartHalf", true)
  
  sprites.UI.ProgressBarHearts:PlayOverlay("Anim0", false)
  sprites.UI.ProgressBarPockets:PlayOverlay("Anim0", false)
  sprites.UI.ProgressBarKeys:PlayOverlay("Anim0", false)
  sprites.UI.ProgressBarBombs:PlayOverlay("Anim0", false)
  sprites.UI.ProgressBarCoins:PlayOverlay("Anim0", false)
  sprites.UI.ProgressBarLine:PlayOverlay("BarLine", false)
  
  sprites.UI.PollFrame1:PlayOverlay("Item", false)
  sprites.UI.PollFrame2:PlayOverlay("Item", false)
  sprites.UI.PollFrame3:PlayOverlay("Item", false)
end

return sprites;