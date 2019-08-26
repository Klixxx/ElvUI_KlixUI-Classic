local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local r, g, b = T.unpack(E.media.rgbvaluecolor)

local function styleCPaperDollFrame()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.character ~= true or E.private.KlixUI.skins.blizzard.character ~= true then return end

	local CharacterStatsPane = _G.CharacterStatsPane

	--_G.CharacterModelFrame:DisableDrawLayer("BACKGROUND")
	--_G.CharacterModelFrame:DisableDrawLayer("BORDER")
	--_G.CharacterModelFrame:DisableDrawLayer("OVERLAY")

	local slots = {
		"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
		"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
		"SecondaryHand", "Tabard",
	}

	for i = 1, #slots do
		local slot = _G["Character"..slots[i].."Slot"]
		local border = slot.IconBorder

		--_G["Character"..slots[i].."SlotFrame"]:Hide()
		
		slot:CreateIconShadow()
		
		slot:SetNormalTexture("")
		slot:SetPushedTexture("")
		slot:GetHighlightTexture():SetColorTexture(r, g, b, .25)
		slot.SetHighlightTexture = KUI.dummy
		slot.icon:SetTexCoord(T.unpack(E.TexCoords))

		border:SetPoint("TOPLEFT", -1, 1)
		border:SetPoint("BOTTOMRIGHT", 1, -1)
		border:SetDrawLayer("BACKGROUND")
		KS:CreateBDFrame(slot, .25)
	end

	local function StatsPane(type)
		CharacterStatsPane[type]:StripTextures()
		CharacterStatsPane[type].backdrop:Hide()
	end

	local function CharacterStatFrameCategoryTemplate(frame)
		frame:StripTextures()

		local bg = frame.Background
		bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
		bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
		bg:ClearAllPoints()
		bg:SetPoint("CENTER", 0, -5)
		bg:SetSize(210, 30)
		bg:SetVertexColor(r, g, b, 0.5)
	end

	--[[if not T.IsAddOnLoaded("DejaCharacterStats") then
		CharacterStatsPane.ItemLevelCategory.Title:SetTextColor(T.unpack(E.media.rgbvaluecolor))
		CharacterStatsPane.AttributesCategory.Title:SetTextColor(T.unpack(E.media.rgbvaluecolor))
		CharacterStatsPane.EnhancementsCategory.Title:SetTextColor(T.unpack(E.media.rgbvaluecolor))

		StatsPane("EnhancementsCategory")
		StatsPane("ItemLevelCategory")
		StatsPane("AttributesCategory")

		CharacterStatFrameCategoryTemplate(CharacterStatsPane.ItemLevelCategory)
		CharacterStatFrameCategoryTemplate(CharacterStatsPane.AttributesCategory)
		CharacterStatFrameCategoryTemplate(CharacterStatsPane.EnhancementsCategory)


		-- Copied from ElvUI
		local function ColorizeStatPane(frame)
			if frame.leftGrad then frame.leftGrad:StripTextures() end
			if frame.rightGrad then frame.rightGrad:StripTextures() end

			frame.leftGrad = frame:CreateTexture(nil, "BORDER")
			frame.leftGrad:SetWidth(80)
			frame.leftGrad:SetHeight(frame:GetHeight())
			frame.leftGrad:SetPoint("LEFT", frame, "CENTER")
			frame.leftGrad:SetTexture(E.media.blankTex)
			frame.leftGrad:SetGradientAlpha("Horizontal", r, g, b, 0.5, r, g, b, 0)

			frame.rightGrad = frame:CreateTexture(nil, "BORDER")
			frame.rightGrad:SetWidth(80)
			frame.rightGrad:SetHeight(frame:GetHeight())
			frame.rightGrad:SetPoint("RIGHT", frame, "CENTER")
			frame.rightGrad:SetTexture(E.media.blankTex)
			frame.rightGrad:SetGradientAlpha("Horizontal", r, g, b, 0, r, g, b, 0.5)
		end
		CharacterStatsPane.ItemLevelFrame.Background:SetAlpha(0)
		ColorizeStatPane(CharacterStatsPane.ItemLevelFrame)


		hooksecurefunc("PaperDollFrame_UpdateStats", function()
			local level = T.UnitLevel("player")
			local categoryYOffset = -5
			local statYOffset = 0

			if not T.IsAddOnLoaded("DejaCharacterStats") then
				if ( level >= MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY ) then
					T.PaperDollFrame_SetItemLevel(CharacterStatsPane.ItemLevelFrame, "player")
					CharacterStatsPane.ItemLevelFrame.Value:SetTextColor(T.GetItemLevelColor())
					CharacterStatsPane.ItemLevelCategory:Show()
					CharacterStatsPane.ItemLevelFrame:Show()
					CharacterStatsPane.AttributesCategory:SetPoint("TOP", 0, -76)
				else
					CharacterStatsPane.ItemLevelCategory:Hide()
					CharacterStatsPane.ItemLevelFrame:Hide()
					CharacterStatsPane.AttributesCategory:SetPoint("TOP", 0, -20)
					categoryYOffset = -12
					statYOffset = -6
				end
			end

			local spec = T.GetSpecialization()
			local role = T.GetSpecializationRole(spec)

			CharacterStatsPane.statsFramePool:ReleaseAll()
			-- we need a stat frame to first do the math to know if we need to show the stat frame
			-- so effectively we'll always pre-allocate
			local statFrame = CharacterStatsPane.statsFramePool:Acquire()

			local lastAnchor

			for catIndex = 1, #PAPERDOLL_STATCATEGORIES do
				local catFrame = CharacterStatsPane[PAPERDOLL_STATCATEGORIES[catIndex].categoryFrame]
				local numStatInCat = 0
				for statIndex = 1, #PAPERDOLL_STATCATEGORIES[catIndex].stats do
					local stat = PAPERDOLL_STATCATEGORIES[catIndex].stats[statIndex]
					local showStat = true
					if ( showStat and stat.primary ) then
						local primaryStat = T.select(6, T.GetSpecializationInfo(spec, nil, nil, nil, T.UnitSex("player")))
						if ( stat.primary ~= primaryStat ) then
							showStat = false
						end
					end
					if ( showStat and stat.roles ) then
						local foundRole = false
						for _, statRole in T.pairs(stat.roles) do
							if ( role == statRole ) then
								foundRole = true
								break
							end
						end
						showStat = foundRole
					end
					if ( showStat ) then
						statFrame.onEnterFunc = nil
						PAPERDOLL_STATINFO[stat.stat].updateFunc(statFrame, "player")
						if ( not stat.hideAt or stat.hideAt ~= statFrame.numericValue ) then
							if ( numStatInCat == 0 ) then
								if ( lastAnchor ) then
									catFrame:SetPoint("TOP", lastAnchor, "BOTTOM", 0, categoryYOffset)
								end
								statFrame:SetPoint("TOP", catFrame, "BOTTOM", 0, -2)
							else
								statFrame:SetPoint("TOP", lastAnchor, "BOTTOM", 0, statYOffset)
							end
							numStatInCat = numStatInCat + 1
							statFrame.Background:SetShown(false)
							ColorizeStatPane(statFrame)
							statFrame.leftGrad:SetShown((numStatInCat % 2) == 0)
							statFrame.rightGrad:SetShown((numStatInCat % 2) == 0)
							lastAnchor = statFrame
							-- done with this stat frame, get the next one
							statFrame = CharacterStatsPane.statsFramePool:Acquire()
						end
					end
				end
				catFrame:SetShown(numStatInCat > 0)
			end
			-- release the current stat frame
			CharacterStatsPane.statsFramePool:Release(statFrame)
		end)
	end
	
	if T.IsAddOnLoaded("ElvUI_SLE") or E.db.KlixUI.armory.enable then
		_G.PaperDollFrame:HookScript("OnShow", function()
			if CharacterStatsPane.DefenceCategory then
				CharacterStatsPane.DefenceCategory.Title:SetTextColor(T.unpack(E.media.rgbvaluecolor))
				StatsPane("DefenceCategory")
				CharacterStatFrameCategoryTemplate(CharacterStatsPane.DefenceCategory)
			end
			if CharacterStatsPane.OffenseCategory then
				CharacterStatsPane.OffenseCategory.Title:SetTextColor(T.unpack(E.media.rgbvaluecolor))
				StatsPane("OffenseCategory")
				CharacterStatFrameCategoryTemplate(CharacterStatsPane.OffenseCategory)
			end
		end)
	end
	
	-- CharacterFrame Class Texture
	if not ClassTexture and E.db.KlixUI.armory.classCrests then
		ClassTexture = _G.CharacterFrameInsetRight:CreateTexture(nil, "BORDER")
		ClassTexture:SetPoint("BOTTOM", _G.CharacterFrameInsetRight, "BOTTOM", 0, 40)
		ClassTexture:SetSize(126, 120)
		ClassTexture:SetAlpha(.45)
		ClassTexture:SetTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\classIcons\\CLASS-"..E.myclass)
		ClassTexture:SetDesaturated(true)
	end
	
	-- Flyoutbuttons shadow
	local function UpdateFlyoutButtons(button)
		button:CreateIconShadow()
	end
	hooksecurefunc("EquipmentFlyout_DisplayButton", UpdateFlyoutButtons)]]
end

S:AddCallback("KuiPaperDoll", styleCPaperDollFrame)