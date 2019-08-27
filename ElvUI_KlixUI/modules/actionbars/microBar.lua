local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local MB = KUI:NewModule("MicroBar", "AceTimer-3.0", "AceEvent-3.0")
local KS = KUI:GetModule("KuiSkins")

local BOOKTYPE_SPELL = BOOKTYPE_SPELL

local microBar

local DELAY = 5
local elapsed = DELAY - 5

local microBar = T.CreateFrame("Frame", KUI.Title.."MicroBar", E.UIParent)

local function OnHover(button)
if not MB.db.highlight.enable then return end
	local buttonHighlight = "Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\highlight"

	if button.tex then
		if MB.db.text.colors.customColor == 1 then
		button.tex:SetVertexColor(KUI.r, KUI.g, KUI.b)
		elseif MB.db.text.colors.customColor == 2 then
		button.tex:SetVertexColor(KUI:unpackColor(MB.db.text.colors.userColor))
		else
		button.tex:SetVertexColor(KUI:unpackColor(E.db.general.valuecolor))
		end
		
		if MB.db.highlight.buttons then
		button.highlight = button:CreateTexture(nil, "HIGHLIGHT")
		else
		button.highlight = button:CreateTexture(nil, "HIGHLIGHT")
		button.highlight:SetPoint("TOPLEFT", button.tex, "TOPLEFT", -4, 1)
		button.highlight:SetPoint("BOTTOMRIGHT", button.tex, "BOTTOMRIGHT", 4, -1)
		end
		
		if MB.db.text.colors.customColor == 1 then
		button.highlight:SetVertexColor(KUI.r, KUI.g, KUI.b)
		elseif MB.db.text.colors.customColor == 2 then
		button.highlight:SetVertexColor(KUI:unpackColor(MB.db.text.colors.userColor))
		else
		button.highlight:SetVertexColor(KUI:unpackColor(E.db.general.valuecolor))
		end
		
		button.highlight:SetTexture(buttonHighlight)
		button.highlight:SetBlendMode("ADD")
	end
end

local function OnLeave(button)
if not MB.db.highlight.enable then return end
	if button.tex then
		button.tex:SetVertexColor(.6, .6, .6)
		button.highlight:Hide()
	end
end

function MB:OnClick(btn)
	if T.InCombatLockdown() then return end
end

