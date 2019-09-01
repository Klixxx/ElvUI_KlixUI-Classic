local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local AP = KUI:NewModule('AddonControlPanel', 'AceEvent-3.0')
local S = E:GetModule('Skins')
local LSM = E.LSM or E.Libs.LSM

AddonPanelProfilesDB = {}
AddonPanelServerDB = {}

local Color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass]
AP.ClassColor = { Color.r, Color.g, Color.b }

StaticPopupDialogs["ADDONPANEL_OVERWRITEPROFILE"] = {
	button1 = L["Overwrite"],
	button2 = CANCEL,
	timeout = 0,
	whileDead = 1,
	enterClicksFirstButton = 1,
	hideOnEscape = 1,
}

StaticPopupDialogs["ADDONPANEL_NEWPROFILE"] = {
	text = L["Enter a name for your new Addon Profile:"],
	button1 = L["Create"],
	button2 = CANCEL,
	timeout = 0,
	hasEditBox = 1,
	whileDead = 1,
	OnAccept = function(self) AP:NewAddOnProfile(self.editBox:GetText()) end,
	EditBoxOnEnterPressed = function(self) AP:NewAddOnProfile(self:GetText()) self:GetParent():Hide() end,
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
}

StaticPopupDialogs["ADDONPANEL_RENAMEPROFILE"] = {
	text = L["Enter a name for your AddOn Profile:"],
	button1 = L["Update"],
	button2 = CANCEL,
	timeout = 0,
	hasEditBox = 1,
	whileDead = 1,
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
}

StaticPopupDialogs["ADDONPANEL_DELETECONFIRMATION"] = {
	button1 = DELETE,
	button2 = CANCEL,
	timeout = 0,
	whileDead = 1,
	enterClicksFirstButton = 1,
	hideOnEscape = 1,
}

local function strtrim(string)
	return string:gsub("^%s*(.-)%s*$", "%1")
end

