local A, L = ...

L.C = {}

_, L.C.playerClass = UnitClass('player')
L.C.maxComboPoints = 5 --may need to change in the future

L.C.target = {
  enabled = true,
  anchorToZorkUI = true,
  textMode = false,
  textSize = 36,
  textOffsetX = -48,
  textOffsetY = 30,
  imageWidth = 10,
  imageHeight = 5,
  imageOffsetX = -25,
  imageOffsetY = 18,
  point = {"LEFT", UIParent, "CENTER", 130, -210},
  colors = {     -- r, g, b
    {1, 1, 1},   -- 0p
    {1, 1, 1},   -- 1p
    {1, 1, 1},   -- 2p
    {1, 1, 1},   -- 3p
    {1, 1, 0},   -- 4p
    {1, 0, 0},   -- 5p
    {0.5, 0, 0}, -- 6p
  }
}
