
-- oUF_SimpleConfig: player
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Player Config
-----------------------------

L.C.player = {
  enabled = true,
  size = {265,26},
  point = {"RIGHT",UIParent,"CENTER",-130,-210},
  scale = 1*L.C.globalscale,
  frameVisibility = "show",
  --fader via OnShow
  fader = {
    fadeInAlpha = 1,
    fadeInDuration = 0.3,
    fadeInSmooth = "OUT",
    fadeOutAlpha = 0,
    fadeOutDuration = 0.9,
    fadeOutSmooth = "OUT",
    fadeOutDelay = 0,
    trigger = "OnShow",
  },
  --healthbar
  healthbar = {
    --orientation = "VERTICAL",
    --health and absorb bar cannot be disabled, they match the size of the frame
    colorClass = true,
    colorHealth = true,
    colorThreat = false,
    frequentUpdates = true,
    name = {
      enabled = true,
      points = {
        {"TOPLEFT",2,10},
        {"TOPRIGHT",-2,10},
      },
      size = 17,
      tag = "[oUF_SimpleConfig:status][oUF_Simple:leader]",
    },
    health = {
      enabled = true,
      point = {"RIGHT",-2,0},
      size = 16,
      tag = "[oUF_Simple:health]",
    },
    debuffHighlight = true,
  },
  --powerbar
  powerbar = {
    enabled = true,
    size = {265,5},
    point = {"TOP","BOTTOM",0,-4}, --if no relativeTo is given the frame base will be the relativeTo reference
    colorPower = true,
    power = {
      enabled = false,
      point = {"RIGHT",-2,0},
      size = 16,
      tag = "[perpp]",
    },
  },
  --raidmark
  raidmark = {
    enabled = true,
    size = {18,18},
    point = {"CENTER","TOP",0,0},
  },
  --castbar
  castbar = {
    enabled = true,
    size = {365,26},
    point = {"BOTTOM","TOP",255,-140},
    --orientation = "VERTICAL",
    name = {
      enabled = true,
      points = {
        {"LEFT",2,0},
        {"RIGHT",-2,0},
      },
      --font = STANDARD_TEXT_FONT,
      size = 16,
      --outline = "",--OUTLINE",
      --align = "CENTER",
      --noshadow = true,
    },
    icon = {
      enabled = true,
      size = {26,26},
      point = {"RIGHT","LEFT",-6,0},
    },
  },
  --classbar
  classbar = {
    enabled = false,
    size = {130,5},
    point = {"BOTTOMRIGHT","TOPRIGHT",0,4},
    splits = {
      enabled = true,
      texture = L.C.textures.split,
      size = {5,5},
      color = {0,0,0,1}
    },
  },
  --altpowerbar
  altpowerbar = {
    enabled = false,
    size = {130,5},
    point = {"BOTTOMLEFT","TOPLEFT",0,4},
  },
  --addpowerbar (additional powerbar, like mana if a druid has rage display atm)
  addpowerbar = {
    enabled = false,
    size = {265,5},
    point = {"TOP","BOTTOM",0,-13},
    orientation = "HORIZONTAL",
    colorPower = true,
  },
  buffs = {
    enabled = true,
    point = {"BOTTOMRIGHT","LEFT",-7,5},
    num = 32,
    cols = 8,
    size = 22,
    spacing = 5,
    initialAnchor = "BOTTOMRIGHT",
    growthX = "LEFT",
    growthY = "UP",
    disableCooldown = false,
  },
  debuffs = {
    enabled = true,
    point = {"TOPRIGHT","LEFT",-7,-5},
    num = 40,
    cols = 8,
    size = 22,
    spacing = 5,
    initialAnchor = "TOPRIGHT",
    growthX = "LEFT",
    growthY = "DOWN",
    disableCooldown = false,
  },
}
