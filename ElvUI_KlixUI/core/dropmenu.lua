local KUI, T, E, L, V, P, G = unpack(select(2, ...))

local PADDING = 10
local BUTTON_HEIGHT = 16
local BUTTON_WIDTH = 135
local counter = 0
local hoverVisible = false

KUI.MenuList = {
	{text = CHARACTER_BUTTON, func = function() ToggleCharacter("PaperDollFrame") end},
	{text = SPELLBOOK_ABILITIES_BUTTON, func = function() if not SpellBookFrame:IsShown() then T.ShowUIPanel(SpellBookFrame) else T.HideUIPanel(SpellBookFrame) end end},
	{text = TALENTS,
	func = function()
		if not PlayerTalentFrame then
			T.ToggleTalentFrame()
		end
	end},
	{text = L["Skills"],
	func = function()
		if not PlayerTalentFrame then
			 ToggleCharacter("SkillFrame")
		end
	end},
	{text = REPUTATION, func = function() ToggleCharacter('ReputationFrame') end},
	{text = L["Communities"], func = function() ToggleGuildFrame() end},
	{text = MACROS, func = function() GameMenuButtonMacros:Click() end},
	{text = TIMEMANAGER_TITLE, func = function() T.ToggleFrame(TimeManagerFrame) end},
	{text = SOCIAL_BUTTON, func = function() ToggleFriendsFrame() end},
	{text = MAINMENU_BUTTON,
	func = function()
		if ( not GameMenuFrame:IsShown() ) then
			if ( VideoOptionsFrame:IsShown() ) then
					VideoOptionsFrameCancel:Click();
			elseif ( AudioOptionsFrame:IsShown() ) then
					AudioOptionsFrameCancel:Click();
			elseif ( InterfaceOptionsFrame:IsShown() ) then
					InterfaceOptionsFrameCancel:Click();
			end
			CloseMenus();
			CloseAllWindows()
			T.ShowUIPanel(GameMenuFrame);
		else
			T.HideUIPanel(GameMenuFrame);
			MainMenuMicroButton_SetNormal();
		end
	end},
	{text = HELP_BUTTON, func = function() ToggleHelpFrame() end},
}

local function sortFunction(a, b)
	return a.text < b.text
end

table.sort(KUI.MenuList, sortFunction)

local function OnClick(btn)
	local parent = btn:GetParent()
	btn.func()
	T.UIFrameFadeOut(parent, 0.3, parent:GetAlpha(), 0)
	parent.fadeInfo.finishedFunc = function() parent:Hide() end
end

local function OnEnter(btn)
	E:UIFrameFadeIn(btn.hoverTex, .3, 0, 1)
	hoverVisible = true
end

local function OnLeave(btn)
	E:UIFrameFadeOut(btn.hoverTex, .3, 1, 0)
	hoverVisible = false
end

-- added parent, removed the mouse x,y and set menu frame position to any parent corners.
-- Also added delay to autohide
function KUI:Dropmenu(list, frame, parent, pos, xOffset, yOffset, delay, addedSize)
	local db = E.db.KlixUI.gamemenu
	
	local r, g, b
	if db.color == 1 then
		r, g, b = KUI.r, KUI.g, KUI.b
	elseif db.color == 2 then
		r, g, b = KUI:unpackColor(db.customColor)
	else
		r, g, b = KUI:unpackColor(E.db.general.valuecolor)
	end
	
	if not frame.buttons then
		frame.buttons = {}
		frame:SetParent(parent)
		frame:SetFrameStrata('DIALOG')
		frame:SetClampedToScreen(true)
		T.table_insert(T.UISpecialFrames, frame:GetName())
		frame:Hide()
		frame:Styling()
	end

	xOffset = xOffset or 0
	yOffset = yOffset or 0

	for i=1, #frame.buttons do
		frame.buttons[i]:Hide()
	end

	for i=1, #list do 
		if not frame.buttons[i] then
			frame.buttons[i] = T.CreateFrame('Button', nil, frame)

			frame.buttons[i].hoverTex = frame.buttons[i]:CreateTexture(nil, 'OVERLAY')
			frame.buttons[i].hoverTex:SetAllPoints()
			frame.buttons[i].hoverTex:SetTexture(E.Media.Textures.Highlight)
			frame.buttons[i].hoverTex:SetBlendMode('BLEND')
			frame.buttons[i].hoverTex:SetDrawLayer('BACKGROUND')
			frame.buttons[i].hoverTex:SetAlpha(0)

			frame.buttons[i].text = frame.buttons[i]:CreateFontString(nil, 'BORDER')
			frame.buttons[i].text:SetAllPoints()
			frame.buttons[i].text:FontTemplate()
			frame.buttons[i].text:SetJustifyH('LEFT')

			frame.buttons[i]:SetScript('OnEnter', OnEnter)
			frame.buttons[i]:SetScript('OnLeave', OnLeave)
		end

		frame.buttons[i]:Show()
		frame.buttons[i]:SetHeight(BUTTON_HEIGHT)
		frame.buttons[i]:SetWidth(BUTTON_WIDTH + (addedSize or 0))
		frame.buttons[i].text:SetText(list[i].text)
		frame.buttons[i].text:SetTextColor(r, g, b)
		frame.buttons[i].hoverTex:SetVertexColor(r, g, b)
		frame.buttons[i].func = list[i].func
		frame.buttons[i]:SetScript('OnClick', OnClick)

		if i == 1 then
			frame.buttons[i]:SetPoint('TOPLEFT', frame, 'TOPLEFT', PADDING, -PADDING)
		else
			frame.buttons[i]:SetPoint('TOPLEFT', frame.buttons[i-1], 'BOTTOMLEFT')
		end
	end

	frame:SetScript('OnShow', function(self)
		T.UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
	end)

	frame:SetScript('OnUpdate', function(self, elapsed)
		if hoverVisible then return end
		counter = counter + elapsed
		if counter >= delay then
			T.UIFrameFadeOut(self, 0.3, self:GetAlpha(), 0)
			self.fadeInfo.finishedFunc = function() self:Hide() end
			counter = 0
		end
	end)

	frame:SetHeight((#list * BUTTON_HEIGHT) + PADDING * 2)
	frame:SetWidth(BUTTON_WIDTH + PADDING * 2 + (addedSize or 0))
	frame:ClearAllPoints()
	if pos == 'tLeft' then
		frame:SetPoint('BOTTOMRIGHT', parent, 'TOPLEFT', xOffset, yOffset)
	elseif pos == 'tRight' then
		frame:SetPoint('BOTTOMLEFT', parent, 'TOPRIGHT', xOffset, yOffset)
	elseif pos == 'bLeft' then
		frame:SetPoint('TOPRIGHT', parent, 'BOTTOMLEFT', xOffset, yOffset)
	elseif pos == 'bRight' then
		frame:SetPoint('TOPLEFT', parent, 'BOTTOMRIGHT', xOffset, yOffset)
	end

	T.ToggleFrame(frame)
end