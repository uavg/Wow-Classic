local _, namespace = ...
local AnchorManager = namespace.AnchorManager
local PoolManager = namespace.PoolManager

local addon = namespace.addon
local activeFrames = addon.activeFrames
local gsub = _G.string.gsub
local unpack = _G.unpack
local min = _G.math.min
local max = _G.math.max
local UnitExists = _G.UnitExists
local UIFrameFadeOut = _G.UIFrameFadeOut
local UIFrameFadeRemoveFrame = _G.UIFrameFadeRemoveFrame

function addon:GetCastbarFrame(unitID)
    -- PoolManager:DebugInfo()
    if unitID == "player" then return CastingBarFrame end

    if activeFrames[unitID] then
        return activeFrames[unitID]
    end

    activeFrames[unitID] = PoolManager:AcquireFrame()

    return activeFrames[unitID]
end

function addon:SetTargetCastbarPosition(castbar, parentFrame)
    local auraRows = parentFrame.auraRows or 0

    if oUF_SimpleConfig then
      local rConfig, xOffset, yOffset
      if parentFrame.unit == "target" then
        rConfig = oUF_SimpleConfig.target.castbar
        xOffset = -12
        yOffset = 0
      else
        rConfig = oUF_SimpleConfig.nameplate.castbar
        xOffset = 5
        yOffset = -15
      end
      castbar:SetPoint(rConfig.point[1], parentFrame, rConfig.point[2], rConfig.point[4] + xOffset, rConfig.point[4] - yOffset)
      castbar:SetSize(unpack(rConfig.size))
    elseif parentFrame.haveToT or parentFrame.haveElite or UnitExists("targettarget") then
        if parentFrame.buffsOnTop or auraRows <= 1 then
            castbar:SetPoint("CENTER", parentFrame, -18, -75)
        else
            castbar:SetPoint("CENTER", parentFrame, -18, max(min(-75, -37.5 * auraRows), -150))
        end
    else
        if not parentFrame.buffsOnTop and auraRows > 0 then
            castbar:SetPoint("CENTER", parentFrame, -18, max(min(-75, -37.5 * auraRows), -150))
        else
            castbar:SetPoint("CENTER", parentFrame, -18, -50)
        end
    end
end

function addon:SetCastbarIconAndText(castbar, cast, db)
    local spellName = cast.spellName

    if castbar.Text:GetText() ~= spellName then
        castbar.Icon:SetTexture(cast.icon)
        castbar.Text:SetText(spellName)

        -- Move timer position depending on spellname length
        if db.showTimer then
            castbar.Timer:SetPoint("RIGHT", castbar, (spellName:len() >= 19) and 30 or -6, 0)
        end
    end
end

function addon:SetCastbarStyle(castbar, cast, db)
    castbar:SetSize(db.width, db.height)
    castbar.Timer:SetShown(db.showTimer)
    castbar:SetStatusBarTexture(db.castStatusBar)
    castbar:SetFrameLevel(db.frameLevel)

    if db.showCastInfoOnly then
        castbar.Timer:SetText("")
        castbar:SetValue(0)
        castbar.Spark:SetAlpha(0)
    else
        castbar.Spark:SetAlpha(1)
    end

    if db.hideIconBorder then
        castbar.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    else
        castbar.Icon:SetTexCoord(0, 1, 0, 1)
    end

    castbar.Spark:SetHeight(db.height * 2.1)
    castbar.Icon:SetSize(db.iconSize, db.iconSize)
    castbar.Icon:SetPoint("LEFT", castbar, db.iconPositionX - db.iconSize, db.iconPositionY)
    castbar.Border:SetVertexColor(unpack(db.borderColor))

    if db.castBorder == "Interface\\CastingBar\\UI-CastingBar-Border-Small" or db.castBorder == "Interface\\CastingBar\\UI-CastingBar-Border" then -- default border
        castbar.Border:SetAlpha(1)
        if castbar.BorderFrame then
            -- Hide LSM border frame if it exists
            castbar.BorderFrame:SetAlpha(0)
        end

        -- Update border to match castbar size
        local width, height = castbar:GetWidth() * 1.16, castbar:GetHeight() * 1.16
        castbar.Border:SetPoint("TOPLEFT", width, height)
        castbar.Border:SetPoint("BOTTOMRIGHT", -width, -height)
    else
        -- Using border sat by LibSharedMedia
        self:SetLSMBorders(castbar, cast, db)
    end
