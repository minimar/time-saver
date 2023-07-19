local mod = RegisterMod("Time Saver", 1)

function GetGridEntities()
  ---@type GridEntity[]
  local gridEntities = {}
  local room = Game():GetRoom()

  for i = 0, room:GetGridSize() - 1, 1 do
    local gridEntity = room:GetGridEntity(i)

    gridEntities[#gridEntities+1] = gridEntity
  end
  return gridEntities
end

function destroyPoopFire()
  for gridIndex = 1, room:GetGridSize() do -- for grid entites
    local grid = room:GetGridEntity(gridIndex)
    if grid and grid:ToPoop() then
        grid:Destroy()
    end
  end
  local room = Game():GetRoom()
  for i, entity in pairs(Isaac.GetRoomEntities()) do
    if entity.Type == EntityType.ENTITY_FIREPLACE then
      entity:TakeDamage(1000000, 0, EntityRef(nil), 0)
    end
  end  
end

--TODO: Fix the two following monstrosities of a function

function destroyRocks()
  for index, value in ipairs(GetGridEntities()) do
    if (value:GetType() == GridEntityType.GRID_ROCK or value:GetType() == GridEntityType.GRID_ROCKT or value:GetType() == GridEntityType.GRID_ROCK_BOMB or value:GetType() == GridEntityType.GRID_ROCK_ALT or value:GetType() == GridEntityType.GRID_ROCK_SS or value:GetType() == GridEntityType.GRID_ROCK_SPIKED or value:GetType() == GridEntityType.GRID_ROCK_ALT2 or value:GetType() == GridEntityType.GRID_ROCK_GOLD) and (checkBombStatus() == true)then
      value:Destroy()
    end
  end
end

function checkBombStatus()
  local player = Isaac.GetPlayer()
  --TODO: Magic numbers are bad! Also a monstrosity.
  if (player:HasGoldenBomb() == true) or (player:HasCollectible(149) == true) or (player:HasCollectible(52) == true) or (player:HasCollectible(168) == true) or (player:HasCollectible(378) == true) or (player:HasCollectible(592) == true) or (player:HasCollectible(604) == true) or (player:HasCollectible(463) == true) or (player:HasCollectible(314) == true) or (player:HasCollectible(321) == true) then
    return true
  else
    return false
  end
end

mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, function()
  destroyPoopFire()
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
  if Game():GetRoom():IsClear() then
    destroyPoopFire()
  end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
  if Input.IsButtonTriggered(71, 0) and Game():GetRoom():IsClear() then
    destroyRocks()
  end
end)
