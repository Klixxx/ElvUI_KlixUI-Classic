local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KUIL = KUI:NewModule('KuiLayout', 'AceHook-3.0', 'AceEvent-3.0');
local KS = KUI:GetModule("KuiSkins")
local KC = KUI:GetModule("KuiChat")
local AB = E:GetModule("ActionBars")
local CH = E:GetModule("Chat")
local LO = E:GetModule('Layout')
local DT = E:GetModule('DataTexts')
local M = E:GetModule('Minimap')
local LSM = E.LSM or E.Libs.LSM

local GameTooltip = _G.GameTooltip
local GameMenuButtonAddons = _G.GameMenuButtonAddons

local cp = "|cFF00c0fa" -- +
local cm = "|cff9a1212" -- -

local PANEL_HEIGHT = 21;
local SPACING = (E.PixelMode and 1 or 3)
local BUTTON_NUM = 4

local Kui_ldtp = T.CreateFrame('Frame', 'KuiLeftChatDTPanel', E.UIParent)
local Kui_rdtp = T.CreateFrame('Frame', 'KuiRightChatDTPanel', E.UIParent)
local Kui_mdtp = T.CreateFrame('Frame', 'KuiMiddleDTPanel', E.UIParent)

function KUIL:LoadLayout()
	--Create extra panels
	KUIL:CreateExtraDataBarPanels()
end
hooksecurefunc(LO, "Initialize", KUIL.LoadLayout)

local function RegKuiDataTexts()
	DT:RegisterPanel(KuiLeftChatDTPanel, 3, 'ANCHOR_TOP', 0, 1)
	DT:RegisterPanel(KuiRightChatDTPanel, 3, 'ANCHOR_TOP', 0, 1)
	DT:RegisterPanel(KuiMiddleDTPanel, 3, 'ANCHOR_TOP', 0, 1)
	
	L['KuiLeftChatDTPanel'] = KUI.Title..KUI:cOption(L['Left Chat Panel']);
	L['KuiRightChatDTPanel'] = KUI.Title..KUI:cOption(L['Right Chat Panel']);
	L['KuiMiddleDTPanel'] = KUI.Title..KUI:cOption(L['Middle Panel']);
	E.FrameLocks['KuiMiddleDTPanel'] = true;
end

-- Credits to Merathilis for this mod.
function KUIL:CreateExtraDataBarPanels()
	local leftchattab = T.CreateFrame("Frame", "Left_ChatTab_Panel", LeftChatPanel)
	leftchattab:SetPoint("TOPRIGHT", LeftChatTab, "TOPRIGHT", 0, 0)
	leftchattab:SetPoint("BOTTOMLEFT", LeftChatTab, "BOTTOMLEFT", 0, 0)
	E.FrameLocks["Left_ChatTab_Panel"] = true
	DT:RegisterPanel(leftchattab, 3, "ANCHOR_TOPLEFT", -3, 4)
	L['Left_ChatTab_Panel'] = KUI.Title..KUI:cOption(L['Left ChatTab Panel']);
	
	local rightchattab = T.CreateFrame("Frame", "Right_ChatTab_Panel", RightChatPanel)
	rightchattab:SetPoint("TOPRIGHT", RightChatTab, "TOPRIGHT", 0, 0)
	rightchattab:SetPoint("BOTTOMLEFT", RightChatTab, "BOTTOMLEFT", 0, 0)
	E.FrameLocks["Right_ChatTab_Panel"] = true
	DT:RegisterPanel(rightchattab, 3, "ANCHOR_TOPLEFT", -3, 4)
	L['Right_ChatTab_Panel'] = KUI.Title..KUI:cOption(L['Right ChatTab Panel']);
end

function KUIL:ToggleLeftChatPanel()
	local db = E.db.KlixUI.datatexts.leftChatTabDatatextPanel

	if db.enable then
		Left_ChatTab_Panel:Show()
	else
		Left_ChatTab_Panel:Hide()
	end
end

