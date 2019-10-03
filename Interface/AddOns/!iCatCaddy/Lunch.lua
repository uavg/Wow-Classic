local cvars = {
	profanityFilter = "0",
	scriptErrors = "1",
	buffDurations = "1",
	autoLootDefault = "1",
	lootUnderMouse = "1",
	autoSelfCast = "1",
--	cameraDistanceMaxFactor = "3.4",
--  cameraDistanceMaxZoomFactor = "2.6",
	screenshotQuality = "7",
	screenshotFormat = "'PNG'",
	cameraSmoothStyle = "0",
	chatStyle = "im",
	locale = "enCN",
	gxApi = "D3D11",
	gxMaximize = "0",
	autoDismountFlying = "0",
	alwaysCompareItems = "1",
	overrideArchive = "0",
	nameplateMaxDistance = "40",
	lossOfControl = "1",
	--gameTip = ""0"",

	showTimestamps = "none",
	UnitNameNPC = "1",
	guildMemberNotify = "1",
	autoOpenLootHistory = "0",
	autoQuestProgress = "1",
	hdPlayerModels = "0",
	UnitNameFriendlyPlayerName =  "1",
	UnitNameFriendlyPetName = "0",
	UnitNameFriendlyGuardianName = "0",
	UnitNameFriendlyTotemName = "0",
	UnitNameEnemyPlayerName =  "1",
	UnitNameEnemyPetName =  "1",
	UnitNameEnemyGuardianName =  "0",
	UnitNameEnemyTotemName = "1",
	alwaysShowActionBars = "0",
	autoquestwatch = "1",
	hideAdventureJournalAlerts = "0",
	taintLog = "1",
	showTutorials = "0",
	showNPETutorials = "0",
	nameplateShowSelf = "0",

	calendarShowWeeklyHolidays = "0",
	--TargetPriorityAllowAnyOnScreen = "0", 
	nameplateMaxScale = "1",
	nameplateGlobalScale = "1",
	nameplateShowFriendlyNPCs = "1",

	-- enable Floating Combat Text done to other players/mobs
	enableFloatingCombatText = "0",

	-- /run floatingCombatTextCombatHealing = "1", ReloadUI(",
	floatingCombatTextCombatDamageDirectionalScale = "0",
	floatingCombatTextCombatHealing = "1",
	floatingCombatTextCombatDamage = "1",
	floatingCombatTextFloatMode = "1",
	floatingCombatTextSpellMechanics = "0",
	floatingCombatTextSpellMechanicsOther = "0",
	
	breakUpLargeNumbers = "1", 

	-- Controls
	synchronizeConfig   = "1",
	synchronizeMacros   = "1",
	synchronizeSettings = "1",

	}

	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_LOGIN")
	f:SetScript("OnEvent", function()
		ConsoleExec("fixedfunction 1") -- disable "tunnel vision" glow effect (not a cvar)
		ChangeChatColor("CHANNEL4", 255/255, 255/255 ,150/255)

		-- Enable classcolor automatically on login and on each character without doing /configure each time
		ToggleChatColorNamesByClassGroup(true, "SAY")
		ToggleChatColorNamesByClassGroup(true, "EMOTE")
		ToggleChatColorNamesByClassGroup(true, "YELL")
		ToggleChatColorNamesByClassGroup(true, "GUILD")
		ToggleChatColorNamesByClassGroup(true, "OFFICER")
		ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
		ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
		ToggleChatColorNamesByClassGroup(true, "WHISPER")
		ToggleChatColorNamesByClassGroup(true, "PARTY")
		ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
		ToggleChatColorNamesByClassGroup(true, "RAID")
		ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
		ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
		ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT")
		ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT_LEADER")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL5")

	for cvar, value in pairs(cvars) do
		local current = tostring(GetCVar(cvar))
		if current ~= value then
			--print("SetCVar", cvar, value)
			SetCVar(cvar, value)
		end
	end
end)

hooksecurefunc("SetCVar", function(k, v)
	local o = cvars[k]
	if o and tostring(v) ~= o then
		print("|cffff9f7fSetCVar|r", k, o, "|cffff9f7f==>|r", v)
	end
end)
