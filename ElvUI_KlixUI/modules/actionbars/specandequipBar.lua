local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local SEB = KUI:NewModule("SpecEquipBar", "AceEvent-3.0")
local LCG = LibStub('LibCustomGlow-1.0')

local r, g, b = T.unpack(E.media.rgbvaluecolor)

function SEB:CreateSpecBar()
	if SEB.db.enable ~= true then return end

	local Spacing, Mult = 4, 1
	local Size = 24

	local specBar = T.CreateFrame("Frame", "SpecializationBar", E.UIParent)
	specBar:SetFrameStrata("BACKGROUND")
	specBar:SetFrameLevel(0)
	specBar:SetSize(40, 40)
	specBar:SetTemplate("Transparent")
	specBar:SetPoint("BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 43, 194)
	specBar:Styling()
	specBar:Hide()
	E.FrameLocks[specBar] = true

	specBar.Button = {}
	E:CreateMover(specBar, "SpecializationBarMover", L["Specialization Bar"], nil, nil, nil, 'ALL,ACTIONBARS,KLIXUI', nil, "KlixUI,modules,actionbars,SEBar")

	specBar:SetScript('OnEnter', function(self) T.UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1) end)
	specBar:SetScript('OnLeave', function(self)
		if SEB.db.mouseover then
			T.UIFrameFadeOut(self, 0.2, self:GetAlpha(), SEB.db.malpha)
		end
	end)

	local Specs = T.GetNumSpecializations()

	for i = 1, Specs do
		local SpecID, SpecName, Description, Icon = T.GetSpecializationInfo(i)
		local Button = T.CreateFrame("Button", nil, specBar)
		Button:SetSize(Size, Size)
		Button:SetID(i)
		Button:SetTemplate()
		Button:StyleButton()
		Button:CreateIconShadow()
		Button:SetNormalTexture(Icon)
		Button:GetNormalTexture():SetTexCoord(T.unpack(E.TexCoords))
		Button:GetNormalTexture():SetInside()
		Button:SetPushedTexture(Icon)
		Button:GetPushedTexture():SetInside()
		Button:RegisterForClicks('AnyDown')
		Button:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:AddLine(SpecName)
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(Description, true)
			GameTooltip:Show()
		end)
		Button:SetScript("OnLeave", GameTooltip_Hide)
		Button:SetScript("OnClick", function(self, button)
			if button == "LeftButton" then
				if self:GetID() ~= T.GetSpecialization() then
					T.SetSpecialization(self:GetID())
				end
			end
		end)
		Button:SetScript("OnEvent", function(self)
			local Spec = T.GetSpecialization()
			if Spec == self:GetID() then
				if SEB.db.borderGlow then
					LCG.PixelGlow_Start(Button, {r, g, b, 1}, nil, -0.25, nil, 1)
				else
					self:SetBackdropBorderColor(0, 0.44, 0.87)
				end
			else
				if SEB.db.borderGlow then
					LCG.PixelGlow_Stop(Button)
				else
					self:SetTemplate()
				end
			end
		end)

		Button:HookScript('OnEnter', function(self)
			if specBar:IsShown() then
				T.UIFrameFadeIn(specBar, 0.2, specBar:GetAlpha(), 1)
			end
		end)
		Button:HookScript('OnLeave', function(self)
			if specBar:IsShown() and SEB.db.mouseover then
				T.UIFrameFadeOut(specBar, 0.2, specBar:GetAlpha(), SEB.db.malpha)
			end
		end)

		Button:SetPoint("LEFT", i == 1 and specBar or specBar.Button[i - 1], i == 1 and "LEFT" or "RIGHT", Spacing, 0)

		specBar.Button[i] = Button
	end

	local BarWidth = (Spacing + ((Size * (Specs * Mult)) + ((Spacing * (Specs - 1)) * Mult) + (Spacing * Mult)))
	local BarHeight = (Spacing + (Size * Mult) + (Spacing * Mult))

	specBar:SetSize(BarWidth, BarHeight)

	for _, Button in T.pairs(specBar.Button) do
		Button:HookScript("OnClick", function(self, button)
			if button == "RightButton" then
				local SpecID = T.GetSpecializationInfo(self:GetID())
				if (T.GetLootSpecialization() == SpecID) then
					SpecID = 0
				end
				T.SetLootSpecialization(SpecID)
			end
		end)
		Button:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
		Button:RegisterEvent("PLAYER_ENTERING_WORLD")
		Button:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
		Button:HookScript("OnEvent", function(self)
			if (T.GetLootSpecialization() == T.GetSpecializationInfo(self:GetID())) then
				if SEB.db.borderGlow then
					LCG.AutoCastGlow_Start(Button, {1, 0.44, 0.4, 1}, 4, -0.25)
				else
					self:SetBackdropBorderColor(1, 0.44, 0.4)
				end
			else
				LCG.AutoCastGlow_Stop(Button)
			end
		end)
	end
	
	if SEB.db.mouseover then
		T.UIFrameFadeOut(specBar, 0.2, specBar:GetAlpha(), SEB.db.malpha)
	else
		T.UIFrameFadeIn(specBar, 0.2, specBar:GetAlpha(), 1)
	end