function MB:CreateMicroBar()
	microBar = T.CreateFrame("Frame", KUI.Title.."MicroBar", E.UIParent)
	microBar:SetFrameStrata("HIGH")
	microBar:EnableMouse(true)
	microBar:SetSize(360, 26)
	microBar:SetScale(MB.db.scale or 1)
	microBar:Point("TOP", E.UIParent, "TOP", 0, -10)
	microBar:SetTemplate("Transparent")
	microBar:Styling()
	E.FrameLocks[microBar] = true

	local IconPath = "Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\icons\\"

	--Config
	local configButton = T.CreateFrame("Button", nil, microBar)
	configButton:SetPoint("LEFT", microBar, 2, 0)
	configButton:SetSize(32, 32)
	configButton:SetFrameLevel(6)

	configButton.tex = configButton:CreateTexture(nil, "OVERLAY")
	configButton.tex:SetPoint("BOTTOMLEFT")
	configButton.tex:SetPoint("BOTTOMRIGHT")
	configButton.tex:SetSize(32, 32)
	configButton.tex:SetTexture(IconPath.."Config")
	configButton.tex:SetVertexColor(.6, .6, .6)
	configButton.tex:SetBlendMode("ADD")

	configButton.text = KUI:CreateText(configButton, "HIGHLIGHT", 11, "OUTLINE", "CENTER")
	if MB.db.text.buttons.position == "BOTTOM" then
	configButton.text:SetPoint("BOTTOM", configButton, 2, -15)
	elseif MB.db.text.buttons.position == "TOP" then
	configButton.text:SetPoint("TOP", configButton, 2, 15)
	end
	configButton.text:SetText(L["Config"])
	if MB.db.text.colors.customColor == 1 then
	configButton.text:SetTextColor(KUI.r, KUI.g, KUI.b)
	elseif MB.db.text.colors.customColor == 2 then
	configButton.text:SetTextColor(KUI:unpackColor(MB.db.text.colors.userColor))
	else
	configButton.text:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
	end

	configButton:SetScript("OnEnter", function(self) OnHover(self) end)
	configButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	configButton:SetScript("OnClick", function(self) if T.InCombatLockdown() then return end E:ToggleOptionsUI() end)

	if MB.db.text.buttons.position == "BOTTOM" then
	configButton.text:SetPoint("BOTTOM", configButton, 2, -15)
	elseif MB.db.text.buttons.position == "TOP" then
	configButton.text:SetPoint("TOP", configButton, 2, 15)
	end
	
	--Character
	local charButton = T.CreateFrame("Button", nil, microBar)
	charButton:SetPoint("LEFT", configButton, "RIGHT", 2, 0)
	charButton:SetSize(32, 32)
	charButton:SetFrameLevel(6)

	charButton.tex = charButton:CreateTexture(nil, "OVERLAY")
	charButton.tex:SetPoint("BOTTOMLEFT")
	charButton.tex:SetPoint("BOTTOMRIGHT")
	charButton.tex:SetSize(32, 32)
	charButton.tex:SetTexture(IconPath.."Character")
	charButton.tex:SetVertexColor(.6, .6, .6)
	charButton.tex:SetBlendMode("ADD")

	charButton.text = KUI:CreateText(charButton, "HIGHLIGHT", 11, "OUTLINE", "CENTER")
	if MB.db.text.buttons.position == "BOTTOM" then
	charButton.text:SetPoint("BOTTOM", charButton, 2, -15)
	elseif MB.db.text.buttons.position == "TOP" then
	charButton.text:SetPoint("TOP", charButton, 2, 15)
	end
	charButton.text:SetText(CHARACTER_BUTTON)
	if MB.db.text.colors.customColor == 1 then
	charButton.text:SetTextColor(KUI.r, KUI.g, KUI.b)
	elseif MB.db.text.colors.customColor == 2 then
	charButton.text:SetTextColor(KUI:unpackColor(MB.db.text.colors.userColor))
	else
	charButton.text:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
	end

	charButton:SetScript("OnEnter", function(self) OnHover(self) end)
	charButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	charButton:SetScript("OnClick", function(self) if T.InCombatLockdown() then return end _G["ToggleCharacter"]("PaperDollFrame") end)

	--Friends
	local friendsButton = T.CreateFrame("Button", nil, microBar)
	friendsButton:SetPoint("LEFT", charButton, "RIGHT", 2, 0)
	friendsButton:SetSize(32, 32)
	friendsButton:SetFrameLevel(6)

	friendsButton.tex = friendsButton:CreateTexture(nil, "OVERLAY")
	friendsButton.tex:SetPoint("BOTTOMLEFT")
	friendsButton.tex:SetPoint("BOTTOMRIGHT")
	friendsButton.tex:SetSize(32, 32)
	friendsButton.tex:SetTexture(IconPath.."Friends")
	friendsButton.tex:SetVertexColor(.6, .6, .6)
	friendsButton.tex:SetBlendMode("ADD")

	friendsButton.text = KUI:CreateText(friendsButton, "HIGHLIGHT", 11, "OUTLINE", "CENTER")
	if MB.db.text.buttons.position == "BOTTOM" then
	friendsButton.text:SetPoint("BOTTOM", friendsButton, 2, -15)
	elseif MB.db.text.buttons.position == "TOP" then
	friendsButton.text:SetPoint("TOP", friendsButton, 2, 15)
	end
	friendsButton.text:SetText(SOCIAL_BUTTON)
	if MB.db.text.colors.customColor == 1 then
	friendsButton.text:SetTextColor(KUI.r, KUI.g, KUI.b)
	elseif MB.db.text.colors.customColor == 2 then
	friendsButton.text:SetTextColor(KUI:unpackColor(MB.db.text.colors.userColor))
	else
	friendsButton.text:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
	end

	local function UpdateFriends()
		MB.db = E.db.KlixUI.microBar
		local friendsOnline = T.C_FriendList_GetNumFriends()
		local bnTotal, bnOnline = T.BNGetNumFriends()
		local totalOnline = friendsOnline + bnOnline

		if MB.db.text.friends.enable then
			if (bnOnline > 0) or (friendsOnline > 0) then
				if bnOnline > 0 then
					friendsButton.online:SetText(totalOnline)
				else
					friendsButton.online:SetText("0")
				end
			end
		end
	end
	
	local xOffset = MB.db.text.friends.xOffset or 0
	local yOffset = MB.db.text.friends.yOffset or 0
	friendsButton.online = friendsButton:CreateFontString(nil, "OVERLAY")
	friendsButton.online:FontTemplate(nil, MB.db.text.friends.textSize, "OUTLINE")
	friendsButton.online:SetPoint("BOTTOMRIGHT", friendsButton, xOffset, yOffset)
	friendsButton.online:SetText("")
	
	if MB.db.text.colors.customColor == 1 then
		friendsButton.online:SetTextColor(KUI.r, KUI.g, KUI.b)
	elseif MB.db.text.colors.customColor == 2 then
		friendsButton.online:SetTextColor(KUI:unpackColor(MB.db.text.colors.userColor))
	else
		friendsButton.online:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
	end

	friendsButton:SetScript("OnEnter", function(self) OnHover(self) end)
	friendsButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	friendsButton:SetScript("OnClick", function(self) if T.InCombatLockdown() then return end _G["ToggleFriendsFrame"]() end)
	friendsButton:SetScript("OnUpdate", function (self, elapse)
		elapsed = elapsed + elapse

		if elapsed >= DELAY then
			elapsed = 0
			UpdateFriends()
		end
	end)

	--Guild
	local guildButton = T.CreateFrame("Button", nil, microBar)
	guildButton:SetPoint("LEFT", friendsButton, "RIGHT", 2, 0)
	guildButton:SetSize(32, 32)
	guildButton:SetFrameLevel(6)

	guildButton.tex = guildButton:CreateTexture(nil, "OVERLAY")
	guildButton.tex:SetPoint("BOTTOMLEFT")
	guildButton.tex:SetPoint("BOTTOMRIGHT")
	guildButton.tex:SetSize(32, 32)
	guildButton.tex:SetTexture(IconPath.."Guild")
	guildButton.tex:SetVertexColor(.6, .6, .6)
	guildButton.tex:SetBlendMode("ADD")

	guildButton.text = KUI:CreateText(guildButton, "HIGHLIGHT", 11, "OUTLINE", "CENTER")
	if MB.db.text.buttons.position == "BOTTOM" then
	guildButton.text:SetPoint("BOTTOM", guildButton, 2, -15)
	elseif MB.db.text.buttons.position == "TOP" then
	guildButton.text:SetPoint("TOP", guildButton, 2, 15)
	end
	guildButton.text:SetText(GUILD)
	if MB.db.text.colors.customColor == 1 then
	guildButton.text:SetTextColor(KUI.r, KUI.g, KUI.b)
	elseif MB.db.text.colors.customColor == 2 then
	guildButton.text:SetTextColor(KUI:unpackColor(MB.db.text.colors.userColor))
	else
	guildButton.text:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
	end

	local function UpdateGuild()
		MB.db = E.db.KlixUI.microBar
		if T.IsInGuild() then
			local guildTotal, online = T.GetNumGuildMembers()
			for i = 1, guildTotal do
				local _, _, _, _, _, _, _, _, connected, _, _, _, _, isMobile = T.GetGuildRosterInfo(i)
				if isMobile then
					online = online + 1
				end
			end
			
			if MB.db.text.guild.enable then
				if online > 0 then
					guildButton.online:SetText(online)
				else
					guildButton.online:SetText("0")
				end
			end
		end
	end

	local xOffset = MB.db.text.guild.xOffset or 0
	local yOffset = MB.db.text.guild.yOffset or 0
	guildButton.online = guildButton:CreateFontString(nil, "OVERLAY")
	guildButton.online:FontTemplate(nil, MB.db.text.guild.textSize, "OUTLINE")
	guildButton.online:SetPoint("BOTTOMRIGHT", guildButton, xOffset, yOffset)
	guildButton.online:SetText("")
	
	if MB.db.text.colors.customColor == 1 then
		guildButton.online:SetTextColor(KUI.r, KUI.g, KUI.b)
	elseif MB.db.text.colors.customColor == 2 then
		guildButton.online:SetTextColor(KUI:unpackColor(MB.db.text.colors.userColor))
	else
		guildButton.online:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
	end

	guildButton:SetScript("OnEnter", function(self) OnHover(self) end)
	guildButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	guildButton:SetScript("OnClick", function(self) if T.InCombatLockdown() then return end _G["ToggleGuildFrame"]() end)
	guildButton:SetScript("OnUpdate", function (self, elapse)
		elapsed = elapsed + elapse

		if elapsed >= DELAY then
			elapsed = 0
			UpdateGuild()
		end
	end)
	
	-- Time
	local timeButton = T.CreateFrame("Button", nil, microBar)
	timeButton:SetPoint("LEFT", guildButton, "RIGHT", 18, 0)
	timeButton:SetSize(32, 32)
	timeButton:SetFrameLevel(6)

	timeButton.text = timeButton:CreateFontString(nil, 'OVERLAY')
	timeButton.text:FontTemplate(nil, 16, "OUTLINE")
	timeButton.text:SetPoint("CENTER", 0, 0)
	timeButton.text:SetJustifyH("CENTER")
	
	if MB.db.text.colors.customColor == 1 then
		timeButton.text:SetTextColor(KUI.r, KUI.g, KUI.b)
	elseif MB.db.text.colors.customColor == 2 then
		timeButton.text:SetTextColor(KUI:unpackColor(MB.db.text.colors.userColor))
	else
		timeButton.text:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
	end
	
	
	timeButton.tex = timeButton:CreateTexture(nil, "OVERLAY") --dummy texture
	timeButton.tex:SetPoint("BOTTOMLEFT")
	timeButton.tex:SetPoint("BOTTOMRIGHT")
	timeButton.tex:SetSize(32, 32)
	timeButton.tex:SetBlendMode("ADD")

	local timer = timeButton:CreateAnimationGroup()

	local timerAnim = timer:CreateAnimation()
	timerAnim:SetDuration(1)

	timer:SetScript("OnFinished", function(self, requested)
		local euTime = T.date("%H|cFF999999:|r%M")
		local ukTime = T.date("%I|cFF999999:|r%M")

		if E.db.datatexts.time24 == true then
			timeButton.text:SetText(euTime)
		else
			timeButton.text:SetText(ukTime)
		end
		self:Play()
	end)
	timer:Play()

	timeButton:SetScript("OnEnter", function(self) OnHover(self) end)
	timeButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	timeButton:SetScript("OnMouseUp", MB.OnClick)
	
	--QuestLog
	local questButton = T.CreateFrame("Button", nil, microBar)
	questButton:SetPoint("LEFT", timeButton, "RIGHT", 2, 0)
	questButton:SetSize(32, 32)
	questButton:SetFrameLevel(6)

	questButton.tex = questButton:CreateTexture(nil, "OVERLAY")
	questButton.tex:SetPoint("BOTTOMLEFT")
	questButton.tex:SetPoint("BOTTOMRIGHT")
	questButton.tex:SetSize(32, 32)
	questButton.tex:SetTexture(IconPath.."Quest")
	questButton.tex:SetVertexColor(.6, .6, .6)
	questButton.tex:SetBlendMode("ADD")

	questButton.text = KUI:CreateText(questButton, "HIGHLIGHT", 11, "OUTLINE", "CENTER")
	if MB.db.text.buttons.position == "BOTTOM" then
	questButton.text:SetPoint("BOTTOM", questButton, 2, -15)
	elseif MB.db.text.buttons.position == "TOP" then
	questButton.text:SetPoint("TOP", questButton, 2, 15)
	end
	questButton.text:SetText(L["Map & Quest Log"])
	if MB.db.text.colors.customColor == 1 then
	questButton.text:SetTextColor(KUI.r, KUI.g, KUI.b)
	elseif MB.db.text.colors.customColor == 2 then
	questButton.text:SetTextColor(KUI:unpackColor(MB.db.text.colors.userColor))
	else
	questButton.text:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
	end

	questButton:SetScript("OnEnter", function(self) OnHover(self) end)
	questButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	questButton:SetScript("OnClick", function(self) if T.InCombatLockdown() then return end _G["ToggleQuestLog"]() end)
	
	--Spellbook
	local spellBookButton = T.CreateFrame("Button", nil, microBar)
	spellBookButton:SetPoint("LEFT", questButton, "RIGHT", 2, 0)
	spellBookButton:SetSize(32, 32)
	spellBookButton:SetFrameLevel(6)

	spellBookButton.tex = spellBookButton:CreateTexture(nil, "OVERLAY")
	spellBookButton.tex:SetPoint("BOTTOMLEFT")
	spellBookButton.tex:SetPoint("BOTTOMRIGHT")
	spellBookButton.tex:SetSize(32, 32)
	spellBookButton.tex:SetTexture(IconPath.."Spellbook")
	spellBookButton.tex:SetVertexColor(.6, .6, .6)
	spellBookButton.tex:SetBlendMode("ADD")

	spellBookButton.text = KUI:CreateText(spellBookButton, "HIGHLIGHT", 11, "OUTLINE", "CENTER")
	if MB.db.text.buttons.position == "BOTTOM" then
	spellBookButton.text:SetPoint("BOTTOM", spellBookButton, 2, -15)
	elseif MB.db.text.buttons.position == "TOP" then
	spellBookButton.text:SetPoint("TOP", spellBookButton, 2, 15)
	end
	spellBookButton.text:SetText(SPELLBOOK_ABILITIES_BUTTON)
	if MB.db.text.colors.customColor == 1 then
	spellBookButton.text:SetTextColor(KUI.r, KUI.g, KUI.b)
	elseif MB.db.text.colors.customColor == 2 then
	spellBookButton.text:SetTextColor(KUI:unpackColor(MB.db.text.colors.userColor))
	else
	spellBookButton.text:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
	end

	spellBookButton:SetScript("OnEnter", function(self) OnHover(self) end)
	spellBookButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	spellBookButton:SetScript("OnClick", function(self) if T.InCombatLockdown() then return end _G["ToggleSpellBook"](BOOKTYPE_SPELL) end)

	--Specc Button
	local speccButton = T.CreateFrame("Button", nil, microBar)
	speccButton:SetPoint("LEFT", spellBookButton, "RIGHT", 2, 0)
	speccButton:SetSize(32, 32)
	speccButton:SetFrameLevel(6)

	speccButton.tex = speccButton:CreateTexture(nil, "OVERLAY")
	speccButton.tex:SetPoint("BOTTOMLEFT")
	speccButton.tex:SetPoint("BOTTOMRIGHT")
	speccButton.tex:SetSize(32, 32)
	speccButton.tex:SetTexture(IconPath.."Specc")
	speccButton.tex:SetVertexColor(.6, .6, .6)
	speccButton.tex:SetBlendMode("ADD")

	speccButton.text = KUI:CreateText(speccButton, "HIGHLIGHT", 11, "OUTLINE", "CENTER")
	if MB.db.text.buttons.position == "BOTTOM" then
	speccButton.text:SetPoint("BOTTOM", speccButton, 2, -15)
	elseif MB.db.text.buttons.position == "TOP" then
	speccButton.text:SetPoint("TOP", speccButton, 2, 15)
	end
	speccButton.text:SetText(TALENTS_BUTTON)
	if MB.db.text.colors.customColor == 1 then
	speccButton.text:SetTextColor(KUI.r, KUI.g, KUI.b)
	elseif MB.db.text.colors.customColor == 2 then
	speccButton.text:SetTextColor(KUI:unpackColor(MB.db.text.colors.userColor))
	else
	speccButton.text:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
	end

	speccButton:SetScript("OnEnter", function(self) OnHover(self) end)
	speccButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	speccButton:SetScript("OnClick", function(self) if T.InCombatLockdown() then return end _G["ToggleTalentFrame"]() end)

	--Bug
	local bugButton = T.CreateFrame("Button", nil, microBar)
	bugButton:SetPoint("LEFT", speccButton, "RIGHT", 2, 0)
	bugButton:SetSize(32, 32)
	bugButton:SetFrameLevel(6)

	bugButton.tex = bugButton:CreateTexture(nil, "OVERLAY")
	bugButton.tex:SetPoint("BOTTOMLEFT")
	bugButton.tex:SetPoint("BOTTOMRIGHT")
	bugButton.tex:SetSize(32, 32)
	bugButton.tex:SetTexture(IconPath.."Bug")
	bugButton.tex:SetVertexColor(.6, .6, .6)
	bugButton.tex:SetBlendMode("ADD")

	bugButton.text = KUI:CreateText(bugButton, "HIGHLIGHT", 11, "OUTLINE", "CENTER")
	if MB.db.text.buttons.position == "BOTTOM" then
	bugButton.text:SetPoint("BOTTOM", bugButton, 2, -15)
	elseif MB.db.text.buttons.position == "TOP" then
	bugButton.text:SetPoint("TOP", bugButton, 2, 15)
	end
	bugButton.text:SetText(L["Bug Report"])
	if MB.db.text.colors.customColor == 1 then
	bugButton.text:SetTextColor(KUI.r, KUI.g, KUI.b)
	elseif MB.db.text.colors.customColor == 2 then
	bugButton.text:SetTextColor(KUI:unpackColor(MB.db.text.colors.userColor))
	else
	bugButton.text:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
	end

	bugButton:SetScript("OnEnter", function(self) OnHover(self) end)
	bugButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	bugButton:SetScript("OnClick", function(self) if T.InCombatLockdown() then return end E:StaticPopup_Show("BUG_REPORT", nil, nil, "https://discord.gg/GbQbDRX") end)
	
	--Support
	local supportButton = T.CreateFrame("Button", nil, microBar)
	supportButton:SetPoint("LEFT", bugButton, "RIGHT", 2, 0)
	supportButton:SetSize(32, 32)
	supportButton:SetFrameLevel(6)

	supportButton.tex = supportButton:CreateTexture(nil, "OVERLAY")
	supportButton.tex:SetPoint("BOTTOMLEFT")
	supportButton.tex:SetPoint("BOTTOMRIGHT")
	supportButton.tex:SetSize(32, 32)
	supportButton.tex:SetTexture(IconPath.."Support")
	supportButton.tex:SetVertexColor(.6, .6, .6)
	supportButton.tex:SetBlendMode("ADD")

	supportButton.text = KUI:CreateText(supportButton, "HIGHLIGHT", 11, "OUTLINE", "CENTER")
	if MB.db.text.buttons.position == "BOTTOM" then
	supportButton.text:SetPoint("BOTTOM", supportButton, 2, -15)
	elseif MB.db.text.buttons.position == "TOP" then
	supportButton.text:SetPoint("TOP", supportButton, 2, 15)
	end
	supportButton.text:SetText(HELP_BUTTON)
	if MB.db.text.colors.customColor == 1 then
	supportButton.text:SetTextColor(KUI.r, KUI.g, KUI.b)
	elseif MB.db.text.colors.customColor == 2 then
	supportButton.text:SetTextColor(KUI:unpackColor(MB.db.text.colors.userColor))
	else
	supportButton.text:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
	end

	supportButton:SetScript("OnEnter", function(self) OnHover(self) end)
	supportButton:SetScript("OnLeave", function(self) OnLeave(self) end)
	supportButton:SetScript("OnClick", function(self) if T.InCombatLockdown() then return end ToggleHelpFrame() end)
	
	E:CreateMover(microBar, "KUI_MicroBarMover", L["KlixUI Micro Bar"], nil, nil, nil, 'ALL,ACTIONBARS,KLIXUI', nil, "KlixUI,modules,actionbars,microBar")
end

function MB:Toggle()
	if MB.db.enable then
		microBar:Show()
		E:EnableMover(microBar.mover:GetName())
	else
		microBar:Hide()
		E:DisableMover(microBar.mover:GetName())
	end
end

function MB:PLAYER_REGEN_DISABLED()
	if MB.db.hideInCombat then microBar:Hide() end
end

function MB:PLAYER_REGEN_ENABLED()
	if MB.db.enable then microBar:Show() end
end

function MB:Initialize()
	MB.db = E.db.KlixUI.microBar
	if MB.db.enable ~= true then return end

	KUI:RegisterDB(self, "microBar")
	
	self:CreateMicroBar()
	self:Toggle()
	
	function MB:ForUpdateAll()
		MB.db = E.db.KlixUI.microBar

		self:Toggle()
	end

	self:ForUpdateAll()

	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
end

local function InitializeCallback()
	MB:Initialize()
end

KUI:RegisterModule(MB:GetName(), InitializeCallback)