local KUI, T, E, L, V, P, G = unpack(select(2, ...))

local MoneyFrame_Update = MoneyFrame_Update

-- Bug Report
E.PopupDialogs["BUG_REPORT"] = {
	text = KUI:cOption(L["Bug Report"]),
	button1 = OKAY,
	hasEditBox = 1,
	OnShow = function(self, data)
		self.editBox:SetAutoFocus(false)
		self.editBox.width = self.editBox:GetWidth()
		self.editBox:Width(280)
		self.editBox:AddHistoryLine("text")
		self.editBox.temptxt = data
		self.editBox:SetText(data)
		self.editBox:HighlightText()
		self.editBox:SetJustifyH("CENTER")
	end,
	OnHide = function(self)
		self.editBox:Width(self.editBox.width or 50)
		self.editBox.width = nil
		self.temptxt = nil
	end,
	EditBoxOnEnterPressed = function(self)
		self:GetParent():Hide();
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide();
	end,
	EditBoxOnTextChanged = function(self)
		if(self:GetText() ~= self.temptxt) then
			self:SetText(self.temptxt)
		end
		self:HighlightText()
		self:ClearFocus()
	end,
	OnAccept = E.noop,
	timeout = 0,
	whileDead = 1,
	preferredIndex = 3,
	hideOnEscape = 1,
}

-- Discord
E.PopupDialogs["DISCORD"] = {
	text = KUI:cOption(L["Join Discord"]),
	button1 = OKAY,
	hasEditBox = 1,
	OnShow = function(self, data)
		self.editBox:SetAutoFocus(false)
		self.editBox.width = self.editBox:GetWidth()
		self.editBox:Width(280)
		self.editBox:AddHistoryLine("text")
		self.editBox.temptxt = data
		self.editBox:SetText(data)
		self.editBox:HighlightText()
		self.editBox:SetJustifyH("CENTER")
	end,
	OnHide = function(self)
		self.editBox:Width(self.editBox.width or 50)
		self.editBox.width = nil
		self.temptxt = nil
	end,
	EditBoxOnEnterPressed = function(self)
		self:GetParent():Hide();
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide();
	end,
	EditBoxOnTextChanged = function(self)
		if(self:GetText() ~= self.temptxt) then
			self:SetText(self.temptxt)
		end
		self:HighlightText()
		self:ClearFocus()
	end,
	OnAccept = E.noop,
	timeout = 0,
	whileDead = 1,
	preferredIndex = 3,
	hideOnEscape = 1,
}

-- ElvUI Versions check
E.PopupDialogs["VERSION_MISMATCH"] = {
	text = KUI:MismatchText(),
	button1 = CLOSE,
	timeout = 0,
	whileDead = 1,
	preferredIndex = 3,
}

-- Gold clear popup
E.PopupDialogs['KUI_CONFIRM_DELETE_CURRENCY_CHARACTER'] = {
	button1 = YES,
	button2 = NO,
	OnCancel = E.noop;
}

-- KlixUI Credits
E.PopupDialogs["KLIXUI_CREDITS"] = {
	text = KUI.Title,
	button1 = OKAY,
	hasEditBox = 1,
	OnShow = function(self, data)
		self.editBox:SetAutoFocus(false)
		self.editBox.width = self.editBox:GetWidth()
		self.editBox:Width(280)
		self.editBox:AddHistoryLine("text")
		self.editBox.temptxt = data
		self.editBox:SetText(data)
		self.editBox:HighlightText()
		self.editBox:SetJustifyH("CENTER")
	end,
	OnHide = function(self)
		self.editBox:Width(self.editBox.width or 50)
		self.editBox.width = nil
		self.temptxt = nil
	end,
	EditBoxOnEnterPressed = function(self)
		self:GetParent():Hide();
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide();
	end,
	EditBoxOnTextChanged = function(self)
		if(self:GetText() ~= self.temptxt) then
			self:SetText(self.temptxt)
		end
		self:HighlightText()
		self:ClearFocus()
	end,
	OnAccept = E.noop,
	timeout = 0,
	whileDead = 1,
	preferredIndex = 3,
	hideOnEscape = 1,
}

--Incompatibility messages
--[[E.PopupDialogs["KUI_INCOMPATIBLE_ADDON"] = {
	text = T.string_gsub(L["INCOMPATIBLE_ADDON"], "ElvUI", "KlixUI"),
	OnAccept = function(self) T.DisableAddOn(E.PopupDialogs["KUI_INCOMPATIBLE_ADDON"].addon); T.ReloadUI(); end,
	OnCancel = function(self) E.PopupDialogs["KUI_INCOMPATIBLE_ADDON"].optiontable[E.PopupDialogs["KUI_INCOMPATIBLE_ADDON"].value] = false; T.ReloadUI(); end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}]]

