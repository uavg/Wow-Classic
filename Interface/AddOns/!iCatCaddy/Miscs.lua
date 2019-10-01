----------------------------------------------------------------------------------------
--	Slash commands
----------------------------------------------------------------------------------------
SlashCmdList.RELOADUI = function() ReloadUI() end
SLASH_RELOADUI1 = "/rl"


SlashCmdList.RCSLASH = function() DoReadyCheck() end
SLASH_RCSLASH1 = "/rc"

SlashCmdList.TICKET = function() ToggleHelpFrame() end
SLASH_TICKET1 = "/gm"

----------------------------------------------------------------------------------------
--	Grid on screen
----------------------------------------------------------------------------------------
local grid
SlashCmdList.GRIDONSCREEN = function()
	if grid then
		grid:Hide()
		grid = nil
	else
		grid = CreateFrame("Frame", nil, UIParent)
		grid:SetAllPoints(UIParent)
		local width = GetScreenWidth() / 128
		local height = GetScreenHeight() / 72
		for i = 0, 128 do
			local texture = grid:CreateTexture(nil, "BACKGROUND")
			if i == 64 then
				texture:SetColorTexture(1, 0, 0, 0.8)
			else
				texture:SetColorTexture(0, 0, 0, 0.8)
			end
			texture:SetPoint("TOPLEFT", grid, "TOPLEFT", i * width - 1, 0)
			texture:SetPoint("BOTTOMRIGHT", grid, "BOTTOMLEFT", i * width, 0)
		end
		for i = 0, 72 do
			local texture = grid:CreateTexture(nil, "BACKGROUND")
			if i == 36 then
				texture:SetColorTexture(1, 0, 0, 0.8)
			else
				texture:SetColorTexture(0, 0, 0, 0.8)
			end
			texture:SetPoint("TOPLEFT", grid, "TOPLEFT", 0, -i * height)
			texture:SetPoint("BOTTOMRIGHT", grid, "TOPRIGHT", 0, -i * height - 1)
		end
	end
end
SLASH_GRIDONSCREEN1 = "/align"

-- Disable Combat Text Spam
LoadAddOn("Blizzard_CombatText")

COMBAT_TEXT_TYPE_INFO["PERIODIC_HEAL"] = {var = nil, show = nil}
COMBAT_TEXT_TYPE_INFO["HEAL_CRIT"] = {var = nil, show = nil}
COMBAT_TEXT_TYPE_INFO["HEAL"] = {var = nil, show = nil}
COMBAT_TEXT_TYPE_INFO["PERIODIC_HEAL_ABSORB"] = {var = nil, show = nil}
COMBAT_TEXT_TYPE_INFO["HEAL_CRIT_ABSORB"] = {var = nil, show = nil}
COMBAT_TEXT_TYPE_INFO["HEAL_ABSORB"] = {var = nil, show = nil}

COMBAT_TEXT_TYPE_INFO["DAMAGE_CRIT"] = {var = nil, show = nil}
COMBAT_TEXT_TYPE_INFO["DAMAGE"] = {var = nil, show = nil}
COMBAT_TEXT_TYPE_INFO["SPELL_DAMAGE_CRIT"] = {var = nil, show = nil}
COMBAT_TEXT_TYPE_INFO["SPELL_DAMAGE"] = {var = nil, show = nil}

----------------------------------------------------------------------
--	Repair automatically (no reload required)
----------------------------------------------------------------------

do

	-- Repair when suitable merchant frame is shown
	local function RepairFunc()
		if IsShiftKeyDown() then return end
		if CanMerchantRepair() then -- If merchant is capable of repair
			-- Process repair
			local RepairCost, CanRepair = GetRepairAllCost()
			if CanRepair then -- If merchant is offering repair
				if GetMoney() >= RepairCost then
					RepairAllItems()
					-- Show cost summary
					LeaPlusLC:Print(L["Repaired for"] .. " " .. GetCoinText(RepairCost) .. ".")
				end
			end
		end
	end

	-- Create event frame
	local RepairFrame = CreateFrame("FRAME")

	-- Function to setup event
	local function SetupEvent()
			RepairFrame:RegisterEvent("MERCHANT_SHOW")
	end

	-- Event handler
	RepairFrame:SetScript("OnEvent", RepairFunc)

end



----------------------------------------------------------------------
--	Disable sticky chat
----------------------------------------------------------------------

-- These taint if set to anything other than nil
ChatTypeInfo.WHISPER.sticky = nil
ChatTypeInfo.BN_WHISPER.sticky = nil
ChatTypeInfo.CHANNEL.sticky = nil


----------------------------------------------------------------------
--	BlueShaman
----------------------------------------------------------------------

RAID_CLASS_COLORS["SHAMAN"] = CreateColor(0, 0.44, 0.87, 1);
RAID_CLASS_COLORS["SHAMAN"].colorStr = RAID_CLASS_COLORS["SHAMAN"]:GenerateHexColor()
