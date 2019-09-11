local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KC = KUI:NewModule("KuiChat", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
local CH = E:GetModule('Chat')

local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS

KC.SelectedStrings = {
	["DEFAULT"] = "|cff%02x%02x%02x>|r %s |cff%02x%02x%02x<|r",
	["SQUARE"] = "|cff%02x%02x%02x[|r %s |cff%02x%02x%02x]|r",
	["BEND"] = "|cff%02x%02x%02x(|r %s |cff%02x%02x%02x)|r",
	["HALFDEFAULT"] = "|cff%02x%02x%02x>|r %s",
	["CHECKBOX"] = [[|TInterface\ACHIEVEMENTFRAME\UI-Achievement-Criteria-Check:%s|t%s]],
	["ARROWRIGHT"] = [[|TInterface\BUTTONS\UI-SpellbookIcon-NextPage-Up:%s|t%s]],
	["ARROWDOWN"] = [[|TInterface\BUTTONS\UI-MicroStream-Green:%s|t%s]],
}

local CreatedFrames = 0;

local function Style(self, frame)
	CreatedFrames = frame:GetID()
end

--Replacement of chat tab position and size function
local PixelOff = E.PixelMode and 33 or 27

local function PositionChat(self, override)
	if ((T.InCombatLockdown() and not override and self.initialMove) or (T.IsMouseButtonDown("LeftButton") and not override)) then return end
	if not RightChatPanel or not LeftChatPanel then return; end
	if not self.db.lockPositions or E.private.chat.enable ~= true then return end

	local BASE_OFFSET = 60
	if E.PixelMode then
		BASE_OFFSET = BASE_OFFSET - 3
	end
	local chat, id, tab, isDocked, point
	for i=1, CreatedFrames do
		chat = _G[T.string_format("ChatFrame%d", i)]
		id = chat:GetID()
		tab = _G[T.string_format("ChatFrame%sTab", i)]
		point = T.GetChatWindowSavedPosition(id)
		isDocked = chat.isDocked
		tab.flashTab = true

		if chat:IsShown() and not (id > NUM_CHAT_WINDOWS) and id == CH.RightChatWindowID then
			chat:ClearAllPoints()
			if E.db.datatexts.rightChatPanel then
				chat:Point("BOTTOMRIGHT", RightChatDataPanel, "TOPRIGHT", 10, 3)
			else
				BASE_OFFSET = BASE_OFFSET - 24
				chat:SetPoint("BOTTOMLEFT", RightChatPanel, "BOTTOMLEFT", 4, 4)
			end
			if id ~= 2 then
				chat:Size((E.db.chat.separateSizes and E.db.chat.panelWidthRight or E.db.chat.panelWidth) - 10, ((E.db.chat.separateSizes and E.db.chat.panelHeightRight or E.db.chat.panelHeight) - PixelOff))
			end
		elseif not isDocked and chat:IsShown() then

		else
			if id ~= 2 and not (id > NUM_CHAT_WINDOWS) then
				BASE_OFFSET = BASE_OFFSET - 24
				chat:SetPoint("BOTTOMLEFT", LeftChatPanel, "BOTTOMLEFT", 4, 4)
				chat:Size(E.db.chat.panelWidth - 10, E.db.chat.panelHeight - PixelOff)
			end
		end
	end
end
hooksecurefunc(CH, "PositionChat", PositionChat)
hooksecurefunc(CH, "StyleChat", Style)

function KC:SetSelectedTab(isForced)
	local selectedId = GeneralDockManager.selected:GetID()

	--Set/Remove brackets and set alpha of chat tabs
	for i=1, CreatedFrames do
		local tab = _G[T.string_format("ChatFrame%sTab", i)]
		if tab.isDocked then
			--Brackets
			if selectedId == tab:GetID() and E.db.KlixUI.chat.select then
				if tab.hasBracket ~= true or isForced then
					local color = E.db.KlixUI.chat.colorTab
					if E.db.KlixUI.chat.styleTab == "DEFAULT" or E.db.KlixUI.chat.styleTab == "SQUARE" or E.db.KlixUI.chat.styleTab == "BEND" then
						tab.text:SetText(T.string_format(KC.SelectedStrings[E.db.KlixUI.chat.styleTab], color.r * 255, color.g * 255, color.b * 255, (T.FCF_GetChatWindowInfo(tab:GetID())), color.r * 255, color.g * 255, color.b * 255))
					elseif E.db.KlixUI.chat.styleTab == "HALFDEFAULT" then
						tab.text:SetText(T.string_format(KC.SelectedStrings[E.db.KlixUI.chat.styleTab], color.r * 255, color.g * 255, color.b * 255, (T.FCF_GetChatWindowInfo(tab:GetID()))))
					else
						tab.text:SetText(T.string_format(KC.SelectedStrings[E.db.KlixUI.chat.styleTab], (E.db.chat.tabFontSize + 12), (T.FCF_GetChatWindowInfo(tab:GetID()))))
					end
					tab.hasBracket = true
				end
			else
				if tab.hasBracket == true then
					local tabText = tab.isTemporary and tab.origText or (T.FCF_GetChatWindowInfo(tab:GetID()))
					tab.text:SetText(tabText)
					tab.hasBracket = false
				end
			end
			--Alpha
			tab.SetAlpha = nil
			if selectedId == tab:GetID() or not E.db.KlixUI.chat.fadeChatTabs then
				tab:SetAlpha(1)
			else
				tab:SetAlpha(E.db.KlixUI.chat.fadedChatTabAlpha)
			end
			tab.SetAlpha = E.noop
		end

		--Prevent chat tabs changing width on each click.
		T.PanelTemplates_TabResize(tab, tab.isTemporary and 20 or 10, nil, nil, nil, tab.textWidth);
	end
end

function KC:OpenTemporaryWindow()
	local chatID = T.FCF_GetCurrentChatFrameID()
	local tab = _G[T.string_format("ChatFrame%sTab", chatID)]
	tab.origText = (T.FCF_GetChatWindowInfo(tab:GetID()))
	KC:SetSelectedTab()
end

function KC:DelaySetSelectedTab()
	KC:ScheduleTimer('SetSelectedTab', 1)
end

function KC:SetTabWidth()
	for i=1, CreatedFrames do
		local tab = _G[T.string_format("ChatFrame%sTab", i)]
		T.PanelTemplates_TabResize(tab, tab.isTemporary and 20 or 10, nil, nil, nil, tab.textWidth);
	end
end

function KC:StyleChat(frame)
	if frame.KCstyled then return end

	local name = frame:GetName()
	local id = frame:GetID()
	local tab = _G[name..'Tab']
	
	--Store variables for each tab
	tab.isTemporary = frame.isTemporary
	tab.isDocked = frame.isDocked
	tab.SetAlpha = E.noop --Prevent ElvUI or WoW from changing alpha on the tab

	--Mark current selected tab on initial load and set alpha of chat tabs
	if GeneralDockManager.selected:GetID() == tab:GetID() then
		if not tab.isTemporary and E.db.KlixUI.chat.select then
			local color = E.db.KlixUI.chat.colorTab
				if E.db.KlixUI.chat.styleTab == "DEFAULT" or E.db.KlixUI.chat.styleTab == "SQUARE" or E.db.KlixUI.chat.styleTab == "BEND" then
					tab.text:SetText(T.string_format(KC.SelectedStrings[E.db.KlixUI.chat.styleTab], color.r * 255, color.g * 255, color.b * 255, (T.FCF_GetChatWindowInfo(tab:GetID())), color.r * 255, color.g * 255, color.b * 255))
				elseif E.db.KlixUI.chat.styleTab == "HALFDEFAULT" then
					tab.text:SetText(T.string_format(KC.SelectedStrings[E.db.KlixUI.chat.styleTab], color.r * 255, color.g * 255, color.b * 255, (T.FCF_GetChatWindowInfo(tab:GetID()))))
				else
					tab.text:SetText(T.string_format(KC.SelectedStrings[E.db.KlixUI.chat.styleTab], (E.db.chat.tabFontSize + 12), (T.FCF_GetChatWindowInfo(tab:GetID()))))
				end
			tab.hasBracket = true
		end
		tab.SetAlpha = nil --Re-enable SetAlpha
		tab:SetAlpha(1)
		tab.SetAlpha = E.noop --Disable SetAlpha once more
	else
		tab.SetAlpha = nil
		if E.db.KlixUI.chat.fadeChatTabs then
			tab:SetAlpha(E.db.KlixUI.chat.fadedChatTabAlpha)
		else
			tab:SetAlpha(1)
		end
		tab.SetAlpha = E.noop
	end
	
	--Mark current selected tab if renamed
	hooksecurefunc(tab, "SetText", function(self)
		if self.isDocked and GeneralDockManager.selected:GetID() == self:GetID() and not self.isTemporary and E.db.KlixUI.chat.select then
			local color = E.db.KlixUI.chat.colorTab
				if E.db.KlixUI.chat.styleTab == "DEFAULT" or E.db.KlixUI.chat.styleTab == "SQUARE" or E.db.KlixUI.chat.styleTab == "BEND" then
					tab.text:SetText(T.string_format(KC.SelectedStrings[E.db.KlixUI.chat.styleTab], color.r * 255, color.g * 255, color.b * 255, (T.FCF_GetChatWindowInfo(tab:GetID())), color.r * 255, color.g * 255, color.b * 255))
				elseif E.db.KlixUI.chat.styleTab == "HALFDEFAULT" then
					tab.text:SetText(T.string_format(KC.SelectedStrings[C.db.tab.style], color.r * 255, color.g * 255, color.b * 255, (T.FCF_GetChatWindowInfo(tab:GetID()))))
				else
					tab.text:SetText(T.string_format(KC.SelectedStrings[E.db.KlixUI.chat.styleTab], (E.db.chat.tabFontSize + 12), (T.FCF_GetChatWindowInfo(tab:GetID()))))
				end
			self.hasBracket = true
		end
	end)
	
	--Prevent text from jumping from left to right when tab is clicked.
	hooksecurefunc(tab, "SetWidth", function(self)
		self.text:ClearAllPoints()
		self.text:SetPoint("CENTER", self, "CENTER", 0, -4)
	end)
	
	--Mark current selected tab when clicked
	tab:HookScript("OnClick", function()
		KC:SetSelectedTab()
	end)
	
	CreatedFrames = id
	frame.KCstyled = true
end
hooksecurefunc(CH, "StyleChat", KC.StyleChat)

function KC:ModifyChatTabs(override)
	--If "Force to Show" is not enabled then just stop here
	if not E.db.KlixUI.chat.forceShow then return end

	local fade = E.db.KlixUI.chat.fadeChatTabs
	local fadeAlpha = E.db.KlixUI.chat.fadedChatTabAlpha
	local showBelowAlpha = E.db.KlixUI.chat.forceShowBelowAlpha
	local showToAlpha = E.db.KlixUI.chat.forceShowToAlpha

	for i = 1, CreatedFrames do
		local tab = _G[T.string_format("ChatFrame%sTab", i)]
		local text = _G[T.string_format("ChatFrame%sTabText", i)]
		
		--If chat panel backdrop is hidden then force tab to show when flashing
		if E.db.chat.panelBackdrop ~= 'SHOWBOTH' then
			if tab.glow:IsShown() then
				CH:SetupChatTabs(tab, false)
			else
				CH:SetupChatTabs(tab, true)
			end
		end

		--If chat tab is faded then force it to show when flashing
		if i ~= GeneralDockManager.selected:GetID() then
			if tab.glow:IsShown() then
				tab.SetAlpha = nil
				if fade and fadeAlpha <= showBelowAlpha then
					tab:SetAlpha(showToAlpha)
				else
					tab:SetAlpha(fadeAlpha)
				end
				tab.SetAlpha = E.noop
			end
		end
	end
end
hooksecurefunc(CH, "PositionChat", KC.ModifyChatTabs)

function KC:StyleChat()
	-- Style the chat
	_G["LeftChatPanel"].backdrop:Styling()
	_G["RightChatPanel"].backdrop:Styling()
end

function KC:Initialize()
	if E.private.chat.enable ~= true then return; end
	
	self:StyleChat()
	
	--Bracket selected chat tab and set correct width
	hooksecurefunc("FCF_OpenNewWindow", KC.DelaySetSelectedTab)
	hooksecurefunc("FCF_OpenTemporaryWindow", KC.OpenTemporaryWindow)
	hooksecurefunc("FCFDockOverflowListButton_OnClick", KC.SetSelectedTab)
	hooksecurefunc("FCF_Close", KC.SetSelectedTab)
	hooksecurefunc("FCF_DockUpdate", KC.SetTabWidth)
	
	_G["ERR_FRIEND_ONLINE_SS"] = "[%s] "..L["has come |cff298F00online|r."]
	_G["ERR_FRIEND_OFFLINE_S"] = "[%s] "..L["has gone |cffff0000offline|r."]

	_G["BN_INLINE_TOAST_FRIEND_ONLINE"] = "[%s]"..L[" has come |cff298F00online|r."]
	_G["BN_INLINE_TOAST_FRIEND_OFFLINE"] = "[%s]"..L[" has gone |cffff0000offline|r."]
	
	_G["GUILD_MOTD_TEMPLATE"] = L["|cfff960d9GMOTD:|r %s"]
	
	self:LoadChatEmote()
end

local function InitializeCallback()
	KC:Initialize()
end

KUI:RegisterModule(KC:GetName(), InitializeCallback)