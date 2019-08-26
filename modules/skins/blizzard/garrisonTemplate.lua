local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local function styleGarrisonTemplates()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.orderhall ~= true or E.private.skins.blizzard.garrison ~= true or E.private.KlixUI.skins.blizzard.garrison ~= true then return end

	--[[ AddOns\Blizzard_GarrisonTemplates.lua ]]
	function KS.GarrisonFollowerList_UpdateData(self)
		local followers = self.followers
		local followersList = self.followersList
		local numFollowers = #followersList
		local scrollFrame = self.listScroll
		local offset = T.HybridScrollFrame_GetOffset(scrollFrame)
		local buttons = scrollFrame.buttons
		local numButtons = #buttons

		for i = 1, numButtons do
			local button = buttons[i]
			local index = offset + i -- adjust index
			if index <= numFollowers and followersList[index] ~= 0 then
				local follower = followers[followersList[index]]

				if follower.isCollected then
					-- adjust text position if we have additional text to show below name
					local nameOffsetY = 0
					if follower.status then
						nameOffsetY = nameOffsetY + 6
					end
					-- show iLevel for max level followers
					if T.ShouldShowILevelInFollowerList(follower) then
						nameOffsetY = nameOffsetY + 6
						button.Follower.ILevel:SetPoint("TOPLEFT", button.Follower.Name, "BOTTOMLEFT", 0, -2)
						button.Follower.Status:SetPoint("TOPLEFT", button.Follower.ILevel, "BOTTOMLEFT", 0, 0)
					else
						button.Follower.Status:SetPoint("TOPLEFT", button.Follower.Name, "BOTTOMLEFT", 0, -2)
					end

					if button.Follower.DurabilityFrame:IsShown() then
						nameOffsetY = nameOffsetY + 8

						if follower.status then
							button.Follower.DurabilityFrame:SetPoint("TOPLEFT", button.Follower.Status, "BOTTOMLEFT", 0, -4)
						elseif T.ShouldShowILevelInFollowerList(follower) then
							button.Follower.DurabilityFrame:SetPoint("TOPLEFT", button.Follower.ILevel, "BOTTOMLEFT", 0, -6)
						else
							button.Follower.DurabilityFrame:SetPoint("TOPLEFT", button.Follower.Name, "BOTTOMLEFT", 0, -6)
						end
					end
					button.Follower.Name:SetPoint("LEFT", button.Follower.PortraitFrame, "RIGHT", 10, nameOffsetY)
				end
			end
		end
	end

	function KS.GarrisonFollowerButton_SetCounterButton(button, followerID, index, info, lastUpdate, followerTypeID)
		local counter = button.Counters[index]
		if not counter._auroraSkinned then
			KS:GarrisonMissionAbilityCounterTemplate(counter)
			counter.isSkinned = true
		end

		local scale = _G.GarrisonFollowerOptions[followerTypeID].followerListCounterScale
		if scale ~= 1 then
			counter:SetScale(1)
			local size = 20 * scale
			counter:SetSize(size, size)
		end
	end

	function KS.GarrisonFollowerList_ExpandButtonAbilities(self, button, traitsFirst)
		if not button.isCollected then
			return -1
		end

		local abHeight = 0
		local buttonCount = 0
		for i = 1, #button.info.abilities do
			if traitsFirst == button.info.abilities[i].isTrait and button.info.abilities[i].icon then
				buttonCount = buttonCount + 1

				local Ability = button.Abilities[buttonCount]
				abHeight = abHeight + (Ability:GetHeight())
			end
		end
		for i = 1, #button.info.abilities do
			if traitsFirst ~= button.info.abilities[i].isTrait and button.info.abilities[i].icon then
				buttonCount = buttonCount + 1

				local Ability = button.Abilities[buttonCount]
				abHeight = abHeight + (Ability:GetHeight())
			end
		end

		for i = (#button.info.abilities + 1), #button.Abilities do
			button.Abilities[i]:Hide()
		end
		if abHeight > 0 then
			abHeight = abHeight + 8
			button.AbilitiesBG:Show()
		else
			button.AbilitiesBG:Hide()
		end
		return abHeight
	end

	function KS.GarrisonFollowerList_ExpandButton(self, button, followerListFrame)
		local abHeight = KS.GarrisonFollowerList_ExpandButtonAbilities(self, button, false)
		if abHeight == -1 then
			return
		end

		button.UpArrow:Show()
		button.DownArrow:Hide()
	end

	function KS.GarrisonFollowerButton_AddAbility(self, index, ability, followerType)
		local Ability = self.Abilities[index]
		if not Ability._auroraSkinned then
			KS.GarrisonFollowerListButtonAbilityTemplate(Ability)
			Ability.IsSkinned = true
		end
	end

	function KS.GarrisonFollowerList_CollapseButton(self, button)
		button:SetHeight(46)
	end

	--[[ AddOns\Blizzard_GarrisonTemplates.xml ]]
	function KS:GarrisonUITemplate(Frame)
		Frame:Styling()
	end

	function KS:GarrisonMissionBaseFrameTemplate(Frame)
		Frame.BaseFrameBackground:Hide()
		Frame.BaseFrameTop:Hide()
		Frame.BaseFrameBottom:Hide()
		Frame.BaseFrameLeft:Hide()
		Frame.BaseFrameRight:Hide()
		Frame.BaseFrameTopLeft:Hide()
		Frame.BaseFrameTopRight:Hide()
		Frame.BaseFrameBottomLeft:Hide()
		Frame.BaseFrameBottomRight:Hide()

		for i = 10, 17 do
			T.select(i, Frame:GetRegions()):Hide()
		end
	end

	function KS:GarrisonListTemplate(Frame)
		KS:GarrisonMissionBaseFrameTemplate(Frame)

		Frame.listScroll:SetPoint("TOPLEFT", 2, -2)
		Frame.listScroll:SetPoint("BOTTOMRIGHT", -20, 2)
	end

	function KS:GarrisonListTemplateHeader(Frame)
		KS:GarrisonListTemplate(Frame)

		Frame.HeaderLeft:Hide()
		Frame.HeaderRight:Hide()
		Frame.HeaderMid:Hide()
	end

	function KS:GarrisonFollowerButtonTemplate(Frame)
		Frame.BG:Hide()

		Frame.Selection:SetTexCoord(0, 0.99568965517241, 0.01785714285714, 0.96428571428571)
		Frame.Selection:SetAllPoints()

		Frame.XPBar:SetPoint("TOPLEFT", Frame.PortraitFrame, "BOTTOMRIGHT", 0, 6)
		KS:GarrisonFollowerPortraitTemplate(Frame.PortraitFrame)
		Frame.PortraitFrame:SetPoint("TOPLEFT", -3, 3)
		Frame.Highlight:SetTexCoord(0, 0.99568965517241, 0.01785714285714, 0.96428571428571)
		Frame.Highlight:SetAllPoints()

		--[[ Scale ]]--
		Frame:SetWidth(260)
	end

	function KS:GarrisonFollowerCombatAllySpellTemplate(Button)
		S:HandleIcon(Button.iconTexture)
	end

	function KS:GarrisonFollowerEquipmentTemplate(Button)
		KS:GarrisonEquipmentTemplate(Button)
		Button.BG:Hide()
		Button.Border:Hide()
	end

	function KS:GarrisonMissionFollowerDurabilityFrameTemplate(Frame)
	end

	function KS:GarrisonAbilityCounterTemplate(Frame)
		if Frame then
			S:HandleIcon(Frame.Icon)
			Frame.Icon:SetSize(20, 20)

			Frame.Border:ClearAllPoints()
			Frame.Border:SetPoint("TOPLEFT", Frame.Icon, -8, 8)
			Frame.Border:SetPoint("BOTTOMRIGHT", Frame.Icon, 8, -8)
		end
	end

	function KS:GarrisonMissionAbilityCounterTemplate(Frame)
		if Frame then
			KS:GarrisonAbilityCounterTemplate(Frame)
		end
	end

	function KS:GarrisonFollowerListButtonAbilityTemplate(Frame)
		if Frame then
			S:HandleIcon(Frame.Icon)
		end
	end

	function KS:GarrisonMissionFollowerButtonTemplate(Frame)
		KS:GarrisonFollowerButtonTemplate(Frame)
		Frame.AbilitiesBG:SetAlpha(0)
		Frame.BusyFrame:SetAllPoints()
	end

	function KS:GarrisonMissionFollowerOrCategoryListButtonTemplate(Frame)
		KS:GarrisonMissionFollowerButtonTemplate(Frame.Follower)
	end

	function KS:MaterialFrameTemplate(Frame)
		local bg, label = Frame:GetRegions()
		bg:Hide()
		label:SetPoint("LEFT", 5, 0)
		Frame.Materials:SetPoint("RIGHT", Frame.Icon, "LEFT", -5, 0)

		S:HandleIcon(Frame.Icon)
		Frame.Icon:SetSize(18, 18)
		Frame.Icon:SetPoint("RIGHT", -5, 0)
	end

	function KS:GarrisonEquipmentTemplate(Button)
		S:HandleIcon(Button.Icon)
	end

	function KS.GarrisonFollowerTabMixin_OnLoad(self)
		--hooksecurefunc(self.abilitiesPool, "Acquire", KS.ObjectPoolMixin_Acquire)
		--hooksecurefunc(self.equipmentPool, "Acquire", KS.ObjectPoolMixin_Acquire)
		--hooksecurefunc(self.countersPool, "Acquire", KS.ObjectPoolMixin_Acquire)
	end

	----====####$$$$%%%%%%%$$$$####====----
	-- Blizzard_GarrisonMissionTemplates --
	----====####$$$$%%%%%%%$$$$####====----

	function KS.GarrisonMissionFrame_SetItemRewardDetails(frame)
		local _, _, quality = T.GetItemInfo(frame.itemID)
		KS.SetItemButtonQuality(frame, quality, frame.itemID)
	end

	function KS:GarrisonMissionCompleteDialogTemplate(Frame)
		KS:GarrisonMissionStageTemplate(Frame.Stage)
		local left, right = T.select(5, Frame.Stage:GetRegions())
		left:Hide()
		right:Hide()
	end

	function KS:GarrisonMissionCompleteTemplate(Frame)
	end

	function KS:GarrisonFollowerXPBarTemplate(StatusBar)
		StatusBar.XPLeft:ClearAllPoints()
		StatusBar.XPRight:ClearAllPoints()
	end

	function KS:StartMissionButtonTemplate(Button)
		Button.Flash:SetAtlas("GarrMission_FollowerListButton-Select")
		Button.Flash:SetAllPoints()
		Button.Flash:SetTexCoord(0, 0.99568965517241, 0.01785714285714, 0.96428571428571)
	end

	function KS:GarrisonMissionPageCostFrameTemplate(Button)
		S:HandleIcon(Button.CostIcon)
	end

	function KS:GarrisonMissionPageCloseButtonTemplate(Button)
		S:HandleCloseButton(Button)
		Button:SetSize(22, 22)
	end

	function KS:GarrisonMissionFrameTemplate(Frame)
		Frame:SetSize(Frame:GetSize())
	end

	function KS:GarrisonMissionRewardEffectsTemplate(Frame)
		S:HandleIcon(Frame.Icon)

		Frame.IconBorder:Hide()
		local iconBG = T.CreateFrame("Frame", nil, Frame)
		iconBG:SetPoint("TOPLEFT", Frame.Icon, -1, 1)
		iconBG:SetPoint("BOTTOMRIGHT", Frame.Icon, 1, -1)
		Frame._KuiIconBorder = iconBG

		Frame.BG:SetAlpha(0)
		local nameBG = T.CreateFrame("Frame", nil, Frame)
		nameBG:SetPoint("TOPLEFT", iconBG, "TOPRIGHT", 1, 0)
		nameBG:SetPoint("BOTTOMRIGHT", -3, -1)
		Frame._KuiNameBG = nameBG

		--[[ Scale ]]--
		Frame:SetSize(Frame:GetSize())
	end

	function KS:GarrisonMissionPageOvermaxRewardTemplate(Frame)
		S:HandleIcon(Frame.Icon)

		Frame.IconBorder:Hide()
		local iconBG = T.CreateFrame("Frame", nil, Frame)
		iconBG:SetPoint("TOPLEFT", Frame.Icon, -1, 1)
		iconBG:SetPoint("BOTTOMRIGHT", Frame.Icon, 1, -1)
		Frame._KuiIconBorder = iconBG

		--[[ Scale ]]--
		Frame:SetSize(Frame:GetSize())
	end

	function KS:GarrisonMissionPageRewardTemplate(Frame)
	KS:GarrisonMissionPageOvermaxRewardTemplate(Frame.OvermaxItem)
	KS:GarrisonMissionRewardEffectsTemplate(Frame.Reward1)
	KS:GarrisonMissionRewardEffectsTemplate(Frame.Reward2)
	end

	function KS:GarrisonAbilityLargeCounterTemplate(Frame)
		S:HandleIcon(Frame.Icon)
	end

	function KS:GarrisonMissionLargeMechanicTemplate(Frame)
		KS:GarrisonAbilityLargeCounterTemplate(Frame)
	end

	function KS:GarrisonMissionCheckTemplate(Frame)
	end

	function KS:GarrisonMissionMechanicTemplate(Frame)
		KS:GarrisonAbilityCounterTemplate(Frame)
	end

	function KS:GarrisonMissionEnemyMechanicTemplate(Frame)
		KS:GarrisonMissionMechanicTemplate(Frame)
		KS:GarrisonMissionCheckTemplate(Frame)
	end

	function KS:GarrisonMissionEnemyLargeMechanicTemplate(Frame)
		KS:GarrisonMissionLargeMechanicTemplate(Frame)
		KS:GarrisonMissionCheckTemplate(Frame)
	end

	function KS:GarrisonMissionStageTemplate(Frame)
		Frame.LocBack:SetPoint("TOPLEFT")
		Frame.LocBack:SetPoint("BOTTOMRIGHT")
		T.select(4, Frame:GetRegions()):Hide()

		local mask1 = Frame:CreateMaskTexture(nil, "ARTWORK")
		mask1:SetTexture([[Interface\Common\icon-shadow]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
		mask1:SetPoint("TOPLEFT", Frame.LocBack, -150, 100)
		mask1:SetPoint("BOTTOMRIGHT", Frame.LocBack, 150, -20)
		Frame.LocBack:AddMaskTexture(mask1)
		Frame.LocMid:AddMaskTexture(mask1)
		Frame.LocFore:AddMaskTexture(mask1)
	end

	function KS:GarrisonMissionPageStageTemplate(Frame)
		KS:VerticalLayoutFrame(Frame.MissionInfo)
		KS:GarrisonMissionStageTemplate(Frame)
	end

	function KS:GarrisonMissionCompleteStageTemplate(Frame)
	end

	function KS:GarrisonMissionCompleteStageTemplate(Frame)
	end

	function KS:GarrisonMissionCompleteTemplate(Frame)
		Frame.ButtonFrameLeft:Hide()
		Frame.ButtonFrameRight:Hide()
	end

	function KS:GarrisonFollowerXPBarTemplate(StatusBar)
		StatusBar.XPLeft:ClearAllPoints()
		StatusBar.XPRight:ClearAllPoints()
	end

	function KS:GarrisonFollowerXPGainTemplate(Frame)
	end

	function KS:GarrisonFollowerLevelUpTemplate(Frame)
	end

	-- Blizzard_GarrisonSharedTemplates --
	----====####$$$$%%%%%%$$$$####====----

	--hooksecurefunc(GarrisonFollowerList, "UpdateData", KS.GarrisonFollowerList_UpdateData)
	hooksecurefunc("GarrisonFollowerButton_SetCounterButton", KS.GarrisonFollowerButton_SetCounterButton)
	--hooksecurefunc(GarrisonFollowerList, "ExpandButton", KS.GarrisonFollowerList_ExpandButton)
	hooksecurefunc("GarrisonFollowerButton_AddAbility", KS.GarrisonFollowerButton_AddAbility)
	--hooksecurefunc(GarrisonFollowerList, "CollapseButton", KS.GarrisonFollowerList_CollapseButton)
	hooksecurefunc(_G.GarrisonFollowerTabMixin, "OnLoad", KS.GarrisonFollowerTabMixin_OnLoad)
end

S:AddCallbackForAddon("Blizzard_GarrisonTemplates", "KuiGarrisonTemplates", styleGarrisonTemplates)