function KUIL:ToggleRightChatPanel()
	local db = E.db.KlixUI.datatexts.rightChatTabDatatextPanel

	if db.enable then
		Right_ChatTab_Panel:Show()
	else
		Right_ChatTab_Panel:Hide()
	end
end

local Kui_dchat = T.CreateFrame('Frame', 'KuiDummyChat', E.UIParent)
local Kui_dthreat = T.CreateFrame('Frame', 'KuiDummyThreat', E.UIParent)

local menuFrame = T.CreateFrame('Frame', 'KuiGameClickMenu', E.UIParent)
menuFrame:SetTemplate('Transparent', true)

function KuiGameMenu_OnMouseUp(self)
	GameTooltip:Hide()
	KUI:Dropmenu(KUI.MenuList, menuFrame, self:GetName(), 'tLeft', -SPACING, SPACING, 4)
	T.PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
end

local function ChatButton_OnClick(self)
	GameTooltip:Hide()

	if E.db[self.parent:GetName()..'Faded'] then
		E.db[self.parent:GetName()..'Faded'] = nil
		T.UIFrameFadeIn(self.parent, 0.2, self.parent:GetAlpha(), 1)
		if T.IsAddOnLoaded('AddOnSkins') then
			local AS = T.unpack(AddOnSkins) or nil
			if AS.db.EmbedSystem or AS.db.EmbedSystemDual then AS:Embed_Show() end
		end
	else
		E.db[self.parent:GetName()..'Faded'] = true
		T.UIFrameFadeOut(self.parent, 0.2, self.parent:GetAlpha(), 0)
		self.parent.fadeInfo.finishedFunc = self.parent.fadeFunc
	end
	T.PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
end

local kbuttons = {}

function KUIL:ToggleKuiDts()
	if not E.db.KlixUI.datatexts.chat.enable or E.db.datatexts.leftChatPanel then
		KuiLeftChatDTPanel:Hide()
		for i = 3, 4 do
			kbuttons[i]:Hide()
		end
	else
		KuiLeftChatDTPanel:Show()
		for i = 3, 4 do
			kbuttons[i]:Show()
		end
	end

	if not E.db.KlixUI.datatexts.chat.enable or E.db.datatexts.rightChatPanel then
		KuiRightChatDTPanel:Hide()
		for i = 1, 2 do
			kbuttons[i]:Hide()
		end
	else
		KuiRightChatDTPanel:Show()
		for i = 1, 2 do
			kbuttons[i]:Show()
		end
	end
end

function KUIL:ResizeMinimapPanels()
	LeftMiniPanel:Point('TOPLEFT', Minimap.backdrop, 'BOTTOMLEFT', 0, -SPACING)
	LeftMiniPanel:Point('BOTTOMRIGHT', Minimap.backdrop, 'BOTTOM', -SPACING, -(SPACING + PANEL_HEIGHT))
	RightMiniPanel:Point('TOPRIGHT', Minimap.backdrop, 'BOTTOMRIGHT', 0, -SPACING)
	RightMiniPanel:Point('BOTTOMLEFT', LeftMiniPanel, 'BOTTOMRIGHT', SPACING, 0)
end

function KUIL:ToggleTransparency()
	local db = E.db.KlixUI.datatexts.chat
	if not db.backdrop then
		Kui_ldtp:SetTemplate('NoBackdrop')
		Kui_rdtp:SetTemplate('NoBackdrop')
		for i = 1, BUTTON_NUM do
			kbuttons[i]:SetTemplate('NoBackdrop')
		end
	else
		if db.transparent then
			Kui_ldtp:SetTemplate('Transparent')
			Kui_rdtp:SetTemplate('Transparent')	
			for i = 1, BUTTON_NUM do
				kbuttons[i]:SetTemplate('Transparent')
			end
		else
			Kui_ldtp:SetTemplate('Default', true)
			Kui_rdtp:SetTemplate('Default', true)
			for i = 1, BUTTON_NUM do
				kbuttons[i]:SetTemplate('Default', true)
			end
		end
	end
end