E.PopupDialogs["BUI_KUI_INCOMPATIBLE"] = {
	text = L["You got |cff00c0faBenikUI|r and |cfff960d9KlixUI|r both enabled at the same time. Please select an addon to disable."],
	OnAccept = function() T.DisableAddOn("ElvUI_BenikUI"); T.ReloadUI() end,
	OnCancel = function() T.DisableAddOn("ElvUI_KlixUI"); T.ReloadUI() end,
	button1 = "|cff00c0faBenikUI|r",
	button2 = KUI.Title,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

E.PopupDialogs["LOCPLUS_KUI_INCOMPATIBLE"] = {
	text = L["You got ElvUI Location Plus and |cfff960d9KlixUI|r both enabled at the same time. Please select an addon to disable."],
	OnAccept = function() T.DisableAddOn("ElvUI_LocPlus"); T.ReloadUI() end,
	OnCancel = function() T.DisableAddOn("ElvUI_KlixUI"); T.ReloadUI() end,
	button1 = "Location Plus",
	button2 = KUI.Title,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

E.PopupDialogs["LOCLITE_KUI_INCOMPATIBLE"] = {
	text = L["You got ElvUI Location Lite and |cfff960d9KlixUI|r both enabled at the same time. Please select an addon to disable."],
	OnAccept = function() T.DisableAddOn("ElvUI_LocLite"); T.ReloadUI() end,
	OnCancel = function() T.DisableAddOn("ElvUI_KlixUI"); T.ReloadUI() end,
	button1 = "Location Lite",
	button2 = KUI.Title,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

E.PopupDialogs["MUI_KUI_INCOMPATIBLE"] = {
	text = L["You got |cffff7d0aMerathilisUI|r and |cfff960d9KlixUI|r both enabled at the same time. Please select an addon to disable."],
	OnAccept = function() T.DisableAddOn("ElvUI_MerathilisUI"); T.ReloadUI() end,
	OnCancel = function() T.DisableAddOn("ElvUI_KlixUI"); T.ReloadUI() end,
	button1 = "|cffff7d0aMerathilisUI|r",
	button2 = KUI.Title,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

-- Profile Creation
function KUI:NewProfile(new)
	if (new) then
		E.PopupDialogs["KLIXUI_CREATE_PROFILE_NEW"] = {
			text = KUI:cOption(L["Name for the new profile"]),
			button1 = OKAY,
			button2 = CANCEL,
			hasEditBox = 1,
			whileDead = 1,
			hideOnEscape = 1,
			timeout = 0,
			OnShow = function(self, data)
				self.editBox:SetAutoFocus(false)
				self.editBox.width = self.editBox:GetWidth()
				self.editBox:Width(280)
				self.editBox:AddHistoryLine("text")
				self.editBox.temptxt = data
				self.editBox:SetText("KlixUI")
				self.editBox:HighlightText()
				self.editBox:SetJustifyH("CENTER")
			end,
			OnHide = function(self)
				self.editBox:Width(self.editBox.width or 50)
				self.editBox.width = nil
				self.temptxt = nil
			end,
			OnAccept = function(self, data, data2)
				local text = self.editBox:GetText()
				ElvUI[1].data:SetProfile(text)
				PluginInstallStepComplete.message = KUI.Title.."Profile Created"
				PluginInstallStepComplete:Show()
			end
			}
		E:StaticPopup_Show("KLIXUI_CREATE_PROFILE_NEW")
	else
		E.PopupDialogs["KLIXUI_PROFILE_OVERRIDE"] = {
			text = KUI:cOption(L["Are you sure you want to override the current profile?"]),
			button1 = YES,
			button2 = NO,
			OnAccept = function()
				PluginInstallStepComplete.message = KUI.Title..L["Profile Set"]
				PluginInstallStepComplete:Show()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
		}
		E:StaticPopup_Show("KLIXUI_PROFILE_OVERRIDE")
	end
end

-- Item Select
E.PopupDialogs["DELETE_SELECTED"] = {
	text = format("|cffff0000%s|r", L["Delete selected items?"]),
	button1 = YES,
	button2 = NO,
	OnAccept = function() KUI:GetModule('ItemSelect'):ProcessSelected(true); end,
	OnCancel = function() KUI:GetModule('ItemSelect'):Reset(); end,
	OnShow = function(self)
		MoneyFrame_Update(self.moneyFrame, E.PopupDialogs["DELETE_SELECTED"].Money);
	end,
	timeout = 4,
	whileDead = 1,
	hideOnEscape = false,
	hasMoneyFrame = 1
}