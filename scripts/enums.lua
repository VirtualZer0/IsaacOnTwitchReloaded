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
  Color(.858,.219,.219,1,.858,.219,.219),
  Color(.964,.384,.121,1,.964,.384,.121),
  Color(.996,.8,.184,1,.996,.8,.184),
  Color(0.596,.858,.301,1,0.596,.858,.301),
  Color(.196,.709,.913,1,.196,.709,.913),
  Color(.254,.321,.828,1,.254,.321,.828),
  Color(.549,.27,.968,1,.549,.27,.968)
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

enums.StageTypes = {
  StageType.STAGETYPE_ORIGINAL,
  StageType.STAGETYPE_WOTL,
  StageType.STAGETYPE_AFTERBIRTH,
  StageType.STAGETYPE_REPENTANCE,
  StageType.STAGETYPE_REPENTANCE_B,
}

enums.StageLevels = {
  LevelStage.STAGE1_1,
	LevelStage.STAGE1_2,
	LevelStage.STAGE2_1,
	LevelStage.STAGE2_2,
	LevelStage.STAGE3_1,
	LevelStage.STAGE3_2,
	LevelStage.STAGE4_1,
	LevelStage.STAGE4_2,
	LevelStage.STAGE4_3,
	LevelStage.STAGE5,
	LevelStage.STAGE6,
	LevelStage.STAGE7,
	LevelStage.STAGE8
}

enums.Doors = {
  RoomType.ROOM_DEFAULT,
  RoomType.ROOM_SHOP,
  RoomType.ROOM_TREASURE,
  RoomType.ROOM_BOSS,
  RoomType.ROOM_SECRET,
  RoomType.ROOM_ARCADE,
  RoomType.ROOM_CURSE,
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
  EntityType.ENTITY_FORSAKEN,
  EntityType.ENTITY_LIL_BLUB,
  EntityType.ENTITY_RAINMAKER,
  EntityType.ENTITY_VISAGE,
  EntityType.ENTITY_SIREN,
  EntityType.ENTITY_BUMBINO,
  EntityType.ENTITY_BABY_PLUM
}

enums.TwitchRoomPickups = {
  Isaac.GetEntityVariantByName ("Bits A"),
  Isaac.GetEntityVariantByName ("Bits B"),
  Isaac.GetEntityVariantByName ("Bits C"),
  Isaac.GetEntityVariantByName ("Bits D"),
  Isaac.GetEntityVariantByName ("Bits E"),
  Isaac.GetEntityVariantByName ("Twitch Heart")
}

enums.BasicCards = {
  Card.CARD_FOOL,
  Card.CARD_MAGICIAN,
  Card.CARD_HIGH_PRIESTESS,
  Card.CARD_EMPRESS,
  Card.CARD_EMPEROR,
  Card.CARD_HIEROPHANT,
  Card.CARD_LOVERS,
  Card.CARD_CHARIOT,
  Card.CARD_JUSTICE,
  Card.CARD_HERMIT,
  Card.CARD_WHEEL_OF_FORTUNE,
  Card.CARD_STRENGTH,
  Card.CARD_HANGED_MAN,
  Card.CARD_DEATH,
  Card.CARD_TEMPERANCE,
  Card.CARD_DEVIL,
  Card.CARD_TOWER,
  Card.CARD_STARS,
  Card.CARD_MOON,
  Card.CARD_SUN,
  Card.CARD_JUDGEMENT,
  Card.CARD_WORLD
}

enums.RedCards = {
  Card.CARD_CLUBS_2,
  Card.CARD_DIAMONDS_2,
  Card.CARD_SPADES_2,
  Card.CARD_HEARTS_2,
  Card.CARD_ACE_OF_CLUBS,
  Card.CARD_ACE_OF_DIAMONDS,
  Card.CARD_ACE_OF_SPADES,
  Card.CARD_ACE_OF_HEARTS,
  Card.CARD_JOKER
}

enums.Runes = {
  Card.RUNE_HAGALAZ,
  Card.RUNE_JERA,
  Card.RUNE_EHWAZ,
  Card.RUNE_DAGAZ,
  Card.RUNE_ANSUZ,
  Card.RUNE_PERTHRO,
  Card.RUNE_BERKANO,
  Card.RUNE_ALGIZ,
  Card.RUNE_BLANK
}

return enums