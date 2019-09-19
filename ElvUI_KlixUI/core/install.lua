local KUI, T, E, L, V, P, G = unpack(select(2, ...))

local FCF_SetLocked = FCF_SetLocked
local FCF_DockFrame, FCF_UnDockFrame = FCF_DockFrame, FCF_UnDockFrame
local FCF_SetWindowName = FCF_SetWindowName
local FCF_SavePositionAndDimensions = FCF_SavePositionAndDimensions
local FCF_GetChatWindowInfo = FCF_GetChatWindowInfo
local FCF_StopDragging = FCF_StopDragging
local FCF_SetChatWindowFontSize = FCF_SetChatWindowFontSize
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS
local ADDONS, LOOT, TRADE, TANK, HEALER = ADDONS, LOOT, TRADE, TANK, HEALER

local function SetupCVars()
	T.SetCVar("alwaysCompareItems", 1)
	T.SetCVar("autoQuestProgress", 1)
	T.SetCVar("guildMemberNotify", 1)
	T.SetCVar("statusTextDisplay", "BOTH")
	T.SetCVar("ShowClassColorInNameplate", 1)
	T.SetCVar("screenshotQuality", 10)
	T.SetCVar("chatMouseScroll", 1)
	T.SetCVar("chatStyle", "classic")
	T.SetCVar("WholeChatWindowClickable", 0)
	T.SetCVar("showTutorials", 0)
	T.SetCVar("UberTooltips", 1)
	T.SetCVar('alwaysShowActionBars', 1)
	T.SetCVar('lockActionBars', 1)
	T.SetCVar('SpamFilter', 0)
	T.SetCVar("whisperMode", "inline")
	T.SetCVar("violenceLevel", 5)
	T.SetCVar("blockTrades", 0)
	T.SetCVar("removeChatDelay", 1)
	T.SetCVar("TargetNearestUseNew", 1)
	T.SetCVar("cameraSmoothStyle", 0)
	T.SetCVar("cameraDistanceMaxZoomFactor", 4)
	T.SetCVar("screenEdgeFlash", 0)
	T.SetCVar("WorldTextScale", 0.75)
	--T.SetCVar("nameplateMaxDistance", "1e4") -- Thanks Ketho!

	
	if not KUI:IsDeveloper() or not (T.IsAddOnLoaded("!BugGrabber") and T.IsAddOnLoaded("BugSack")) then
		T.SetCVar("scriptErrors", 1)
	end
	
	InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:SetValue('SHIFT')
	InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:RefreshValue()
	
	PluginInstallStepComplete.message = KUI.Title..L["CVars Set"]
	PluginInstallStepComplete:Show()
end