end

-- LSM uses backdrop for borders instead of normal textures
function addon:SetLSMBorders(castbar, cast, db)
    -- Create new frame to contain our backdrop
    -- (castbar.Border is a texture object and not a frame so we can't reuse that)
    if not castbar.BorderFrame then
        castbar.BorderFrame = CreateFrame("Frame", nil, castbar)
        castbar.BorderFrame:SetPoint("TOPLEFT", castbar, -2, 2)
        castbar.BorderFrame:SetPoint("BOTTOMRIGHT", castbar, 2, -2)
    end

    castbar.Border:SetAlpha(0) -- hide default border
    castbar.BorderFrame:SetAlpha(1)

    -- TODO: should be a better way to handle this.
    -- Certain borders with transparent textures requires frame level 1 to show correctly.
    -- Meanwhile non-transparent textures requires the frame level to be higher than the castbar frame level
    if db.castBorder == "Interface\\CHARACTERFRAME\\UI-Party-Border" or db.castBorder == "Interface\\Tooltips\\ChatBubble-Backdrop" then
        castbar.BorderFrame:SetFrameLevel(1)
    else
        castbar.BorderFrame:SetFrameLevel(castbar:GetFrameLevel() + 1)
    end

    -- Apply backdrop if it isn't already active
    if castbar.BorderFrame.currentTexture ~= db.castBorder then
        castbar.BorderFrame:SetBackdrop({
            edgeFile = db.castBorder,
            tile = false, tileSize = 0,
            edgeSize = castbar:GetHeight(),
        })
        castbar.BorderFrame.currentTexture = db.castBorder
    end
    castbar.BorderFrame:SetBackdropBorderColor(unpack(db.borderColor))
end

function addon:SetCastbarFonts(castbar, cast, db)
    local fontName, fontHeight = castbar.Text:GetFont()

    if fontName ~= db.castFont or db.castFontSize ~= fontHeight then
        castbar.Text:SetFont(db.castFont, db.castFontSize)
        castbar.Timer:SetFont(db.castFont, db.castFontSize)
    end

    local c = db.textColor
    castbar.Text:SetTextColor(c[1], c[2], c[3], c[4])
    castbar.Timer:SetTextColor(c[1], c[2], c[3], c[4])
    castbar.Text:SetPoint("CENTER", db.textPositionX, db.textPositionY)
end

function addon:SetZorkCastbar(castbar, cast, unitID)
  local cfg = {}
  if gsub(unitID, "%d", "") == "target" then
    cfg = oUF_SimpleConfig.target
    castbar:SetScale(1)
  else
    cfg = oUF_SimpleConfig.nameplate
    castbar:SetScale(cfg.scale)
  end

  castbar:SetStatusBarTexture(oUF_SimpleConfig.textures.statusbar)
  castbar:SetFrameStrata("MEDIUM")
  castbar:SetSize(unpack(cfg.castbar.size))
  castbar:SetOrientation(cfg.castbar.orientation or "HORIZONTAL")
  castbar:SetStatusBarColor(unpack(oUF_SimpleConfig.colors.castbar.default))

  --bg
  if not castbar.Background then
    castbar.Background = castbar:CreateTexture(nil, "BACKGROUND")
  end
  castbar.Background:SetTexture(oUF_SimpleConfig.textures.statusbar)
  castbar.Background:SetAllPoints()
  castbar.Background:SetVertexColor(unpack(oUF_SimpleConfig.colors.castbar.defaultBG)) --bg multiplier

  --backdrop
  local backdrop = oUF_SimpleConfig.backdrop
  if not castbar.Backdrop then
    castbar.Backdrop = CreateFrame("Frame", nil, castbar)
  else
    castbar.Backdrop:Show()
  end
  castbar.Backdrop:SetFrameLevel(castbar:GetFrameLevel()-2 or -1)
  castbar.Backdrop:SetPoint("TOPLEFT", castbar, "TOPLEFT", -backdrop.inset, backdrop.inset)
  castbar.Backdrop:SetPoint("BOTTOMRIGHT", castbar, "BOTTOMRIGHT", backdrop.inset, -backdrop.inset)
  castbar.Backdrop:SetBackdrop(backdrop)
  castbar.Backdrop:SetBackdropColor(unpack(backdrop.bgColor))
  castbar.Backdrop:SetBackdropBorderColor(unpack(backdrop.edgeColor))

  if cfg.castbar.icon and cfg.castbar.icon.enabled then
    --icon
    if not castbar.Icon then
      castbar.Icon = castbar:CreateTexture(nil,"BACKGROUND",nil,-8)
    else
      castbar.Icon:Show()
    end
    castbar.Icon:ClearAllPoints()
    castbar.Icon:SetPoint(cfg.castbar.icon.point[1], castbar, cfg.castbar.icon.point[2], cfg.castbar.icon.point[3], cfg.castbar.icon.point[4])
    castbar.Icon:SetSize(unpack(cfg.castbar.icon.size))
    castbar.Icon:SetTexture(cast.icon)
    castbar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    --backdrop (for the icon)
    if not castbar.Icon.Backdrop then
      castbar.Icon.Backdrop = CreateFrame("Frame", nil, castbar)
    else
      castbar.Icon.Backdrop:Show()
    end
    castbar.Icon.Backdrop:SetFrameLevel(castbar:GetFrameLevel()-2 or -1)
    castbar.Icon.Backdrop:SetPoint("TOPLEFT", castbar.Icon, "TOPLEFT", -backdrop.inset, backdrop.inset)
    castbar.Icon.Backdrop:SetPoint("BOTTOMRIGHT", castbar.Icon, "BOTTOMRIGHT", backdrop.inset, -backdrop.inset)
    castbar.Icon.Backdrop:SetBackdrop(backdrop)
    castbar.Icon.Backdrop:SetBackdropColor(unpack(backdrop.bgColor))
    castbar.Icon.Backdrop:SetBackdropBorderColor(unpack(backdrop.edgeColor))
  end
  --[[
  --shield
  castbar.Shield = castbar:CreateTexture(nil,"BACKGROUND",nil,-8)
  castbar.Shield.__owner = castbar
  --use a trick here...we use the show/hide on the shield texture to recolor the castbar
  hooksecurefunc(castbar.Shield, "Show", SetCastBarColorShielded)
  hooksecurefunc(castbar.Shield, "Hide", SetCastBarColorDefault)
  ]]
  --text
  if cfg.castbar.name and cfg.castbar.name.enabled then
    local cfgName = cfg.castbar.name
    if not castbar.Text then
      castbar.Text = castbar:CreateFontString(nil, "ARTWORK") --"BORDER", "OVERLAY"
    end
    castbar.Text:SetFont(cfgName.font or STANDARD_TEXT_FONT, cfgName.size or 14, cfgName.outline or "OUTLINE")
    castbar.Text:SetJustifyH(cfgName.align or "LEFT")
    if not cfgName.noshadow then
      castbar.Text:SetShadowColor(0,0,0,0.25)
      castbar.Text:SetShadowOffset(1,-2)
    end
    --fix some wierd bug
    castbar.Text:SetText(cast.spellName)
    castbar.Text:SetMaxLines(1)
    castbar.Text:SetHeight(castbar.Text:GetStringHeight())

    if cfgName.points then
      castbar.Text:SetPoint(cfgName.points[1][1], castbar, cfgName.points[1][2], cfgName.points[1][3], cfgName.points[1][4])
      castbar.Text:SetPoint(cfgName.points[2][1], castbar, cfgName.points[2][2], cfgName.points[2][3], cfgName.points[2][4])
    else
      castbar.Text:SetPoint(cfgName.point[1], castbar, cfgName.point[2], cfgName.point[3], cfgName.point[4])
    end
  end
end

function addon:DisplayCastbar(castbar, unitID)
    local parentFrame = AnchorManager:GetAnchor(unitID)
    if not parentFrame then return end -- sanity check

    local db = self.db[gsub(unitID, "%d", "")] -- nameplate1 -> nameplate
    if unitID == "nameplate-testmode" then
        db = self.db.nameplate
    elseif unitID == "party-testmode" then
        db = self.db.party
    end

    if castbar.fadeInfo then
        -- need to remove frame if it's currently fading so alpha doesn't get changed after re-displaying castbar
        UIFrameFadeRemoveFrame(castbar)
        castbar.fadeInfo.finishedFunc = nil
    end

    local cast = castbar._data
    cast.showCastInfoOnly = db.showCastInfoOnly
    castbar:SetParent(parentFrame)
    castbar.Text:SetWidth(db.width - 10) -- ensure text gets truncated

    if not oUF_SimpleConfig then
      if not castbar.Background then
          for k, v in pairs({ castbar:GetRegions() }) do
              if v.GetTexture and v:GetTexture() and strfind(v:GetTexture(), "Color-") then
                  castbar.Background = v
                  break
              end
          end
      end
      castbar.Background:SetColorTexture(unpack(db.statusBackgroundColor))
    end

    if cast.isChanneled then
        castbar:SetStatusBarColor(unpack(db.statusColorChannel))
    else
        castbar:SetStatusBarColor(unpack(db.statusColor))
    end

    if oUF_SimpleConfig or (unitID == "target" and self.db.target.autoPosition) then
        self:SetTargetCastbarPosition(castbar, parentFrame)
    else
        castbar:SetPoint(db.position[1], parentFrame, db.position[2], db.position[3])
    end

    -- Note: since frames are recycled and we also allow having different styles
    -- between castbars for target frame & nameplates, we need to always update the style here
    -- incase it was modified to something else on last recycle
    if oUF_SimpleConfig then
      self:SetZorkCastbar(castbar, cast, unitID)
      castbar.Spark:SetAlpha(0)
      castbar.Spark:Hide()
      castbar.Timer:Hide()
    else
      self:SetCastbarStyle(castbar, cast, db)
      self:SetCastbarFonts(castbar, cast, db)
      self:SetCastbarIconAndText(castbar, cast, db)
    end

    if not castbar.isTesting then
        castbar:SetMinMaxValues(0, cast.maxValue)
        castbar:SetValue(0)
        castbar.Spark:SetPoint("CENTER", castbar, "LEFT", 0, 0)
    end

    castbar:SetAlpha(1)
    castbar:Show()
end

function addon:HideCastbar(castbar, noFadeOut)
    if noFadeOut then
        castbar:SetAlpha(0)
        castbar:Hide()
        return
    end

    local cast = castbar._data

    if cast and cast.isInterrupted then
        castbar.Text:SetText(_G.INTERRUPTED)
        castbar:SetStatusBarColor(castbar.failedCastColor:GetRGB())
    end

    --[[if cast and cast.isCastComplete and not cast.isChanneled then
        castbar:SetStatusBarColor(0, 1, 0)
    end]]

    UIFrameFadeOut(castbar, cast and cast.isInterrupted and 1.5 or 0.2, 1, 0)
end

-- TODO: gotta be able to reset aswell
function addon:SkinPlayerCastbar()
    local db = self.db.player

    if not CastingBarFrame.Timer then
        -- TODO: implement me
        CastingBarFrame.Timer = CastingBarFrame:CreateFontString(nil, "OVERLAY")
        CastingBarFrame.Timer:SetTextColor(1, 1, 1)
        CastingBarFrame.Timer:SetFontObject("SystemFont_Shadow_Small")
        CastingBarFrame.Timer:SetPoint("RIGHT", CastingBarFrame, -6, 0)
    end

    CastingBarFrame_SetStartCastColor(CastingBarFrame, unpack(db.statusColor))
  	CastingBarFrame_SetStartChannelColor(CastingBarFrame, unpack(db.statusColorChannel))
  	--[[CastingBarFrame_SetFinishedCastColor(CastingBarFrame, 0.0, 1.0, 0.0)
  	CastingBarFrame_SetNonInterruptibleCastColor(CastingBarFrame, 0.7, 0.7, 0.7)
  	CastingBarFrame_SetFailedCastColor(CastingBarFrame, 1.0, 0.0, 0.0)]]

    CastingBarFrame.Text:ClearAllPoints()
    CastingBarFrame.Text:SetPoint("CENTER")
    CastingBarFrame.Icon:ClearAllPoints()
    CastingBarFrame.Icon:Show()

    if not db.autoPosition then
        local pos = db.position
        CastingBarFrame:SetPoint(pos[1], UIParent, pos[2], pos[3])
        CastingBarFrame.OldSetPoint = CastingBarFrame.SetPoint
        CastingBarFrame.SetPoint = function() end
    else
        if CastingBarFrame.OldSetPoint then
            CastingBarFrame.SetPoint = CastingBarFrame.OldSetPoint
        end
    end

    self:SetCastbarStyle(CastingBarFrame, nil, db)
    self:SetCastbarFonts(CastingBarFrame, nil, db)
end
