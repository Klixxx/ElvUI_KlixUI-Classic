local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local r, g, b = T.unpack(E.media.rgbvaluecolor)

local function styleGarrison()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.orderhall ~= true or E.private.skins.blizzard.garrison ~= true or E.private.KlixUI.skins.blizzard.garrison ~= true then return end

	-- [[ Garrison system ]]
	function KS:ReskinMissionPage(self)
		self:StripTextures()
		self.StartMissionButton.Flash:SetTexture("")
		KS:Reskin(self.StartMissionButton)

		self.CloseButton:ClearAllPoints()
		self.CloseButton:SetPoint("TOPRIGHT", -10, -5)
		T.select(4, self.Stage:GetRegions()):Hide()
		T.select(5, self.Stage:GetRegions()):Hide()

		local bg = KS:CreateBDFrame(self.Stage)
		bg:SetPoint("TOPLEFT", 4, 1)
		bg:SetPoint("BOTTOMRIGHT", -4, -1)
		local overlay = self.Stage:CreateTexture()
		overlay:SetDrawLayer("ARTWORK", 3)
		overlay:SetAllPoints(bg)
		overlay:SetColorTexture(0, 0, 0, .5)
		local iconbg = T.select(16, self:GetRegions())
		iconbg:ClearAllPoints()
		iconbg:SetPoint("TOPLEFT", 3, -1)

		for i = 1, 3 do
			local follower = self.Followers[i]
			follower:GetRegions():Hide()
			KS:CreateBD(follower, .25)
			KS:ReskinGarrisonPortrait(follower.PortraitFrame)
			follower.PortraitFrame:ClearAllPoints()
			follower.PortraitFrame:SetPoint("TOPLEFT", 0, -3)
		end

		for i = 1, 10 do
			T.select(i, self.RewardsFrame:GetRegions()):Hide()
		end
		KS:CreateBD(self.RewardsFrame, .25)

		local env = self.Stage.MissionEnvIcon
		env.Texture:SetDrawLayer("BORDER", 1)
		KS:ReskinIcon(env.Texture)

		local item = self.RewardsFrame.OvermaxItem
		item.Icon:SetDrawLayer("BORDER", 1)
		KS:ReskinIcon(item.Icon)
	end

	function KS:ReskinMissionList()
		local buttons = self.listScroll.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if not button.styled then
				local rareOverlay = button.RareOverlay
				local rareText = button.RareText

				button:StripTextures()
				KS:CreateBD(button, .25)

				rareText:ClearAllPoints()
				rareText:SetPoint("BOTTOMLEFT", button, 20, 10)
				rareOverlay:SetDrawLayer("BACKGROUND")
				rareOverlay:SetTexture(E.media.normTex)
				rareOverlay:SetAllPoints()
				rareOverlay:SetVertexColor(.098, .537, .969, .2)

				button.styled = true
			end
		end
	end

	function KS:ReskinMissionTabs(self)
		for i = 1, 2 do
			local tab = _G[self:GetName().."Tab"..i]
			tab:StripTextures()
			KS:CreateBD(tab, .25)
			if i == 1 then
				tab:SetBackdropColor(r, g, b, .2)
			end
		end
	end

	function KS:ReskinMissionComplete(self)
		local missionComplete = self.MissionComplete
		local bonusRewards = missionComplete.BonusRewards
		select(11, bonusRewards:GetRegions()):SetTextColor(1, .8, 0)
		bonusRewards.Saturated:StripTextures()
		for i = 1, 9 do
			T.select(i, bonusRewards:GetRegions()):SetAlpha(0)
		end
		KS:CreateBD(bonusRewards)
		KS:Reskin(missionComplete.NextMissionButton)
	end

	function KS:ReskinGarrMaterial(self)
		self.MaterialFrame.Icon:SetTexCoord(unpack(E.TexCoords))
		self.MaterialFrame:GetRegions():Hide()
		local bg = KS:CreateBDFrame(self.MaterialFrame, .25)
		bg:SetPoint("TOPLEFT", 5, -5)
		bg:SetPoint("BOTTOMRIGHT", -5, 6)
	end

	function KS:ReskinMissionFrame(self)
		if self.GarrCorners then self.GarrCorners:Hide() end
		if self.ClassHallIcon then self.ClassHallIcon:Hide() end
		if self.Topper then self.Topper:SetAtlas(T.UnitFactionGroup("player").."Frame-Header") end
		if self.TitleScroll then
			T.select(4, self.TitleScroll:GetRegions()):SetTextColor(1, .8, 0)
		end
		for i = 1, 3 do
			local tab = _G[self:GetName().."Tab"..i]
			if tab then KS:ReskinTab(tab) end
		end
		if self.MapTab then self.MapTab.ScrollContainer.Child.TiledBackground:Hide() end

		KS:ReskinMissionComplete(self)
		KS:ReskinMissionPage(self.MissionTab.MissionPage)

		local missionList = self.MissionTab.MissionList
		missionList:StripTextures()
		KS:ReskinGarrMaterial(missionList)
		KS:ReskinMissionTabs(missionList)
		hooksecurefunc(missionList, "Update", KS.ReskinMissionList)

		local followerList = self.FollowerList
		KS:ReskinGarrMaterial(followerList)
	end

	-- Building frame
	local GarrisonBuildingFrame = _G.GarrisonBuildingFrame
	GarrisonBuildingFrame:StripTextures()
	KS:CreateBD(GarrisonBuildingFrame)
	GarrisonBuildingFrame.GarrCorners:Hide()
	if GarrisonBuildingFrame.backdrop then GarrisonBuildingFrame.backdrop:Hide() end
	GarrisonBuildingFrame:Styling()

	-- Tutorial button
	local MainHelpButton = GarrisonBuildingFrame.MainHelpButton
	MainHelpButton.Ring:Hide()
	MainHelpButton:SetPoint("TOPLEFT", GarrisonBuildingFrame, "TOPLEFT", -12, 12)

	-- Building list
	local BuildingList = GarrisonBuildingFrame.BuildingList

	BuildingList:DisableDrawLayer("BORDER")
	BuildingList.MaterialFrame.Icon:SetTexCoord(T.unpack(E.TexCoords))
	BuildingList.MaterialFrame:GetRegions():Hide()

	local bg = KS:CreateBDFrame(BuildingList.MaterialFrame, .25)
	bg:SetPoint("TOPLEFT", 5, -5)
	bg:SetPoint("BOTTOMRIGHT", -5, 6)

	for i = 1, GARRISON_NUM_BUILDING_SIZES do
		local tab = BuildingList["Tab"..i]

		tab:GetNormalTexture():SetAlpha(0)

		local bg = T.CreateFrame("Frame", nil, tab)
		bg:SetPoint("TOPLEFT", 6, -7)
		bg:SetPoint("BOTTOMRIGHT", -6, 7)
		bg:SetFrameLevel(tab:GetFrameLevel()-1)
		KS:CreateBD(bg, .25)
		tab.bg = bg

		local hl = tab:GetHighlightTexture()
		hl:SetColorTexture(r, g, b, .1)
		hl:ClearAllPoints()
		hl:SetPoint("TOPLEFT", bg, 1, -1)
		hl:SetPoint("BOTTOMRIGHT", bg, -1, 1)
	end

	hooksecurefunc("GarrisonBuildingList_SelectTab", function(tab)
		local list = GarrisonBuildingFrame.BuildingList

		for i = 1, GARRISON_NUM_BUILDING_SIZES do
			local otherTab = list["Tab"..i]
			if i ~= tab:GetID() then
				otherTab.bg:SetBackdropColor(0, 0, 0, .25)
			end
		end
		tab.bg:SetBackdropColor(r, g, b, .2)

		for _, button in pairs(list.Buttons) do
			if not button.styled then
				button.BG:Hide()

				KS:ReskinIcon(button.Icon)

				local bg = T.CreateFrame("Frame", nil, button)
				bg:SetPoint("TOPLEFT", 44, -5)
				bg:SetPoint("BOTTOMRIGHT", 0, 6)
				bg:SetFrameLevel(button:GetFrameLevel()-1)
				KS:CreateBD(bg, .25)

				button.SelectedBG:SetColorTexture(r, g, b, .2)
				button.SelectedBG:ClearAllPoints()
				button.SelectedBG:SetPoint("TOPLEFT", bg, 1, -1)
				button.SelectedBG:SetPoint("BOTTOMRIGHT", bg, -1, 1)

				local hl = button:GetHighlightTexture()
				hl:SetColorTexture(r, g, b, .1)
				hl:ClearAllPoints()
				hl:SetPoint("TOPLEFT", bg, 1, -1)
				hl:SetPoint("BOTTOMRIGHT", bg, -1, 1)

				button.styled = true
			end
		end
	end)

	-- Building level tooltip
	local BuildingLevelTooltip = GarrisonBuildingFrame.BuildingLevelTooltip

	for i = 1, 9 do
		T.select(i, BuildingLevelTooltip:GetRegions()):Hide()
	end
	BuildingLevelTooltip:Styling()

	-- Follower list
	local FollowerList = GarrisonBuildingFrame.FollowerList

	FollowerList:DisableDrawLayer("BACKGROUND")
	FollowerList:DisableDrawLayer("BORDER")

	FollowerList:ClearAllPoints()
	FollowerList:SetPoint("BOTTOMLEFT", 24, 34)

	-- Info box
	local InfoBox = GarrisonBuildingFrame.InfoBox
	local TownHallBox = GarrisonBuildingFrame.TownHallBox

	for i = 1, 25 do
		T.select(i, InfoBox:GetRegions()):Hide()
		T.select(i, TownHallBox:GetRegions()):Hide()
	end

	KS:CreateBD(InfoBox, .25)
	KS:CreateBD(TownHallBox, .25)
	KS:Reskin(InfoBox.UpgradeButton)
	KS:Reskin(TownHallBox.UpgradeButton)
	GarrisonBuildingFrame.MapFrame.TownHall.TownHallName:SetTextColor(1, .8, 0)

	do
		local FollowerPortrait = InfoBox.FollowerPortrait

		FollowerPortrait:SetPoint("BOTTOMLEFT", 230, 10)
		FollowerPortrait.RemoveFollowerButton:ClearAllPoints()
		FollowerPortrait.RemoveFollowerButton:SetPoint("TOPRIGHT", 4, 4)
	end

	-- Confirmation popup
	local Confirmation = GarrisonBuildingFrame.Confirmation

	Confirmation:GetRegions():Hide()
	KS:CreateBD(Confirmation)
	KS:Reskin(Confirmation.CancelButton)
	KS:Reskin(Confirmation.BuildButton)
	KS:Reskin(Confirmation.UpgradeButton)
	KS:Reskin(Confirmation.UpgradeGarrisonButton)
	KS:Reskin(Confirmation.ReplaceButton)
	KS:Reskin(Confirmation.SwitchButton)

	-- [[ Capacitive display frame ]]
	local GarrisonCapacitiveDisplayFrame = _G.GarrisonCapacitiveDisplayFrame

	GarrisonCapacitiveDisplayFrameLeft:Hide()
	GarrisonCapacitiveDisplayFrameMiddle:Hide()
	GarrisonCapacitiveDisplayFrameRight:Hide()
	KS:CreateBD(GarrisonCapacitiveDisplayFrame.Count, .25)
	GarrisonCapacitiveDisplayFrame.Count:SetWidth(38)
	GarrisonCapacitiveDisplayFrame.Count:SetTextInsets(3, 0, 0, 0)
	GarrisonCapacitiveDisplayFrame.IncrementButton:ClearAllPoints()
	GarrisonCapacitiveDisplayFrame.IncrementButton:Point('LEFT', GarrisonCapacitiveDisplayFrame.Count, 'RIGHT', 4, 0)

	KS:Reskin(GarrisonCapacitiveDisplayFrame.StartWorkOrderButton, true)
	KS:Reskin(GarrisonCapacitiveDisplayFrame.CreateAllWorkOrdersButton, true)

	GarrisonCapacitiveDisplayFrame:Styling()

	-- Capacitive display
	local CapacitiveDisplay = GarrisonCapacitiveDisplayFrame.CapacitiveDisplay

	CapacitiveDisplay.IconBG:SetAlpha(0)

	do
		local icon = CapacitiveDisplay.ShipmentIconFrame.Icon
		icon:SetTexCoord(T.unpack(E.TexCoords))
		KS:CreateBG(icon)
	end

	local reagentIndex = 1
	hooksecurefunc("GarrisonCapacitiveDisplayFrame_Update", function()
		local reagents = CapacitiveDisplay.Reagents

		local reagent = reagents[reagentIndex]
		while reagent do
			reagent.NameFrame:SetAlpha(0)
			if reagent.backdrop then reagent.backdrop:Hide() end

			reagent.Icon:SetTexCoord(T.unpack(E.TexCoords))
			reagent.Icon:SetDrawLayer("BORDER")
			KS:CreateBG(reagent.Icon)

			local bg = T.CreateFrame("Frame", nil, reagent)
			bg:SetPoint("TOPLEFT")
			bg:SetPoint("BOTTOMRIGHT", 0, 2)
			bg:SetFrameLevel(reagent:GetFrameLevel() - 1)
			KS:CreateBD(bg, .25)

			reagentIndex = reagentIndex + 1
			reagent = reagents[reagentIndex]
		end
	end)

	-- [[ Landing page ]]
	local GarrisonLandingPage = _G["GarrisonLandingPage"]

	for i = 1, 10 do
		T.select(i, GarrisonLandingPage:GetRegions()):Hide()
	end

	if GarrisonLandingPage.backdrop then GarrisonLandingPage.backdrop:Hide() end

	KS:CreateBD(GarrisonLandingPage)
	GarrisonLandingPage:Styling()
	KS:ReskinTab(GarrisonLandingPageTab1)
	KS:ReskinTab(GarrisonLandingPageTab2)
	KS:ReskinTab(GarrisonLandingPageTab3)

	GarrisonLandingPageTab1:ClearAllPoints()
	GarrisonLandingPageTab1:SetPoint("TOPLEFT", GarrisonLandingPage, "BOTTOMLEFT", 70, 2)

	-- Report
	local Report = GarrisonLandingPage.Report

	select(2, Report:GetRegions()):Hide()
	Report.List:GetRegions():Hide()

	local scrollFrame = Report.List.listScroll

	local buttons = scrollFrame.buttons
	for i = 1, #buttons do
		local button = buttons[i]
		button.BG:Hide()

		local bg = T.CreateFrame("Frame", nil, button)
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT", 0, 1)
		bg:SetFrameLevel(button:GetFrameLevel() - 1)

		for _, reward in T.pairs(button.Rewards) do
			reward:GetRegions():Hide()
			reward.Icon:SetTexCoord(T.unpack(E.TexCoords))
			reward.IconBorder:SetAlpha(0)
			KS:CreateBG(reward.Icon)
			reward:ClearAllPoints()
			reward:SetPoint("TOPRIGHT", -4, -4)
		end

		KS:CreateBD(bg, .25)
		KS:CreateGradient(bg)
	end

	for _, tab in T.pairs({Report.InProgress, Report.Available}) do
		tab:SetHighlightTexture("")
		tab.Text:ClearAllPoints()
		tab.Text:SetPoint("CENTER")

		local bg = T.CreateFrame("Frame", nil, tab)
		bg:SetFrameLevel(tab:GetFrameLevel() - 1)
		KS:CreateBD(bg, .25)
		KS:CreateGradient(bg)

		local selectedTex = bg:CreateTexture(nil, "BACKGROUND")
		selectedTex:SetAllPoints()
		selectedTex:SetColorTexture(r, g, b, .2)
		selectedTex:Hide()
		tab.selectedTex = selectedTex

		if tab == Report.InProgress then
			bg:SetPoint("TOPLEFT", 5, 0)
			bg:SetPoint("BOTTOMRIGHT")
		else
			bg:SetPoint("TOPLEFT")
			bg:SetPoint("BOTTOMRIGHT", -7, 0)
		end
	end

	hooksecurefunc("GarrisonLandingPageReport_SetTab", function(self)
		local unselectedTab = Report.unselectedTab
		unselectedTab:SetHeight(36)
		unselectedTab:SetNormalTexture("")
		unselectedTab.selectedTex:Hide()
		self:SetNormalTexture("")
		self.selectedTex:Show()
	end)

	local FollowerList = GarrisonLandingPage.FollowerList

	FollowerList:GetRegions():Hide()
	T.select(2, FollowerList:GetRegions()):Hide()

	-- Ship follower list
	local FollowerList = GarrisonLandingPage.ShipFollowerList

	FollowerList:GetRegions():Hide()
	T.select(2, FollowerList:GetRegions()):Hide()

	-- [[ Mission UI ]]
	local GarrisonMissionFrame = _G.GarrisonMissionFrame
	if GarrisonMissionFrame.backdrop then GarrisonMissionFrame.backdrop:Hide() end
	KS:CreateBD(GarrisonMissionFrame, .25)
	KS:ReskinMissionFrame(GarrisonMissionFrame)
	GarrisonMissionFrame:Styling()

	hooksecurefunc("GarrisonMissonListTab_SetSelected", function(tab, isSelected)
		if isSelected then
			tab:SetBackdropColor(r, g, b, .2)
		else
			tab:SetBackdropColor(0, 0, 0, .25)
		end
	end)

	hooksecurefunc("GarrisonFollowerButton_AddAbility", function(self, index)
		local ability = self.Abilities[index]

		if not ability.styled then
			local icon = ability.Icon
			icon:SetSize(19, 19)
			KS:ReskinIcon(icon)

			ability.styled = true
		end
	end)

	hooksecurefunc("GarrisonMissionPage_SetReward", function(frame)
		if not frame.bg then
			frame.Icon:SetTexCoord(T.unpack(E.TexCoords))
			KS:CreateBDFrame(frame.Icon)
			frame.BG:SetAlpha(0)
			frame.bg = KS:CreateBDFrame(frame.BG, .25)
			frame.IconBorder:SetScale(.0001)
		end
	end)

	hooksecurefunc(_G.GarrisonMission, "UpdateMissionParty", function(_, followers)
		for followerIndex = 1, #followers do
			local followerFrame = followers[followerIndex]
			if followerFrame.info then
				for i = 1, #followerFrame.Counters do
					local counter = followerFrame.Counters[i]
					if not counter.styled then
						KS:ReskinIcon(counter.Icon)
						counter.styled = true
					end
				end
			end
		end
	end)

	hooksecurefunc(_G.GarrisonMission, "SetEnemies", function(_, missionPage, enemies)
		for i = 1, #enemies do
			local frame = missionPage.Enemies[i]
			if frame:IsShown() and not frame.styled then
				for j = 1, #frame.Mechanics do
					local mechanic = frame.Mechanics[j]
					KS:ReskinIcon(mechanic.Icon)
				end
				frame.styled = true
			end
		end
	end)

	hooksecurefunc(_G.GarrisonMission, "UpdateMissionData", function(_, missionPage)
		local buffsFrame = missionPage.BuffsFrame
		if buffsFrame:IsShown() then
			for i = 1, #buffsFrame.Buffs do
				local buff = buffsFrame.Buffs[i]
				if not buff.styled then
					KS:ReskinIcon(buff.Icon)
					buff.styled = true
				end
			end
		end
	end)

	hooksecurefunc(_G.GarrisonMission, "MissionCompleteInitialize", function(self, missionList, index)
		local mission = missionList[index]
		if not mission then return end

		for i = 1, #mission.followers do
			local frame = self.MissionComplete.Stage.FollowersFrame.Followers[i]
			if frame.PortraitFrame then
				if not frame.bg then
					frame.PortraitFrame:ClearAllPoints()
					frame.PortraitFrame:SetPoint("TOPLEFT", 0, -10)

					local oldBg = frame:GetRegions()
					oldBg:Hide()
					frame.bg = KS:CreateBDFrame(oldBg)
					frame.bg:SetPoint("TOPLEFT", frame.PortraitFrame, -1, 1)
					frame.bg:SetPoint("BOTTOMRIGHT", -10, 8)
				end
			end
		end
	end)

	-- [[ Recruiter frame ]]
	local GarrisonRecruiterFrame = _G.GarrisonRecruiterFrame

	-- Unavailable frame
	local UnavailableFrame = GarrisonRecruiterFrame.UnavailableFrame

	KS:Reskin(UnavailableFrame:GetChildren())

	-- [[ Recruiter select frame ]]
	local GarrisonRecruitSelectFrame = GarrisonRecruitSelectFrame

	for i = 1, 14 do
		T.select(i, GarrisonRecruitSelectFrame:GetRegions()):Hide()
	end
	GarrisonRecruitSelectFrame.TitleText:Show()
	GarrisonRecruitSelectFrame.GarrCorners:Hide()
	KS:CreateBD(GarrisonRecruitSelectFrame)

	-- Follower list
	local FollowerList = GarrisonRecruitSelectFrame.FollowerList

	FollowerList:DisableDrawLayer("BORDER")

	-- Follower selection
	local FollowerSelection = GarrisonRecruitSelectFrame.FollowerSelection

	FollowerSelection:DisableDrawLayer("BORDER")
	for i = 1, 3 do
		local recruit = FollowerSelection["Recruit"..i]
		KS:Reskin(recruit.HireRecruits)
	end

	-- [[ Monuments ]]
	local GarrisonMonumentFrame = _G.GarrisonMonumentFrame

	GarrisonMonumentFrame.Background:Hide()
	KS:CreateBD(GarrisonMonumentFrame)
	GarrisonMonumentFrame:Styling()

	-- [[ Shipyard ]]
	local GarrisonShipyardFrame = _G.GarrisonShipyardFrame

	for i = 1, 14 do
		T.select(i, GarrisonShipyardFrame.BorderFrame:GetRegions()):Hide()
	end

	GarrisonShipyardFrame.BorderFrame.TitleText:Show()
	GarrisonShipyardFrame.BorderFrame.GarrCorners:Hide()
	GarrisonShipyardFrame.BackgroundTile:Hide()
	if GarrisonShipyardFrame.backdrop then GarrisonShipyardFrame.backdrop:Hide() end
	KS:CreateBD(GarrisonShipyardFrame, .25)
	GarrisonShipyardFrame:Styling()

	GarrisonShipyardFrameFollowers:GetRegions():Hide()
	T.select(2, GarrisonShipyardFrameFollowers:GetRegions()):Hide()
	GarrisonShipyardFrameFollowers:DisableDrawLayer("BORDER")

	local shipyardTab = GarrisonShipyardFrame.FollowerTab
	shipyardTab:DisableDrawLayer("BORDER")

	KS:ReskinTab(GarrisonShipyardFrameTab1)
	KS:ReskinTab(GarrisonShipyardFrameTab2)

	local shipyardMission = GarrisonShipyardFrame.MissionTab.MissionPage
	shipyardMission:StripTextures()
	KS:Reskin(shipyardMission.StartMissionButton)

	local smbg = KS:CreateBDFrame(shipyardMission.Stage)
	smbg:SetPoint("TOPLEFT", 4, 1)
	smbg:SetPoint("BOTTOMRIGHT", -4, -1)

	for i = 1, 10 do
		T.select(i, shipyardMission.RewardsFrame:GetRegions()):Hide()
	end
	KS:CreateBD(shipyardMission.RewardsFrame, .25)

	GarrisonShipyardFrame.MissionCompleteBackground:GetRegions():Hide()
	GarrisonShipyardFrame.MissionTab.MissionList.CompleteDialog:GetRegions():Hide()
	KS:Reskin(GarrisonShipyardFrame.MissionTab.MissionList.CompleteDialog.BorderFrame.ViewButton)
	T.select(11, GarrisonShipyardFrame.MissionComplete.BonusRewards:GetRegions()):SetTextColor(1, .8, 0)
	KS:Reskin(GarrisonShipyardFrame.MissionComplete.NextMissionButton)

	-- [[ Orderhall UI]]

	local OrderHallMissionFrame = _G.OrderHallMissionFrame
	if OrderHallMissionFrame.backdrop then OrderHallMissionFrame.backdrop:Hide() end
	KS:CreateBD(OrderHallMissionFrame, .25)
	KS:ReskinMissionFrame(OrderHallMissionFrame)
	OrderHallMissionFrame:Styling()

	-- CombatAlly MissionFrame
	local combatAlly = _G.OrderHallMissionFrameMissions.CombatAllyUI
	local portraitFrame = combatAlly.InProgress.PortraitFrame
	local portrait = combatAlly.InProgress.PortraitFrame.Portrait
	local portraitRing = combatAlly.InProgress.PortraitFrame.PortraitRing
	local portraitRingQuality = combatAlly.InProgress.PortraitFrame.PortraitRingQuality
	local levelBorder = combatAlly.InProgress.PortraitFrame.LevelBorder
	combatAlly:StripTextures()
	KS:CreateBD(combatAlly, .25)

	if portrait and not portrait.IsSkinned then
		portraitFrame:CreateBackdrop("Default")
		portraitFrame.backdrop:SetPoint("TOPLEFT", portrait, "TOPLEFT", -1, 1)
		portraitFrame.backdrop:SetPoint("BOTTOMRIGHT", portrait, "BOTTOMRIGHT", 1, -1)
		portrait:ClearAllPoints()
		portrait:SetPoint("TOPLEFT", 1, -1)
		portrait:SetTexCoord(T.unpack(E.TexCoords))
		portraitRing:SetAlpha(0)
		portraitRingQuality:SetAlpha(0)
		levelBorder:SetAlpha(0)

		portrait.IsSkinned = true
	end

	-- CombatAlly ZoneSupport Frame
	_G.OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage:StripTextures()
	KS:CreateBD(_G.OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage, .5)
	local combatAlly = _G.OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage.Follower1
	local portraitFrame = combatAlly.PortraitFrame
	local portrait = portraitFrame.Portrait
	local portraitRing = portraitFrame.PortraitRing
	local portraitRingQuality = portraitFrame.PortraitRingQuality
	local levelBorder = portraitFrame.LevelBorder

	combatAlly:StripTextures()

	if portrait and not portrait.IsSkinned then
		portrait:ClearAllPoints()
		portrait:SetPoint("TOPLEFT", 1, -1)
		portrait:SetTexCoord(T.unpack(E.TexCoords))
		portraitRing:Hide()
		portraitRingQuality:SetAlpha(0)
		levelBorder:SetAlpha(0)

		portrait.IsSkinned = true
	end

	 -- Missions
	local Mission = _G.OrderHallMissionFrameMissions
	Mission.CompleteDialog:StripTextures()
	Mission.CompleteDialog:SetTemplate("Transparent")

	local MissionPage = _G.OrderHallMissionFrame.MissionTab.MissionPage
	for i = 1, 10 do
		T.select(i, MissionPage.RewardsFrame:GetRegions()):Hide()
	end
	KS:CreateBD(MissionPage.RewardsFrame, .25)

	-- [[ BFA Mission UI]]
	local BFAMissionFrame = _G.BFAMissionFrame
	if BFAMissionFrame.backdrop then BFAMissionFrame.backdrop:Hide() end
	KS:CreateBD(BFAMissionFrame, .25)
	BFAMissionFrame:Styling()
	KS:ReskinMissionFrame(BFAMissionFrame)

	-- [[ BFA Missions ]]
	local MissionFrame = _G.BFAMissionFrame

	for i, v in T.ipairs(_G.BFAMissionFrame.MissionTab.MissionList.listScroll.buttons) do
		local Button = _G["BFAMissionFrameMissionsListScrollFrameButton" .. i]
		if Button and not Button.skinned then
			Button:StripTextures()
			KS:CreateBD(Button, .25)
			KS:CreateGradient(Button)
			KS:Reskin(Button, true)
			Button.LocBG:SetAlpha(0)

			Button.isSkinned = true
		end
	end
end

S:AddCallbackForAddon("Blizzard_GarrisonUI", "KuiGarrison", styleGarrison)