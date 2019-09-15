local A, L = ...

if (L.C.playerClass == 'ROGUE' or L.C.playerClass == 'DRUID') then
  local p, rf, rp, ox, oy = unpack(L.C.target.point) -- Standalone
  if (L.C.target.anchorToZorkUI and oUF_SimpleConfig ~= nil) then
    p, rf, rp, ox, oy = unpack(oUF_SimpleConfig.target.point) -- Zork's UI
  end

  local targetPoints = CreateFrame("Frame", "targetPoints", UIParent)
  if (L.C.target.textMode) then
    targetPoints:SetWidth(L.C.target.textSize)
    targetPoints:SetHeight(L.C.target.textSize)
    targetPoints:SetPoint(p, rf, rp, ox + L.C.target.textOffsetX, oy + L.C.target.textOffsetY)
    targetPoints.points = targetPoints:CreateFontString("MEDIUM", "GameFontNormalLarge")
    targetPoints.points:SetFontObject("GameFontNormalLarge")
    targetPoints.points:SetWidth(L.C.target.textSize)
    targetPoints.points:SetHeight(L.C.target.textSize)
    targetPoints.points:SetTextColor(1, 1, 1)
    targetPoints.points:SetPoint("CENTER", targetPoints, "CENTER", 0, 0)
  else
    targetPoints:SetWidth(1)
    targetPoints:SetHeight(1)
    targetPoints:SetPoint(p, rf, rp, ox + L.C.target.imageOffsetX, oy + L.C.target.imageOffsetY)
    local previous = targetPoints

    targetPoints.points = {}
    for i = 1, L.C.maxComboPoints, 1 do
      targetPoints.points[i] = CreateFrame("Frame", "targetPoints"..i, targetPoints)
      targetPoints.points[i]:SetFrameStrata("HIGH")
      targetPoints.points[i]:SetWidth(L.C.target.imageWidth)
      targetPoints.points[i]:SetHeight(L.C.target.imageHeight)

      local t = targetPoints.points[i]:CreateTexture(nil, "HIGH")
      t:SetTexture("interface\\addons\\"..A.."\\media\\square")
      t:SetAllPoints(targetPoints.points[i])
      t:SetVertexColor(unpack(L.C.target.colors[i+1]))

      targetPoints.points[i].texture = t
      targetPoints.points[i]:SetPoint("BOTTOM", previous, "TOP")

      previous = targetPoints.points[i]
    end
  end

  targetPoints:SetScript("OnEvent", function(self, event, ...)
    return self[event](self, event, ...)
  end)

  function targetPoints.PLAYER_TARGET_CHANGED(self, event)
    local isEnemy = UnitReaction("target", "player")
    if (isEnemy == nil) then
      isEnemy = false
    else
      isEnemy = isEnemy < 5
    end

    if UnitExists("target") and isEnemy and UnitPowerMax("player", 3) > 0 then
      self:Show()
      self:UNIT_COMBO_POINTS(event)
    else
      self:Hide()
    end
  end

  function targetPoints.UNIT_POWER_FREQUENT(self, event)
    if UnitExists("target") then
      self:UNIT_COMBO_POINTS(event)
    end
  end

  function targetPoints.UNIT_COMBO_POINTS(self, event, ...)
    local comboPoints, _, _, _, _ = GetComboPoints("player", "target");
    if (L.C.target.textMode) then
      self.points:SetText(comboPoints)
      self.points:SetTextColor(unpack(L.C.target.colors[comboPoints+1]))
    else
      for i = 1, L.C.maxComboPoints, 1 do
        if (i <= comboPoints) then
          self.points[i]:Show()
        else
          self.points[i]:Hide()
        end
      end
    end
  end

  targetPoints:RegisterEvent("PLAYER_TARGET_CHANGED")
  targetPoints:RegisterEvent("UNIT_POWER_FREQUENT")

  targetPoints:Hide()
end