end

function SEB:CreateEquipBar()
	if SEB.db.enable ~= true then return end

	local GearTexture = "Interface\\WorldMap\\GEAR_64GREY"
	local EquipmentSets = T.CreateFrame("Frame", "EquipmentSets", E.UIParent)
	EquipmentSets:SetFrameStrata("BACKGROUND")
	EquipmentSets:SetFrameLevel(0)
	EquipmentSets:SetSize(32, 32)
	EquipmentSets:SetTemplate("Transparent")
	EquipmentSets:SetPoint("RIGHT", _G["SpecializationBar"], "LEFT", -1, 0)
	EquipmentSets:Styling()
	EquipmentSets:Hide()
	E.FrameLocks[EquipmentSets] = true

	E:CreateMover(EquipmentSets, "EquipmentSetsBarMover", L["Equipment Sets Bar"], nil, nil, nil, 'ALL,ACTIONBARS,KLIXUI', nil, "KlixUI,modules,actionbars")
	
	EquipmentSets:SetScript('OnEnter', function(self) T.UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1) end)
	EquipmentSets:SetScript('OnLeave', function(self)
		if SEB.db.mouseover then
			T.UIFrameFadeOut(self, 0.2, self:GetAlpha(), SEB.db.malpha)
		end
	end)

	EquipmentSets.Button = T.CreateFrame("Button", nil, EquipmentSets)
	EquipmentSets.Button:SetFrameStrata("BACKGROUND")
	EquipmentSets.Button:SetFrameLevel(1)
	EquipmentSets.Button:SetTemplate()
	EquipmentSets.Button:CreateIconShadow()
	EquipmentSets.Button:SetPoint("CENTER")
	EquipmentSets.Button:SetSize(24, 24)
	EquipmentSets.Button:SetNormalTexture("Interface\\PaperDollInfoFrame\\PaperDollSidebarTabs")
	EquipmentSets.Button:GetNormalTexture():SetTexCoord(0.01562500, 0.53125000, 0.46875000, 0.60546875)
	EquipmentSets.Button:GetNormalTexture():SetInside()
	EquipmentSets.Button:SetPushedTexture("")
	EquipmentSets.Button:SetHighlightTexture("")
	EquipmentSets.Button:HookScript("OnEnter", function(self) self:SetBackdropBorderColor(0, 0.44, .87) end)
	EquipmentSets.Button:HookScript("OnLeave", function(self) self:SetTemplate() end)

	EquipmentSets.Button.Icon = EquipmentSets.Button:CreateTexture(nil, "OVERLAY")
	EquipmentSets.Button.Icon:SetTexCoord(.1, .9, .1, .9)
	EquipmentSets.Button.Icon:SetInside()

	EquipmentSets.Flyout = T.CreateFrame("Button", nil, EquipmentSets)
	EquipmentSets.Flyout:SetFrameStrata("BACKGROUND")
	EquipmentSets.Flyout:SetFrameLevel(2)
	EquipmentSets.Flyout:SetPoint("TOP", EquipmentSets, "TOP", 0, 0)
	EquipmentSets.Flyout:SetSize(23, 11)
	EquipmentSets.Flyout.Arrow = EquipmentSets.Flyout:CreateTexture(nil, "OVERLAY", "ActionBarFlyoutButton-ArrowUp")
	EquipmentSets.Flyout.Arrow:SetAllPoints()
	EquipmentSets.Flyout:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:ClearLines()
		GameTooltip:AddLine(PAPERDOLL_EQUIPMENTMANAGER)
		GameTooltip:Show()
	end)
	
	EquipmentSets.Flyout:SetScript("OnLeave", GameTooltip_Hide)
	EquipmentSets.Flyout:SetScript("OnClick", function()
		for i = 1, 10 do
			if EquipmentSets.Button[i]:IsShown() then
				EquipmentSets.Button[i]:Hide()
			else
				if EquipmentSets.Button[i]:GetNormalTexture():GetTexture() ~= GearTexture then
					EquipmentSets.Button[i]:Show()
				end
			end
		end
	end)
	
	EquipmentSets.Flyout:HookScript("OnEnter", function(self)
		if EquipmentSets:IsShown() then
			T.UIFrameFadeIn(EquipmentSets, 0.2, EquipmentSets:GetAlpha(), 1)
		end
	end)
	EquipmentSets.Flyout:HookScript("OnLeave", function(self)
		if EquipmentSets:IsShown() and SEB.db.mouseover then
			T.UIFrameFadeOut(EquipmentSets, 0.2, EquipmentSets:GetAlpha(), SEB.db.malpha)
		end
	end)
	
	for i = 1, 10 do
		local Button = T.CreateFrame("Button", nil, EquipmentSets.Flyout)
		Button:Hide()
		Button:SetSize(24, 24)
		Button:SetTemplate()
		Button:CreateIconShadow()
		Button:SetFrameStrata("TOOLTIP")
		Button:SetNormalTexture(GearTexture)
		Button:GetNormalTexture():SetTexCoord(.1, .9, .1, .9)
		Button:GetNormalTexture():SetInside()
		Button:SetPoint("BOTTOM", i == 1 and EquipmentSets.Flyout or EquipmentSets.Button[i - 1], "TOP", 0, 3)
		Button:SetScript("OnEnter", function(self)
			local Name = T.C_EquipmentSet_GetEquipmentSetInfo(self:GetID())
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			GameTooltip:SetEquipmentSet(Name)
		end)
		Button:SetScript("OnClick", function(self)
			local _, Icon, Index, IsEquipped = T.C_EquipmentSet_GetEquipmentSetInfo(self:GetID())
			EquipmentSets.Button:SetID(Index)
			EquipmentSets.Button.Icon:SetTexture(Icon)
			if not IsEquipped then T.C_EquipmentSet_UseEquipmentSet(self:GetID()) end
			EquipmentSets.Flyout:Click()
		end)
		Button:SetScript("OnLeave", GameTooltip_Hide)
		Button:HookScript("OnEnter", function(self)
			if EquipmentSets:IsShown() then
				T.UIFrameFadeIn(EquipmentSets, 0.2, EquipmentSets:GetAlpha(), 1)
			end
		end)
		Button:HookScript("OnLeave", function(self)
			if EquipmentSets:IsShown() and SEB.db.mouseover then
				T.UIFrameFadeOut(EquipmentSets, 0.2, EquipmentSets:GetAlpha(), SEB.db.malpha)
			end
		end)

		EquipmentSets.Button[i] = Button
	end

	EquipmentSets.Button:SetScript("OnClick", function(self)
		if T.InCombatLockdown() then
			return T.UIErrorsFrame:AddMessage(ERR_NOT_IN_COMBAT, 1.0, 0.1, 0.1, 1.0);
		end
		if not self:GetID() then
			T.ShowUIPanel(_G["CharacterFrame"])
			PaperDollFrame_SetSidebar(_G["CharacterFrame"], 3)
			return
		end

		if not T.select(4, T.C_EquipmentSet_GetEquipmentSetInfo(self:GetID())) then
			T.C_EquipmentSet_UseEquipmentSet(self:GetID())
		end
	end)

	EquipmentSets.Button:SetScript("OnEnter", function(self)
		local Name = T.C_EquipmentSet_GetEquipmentSetInfo(self:GetID())
		if not Name then return end
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetEquipmentSet(Name)
	end)
	EquipmentSets.Button:SetScript("OnLeave", GameTooltip_Hide)
	EquipmentSets.Button:RegisterEvent("PLAYER_ENTERING_WORLD")
	EquipmentSets.Button:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	EquipmentSets.Button:RegisterEvent("EQUIPMENT_SETS_CHANGED")
	EquipmentSets.Button:RegisterUnitEvent('UNIT_INVENTORY_CHANGED', 'player')
	EquipmentSets.Button:SetScript("OnEvent", function(self)
		local Index, SetEquipped = 1
		for i = 1, 10 do
			local _, Icon, SpecIndex, IsEquipped = T.C_EquipmentSet_GetEquipmentSetInfo(i - 1)
			self[i]:SetNormalTexture(GearTexture)
			self[i]:SetID(i)
			if SpecIndex then
				self[Index]:SetID(SpecIndex)
				self[Index]:SetNormalTexture(Icon)
				if IsEquipped then
					SetEquipped = IsEquipped
					self:SetID(SpecIndex)
					self.Icon:SetTexture(Icon)
				end
				Index = Index + 1
			end
		end
		if not SetEquipped then
			self.SaveButton.Icon:SetTexture("Interface\\RaidFrame\\ReadyCheck-NotReady")
			self.SaveButton:Enable()
			self.SaveButton:EnableMouse(true)
		else
			self.SaveButton.Icon:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
			self.SaveButton:Disable()
			self.SaveButton:EnableMouse(false)
		end
	end)

	EquipmentSets.Button:HookScript("OnEnter", function(self)
		self:SetBackdropBorderColor(0, 0.44, .87)
		if EquipmentSets:IsShown() then
			T.UIFrameFadeIn(EquipmentSets, 0.2, EquipmentSets:GetAlpha(), 1)
		end
	end)
	EquipmentSets.Button:HookScript("OnLeave", function(self)
		self:SetTemplate()
		if EquipmentSets:IsShown() and SEB.db.mouseover then
			T.UIFrameFadeOut(EquipmentSets, 0.2, EquipmentSets:GetAlpha(), SEB.db.malpha)
		end
	end)

	EquipmentSets.Button.SaveButton = T.CreateFrame("Button", nil, EquipmentSets.Button)
	EquipmentSets.Button.SaveButton:SetFrameLevel(2)
	EquipmentSets.Button.SaveButton:SetSize(14, 14)
	EquipmentSets.Button.SaveButton:SetPoint("BOTTOMLEFT", EquipmentSets.Button, "BOTTOMLEFT", 0, 0)
	EquipmentSets.Button.SaveButton.Icon = EquipmentSets.Button.SaveButton:CreateTexture(nil, "ARTWORK")
	EquipmentSets.Button.SaveButton.Icon:SetAllPoints()
	EquipmentSets.Button.SaveButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(SAVE_CHANGES)
	end)
	EquipmentSets.Button.SaveButton:SetScript("OnLeave", GameTooltip_Hide)
	EquipmentSets.Button.SaveButton:SetScript("OnClick", function(self, button)
		T.C_EquipmentSet_SaveEquipmentSet(EquipmentSets.Button:GetID())
	end)
	
	if SEB.db.mouseover then
		T.UIFrameFadeOut(EquipmentSets, 0.2, EquipmentSets:GetAlpha(), SEB.db.malpha)
	else
		T.UIFrameFadeIn(EquipmentSets, 0.2, EquipmentSets:GetAlpha(), 1)
	end
