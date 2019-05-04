local trinkets = {}

-- Example
--trinkets.ItemName= {
--  id = Isaac.GetItemIdByName("Item Name"), <-- Item Id
--  description = {en = "Item description", ru = "Описание" }, <-- Item description for external item description mod
--  hold = flase, <-- If player hold trinket now
--  onPickup = nil, <-- Function, called on pickup item
--  onUpdate = nil, <-- Function, called every update when player have item
--  onCacheUpdate = nil, <-- Function, called when player stats evaluate
--  onEntityUpdate = nil, <-- Functon, called for every enemy on postUpdate
--  onRoomChange = nil, <-- Function, called when room changed
--  onDamage = nil, <-- Function, called when player get damage
--  onNPCDeath = nil, <-- Function, called when NPC died
--  onTearUpdate = nil, <-- Function, called when tier updated
--  onProjectileUpdate = nil, <-- Function, called when projectile updated
--  onStageChange = nil, <-- Function, called when stage changed
--  onRemove = nil <-- Function, called when item removed

--}

trinkets.T_NeoGlasses = {
  id = Isaac.GetItemIdByName("Neo glasses"),
  
  description = {
    en = "\1 Enemy projectiles have a chance to stop",
    ru = "\1 Снаряды монстра имеют шанс на остановку"
  },
  
  hold = false
  
}

return trinkets