function KUIL:MiddleDatatextLayout()
	local db = E.db.KlixUI.datatexts.middle

	if db.enable then
		Kui_mdtp:Show()
	else
		Kui_mdtp:Hide()
	end

	if not db.backdrop then
		Kui_mdtp:SetTemplate('NoBackdrop')
	else
		if db.transparent then
			Kui_mdtp:SetTemplate('Transparent')
		else
			Kui_mdtp:SetTemplate('Default', true)
		end
	end
end

function KUIL:MiddleDatatextDimensions()
	local db = E.db.KlixUI.datatexts.middle
	Kui_mdtp:Width(db.width)
	Kui_mdtp:Height(db.height)
	DT:UpdateAllDimensions()
end

function KUIL:Styles()
	if not E.db.KlixUI.general.style then return end
	if E.db.KlixUI.datatexts.chat.style then
		Kui_rdtp:Styling()
		Kui_ldtp:Styling()
		for i = 1, BUTTON_NUM do
			kbuttons[i]:Styling()
		end
	else
	end
	if E.db.KlixUI.datatexts.middle.style then
		Kui_mdtp:Styling()
	end
end

local function updateButtonFont()
	for i = 1, BUTTON_NUM do
		if kbuttons[i].text then
			kbuttons[i].text:SetFont(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
			kbuttons[i].text:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
		end
	end
end

local function Panel_OnShow(self)
	self:SetFrameLevel(0)
end

local function ShowOrHideBar4(bar, button)
	if E.db.actionbar.bar4.enabled == true then
		E.db.actionbar.bar4.enabled = false
	elseif E.db.actionbar.bar4.enabled == false then
		E.db.actionbar.bar4.enabled = true
	end
	AB:UpdateButtonSettings("bar4")
end

local function ShowOrHideBar5(bar, button)
	if E.db.actionbar.bar5.enabled == true then
		E.db.actionbar.bar5.enabled = false
	elseif E.db.actionbar.bar5.enabled == false then
		E.db.actionbar.bar5.enabled = true
	end
	AB:UpdateButtonSettings("bar5")
end

local function MoveButtonBar(button, bar)
	if button == kbuttons4 then
		if E.db.actionbar.bar4.enabled == true then
			button.text:SetText(cm.."-|r")
		else
			button.text:SetText(cp.."+|r")
		end
	end

	if button == kbuttons2 then
		if E.db.actionbar.bar5.enabled == true then
			button.text:SetText(cm.."-|r")
		else
			button.text:SetText(cp.."+|r")
		end
	end
end

local function UpdateBar4(self, bar)
	GameTooltip:Hide()
	if T.InCombatLockdown() then KUI:Print(ERR_NOT_IN_COMBAT) return end
	local button = self

	ShowOrHideBar4(bar, button)
	MoveButtonBar(button, bar)
end

local function UpdateBar5(self, bar)
	GameTooltip:Hide()
	if T.InCombatLockdown() then KUI:Print(ERR_NOT_IN_COMBAT) return end
	local button = self

	ShowOrHideBar5(bar, button)
	MoveButtonBar(button, bar)
end

function KUIL:SpecandEquipBar_OnClick()
	GameTooltip:Hide()

	if SpecializationBar:IsShown() and EquipmentSets:IsShown() then
		SpecializationBar:Hide()
		EquipmentSets:Hide()
	else
		SpecializationBar:Show()
		EquipmentSets:Show()
	end
end

function KUIL:MiddleDT_OnClick()
	GameTooltip:Hide()

	if KuiMiddleDTPanel:IsShown()then
		KuiMiddleDTPanel:Hide()
	else
		KuiMiddleDTPanel:Show()
	end
end

function KUIL:ChangeLayout()

	LeftMiniPanel:Height(PANEL_HEIGHT)
	RightMiniPanel:Height(PANEL_HEIGHT)

	-- Left dt panel
	Kui_ldtp:SetFrameStrata(E.db.KlixUI.datatexts.chat.strata)
	Kui_ldtp:Point('TOPLEFT', LeftChatPanel, 'BOTTOMLEFT', (SPACING +PANEL_HEIGHT), -SPACING)
	Kui_ldtp:Point('BOTTOMRIGHT', LeftChatPanel, 'BOTTOMRIGHT', -(SPACING +PANEL_HEIGHT), -PANEL_HEIGHT -SPACING)

	-- Right dt panel
	Kui_rdtp:SetFrameStrata(E.db.KlixUI.datatexts.chat.strata)
	Kui_rdtp:Point('TOPLEFT', RightChatPanel, 'BOTTOMLEFT', (SPACING +PANEL_HEIGHT), -SPACING)
	Kui_rdtp:Point('BOTTOMRIGHT', RightChatPanel, 'BOTTOMRIGHT', -(SPACING +PANEL_HEIGHT), -PANEL_HEIGHT -SPACING)

	-- Middle dt panel
	Kui_mdtp:SetFrameStrata(E.db.KlixUI.datatexts.middle.strata)
	Kui_mdtp:Point('BOTTOM', E.UIParent, 'BOTTOM', 0, 8)
	Kui_mdtp:Width(E.db.KlixUI.datatexts.middle.width or 400)
	Kui_mdtp:Height(E.db.KlixUI.datatexts.middle.height or PANEL_HEIGHT)

	E:CreateMover(Kui_mdtp, "KuiMiddleDTMover", L["KlixUI Middle DataText"], nil, nil, nil, 'ALL,SOLO,KLIXUI', nil, "KlixUI,modules,datatexts,panels,middle")
	
	-- dummy frame for chat/threat (left)
	Kui_dchat:SetFrameStrata('LOW')
	Kui_dchat:Point('TOPLEFT', LeftChatPanel, 'BOTTOMLEFT', 0, -SPACING)
	Kui_dchat:Point('BOTTOMRIGHT', LeftChatPanel, 'BOTTOMRIGHT', 0, -PANEL_HEIGHT -SPACING)

	-- dummy frame for threat (right)
	Kui_dthreat:SetFrameStrata('LOW')
	Kui_dthreat:Point('TOPLEFT', RightChatPanel, 'BOTTOMLEFT', 0, -SPACING)
	Kui_dthreat:Point('BOTTOMRIGHT', RightChatPanel, 'BOTTOMRIGHT', 0, -PANEL_HEIGHT -SPACING)

	-- Buttons
	for i = 1, BUTTON_NUM do
		kbuttons[i] = T.CreateFrame('Button', 'KuiButton_'..i, E.UIParent)
		kbuttons[i]:RegisterForClicks('AnyUp')
		kbuttons[i]:SetFrameStrata(E.db.KlixUI.datatexts.chat.strata)
		kbuttons[i]:CreateSoftGlow()
		kbuttons[i].sglow:Hide()
		kbuttons[i].text = kbuttons[i]:CreateFontString(nil, 'OVERLAY')
		kbuttons[i].text:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
		kbuttons[i].text:SetPoint('CENTER', 1, 0)
		kbuttons[i].text:SetJustifyH('CENTER')
		kbuttons[i].text:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))

		-- ElvUI Config
		if i == 1 then
			kbuttons[i]:Point('TOPLEFT', Kui_rdtp, 'TOPRIGHT', SPACING, 0)
			kbuttons[i]:Point('BOTTOMRIGHT', Kui_rdtp, 'BOTTOMRIGHT', PANEL_HEIGHT + SPACING, 0)
			kbuttons[i].parent = RightChatPanel
			kbuttons[i].text:SetText('C')

			kbuttons[i]:SetScript('OnEnter', function(self)
				GameTooltip:SetOwner(self, 'ANCHOR_TOPRIGHT', 0, 2)
				GameTooltip:ClearLines()
				GameTooltip:AddLine(L['Left Click: Toggle Configuration'], selectioncolor)
				if T.IsAddOnLoaded('AddOnSkins') then
					GameTooltip:AddLine(L['Right Click: Toggle Embedded Addon'], selectioncolor)
				elseif E.db.datatexts.battleground == true then
					GameTooltip:AddLine(L['Right Click: Toggle Battleground DataTexts'], selectioncolor)
				end
				GameTooltip:AddLine(L['Shift + Click: Toggle Chat'], 0.7, 0.7, 1)
				GameTooltip:AddLine(L['Control + Click: Toggle |cfff960d9KlixUI|r Configuration'], 0.7, 0.7, 1)
				self.sglow:Show()

				if T.IsShiftKeyDown() then
					self.text:SetText('>')
					self:SetScript('OnClick', ChatButton_OnClick)
				else
					self.text:SetText('C')
					self:SetScript('OnClick', function(self, btn)
					if T.IsControlKeyDown() then
						KUI:DasOptions()
					elseif btn == 'LeftButton' then
							E:ToggleOptionsUI()
						else
							if T.IsAddOnLoaded('AddOnSkins') then
								local AS = T.unpack(AddOnSkins) or nil
								if AS:CheckOption('EmbedRightChat') then
									if EmbedSystem_MainWindow:IsShown() then
										AS:SetOption('EmbedIsHidden', true)
										EmbedSystem_MainWindow:Hide()
									else
										AS:SetOption('EmbedIsHidden', false)
										EmbedSystem_MainWindow:Show()
									end
								end
							else
								if E.db.datatexts.battleground == true then
								E:BGStats()
								else return end
							end
						end
						T.PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
					end)
				end

				GameTooltip:Show()
				if T.InCombatLockdown() then GameTooltip:Hide() end
			end)

			kbuttons[i]:SetScript('OnLeave', function(self)
				self.text:SetText('C')
				self.sglow:Hide()
				GameTooltip:Hide()
			end)
			
		-- Game menu button
		elseif i == 2 then
			kbuttons[i]:Point('TOPRIGHT', Kui_rdtp, 'TOPLEFT', -SPACING, 0)
			kbuttons[i]:Point('BOTTOMLEFT', Kui_rdtp, 'BOTTOMLEFT', -(PANEL_HEIGHT + SPACING), 0)
			kbuttons[i].parent = ElvUI_Bar5
			kbuttons[i].text:SetText('G')

			kbuttons[i]:SetScript('OnEnter', function(self)
				self.sglow:Show()
				if T.IsShiftKeyDown() then
						if E.db.actionbar.bar5.enabled == true then -- double check for login
							kbuttons[i].text:SetText(cm.."-|r")
						else
							kbuttons[i].text:SetText(cp.."+|r")
						end
					self:SetScript('OnClick', UpdateBar5)
				else
				self:SetScript('OnClick', function(self, btn)
					if btn == "LeftButton" then
						KuiGameMenu_OnMouseUp(self)
					elseif btn == "RightButton" then
						if E.db.KlixUI.chat.isExpanded then
							E.db.chat.panelHeight = E.db.KlixUI.chat.panelHeight
							E.db.KlixUI.chat.isExpanded = false
							CH:PositionChat(true)
						else
							E.db.chat.panelHeight = 400
							CH:PositionChat(true)
							E.db.KlixUI.chat.isExpanded = true
							end
						end
					end)
				end
				GameTooltip:SetOwner(self, 'ANCHOR_TOPRIGHT', 0, 2)
				GameTooltip:ClearLines()
				GameTooltip:AddLine(L['Left Click: Toggle |cfff960d9KlixUI |r']..MAINMENU_BUTTON, selectioncolor)
				GameTooltip:AddLine(L['Right Click: Expand/Compress the Chat Menu'], selectioncolor)
				GameTooltip:AddLine(L['Shift + Click: Toggle ActionBar5'], 0.7, 0.7, 1)
				GameTooltip:Show()
				if T.InCombatLockdown() or KuiGameClickMenu:IsShown() then GameTooltip:Hide() end
			end)
			
			kbuttons[i]:SetScript('OnLeave', function(self)
				self.text:SetText('G')
				self.sglow:Hide()
				GameTooltip:Hide()
			end)

		-- Voice/AddOns Button
		elseif i == 3 then
			kbuttons[i]:Point('TOPRIGHT', Kui_ldtp, 'TOPLEFT', -SPACING, 0)
			kbuttons[i]:Point('BOTTOMLEFT', Kui_ldtp, 'BOTTOMLEFT', -(PANEL_HEIGHT + SPACING), 0)
			kbuttons[i].parent = LeftChatPanel
			kbuttons[i].text:SetText('A')

			kbuttons[i]:SetScript('OnEnter', function(self)
				self.sglow:Show()
				if T.IsShiftKeyDown() then
					self.text:SetText('<')
					self:SetScript('OnClick', ChatButton_OnClick)
				else
				self:SetScript('OnClick', function(self, btn)
					if btn == "LeftButton" then
						if (E.db.KlixUI.addonpanel.Enable and not T.IsAddOnLoaded("ProjectAzilroka")) then
							if APFrame:IsShown() then
								APFrame:Hide()
							else
								APFrame:Show()
							end
						else
							GameMenuButtonAddons:Click()
						end
					elseif btn == "RightButton" then
						KC.ChatEmote.ToggleEmoteTable()
					end
				end)
				end
				GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 0, 2)
				GameTooltip:ClearLines()
				GameTooltip:AddLine(L['Left Click: Toggle Addon List'], selectioncolor)
				GameTooltip:AddLine(L['Right Click: Toggle Emoticons'], selectioncolor)
				GameTooltip:AddLine(L['Shift + Click: Toggle Chat'], 0.7, 0.7, 1)
				GameTooltip:Show()
				if T.InCombatLockdown() then GameTooltip:Hide() end
			end)

			kbuttons[i]:SetScript('OnLeave', function(self)
				self.text:SetText('A')
				self.sglow:Hide()
				GameTooltip:Hide()
			end)

		-- LFG Button
		elseif i == 4 then
			kbuttons[i]:Point('TOPLEFT', Kui_ldtp, 'TOPRIGHT', SPACING, 0)
			kbuttons[i]:Point('BOTTOMRIGHT', Kui_ldtp, 'BOTTOMRIGHT', PANEL_HEIGHT + SPACING, 0)
			kbuttons[i].parent = ElvUI_Bar4
			kbuttons[i].text:SetText('L')
			
			kbuttons[i]:SetScript('OnEnter', function(self)
				self.sglow:Show()
				if T.IsShiftKeyDown() then
						if E.db.actionbar.bar4.enabled == true then -- double check for login
							kbuttons[i].text:SetText(cm.."-|r")
						else
							kbuttons[i].text:SetText(cp.."+|r")
						end
					self:SetScript('OnClick', UpdateBar4)
				else
				self:SetScript('OnClick', function(self, btn)
				if T.IsControlKeyDown() and E.db.KlixUI.datatexts.middle.enable == true then
					KUIL:MiddleDT_OnClick(self)
						elseif btn == "LeftButton" then 
							T.ToggleTalentFrame()
							T.PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
						elseif btn == "RightButton" then
							T.ToggleCommunitiesFrame()
						end
					end)
				end
				GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 0, 2)
				GameTooltip:ClearLines()
				GameTooltip:AddLine(L['Left Click: Toggle Talents'], selectioncolor)
				GameTooltip:AddLine(L['Right Click: Toggle Guild & Communities'], selectioncolor)
				GameTooltip:AddLine(L['Shift + Click: Toggle ActionBar4'], 0.7, 0.7, 1)
				if E.db.KlixUI.datatexts.middle.enable == true then
				GameTooltip:AddLine(L['Control + Click: Toggle |cfff960d9KlixUI|r Middle DataText Panel'], 0.7, 0.7, 1)
				end
				GameTooltip:Show()
				if T.InCombatLockdown() then GameTooltip:Hide() end
			end)
			
			kbuttons[i]:SetScript('OnLeave', function(self)
				self.text:SetText('L')
				self.sglow:Hide()
				GameTooltip:Hide()
			end)
		end
	end
	self:ResizeMinimapPanels()
	self:ToggleTransparency()