end

function SEB:PLAYER_REGEN_DISABLED()
	if SEB.db.hideInCombat then
	SpecializationBar:Hide()
	EquipmentSets:Hide()
	end
end

function SEB:PLAYER_REGEN_ENABLED()
	if SEB.db.enable then
	SpecializationBar:Show()
	EquipmentSets:Show()
	end
end

function SEB:UNIT_AURA(event, unit)
	if unit ~= "player" then return end
	if SEB.db.enable and SEB.db.hideInOrderHall then
		local inOrderHall = T.C_Garrison_IsPlayerInGarrison(LE_GARRISON_TYPE_7_0)
		SpecializationBar:SetShown(not inOrderHall)
		EquipmentSets:SetShown(not inOrderHall)
	end
end

function SEB:Initialize()
	SEB.db = E.db.KlixUI.actionbars.SEBar
	if SEB.db.enable ~= true then return end

	SEB:CreateSpecBar()
	SEB:CreateEquipBar()
	
	SEB:RegisterEvent("PLAYER_REGEN_DISABLED")
	SEB:RegisterEvent("PLAYER_REGEN_ENABLED")
	SEB:RegisterEvent("UNIT_AURA")
end

local function InitializeCallback()
	SEB:Initialize()
end

KUI:RegisterModule(SEB:GetName(), InitializeCallback)
