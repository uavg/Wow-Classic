----------------------------------------------------------------------------------------
--	Auto cancel various buffs(by Unknown)
----------------------------------------------------------------------------------------
local function CheckUnitBuff(IsSpellId)
	for i = 1, 40, 1 do
		local name, icon, _, _, _, _, _, _, _, spellID = UnitBuff("player", i)
		if not name then break end
		if IsSpellId == spellID then
			return i
		end
	end
	return nil
end

local blacklist = {
	[58493] = true,		-- Mohawked!
	[44212] = true,		-- Jack-o'-Lanterned!
	[61716] = true,		-- Rabbit Costume
	[172010] = true,	-- Abomination Costume
	[24732] = true,		-- Bat Costume
	[172015] = true,	-- Geist Costume
	[24735] = true,		-- Ghost Costume
	[172008] = true,	-- Ghoul Costume
	[24712] = true,		-- Leper Gnome Costume
	[24710] = true,		-- Ninja Costume
	[24709] = true,		-- Pirate Costume
	[24723] = true,		-- Skeleton Costume
	[172003] = true,	-- Slime Costume
	[172020] = true,	-- Spider Costume
	[24740] = true,		-- Wisp Costume
	[61781] = true,		-- Turkey Feathers
	[61734] = true,		-- Noblegarden Bunny
}

local frame = CreateFrame("Frame")
frame:RegisterEvent("UNIT_AURA")
frame:SetScript("OnEvent", function(self, event, unit)
	if unit ~= "player" then return end

	if event == "UNIT_AURA" and not InCombatLockdown() then
		for buff, enabled in next, blacklist do
			if CheckUnitBuff(buff) and enabled then
				CancelUnitBuff(unit, CheckUnitBuff(buff))
				print("|cffffff00"..ACTION_SPELL_AURA_REMOVED.."|r "..(GetSpellLink(buff) or ("|cffffff00["..buff.."]|r")).."|cffffff00.|r")
			end
		end
	end
end)