function AP:BuildFrame()
	local Frame = T.CreateFrame("Frame", "APFrame", UIParent)
	local Close = T.CreateFrame("Button", "APCloseButton", Frame)
	local Reload = T.CreateFrame("Button", "APReload", Frame)
	local Search = T.CreateFrame("EditBox", "APSearchBox", Frame)
	local CharacterSelect = T.CreateFrame("Button", nil, Frame)
	local Profiles = T.CreateFrame("Button", "APProfiles", Frame)
	local AddOns = T.CreateFrame("Frame", "APAddOns", Frame)
	local Slider = T.CreateFrame("Slider", nil, AddOns)

	local Title = Frame:CreateFontString(nil, "OVERLAY")

	Frame:SetSize(AP.db["FrameWidth"], 10 + AP.db["NumAddOns"] * 25 + 40)
	Frame:SetPoint("CENTER", E.UIParent, "CENTER", 0, 0)
	Frame:SetTemplate("Transparent")
	Frame:SetFrameStrata("HIGH")
	Frame:SetClampedToScreen(true)
	Frame:SetMovable(true)
	Frame:EnableMouse(true)
	Frame:SetScript("OnMouseDown", function(self) self:StartMoving() end)
	Frame:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
	Frame:Styling()

	Title:SetPoint("TOPLEFT", 0, -5)
	Title:SetPoint("TOPRIGHT", 0, -5)
	Title:SetFont(LSM:Fetch("font", AP.db["Font"]), 14, AP.db["FontFlag"])
	Title:SetText(KUI.Title.."Addon Control Panel")
	Title:SetJustifyH("CENTER")
	Title:SetJustifyV("MIDDLE")

	Close:SetPoint("TOPRIGHT", 0, 0)
	Close:SetSize(16 + ((E.PixelMode and 4) or 8), 16 + ((E.PixelMode and 4) or 8))
	S:HandleCloseButton(Close)
	Close:SetScript('OnClick', function(self) Frame:Hide() end)

	Search:SetPoint('TOPLEFT', Title, 'BOTTOMLEFT', 10, -10)
	Search:SetPoint('BOTTOMRIGHT', Profiles, 'BOTTOMLEFT', -5, 0)
	Search:SetSize(1, 20)
	Search:SetTemplate("Transparent")
	Search:SetAutoFocus(false)
	Search:SetTextInsets(5, 5, 0, 0)
	Search:SetTextColor(1, 1, 1)
	Search:SetFont(LSM:Fetch('font', AP.db['Font']), 12, AP.db['FontFlag'])
	Search:SetShadowOffset(0,0)
	Search:SetText(L['Search'])
	Search.AddOns = {}
	Search:HookScript('OnEscapePressed', function(self) AP:UpdateAddonList() self:SetText("Search") self:ClearFocus()end)
	Search:HookScript('OnTextChanged', function(self, userInput) AP.scrollOffset = 0 AP.searchQuery = userInput AP:UpdateAddonList() end)
	Search:HookScript('OnEditFocusGained', function(self) self:SetBackdropBorderColor(T.unpack(AP.db['ClassColor'] and AP.ClassColor or AP.db['CheckColor'])) self:HighlightText() end)
	Search:HookScript('OnEditFocusLost', function(self) self:SetTemplate() self:HighlightText(0, 0) end)
	Search:HookScript('OnEnterPressed', function(self)
		if T.string_len(T.strtrim(self:GetText())) == 0 then
			AP:UpdateAddonList()
			self:SetText("Search")
			AP.searchQuery = false
		end
		self:ClearFocus()
	end)

	Reload:SetTemplate("Transparent")
	Reload:SetSize(70, 20)
	Reload:SetScript('OnEnter', function(self) self:SetBackdropBorderColor(unpack(AP.db['ClassColor'] and AP.ClassColor or AP.db['CheckColor'])) end)
	Reload:SetScript('OnLeave', function(self) self:SetTemplate() end)
	Reload:SetScript('OnClick', T.ReloadUI)
	Reload.Text = Reload:CreateFontString(nil, 'OVERLAY')
	Reload.Text:SetFont(LSM:Fetch('font', self.db['Font']), 12, self.db['FontFlag'])
	Reload.Text:SetText(L['Reload'])
	Reload.Text:SetPoint('CENTER', 0, 0)
	Reload.Text:SetJustifyH('CENTER')
	Reload:SetPoint('TOPLEFT', AddOns, 'BOTTOMLEFT', 0, -10)

	CharacterSelect:SetPoint('TOPRIGHT', AddOns, 'BOTTOMRIGHT', 0, -10)
	CharacterSelect.DropDown = T.CreateFrame('Frame', 'APCharacterSelectDropDown', CharacterSelect, 'UIDropDownMenuTemplate')
	CharacterSelect:SetSize(150, 20)
	CharacterSelect:SetTemplate()
	CharacterSelect:SetScript('OnEnter', function(self) self:SetBackdropBorderColor(unpack(AP.db['ClassColor'] and AP.ClassColor or AP.db['CheckColor'])) end)
	CharacterSelect:SetScript('OnLeave', function(self) self:SetTemplate() end)
	CharacterSelect:SetScript('OnClick', function(self) T.EasyMenu(AP.Menu, self.DropDown, self, 0, 38 + (AP.MenuOffset * 16), "MENU", 5) end)
	CharacterSelect.Text = CharacterSelect:CreateFontString(nil, 'OVERLAY')
	CharacterSelect.Text:SetFont(LSM:Fetch('font', AP.db['Font']), 12, AP.db['FontFlag'])
	CharacterSelect.Text:SetText(L['Character Select'])
	CharacterSelect.Text:SetPoint('CENTER', 0, 0)
	CharacterSelect.Text:SetJustifyH('CENTER')

	Profiles:SetPoint('TOPRIGHT', Title, 'BOTTOMRIGHT', -10, -10)
	Profiles:SetTemplate()
	Profiles:SetSize(70, 20)
	Profiles:SetScript('OnEnter', function(self) self:SetBackdropBorderColor(T.unpack(AP.db['ClassColor'] and AP.ClassColor or AP.db['CheckColor'])) end)
	Profiles:SetScript('OnLeave', function(self) self:SetTemplate() end)
	Profiles:SetScript('OnClick', function() AP:ToggleProfiles() end)

	Profiles.Text = Profiles:CreateFontString(nil, 'OVERLAY')
	Profiles.Text:SetFont(LSM:Fetch('font', AP.db['Font']), 12, AP.db['FontFlag'])
	Profiles.Text:SetText(L['Profiles'])
	Profiles.Text:SetPoint('CENTER', 0, 0)
	Profiles.Text:SetJustifyH('CENTER')

	AddOns:SetPoint('TOPLEFT', Search, 'BOTTOMLEFT', 0, -5)
	AddOns:SetPoint('TOPRIGHT', Profiles, 'BOTTOMRIGHT', 0, -5)
	AddOns:SetHeight(self.db['NumAddOns'] * (AP.db['ButtonHeight'] + 5) + 15)
	AddOns:SetTemplate()
	AddOns.Buttons = {}
	AddOns:EnableMouse(true)
	AddOns:EnableMouseWheel(true)
	AddOns:SetTemplate("Transparent")

	Slider:SetPoint("RIGHT", -2, 0)
	Slider:SetWidth(14)
	Slider:SetHeight(self.db['NumAddOns'] * (self.db['ButtonHeight'] + 5) + 11)
	Slider:SetThumbTexture(LSM:Fetch('statusbar', AP.db['CheckTexture']))
	Slider:SetOrientation("VERTICAL")
	Slider:SetValueStep(1)
	Slider:SetTemplate("Transparent")
	Slider:SetMinMaxValues(0, 1)
	Slider:SetValue(0)
	Slider:EnableMouse(true)
	Slider:EnableMouseWheel(true)

	local Thumb = Slider:GetThumbTexture()
	Thumb:SetSize(10, 16)
	Thumb:SetVertexColor(T.unpack(AP.db['ClassColor'] and AP.ClassColor or AP.db['CheckColor']))

	AddOns.ScrollBar = Slider

	local OnScroll = function(self, delta)
		local numAddons = AP.searchQuery and #Search.AddOns or #AP.AddOnInfo
		if T.IsShiftKeyDown() then
			if delta == 1 then
				AP.scrollOffset = max(0, AP.scrollOffset - AP.db['NumAddOns'])
			elseif delta == -1 then
				AP.scrollOffset = min(numAddons - AP.db['NumAddOns'], AP.scrollOffset + AP.db['NumAddOns'])
			end
		else
			if delta == 1 and AP.scrollOffset > 0 then
				AP.scrollOffset = AP.scrollOffset - 1
			elseif delta == -1 then
				if AP.scrollOffset < numAddons - AP.db['NumAddOns'] then
					AP.scrollOffset = AP.scrollOffset + 1
				end
			end
		end
		Slider:SetMinMaxValues(0, (numAddons - AP.db['NumAddOns']))
		Slider:SetValue(AP.scrollOffset)
		AP:UpdateAddonList()
	end

	AddOns:SetScript('OnMouseWheel', OnScroll)
	Slider:SetScript('OnMouseWheel', OnScroll)
	Slider:SetScript('OnValueChanged', function(self, value)
		AP.scrollOffset = value
		OnScroll()
	end)

	for i = 1, 30 do
		local CheckButton = T.CreateFrame('CheckButton', 'APCheckButton_'..i, AddOns)
		CheckButton:SetTemplate("Transparent")
		CheckButton:SetSize(AP.db['ButtonWidth'], AP.db['ButtonHeight'])
		CheckButton:SetPoint(T.unpack(i == 1 and {"TOPLEFT", AddOns, "TOPLEFT", 10, -10} or {"TOP", AddOns.Buttons[i-1], "BOTTOM", 0, -5}))
		CheckButton:SetScript('OnClick', function(self)
			if self.name then
				if KUI:IsAddOnEnabled(self.name, AP.SelectedCharacter) then
					T.DisableAddOn(self.name, AP.SelectedCharacter)
				else
					T.EnableAddOn(self.name, AP.SelectedCharacter)
				end
				AP:UpdateAddonList()
			end
		end)
		CheckButton:SetScript('OnEnter', function(self)
			GameTooltip:SetOwner(self, 'ANCHOR_TOPRIGHT', 0, 4)
			GameTooltip:ClearLines()
			GameTooltip:AddDoubleLine('AddOn:', self.title, 1, 1, 1, 1, 1, 1)
			GameTooltip:AddDoubleLine('Notes:', self.notes, 1, 1, 1, 1, 1, 1)
			if self.requireddeps or self.optionaldeps then
				GameTooltip:AddLine(' ')
			end
			if self.requireddeps then
				GameTooltip:AddDoubleLine('Required Dependencies:', self.requireddeps, 1, 1, 1, 1, 1, 1)
			end
			if self.optionaldeps then
				GameTooltip:AddDoubleLine('Optional Dependencies:', self.optionaldeps, 1, 1, 1, 1, 1, 1)
			end
			GameTooltip:Show()
			self:SetBackdropBorderColor(unpack(AP.db['ClassColor'] and AP.ClassColor or AP.db['CheckColor']))
		end)
		CheckButton:SetScript('OnLeave', function(self) self:SetTemplate() GameTooltip:Hide() end)

		local Checked = CheckButton:CreateTexture(nil, 'OVERLAY', nil, 1)
		Checked:SetTexture(LSM:Fetch('statusbar', AP.db['CheckTexture']))
		Checked:SetVertexColor(T.unpack(AP.db['ClassColor'] and AP.ClassColor or AP.db['CheckColor']))
		Checked:SetInside(CheckButton)

		CheckButton.CheckTexture = Checked
		CheckButton:SetCheckedTexture(Checked)

		CheckButton:SetHighlightTexture('')

		local Text = CheckButton:CreateFontString(nil, 'OVERLAY')
		Text:SetPoint('LEFT', 5, 0)
		Text:SetFont(LSM:Fetch('font', AP.db['Font']), AP.db['FontSize'], AP.db['FontFlag'])
		Text:SetText('')
		Text:SetJustifyH('CENTER')
		Text:ClearAllPoints()
		Text:SetPoint("LEFT", CheckButton, "RIGHT", 10, 0)
		Text:SetPoint("TOP", CheckButton, "TOP")
		Text:SetPoint("BOTTOM", CheckButton, "BOTTOM")
		Text:SetPoint("RIGHT", AddOns, "RIGHT", -10, 0)
		Text:SetJustifyH("LEFT")

		CheckButton.Text = Text

		AddOns.Buttons[i] = CheckButton
	end

	Frame.Title = Title
	Frame.Close = Close
	Frame.Reload = Reload
	Frame.Search = Search
	Frame.CharacterSelect = CharacterSelect
	Frame.Profiles = Profiles
	Frame.AddOns = AddOns
	self.Frame = Frame

	T.table_insert(UISpecialFrames, self.Frame:GetName())

	GameMenuButtonAddons:SetScript("OnClick", function() self.Frame:Show() T.HideUIPanel(GameMenuFrame) end)
