local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

TransmogSlots = {
  "BackSlot",          -- Back (cloak) slot
  "ChestSlot",         -- Chest slot
  "FeetSlot",          -- Feet (boots) slot
  "HandsSlot",         -- Hand (gloves) slot
  "HeadSlot",          -- Head (helmet) slot
  "LegsSlot",          -- Legs (pants) slot
  "MainHandSlot",      -- Main hand weapon slot
  "SecondaryHandSlot", -- Off-hand (weapon, shield, or held item) slot
  "ShirtSlot",         -- Shirt slot
  "ShoulderSlot",      -- Shoulder slot
  "TabardSlot",        -- Tabard slot
  "WaistSlot",         -- Waist (belt) slot
  "WristSlot"          -- Wrist (bracers) slot
}

local r, g, b = T.unpack(E.media.rgbvaluecolor)

local function styleCollections()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.collections ~= true or E.private.KlixUI.skins.blizzard.collections ~= true then return end

	local CollectionsJournal = _G.CollectionsJournal
	CollectionsJournal:Styling()

	CollectionsJournalTab2:SetPoint("LEFT", CollectionsJournalTab1, "RIGHT", -15, 0)
	CollectionsJournalTab3:SetPoint("LEFT", CollectionsJournalTab2, "RIGHT", -15, 0)
	CollectionsJournalTab4:SetPoint("LEFT", CollectionsJournalTab3, "RIGHT", -15, 0)
	CollectionsJournalTab5:SetPoint("LEFT", CollectionsJournalTab4, "RIGHT", -15, 0)

	-- [[ Mounts and pets ]]
	local PetJournal = _G.PetJournal
	local MountJournal = _G.MountJournal

	for i = 1, 9 do
		T.select(i, MountJournal.MountCount:GetRegions()):Hide()
		T.select(i, PetJournal.PetCount:GetRegions()):Hide()
	end

	MountJournal.LeftInset:Hide()
	MountJournal.RightInset:Hide()
	PetJournal.LeftInset:Hide()
	PetJournal.RightInset:Hide()
	PetJournal.PetCardInset:Hide()
	PetJournal.loadoutBorder:Hide()
	MountJournal.MountDisplay.YesMountsTex:SetAlpha(0)
	MountJournal.MountDisplay.NoMountsTex:SetAlpha(0)
	MountJournal.MountDisplay.ShadowOverlay:Hide()
	PetJournalTutorialButton.Ring:Hide()

	KS:CreateBD(MountJournal.MountCount, .25)
	KS:CreateBD(PetJournal.PetCount, .25)
	KS:CreateBD(MountJournal.MountDisplay.ModelScene, .25)

	-- Mount list
	for _, bu in T.pairs(MountJournal.ListScrollFrame.buttons) do
		KS:CreateGradient(bu.backdrop)

		bu.DragButton.ActiveTexture:SetAlpha(0)

		bu.pulseName = bu:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
		bu.pulseName:SetJustifyH('LEFT')
		bu.pulseName:SetSize(147, 25)
		bu.pulseName:SetAllPoints(bu.name)
		bu.pulseName:Hide()

		bu.pulseName.anim = bu.pulseName:CreateAnimationGroup()
		bu.pulseName.anim:SetToFinalAlpha(true)

		bu.pulseName.anim.alphaout = bu.pulseName.anim:CreateAnimation("Alpha")
		bu.pulseName.anim.alphaout:SetOrder(1)
		bu.pulseName.anim.alphaout:SetFromAlpha(1)
		bu.pulseName.anim.alphaout:SetToAlpha(0)
		bu.pulseName.anim.alphaout:SetDuration(1)

		bu.pulseName.anim.alphain = bu.pulseName.anim:CreateAnimation("Alpha")
		bu.pulseName.anim.alphain:SetOrder(2)
		bu.pulseName.anim.alphain:SetFromAlpha(0)
		bu.pulseName.anim.alphain:SetToAlpha(1)
		bu.pulseName.anim.alphain:SetDuration(1)

		hooksecurefunc(bu.name, 'SetText', function(self, text)
			bu.pulseName:SetText(text)
			bu.pulseName:SetTextColor(T.unpack(E.media.rgbvaluecolor))
		end)

		bu:HookScript("OnUpdate", function(self)
			if self.active then
				bu.pulseName:Show()
				bu.pulseName.anim:Play()
			elseif bu.pulseName.anim:IsPlaying() then
				bu.pulseName:Hide()
				bu.pulseName.anim:Stop()
			end
		end)
	end

	-- Pet list
	for _, bu in T.pairs(PetJournal.listScroll.buttons) do
		KS:CreateGradient(bu.backdrop)
	end

	PetJournalHealPetButtonBorder:Hide()
	PetJournalHealPetButtonIconTexture:SetTexCoord(T.unpack(E.TexCoords))
	PetJournal.HealPetButton:SetPushedTexture("")
	PetJournal.HealPetButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)

	do
		local ic = MountJournal.MountDisplay.InfoButton.Icon
		ic:SetTexCoord(T.unpack(E.TexCoords))
		KS:CreateBG(ic)
	end

	PetJournalLoadoutBorderSlotHeaderText:SetParent(PetJournal)
	PetJournalLoadoutBorderSlotHeaderText:SetPoint("CENTER", PetJournalLoadoutBorderTop, "TOP", 0, 4)

	PetJournalSummonRandomFavoritePetButtonBorder:Hide()
	PetJournalSummonRandomFavoritePetButtonIconTexture:SetTexCoord(T.unpack(E.TexCoords))
	PetJournalSummonRandomFavoritePetButton:SetPushedTexture("")
	PetJournalSummonRandomFavoritePetButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)

	-- Favourite mount button
	MountJournalSummonRandomFavoriteButtonBorder:Hide()
	MountJournalSummonRandomFavoriteButtonIconTexture:SetTexCoord(T.unpack(E.TexCoords))
	MountJournalSummonRandomFavoriteButton:SetPushedTexture("")
	MountJournalSummonRandomFavoriteButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)

	-- Pet card
	local card = _G.PetJournalPetCard

	PetJournalPetCardBG:Hide()
	card.PetInfo.levelBG:SetAlpha(0)
	card.PetInfo.qualityBorder:SetAlpha(0)
	card.AbilitiesBG1:SetAlpha(0)
	card.AbilitiesBG2:SetAlpha(0)
	card.AbilitiesBG3:SetAlpha(0)

	card.PetInfo.level:SetFontObject(GameFontNormal)
	card.PetInfo.level:SetTextColor(1, 1, 1)

	card.PetInfo.icon:SetTexCoord(T.unpack(E.TexCoords))
	card.PetInfo.icon.bg = KS:CreateBG(card.PetInfo.icon)

	KS:CreateBD(card, .25)

	for i = 2, 12 do
		T.select(i, card.xpBar:GetRegions()):Hide()
	end

	KS:CreateBDFrame(card.xpBar, .25)

	for i = 1, 6 do
		local bu = card["spell"..i]
		KS:ReskinIcon(bu.icon)
	end

	hooksecurefunc("PetJournal_UpdatePetCard", function(self)
		local border = self.PetInfo.qualityBorder
		local r, g, b

		if border:IsShown() then
			r, g, b = self.PetInfo.qualityBorder:GetVertexColor()
		else
			r, g, b = 0, 0, 0
		end

		self.PetInfo.icon.bg:SetVertexColor(r, g, b)
	end)

	-- Pet loadout

	for i = 1, 3 do
		local bu = _G.PetJournal.Loadout["Pet"..i]

		_G["PetJournalLoadoutPet"..i.."BG"]:Hide()

		bu.iconBorder:SetAlpha(0)
		bu.qualityBorder:SetTexture("")
		bu.levelBG:SetAlpha(0)
		bu.helpFrame:GetRegions():Hide()
		bu.dragButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)

		bu.level:SetFontObject(_G.GameFontNormal)
		bu.level:SetTextColor(1, 1, 1)

		bu.icon:SetTexCoord(T.unpack(E.TexCoords))
		bu.icon.bg = KS:CreateBDFrame(bu.icon, .25)

		bu.setButton:GetRegions():SetPoint("TOPLEFT", bu.icon, -5, 5)
		bu.setButton:GetRegions():SetPoint("BOTTOMRIGHT", bu.icon, 5, -5)

		KS:CreateBD(bu, .25)

		for i = 2, 12 do
			T.select(i, bu.xpBar:GetRegions()):Hide()
		end

		bu.xpBar:SetStatusBarTexture(E.media.normTex)
		KS:CreateBDFrame(bu.xpBar, .25)

		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarLeft"]:Hide()
		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarRight"]:Hide()
		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarMiddle"]:Hide()
		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarBGMiddle"]:Hide()

		bu.healthFrame.healthBar:SetStatusBarTexture(E["media"].normTex)
		KS:CreateBDFrame(bu.healthFrame.healthBar, .25)

		for j = 1, 3 do
			local spell = bu["spell"..j]

			spell:SetPushedTexture("")
			spell:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
			spell:GetRegions():Hide()

			spell.icon:SetTexCoord(T.unpack(E.TexCoords))
			KS:CreateBG(spell.icon)
		end
	end

	hooksecurefunc("PetJournal_UpdatePetLoadOut", function()
		for i = 1, 3 do
			local bu = _G.PetJournal.Loadout["Pet"..i]

			bu.icon.bg:SetShown(not bu.helpFrame:IsShown())
			bu.icon.bg:SetBackdropBorderColor(bu.qualityBorder:GetVertexColor())

			bu.dragButton:SetEnabled(not bu.helpFrame:IsShown())
		end
	end)

	_G.PetJournal.SpellSelect.BgEnd:Hide()
	_G.PetJournal.SpellSelect.BgTiled:Hide()

	-- [[ Toy box ]]
	local ToyBox = _G.ToyBox

	-- Progress bar
	local progressBar = ToyBox.progressBar
	progressBar.text:SetPoint("CENTER", 0, 1)

	-- Toys
	for i = 1, 18 do
		local button = ToyBox.iconsFrame['spellButton'..i]
		KS:StyleButton(button)
		KS:ReskinIcon(button.iconTexture)
		KS:ReskinIcon(button.iconTextureUncollected)

		button.name:SetPoint('LEFT', button, 'RIGHT', 9, 0)

		local bg = KS:CreateBDFrame(button)
		bg:SetPoint('TOPLEFT', button, 'TOPRIGHT', 0, -2)
		bg:SetPoint('BOTTOMLEFT', button, 'BOTTOMRIGHT', 0, 2)
		bg:SetPoint('RIGHT', button.name, 'RIGHT', 0, 0)
		KS:CreateGradient(bg)
	end

	-- [[ Heirlooms ]]
	local HeirloomsJournal = _G.HeirloomsJournal

	-- Progress bar
	local progressBar = HeirloomsJournal.progressBar
	progressBar.text:SetPoint("CENTER", 0, 1)


	hooksecurefunc(HeirloomsJournal, "UpdateButton", function(_, button)
		if not button.IsStyled then
			local bg = KS:CreateBDFrame(button)
			bg:SetPoint('TOPLEFT', button, 'TOPRIGHT', 0, -2)
			bg:SetPoint('BOTTOMLEFT', button, 'BOTTOMRIGHT', 0, 2)
			bg:SetPoint('RIGHT', button.name, 'RIGHT', 2, 0)
			KS:CreateGradient(bg)
			button.IsStyled = true
		end
	end)

	-- Header
	hooksecurefunc(HeirloomsJournal, "LayoutCurrentPage", function()
		for i = 1, #HeirloomsJournal.heirloomHeaderFrames do
			local header = HeirloomsJournal.heirloomHeaderFrames[i]
			if not header.IsStyled then
				header.text:SetTextColor(1, 1, 1)
				header.text:SetFont(E.media.normFont, 16, "OUTLINE")

				header.IsStyled = true
			end
		end
	end)

	-- [[ WardrobeCollectionFrame ]]
	local WardrobeCollectionFrame = _G.WardrobeCollectionFrame
	local ItemsCollectionFrame = WardrobeCollectionFrame.ItemsCollectionFrame

	for index = 1, 2 do
		local tab = _G["WardrobeCollectionFrameTab"..index]
		for i = 1, 6 do
			T.select(i, tab:GetRegions()):SetAlpha(0)
		end

		if tab.backdrop then
			tab.backdrop:Hide()
		end

		tab:SetHighlightTexture("")
		tab.bg = KS:CreateBDFrame(tab, .25)
		tab.bg:SetPoint("TOPLEFT", 3, -3)
		tab.bg:SetPoint("BOTTOMRIGHT", -3, -1)
	end

	hooksecurefunc("WardrobeCollectionFrame_SetTab", function(tabID)
		for index = 1, 2 do
			local tab = _G["WardrobeCollectionFrameTab"..index]
			if tabID == index then
				tab.bg:SetBackdropColor(r, g, b, .45)
			else
				tab.bg:SetBackdropColor(0, 0, 0, .2)
			end
		end
	end)

	-- Progress bar
	local progressBar = WardrobeCollectionFrame.progressBar
	progressBar.text:SetPoint("CENTER", 0, 1)

	-- ItemSetsCollection
	local SetsCollectionFrame = WardrobeCollectionFrame.SetsCollectionFrame
	KS:CreateBDFrame(SetsCollectionFrame.Model, .25)

	local ScrollFrame = SetsCollectionFrame.ScrollFrame
	for i = 1, #ScrollFrame.buttons do
		local bu = ScrollFrame.buttons[i]
		bu.Background:Hide()
		bu.HighlightTexture:SetTexture("")
		KS:ReskinIcon(bu.Icon)

		bu.SelectedTexture:SetDrawLayer("BACKGROUND")
		bu.SelectedTexture:SetColorTexture(r, g, b, .25)
		bu.SelectedTexture:ClearAllPoints()
		bu.SelectedTexture:SetPoint("TOPLEFT", 1, -2)
		bu.SelectedTexture:SetPoint("BOTTOMRIGHT", -1, 2)
		KS:CreateBDFrame(bu.SelectedTexture, .25)
	end

	local DetailsFrame = SetsCollectionFrame.DetailsFrame
	DetailsFrame.ModelFadeTexture:Hide()
	DetailsFrame.IconRowBackground:Hide()

	hooksecurefunc(SetsCollectionFrame, "SetItemFrameQuality", function(_, itemFrame)
		local ic = itemFrame.Icon
		if not ic.bg then
			ic:SetTexCoord(T.unpack(E.TexCoords))
			itemFrame.IconBorder:Hide()
			itemFrame.IconBorder.Show = KUI.dummy
			ic.bg = KS:CreateBDFrame(ic)
		end

		if itemFrame.collected then
			local quality = T.C_TransmogCollection_GetSourceInfo(itemFrame.sourceID).quality
			local color = BAG_ITEM_QUALITY_COLORS[quality or 1]
			ic.bg:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			ic.bg:SetBackdropBorderColor(0, 0, 0)
		end
	end)

	local SetsTransmogFrame = WardrobeCollectionFrame.SetsTransmogFrame
	for i = 1, 34 do
		T.select(i, SetsTransmogFrame:GetRegions()):Hide()
	end

	-- [[ Wardrobe ]]
	local WardrobeFrame = _G.WardrobeFrame
	local WardrobeTransmogFrame = _G.WardrobeTransmogFrame

	_G.WardrobeTransmogFrameBg:Hide()
	WardrobeTransmogFrame.Inset.BG:Hide()
	WardrobeTransmogFrame.Inset:DisableDrawLayer("BORDER")
	WardrobeTransmogFrame.MoneyLeft:Hide()
	WardrobeTransmogFrame.MoneyMiddle:Hide()
	WardrobeTransmogFrame.MoneyRight:Hide()

	WardrobeFrame:Styling()

	for i = 1, 9 do
		T.select(i, WardrobeTransmogFrame.SpecButton:GetRegions()):Hide()
	end

	for i = 1, 9 do
		T.select(i, _G.WardrobeOutfitFrame:GetRegions()):Hide()
	end
	KS:CreateBDFrame(_G.WardrobeOutfitFrame, .25)
	KS:CreateSD(_G.WardrobeOutfitFrame, .25)

	for i = 1, 10 do
		T.select(i, WardrobeTransmogFrame.Model.ClearAllPendingButton:GetRegions()):Hide()
	end
	WardrobeTransmogFrame.SpecButton:SetPoint("RIGHT", WardrobeTransmogFrame.ApplyButton, "LEFT", -3, 0)

	local slots = {
		"Head",
		"Shoulder",
		"Chest",
		"Waist",
		"Legs",
		"Feet",
		"Wrist",
		"Hands",
		"Back",
		"Shirt",
		"Tabard",
		"MainHand",
		"SecondaryHand"
	}

	for i = 1, #slots do
		local slot = WardrobeTransmogFrame.Model[slots[i] .. "Button"]
		if slot then
			slot.Border:Hide()
			slot.Icon:SetDrawLayer("BACKGROUND", 1)
			KS:ReskinIcon(slot.Icon)
			slot:SetHighlightTexture(E["media"].normTex)
			local hl = slot:GetHighlightTexture()
			hl:SetVertexColor(1, 1, 1, .25)
			hl:SetPoint("TOPLEFT", 2, -2)
			hl:SetPoint("BOTTOMRIGHT", -2, 2)
		end
	end

	-- Edit Frame
	for i = 1, 11 do
		local region = T.select(i, _G.WardrobeOutfitEditFrame:GetRegions())
		if region then
			region:Hide()
		end
	end
	_G.WardrobeOutfitEditFrame.Title:Show()

	for i = 2, 5 do
		T.select(i, _G.WardrobeOutfitEditFrame.EditBox:GetRegions()):Hide()
	end

	
	if E.db.KlixUI.misc.transmog then	
		-- Remove Transmog Button
		local ClearAllPendingButton = WardrobeTransmogFrame.Model.ClearAllPendingButton
		local button = T.CreateFrame("Button", KUI.Title.."TransmogRemoveButton", WardrobeTransmogFrame, "UIMenuButtonStretchTemplate")
		local pendingPoint = {"TOPLEFT", ClearAllPendingButton, "BOTTOMLEFT", 0, -5}
		local defaultPoint = {"TOPLEFT", ClearAllPendingButton, "TOPLEFT", 0, 0}
		button:SetWidth(26)
		button:SetHeight(26)
		button:SetFrameLevel(ClearAllPendingButton:GetFrameLevel())
		button:SetPoint(T.unpack(defaultPoint))
		S:HandleButton(button)

		-- button icon
		button.Icon = button:CreateTexture(KUI.Title.."TransmogRemoveButtonTexture", "ARTWORK")
		button.Icon:SetAtlas("XMarksTheSpot")
		button.Icon:SetSize(18, 18)
		button.Icon:SetPoint("CENTER")
		
		button:HookScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 0, 4)
			GameTooltip:AddLine(L["Instantly remove all transmogs."])
			GameTooltip:Show()
		end)

		button:HookScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)

		button:HookScript("OnClick", function(self, button)
			if (button == "LeftButton") then S:RemoveAllTransmog() end
		end)

		-- Hook to set button point
		ClearAllPendingButton:HookScript("OnShow", function(self)
			button:SetPoint(T.unpack(pendingPoint))
		end)
		ClearAllPendingButton:HookScript("OnHide", function(self)
			button:SetPoint(T.unpack(defaultPoint))
		end)
	end
end

-- Removes transmog from all transmogged slots.
function S:RemoveAllTransmog()
	for _, slot in T.pairs(TransmogSlots) do
    local slotID = T.GetInventorySlotInfo(slot)
    S:RemoveTransmog(slotID)
  end
end

-- Removes transmog from the specified slot if possible.
-- @param slotID - the inventory slot to remove transmog
function S:RemoveTransmog(slotID)
  local isTransmogrified, hasPending = T.C_Transmog_GetSlotInfo(slotID, LE_TRANSMOG_TYPE_APPEARANCE)
  if isTransmogrified then
    T.C_Transmog_SetPending(slotID, LE_TRANSMOG_TYPE_APPEARANCE, 0)
  elseif hasPending then
    T.C_Transmog_ClearPending(slotID, LE_TRANSMOG_TYPE_APPEARANCE)
  end
end

S:AddCallbackForAddon("Blizzard_Collections", "KuiCollections", styleCollections)