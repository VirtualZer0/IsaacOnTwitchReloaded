local enums = {}

-- For "Twitch Raid" spacebar item
enums.Buddies = {
  EntityType.ENTITY_GAPER,
  EntityType.ENTITY_HUSH_GAPER,
  EntityType.ENTITY_GREED_GAPER,
  EntityType.ENTITY_GURGLE,
  EntityType.ENTITY_GLOBIN
}

-- For Angel Rage event
enums.AngelRage = {
  EntityType.ENTITY_WIZOOB,
  EntityType.ENTITY_THE_HAUNT,
  EntityType.ENTITY_BRAIN,
  EntityType.ENTITY_BONY,
  EntityType.ENTITY_BABY
}

-- For Devil Rage event
enums.DevilRage = {
  EntityType.ENTITY_BABY_LONG_LEGS,
  EntityType.ENTITY_ONE_TOOTH,
  EntityType.ENTITY_TARBOY,
  EntityType.ENTITY_NULLS,
  EntityType.ENTITY_BOOMFLY
}


enums.Rainbow = {
  Color(.858,.219,.219,1,0,0,0),
  Color(.964,.384,.121,1,0,0,0),
  Color(.996,.8,.184,1,0,0,0),
  Color(0.596,.858,.301,1,0,0,0),
  Color(.196,.709,.913,1,0,0,0),
  Color(.254,.321,.828,1,0,0,0),
  Color(.549,.27,.968,1,0,0,0)
}

enums.TintedRainbow = {
  Color(.858,.219,.219,1,219,56,56),
  Color(.964,.384,.121,1,246,98,31),
  Color(.996,.8,.184,1,254,204,47),
  Color(0.596,.858,.301,1,152,219,77),
  Color(.196,.709,.913,1,50,181,223),
  Color(.254,.321,.828,1,65,82,212),
  Color(.549,.27,.968,1,140,69,247)
}


enums.ChatColors = {
  Color(1,0,0,1,0,0,0),
  Color(0,0,1,1,0,0,0),
  Color(0.698, 0.133, 0.133,1,0,0,0),
  Color(1, 0.498, 0.314,1,0,0,0),
  Color(0.604, 0.804, 0.196,1,0,0,0),
  Color(1, 0.271, 0,1,0,0,0),
  Color(0.18, 0.545, 0.341,1,0,0,0),
  Color(0.855, 0.647, 0.125,1,0,0,0),
  Color(0.824, 0.412, 0.118,1,0,0,0),
  Color(0.373, 0.62, 0.627,1,0,0,0),
  Color(0.118, 0.565, 1,1,0,0,0),
  Color(1, 0.412, 0.706,1,0,0,0),
  Color(0.541, 0.169, 0.886,1,0,0,0),
  Color(0,0.502,0,1,0,0,0),
  Color(0, 1, 0.498,1,0,0,0)
}

enums.Doors = {
  RoomType.ROOM_DEFAULT,
  RoomType.ROOM_SHOP,
  RoomType.ROOM_TREASURE,
  RoomType.ROOM_BOSS,
  RoomType.ROOM_SECRET,
  RoomType.ROOM_ARCADE,
  RoomType.ROOM_CURSE,
  RoomType.ROOM_SACRIFICE,
  RoomType.ROOM_DEVIL,
  RoomType.ROOM_ANGEL
}

enums.Bosses = {
  EntityType.ENTITY_LARRYJR,
  EntityType.ENTITY_MONSTRO,
  EntityType.ENTITY_SLOTH,
  EntityType.ENTITY_LUST,
  EntityType.ENTITY_GLUTTONY,
  EntityType.ENTITY_ENVY,
  EntityType.ENTITY_PRIDE,
  EntityType.ENTITY_PIN,
  EntityType.ENTITY_FAMINE,
  EntityType.ENTITY_PESTILENCE,
  EntityType.ENTITY_WAR,
  EntityType.ENTITY_DEATH,
  EntityType.ENTITY_DUKE,
  EntityType.ENTITY_PEEP,
  EntityType.ENTITY_LOKI,
  EntityType.ENTITY_BLASTOCYST_BIG,
  EntityType.ENTITY_GEMINI,
  EntityType.ENTITY_HEADLESS_HORSEMAN,
  EntityType.ENTITY_THE_HAUNT,
  EntityType.ENTITY_DINGLE,
  EntityType.ENTITY_MEGA_MAW,
  EntityType.ENTITY_GATE,
  EntityType.ENTITY_MEGA_FATTY,
  EntityType.ENTITY_CAGE,
  EntityType.ENTITY_DARK_ONE,
  EntityType.ENTITY_ADVERSARY,
  EntityType.ENTITY_STAIN,
  EntityType.ENTITY_BROWNIE,
  EntityType.ENTITY_FORSAKEN
}

enums.TwitchRoomPickups = {
  Isaac.GetEntityVariantByName ("Bits A"),
  Isaac.GetEntityVariantByName ("Bits B"),
  Isaac.GetEntityVariantByName ("Bits C"),
  Isaac.GetEntityVariantByName ("Bits D"),
  Isaac.GetEntityVariantByName ("Bits E"),
  Isaac.GetEntityVariantByName ("Twitch Heart")
}

return enums