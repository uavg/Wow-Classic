
-- oUF_SimpleConfig: party
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Party Config
-----------------------------

--custom filter for party buffsw
local function CustomFilter(...)
  --icons, unit, icon, name, texture, count, dispelType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID, canApply, isBossDebuff, casterIsPlayer, nameplateShowAll
  local _, _, _, _, _, _, _, duration, _, caster, _, _, _, _, _, _, _ = ...
  return caster == 'player' and duration < 60 and duration > 0
end

L.C.party = {
  enabled = true,
  size = {200,26},
  point = {"LEFT",100,0},
  scale = 1*L.C.globalscale,
  --healthbar
  healthbar = {
    --health and absorb bar cannot be disabled, they match the size of the frame
    colorDisconnected = true,
    colorClass = true,
    colorReaction = true,
    colorHealth = true,
    colorThreat = false,
    name = {
      enabled = true,
      points = {
        {"TOPLEFT",2,10},
        {"TOPRIGHT",-2,10},
      },
      size = 17,
      tag = "[name][oUF_Simple:leader]",
    },
    health = {
      enabled = true,
      point = {"RIGHT",-2,0},
      size = 16,
      tag = "",
    },
    debuffHighlight = true,
  },
  --powerbar
  powerbar = {
    enabled = true,
    size = {180,5},
    point = {"TOP","BOTTOM",0,-4}, --if no relativeTo is given the frame base will be the relativeTo reference
    colorPower = true,
  },
  --raidmark
  raidmark = {
    enabled = true,
    size = {18,18},
    point = {"CENTER","TOP",0,0},
  },
  --buffs
  buffs = {
    enabled = true,
    point = {"CENTER","CENTER",0,-2},
    num = 8,
    cols = 8,
    size = 14,
    spacing = 5,
    initialAnchor = "LEFT",
    growthX = "RIGHT",
    growthY = "UP",
    disableCooldown = false,
    CustomFilter = CustomFilter
  },
  --debuffs
  debuffs = {
    enabled = true,
    point = {"LEFT","RIGHT",5,0},
    num = 5,
    cols = 5,
    size = 26,
    spacing = 5,
    initialAnchor = "TOPLEFT",
    growthX = "RIGHT",
    growthY = "DOWN",
    disableCooldown = false,
  },
  setup = {
    template = nil,
    visibility = "custom [group:party,nogroup:raid] show; hide",
    showPlayer = false,
    showSolo = false,
    showParty = true,
    showRaid = false,
    point = "TOP",
    xOffset = 0,
    yOffset = -24,
  },
}
