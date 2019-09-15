
-- oUF_SimpleConfig: raid
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Raid Config
-----------------------------

--custom filter for raid buffs
local function CustomFilter(...)
  --icons, unit, icon, name, texture, count, dispelType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID, canApply, isBossDebuff, casterIsPlayer, nameplateShowAll
  local _, _, _, _, _, _, _, duration, _, caster, _, _, _, _, _, _, _ = ...
  return caster == 'player' and duration < 60 and duration > 0
end

L.C.raid = {
  enabled = true,
  size = {110,26},
  points = { --list of 8 points, one for each raid group
    {"TOPLEFT",20,-20},
    {"TOP", "oUF_SimpleRaidHeader1", "BOTTOM", 0, -10},
    {"TOP", "oUF_SimpleRaidHeader2", "BOTTOM", 0, -10},
    {"TOP", "oUF_SimpleRaidHeader3", "BOTTOM", 0, -10},
    {"TOPLEFT", "oUF_SimpleRaidHeader1", "TOPRIGHT", 10, 0},
    {"TOP", "oUF_SimpleRaidHeader5", "BOTTOM", 0, -10},
    {"TOP", "oUF_SimpleRaidHeader6", "BOTTOM", 0, -10},
    {"TOP", "oUF_SimpleRaidHeader7", "BOTTOM", 0, -10},
  },
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
        {"LEFT",2,0},
        {"RIGHT",-2,0},
      },
      size = 16,
      align = "CENTER",
      tag = "[name][oUF_Simple:role]",
    },
    debuffHighlight = true,
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
  setup = {
    template = nil,
    visibility = "custom [group:raid] show; hide",
    showPlayer = false,
    showSolo = false,
    showParty = false,
    showRaid = true,
    point = "TOP",
    xOffset = 0,
    yOffset = -5,
  },
}
