
-- oUF_SimpleConfig: tags
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Tags
-----------------------------

local floor = floor

--tag method: oUF_SimpleConfig:status
L.C.tagMethods["oUF_SimpleConfig:status"] = function(unit,...)
  if UnitAffectingCombat(unit) then
    return "|TInterface\\CharacterFrame\\UI-StateIcon:20:20:0:0:64:64:33:64:0:31|t"
  elseif unit == "player" and IsResting() then
    return "|TInterface\\CharacterFrame\\UI-StateIcon:20:20:0:0:64:64:0:31:0:31|t"
  end
end

--tag method: oUF_SimpleConfig:classification
L.C.tagMethods["oUF_SimpleConfig:classification"] = function(unit)
  local c = UnitClassification(unit)
  local l = UnitLevel(unit)
  if(c == 'worldboss' or l == -1) then
    return '|cffff0000{B}|r '
  elseif(c == 'rare') then
    return '|cffff9900{R}|r '
  elseif(c == 'rareelite') then
    return '|cffff0000{R+}|r '
  elseif(c == 'elite') then
    return '|cffff6666{E}|r '
  end
end

--tag method: oUF_SimpleConfig:happiness
L.C.tagMethods["oUF_SimpleConfig:happiness"] = function(unit)
  happiness, damagePercentage, loyaltyRate = GetPetHappiness()
  local happyString = ''
  if happiness then
    if (happiness == 1) then
      happyString = '|cffff0000•|r ' -- unhappy
    elseif (happiness == 2) then
      happyString = '|cffffff00•|r ' -- content
    elseif (happiness == 3) then
      happyString = '|cff00ff00•|r ' -- happy
    end
  end
  return happyString
end

--tag method: oUF_SimpleConfig:RealMobHealth
L.C.tagMethods["oUF_SimpleConfig:RealMobHealth"] = function(unit)
  local health = ""
  if not UnitIsConnected(unit) then
    return "|cff999999Offline|r"
  end
  if(UnitIsDead(unit) or UnitIsGhost(unit)) then
    return "|cff999999Dead|r"
  end

  if RealMobHealth and RealMobHealth.UnitHasHealthData(unit)then
    health, _ = RealMobHealth.GetUnitHealth(unit)
  elseif UnitHealthMax(unit) == 100 then
    health = ""
  else
    health = UnitHealth(unit)
  end
  return health.."|ccccccccc"
end

--tag event: oUF_SimpleConfig:RealMobHealth
L.C.tagEvents["oUF_SimpleConfig:RealMobHealth"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"
--tag event: oUF_Simple:status
L.C.tagEvents["oUF_SimpleConfig:status"] = "PLAYER_REGEN_DISABLED PLAYER_REGEN_ENABLED PLAYER_UPDATE_RESTING"
--tag event: oUF_Simple:status
L.C.tagEvents["oUF_SimpleConfig:classification"] = "UNIT_CLASSIFICATION_CHANGED"
--tag event: oUF_Simple:happiness
L.C.tagEvents["oUF_SimpleConfig:happiness"] = "UNIT_HAPPINESS"

