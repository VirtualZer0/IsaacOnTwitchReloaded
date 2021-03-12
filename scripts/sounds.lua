local sounds = {
  list = {},
  
  play = function (sound)
  
    SFXManager():Play(sound, 1, 0, false, 1);
    
  end
}

sounds.list.bitsAppear = Isaac.GetSoundIdByName ("BitsAppear")
sounds.list.bitsCollect = Isaac.GetSoundIdByName ("BitsCollect")
sounds.list.superhotBreak = Isaac.GetSoundIdByName ("SuperhotBreak")
sounds.list.superhotVoice = Isaac.GetSoundIdByName ("SuperhotVoice")
sounds.list.rewind = Isaac.GetSoundIdByName ("Rewind")
sounds.list.goodMusic = Isaac.GetSoundIdByName ("GoodMusic")
sounds.list.ddosDialup = Isaac.GetSoundIdByName ("DdosDialup")
sounds.list.attackOnTitan = Isaac.GetSoundIdByName ("AttackOnTitan")
sounds.list.interstellar = Isaac.GetSoundIdByName ("Interstellar")
sounds.list.rerunCharging = Isaac.GetSoundIdByName ("RerunCharging")
sounds.list.allergia = Isaac.GetSoundIdByName ("Sneeze")
sounds.list.heavyrain = Isaac.GetSoundIdByName ("Rain")
sounds.list.qte_yes = Isaac.GetSoundIdByName ("QTEYes")
sounds.list.qte_no = Isaac.GetSoundIdByName ("QTENo")
sounds.list.machineGunShot = Isaac.GetSoundIdByName ("MachgineGunShot")

return sounds