end

function AP:NewAddOnProfile(name, overwrite)
	if AddonPanelProfilesDB[name] and (not overwrite) then
		StaticPopupDialogs['ADDONPANEL_OVERWRITEPROFILE'].text = T.string_format(L['There is already a profile named %s. Do you want to overwrite it?'], name)
		StaticPopupDialogs['ADDONPANEL_OVERWRITEPROFILE'].OnAccept = function(self) AP:NewAddOnProfile(name, true) end
		StaticPopup_Show('ADDONPANEL_OVERWRITEPROFILE')
		return
	end

	AddonPanelProfilesDB[name] = {}

	for i = 1, #self.AddOnInfo do
		local AddOn, isEnabled = T.unpack(self.AddOnInfo[i]), KUI:IsAddOnEnabled(i, AP.SelectedCharacter)
		if isEnabled then
			T.table_insert(AddonPanelProfilesDB[name], AddOn)
		end
	end

	self:UpdateProfiles()
end

function AP:InitProfiles()
	local ProfileMenu = T.CreateFrame('Frame', 'APProfileMenu', self.Frame)
	ProfileMenu:SetPoint('TOPLEFT', self.Frame, 'TOPRIGHT', 3, 0)
	ProfileMenu:SetSize(250, 50)
	ProfileMenu:SetTemplate('Transparent')
	ProfileMenu:Hide()
	ProfileMenu:Styling()

	for _, name in T.pairs({'EnableAll', 'DisableAll', 'NewButton'}) do
		local Button = T.CreateFrame('Button', nil, ProfileMenu)
		Button:SetTemplate()
		Button:SetSize(self.db['ButtonWidth'], self.db['ButtonHeight'])
		Button:SetScript('OnEnter', function(self) self:SetBackdropBorderColor(unpack(AP.db['ClassColor'] and AP.ClassColor or AP.db['CheckColor'])) end)
		Button:SetScript('OnLeave', function(self) self:SetTemplate() end)

		Button.Text = Button:CreateFontString(nil, 'OVERLAY')
		Button.Text:SetFont(LSM:Fetch('font', AP.db['Font']), 12, 'OUTLINE')
		Button.Text:SetPoint('CENTER', 0, 0)
		Button.Text:SetJustifyH('CENTER')

		ProfileMenu[name] = Button
	end

	ProfileMenu.EnableAll.Text:SetText(L['Enable All'])
	ProfileMenu.EnableAll:SetPoint('TOPLEFT', ProfileMenu, 'TOPLEFT', 10, -10)
	ProfileMenu.EnableAll:SetPoint('TOPRIGHT', ProfileMenu, 'TOP', -3, -10)
	ProfileMenu.EnableAll:SetScript('OnClick', function(self)
		T.EnableAllAddOns(AP.SelectedCharacter)
		AP:UpdateAddonList()
	end)

	ProfileMenu.DisableAll.Text:SetText(L['Disable All'])
	ProfileMenu.DisableAll:SetPoint('TOPRIGHT', ProfileMenu, 'TOPRIGHT', -10, -10)
	ProfileMenu.DisableAll:SetPoint('TOPLEFT', ProfileMenu, 'TOP', 2, -10)
	ProfileMenu.DisableAll:SetScript('OnClick', function(self)
		T.DisableAllAddOns(AP.SelectedCharacter)
		AP:UpdateAddonList()
	end)

	ProfileMenu.NewButton:SetPoint('TOPLEFT', ProfileMenu.EnableAll, 'BOTTOMLEFT', 0, -5)
	ProfileMenu.NewButton:SetPoint('TOPRIGHT', ProfileMenu.DisableAll, 'BOTTOMRIGHT', 0, -5)
	ProfileMenu.NewButton:SetScript('OnClick', function() StaticPopup_Show('ADDONPANEL_NEWPROFILE') end)
	ProfileMenu.NewButton.Text:SetText(L['New Profile'])

	ProfileMenu.Buttons = {}

	for i = 1, 10 do
		local Pullout = T.CreateFrame('Frame', nil, ProfileMenu)
		Pullout:SetWidth(210)
		Pullout:SetHeight(AP.db.ButtonHeight)
		Pullout:Hide()

		for _, Frame in T.pairs({'Load', 'Delete', 'Update'}) do
			local Button = T.CreateFrame('Button', nil, Pullout)
			Button:SetTemplate()
			Button:SetSize(73, AP.db.ButtonHeight)
			Button:RegisterForClicks('AnyDown')
			Button:SetScript('OnEnter', function(self) self:SetBackdropBorderColor(T.unpack(AP.db['ClassColor'] and AP.ClassColor or AP.db['CheckColor'])) end)
			Button:SetScript('OnLeave', function(self) self:SetTemplate() end)

			Button.Text = Button:CreateFontString(nil, 'OVERLAY')
			Button.Text:SetFont(LSM:Fetch('font', AP.db['Font']), 12, 'OUTLINE')
			Button.Text:SetPoint('CENTER', 0, 0)
			Button.Text:SetJustifyH('CENTER')

			Pullout[Frame] = Button
		end

		Pullout.Load:SetPoint('LEFT', Pullout, 0, 0)
		Pullout.Load.Text:SetText('Load')
		Pullout.Load:SetScript('OnClick', function(self, btn)
			if btn == 'RightButton' then
				local Dialog = StaticPopupDialogs['ADDONPANEL_RENAMEPROFILE']
				Dialog.OnAccept = function(self)
					AddonPanelProfilesDB[Pullout.Name] = nil
					AP:NewAddOnProfile(self.editBox:GetText())
					AP:UpdateProfiles()
				end
				Dialog.EditBoxOnEnterPressed = function(self)
					AddonPanelProfilesDB[Pullout.Name] = nil
					AP:NewAddOnProfile(self:GetText())
					AP:UpdateProfiles()
					self:GetParent():Hide()
				end
				StaticPopup_Show('ADDONPANEL_RENAMEPROFILE')
			else
				if not T.IsShiftKeyDown() then
					T.DisableAllAddOns(AP.SelectedCharacter)
				end
				for _, AddOn in T.pairs(AddonPanelProfilesDB[Pullout.Name]) do
					T.EnableAddOn(AddOn, AP.SelectedCharacter)
				end

				AP:UpdateAddonList()
			end
		end)

		Pullout.Update:SetPoint('LEFT', Pullout.Load, 'RIGHT', 5, 0)
		Pullout.Update.Text:SetText(L['Update'])
		Pullout.Update:SetScript('OnClick', function(self)
			AP:NewAddOnProfile(Pullout.Name, true)
		end)

		Pullout.Delete:SetPoint('LEFT', Pullout.Update, 'RIGHT', 5, 0)
		Pullout.Delete.Text:SetText(L['Delete'])
		Pullout.Delete:SetScript('OnClick', function(self)
			local dialog = StaticPopupDialogs['ADDONPANEL_DELETECONFIRMATION']

			dialog.text = T.string_format(L['Are you sure you want to delete %s?'], Pullout.Name)
			dialog.OnAccept = function(self)
				AddonPanelProfilesDB[Pullout.Name] = nil
				AP:UpdateProfiles()
			end

			StaticPopup_Show('ADDONPANEL_DELETECONFIRMATION')
		end)

		ProfileMenu.Buttons[i] = Pullout
	end

	self.ProfileMenu = ProfileMenu