local function SetupChat()
	FCF_ResetChatWindows() -- Monitor this
	FCF_SetLocked(ChatFrame1, 1)
	FCF_DockFrame(ChatFrame2)
	FCF_SetLocked(ChatFrame2, 1)

	FCF_OpenNewWindow(LOOT)
	FCF_UnDockFrame(ChatFrame3)
	FCF_SetLocked(ChatFrame3, 1)
	ChatFrame3:Show()

	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G[T.string_format("ChatFrame%s", i)]

		-- move general bottom left
		if i == 1 then
			frame:ClearAllPoints()
			frame:Point("BOTTOMLEFT", LeftChatToggleButton, "TOPLEFT", 1, 3)
		elseif i == 3 then
			frame:ClearAllPoints()
			frame:Point("BOTTOMLEFT", RightChatDataPanel, "TOPLEFT", 1, 3)
		end

		FCF_SavePositionAndDimensions(frame)
		FCF_StopDragging(frame)

		-- set default Elvui font size
		FCF_SetChatWindowFontSize(nil, frame, 13)

		-- rename windows general because moved to chat #3
		if i == 1 then
			FCF_SetWindowName(frame, GENERAL)
		elseif i == 2 then
			FCF_SetWindowName(frame, GUILD_EVENT_LOG)
		elseif i == 3 then
			FCF_SetWindowName(frame, LOOT.." / "..TRADE)
		end
	end

	-- keys taken from `ChatTypeGroup` but doesnt add: "OPENING", "TRADESKILLS", "PET_INFO", "COMBAT_MISC_INFO", "COMMUNITIES_CHANNEL", "PET_BATTLE_COMBAT_LOG", "PET_BATTLE_INFO", "TARGETICONS"
	local chatGroup = { "SYSTEM", "CHANNEL", "SAY", "EMOTE", "YELL", "WHISPER", "PARTY", "PARTY_LEADER", "RAID", "RAID_LEADER", "RAID_WARNING", "INSTANCE_CHAT", "INSTANCE_CHAT_LEADER", "GUILD", "OFFICER", "MONSTER_SAY", "MONSTER_YELL", "MONSTER_EMOTE", "MONSTER_WHISPER", "MONSTER_BOSS_EMOTE", "MONSTER_BOSS_WHISPER", "ERRORS", "AFK", "DND", "IGNORED", "BG_HORDE", "BG_ALLIANCE", "BG_NEUTRAL", "ACHIEVEMENT", "GUILD_ACHIEVEMENT", "BN_WHISPER", "BN_INLINE_TOAST_ALERT" }
	ChatFrame_RemoveAllMessageGroups(ChatFrame1)
	for _, v in ipairs(chatGroup) do
		ChatFrame_AddMessageGroup(ChatFrame1, v)
	end

	-- keys taken from `ChatTypeGroup` which weren't added above to ChatFrame1
	chatGroup = { "COMBAT_XP_GAIN", "COMBAT_HONOR_GAIN", "COMBAT_FACTION_CHANGE", "SKILL", "LOOT", "CURRENCY", "MONEY" }
	ChatFrame_RemoveAllMessageGroups(ChatFrame3)
	for _, v in ipairs(chatGroup) do
		ChatFrame_AddMessageGroup(ChatFrame3, v)
	end

	ChatFrame_AddChannel(ChatFrame1, GENERAL)
	ChatFrame_RemoveChannel(ChatFrame1, TRADE)
	ChatFrame_AddChannel(ChatFrame3, TRADE)

	-- set the chat groups names in class color to enabled for all chat groups which players names appear
	chatGroup = { "SAY", "EMOTE", "YELL", "WHISPER", "PARTY", "PARTY_LEADER", "RAID", "RAID_LEADER", "RAID_WARNING", "INSTANCE_CHAT", "INSTANCE_CHAT_LEADER", "GUILD", "OFFICER", "ACHIEVEMENT", "GUILD_ACHIEVEMENT" }
	for i = 1, MAX_WOW_CHAT_CHANNELS do
		T.table_insert(chatGroup, "CHANNEL"..i)
	end
	for _, v in ipairs(chatGroup) do
		ToggleChatColorNamesByClassGroup(true, v)
	end

	-- Adjust Chat Colors
	ChangeChatColor("CHANNEL1", 195/255, 230/255, 232/255) -- General
	ChangeChatColor("CHANNEL2", 232/255, 158/255, 121/255) -- Trade
	ChangeChatColor("CHANNEL3", 232/255, 228/255, 121/255) -- Local Defense

	if E.Chat then
		E.Chat:PositionChat(true)
		if E.db['RightChatPanelFaded'] then
			RightChatToggleButton:Click()
		end

		if E.db['LeftChatPanelFaded'] then
			LeftChatToggleButton:Click()
		end
	end
	
	E.db["chat"]["emotionIcons"] = true
	E.db["chat"]["lfgIcons"] = false
	E.db["chat"]["keywordSound"] = "Whisper Alert"
	E.db["chat"]["panelTabTransparency"] = true
	E.db["chat"]["chatHistory"] = false
	E.db["chat"]["separateSizes"] = false
	E.db["chat"]["panelWidth"] = 400
	E.db["chat"]["panelHeight"] = 163
	E.db["chat"]["panelWidthRight"] = 400
	E.db["chat"]["panelHeightRight"] = 163
	E.db["chat"]["panelColor"] = {r = 18/255, g = 18/255, b = 18/255, a = 0.60}
	E.db["chat"]["editBoxPosition"] = "BELOW_CHAT"
	E.db["chat"]["panelBackdrop"] = "SHOWBOTH"
	E.db["chat"]["panelTabBackdrop"] = false
	E.db["chat"]["panelTabTransparency"] = false
	E.db["chat"]["fadeUndockedTabs"] = true
	E.db["chat"]["fadeTabsNoBackdrop"] = true
	E.db["chat"]["chatHistory"] = true
	if T.IsAddOnLoaded("ElvUI_ChatTweaks") then
		E.db["chat"]["copyChatLines"] = false
		E.db["chat"]["timeStampFormat"] = "NONE"
	else
		E.db["chat"]["copyChatLines"] = true
		E.db["chat"]["timeStampFormat"] = "%H:%M"
	end
	E.db["chat"]["keywords"] = "%MYNAME%, ElvUI, KlixUI"
	E.db["chat"]["keywordSound"] = "None"
	E.db["chat"]["noAlertInCombat"] = true

	E.db["chat"]["font"] = "Expressway"
	E.db["chat"]["fontOutline"] = "OUTLINE"
	E.db["chat"]["tabFont"] = "Expressway"
	E.db["chat"]["tabFont"] = "Expressway"
	E.db["chat"]["tabFontOutline"] = "OUTLINE"
	E.db["chat"]["tabFontSize"] = 12
	E.db["chat"]["hideVoiceButtons"] = true
	
	KUI:SetMoverPosition("RightChatMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -10, 30)
	KUI:SetMoverPosition("LeftChatMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 10, 30)

	E:StaggeredUpdateAll(nil, true)
	
	PluginInstallStepComplete.message = KUI.Title..L["Chat Set"]
	PluginInstallStepComplete:Show()
end

function KUI:SetupLayout(layout)
	
	-- UI scales
	if E.screenheight == 1080 then E.db["general"]["UIScale"] = 0.711 end
	if E.screenheight == 1440 then E.db["general"]["UIScale"] = 0.533 end
	
	--[[----------------------------------
	--	PrivateDB - General
	--]]----------------------------------
	E.private["general"]["namefont"] = "Expressway"
	E.private["general"]["dmgfont"] = "Expressway"
	E.private["general"]["pixelPerfect"] = true
	E.private["general"]["chatBubbles"] = "backdrop"
	E.private["general"]["chatBubbleFont"] = "Expressway"
	E.private["general"]["chatBubbleFontSize"] = 12
	E.private["general"]["chatBubbleFontOutline"] = "OUTLINE"
	E.private["general"]["chatBubbleName"] = true
	E.private["general"]["classColorMentionsSpeech"] = true
	E.private["general"]["normTex"] = "Klix"
	E.private["general"]["glossTex"] = "Klix"
	if T.IsAddOnLoaded("XLoot") then
		E.private["general"]["loot"] = false
		E.private["general"]["lootRoll"] = false
	else
		E.private["general"]["loot"] = true
		E.private["general"]["lootRoll"] = true
	end

	--[[----------------------------------
	--	GlobalDB - General
	--]]----------------------------------
	E.global["general"]["autoScale"] = true
	E.global["general"]["animateConfig"] = false
	E.global["general"]["smallerWorldMap"] = false
	E.global["general"]["commandBarSetting"] = "DISABLED"

	--[[----------------------------------
	--	ProfileDB - General
	--]]----------------------------------
	E.db["general"]["font"] = "Expressway"
	E.db["general"]["fontSize"] = 11
	E.db["general"]["valuecolor"] = {r = KUI.r, g = KUI.g, b = KUI.b}
	E.db["general"]["bordercolor"] = {r = 0/255, g = 0/255, b = 0/255}
	E.db["general"]["backdropcolor"] = {r = 18/255, g = 18/255, b = 18/255}
	E.db["general"]["backdropfadecolor"] = {r = 18/255, g = 18/255, b = 18/255, a = 0.60}
	E.db["general"]["loginmessage"] = false
	E.db["general"]["afk"] = true
	E.db["general"]["stickyFrames"] = true
	E.db["general"]["autoRepair"] = "GUILD"
	E.db["general"]["autoRoll"] = false
	E.db["general"]["autoAcceptInvite"] = false
	E.db["general"]["vendorGrays"] = true
	E.db["general"]["vendorGraysDetails"] = true
	E.db["general"]["interruptAnnounce"] = "SAY"
	E.db["general"]["bottomPanel"] = false
	E.db["general"]["topPanel"] = false
	E.db["general"]["hideErrorFrame"] = true
	E.db["general"]["enhancedPvpMessages"] = true
	E.db["general"]["objectiveFrameHeight"] = 500
	E.db["general"]["bonusObjectivePosition"] = "LEFT"
	E.db["general"]["threat"]["enable"] = false
	E.db["general"]["numberPrefixStyle"] = "ENGLISH"
	E.db["general"]["talkingHeadFrameScale"] = 0.7
	E.db["general"]["talkingHeadFrameBackdrop"] = true
	E.db["general"]["decimalLenght"] = 1
	E.db["general"]["taintLog"] = false
	E.db["general"]["vehicleSeatIndicatorSize"] = 72
	if E.myclass == "SHAMAN" then
		E.db["general"]["totems"]["enable"] = true
	else
		E.db["general"]["totems"]["enable"] = false
	end
	E.db["general"]["totems"]["growthDirection"] = "VERTICAL"
	E.db["general"]["totems"]["size"] = 40
	E.db["general"]["totems"]["spacing"] = 3
	E.db["general"]["minimap"]["icons"]["mail"]["scale"] = 1
	E.db["general"]["minimap"]["icons"]["mail"]["xOffset"] = -8
	E.db["general"]["minimap"]["icons"]["mail"]["yOffset"] = -4
	E.db["general"]["minimap"]["resetZoom"]["enable"] = true
	E.db["general"]["minimap"]["resetZoom"]["time"] = 5
	E.db["general"]["minimap"]["size"] = 150
	E.db["general"]["minimap"]["locationText"] = "MOUSEOVER"
	E.db["general"]["minimap"]["locationFontSize"] = 12
	E.db["general"]["minimap"]["locationFontOutline"] = "OUTLINE"
	E.db["general"]["minimap"]["locationFont"] = "Expressway"
	E.db["general"]["altPowerBar"]["enable"] = true
	E.db["general"]["altPowerBar"]["font"] = "Expressway"
	E.db["general"]["altPowerBar"]["fontSize"] = 11
	E.db["general"]["altPowerBar"]["fontOutline"] = "OUTLINE"
	E.db["general"]["altPowerBar"]["statusBar"] = "Klix"
	E.db["general"]["altPowerBar"]["textFormat"] = "NAMECURMAXPERC"
	E.db["general"]["altPowerBar"]["statusBarColorGradient"] = true
	E.db["general"]["itemLevel"]["displayCharacterInfo"] = true
	E.db["general"]["itemLevel"]['itemLevelFont'] = "Expressway"
	E.db["general"]["itemLevel"]['enchantFont'] = "Expressway"

	if T.IsAddOnLoaded('XIV_Databar') then
		KUI:SetMoverPosition("MinimapMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -10, -25)
	else
		KUI:SetMoverPosition("MinimapMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -10, -10)
	end
	KUI:SetMoverPosition("TotemBarMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 432, 30)
	
	--[[----------------------------------
	--	ProfileDB - Minimap Buttons KlixUI
	--]]----------------------------------
	if KUI.IsDeveloper() then
		E.db["KlixUI"]["maps"]["minimap"]["buttons"]["iconSize"] = 16.5
		E.db["KlixUI"]["maps"]["minimap"]["buttons"]["buttonsPerRow"] = 9
	else
		E.db["KlixUI"]["maps"]["minimap"]["buttons"]["iconSize"] = 20
		E.db["KlixUI"]["maps"]["minimap"]["buttons"]["buttonsPerRow"] = 6
	end
	
	--[[----------------------------------
	--	ProfileDB - Auras
	--]]----------------------------------
	if T.IsAddOnLoaded("Masque") then
		E.private["auras"]["masque"]["buffs"] = true
		E.private["auras"]["masque"]["debuffs"] = true
	end
	E.db["auras"]["fadeThreshold"] = 10
	E.db["auras"]["font"] = "Expressway"
	E.db["auras"]["fontSize"] = 12
	E.db["auras"]["fontOutline"] = "OUTLINE"
	E.db["auras"]["buffs"]["horizontalSpacing"] = 2
	E.db["auras"]["buffs"]["size"] = 34
	E.db["auras"]["buffs"]["countFontsize"] = 12
	E.db["auras"]["buffs"]["durationFontSize"] = 12
	E.db["auras"]["buffs"]["wrapAfter"] = 12
	E.db["auras"]["buffs"]["maxWraps"] = 2
	E.db["auras"]["debuffs"]["horizontalSpacing"] = 2
	E.db["auras"]["debuffs"]["size"] = 34
	E.db["auras"]["debuffs"]["countFontsize"] = 16
	E.db["auras"]["debuffs"]["durationFontSize"] = 16
	E.db["auras"]["debuffs"]["wrapAfter"] = 12
	E.db["auras"]["debuffs"]["maxWraps"] = 2
	
	-- Cooldown Settings
	E.db["auras"]["cooldown"]["override"] = false
	E.db["auras"]["cooldown"]["fonts"]["enable"] = true
	E.db["auras"]["cooldown"]["fonts"]["font"] = "Expressway"
	E.db["auras"]["cooldown"]["fonts"]["fontOutline"] = "OUTLINE"
	E.db["auras"]["cooldown"]["fonts"]["fontSize"] = 12
	
	if T.IsAddOnLoaded('ElvUI_VisualAuraTimers') then
	E.db["auras"]["timeXOffset"] = 0
	E.db["auras"]["timeYOffset"] = -8
	E.db["auras"]["buffs"]["verticalSpacing"] = 24
	E.db["auras"]["debuffs"]["verticalSpacing"] = 24
	else
	E.db["auras"]["timeXOffset"] = 0
	E.db["auras"]["timeYOffset"] = -1
	E.db["auras"]["buffs"]["verticalSpacing"] = 16
	E.db["auras"]["debuffs"]["verticalSpacing"] = 16
	end
	
	if T.IsAddOnLoaded('XIV_Databar') then
		KUI:SetMoverPosition("BuffsMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -164, -25)
		KUI:SetMoverPosition("DebuffsMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -164, -143)
	else
		KUI:SetMoverPosition("BuffsMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -164, -10)
		KUI:SetMoverPosition("DebuffsMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -164, -128)
	end
	
	--[[----------------------------------
	--	ProfileDB - Bags
	--]]----------------------------------
	if T.IsAddOnLoaded("AdiBags")
	 or T.IsAddOnLoaded("ArkInventory")
	 or T.IsAddOnLoaded("Baggins")
	 or T.IsAddOnLoaded("Bagnon")
	 or T.IsAddOnLoaded("BaudBag")
	 or T.IsAddOnLoaded("cargBags_Nivaya")
	 or T.IsAddOnLoaded("Combuctor")
	 or T.IsAddOnLoaded("DJBags")
	 or T.IsAddOnLoaded("ElvUI_CategoryBags")
	 or T.IsAddOnLoaded("Inventorian")
	 or T.IsAddOnLoaded("LiteBag")
	 or T.IsAddOnLoaded("OneBag3") then
		E.private["bags"]["enable"] = false
	else
		E.private["bags"]["enable"] = true
	end
	E.db["bags"]["bagSize"] = 28
	E.db["bags"]["bagWidth"] = 400
	E.db["bags"]["bankSize"] = 28
	E.db["bags"]["bankWidth"] = 400
	E.db["bags"]["bagBar"]["enable"] = false
	E.db["bags"]["alignToChat"] = false
	E.db["bags"]["moneyFormat"] = "CONDENSED"
	E.db["bags"]["moneyCoins"] = false
	E.db["bags"]["junkIcon"] = true
	E.db["bags"]["scrapIcon"] = true
	E.db["bags"]["sortInverted"] = true
	E.db["bags"]["clearSearchOnClose"] = true
	E.db["bags"]["itemLevelFont"] = "Expressway"
	E.db["bags"]["itemLevelFontSize"] = 12
	E.db["bags"]["itemLevelFontOutline"] = "OUTLINE"
	E.db["bags"]["countFont"] = "Expressway"
	E.db["bags"]["countFontSize"] = 12
	E.db["bags"]["countFontOutline"] = "OUTLINE"
	E.db["bags"]["itemLevelThreshold"] = 100
	E.db["bags"]["transparent"] = true
	if KUI:IsDeveloper() then 
		E.db["bags"]["split"]["player"] = false
		E.db["bags"]["split"]["bank"] = false
	else
		E.db["bags"]["split"]["player"] = true
		E.db["bags"]["split"]["bank"] = true
	end
	E.db["bags"]["split"]["bag1"] = true
	E.db["bags"]["split"]["bag2"] = true
	E.db["bags"]["split"]["bag3"] = true
	E.db["bags"]["split"]["bag4"] = true
	E.db["bags"]["split"]["bag5"] = true
	E.db["bags"]["split"]["bag6"] = true
	E.db["bags"]["split"]["bag7"] = true
	E.db["bags"]["split"]["bag8"] = true
	E.db["bags"]["split"]["bag9"] = true
	E.db["bags"]["split"]["bag10"] = true
	E.db["bags"]["split"]["bag11"] = true
	E.db["bags"]["vendorGrays"]["details"] = true
		
	-- Cooldown Settings
	E.db["bags"]["cooldown"]["override"] = false
	E.db["bags"]["cooldown"]["fonts"]["enable"] = true
	E.db["bags"]["cooldown"]["fonts"]["font"] = "Expressway"
	E.db["bags"]["cooldown"]["fonts"]["fontOutline"] = "OUTLINE"
	E.db["bags"]["cooldown"]["fonts"]["fontSize"] = 14
	
	KUI:SetMoverPosition("ElvUIBagMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -10, 30)
	KUI:SetMoverPosition("ElvUIBankMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 10, 30)
	
	--[[----------------------------------
	--	ProfileDB - DataBars
	--]]----------------------------------
	-- ExperienceBar
	E.db["databars"]["experience"]["enable"] = true
	E.db["databars"]["experience"]["mouseover"] = false
	E.db["databars"]["experience"]["width"] = 371
	E.db["databars"]["experience"]["height"] = 10
	E.db["databars"]["experience"]["font"] = "Expressway"
	E.db["databars"]["experience"]["fontOutline"] = "OUTLINE"
	E.db["databars"]["experience"]["textFormat"] = "NONE"
	E.db["databars"]["experience"]["textSize"] = 12
	E.db["databars"]["experience"]["orientation"] = "HORIZONTAL"
	E.db["databars"]["experience"]["hideAtMaxLevel"] = true
	E.db["databars"]["experience"]["hideInVehicle"] = false
	E.db["databars"]["experience"]["hideInCombat"] = false
	E.db["databars"]["experience"]["reverseFill"] = false
	-- ReputationBar 
	E.db["databars"]["reputation"]["enable"] = true
	E.db["databars"]["reputation"]["mouseover"] = false
	E.db["databars"]["reputation"]["width"] = 371
	E.db["databars"]["reputation"]["height"] = 10
	E.db["databars"]["reputation"]["font"] = "Expressway"
	E.db["databars"]["reputation"]["fontOutline"] = "OUTLINE"
	E.db["databars"]["reputation"]["textFormat"] = "NONE"
	E.db["databars"]["reputation"]["textSize"] = 12
	E.db["databars"]["reputation"]["orientation"] = "HORIZONTAL"
	E.db["databars"]["reputation"]["hideInVehicle"] = false
	E.db["databars"]["reputation"]["hideInCombat"] = false
	E.db["databars"]["reputation"]["reverseFill"] = false
	
	KUI:SetMoverPosition("ExperienceBarMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 62)
	KUI:SetMoverPosition("ReputationBarMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 72)
	
	--[[----------------------------------
	--	ProfileDB - NamePlate
	--]]----------------------------------
	-- General
	E.db["nameplates"]["threat"]["useThreatColor"] = false
	E.db["nameplates"]["clampToScreen"] = true
	E.db["nameplates"]["colors"]["glowColor"] = {r = 249/255, g = 96/255, b = 217/255, a = 1}
	E.db["nameplates"]["font"] = "Expressway"
	E.db["nameplates"]["fontSize"] = 12
	E.db["nameplates"]["stackFont"] = "Expressway"
	E.db["nameplates"]["stackFontSize"] = 9
	E.db["nameplates"]["statusbar"] = "Klix"
	E.db["nameplates"]["smoothbars"] = true

	-- Player
	E.db["nameplates"]["units"]["PLAYER"]["enable"] = false
	E.db["nameplates"]["units"]["PLAYER"]["health"]["text"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["PLAYER"]["health"]["text"]["fontSize"] = 10
	E.db["nameplates"]["units"]["PLAYER"]["health"]["text"]["format"] = "[perhp<%]"
	E.db["nameplates"]["units"]["PLAYER"]["name"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["PLAYER"]["name"]["fontSize"] = 11
	E.db["nameplates"]["units"]["PLAYER"]["name"]["format"] = '[name:long]'
	E.db["nameplates"]["units"]["PLAYER"]["power"]["text"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["PLAYER"]["power"]["text"]["fontSize"] = 10
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["size"] = 20
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["yOffset"] = 2
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["fontSize"] = 11
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["countFont"] = 'Expressway'
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["countFontOutline"] = 'OUTLINE'
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["countFontSize"] = 9
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["durationPosition"] = 'CENTER'
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["numAuras"] = 8
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["size"] = 24
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["fontSize"] = 11
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["countFont"] = 'Expressway'
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["countFontOutline"] = 'OUTLINE'
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["countFontSize"] = 9
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["durationPosition"] = 'CENTER'
	E.db["nameplates"]["units"]["PLAYER"]["level"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["PLAYER"]["level"]["fontSize"] = 11
	E.db["nameplates"]["units"]["PLAYER"]["castbar"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["PLAYER"]["castbar"]["fontSize"] = 10
	E.db["nameplates"]["units"]["PLAYER"]["castbar"]["sourceInterrupt"] = true
	E.db["nameplates"]["units"]["PLAYER"]["castbar"]["sourceInterruptClassColor"] = true
	E.db["nameplates"]["units"]["PLAYER"]["castbar"]["iconPosition"] = 'LEFT'
	E.db["nameplates"]["units"]["PLAYER"]["floatingCombatFeedback"] = false

	-- Friendly Player
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["health"]["text"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["health"]["text"]["fontSize"] = 10
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["health"]["text"]["format"] = "[perhp<%]"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["name"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["name"]["fontSize"] = 11
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["name"]["format"] = '[name:long]'
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["power"]["text"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["power"]["text"]["fontSize"] = 10
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["size"] = 20
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["yOffset"] = 2
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["fontSize"] = 11
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["countFont"] = 'Expressway'
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["countFontOutline"] = 'OUTLINE'
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["countFontSize"] = 9
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["durationPosition"] = 'CENTER'
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["numAuras"] = 8
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["size"] = 24
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["fontSize"] = 11
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["countFont"] = 'Expressway'
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["countFontOutline"] = 'OUTLINE'
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["countFontSize"] = 9
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["durationPosition"] = 'CENTER'
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["level"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["level"]["fontSize"] = 11
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["castbar"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["castbar"]["fontSize"] = 10
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["castbar"]["sourceInterrupt"] = true
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["castbar"]["sourceInterruptClassColor"] = true
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["castbar"]["iconPosition"] = 'LEFT'
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["floatingCombatFeedback"] = false

	-- Enemy Player
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["health"]["text"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["health"]["text"]["fontSize"] = 10
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["health"]["text"]["format"] = "[perhp<%]"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["name"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["name"]["fontSize"] = 11
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["name"]["format"] = '[name:long]'
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["power"]["text"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["power"]["text"]["fontSize"] = 10
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["size"] = 20
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["yOffset"] = 2
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["fontSize"] = 11
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["countFont"] = 'Expressway'
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["countFontOutline"] = 'OUTLINE'
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["countFontSize"] = 9
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["durationPosition"] = 'CENTER'
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["numAuras"] = 8
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["size"] = 24
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["fontSize"] = 11
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["countFont"] = 'Expressway'
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["countFontOutline"] = 'OUTLINE'
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["countFontSize"] = 9
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["durationPosition"] = 'CENTER'
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["level"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["level"]["fontSize"] = 11
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["fontSize"] = 10
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["sourceInterrupt"] = true
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["sourceInterruptClassColor"] = true
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["iconPosition"] = 'LEFT'
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["floatingCombatFeedback"] = false

	-- Friendly NPC
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["health"]["text"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["health"]["text"]["fontSize"] = 10
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["health"]["text"]["format"] = "[perhp<%]"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["name"]["format"] = '[name:long]'
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["name"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["name"]["fontSize"] = 11
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["power"]["text"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["power"]["text"]["fontSize"] = 10
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["size"] = 20
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["yOffset"] = 2
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["fontSize"] = 11
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["countFont"] = 'Expressway'
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["countFontOutline"] = 'OUTLINE'
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["countFontSize"] = 9
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["durationPosition"] = 'CENTER'
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["numAuras"] = 8
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["size"] = 24
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["fontSize"] = 11
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["countFont"] = 'Expressway'
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["countFontOutline"] = 'OUTLINE'
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["countFontSize"] = 9
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["durationPosition"] = 'CENTER'
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["level"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["level"]["fontSize"] = 11
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["level"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["level"]["fontSize"] = 11
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["fontSize"] = 10
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["sourceInterrupt"] = true
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["sourceInterruptClassColor"] = true
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["iconPosition"] = 'LEFT'
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["questIcon"]["enable"] = true
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["floatingCombatFeedback"] = false

	-- Enemy NPC
	E.db["nameplates"]["units"]["ENEMY_NPC"]["health"]["text"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["health"]["text"]["fontSize"] = 10
	E.db["nameplates"]["units"]["ENEMY_NPC"]["name"]["format"] = '[name:long]'
	E.db["nameplates"]["units"]["ENEMY_NPC"]["name"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["name"]["fontSize"] = 11
	E.db["nameplates"]["units"]["ENEMY_NPC"]["power"]["text"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["power"]["text"]["fontSize"] = 10
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["size"] = 20
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["yOffset"] = 13
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["fontSize"] = 11
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["countFont"] = 'Expressway'
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["countFontOutline"] = 'OUTLINE'
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["countFontSize"] = 9
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["durationPosition"] = 'CENTER'
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["filters"]["priority"] = 'Blacklist,RaidBuffsElvUI,PlayerBuffs,TurtleBuffs,CastByUnit'
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["numAuras"] = 8
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["size"] = 24
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["yOffset"] = 33
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["fontSize"] = 11
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["countFont"] = 'Expressway'
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["countFontOutline"] = 'OUTLINE'
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["countFontSize"] = 9
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["durationPosition"] = 'CENTER'
	E.db["nameplates"]["units"]["ENEMY_NPC"]["level"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["level"]["fontSize"] = 11
	E.db["nameplates"]["units"]["ENEMY_NPC"]["level"]["format"] = '[difficultycolor][level]'
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["fontSize"] = 10
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["sourceInterrupt"] = true
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["sourceInterruptClassColor"] = true
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["iconPosition"] = 'LEFT'
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["iconSize"] = 23
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["iconOffsetX"] = -2
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["iconOffsetY"] = -1
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["timeToHold"] = 0.8
	E.db["nameplates"]["units"]["ENEMY_NPC"]["eliteIcon"]["enable"] = true
	E.db["nameplates"]["units"]["ENEMY_NPC"]["eliteIcon"]["position"] = 'RIGHT'
	E.db["nameplates"]["units"]["ENEMY_NPC"]["eliteIcon"]["xOffset"] = -10
	E.db["nameplates"]["units"]["ENEMY_NPC"]["questIcon"]["enable"] = true
	E.db["nameplates"]["units"]["ENEMY_NPC"]["questIcon"]["position"] = 'RIGHT'
	E.db["nameplates"]["units"]["ENEMY_NPC"]["questIcon"]["xOffset"] = 8
	E.db["nameplates"]["units"]["ENEMY_NPC"]["floatingCombatFeedback"] = false
	
	-- TARGETED
	E.db["nameplates"]["units"]["TARGET"]["scale"] = 1.08 -- 108% scale
	E.db["nameplates"]["units"]["TARGET"]["classpower"]["enable"] = true
	E.db["nameplates"]["units"]["TARGET"]["classpower"]["width"] = 144
	E.db["nameplates"]["units"]["TARGET"]["classpower"]["yOffset"] = 23

	--[[----------------------------------
	--	ProfileDB - Tooltip
	--]]----------------------------------
	E.db["tooltip"]["targetInfo"] = true
	E.db["tooltip"]["playerTitles"] = true
	E.db["tooltip"]["guildRanks"] = true
	E.db["tooltip"]["inspectInfo"] = true
	E.db["tooltip"]["spellID"] = true
	E.db["tooltip"]["font"] = "Expressway"
	E.db["tooltip"]["fontOutline"] = "OUTLINE"
	E.db["tooltip"]["itemCount"] = "NONE"
	E.db["tooltip"]["headerFontSize"] = 11
	E.db["tooltip"]["textFontSize"] = 11
	E.db["tooltip"]["smallTextFontSize"] = 11
	E.db["tooltip"]["healthBar"]["text"] = false
	E.db["tooltip"]["healthBar"]["height"] = 0
	E.db["tooltip"]["healthBar"]["font"] = "Expressway"
	E.db["tooltip"]["healthBar"]["fontSize"] = 11
	E.db["tooltip"]["visibility"]["combat"] = true
	
	if T.IsAddOnLoaded("ClassicThreatMeter") then
		KUI:SetMoverPosition("TooltipMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -9, 213)
	else
		KUI:SetMoverPosition("TooltipMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -9, 156)
	end
	
	--[[----------------------------------
	--	Movers - Layout
	--]]----------------------------------
	if T.IsAddOnLoaded('XIV_Databar') then
		KUI:SetMoverPosition("GMMover", "TOPLEFT", E.UIParent, "TOPLEFT", 10, -25)
		KUI:SetMoverPosition("VehicleSeatMover", "TOPLEFT", E.UIParent, "TOPLEFT", 10, -25)
	else
		KUI:SetMoverPosition("GMMover", "TOPLEFT", E.UIParent, "TOPLEFT", 10, -10)
		KUI:SetMoverPosition("VehicleSeatMover", "TOPLEFT", E.UIParent, "TOPLEFT", 10, -10)
	end
	KUI:SetMoverPosition("AltPowerBarMover", "TOP", E.UIParent, "TOP", 0, -115)
	KUI:SetMoverPosition("LootFrameMover", "TOP", E.UIParent, "TOP", 0, -275)
	KUI:SetMoverPosition("AlertFrameMover", "TOP", E.UIParent, "TOP", 0, -250)
	KUI:SetMoverPosition("LossControlMover", "TOP", E.UIParent, "TOP", 0, -491)
	KUI:SetMoverPosition("ObjectiveFrameMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -62, -260)
	KUI:SetMoverPosition("TalkingHeadFrameMover", "TOP", E.UIParent, "TOP", 0, -155)
	KUI:SetMoverPosition("SocialMenuMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 10, 194)
	KUI:SetMoverPosition("CM_MOVER", "BOTTOM", E.UIParent, "BOTTOM", 0, 150)
	KUI:SetMoverPosition("TopCenterContainerMover", "TOP", E.UIParent, "TOP", 0, -10)

	E:StaggeredUpdateAll(nil, true)

	PluginInstallStepComplete.message = KUI.Title..L["Layout Set"]
	PluginInstallStepComplete:Show()
end

function KUI:SetupUnitframes(layout)
	--[[----------------------------------
	--	UnitFrames - General
	--]]----------------------------------
	E.db["unitframe"]["font"] = "Expressway"
	E.db["unitframe"]["fontSize"] = 11
	E.db["unitframe"]["fontOutline"] = "OUTLINE"
	E.db["unitframe"]["smoothbars"] = true
	E.db["unitframe"]["statusbar"] = "Klix"
	E.db["unitframe"]["smartRaidFilter"] = false
	E.db["unitframe"]["OORAlpha"] = 0.35
	
	-- Colors
	E.db["unitframe"]["colors"]["transparentAurabars"] = true
	E.db["unitframe"]["colors"]["transparentPower"] = false
	E.db["unitframe"]["colors"]["transparentCastbar"] = false
	E.db["unitframe"]["colors"]["castClassColor"] = false
	E.db["unitframe"]["colors"]["castReactionColor"] = false
	E.db["unitframe"]["colors"]["powerclass"] = false
	E.db["unitframe"]["colors"]["transparentHealth"] = false
	E.db["unitframe"]["colors"]["healthclass"] = true
	E.db["unitframe"]["colors"]["forcehealthreaction"] = false
	E.db["unitframe"]["colors"]["colorhealthbyvalue"] = false
	E.db["unitframe"]["colors"]["customhealthbackdrop"] = true
	E.db["unitframe"]["colors"]["useDeadBackdrop"] = false
	E.db["unitframe"]["colors"]["classbackdrop"] = false
	E.db["unitframe"]["colors"]["health"] = { r = 107/255, g = 255/255, b = 103/255 }
	E.db["unitframe"]["colors"]["health_backdrop"] = { r = 18/255, g = 18/255, b = 18/255 }
	E.db["unitframe"]["colors"]["tapped"] = { r = 195/255, g = 202/255, b = 217/255 }
	E.db["unitframe"]["colors"]["disconnected"] = { r = 195/255, g = 202/255, b = 217/255 }
	E.db["unitframe"]["colors"]["power"]["MANA"] = { r = 79/255, g = 115/255, b = 161/255 }
	E.db["unitframe"]["colors"]["power"]["RAGE"] = { r = 199/255, g = 64/255, b = 64/255 }
	E.db["unitframe"]["colors"]["power"]["FOCUS"] = { r = 181/255, g = 110/255, b = 69/255 }
	E.db["unitframe"]["colors"]["power"]["ENERGY"] = { r = 166/255, g = 161/255, b = 89/255 }
	E.db["unitframe"]["colors"]["power"]["RUNIC_POWER"] = { r = 0/255, g = 209/255, b = 255/255 }
	E.db["unitframe"]["colors"]["power"]["FURY"] = { r = 227/255, g = 126/255, b = 39/255 }
	E.db["unitframe"]["colors"]["power"]["PAIN"] = { r = 225/255, g = 225/255, b = 225/255 }
	E.db["unitframe"]["colors"]["reaction"]["BAD"] = { r = 239/225, g = 31/225, b = 44/225 }
	E.db["unitframe"]["colors"]["reaction"]["NEUTRAL"] = { r = 255/255, g = 249/255, b = 94/255 }
	E.db["unitframe"]["colors"]["reaction"]["GOOD"] = { r = 107/255, g = 255/255, b = 103/255 }
	E.db["unitframe"]["colors"]["castColor"] = { r = 204/255, g = 204/255, b = 204/255 }
	E.db["unitframe"]["colors"]["castNoInterrupt"] = { r = 239/225, g = 31/225, b = 44/225 }
	E.db["unitframe"]["colors"]["classResources"]["bgColor"] = { r = 18/255, g = 18/255, b = 18/255}
	E.db["unitframe"]["colors"]["classResources"]["MONK[1]"] = { r = 0/255, g = 255/255, b = 150/255 }
	E.db["unitframe"]["colors"]["classResources"]["MONK[2]"] = { r = 0/255, g = 255/255, b = 150/255 }
	E.db["unitframe"]["colors"]["classResources"]["MONK[3]"] = { r = 0/255, g = 255/255, b = 150/255 }
	E.db["unitframe"]["colors"]["classResources"]["MONK[4]"] = { r = 0/255, g = 255/255, b = 150/255 }
	E.db["unitframe"]["colors"]["classResources"]["MONK[5]"] = { r = 0/255, g = 255/255, b = 150/255 }
	E.db["unitframe"]["colors"]["classResources"]["MONK[6]"] = { r = 0/255, g = 255/255, b = 150/255 }
	
	-- Frame Glow
	E.db["unitframe"]["colors"]["frameGlow"]["targetGlow"]["enable"] = false
	E.db["unitframe"]["colors"]["frameGlow"]["mainGlow"]["enable"] = false
	E.db["unitframe"]["colors"]["frameGlow"]["mainGlow"]["class"] = true
	E.db["unitframe"]["colors"]["frameGlow"]["mouseoverGlow"]["color"]["a"] = 0.5
	E.db["unitframe"]["colors"]["frameGlow"]["mouseoverGlow"]["color"]["b"] = 0
	E.db["unitframe"]["colors"]["frameGlow"]["mouseoverGlow"]["color"]["g"] = 0
	E.db["unitframe"]["colors"]["frameGlow"]["mouseoverGlow"]["color"]["r"] = 0
	E.db["unitframe"]["colors"]["frameGlow"]["mouseoverGlow"]["class"] = true
	E.db["unitframe"]["colors"]["frameGlow"]["mouseoverGlow"]["texture"] = "Klix1"

	-- Cooldown Settings
	E.db["unitframe"]["cooldown"]["override"] = false
	E.db["unitframe"]["cooldown"]["fonts"]["enable"] = true
	E.db["unitframe"]["cooldown"]["fonts"]["font"] = "Expressway"
	E.db["unitframe"]["cooldown"]["fonts"]["fontOutline"] = "OUTLINE"
	E.db["unitframe"]["cooldown"]["fonts"]["fontSize"] = 10
	
	-- Player
	E.db["unitframe"]["units"]["player"]["width"] = 250
	E.db["unitframe"]["units"]["player"]["height"] = 33
	E.db["unitframe"]["units"]["player"]["orientation"] = "LEFT"
	E.db["unitframe"]["units"]["player"]["threatStyle"] = "NONE"
	E.db["unitframe"]["units"]["player"]["healPrediction"]["enable"] = true
	E.db["unitframe"]["units"]["player"]["healPrediction"]["showOverAbsorbs"] = true
	E.db["unitframe"]["units"]["player"]["healPrediction"]["showAbsorbAmount"] = false
	E.db["unitframe"]["units"]["player"]["health"]["text_format"] = ""
	E.db["unitframe"]["units"]["player"]["health"]["attachTextTo"] = "HEALTH"
	E.db["unitframe"]["units"]["player"]["health"]["position"] = "LEFT"
	E.db["unitframe"]["units"]["player"]["health"]["xOffset"] = 0
	E.db["unitframe"]["units"]["player"]["health"]["yOffset"] = 0
	E.db["unitframe"]["units"]["player"]["name"]["text_format"] = ""
	E.db["unitframe"]["units"]["player"]["portrait"]["enable"] = false
	E.db["unitframe"]["units"]["player"]["power"]["enable"] = true
	E.db["unitframe"]["units"]["player"]["power"]["text_format"] = ""
	E.db["unitframe"]["units"]["player"]["power"]["position"] = "CENTER"
	E.db["unitframe"]["units"]["player"]["power"]["attachTextTo"] = "Power"
	E.db["unitframe"]["units"]["player"]["power"]["height"] = 33
	E.db["unitframe"]["units"]["player"]["power"]["xOffset"] = 0
	E.db["unitframe"]["units"]["player"]["power"]["yOffset"] = 0
	E.db["unitframe"]["units"]["player"]["power"]["detachFromFrame"] = true
	if T.IsAddOnLoaded("Masque") and T.IsAddOnLoaded("Masque_KlixUI") then
		E.db["unitframe"]["units"]["player"]["power"]["detachedWidth"] = 246
	else
		E.db["unitframe"]["units"]["player"]["power"]["detachedWidth"] = 247
	end
	E.db["unitframe"]["units"]["player"]["power"]["druidMana"] = false
	E.db["unitframe"]["units"]["player"]["power"]["strataAndLevel"]["useCustomStrata"] = true
	E.db["unitframe"]["units"]["player"]["buffs"]["enable"] = false
	E.db["unitframe"]["units"]["player"]["buffs"]["perrow"] = 8
	E.db["unitframe"]["units"]["player"]["buffs"]["numrows"] = 1
	E.db["unitframe"]["units"]["player"]["buffs"]["attachTo"] = "FRAME"
	E.db["unitframe"]["units"]["player"]["buffs"]["anchorPoint"] = "TOPLEFT"
	E.db["unitframe"]["units"]["player"]["buffs"]["sizeOverride"] = 24
	E.db["unitframe"]["units"]["player"]["buffs"]["xOffset"] = 0
	E.db["unitframe"]["units"]["player"]["buffs"]["yOffset"] = 1
	E.db["unitframe"]["units"]["player"]["buffs"]["countFont"] = "Expressway"
	E.db["unitframe"]["units"]["player"]["buffs"]["countFontSize"] = 9
	E.db["unitframe"]["units"]["player"]["debuffs"]["enable"] = false
	E.db["unitframe"]["units"]["player"]["debuffs"]["perrow"] = 8
	E.db["unitframe"]["units"]["player"]["debuffs"]["numrows"] = 1
	E.db["unitframe"]["units"]["player"]["debuffs"]["attachTo"] = "FRAME"
	E.db["unitframe"]["units"]["player"]["debuffs"]["anchorPoint"] = "TOPLEFT"
	E.db["unitframe"]["units"]["player"]["debuffs"]["countFont"] = "Expressway"
	E.db["unitframe"]["units"]["player"]["debuffs"]["countFontSize"] = 9
	E.db["unitframe"]["units"]["player"]["debuffs"]["sizeOverride"] = 24
	E.db["unitframe"]["units"]["player"]["debuffs"]["xOffset"] = 0
	E.db["unitframe"]["units"]["player"]["debuffs"]["yOffset"] = -28
	E.db["unitframe"]["units"]["player"]["smartAuraPosition"] = "DISABLED"
	E.db["unitframe"]["units"]["player"]["aurabar"]["enable"] = false
	E.db["unitframe"]["units"]["player"]["aurabar"]["attachTo"] = "FRAME"
	E.db["unitframe"]["units"]["player"]["aurabar"]["anchorPoint"] = "ABOVE"
	E.db["unitframe"]["units"]["player"]["aurabar"]["height"] = 20
	E.db["unitframe"]["units"]["player"]["aurabar"]["yOffset"] = 2
	E.db["unitframe"]["units"]["player"]["castbar"]["enable"] = true
	E.db["unitframe"]["units"]["player"]["castbar"]["width"] = 250
	E.db["unitframe"]["units"]["player"]["castbar"]["height"] = 16
	E.db["unitframe"]["units"]["player"]["castbar"]["icon"] = false
	E.db["unitframe"]["units"]["player"]["castbar"]["latency"] = true
	E.db["unitframe"]["units"]["player"]["castbar"]["format"] = "REMAINING"
	E.db["unitframe"]["units"]["player"]["castbar"]["ticks"] = true
	E.db["unitframe"]["units"]["player"]["castbar"]["spark"] = false
	E.db["unitframe"]["units"]["player"]["castbar"]["strataAndLevel"]["frameStrata"] = "MEDIUM"
	E.db["unitframe"]["units"]["player"]["classbar"]["enable"] = true
	E.db["unitframe"]["units"]["player"]["classbar"]["detachFromFrame"] = true
	if T.IsAddOnLoaded("Masque") and T.IsAddOnLoaded("Masque_KlixUI") then
		E.db["unitframe"]["units"]["player"]["classbar"]["detachedWidth"] = 246
	else
		E.db["unitframe"]["units"]["player"]["classbar"]["detachedWidth"] = 247
	end
	E.db["unitframe"]["units"]["player"]["classbar"]["height"] = 10
	E.db["unitframe"]["units"]["player"]["classbar"]["autoHide"] = false
	E.db["unitframe"]["units"]["player"]["classbar"]["fill"] = "filled"
	E.db["unitframe"]["units"]["player"]["classbar"]["additionalPowerText"] = false
	E.db["unitframe"]["units"]["player"]["RestIcon"]["enable"] = true
	E.db["unitframe"]["units"]["player"]["RestIcon"]["size"] = 20
	E.db["unitframe"]["units"]["player"]["RestIcon"]["xOffset"] = -2
	E.db["unitframe"]["units"]["player"]["RestIcon"]["yOffset"] = 2
	E.db["unitframe"]["units"]["player"]["RestIcon"]["anchorPoint"] = "TOPLEFT"
	E.db["unitframe"]["units"]["player"]["RestIcon"]["texture"] = "RESTING1"
	E.db["unitframe"]["units"]["player"]["CombatIcon"]["enable"] = true
	E.db["unitframe"]["units"]["player"]["CombatIcon"]["size"] = 16
	E.db["unitframe"]["units"]["player"]["CombatIcon"]["xOffset"] = -1
	E.db["unitframe"]["units"]["player"]["CombatIcon"]["yOffset"] = 1
	E.db["unitframe"]["units"]["player"]["CombatIcon"]["anchorPoint"] = "TOPLEFT"
	E.db["unitframe"]["units"]["player"]["CombatIcon"]["texture"] = "COMBAT"
	E.db["unitframe"]["units"]["player"]["CombatIcon"]["customTexture"] = ""
	E.db["unitframe"]["units"]["player"]["raidicon"]["enable"] = true
	E.db["unitframe"]["units"]["player"]["raidicon"]["position"] = "TOP"
	E.db["unitframe"]["units"]["player"]["raidicon"]["size"] = 18
	E.db["unitframe"]["units"]["player"]["raidicon"]["xOffset"] = 0
	E.db["unitframe"]["units"]["player"]["raidicon"]["yOffset"] = 8
	E.db["unitframe"]["units"]["player"]["infoPanel"]["enable"] = false
	E.db["unitframe"]["units"]["player"]["pvpIcon"]["enable"] = false
	E.db["unitframe"]["units"]["player"]["pvpIcon"]["anchorPoint"] = "TOPRIGHT"
	E.db["unitframe"]["units"]["player"]["pvpIcon"]["xOffset"] = 4
	E.db["unitframe"]["units"]["player"]["pvpIcon"]["yOffset"] = 4
	E.db["unitframe"]["units"]["player"]["pvpIcon"]["scale"] = 0.4
	if not E.db["unitframe"]["units"]["player"]["customTexts"] then E.db["unitframe"]["units"]["player"]["customTexts"] = {} end
	-- Delete old customTexts/ Create empty table
	E.db["unitframe"]["units"]["player"]["customTexts"] = {}
	-- Create own customText
	E.db["unitframe"]["units"]["player"]["customTexts"]["HealthText"] = {
		["font"] = "Expressway",
		["justifyH"] = "LEFT",
		["fontOutline"] = "OUTLINE",
		["text_format"] = "[health:current-percent-kui]",
		["size"] = 12,
		["attachTextTo"] = "Frame",
		["xOffset"] = 4,
		["yOffset"] = 0,
	}
	E.db["unitframe"]["units"]["player"]["customTexts"]["PowerText"] = {
		["font"] = "Expressway",
		["fontOutline"] = "OUTLINE",
		["size"] = 16,
		["justifyH"] = "CENTER",
		["text_format"] = "[power:current-kui]",
		["attachTextTo"] = "Power",
		["xOffset"] = 0,
		["yOffset"] = 0,
	}
	
	-- Target
	E.db["unitframe"]["units"]["target"]["width"] = 250
	E.db["unitframe"]["units"]["target"]["height"] = 33
	E.db["unitframe"]["units"]["target"]["rangeCheck"] = false
	E.db["unitframe"]["units"]["target"]["orientation"] = "RIGHT"
	E.db["unitframe"]["units"]["target"]["threatStyle"] = "NONE"
	E.db["unitframe"]["units"]["target"]["healPrediction"]["enable"] = true
	E.db["unitframe"]["units"]["target"]["healPrediction"]["showOverAbsorbs"] = true
	E.db["unitframe"]["units"]["target"]["healPrediction"]["showAbsorbAmount"] = false
	E.db["unitframe"]["units"]["target"]["health"]["text_format"] = ""
	E.db["unitframe"]["units"]["target"]["health"]["attachTextTo"] = "HEALTH"
	E.db["unitframe"]["units"]["target"]["health"]["position"] = "RIGHT"
	E.db["unitframe"]["units"]["target"]["health"]["xOffset"] = 0
	E.db["unitframe"]["units"]["target"]["health"]["yOffset"] = 0
	E.db["unitframe"]["units"]["target"]["name"]["text_format"] = ""
	E.db["unitframe"]["units"]["target"]["portrait"]["enable"] = false
	E.db["unitframe"]["units"]["target"]["power"]["enable"] = true
	E.db["unitframe"]["units"]["target"]["power"]["text_format"] = ""
	E.db["unitframe"]["units"]["target"]["power"]["position"] = "CENTER"
	E.db["unitframe"]["units"]["target"]["power"]["attachTextTo"] = "Power"
	E.db["unitframe"]["units"]["target"]["power"]["height"] = 5
	E.db["unitframe"]["units"]["target"]["power"]["xOffset"] = 0
	E.db["unitframe"]["units"]["target"]["power"]["yOffset"] = 0
	E.db["unitframe"]["units"]["target"]["power"]["detachFromFrame"] = false
	E.db["unitframe"]["units"]["target"]["power"]["detachedWidth"] = 250
	E.db["unitframe"]["units"]["target"]["power"]["hideonnpc"] = false
	E.db["unitframe"]["units"]["target"]["power"]["druidMana"] = false
	E.db["unitframe"]["units"]["target"]["power"]["strataAndLevel"]["useCustomStrata"] = true
	E.db["unitframe"]["units"]["target"]["buffs"]["enable"] = true
	E.db["unitframe"]["units"]["target"]["buffs"]["perrow"] = 8
	E.db["unitframe"]["units"]["target"]["buffs"]["numrows"] = 1
	E.db["unitframe"]["units"]["target"]["buffs"]["attachTo"] = "FRAME"
	E.db["unitframe"]["units"]["target"]["buffs"]["anchorPoint"] = "TOPLEFT"
	E.db["unitframe"]["units"]["target"]["buffs"]["sizeOverride"] = 24
	E.db["unitframe"]["units"]["target"]["buffs"]["fontSize"] = 11
	E.db["unitframe"]["units"]["target"]["buffs"]["xOffset"] = 0
	E.db["unitframe"]["units"]["target"]["buffs"]["yOffset"] = 1
	E.db["unitframe"]["units"]["target"]["buffs"]["priority"] = "Personal,Boss,Whitelist,Blacklist,PlayerBuffs,nonPersonal"
	E.db["unitframe"]["units"]["target"]["buffs"]["countFont"] = "Expressway"
	E.db["unitframe"]["units"]["target"]["buffs"]["countFontSize"] = 9
	E.db["unitframe"]["units"]["target"]["debuffs"]["enable"] = true
	E.db["unitframe"]["units"]["target"]["debuffs"]["perrow"] = 8
	E.db["unitframe"]["units"]["target"]["debuffs"]["numrows"] = 1
	E.db["unitframe"]["units"]["target"]["debuffs"]["attachTo"] = "FRAME"
	E.db["unitframe"]["units"]["target"]["debuffs"]["anchorPoint"] = "TOPLEFT"
	E.db["unitframe"]["units"]["target"]["debuffs"]["sizeOverride"] = 24
	E.db["unitframe"]["units"]["target"]["debuffs"]["fontSize"] = 11
	E.db["unitframe"]["units"]["target"]["debuffs"]["xOffset"] = 0
	E.db["unitframe"]["units"]["target"]["debuffs"]["yOffset"] = 26
	E.db["unitframe"]["units"]["target"]["debuffs"]["priority"] = "Blacklist,Personal,RaidDebuffs,CCDebuffs,Friendly:Dispellable"
	E.db["unitframe"]["units"]["target"]["debuffs"]["countFont"] = "Expressway"
	E.db["unitframe"]["units"]["target"]["debuffs"]["countFontSize"] = 9
	E.db["unitframe"]["units"]["target"]["smartAuraPosition"] = "DISABLED"
	E.db["unitframe"]["units"]["target"]["aurabar"]["enable"] = false
	E.db["unitframe"]["units"]["target"]["aurabar"]["attachTo"] = "FRAME"
	E.db["unitframe"]["units"]["target"]["aurabar"]["anchorPoint"] = "ABOVE"
	E.db["unitframe"]["units"]["target"]["aurabar"]["height"] = 20
	E.db["unitframe"]["units"]["target"]["aurabar"]["yOffset"] = 2
	E.db["unitframe"]["units"]["target"]["castbar"]["enable"] = true
	E.db["unitframe"]["units"]["target"]["castbar"]["width"] = 250
	E.db["unitframe"]["units"]["target"]["castbar"]["height"] = 16
	E.db["unitframe"]["units"]["target"]["castbar"]["icon"] = false
	E.db["unitframe"]["units"]["target"]["castbar"]["latency"] = true
	E.db["unitframe"]["units"]["target"]["castbar"]["format"] = "REMAINING"
	E.db["unitframe"]["units"]["target"]["castbar"]["spark"] = false
	E.db["unitframe"]["units"]["target"]["castbar"]["strataAndLevel"]["frameStrata"] = "MEDIUM"
	E.db["unitframe"]["units"]["target"]["raidicon"]["enable"] = true
	E.db["unitframe"]["units"]["target"]["raidicon"]["position"] = "TOP"
	E.db["unitframe"]["units"]["target"]["raidicon"]["size"] = 18
	E.db["unitframe"]["units"]["target"]["raidicon"]["xOffset"] = 0
	E.db["unitframe"]["units"]["target"]["raidicon"]["yOffset"] = 8
	E.db["unitframe"]["units"]["target"]["infoPanel"]["enable"] = false
	E.db["unitframe"]["units"]["target"]["pvpIcon"]["enable"] = false
	E.db["unitframe"]["units"]["target"]["pvpIcon"]["anchorPoint"] = "TOPLEFT"
	E.db["unitframe"]["units"]["target"]["pvpIcon"]["xOffset"] = 4
	E.db["unitframe"]["units"]["target"]["pvpIcon"]["yOffset"] = -4
	E.db["unitframe"]["units"]["target"]["pvpIcon"]["scale"] = 0.4
	if not E.db["unitframe"]["units"]["target"]["customTexts"] then E.db["unitframe"]["units"]["target"]["customTexts"] = {} end
	-- Delete old customTexts/ Create empty table
	E.db["unitframe"]["units"]["target"]["customTexts"] = {}
	-- Create own customText
	E.db["unitframe"]["units"]["target"]["customTexts"]["HealthText"] = {
		["font"] = "Expressway",
		["justifyH"] = "RIGHT",
		["fontOutline"] = "OUTLINE",
		["text_format"] = "[health:current-percent1-kui]",
		["size"] = 12,
		["attachTextTo"] = "Health",
		["xOffset"] = -4,
		["yOffset"] = 0,
	}
	E.db["unitframe"]["units"]["target"]["customTexts"]["NameText"] = {
		["font"] = "Expressway",
		["fontOutline"] = "OUTLINE",
		["size"] = 12,
		["justifyH"] = "LEFT",
		["text_format"] = "[name:long]",
		["attachTextTo"] = "Health",
		["xOffset"] = 4,
		["yOffset"] = 0,
	}

	-- TargetTarget
	E.db["unitframe"]["units"]["targettarget"]["enable"] = true
	E.db["unitframe"]["units"]["targettarget"]["width"] = 90
	E.db["unitframe"]["units"]["targettarget"]["height"] = 33
	E.db["unitframe"]["units"]["targettarget"]["rangeCheck"] = false
	E.db["unitframe"]["units"]["targettarget"]["buffs"]["enable"] = false
	E.db["unitframe"]["units"]["targettarget"]["debuffs"]["enable"] = false
	E.db["unitframe"]["units"]["targettarget"]["power"]["enable"] = false
	E.db["unitframe"]["units"]["targettarget"]["power"]["position"] = "CENTER"
	E.db["unitframe"]["units"]["targettarget"]["power"]["height"] = 3
	E.db["unitframe"]["units"]["targettarget"]["name"]["yOffset"] = 0
	E.db["unitframe"]["units"]["targettarget"]["name"]["text_format"] = "[name:medium]"
	E.db["unitframe"]["units"]["targettarget"]["health"]["text_format"] = ""
	E.db["unitframe"]["units"]["targettarget"]["raidicon"]["enable"] = true
	E.db["unitframe"]["units"]["targettarget"]["raidicon"]["position"] = "TOP"
	E.db["unitframe"]["units"]["targettarget"]["raidicon"]["size"] = 18
	E.db["unitframe"]["units"]["targettarget"]["raidicon"]["xOffset"] = 0
	E.db["unitframe"]["units"]["targettarget"]["raidicon"]["yOffset"] = 8
	E.db["unitframe"]["units"]["targettarget"]["portrait"]["enable"] = false
	E.db["unitframe"]["units"]["targettarget"]["infoPanel"]["enable"] = false
	if not E.db["unitframe"]["units"]["targettarget"]["customTexts"] then E.db["unitframe"]["units"]["targettarget"]["customTexts"] = {} end
	-- Delete old customTexts/ Create empty table
	E.db["unitframe"]["units"]["targettarget"]["customTexts"] = {}
	--[[
	-- Focus
	E.db["unitframe"]["units"]["focus"]["enable"] = true
	E.db["unitframe"]["units"]["focus"]["width"] = 250
	E.db["unitframe"]["units"]["focus"]["height"] = 16
	E.db["unitframe"]["units"]["focus"]["rangeCheck"] = false
	E.db["unitframe"]["units"]["focus"]["threatStyle"] = "NONE"
	E.db["unitframe"]["units"]["focus"]["buffs"]["enable"] = false
	E.db["unitframe"]["units"]["focus"]["debuffs"]["enable"] = false
	E.db["unitframe"]["units"]["focus"]["name"]["attachTextTo"] = "Frame"
	E.db["unitframe"]["units"]["focus"]["name"]["position"] = "CENTER"
	E.db["unitframe"]["units"]["focus"]["name"]["text_format"] = "[name:long]"
	E.db["unitframe"]["units"]["focus"]["health"]["position"] = "LEFT"
	E.db["unitframe"]["units"]["focus"]["health"]["text_format"] = ""
	E.db["unitframe"]["units"]["focus"]["health"]["xOffset"] = 0
	E.db["unitframe"]["units"]["focus"]["health"]["yOffset"] = 0
	E.db["unitframe"]["units"]["focus"]["health"]["attachTextTo"] = "Frame"
	E.db["unitframe"]["units"]["focus"]["power"]["enable"] = false
	E.db["unitframe"]["units"]["focus"]["power"]["position"] = "CENTER"
	E.db["unitframe"]["units"]["focus"]["power"]["height"] = 3
	E.db["unitframe"]["units"]["focus"]["power"]["text_format"] = ""
	E.db["unitframe"]["units"]["focus"]["power"]["xOffset"] = 0
	E.db["unitframe"]["units"]["focus"]["power"]["yOffset"] = 0
	E.db["unitframe"]["units"]["focus"]["castbar"]["enable"] = false
	E.db["unitframe"]["units"]["focus"]["castbar"]["width"] = 250
	E.db["unitframe"]["units"]["focus"]["castbar"]["height"] = 16
	E.db["unitframe"]["units"]["focus"]["castbar"]["icon"] = false
	E.db["unitframe"]["units"]["focus"]["castbar"]["iconSize"] = 16
	E.db["unitframe"]["units"]["focus"]["castbar"]["latency"] = true
	E.db["unitframe"]["units"]["focus"]["castbar"]["format"] = "REMAINING"
	E.db["unitframe"]["units"]["focus"]["castbar"]["spark"] = false
	E.db["unitframe"]["units"]["focus"]["castbar"]["insideInfoPanel"] = false
	E.db["unitframe"]["units"]["focus"]["portrait"]["enable"] = false
	E.db["unitframe"]["units"]["focus"]["infoPanel"]["enable"] = false

	-- FocusTarget
	E.db["unitframe"]["units"]["focustarget"]["enable"] = true
	E.db["unitframe"]["units"]["focustarget"]["rangeCheck"] = false
	E.db["unitframe"]["units"]["focustarget"]["width"] = 250
	E.db["unitframe"]["units"]["focustarget"]["height"] = 16
	E.db["unitframe"]["units"]["focustarget"]["power"]["enable"] = false
	E.db["unitframe"]["units"]["focustarget"]["buffs"]["enable"] = false
	E.db["unitframe"]["units"]["focustarget"]["debuffs"]["enable"] = false
	E.db["unitframe"]["units"]["focustarget"]["name"]["position"] = "CENTER"
	E.db["unitframe"]["units"]["focustarget"]["name"]["text_format"] = "[name:long]"
	]]
	-- Pet
	E.db["unitframe"]["units"]["pet"]["width"] = 90
	E.db["unitframe"]["units"]["pet"]["height"] = 33
	E.db["unitframe"]["units"]["pet"]["rangeCheck"] = false
	E.db["unitframe"]["units"]["pet"]["threatStyle"] = "NONE"
	E.db["unitframe"]["units"]["pet"]["healPrediction"] = false
	E.db["unitframe"]["units"]["pet"]["health"]["position"] = "LEFT"
	E.db["unitframe"]["units"]["pet"]["health"]["text_format"] = ""
	E.db["unitframe"]["units"]["pet"]["health"]["xOffset"] = 0
	E.db["unitframe"]["units"]["pet"]["health"]["yOffset"] = 0
	E.db["unitframe"]["units"]["pet"]["health"]["attachTextTo"] = "Frame"
	E.db["unitframe"]["units"]["pet"]["name"]["attachTextTo"] = "Frame"
	E.db["unitframe"]["units"]["pet"]["name"]["position"] = "CENTER"
	E.db["unitframe"]["units"]["pet"]["name"]["text_format"] = "[name:medium]"
	E.db["unitframe"]["units"]["pet"]["name"]["xOffset"] = 0
	E.db["unitframe"]["units"]["pet"]["name"]["yOffset"] = 0
	E.db["unitframe"]["units"]["pet"]["power"]["enable"] = false
	E.db["unitframe"]["units"]["pet"]["power"]["position"] = "RIGHT"
	E.db["unitframe"]["units"]["pet"]["power"]["height"] = 3
	E.db["unitframe"]["units"]["pet"]["power"]["text_format"] = ""
	E.db["unitframe"]["units"]["pet"]["power"]["xOffset"] = 0
	E.db["unitframe"]["units"]["pet"]["power"]["yOffset"] = 0
	E.db["unitframe"]["units"]["pet"]["power"]["attachTextTo"] = "Power"
	E.db["unitframe"]["units"]["pet"]["buffs"]["enable"] = false
	E.db["unitframe"]["units"]["pet"]["buffs"]["fontSize"] = 10
	E.db["unitframe"]["units"]["pet"]["buffs"]["attachTo"] = "FRAME"
	E.db["unitframe"]["units"]["pet"]["buffs"]["sizeOverride"] = 0
	E.db["unitframe"]["units"]["pet"]["buffs"]["xOffset"] = 0
	E.db["unitframe"]["units"]["pet"]["buffs"]["yOffset"] = 0
	E.db["unitframe"]["units"]["pet"]["buffs"]["perrow"] = 5
	E.db["unitframe"]["units"]["pet"]["buffs"]["anchorPoint"] = "TOPLEFT"
	E.db["unitframe"]["units"]["pet"]["buffs"]["countFont"] = "Expressway"
	E.db["unitframe"]["units"]["pet"]["buffs"]["countFontSize"] = 9
	E.db["unitframe"]["units"]["pet"]["debuffs"]["enable"] = false
	E.db["unitframe"]["units"]["pet"]["debuffs"]["fontSize"] = 10
	E.db["unitframe"]["units"]["pet"]["debuffs"]["attachTo"] = "FRAME"
	E.db["unitframe"]["units"]["pet"]["debuffs"]["sizeOverride"] = 0
	E.db["unitframe"]["units"]["pet"]["debuffs"]["xOffset"] = 0
	E.db["unitframe"]["units"]["pet"]["debuffs"]["yOffset"] = 0
	E.db["unitframe"]["units"]["pet"]["debuffs"]["perrow"] = 5
	E.db["unitframe"]["units"]["pet"]["debuffs"]["anchorPoint"] = "TOPLEFT"
	E.db["unitframe"]["units"]["pet"]["debuffs"]["countFont"] = "Expressway"
	E.db["unitframe"]["units"]["pet"]["debuffs"]["countFontSize"] = 9
	E.db["unitframe"]["units"]["pet"]["castbar"]["enable"] = true
	E.db["unitframe"]["units"]["pet"]["castbar"]["width"] = 90
	E.db["unitframe"]["units"]["pet"]["castbar"]["height"] = 16
	E.db["unitframe"]["units"]["pet"]["castbar"]["latency"] = true
	E.db["unitframe"]["units"]["pet"]["castbar"]["spark"] = false
	E.db["unitframe"]["units"]["pet"]["castbar"]["icon"] = false
	E.db["unitframe"]["units"]["pet"]["castbar"]["iconAttached"] = false
	E.db["unitframe"]["units"]["pet"]["castbar"]["insideInfoPanel"] = false
	E.db["unitframe"]["units"]["pet"]["portrait"]["enable"] = false
	E.db["unitframe"]["units"]["pet"]["portrait"]["overlay"] = true
	E.db["unitframe"]["units"]["pet"]["orientation"] = "MIDDLE"
	E.db["unitframe"]["units"]["pet"]["infoPanel"]["enable"] = false
	E.db["unitframe"]["units"]["pet"]["infoPanel"]["height"] = 14
	E.db["unitframe"]["units"]["pet"]["infoPanel"]["transparent"] = true
	
	-- PetTarget
	E.db["unitframe"]["units"]["pettarget"]["enable"] = false
	--[[
	-- Arena
	E.db["unitframe"]["units"]["arena"]["enable"] = true
	E.db["unitframe"]["units"]["arena"]["width"] = 225
	E.db["unitframe"]["units"]["arena"]["height"] = 40
	E.db["unitframe"]["units"]["arena"]["spacing"] = 20
	E.db["unitframe"]["units"]["arena"]["health"]["text_format"] = "[health:current-percent1-kui]"
	E.db["unitframe"]["units"]["arena"]["health"]["position"] = "RIGHT"
	E.db["unitframe"]["units"]["arena"]["health"]["xOffset"] = -4
	E.db["unitframe"]["units"]["arena"]["health"]["yOffset"] = 0
	E.db["unitframe"]["units"]["arena"]["power"]["text_format"] = ""
	E.db["unitframe"]["units"]["arena"]["name"]["text_format"] = "[name:medium]"
	E.db["unitframe"]["units"]["arena"]["name"]["position"] = "LEFT"
	E.db["unitframe"]["units"]["arena"]["name"]["xOffset"] = 4
	E.db["unitframe"]["units"]["arena"]["name"]["yOffset"] = 0
	E.db["unitframe"]["units"]["arena"]["buffs"]["anchorPoint"] = "RIGHT"
	E.db["unitframe"]["units"]["arena"]["buffs"]["fontSize"] = 11
	E.db["unitframe"]["units"]["arena"]["buffs"]["sizeOverride"] = 19
	E.db["unitframe"]["units"]["arena"]["buffs"]["xOffset"] = 1
	E.db["unitframe"]["units"]["arena"]["buffs"]["yOffset"] = 10
	E.db["unitframe"]["units"]["arena"]["buffs"]["countFont"] = "Expressway"
	E.db["unitframe"]["units"]["arena"]["buffs"]["countFontSize"] = 9
	E.db["unitframe"]["units"]["arena"]["debuffs"]["anchorPoint"] = "RIGHT"
	E.db["unitframe"]["units"]["arena"]["debuffs"]["fontSize"] = 11
	E.db["unitframe"]["units"]["arena"]["debuffs"]["sizeOverride"] = 19
	E.db["unitframe"]["units"]["arena"]["debuffs"]["xOffset"] = 1
	E.db["unitframe"]["units"]["arena"]["debuffs"]["yOffset"] = -11
	E.db["unitframe"]["units"]["arena"]["debuffs"]["countFont"] = "Expressway"
	E.db["unitframe"]["units"]["arena"]["debuffs"]["countFontSize"] = 9
	E.db["unitframe"]["units"]["arena"]["castbar"]["width"] = 225
	E.db["unitframe"]["units"]["arena"]["castbar"]["height"] = 10
	E.db["unitframe"]["units"]["arena"]["castbar"]["icon"] = false
	E.db["unitframe"]["units"]["arena"]["castbar"]["format"] = ""
	E.db["unitframe"]["units"]["arena"]["castbar"]["spark"] = false
	
	KUI:SetMoverPosition("ArenaHeaderMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -320, -285)

	-- Boss
	E.db["unitframe"]["units"]["boss"]["enable"] = true
	E.db["unitframe"]["units"]["boss"]["width"] = 175
	E.db["unitframe"]["units"]["boss"]["height"] = 35
	E.db["unitframe"]["units"]["boss"]["spacing"] = 20
	E.db["unitframe"]["units"]["boss"]["text_format"] = "[health:current-percent1-kui]"
	E.db["unitframe"]["units"]["boss"]["health"]["xOffset"] = -4
	E.db["unitframe"]["units"]["boss"]["health"]["yOffset"] = 0
	E.db["unitframe"]["units"]["boss"]["health"]["text_format"] = ""
	E.db["unitframe"]["units"]["boss"]["health"]["position"] = "RIGHT"
	E.db["unitframe"]["units"]["boss"]["power"]["enable"] = true
	E.db["unitframe"]["units"]["boss"]["power"]["height"] = 5
	E.db["unitframe"]["units"]["boss"]["power"]["text_format"] = "[power:percent]"
	E.db["unitframe"]["units"]["boss"]["power"]["xOffset"] = 0
	E.db["unitframe"]["units"]["boss"]["power"]["yOffset"] = 0
	E.db["unitframe"]["units"]["boss"]["power"]["attachTextTo"] = "Power"
	E.db["unitframe"]["units"]["boss"]["power"]["position"] = "CENTER"
	E.db["unitframe"]["units"]["boss"]["name"]["text_format"] = "[name:medium]"
	E.db["unitframe"]["units"]["boss"]["name"]["position"] = "LEFT"
	E.db["unitframe"]["units"]["boss"]["name"]["attachTextTo"] = "Health"
	E.db["unitframe"]["units"]["boss"]["name"]["xOffset"] = 4
	E.db["unitframe"]["units"]["boss"]["name"]["yOffset"] = 0
	E.db["unitframe"]["units"]["boss"]["buffs"]["enable"] = false
	E.db["unitframe"]["units"]["boss"]["buffs"]["perrow"] = 3
	E.db["unitframe"]["units"]["boss"]["buffs"]["numrows"] = 1
	E.db["unitframe"]["units"]["boss"]["buffs"]["anchorPoint"] = "LEFT"
	E.db["unitframe"]["units"]["boss"]["buffs"]["attachTo"] = "FRAME"
	E.db["unitframe"]["units"]["boss"]["buffs"]["fontSize"] = 22
	E.db["unitframe"]["units"]["boss"]["buffs"]["xOffset"] = -3
	E.db["unitframe"]["units"]["boss"]["buffs"]["yOffset"] = 0
	E.db["unitframe"]["units"]["boss"]["buffs"]["sizeOverride"] = 35
	E.db["unitframe"]["units"]["boss"]["buffs"]["countFontSize"] = 12
	E.db["unitframe"]["units"]["boss"]["buffs"]["countFont"] = "Expressway"
	E.db["unitframe"]["units"]["boss"]["buffs"]["countFontSize"] = 9
	E.db["unitframe"]["units"]["boss"]["debuffs"]["enable"] = true
	E.db["unitframe"]["units"]["boss"]["debuffs"]["perrow"] = 3
	E.db["unitframe"]["units"]["boss"]["debuffs"]["numrows"] = 1
	E.db["unitframe"]["units"]["boss"]["debuffs"]["anchorPoint"] = "RIGHT"
	E.db["unitframe"]["units"]["boss"]["debuffs"]["attachTo"] = "FRAME"
	E.db["unitframe"]["units"]["boss"]["debuffs"]["fontSize"] = 22
	E.db["unitframe"]["units"]["boss"]["debuffs"]["xOffset"] = 1
	E.db["unitframe"]["units"]["boss"]["debuffs"]["yOffset"] = 0
	E.db["unitframe"]["units"]["boss"]["debuffs"]["sizeOverride"] = 35
	E.db["unitframe"]["units"]["boss"]["debuffs"]["countFontSize"] = 12
	E.db["unitframe"]["units"]["boss"]["debuffs"]["countFont"] = "Expressway"
	E.db["unitframe"]["units"]["boss"]["debuffs"]["countFontSize"] = 9
	E.db["unitframe"]["units"]["boss"]["castbar"]["enable"] = true
	E.db["unitframe"]["units"]["boss"]["castbar"]["width"] = 175
	E.db["unitframe"]["units"]["boss"]["castbar"]["height"] = 10
	E.db["unitframe"]["units"]["boss"]["castbar"]["icon"] = false
	E.db["unitframe"]["units"]["boss"]["castbar"]["format"] = ""
	if not E.db["unitframe"]["units"]["boss"]["customTexts"] then E.db["unitframe"]["units"]["boss"]["customTexts"] = {} end
	-- Delete old customTexts/ Create empty table
	E.db["unitframe"]["units"]["boss"]["customTexts"] = {}

	KUI:SetMoverPosition("BossHeaderMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -370, -285)
	]]
	-- Party
	E.db["unitframe"]["units"]["party"]["width"] = 160
	E.db["unitframe"]["units"]["party"]["height"] = 22
	E.db["unitframe"]["units"]["party"]["threatStyle"] = "GLOW"
	E.db["unitframe"]["units"]["party"]["growthDirection"] = "DOWN_RIGHT"
	E.db["unitframe"]["units"]["party"]["orientation"] = "LEFT"
	E.db["unitframe"]["units"]["party"]["horizontalSpacing"] = 0
	E.db["unitframe"]["units"]["party"]["verticalSpacing"] = 1
	E.db["unitframe"]["units"]["party"]["healPrediction"]["enable"] = true
	E.db["unitframe"]["units"]["party"]["healPrediction"]["showOverAbsorbs"] = true
	E.db["unitframe"]["units"]["party"]["healPrediction"]["showAbsorbAmount"] = false
	E.db["unitframe"]["units"]["party"]["colorOverride"] = "FORCE_ON"
	E.db["unitframe"]["units"]["party"]["groupBy"] = "ROLE"
	E.db["unitframe"]["units"]["party"]["health"]["attachTextTo"] = "Health"
	E.db["unitframe"]["units"]["party"]["health"]["position"] = "CENTER"
	E.db["unitframe"]["units"]["party"]["health"]["frequentUpdates"] = true
	E.db["unitframe"]["units"]["party"]["health"]["text_format"] = "[health:deficit-kui]"
	E.db["unitframe"]["units"]["party"]["health"]["xOffset"] = 0
	E.db["unitframe"]["units"]["party"]["health"]["yOffset"] = 0
	E.db["unitframe"]["units"]["party"]["power"]["enable"] = true
	E.db["unitframe"]["units"]["party"]["power"]["height"] = 4
	E.db["unitframe"]["units"]["party"]["power"]["text_format"] = "[powercolor][power:current]"
	E.db["unitframe"]["units"]["party"]["power"]["position"] = "RIGHT"
	E.db["unitframe"]["units"]["party"]["power"]["attachTextTo"] = "Health"
	E.db["unitframe"]["units"]["party"]["power"]["xOffset"] = -2
	E.db["unitframe"]["units"]["party"]["power"]["yOffset"] = 0
	E.db["unitframe"]["units"]["party"]["name"]["position"] = "LEFT"
	E.db["unitframe"]["units"]["party"]["name"]["attachTextTo"] = "Health"
	E.db["unitframe"]["units"]["party"]["name"]["text_format"] = "[name:long]"
	E.db["unitframe"]["units"]["party"]["name"]["xOffset"] = 165
	E.db["unitframe"]["units"]["party"]["name"]["yOffset"] = 0
	E.db["unitframe"]["units"]["party"]["buffs"]["enable"] = false
	E.db["unitframe"]["units"]["party"]["buffs"]["perrow"] = 2
	E.db["unitframe"]["units"]["party"]["buffs"]["numrows"] = 1
	E.db["unitframe"]["units"]["party"]["buffs"]["sizeOverride"] = 20
	E.db["unitframe"]["units"]["party"]["buffs"]["xOffset"] = -47
	E.db["unitframe"]["units"]["party"]["buffs"]["yOffset"] = 0
	E.db["unitframe"]["units"]["party"]["buffs"]["anchorPoint"] = "RIGHT"
	E.db["unitframe"]["units"]["party"]["buffs"]["countFontSize"] = 12
	E.db["unitframe"]["units"]["party"]["buffs"]["clickThrough"] = true
	E.db["unitframe"]["units"]["party"]["buffs"]["countFont"] = "Expressway"
	E.db["unitframe"]["units"]["party"]["buffs"]["countFontSize"] = 9
	E.db["unitframe"]["units"]["party"]["debuffs"]["enable"] = true
	E.db["unitframe"]["units"]["party"]["debuffs"]["perrow"] = 1
	E.db["unitframe"]["units"]["party"]["debuffs"]["numrows"] = 1
	E.db["unitframe"]["units"]["party"]["debuffs"]["countFontSize"] = 12
	E.db["unitframe"]["units"]["party"]["debuffs"]["sizeOverride"] = 20
	E.db["unitframe"]["units"]["party"]["debuffs"]["xOffset"] = 0
	E.db["unitframe"]["units"]["party"]["debuffs"]["yOffset"] = 0
	E.db["unitframe"]["units"]["party"]["debuffs"]["anchorPoint"] = "CENTER"
	E.db["unitframe"]["units"]["party"]["debuffs"]["onlyDispellable"] = true
	E.db["unitframe"]["units"]["party"]["debuffs"]["clickThrough"] = true
	E.db["unitframe"]["units"]["party"]["debuffs"]["priority"] = "Blacklist,Boss,RaidDebuffs,nonPersonal,CastByUnit,CCDebuffs,CastByNPC,Dispellable"
	E.db["unitframe"]["units"]["party"]["debuffs"]["countFont"] = "Expressway"
	E.db["unitframe"]["units"]["party"]["debuffs"]["countFontSize"] = 9
	E.db["unitframe"]["units"]["party"]["buffIndicator"]["enable"] = true
	E.db["unitframe"]["units"]["party"]["buffIndicator"]["size"] = 8
	E.db["unitframe"]["units"]["party"]["buffIndicator"]["fontSize"] = 10
	E.db["unitframe"]["units"]["party"]["rdebuffs"]["enable"] = false
	E.db["unitframe"]["units"]["party"]["rdebuffs"]["font"] = "Expressway"
	E.db["unitframe"]["units"]["party"]["rdebuffs"]["fontOutline"] = "OUTLINE"
	E.db["unitframe"]["units"]["party"]["rdebuffs"]["size"] = 20
	E.db["unitframe"]["units"]["party"]["rdebuffs"]["xOffset"] = 0
	E.db["unitframe"]["units"]["party"]["rdebuffs"]["yOffset"] = 0
	E.db["unitframe"]["units"]["party"]["roleIcon"]["enable"] = true
	E.db["unitframe"]["units"]["party"]["roleIcon"]["size"] = 10
	E.db["unitframe"]["units"]["party"]["roleIcon"]["damager"] = false
	E.db["unitframe"]["units"]["party"]["roleIcon"]["position"] = "LEFT"
	E.db["unitframe"]["units"]["party"]["roleIcon"]["attachTo"] = "Health"
	E.db["unitframe"]["units"]["party"]["roleIcon"]["xOffset"] = 2
	E.db["unitframe"]["units"]["party"]["roleIcon"]["yOffset"] = 0
	E.db["unitframe"]["units"]["party"]["targetsGroup"]["enable"] = false
	E.db["unitframe"]["units"]["party"]["petsGroup"]["enable"] = false
	E.db["unitframe"]["units"]["party"]["visibility"] = "[@raid6,exists][nogroup] hide;show"
	if E.db["unitframe"]["units"]["party"]["customTexts"] then E.db["unitframe"]["units"]["party"]["customTexts"] = nil end
	-- Delete old customTexts/ Create empty table
	E.db["unitframe"]["units"]["party"]["customTexts"] = {}
	
	-- Raid
	E.db["unitframe"]["units"]["raid"]["width"] = 125
	E.db["unitframe"]["units"]["raid"]["height"] = 20
	E.db["unitframe"]["units"]["raid"]["numGroups"] = 6
	E.db["unitframe"]["units"]["raid"]["groupsPerRowCol"] = 6
	E.db["unitframe"]["units"]["raid"]["threatStyle"] = "GLOW"
	E.db["unitframe"]["units"]["raid"]["orientation"] = "LEFT"
	E.db["unitframe"]["units"]["raid"]["growthDirection"] = "DOWN_RIGHT"
	E.db["unitframe"]["units"]["raid"]["visibility"] = "[@raid6,noexists][@raid31,exists] hide;show"
	E.db["unitframe"]["units"]["raid"]["horizontalSpacing"] = 0
	E.db["unitframe"]["units"]["raid"]["verticalSpacing"] = 1
	E.db["unitframe"]["units"]["raid"]["healPrediction"]["enable"] = true
	E.db["unitframe"]["units"]["raid"]["healPrediction"]["showOverAbsorbs"] = true
	E.db["unitframe"]["units"]["raid"]["healPrediction"]["showAbsorbAmount"] = false
	E.db["unitframe"]["units"]["raid"]["colorOverride"] = "FORCE_ON"
	E.db["unitframe"]["units"]["raid"]["groupBy"] = "ROLE"
	E.db["unitframe"]["units"]["raid"]["raidWideSorting"] = false
	E.db["unitframe"]["units"]["raid"]["health"]["frequentUpdates"] = true
	E.db["unitframe"]["units"]["raid"]["health"]["position"] = "CENTER"
	E.db["unitframe"]["units"]["raid"]["health"]["attachTextTo"] = "Frame"
	E.db["unitframe"]["units"]["raid"]["health"]["text_format"] = "[health:deficit-kui]"
	E.db["unitframe"]["units"]["raid"]["health"]["xOffset"] = 0
	E.db["unitframe"]["units"]["raid"]["health"]["yOffset"] = 0
	E.db["unitframe"]["units"]["raid"]["power"]["enable"] = false
	E.db["unitframe"]["units"]["raid"]["power"]["height"] = 3
	E.db["unitframe"]["units"]["raid"]["name"]["position"] = "LEFT"
	E.db["unitframe"]["units"]["raid"]["name"]["attachTextTo"] = "Frame"
	E.db["unitframe"]["units"]["raid"]["name"]["text_format"] = "[name:long]"
	E.db["unitframe"]["units"]["raid"]["name"]["xOffset"] = 130
	E.db["unitframe"]["units"]["raid"]["name"]["yOffset"] = 0
	E.db["unitframe"]["units"]["raid"]["buffs"]["enable"] = false
	E.db["unitframe"]["units"]["raid"]["debuffs"]["enable"] = true
	E.db["unitframe"]["units"]["raid"]["debuffs"]["perrow"] = 1
	E.db["unitframe"]["units"]["raid"]["debuffs"]["numrows"] = 1
	E.db["unitframe"]["units"]["raid"]["debuffs"]["sizeOverride"] = 18
	E.db["unitframe"]["units"]["raid"]["debuffs"]["countFontSize"] = 12
	E.db["unitframe"]["units"]["raid"]["debuffs"]["xOffset"] = 0
	E.db["unitframe"]["units"]["raid"]["debuffs"]["yOffset"] = 0
	E.db["unitframe"]["units"]["raid"]["debuffs"]["attachTo"] = "Frame"
	E.db["unitframe"]["units"]["raid"]["debuffs"]["anchorPoint"] = "CENTER"
	E.db["unitframe"]["units"]["raid"]["debuffs"]["onlyDispellable"] = true
	E.db["unitframe"]["units"]["raid"]["debuffs"]["clickThrough"] = true
	E.db["unitframe"]["units"]["raid"]["debuffs"]["priority"] = "Blacklist,Boss,RaidDebuffs,nonPersonal,CastByUnit,CCDebuffs,CastByNPC,Dispellable"
	E.db["unitframe"]["units"]["raid"]["debuffs"]["countFont"] = "Expressway"
	E.db["unitframe"]["units"]["raid"]["debuffs"]["countFontSize"] = 9
	E.db["unitframe"]["units"]["raid"]["buffIndicator"]["enable"] = true
	E.db["unitframe"]["units"]["raid"]["buffIndicator"]["size"] = 8
	E.db["unitframe"]["units"]["raid"]["buffIndicator"]["fontSize"] = 10
	E.db["unitframe"]["units"]["raid"]["rdebuffs"]["enable"] = false
	E.db["unitframe"]["units"]["raid"]["rdebuffs"]["size"] = 20
	E.db["unitframe"]["units"]["raid"]["rdebuffs"]["font"] = "Expressway"
	E.db["unitframe"]["units"]["raid"]["rdebuffs"]["fontOutline"] = "OUTLINE"
	E.db["unitframe"]["units"]["raid"]["roleIcon"]["enable"] = true
	E.db["unitframe"]["units"]["raid"]["roleIcon"]["size"] = 10
	E.db["unitframe"]["units"]["raid"]["roleIcon"]["damager"] = false
	E.db["unitframe"]["units"]["raid"]["roleIcon"]["position"] = "LEFT"
	E.db["unitframe"]["units"]["raid"]["roleIcon"]["attachTo"] = "Frame"
	E.db["unitframe"]["units"]["raid"]["roleIcon"]["xOffset"] = 2
	E.db["unitframe"]["units"]["raid"]["roleIcon"]["yOffset"] = 0
	E.db["unitframe"]["units"]["raid"]["portrait"]["enable"] = false
	if not E.db["unitframe"]["units"]["raid"]["customTexts"] then E.db["unitframe"]["units"]["raid"]["customTexts"] = {} end
	-- Delete old customTexts/ Create empty table
	E.db["unitframe"]["units"]["raid"]["customTexts"] = {}
	
	-- Raid40
	E.db["unitframe"]["units"]["raid40"]["enable"] = true
	E.db["unitframe"]["units"]["raid40"]["width"] = 125
	E.db["unitframe"]["units"]["raid40"]["height"] = 15
	E.db["unitframe"]["units"]["raid40"]["numGroups"] = 8
	E.db["unitframe"]["units"]["raid40"]["groupsPerRowCol"] = 8
	E.db["unitframe"]["units"]["raid40"]["threatStyle"] = "GLOW"
	E.db["unitframe"]["units"]["raid40"]["growthDirection"] = "DOWN_RIGHT"
	E.db["unitframe"]["units"]["raid40"]["orientation"] = "LEFT"
	E.db["unitframe"]["units"]["raid40"]["groupBy"] = "ROLE"
	E.db["unitframe"]["units"]["raid40"]["visibility"] = "[@raid31,noexists] hide;show"
	E.db["unitframe"]["units"]["raid40"]["horizontalSpacing"] = 0
	E.db["unitframe"]["units"]["raid40"]["verticalSpacing"] = 1
	E.db["unitframe"]["units"]["raid40"]["raidWideSorting"] = false
	E.db["unitframe"]["units"]["raid40"]["healPrediction"]["enable"] = true
	E.db["unitframe"]["units"]["raid40"]["healPrediction"]["showOverAbsorbs"] = true
	E.db["unitframe"]["units"]["raid40"]["healPrediction"]["showAbsorbAmount"] = false
	E.db["unitframe"]["units"]["raid40"]["colorOverride"] = "FORCE_ON"
	E.db["unitframe"]["units"]["raid40"]["health"]["frequentUpdates"] = true
	E.db["unitframe"]["units"]["raid40"]["health"]["position"] = "CENTER"
	E.db["unitframe"]["units"]["raid40"]["health"]["attachTextTo"] = "Frame"
	E.db["unitframe"]["units"]["raid40"]["health"]["text_format"] = "[health:deficit-kui]"
	E.db["unitframe"]["units"]["raid40"]["health"]["xOffset"] = 0
	E.db["unitframe"]["units"]["raid40"]["health"]["yOffset"] = 0
	E.db["unitframe"]["units"]["raid40"]["power"]["enable"] = false
	E.db["unitframe"]["units"]["raid40"]["power"]["height"] = 3
	E.db["unitframe"]["units"]["raid40"]["name"]["position"] = "LEFT"
	E.db["unitframe"]["units"]["raid40"]["name"]["attachTextTo"] = "Frame"
	E.db["unitframe"]["units"]["raid40"]["name"]["text_format"] = "[name:long]"
	E.db["unitframe"]["units"]["raid40"]["name"]["xOffset"] = 130
	E.db["unitframe"]["units"]["raid40"]["name"]["yOffset"] = 0
	E.db["unitframe"]["units"]["raid40"]["buffs"]["enable"] = false
	E.db["unitframe"]["units"]["raid40"]["debuffs"]["enable"] = false
	E.db["unitframe"]["units"]["raid40"]["debuffs"]["priority"] = "Blacklist,Boss,RaidDebuffs,nonPersonal,CastByUnit,CCDebuffs,CastByNPC,Dispellable"
	E.db["unitframe"]["units"]["raid40"]["debuffs"]["onlyDispellable"] = true
	E.db["unitframe"]["units"]["raid40"]["debuffs"]["countFont"] = "Expressway"
	E.db["unitframe"]["units"]["raid40"]["debuffs"]["countFontSize"] = 9
	E.db["unitframe"]["units"]["raid40"]["buffIndicator"]["enable"] = true
	E.db["unitframe"]["units"]["raid40"]["buffIndicator"]["size"] = 8
	E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["enable"] = false
	E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["font"] = "Expressway"
	E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["fontOutline"] = "OUTLINE"
	E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["size"] = 20
	E.db["unitframe"]["units"]["raid40"]["roleIcon"]["enable"] = true
	E.db["unitframe"]["units"]["raid40"]["roleIcon"]["position"] = "LEFT"
	E.db["unitframe"]["units"]["raid40"]["roleIcon"]["attachTo"] = "Frame"
	E.db["unitframe"]["units"]["raid40"]["roleIcon"]["damager"] = false
	E.db["unitframe"]["units"]["raid40"]["roleIcon"]["size"] = 10
	E.db["unitframe"]["units"]["raid40"]["roleIcon"]["xOffset"] = 2
	E.db["unitframe"]["units"]["raid40"]["roleIcon"]["yOffset"] = 0
	E.db["unitframe"]["units"]["raid40"]["portrait"]["enable"] = false

	-- Assist
	E.db["unitframe"]["units"]["assist"]["enable"] = false

	KUI:SetMoverPosition("ElvUF_AssistMover", "TOPLEFT", E.UIParent, "TOPLEFT", 10, -340)

	-- Tank
	E.db["unitframe"]["units"]["tank"]["enable"] = false

	KUI:SetMoverPosition("ElvUF_TankMover", "TOPLEFT", E.UIParent, "BOTTOMLEFT", 2, 626)

	-- RaidPet
	E.db["unitframe"]["units"]["raidpet"]["enable"] = false
	KUI:SetMoverPosition("ElvUF_RaidpetMover", "TOPLEFT", E.UIParent, "BOTTOMLEFT", 0, 808)
	
	if layout == 'dps' then
		--[[----------------------------------
		--	Movers - DPS
		--]]----------------------------------
		KUI:SetMoverPosition("BNETMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 10, 194)
		KUI:SetMoverPosition("SpecializationBarMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 43, 194)
		-- Player
		KUI:SetMoverPosition("ElvUF_PlayerMover", "BOTTOM", E.UIParent, "BOTTOM", -265, 281)
		KUI:SetMoverPosition("PlayerPowerBarMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 281)
		KUI:SetMoverPosition("ComboBarMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 304)
		KUI:SetMoverPosition("ClassBarMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 304)
		KUI:SetMoverPosition("ElvUF_PlayerCastbarMover", "BOTTOM", E.UIParent, "BOTTOM", -265, 264)
		-- Target/TargetofTarget
		KUI:SetMoverPosition("ElvUF_TargetMover", "BOTTOM", E.UIParent, "BOTTOM", 265, 281)
		KUI:SetMoverPosition("TargetPowerBarMover", "BOTTOM", E.UIParent, "BOTTOM", 265, 281)
		KUI:SetMoverPosition("ElvUF_TargetCastbarMover", "BOTTOM", E.UIParent, "BOTTOM", 265, 264)
		KUI:SetMoverPosition("ElvUF_TargetTargetMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -479, 281)
		-- Pet
		KUI:SetMoverPosition("ElvUF_PetMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 479, 281)
		KUI:SetMoverPosition("ElvUF_PetCastbarMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 479, 264)
		-- Focus/FocusTarget
		KUI:SetMoverPosition("ElvUF_FocusMover", "BOTTOM", E.UIParent, "BOTTOM", -265, 264)
		KUI:SetMoverPosition("ElvUF_FocusCastbarMover", "BOTTOM", E.UIParent, "BOTTOM", -265, 247)
		KUI:SetMoverPosition("ElvUF_FocusTargetMover", "BOTTOM", E.UIParent, "BOTTOM", 265, 264)
		--Group
		KUI:SetMoverPosition("ElvUF_PartyMover", "TOPLEFT", E.UIParent, "BOTTOMLEFT", 10, 658)
		KUI:SetMoverPosition("ElvUF_RaidMover", "TOPLEFT", E.UIParent, "BOTTOMLEFT", 10, 915)
		KUI:SetMoverPosition("ElvUF_Raid40Mover", "TOPLEFT", E.UIParent, "BOTTOMLEFT", 10, 920)
		
		--[[----------------------------------
		--	Chat - DPS
		--]]----------------------------------
			E.db["chat"]["panelWidth"] = 400
		
		--[[----------------------------------
		--	UnitFrames - DPS
		--]]----------------------------------
		-- Party
		E.db["unitframe"]["units"]["party"]["width"] = 160
		E.db["unitframe"]["units"]["party"]["height"] = 22
		E.db["unitframe"]["units"]["party"]["growthDirection"] = "DOWN_RIGHT"
		E.db["unitframe"]["units"]["party"]["horizontalSpacing"] = 0
		E.db["unitframe"]["units"]["party"]["health"]["text_format"] = "[health:deficit-kui]"
		E.db["unitframe"]["units"]["party"]["power"]["height"] = 4
		E.db["unitframe"]["units"]["party"]["power"]["text_format"] = "[powercolor][power:current]"
		E.db["unitframe"]["units"]["party"]["name"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["party"]["name"]["text_format"] = "[name:long]"
		E.db["unitframe"]["units"]["party"]["name"]["xOffset"] = 165
		E.db["unitframe"]["units"]["party"]["roleIcon"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["party"]["roleIcon"]["attachTo"] = "Health"
		E.db["unitframe"]["units"]["party"]["roleIcon"]["xOffset"] = 2
		E.db["unitframe"]["units"]["party"]["debuffs"]["yOffset"] = 0
		E.db["unitframe"]["units"]["party"]["debuffs"]["anchorPoint"] = "CENTER"
		
		-- Raid
		E.db["unitframe"]["units"]["raid"]["width"] = 125
		E.db["unitframe"]["units"]["raid"]["height"] = 20
		E.db["unitframe"]["units"]["raid"]["groupsPerRowCol"] = 6
		E.db["unitframe"]["units"]["raid"]["growthDirection"] = "DOWN_RIGHT"
		E.db["unitframe"]["units"]["raid"]["horizontalSpacing"] = 0
		E.db["unitframe"]["units"]["raid"]["health"]["text_format"] = "[health:deficit-kui]"
		E.db["unitframe"]["units"]["raid"]["name"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["raid"]["name"]["text_format"] = "[name:long]"
		E.db["unitframe"]["units"]["raid"]["name"]["xOffset"] = 130
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["xOffset"] = 2
		E.db["unitframe"]["units"]["raid"]["debuffs"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["debuffs"]["anchorPoint"] = "CENTER"
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["yOffset"] = 0
		
		-- Raid40
		E.db["unitframe"]["units"]["raid40"]["width"] = 125
		E.db["unitframe"]["units"]["raid40"]["height"] = 15
		E.db["unitframe"]["units"]["raid40"]["groupsPerRowCol"] = 8
		E.db["unitframe"]["units"]["raid40"]["growthDirection"] = "DOWN_RIGHT"
		E.db["unitframe"]["units"]["raid40"]["horizontalSpacing"] = 0
		E.db["unitframe"]["units"]["raid40"]["health"]["text_format"] = "[health:deficit-kui]"
		E.db["unitframe"]["units"]["raid40"]["name"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["raid40"]["name"]["text_format"] = "[name:long]"
		E.db["unitframe"]["units"]["raid40"]["name"]["xOffset"] = 130
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["position"] = "LEFT"		
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["xOffset"] = 2
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["enable"] = false
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["perrow"] = 1
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["numrows"] = 1
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["sizeOverride"] = 13
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["anchorPoint"] = "CENTER"
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["yOffset"] = 0
	
	elseif layout == "dps1" then
		--[[----------------------------------
		--	Movers - DPS1
		--]]----------------------------------
		KUI:SetMoverPosition("BNETMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -10, 194)
		if E.myclass == "DRUID" then
			KUI:SetMoverPosition("SpecializationBarMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -265, 194)
		else
			KUI:SetMoverPosition("SpecializationBarMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -293, 194)
		end
		-- Player
		KUI:SetMoverPosition("ElvUF_PlayerMover", "BOTTOM", E.UIParent, "BOTTOM", -265, 281)
		KUI:SetMoverPosition("PlayerPowerBarMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 281)
		KUI:SetMoverPosition("ComboBarMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 304)
		KUI:SetMoverPosition("ClassBarMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 304)
		KUI:SetMoverPosition("ElvUF_PlayerCastbarMover", "BOTTOM", E.UIParent, "BOTTOM", -265, 264)
		-- Target/TargetofTarget
		KUI:SetMoverPosition("ElvUF_TargetMover", "BOTTOM", E.UIParent, "BOTTOM", 265, 281)
		KUI:SetMoverPosition("TargetPowerBarMover", "BOTTOM", E.UIParent, "BOTTOM", 265, 281)
		KUI:SetMoverPosition("ElvUF_TargetCastbarMover", "BOTTOM", E.UIParent, "BOTTOM", 265, 264)
		KUI:SetMoverPosition("ElvUF_TargetTargetMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -479, 281)
		-- Pet
		KUI:SetMoverPosition("ElvUF_PetMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 479, 281)
		KUI:SetMoverPosition("ElvUF_PetCastbarMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 479, 264)
		-- Focus/FocusTarget
		KUI:SetMoverPosition("ElvUF_FocusMover", "BOTTOM", E.UIParent, "BOTTOM", -265, 264)
		KUI:SetMoverPosition("ElvUF_FocusCastbarMover", "BOTTOM", E.UIParent, "BOTTOM", -265, 247)
		KUI:SetMoverPosition("ElvUF_FocusTargetMover", "BOTTOM", E.UIParent, "BOTTOM", 265, 264)
		-- Group
		KUI:SetMoverPosition("ElvUF_PartyMover", "TOPLEFT", E.UIParent, "BOTTOMLEFT", 10, 234)
		KUI:SetMoverPosition("ElvUF_RaidMover", "TOPLEFT", E.UIParent, "BOTTOMLEFT", 10, 379)
		KUI:SetMoverPosition("ElvUF_Raid40Mover", "TOPLEFT", E.UIParent, "BOTTOMLEFT", 10, 401)
		
		--[[----------------------------------
		--	Chat - DPS1
		--]]----------------------------------
			E.db["chat"]["panelWidth"] = 404
		
		--[[----------------------------------
		--	UnitFrames - DPS1
		--]]----------------------------------
		-- Party
		E.db["unitframe"]["units"]["party"]["width"] = 80
		E.db["unitframe"]["units"]["party"]["height"] = 40
		E.db["unitframe"]["units"]["party"]["growthDirection"] = "RIGHT_DOWN"
		E.db["unitframe"]["units"]["party"]["horizontalSpacing"] = 1
		E.db["unitframe"]["units"]["party"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["party"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["party"]["power"]["text_format"] = ""
		E.db["unitframe"]["units"]["party"]["name"]["position"] = "CENTER"
		E.db["unitframe"]["units"]["party"]["name"]["text_format"] = "[name:medium]"
		E.db["unitframe"]["units"]["party"]["name"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["roleIcon"]["position"] = "BOTTOMLEFT"
		E.db["unitframe"]["units"]["party"]["roleIcon"]["attachTo"] = "Frame"
		E.db["unitframe"]["units"]["party"]["roleIcon"]["xOffset"] = 2
		E.db["unitframe"]["units"]["party"]["roleIcon"]["yOffset"] = 6
		E.db["unitframe"]["units"]["party"]["debuffs"]["yOffset"] = -18
		E.db["unitframe"]["units"]["party"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
		
		-- Raid
		E.db["unitframe"]["units"]["raid"]["width"] = 80
		E.db["unitframe"]["units"]["raid"]["height"] = 30
		E.db["unitframe"]["units"]["raid"]["groupsPerRowCol"] = 1
		E.db["unitframe"]["units"]["raid"]["growthDirection"] = "RIGHT_DOWN"
		E.db["unitframe"]["units"]["raid"]["horizontalSpacing"] = 1
		E.db["unitframe"]["units"]["raid"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["raid"]["name"]["position"] = "CENTER"
		E.db["unitframe"]["units"]["raid"]["name"]["text_format"] = "[name:medium]"
		E.db["unitframe"]["units"]["raid"]["name"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["position"] = "BOTTOMLEFT"			
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["xOffset"] = 2
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["yOffset"] = 2
		E.db["unitframe"]["units"]["raid"]["debuffs"]["yOffset"] = -18
		E.db["unitframe"]["units"]["raid"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["xOffset"] = 30
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["yOffset"] = 18
		
		-- Raid40
		E.db["unitframe"]["units"]["raid40"]["width"] = 80
		E.db["unitframe"]["units"]["raid40"]["height"] = 25
		E.db["unitframe"]["units"]["raid40"]["groupsPerRowCol"] = 1
		E.db["unitframe"]["units"]["raid40"]["growthDirection"] = "RIGHT_DOWN"
		E.db["unitframe"]["units"]["raid40"]["horizontalSpacing"] = 1
		E.db["unitframe"]["units"]["raid40"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["raid40"]["name"]["position"] = "CENTER"
		E.db["unitframe"]["units"]["raid40"]["name"]["text_format"] = "[name:medium]"
		E.db["unitframe"]["units"]["raid40"]["name"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["position"] = "BOTTOMLEFT"		
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["xOffset"] = 2
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["yOffset"] = 2
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["perrow"] = 1
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["numrows"] = 1
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["sizeOverride"] = 18
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["yOffset"] = -18
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["xOffset"] = 30
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["yOffset"] = 10
		
	elseif layout == "healer" then
		--[[----------------------------------
		--	Movers - HEALER
		--]]----------------------------------
		KUI:SetMoverPosition("BNETMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 10, 194)
		KUI:SetMoverPosition("SpecializationBarMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 43, 194)		
		-- Player
		KUI:SetMoverPosition("ElvUF_PlayerMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 485, 327)
		KUI:SetMoverPosition("PlayerPowerBarMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 485, 327)
		KUI:SetMoverPosition("ComboBarMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 485, 361)
		KUI:SetMoverPosition("ClassBarMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 485, 361)
		KUI:SetMoverPosition("ElvUF_PlayerCastbarMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 485, 310)
		-- Target/TargetofTarget
		KUI:SetMoverPosition("ElvUF_TargetMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -485, 327)
		KUI:SetMoverPosition("TargetPowerBarMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -485, 327)
		KUI:SetMoverPosition("ElvUF_TargetCastbarMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -485, 310)
		KUI:SetMoverPosition("ElvUF_TargetTargetMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -394, 327)
		-- Pet
		KUI:SetMoverPosition("ElvUF_PetMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 394, 327)
		KUI:SetMoverPosition("ElvUF_PetCastbarMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 394, 310)
		-- Focus/FocusTarget
		KUI:SetMoverPosition("ElvUF_FocusMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 485, 310)
		KUI:SetMoverPosition("ElvUF_FocusCastbarMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 485, 293)
		KUI:SetMoverPosition("ElvUF_FocusTargetMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -485, 310)
		-- Group
		KUI:SetMoverPosition("ElvUF_PartyMover", "TOPLEFT", E.UIParent, "BOTTOMLEFT", 706, 264)
		KUI:SetMoverPosition("ElvUF_RaidMover", "TOPLEFT", E.UIParent, "BOTTOMLEFT", 756, 360)
		KUI:SetMoverPosition("ElvUF_Raid40Mover", "TOPLEFT", E.UIParent, "BOTTOMLEFT", 756, 360)

		--[[----------------------------------
		--	Chat - HEALER
		--]]----------------------------------
			E.db["chat"]["panelWidth"] = 400
		
		--[[----------------------------------
		--	UnitFrames - HEALER
		--]]----------------------------------
		-- Player
		E.db["unitframe"]["units"]["player"]["power"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["player"]["power"]["detachFromFrame"] = false
		E.db["unitframe"]["units"]["player"]["classbar"]["height"] = 10
		E.db["unitframe"]["units"]["player"]["classbar"]["detachedWidth"] = 250
		E.db["unitframe"]["units"]["player"]["customTexts"]["HealthText"] = {
			["font"] = "Expressway",
			["justifyH"] = "LEFT",
			["fontOutline"] = "OUTLINE",
			["text_format"] = "[health:current-percent-kui]",
			["size"] = 12,
			["attachTextTo"] = "Health",
			["xOffset"] = 4,
			["yOffset"] = 0,
		}
		E.db["unitframe"]["units"]["player"]["customTexts"]["PowerText"] = {
			["font"] = "Expressway",
			["fontOutline"] = "OUTLINE",
			["size"] = 12,
			["justifyH"] = "RIGHT",
			["text_format"] = "[powercolor][power:current]",
			["attachTextTo"] = "Health",
			["xOffset"] = -4,
		}
		
		-- Party
		E.db["unitframe"]["units"]["party"]["width"] = 100
		E.db["unitframe"]["units"]["party"]["height"] = 55
		E.db["unitframe"]["units"]["party"]["growthDirection"] = "RIGHT_DOWN"
		E.db["unitframe"]["units"]["party"]["horizontalSpacing"] = 2
		E.db["unitframe"]["units"]["party"]["verticalSpacing"] = 0
		E.db["unitframe"]["units"]["party"]["health"]["position"] = "BOTTOM"
		E.db["unitframe"]["units"]["party"]["health"]["attachTextTo"] = "Frame"
		E.db["unitframe"]["units"]["party"]["health"]["yOffset"] = 10
		E.db["unitframe"]["units"]["party"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["party"]["power"]["text_format"] = ""
		E.db["unitframe"]["units"]["party"]["name"]["position"] = "TOP"
		E.db["unitframe"]["units"]["party"]["name"]["attachTextTo"] = "Frame"
		E.db["unitframe"]["units"]["party"]["name"]["text_format"] = "[name:medium]"
		E.db["unitframe"]["units"]["party"]["name"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["name"]["yOffset"] = -10
		E.db["unitframe"]["units"]["party"]["roleIcon"]["position"] = "BOTTOMLEFT"
		E.db["unitframe"]["units"]["party"]["roleIcon"]["attachTo"] = "Frame"
		E.db["unitframe"]["units"]["party"]["roleIcon"]["xOffset"] = 2
		E.db["unitframe"]["units"]["party"]["roleIcon"]["yOffset"] = 6
		E.db["unitframe"]["units"]["party"]["debuffs"]["yOffset"] = -20
		E.db["unitframe"]["units"]["party"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
			
		-- Raid
		E.db["unitframe"]["units"]["raid"]["width"] = 80
		E.db["unitframe"]["units"]["raid"]["height"] = 40
		E.db["unitframe"]["units"]["raid"]["groupsPerRowCol"] = 1
		E.db["unitframe"]["units"]["raid"]["growthDirection"] = "RIGHT_DOWN"
		E.db["unitframe"]["units"]["raid"]["horizontalSpacing"] = 2
		E.db["unitframe"]["units"]["raid"]["verticalSpacing"] = 2
		E.db["unitframe"]["units"]["raid"]["health"]["position"] = "BOTTOM"
		E.db["unitframe"]["units"]["raid"]["health"]["yOffset"] = 6
		E.db["unitframe"]["units"]["raid"]["name"]["position"] = "TOP"
		E.db["unitframe"]["units"]["raid"]["name"]["text_format"] = "[name:medium]"
		E.db["unitframe"]["units"]["raid"]["name"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["name"]["yOffset"] = -6
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["position"] = "BOTTOMLEFT"
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["xOffset"] = 2
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["yOffset"] = 2
		E.db["unitframe"]["units"]["raid"]["debuffs"]["yOffset"] = -20
		E.db["unitframe"]["units"]["raid"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
			
		-- Raid40
		E.db["unitframe"]["units"]["raid40"]["width"] = 80
		E.db["unitframe"]["units"]["raid40"]["height"] = 30
		E.db["unitframe"]["units"]["raid40"]["groupsPerRowCol"] = 1
		E.db["unitframe"]["units"]["raid40"]["growthDirection"] = "RIGHT_DOWN"
		E.db["unitframe"]["units"]["raid40"]["horizontalSpacing"] = 2
		E.db["unitframe"]["units"]["raid40"]["verticalSpacing"] = 2
		E.db["unitframe"]["units"]["raid40"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["raid40"]["name"]["position"] = "CENTER"
		E.db["unitframe"]["units"]["raid40"]["name"]["text_format"] = "[name:medium]"
		E.db["unitframe"]["units"]["raid40"]["name"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["position"] = "BOTTOMLEFT"
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["xOffset"] = 2
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["xOffset"] = 2
	end
	
	E:StaggeredUpdateAll(nil, true)

	PluginInstallStepComplete.message = KUI.Title..L["UnitFrames Set"]
	PluginInstallStepComplete:Show()
end

function KUI:SetupActionbars(layout)
	--[[----------------------------------
	--	ActionBars - General
	--]]----------------------------------
	E.db["actionbar"]["font"] = "Expressway"
	E.db["actionbar"]["fontOutline"] = "OUTLINE"
	E.db["actionbar"]["fontSize"] = 12
	if KUI.IsDeveloper() and T.IsAddOnLoaded("Masque") then
		E.db["actionbar"]["hotkeytext"] = false
	else
		E.db["actionbar"]["hotkeytext"] = true
	end
	E.db["actionbar"]["macrotext"] = false
	E.db["actionbar"]["lockActionBars"] = true
	E.db["actionbar"]["globalFadeAlpha"] = 0
	E.db["actionbar"]["desaturateOnCooldown"] = true
	E.db["actionbar"]["transparent"] = true

	-- Cooldown options
	E.db["actionbar"]["cooldown"]["override"] = false
	E.db["actionbar"]["cooldown"]["mmssThreshold"] = 141
	E.db["actionbar"]["cooldown"]["fonts"]["enable"] = true
	E.db["actionbar"]["cooldown"]["fonts"]["font"] = "Expressway"
	E.db["actionbar"]["cooldown"]["fonts"]["fontOutline"] = "OUTLINE"
	E.db["actionbar"]["cooldown"]["fonts"]["fontSize"] = 18

	if T.IsAddOnLoaded("Masque") then
		E.private["actionbar"]["masque"]["stanceBar"] = true
		E.private["actionbar"]["masque"]["petBar"] = true
		E.private["actionbar"]["masque"]["actionbars"] = true
	end

	--[[----------------------------------
	--	ActionBars - layout
	--]]----------------------------------
	E.db["actionbar"]["bar1"]["enabled"] = true
	E.db["actionbar"]["bar1"]["mouseover"] = false
	E.db["actionbar"]["bar1"]["buttons"] = 8
	E.db["actionbar"]["bar1"]["buttonsPerRow"] = 12
	E.db["actionbar"]["bar1"]["point"] = "BOTTOMLEFT"
	E.db["actionbar"]["bar1"]["backdrop"] = false
	E.db["actionbar"]["bar1"]["heightMult"] = 1
	E.db["actionbar"]["bar1"]["widthMult"] = 1
	E.db["actionbar"]["bar1"]["buttonsize"] = 30
	E.db["actionbar"]["bar1"]["buttonspacing"] = 1
	E.db["actionbar"]["bar1"]["backdropSpacing"] = 0
	E.db["actionbar"]["bar1"]["alpha"] = 1
	E.db["actionbar"]["bar1"]["inheritGlobalFade"] = false
	E.db["actionbar"]["bar1"]["showGrid"] = true
	
	E.db["actionbar"]["bar2"]["enabled"] = true
	E.db["actionbar"]["bar2"]["mouseover"] = false
	E.db["actionbar"]["bar2"]["buttons"] = 8
	E.db["actionbar"]["bar2"]["buttonsPerRow"] = 12
	E.db["actionbar"]["bar2"]["point"] = "BOTTOMLEFT"
	E.db["actionbar"]["bar2"]["backdrop"] = false
	E.db["actionbar"]["bar2"]["heightMult"] = 1
	E.db["actionbar"]["bar2"]["widthMult"] = 1
	E.db["actionbar"]["bar2"]["buttonsize"] = 30
	E.db["actionbar"]["bar2"]["buttonspacing"] = 1
	E.db["actionbar"]["bar2"]["backdropSpacing"] = 0
	E.db["actionbar"]["bar2"]["alpha"] = 1
	E.db["actionbar"]["bar2"]["inheritGlobalFade"] = false
	E.db["actionbar"]["bar2"]["showGrid"] = true

	E.db["actionbar"]["bar3"]["enabled"] = true
	E.db["actionbar"]["bar3"]["mouseover"] = false
	E.db["actionbar"]["bar3"]["buttons"] = 8
	E.db["actionbar"]["bar3"]["buttonsPerRow"] = 12
	E.db["actionbar"]["bar3"]["point"] = "BOTTOMLEFT"
	E.db["actionbar"]["bar3"]["backdrop"] = false
	E.db["actionbar"]["bar3"]["heightMult"] = 1
	E.db["actionbar"]["bar3"]["widthMult"] = 1
	E.db["actionbar"]["bar3"]["buttonsize"] = 30
	E.db["actionbar"]["bar3"]["buttonspacing"] = 1
	E.db["actionbar"]["bar3"]["backdropSpacing"] = 0
	E.db["actionbar"]["bar3"]["alpha"] = 1
	E.db["actionbar"]["bar3"]["inheritGlobalFade"] = false
	E.db["actionbar"]["bar3"]["showGrid"] = true
	
	if KUI:IsDeveloper() then 
		E.db["actionbar"]["bar4"]["enabled"] = true
	else
		E.db["actionbar"]["bar4"]["enabled"] = false
	end
	E.db["actionbar"]["bar4"]["mouseover"] = false
	E.db["actionbar"]["bar4"]["buttons"] = 6
	E.db["actionbar"]["bar4"]["buttonsPerRow"] = 1
	E.db["actionbar"]["bar4"]["point"] = "BOTTOMLEFT"
	E.db["actionbar"]["bar4"]["backdrop"] = false
	E.db["actionbar"]["bar4"]["heightMult"] = 1
	E.db["actionbar"]["bar4"]["widthMult"] = 1
	E.db["actionbar"]["bar4"]["buttonsize"] = 30
	E.db["actionbar"]["bar4"]["buttonspacing"] = 1
	E.db["actionbar"]["bar4"]["backdropSpacing"] = 0
	E.db["actionbar"]["bar4"]["alpha"] = 1
	E.db["actionbar"]["bar4"]["inheritGlobalFade"] = false
	E.db["actionbar"]["bar4"]["showGrid"] = true
	
	if KUI:IsDeveloper() then 
		E.db["actionbar"]["bar5"]["enabled"] = true
	else
		E.db["actionbar"]["bar5"]["enabled"] = false
	end
	E.db["actionbar"]["bar5"]["mouseover"] = false
	E.db["actionbar"]["bar5"]["buttons"] = 6
	E.db["actionbar"]["bar5"]["buttonsPerRow"] = 1
	E.db["actionbar"]["bar5"]["point"] = "BOTTOMLEFT"
	E.db["actionbar"]["bar5"]["backdrop"] = false
	E.db["actionbar"]["bar5"]["heightMult"] = 1
	E.db["actionbar"]["bar5"]["widthMult"] = 1
	E.db["actionbar"]["bar5"]["buttonsize"] = 30
	E.db["actionbar"]["bar5"]["buttonspacing"] = 1
	E.db["actionbar"]["bar5"]["backdropSpacing"] = 0
	E.db["actionbar"]["bar5"]["alpha"] = 1
	E.db["actionbar"]["bar5"]["inheritGlobalFade"] = false
	E.db["actionbar"]["bar5"]["showGrid"] = true
	
	E.db["actionbar"]["bar6"]["enabled"] = true
	if KUI:IsDeveloper() then
		E.db["actionbar"]["bar6"]["mouseover"] = false
	else
		E.db["actionbar"]["bar6"]["mouseover"] = true
	end
	E.db["actionbar"]["bar6"]["buttons"] = 12
	E.db["actionbar"]["bar6"]["buttonsPerRow"] = 12
	E.db["actionbar"]["bar6"]["point"] = "BOTTOMLEFT"
	E.db["actionbar"]["bar6"]["backdrop"] = false
	E.db["actionbar"]["bar6"]["heightMult"] = 1
	E.db["actionbar"]["bar6"]["widthMult"] = 1
	E.db["actionbar"]["bar6"]["buttonsize"] = 30
	E.db["actionbar"]["bar6"]["buttonspacing"] = 1
	E.db["actionbar"]["bar6"]["backdropSpacing"] = 0
	E.db["actionbar"]["bar6"]["alpha"] = 1
	E.db["actionbar"]["bar6"]["inheritGlobalFade"] = false
	E.db["actionbar"]["bar6"]["showGrid"] = true
	
	E.db["actionbar"]["barPet"]["enabled"] = true
	E.db["actionbar"]["barPet"]["mouseover"] = false
	E.db["actionbar"]["barPet"]["style"] = "darkenInactive"
	E.db["actionbar"]["barPet"]["buttons"] = NUM_STANCE_SLOTS
	E.db["actionbar"]["barPet"]["buttonsPerRow"] = NUM_STANCE_SLOTS
	E.db["actionbar"]["barPet"]["point"] = "BOTTOMLEFT"
	E.db["actionbar"]["barPet"]["backdrop"] = false
	E.db["actionbar"]["barPet"]["heightMult"] = 1
	E.db["actionbar"]["barPet"]["widthMult"] = 1
	E.db["actionbar"]["barPet"]["buttonsize"] = 20
	E.db["actionbar"]["barPet"]["buttonspacing"] = 1
	E.db["actionbar"]["barPet"]["backdropSpacing"] = 0
	E.db["actionbar"]["barPet"]["alpha"] = 1
	E.db["actionbar"]["barPet"]["inheritGlobalFade"] = false
	E.db["actionbar"]["barPet"]["showGrid"] = true

	E.db["actionbar"]["stanceBar"]["enabled"] = false
	E.db["actionbar"]["stanceBar"]["mouseover"] = true
	E.db["actionbar"]["stanceBar"]["style"] = "darkenInactive"
	E.db["actionbar"]["stanceBar"]["buttons"] = NUM_STANCE_SLOTS
	E.db["actionbar"]["stanceBar"]["buttonsPerRow"] = NUM_STANCE_SLOTS
	E.db["actionbar"]["stanceBar"]["point"] = "BOTTOMLEFT"
	E.db["actionbar"]["stanceBar"]["backdrop"] = false
	E.db["actionbar"]["stanceBar"]["heightMult"] = 1
	E.db["actionbar"]["stanceBar"]["widthMult"] = 1
	E.db["actionbar"]["stanceBar"]["buttonsize"] = 30
	E.db["actionbar"]["stanceBar"]["buttonspacing"] = 1
	E.db["actionbar"]["stanceBar"]["backdropSpacing"] = 0
	E.db["actionbar"]["stanceBar"]["alpha"] = 1
	E.db["actionbar"]["stanceBar"]["inheritGlobalFade"] = false
	E.db["actionbar"]["stanceBar"]["showGrid"] = true

	E.db["actionbar"]["microbar"]["enabled"] = false
	E.db["actionbar"]["microbar"]["mouseover"] = true
	E.db["actionbar"]["microbar"]["buttonsPerRow"] = 12
	E.db["actionbar"]["microbar"]["alpha"] = 1
	
	E.db["actionbar"]["extraActionButton"]["alpha"] = 1
	E.db["actionbar"]["extraActionButton"]["scale"] = 0.75
	E.db["actionbar"]["extraActionButton"]["inheritGlobalFade"] = false
	
	KUI:SetMoverPosition("ShiftAB", "TOPLEFT", E.UIParent, "BOTTOMLEFT", 959, 172)
	KUI:SetMoverPosition("MicrobarMover", "TOPLEFT", E.UIParent, "TOPLEFT", 10, -10)
	
	if layout == "dps" then
		--[[----------------------------------
		--	Movers - DPS
		--]]----------------------------------
		KUI:SetMoverPosition("ElvAB_1", "BOTTOM", E.UIParent, "BOTTOM", 0, 248)
		KUI:SetMoverPosition("ElvAB_2", "BOTTOM", E.UIParent, "BOTTOM", 0, 217)
		KUI:SetMoverPosition("ElvAB_3", "BOTTOM", E.UIParent, "BOTTOM", 0, 186)
		KUI:SetMoverPosition("ElvAB_4", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 411, 8)
		KUI:SetMoverPosition("ElvAB_5", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -411, 8)
		KUI:SetMoverPosition("ElvAB_6", "BOTTOM", E.UIParent, "BOTTOM", 0, 30)		
		KUI:SetMoverPosition("PetAB", "BOTTOM", E.UIParent, "BOTTOM", 0, 165)
		KUI:SetMoverPosition("BossButton", "BOTTOM", E.UIParent, "BOTTOM", 0, 90)
		KUI:SetMoverPosition("ZoneAbility", "BOTTOM", E.UIParent, "BOTTOM", 0, 90)
		KUI:SetMoverPosition("KuiMiddleDTPanel", "BOTTOM", E.UIParent, "BOTTOM", 0, 8)
		
		--[[----------------------------------
		--	ActionBars - DPS
		--]]----------------------------------
		if KUI:IsDeveloper() then
			E.db["actionbar"]["bar6"]["mouseover"] = false
		else
			E.db["actionbar"]["bar6"]["mouseover"] = true
		end
		E.db["actionbar"]["bar6"]["buttons"] = 12
	
	elseif layout == "dps1" then
		--[[----------------------------------
		--	Movers - DPS
		--]]----------------------------------
		KUI:SetMoverPosition("ElvAB_1", "BOTTOM", E.UIParent, "BOTTOM", 0, 248)
		KUI:SetMoverPosition("ElvAB_2", "BOTTOM", E.UIParent, "BOTTOM", 0, 217)
		KUI:SetMoverPosition("ElvAB_3", "BOTTOM", E.UIParent, "BOTTOM", 0, 186)
		KUI:SetMoverPosition("ElvAB_4", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 415, 8)
		KUI:SetMoverPosition("ElvAB_5", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -415, 8)
		KUI:SetMoverPosition("ElvAB_6", "BOTTOM", E.UIParent, "BOTTOM", 0, 30)		
		KUI:SetMoverPosition("PetAB", "BOTTOM", E.UIParent, "BOTTOM", 0, 165)
		KUI:SetMoverPosition("BossButton", "BOTTOM", E.UIParent, "BOTTOM", 0, 90)
		KUI:SetMoverPosition("ZoneAbility", "BOTTOM", E.UIParent, "BOTTOM", 0, 90)
		KUI:SetMoverPosition("KuiMiddleDTPanel", "BOTTOM", E.UIParent, "BOTTOM", 0, 8)
		
		--[[----------------------------------
		--	ActionBars - DPS
		--]]----------------------------------
		if KUI:IsDeveloper() then
			E.db["actionbar"]["bar6"]["mouseover"] = false
		else
			E.db["actionbar"]["bar6"]["mouseover"] = true
		end
		E.db["actionbar"]["bar6"]["buttons"] = 12	
	
	elseif layout == "healer" then
		--[[----------------------------------
		--	Movers - HEALER
		--]]----------------------------------
		KUI:SetMoverPosition("ElvAB_1", "BOTTOM", E.UIParent, "BOTTOM", -124, 30)
		KUI:SetMoverPosition("ElvAB_2", "BOTTOM", E.UIParent, "BOTTOM", 124, 30)
		KUI:SetMoverPosition("ElvAB_3", "BOTTOM", E.UIParent, "BOTTOM", -124, 61)
		KUI:SetMoverPosition("ElvAB_4", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 411, 8)
		KUI:SetMoverPosition("ElvAB_5", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -411, 8)
		KUI:SetMoverPosition("ElvAB_6", "BOTTOM", E.UIParent, "BOTTOM", 124, 61)
		KUI:SetMoverPosition("PetAB", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 201, 194)		
		KUI:SetMoverPosition("BossButton", "TOPLEFT", E.UIParent, "TOPLEFT", 60, -274)
		KUI:SetMoverPosition("ZoneAbility", "TOPLEFT", E.UIParent, "TOPLEFT", 60, -274)

		--[[----------------------------------
		--	ActionBars - HEALER
		--]]----------------------------------
		E.db["actionbar"]["bar6"]["mouseover"] = false
		E.db["actionbar"]["bar6"]["buttons"] = 8
	end
	
	E:StaggeredUpdateAll(nil, true)

	PluginInstallStepComplete.message = KUI.Title..L["ActionBars Set"]
	PluginInstallStepComplete:Show()
end

function KUI:SetupDts(layout)
	--[[----------------------------------
	--	ProfileDB - Datatexts
	--]]----------------------------------
	E.db["datatexts"]["font"] = "Expressway"
	E.db["datatexts"]["fontSize"] = 12
	E.db["datatexts"]["fontOutline"] = "OUTLINE"
	E.db["datatexts"]["time24"] = true
	E.db["datatexts"]["goldFormat"] = "CONDENSED"
	E.db["datatexts"]["goldCoins"] = false
	E.db["datatexts"]["noCombatHover"] = true
	E.db["datatexts"]["panelTransparency"] = true
	E.db["datatexts"]["wordWrap"] = true
	E.db["datatexts"]["battleground"] = false

	E.db["datatexts"]["leftChatPanel"] = false
	E.db["datatexts"]["rightChatPanel"] = false
	E.db["datatexts"]["minimapPanels"] = false
	E.db["datatexts"]["minimapTop"] = false
	E.db["datatexts"]["minimapTopLeft"] = false
	E.db["datatexts"]["minimapTopRight"] = false
	E.db["datatexts"]["minimapBottom"] = true
	E.db["datatexts"]["minimapBottomLeft"] = false
	E.db["datatexts"]["minimapBottomRight"] = false
	
	-- Define the default ElvUI datatexts panels
	E.db["datatexts"]["panels"]["LeftChatDataPanel"]["left"] = ""
	E.db["datatexts"]["panels"]["LeftChatDataPanel"]["middle"] = ""
	E.db["datatexts"]["panels"]["LeftChatDataPanel"]["right"] = ""
	E.db["datatexts"]["panels"]["RightChatDataPanel"]["left"] = ""
	E.db["datatexts"]["panels"]["RightChatDataPanel"]["middle"] = ""
	E.db["datatexts"]["panels"]["RightChatDataPanel"]["right"] = ""
	E.db["datatexts"]["panels"]["LeftMiniPanel"] = ""
	E.db["datatexts"]["panels"]["RightMiniPanel"] = ""
	E.db["datatexts"]["panels"]["BottomMiniPanel"] = "Time (KUI)"
	E.db["datatexts"]["panels"]["TopMiniPanel"] = ""
	E.db["datatexts"]["panels"]["BottomLeftMiniPanel"] = ""
	E.db["datatexts"]["panels"]["BottomRightMiniPanel"] = ""
	E.db["datatexts"]["panels"]["TopRightMiniPanel"] = ""
	E.db["datatexts"]["panels"]["TopLeftMiniPanel"] = ""
	
	-- Define the KlixUI datatexts panels
	E.db["datatexts"]["panels"]["KuiLeftChatDTPanel"]["left"] = "Combat Time"
	E.db["datatexts"]["panels"]["KuiLeftChatDTPanel"]["middle"] = "Durability"
	E.db["datatexts"]["panels"]["KuiLeftChatDTPanel"]["right"] = "DPS"
	E.db["datatexts"]["panels"]["KuiRightChatDTPanel"]["left"] = "System (KUI)"
	E.db["datatexts"]["panels"]["KuiRightChatDTPanel"]["middle"] = "Bags"
	if T.IsAddOnLoaded("ElvUI_EnhancedCurrency") then
		E.db["datatexts"]["panels"]["KuiRightChatDTPanel"]["right"] = "Enhanced Currency"
	else
		E.db["datatexts"]["panels"]["KuiRightChatDTPanel"]["right"] = "Gold"
	end
	
	if layout == "dps" then
		-- Define the KlixUI middle datatexts panel
		if T.IsAddOnLoaded("Masque") and T.IsAddOnLoaded("Masque_KlixUI") then
			E.db["KlixUI"]["datatexts"]["middle"]["width"] = 370
		else
			E.db["KlixUI"]["datatexts"]["middle"]["width"] = 373
		end
	
	elseif layout == "healer" then
		-- define the KlixUI middle datatexts panel
		if T.IsAddOnLoaded("Masque") and T.IsAddOnLoaded("Masque_KlixUI") then
			E.db["KlixUI"]["datatexts"]["middle"]["width"] = 494
		else
			E.db["KlixUI"]["datatexts"]["middle"]["width"] = 495
		end
	end
		
	E:StaggeredUpdateAll(nil, true)

	PluginInstallStepComplete.message = KUI.Title..L["DataTexts Set"]
	PluginInstallStepComplete:Show()
end

local addonNames = {}
local profilesFailed = format('|cfff960d9%s |r', L["KlixUI didn't find any supported addons for profile creation!"])

KUI.isInstallerRunning = false

local function SetupAddons()
	KUI.isInstallerRunning = true -- don't print when applying profile that doesn't exist

	-- AddOnSkins
	if T.IsAddOnLoaded('AddOnSkins') then
		KUI:LoadAddOnSkinsProfile()
		T.table_insert(addonNames, 'AddOnSkins')
	end
	
	-- BigWigs
	if T.IsAddOnLoaded('BigWigs') then
		KUI:LoadBigWigsProfile()
		T.table_insert(addonNames, 'BigWigs')
	end
	
	-- ClassicThreatMeter
	if T.IsAddOnLoaded('ClassicThreatMeter') then
		KUI:LoadClassicThreatMeterProfile()
		T.table_insert(addonNames, 'Classic Threat Meter')
	end
	
	-- DBM
	if T.IsAddOnLoaded('DBM-Core') then
		KUI:LoadDBMProfile()
		T.table_insert(addonNames, 'Deadly Boss Mods')
	end
	
	-- Details
	if T.IsAddOnLoaded('Details') then
		KUI:LoadDetailsProfile()
		T.table_insert(addonNames, 'Details')
	end

	-- ls_Toasts
	if T.IsAddOnLoaded('ls_Toasts') then
		KUI:LoadLSProfile()
		T.table_insert(addonNames, 'ls_Toasts')
	end
	
	-- Masque
	if T.IsAddOnLoaded('Masque') then
		KUI:LoadMasqueProfile()
		T.table_insert(addonNames, 'Masque')
	end
	
	-- ProjectAzilroka
	if T.IsAddOnLoaded('ProjectAzilroka') then
		KUI:LoadPAProfile()
		T.table_insert(addonNames, 'ProjectAzilroka')
	end
	
	-- Shadow & Light
	if T.IsAddOnLoaded('ElvUI_SLE') then
		KUI:LoadSLEProfile()
		T.table_insert(addonNames, 'Shadow & Light')
	end
	
	-- XIV_Databar
	if T.IsAddOnLoaded('XIV_Databar') then
		KUI:LoadXIVProfile()
		T.table_insert(addonNames, 'XIV_Databar')
	end
	
	if T.next(addonNames) ~= nil then
		local profileString = T.string_format('|cfffff400%s |r', L['KlixUI successfully created and applied profile(s) for:']..'\n')

		T.table_sort(addonNames, function(a, b) return a < b end)
		local names = T.table_concat(addonNames, ", ")
		profileString = profileString..names

		PluginInstallFrame.Desc4:SetText(profileString..'.')
	else
		PluginInstallFrame.Desc4:SetText(profilesFailed)
	end
	
	T.table_wipe(addonNames)
	E:StaggeredUpdateAll(nil, true)
	
	PluginInstallStepComplete.message = KUI.Title..L['Addons Set']
	PluginInstallStepComplete:Show()
end

local function InstallComplete()
	E.private.install_complete = E.version
	E.db.KlixUI.installed = true
	E.private.KlixUI.install_complete = KUI.Version

	T.ReloadUI()
end

-- ElvUI PlugIn installer
KUI.installTable = {
	["Name"] = "|cfff960d9KlixUI|r",
	["Title"] = L["|cfff960d9KlixUI|r Installation"],
	["tutorialImage"] = "Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\KlixUI.tga",
	["Pages"] = {
		[1] = function()
			PluginInstallTutorialImage:Size(248, 128)
			PluginInstallTutorialImage:Point('BOTTOM', 0, 65)
			PluginInstallFrame.SubTitle:SetFormattedText(L["Welcome to |cfff960d9KlixUI|r version |cfff960d9%s|r, for |cfffe7b2cElvUI|r version |cfffe7b2c%s|r."], KUI.Version, E.version)
			PluginInstallFrame.Desc1:SetText(L["This installation process will guide you through a few steps and apply settings to your current ElvUI profile. If you want to be able to go back to your original settings then create a new profile in the next installation step."])
			PluginInstallFrame.Desc2:SetText(KUI:cOption(L["Some KlixUI options are marked with pink color, inside ElvUI options."]))
			PluginInstallFrame.Desc3:SetText(L["Please click the continue button to go onto the next step."])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() InstallComplete() end)
			PluginInstallFrame.Option1:SetText(L["Skip Process"])
		end,
		[2] = function()
			PluginInstallFrame.SubTitle:SetText("Profiles")
			PluginInstallFrame.Desc1:SetText("This part of the installation process lets you create a new profile or install |cfff960d9KlixUI|r settings to your current profile.")
			PluginInstallFrame.Desc2:SetText("|cffff8000Your currently active ElvUI profile is:|r |cfff960d9"..ElvUI[1].data:GetCurrentProfile().."|r")
			PluginInstallFrame.Desc3:SetText(L['Importance: |cffff006bVery High|r'])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() KUI:NewProfile(false) end)
			PluginInstallFrame.Option1:SetText("Use Current")
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function() KUI:NewProfile(true, "KlixUI") end)
			PluginInstallFrame.Option2:SetText("Create New")
		end,
		[3] = function()
			PluginInstallFrame.SubTitle:SetText(L["CVars"])
			PluginInstallFrame.Desc1:SetText(L["This part of the installation process sets up your World of Warcraft default options it is recommended you should do this step for everything to behave properly."])
			PluginInstallFrame.Desc2:SetText(L["Please click the button below to setup your CVars."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cffff0000High|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() SetupCVars() end)
			PluginInstallFrame.Option1:SetText(L["Setup CVars"])
		end,
		[4] = function()
			PluginInstallFrame.SubTitle:SetText(L["Chat"])
			PluginInstallFrame.Desc1:SetText(L["This part of the installation process sets up your chat windows names, positions and colors."])
			PluginInstallFrame.Desc2:SetText(L["The chat windows function the same as Blizzard standard chat windows, you can right click the tabs and drag them around, rename, etc. Please click the button below to setup your chat windows."])
			PluginInstallFrame.Desc3:SetText(L["Please click the button below to setup your Chat windows."])
			PluginInstallFrame.Desc4:SetText(L["Importance: |cffD3CF00Medium|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() SetupChat() end)
			PluginInstallFrame.Option1:SetText(L['Setup Chat'])
		end,
		[5] = function()
			PluginInstallFrame.SubTitle:SetText(L["Layout"])
			PluginInstallFrame.Desc1:SetText(L["This part of the installation changes the default ElvUI look."])
			PluginInstallFrame.Desc2:SetText(L["Please click the button below to apply the new layout."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cffff0000High|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() KUI:SetupLayout() end)
			PluginInstallFrame.Option1:SetText(L["Layout"])
		end,
		[6] = function()
			PluginInstallFrame.SubTitle:SetText(L["UnitFrames"])
			PluginInstallFrame.Desc1:SetText(L["This part of the installation process will reposition your Unitframes depending on your specialization."])
			PluginInstallFrame.Desc2:SetText(L['|cffff8000DPS & Tank v1: This layout will set the party/raidframes vertically.\nDPS & Tank v2: This layout will set the party/raidframes squared.\nHealer: This layout will set the UnitFrames for healing mode.|r'])
			PluginInstallFrame.Desc3:SetText(L["Please click the button below |cff22ff00TWICE|r to setup your preferred Unitframe layout."])
			PluginInstallFrame.Desc4:SetText(L["Importance: |cffff0000High|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript('OnClick', function() KUI:SetupUnitframes('dps') end)
			PluginInstallFrame.Option1:SetText(L['DPS & Tank v1'])
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript('OnClick', function() KUI:SetupUnitframes('dps1') end)
			PluginInstallFrame.Option2:SetText(L['DPS & Tank v2'])
			PluginInstallFrame.Option3:Show()
			PluginInstallFrame.Option3:SetScript('OnClick', function() KUI:SetupUnitframes('healer') end)
			PluginInstallFrame.Option3:SetText(L['Healer'])
		end,
		[7] = function()
			PluginInstallFrame.SubTitle:SetText(L["ActionBars"])
			PluginInstallFrame.Desc1:SetText(L["This part of the installation process will reposition your ActioBar depending on your specialization."])
			PluginInstallFrame.Desc2:SetText(L['|cffff8000DPS & Tank v1: This layout will set the ActionBars accordingly to the v1 UnitFrame layout.\nDPS & Tank v2: This layout will set the ActionBars accordingly to the v2 UnitFrame layout.\nHealer: This layout will set the ActionBars accordingly to the Healer Unitframe layout|r'])
			PluginInstallFrame.Desc3:SetText(L["Please click the button below |cff22ff00TWICE|r to setup your ActionBar layout."])
			PluginInstallFrame.Desc4:SetText(L["Importance: |cffff0000High|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript('OnClick', function() KUI:SetupActionbars('dps') end)
			PluginInstallFrame.Option1:SetText(L['DPS & Tank v1'])
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript('OnClick', function() KUI:SetupActionbars('dps1') end)
			PluginInstallFrame.Option2:SetText(L['DPS & Tank v2'])
			PluginInstallFrame.Option3:Show()
			PluginInstallFrame.Option3:SetScript('OnClick', function() KUI:SetupActionbars('healer') end)
			PluginInstallFrame.Option3:SetText(L['Healer'])
		end,
		[8] = function()
			PluginInstallFrame.SubTitle:SetText(L["DataTexts"])
			PluginInstallFrame.Desc1:SetText(L["This part of the installation process will fill |cfff960d9KlixUI|r datatexts.\r|cffff8000This doesn't touch ElvUI datatexts|r"])
			PluginInstallFrame.Desc2:SetText(L['|cffff8000DPS & Tank: This layout will set the DataTexts accordingly to the DPS & Tank v1/v2 layout.\nHealer: This layout will set the DataTexts accordingly to the Healer layout.\n\n Furthermore it will apply the best secondary stat for your class/specialization to the Middle DataTexts panel.|r'])
			PluginInstallFrame.Desc3:SetText(L["Please click the button below to setup your datatexts."])
			PluginInstallFrame.Desc4:SetText(L["Importance: |cffD3CF00Medium|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript('OnClick', function() KUI:SetupDts('dps') end)
			PluginInstallFrame.Option1:SetText(L['DPS & Tank'])
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript('OnClick', function() KUI:SetupDts('healer') end)
			PluginInstallFrame.Option2:SetText(L['Healer'])
		end,
		[9] = function()
			PluginInstallFrame.SubTitle:SetFormattedText("%s", ADDONS)
			PluginInstallFrame.Desc1:SetText(L["This part of the installation process will create and apply profiles for the |cfff960d9KlixUI|r supported addons"])
			PluginInstallFrame.Desc2:SetText(L["Please click the button below to setup your addons."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cffD3CF00Medium|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() SetupAddons() end)
			PluginInstallFrame.Option1:SetText(L["Setup Addons"])
		end,
		[10] = function()
			PluginInstallFrame.SubTitle:SetText(L["Installation Complete"])
			PluginInstallFrame.Desc1:SetText(L["You are now finished with the installation process. If you are in need of technical support please visit us at http://www.tukui.org."])
			PluginInstallFrame.Desc2:SetText(L['Please click the "finished" button below in order to finalize the process and automatically reload your UI.\n\n|cffff8000Please click the "Join Discord" button below if you want to join us on discord and copy the url in the popup box.|r\n\n\n|cffff0000Important:|r Restart the game to apply fonts'])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() InstallComplete() end)
			PluginInstallFrame.Option1:SetText(L["Finished"])
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function() E:StaticPopup_Show("DISCORD", nil, nil, "https://discord.gg/GbQbDRX") end)
			PluginInstallFrame.Option2:SetText("Join Discord")

			if InstallStepComplete then
				InstallStepComplete.message = KUI.Title..L["Installed"]
				InstallStepComplete:Show()
			end
		end,
	},

	["StepTitles"] = {
		[1] = START,
		[2] = L["Profiles"],
		[3] = L["CVars"],
		[4] = L["Chat"],
		[5] = L["Layout"],
		[6] = L["UnitFrames"],
		[7] = L["ActionBars"],
		[8] = L["DataTexts"],
		[9] = ADDONS,
		[10] = L["Installation Complete"],
	},
	StepTitlesColor = {1, 1, 1},
	StepTitlesColorSelected = {249/255, 96/255, 217/255},
	StepTitleWidth = 200,
	StepTitleButtonWidth = 200,
	StepTitleTextJustification = "CENTER",
}