end

-- Based on CodeNameBlaze chat lines
function KUIL:CreateAndModifyChatPanels()
	--Left Chat Tab Separator
	local ltabseparator = T.CreateFrame('Frame', 'LeftChatTabSeparator', LeftChatPanel)
	ltabseparator:SetFrameStrata('BACKGROUND')
	ltabseparator:SetFrameLevel(LeftChatPanel:GetFrameLevel() + 2)
	ltabseparator:Size(E.db.chat.panelWidth - 10, 1)
	ltabseparator:Point('TOP', LeftChatPanel, 0, -24)
	ltabseparator:SetTemplate('Transparent')
	
	--Right Chat Tab Separator
	local rtabseparator = T.CreateFrame('Frame', 'RightChatTabSeparator', RightChatPanel)
	rtabseparator:SetFrameStrata('BACKGROUND')
	rtabseparator:SetFrameLevel(RightChatPanel:GetFrameLevel() + 2)
	rtabseparator:Size(E.db.chat.panelWidth - 10, 1)
	rtabseparator:Point('TOP', RightChatPanel, 0, -24)
	rtabseparator:SetTemplate('Transparent')
	
	--Left Chat Data Panel Separator
	local ldataseparator = T.CreateFrame('Frame', 'LeftDataPanelSeparator', LeftChatPanel)
	ldataseparator:SetFrameStrata('BACKGROUND')
	ldataseparator:SetFrameLevel(LeftChatPanel:GetFrameLevel() + 2)
	ldataseparator:Size(E.db.chat.panelWidth - 10, 1)
	ldataseparator:Point('BOTTOM', LeftChatPanel, 0, 24)
	ldataseparator:SetTemplate('Transparent')
	
	--Right Chat Data Panel Separator
	local rdataseparator = T.CreateFrame('Frame', 'RightDataPanelSeparator', RightChatPanel)
	rdataseparator:SetFrameStrata('BACKGROUND')
	rdataseparator:SetFrameLevel(RightChatPanel:GetFrameLevel() + 2)
	rdataseparator:Size(E.db.chat.panelWidth - 10, 1)
	rdataseparator:Point('BOTTOM', RightChatPanel, 0, 24)
	rdataseparator:SetTemplate('Transparent')
	
	--Modify Left Chat Toggle Button font, text and color
	LeftChatToggleButton.text:FontTemplate(LSM:Fetch("font", E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
	LeftChatToggleButton.text:SetText('L')
	LeftChatToggleButton.text:SetTextColor(T.unpack(E["media"].rgbvaluecolor))
	
	--Modify Right Chat Toggle Button font, text and color
	RightChatToggleButton.text:FontTemplate(LSM:Fetch("font", E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
	RightChatToggleButton.text:SetText('R')
	RightChatToggleButton.text:SetTextColor(T.unpack(E["media"].rgbvaluecolor))
end
hooksecurefunc(LO, "CreateChatPanels", KUIL.CreateAndModifyChatPanels)

function KUIL:TopPanelLayout()
	local db = E.db.KlixUI.misc.panels.top
	local frame = ElvUI_TopPanel

	if E.db.KlixUI.general.style then
		if db.style then
			ElvUI_TopPanel:Styling()
		else
			if frame.squares or frame.gradient or frame.mshadow then
				ElvUI_TopPanel.squares:SetTexture(nil)
				ElvUI_TopPanel.gradient:SetTexture(nil)
				ElvUI_TopPanel.mshadow:SetTexture(nil)
			end
		end
	end

	if db.transparency then
		ElvUI_TopPanel:SetTemplate('Transparent')
	else
		ElvUI_TopPanel:SetTemplate('Default')
	end

	ElvUI_TopPanel:Height(db.height)

end

function KUIL:BottomPanelLayout()
	local db = E.db.KlixUI.misc.panels.bottom
	local frame = ElvUI_BottomPanel

	if E.db.KlixUI.general.style then
		if db.style then
			ElvUI_BottomPanel:Styling()
		else
			if frame.squares or frame.gradient or frame.mshadow then
				ElvUI_BottomPanel.squares:SetTexture(nil)
				ElvUI_BottomPanel.gradient:SetTexture(nil)
				ElvUI_BottomPanel.mshadow:SetTexture(nil)
			end
		end
	end

	if db.transparency then
		ElvUI_BottomPanel:SetTemplate('Transparent')
	else
		ElvUI_BottomPanel:SetTemplate('Default')
	end

	ElvUI_BottomPanel:Height(db.height)
end

function KUIL:regEvents()
	self:MiddleDatatextLayout()
	self:MiddleDatatextDimensions()
	self:ResizeMinimapPanels()
	self:ToggleTransparency()
end

function KUIL:SetShadowLevel(n)
	self.f:SetAlpha(n/100)
end

function KUIL:ShadowOverlay()
	-- Based on ncShadow, Credits go to Merathilis
	if not E.db.KlixUI.general.shadowOverlay.enable then return end

	self.f = T.CreateFrame("Frame", KUI.Title.."ShadowBackground")
	self.f:SetPoint("TOPLEFT")
	self.f:SetPoint("BOTTOMRIGHT")
	self.f:SetFrameLevel(0)
	self.f:SetFrameStrata("BACKGROUND")

	self.f.tex = self.f:CreateTexture()
	self.f.tex:SetTexture([[Interface\Addons\ElvUI_KlixUI\media\textures\overlay]])
	self.f.tex:SetAllPoints(self.f)
	
	self:SetShadowLevel(E.db.KlixUI.general.shadowOverlay.alpha or 60)
end

-- Based on CodeNameBlaze chat lines
function KUIL:ToggleChatSeparators()
	if E.db.KlixUI.chat.chatTabSeparator == 'SHOWBOTH' then
		LeftChatTabSeparator:Show()
		RightChatTabSeparator:Show()
	elseif E.db.KlixUI.chat.chatTabSeparator == 'HIDEBOTH' then
		LeftChatTabSeparator:Hide()
		RightChatTabSeparator:Hide()
	elseif E.db.KlixUI.chat.chatTabSeparator == 'LEFTONLY' then
		LeftChatTabSeparator:Show()
		RightChatTabSeparator:Hide()
	elseif E.db.KlixUI.chat.chatTabSeparator == 'RIGHTONLY' then
		LeftChatTabSeparator:Hide()
		RightChatTabSeparator:Show()
	end
	
	if E.db.KlixUI.chat.chatDataSeparator == 'SHOWBOTH' then
		LeftDataPanelSeparator:Show()
		RightDataPanelSeparator:Show()
	elseif E.db.KlixUI.chat.chatDataSeparator == 'HIDEBOTH' then
		LeftDataPanelSeparator:Hide()
		RightDataPanelSeparator:Hide()
	elseif E.db.KlixUI.chat.chatDataSeparator == 'LEFTONLY' then
		LeftDataPanelSeparator:Show()
		RightDataPanelSeparator:Hide()
	elseif E.db.KlixUI.chat.chatDataSeparator == 'RIGHTONLY' then
		LeftDataPanelSeparator:Hide()
		RightDataPanelSeparator:Show()
	end
end

function KUIL:PLAYER_ENTERING_WORLD(...)
	self:ToggleKuiDts()
	self:ToggleLeftChatPanel()
	self:ToggleRightChatPanel()
	self:ToggleChatSeparators()
	self:regEvents()
	self:ShadowOverlay()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function KUIL:Initialize()
	RegKuiDataTexts()
	self:ChangeLayout()
	self:TopPanelLayout()
	self:BottomPanelLayout()
	self:Styles()
	hooksecurefunc(LO, 'ToggleChatPanels', KUIL.ToggleKuiDts)
	hooksecurefunc(LO, 'ToggleChatPanels', KUIL.ResizeMinimapPanels)
	hooksecurefunc(M, 'UpdateSettings', KUIL.ResizeMinimapPanels)
	hooksecurefunc(DT, 'LoadDataTexts', updateButtonFont)
	hooksecurefunc(E, 'UpdateMedia', updateButtonFont)
	self:RegisterEvent('PLAYER_ENTERING_WORLD')
	--self:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED', 'regEvents')
end

local function InitializeCallback()
	KUIL:Initialize()
end

KUI:RegisterModule(KUIL:GetName(), InitializeCallback)