end

function AP:UpdateProfiles()
	local ProfileMenu = self.ProfileMenu
	local Buttons = self.ProfileMenu.Buttons

	T.table_wipe(self.Profiles)

	for name, _ in T.pairs(AddonPanelProfilesDB) do
		T.table_insert(self.Profiles, name)
	end

	T.table_sort(self.Profiles)

	for i = 1, #Buttons do
		Buttons[i]:Hide()
		Buttons[i].Name = nil
	end

	for i = 1, #self.Profiles do
		if i == 1 then
			Buttons[i]:SetPoint("TOPLEFT", ProfileMenu.NewButton, "BOTTOMLEFT", 0, -5)
		else
			Buttons[i]:SetPoint("TOP", Buttons[i-1], "BOTTOM", 0, -5)
		end

		Buttons[i]:Show()
		Buttons[i].Load.Text:SetText(self.Profiles[i])
		Buttons[i].Name = self.Profiles[i]
	end

	ProfileMenu:SetHeight((#self.Profiles+2)*(AP.db.ButtonHeight+5) + 15)
end

function AP:ToggleProfiles()
	T.ToggleFrame(self.ProfileMenu)
	self:UpdateProfiles()
end

function AP:UpdateAddonList()
	if self.searchQuery then
		local query = T.string_lower(T.strtrim(self.Frame.Search:GetText()))

		if (T.string_len(query) == 0) then
			self.searchQuery = false
		end

		T.table_wipe(self.Frame.Search.AddOns)

		for i = 1, #self.AddOnInfo do
			local name, title = T.unpack(self.AddOnInfo[i])

			if T.string_find(T.string_lower(name), query) or T.string_find(T.string_lower(title), query) then
				T.table_insert(self.Frame.Search.AddOns, i)
			end
		end
	end

	for i = 1, AP.db['NumAddOns'] do
		local addonIndex = (not self.searchQuery and (AP.scrollOffset + i)) or self.Frame.Search.AddOns[AP.scrollOffset + i]
		local button = self.Frame.AddOns.Buttons[i]
		if addonIndex and addonIndex <= #self.AddOnInfo then
			button.name, button.title, button.author, button.notes, button.requireddeps, button.optionaldeps = T.unpack(self.AddOnInfo[addonIndex])
			button.Text:SetText(button.title)
			button:SetChecked(KUI:IsAddOnPartiallyEnabled(addonIndex, AP.SelectedCharacter) or KUI:IsAddOnEnabled(addonIndex, AP.SelectedCharacter))
			button.CheckTexture:SetVertexColor(T.unpack(KUI:IsAddOnPartiallyEnabled(addonIndex, AP.SelectedCharacter) and {.6, .6, .6} or AP.db['ClassColor'] and AP.ClassColor or AP.db['CheckColor']))
			button:Show()
		else
			button:Hide()
		end
	end

	for i = AP.db['NumAddOns'] + 1, #self.Frame.AddOns.Buttons do
		self.Frame.AddOns.Buttons[i]:Hide()
	end

	self.Frame.AddOns:SetHeight(AP.db['NumAddOns'] * (AP.db['ButtonHeight'] + 5) + 15)
	self.Frame:SetSize(AP.db['FrameWidth'], self.Frame.Title:GetHeight() + 5 + self.Frame.Search:GetHeight() + 5  + self.Frame.AddOns:GetHeight() + 10 + self.Frame.Profiles:GetHeight() + 20)
end

function AP:Update()
	for i = 1, 30 do
		local CheckButton = self.Frame.AddOns.Buttons[i]

		CheckButton:SetSize(AP.db['ButtonWidth'], AP.db['ButtonHeight'])
		CheckButton.Text:SetFont(LSM:Fetch('font', AP.db['Font']), AP.db['FontSize'], AP.db['FontFlag'])
		CheckButton.CheckTexture:SetTexture(LSM:Fetch('statusbar', AP.db['CheckTexture']))
		CheckButton.CheckTexture:SetVertexColor(T.unpack(AP.db['ClassColor'] and AP.ClassColor or AP.db['CheckColor']))
		CheckButton:SetCheckedTexture(CheckButton.CheckTexture)
	end

	-- Frame fonts
	self.Frame.AddOns.ScrollBar:GetThumbTexture():SetVertexColor(T.unpack(AP.db['ClassColor'] and AP.ClassColor or AP.db['CheckColor']))
	self.Frame.Title:SetFont(LSM:Fetch('font', AP.db['Font']), 14, AP.db['FontFlag'])
	--self.Frame.Close.Text:SetFont(LSM:Fetch('font', AP.db['Font']), 12, AP.db['FontFlag'])
	self.Frame.Search:SetFont(LSM:Fetch('font', AP.db['Font']), 12, AP.db['FontFlag'])
	self.Frame.Reload.Text:SetFont(LSM:Fetch('font', AP.db['Font']), 12, AP.db['FontFlag'])
	self.Frame.Profiles.Text:SetFont(LSM:Fetch('font', AP.db['Font']), 12, AP.db['FontFlag'])
	self.Frame.CharacterSelect.Text:SetFont(LSM:Fetch('font', AP.db['Font']), 12, AP.db['FontFlag'])
	
	-- Frame fonts color
	if AP.db["FontColor"] == 1 then
		self.Frame.Search:SetTextColor(KUI.r, KUI.g, KUI.b)
		self.Frame.Reload.Text:SetTextColor(KUI.r, KUI.g, KUI.b)
		self.Frame.CharacterSelect.Text:SetTextColor(KUI.r, KUI.g, KUI.b)
		self.Frame.Profiles.Text:SetTextColor(KUI.r, KUI.g, KUI.b)
		self.ProfileMenu.EnableAll.Text:SetTextColor(KUI.r, KUI.g, KUI.b)
		self.ProfileMenu.DisableAll.Text:SetTextColor(KUI.r, KUI.g, KUI.b)
		self.ProfileMenu.NewButton.Text:SetTextColor(KUI.r, KUI.g, KUI.b)
		for i = 1, 10 do
			self.ProfileMenu.Buttons[i].Load.Text:SetTextColor(KUI.r, KUI.g, KUI.b)
			self.ProfileMenu.Buttons[i].Update.Text:SetTextColor(KUI.r, KUI.g, KUI.b)
			self.ProfileMenu.Buttons[i].Delete.Text:SetTextColor(KUI.r, KUI.g, KUI.b)
		end
	elseif AP.db["FontColor"] == 2 then
		self.Frame.Search:SetTextColor(KUI:unpackColor(AP.db["FontCustomColor"]))
		self.Frame.Reload.Text:SetTextColor(KUI:unpackColor(AP.db["FontCustomColor"]))
		self.Frame.CharacterSelect.Text:SetTextColor(KUI:unpackColor(AP.db["FontCustomColor"]))
		self.Frame.Profiles.Text:SetTextColor(KUI:unpackColor(AP.db["FontCustomColor"]))
		self.ProfileMenu.EnableAll.Text:SetTextColor(KUI:unpackColor(AP.db["FontCustomColor"]))
		self.ProfileMenu.DisableAll.Text:SetTextColor(KUI:unpackColor(AP.db["FontCustomColor"]))
		self.ProfileMenu.NewButton.Text:SetTextColor(KUI:unpackColor(AP.db["FontCustomColor"]))
		for i = 1, 10 do
			self.ProfileMenu.Buttons[i].Load.Text:SetTextColor(KUI:unpackColor(AP.db["FontCustomColor"]))
			self.ProfileMenu.Buttons[i].Update.Text:SetTextColor(KUI:unpackColor(AP.db["FontCustomColor"]))
			self.ProfileMenu.Buttons[i].Delete.Text:SetTextColor(KUI:unpackColor(AP.db["FontCustomColor"]))
		end
	else
		self.Frame.Search:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
		self.Frame.Reload.Text:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
		self.Frame.CharacterSelect.Text:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
		self.Frame.Profiles.Text:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
		self.ProfileMenu.EnableAll.Text:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
		self.ProfileMenu.DisableAll.Text:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
		self.ProfileMenu.NewButton.Text:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
		for i = 1, 10 do
			self.ProfileMenu.Buttons[i].Load.Text:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
			self.ProfileMenu.Buttons[i].Update.Text:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
			self.ProfileMenu.Buttons[i].Delete.Text:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
		end
	end
	
	AP:UpdateAddonList()
end

function AP:Initialize()
	if not E.db.KlixUI.addonpanel.Enable or T.IsAddOnLoaded("ProjectAzilroka") then return end
	
	AP.db = E.db.KlixUI.addonpanel

	KUI:RegisterDB(self, "addonpanel")
	
	AP.AddOnInfo = {}
	AP.Profiles = {}

	for i = 1, T.GetNumAddOns() do
		local name, title, notes = T.GetAddOnInfo(i)
		local requireddeps, optionaldeps = T.GetAddOnDependencies(i), T.GetAddOnOptionalDependencies(i)
		local author = T.GetAddOnMetadata(i, "Author")
		AP.AddOnInfo[i] = { name, title, author, notes, requireddeps, optionaldeps }
	end

	AP.SelectedCharacter = T.UnitName('player')

	AP.Menu = {
		{ text = 'All', checked = function() return AP.SelectedCharacter == true end, func = function() AP.SelectedCharacter = true AP:UpdateAddonList() end}
	}

	AddonPanelServerDB[T.GetRealmName()] = AddonPanelServerDB[T.GetRealmName()] or {}
	AddonPanelServerDB[T.GetRealmName()][T.UnitName('player')] = true

	local index = 2
	for Character in KUI:PairsByKeys(AddonPanelServerDB[T.GetRealmName()]) do
		AP.Menu[index] = { text = Character, checked = function() return AP.SelectedCharacter == Character end, func = function() AP.SelectedCharacter = Character AP:UpdateAddonList() end }
		index = index + 1
	end
	
	AP.MenuOffset = index

	AP.scrollOffset = 0

	AP:BuildFrame()
	AP:InitProfiles()
end

KUI:RegisterModule(AP:GetName())