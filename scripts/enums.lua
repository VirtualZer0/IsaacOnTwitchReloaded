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
  EntityType.ENTITY_LIL_HAUNT,
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
  Color(1,0,0,1,0,0,0),
  Color(1,0.5,0,1,0,0,0),
  Color(1,1,0,1,0,0,0),
  Color(0.5,1,0,1,0,0,0),
  Color(0,1,1,1,0,0,0),
  Color(0,0,1,1,0,0,0),
  Color(0.5,0,1,1,0,0,0)
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

return enums