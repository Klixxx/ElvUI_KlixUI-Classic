local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local r, g, b = T.unpack(E.media.rgbvaluecolor)

local function styleQuestInfo()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.quest ~= true or E.private.KlixUI.skins.blizzard.quest ~= true then return end

	-- [[ Shared ]]
	local function restyleSpellButton(bu)
		local name = bu:GetName()
		local icon = bu.Icon

		_G[name.."NameFrame"]:Hide()
		_G[name.."SpellBorder"]:Hide()

		icon:SetPoint("TOPLEFT", 3, -2)
		icon:SetDrawLayer("ARTWORK")
		icon:SetTexCoord(unpack(E.TexCoords))
		KS:CreateBG(icon)

		local bg = T.CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", 2, -1)
		bg:SetPoint("BOTTOMRIGHT", 0, 14)
		bg:SetFrameLevel(0)
		KS:CreateBD(bg, .25)
	end

	-- [[ Objectives ]]
	restyleSpellButton(_G.QuestInfoSpellObjectiveFrame)

	local function colorObjectivesText()
		if not _G.QuestInfoFrame.questLog then return end

		local objectivesTable = _G.QuestInfoObjectivesFrame.Objectives
		local numVisibleObjectives = 0

		for i = 1, T.GetNumQuestLeaderBoards() do
			local _, type, finished = T.GetQuestLogLeaderBoard(i)

			if (type ~= "spell" and type ~= "log" and numVisibleObjectives < MAX_OBJECTIVES) then
				numVisibleObjectives = numVisibleObjectives + 1
				local objective = objectivesTable[numVisibleObjectives]

				if objective then
					if finished then
						objective:SetTextColor(34/255, 255/255, 0/255)
					else
						objective:SetTextColor(1, 1, 1)
					end
				end
			end
		end
	end

	hooksecurefunc("QuestMapFrame_ShowQuestDetails", colorObjectivesText)
	hooksecurefunc("QuestInfo_Display", colorObjectivesText)

	-- [[ Quest rewards ]]
	local function restyleRewardButton(bu, isMapQuestInfo)
		bu.Icon:SetTexCoord(T.unpack(E.TexCoords))
		bu.Icon:SetDrawLayer("OVERLAY")
		bu.NameFrame:SetAlpha(0)
		bu.Count:ClearAllPoints()
		bu.Count:SetPoint("BOTTOMRIGHT", bu.Icon, "BOTTOMRIGHT", 2, 0)
		bu.Count:SetDrawLayer("OVERLAY")

		local bg = KS:CreateBDFrame(bu, .25)
		bg:SetFrameStrata("BACKGROUND")

		if isMapQuestInfo then
			bg:SetPoint("TOPLEFT", bu.NameFrame, 1, 1)
			bg:SetPoint("BOTTOMRIGHT", bu.NameFrame, -3, 0)
		else
			bg:SetPoint("TOPLEFT", bu, 1, 1)
			bg:SetPoint("BOTTOMRIGHT", bu, -3, 1)
		end

		if bu.CircleBackground then
			bu.CircleBackground:SetAlpha(0)
			bu.CircleBackgroundGlow:SetAlpha(0)
		end

		bu.bg = bg
	end

	hooksecurefunc("QuestInfo_GetRewardButton", function(rewardsFrame, index)
		local bu = rewardsFrame.RewardButtons[index]

		if (bu and not bu.restyled) then
			restyleRewardButton(bu, rewardsFrame == _G.MapQuestInfoRewardsFrame)

			bu.Icon:SetTexCoord(T.unpack(E.TexCoords))
			bu.IconBorder:SetAlpha(0)
			bu.Icon:SetDrawLayer("OVERLAY")
			bu.Count:SetDrawLayer("OVERLAY")

			bu.restyled = true
		end
	end)

	_G.MapQuestInfoRewardsFrame.XPFrame.Name:SetShadowOffset(0, 0)
	for _, name in T.next, {"HonorFrame", "MoneyFrame", "SkillPointFrame", "XPFrame", "ArtifactXPFrame", "TitleFrame"} do
		restyleRewardButton(_G.MapQuestInfoRewardsFrame[name], true)
	end

	for _, name in T.next, {"HonorFrame", "SkillPointFrame", "ArtifactXPFrame"} do
		restyleRewardButton(_G.QuestInfoRewardsFrame[name])
	end

	--Spell Rewards
	local spellRewards = {_G.QuestInfoRewardsFrame, _G.MapQuestInfoRewardsFrame}
	for _, rewardFrame in T.pairs(spellRewards) do
		local spellRewardFrame = rewardFrame.spellRewardPool:Acquire()
		local icon = spellRewardFrame.Icon
		local nameFrame = spellRewardFrame.NameFrame

		spellRewardFrame:StripTextures()
		icon:SetTexCoord(T.unpack(E.TexCoords))
		KS:CreateBDFrame(icon)
		nameFrame:Hide()

		local bg = KS:CreateBDFrame(nameFrame, .25)
		bg:SetPoint("TOPLEFT", icon, "TOPRIGHT", 0, 2)
		bg:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 101, -1)
	end

	-- Title Reward
	do
		local frame = _G.QuestInfoPlayerTitleFrame
		local icon = frame.Icon

		icon:SetTexCoord(T.unpack(E.TexCoords))
		KS:CreateBDFrame(icon)
		for i = 2, 4 do
			T.select(i, frame:GetRegions()):Hide()
		end
		local bg = KS:CreateBDFrame(frame, .25)
		bg:SetPoint("TOPLEFT", icon, "TOPRIGHT", 0, 2)
		bg:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 220, -1)
	end

	-- Follower Rewards
	hooksecurefunc("QuestInfo_Display", function(template, parentFrame, acceptButton, material, mapView)
		local rewardsFrame = _G.QuestInfoFrame.rewardsFrame
		local isQuestLog = _G.QuestInfoFrame.questLog ~= nil
		local isMapQuest = rewardsFrame == _G.MapQuestInfoRewardsFrame
		local numSpellRewards = isQuestLog and T.GetNumQuestLogRewardSpells() or T.GetNumRewardSpells()

		if (template.canHaveSealMaterial) then
			local questFrame = parentFrame:GetParent():GetParent()
			questFrame.SealMaterialBG:Hide()
		end

		if numSpellRewards > 0 then
			for reward in rewardsFrame.followerRewardPool:EnumerateActive() do
				local portrait = reward.PortraitFrame
				if not reward.styled then
					portrait:ClearAllPoints()
					portrait:SetPoint("TOPLEFT", 2, -5)
					KS:ReskinGarrisonPortrait(portrait)
					reward.BG:Hide()
					local bg = KS:CreateBDFrame(reward, .25)
					bg:SetPoint("TOPLEFT", 0, -3)
					bg:SetPoint("BOTTOMRIGHT", 2, 7)
					reward.styled = true
				end
				if portrait then
					local color = BAG_ITEM_QUALITY_COLORS[portrait.quality or 1]
					portrait.squareBG:SetBackdropBorderColor(color.r, color.g, color.b)
				end
			end
		end
	end)

	-- [[ Change text colors ]]

	hooksecurefunc(_G.QuestInfoRequiredMoneyText, "SetTextColor", function(self, r)
		if r == 0 then
			self:SetTextColor(.8, .8, .8)
		elseif r == .2 then
			self:SetTextColor(1, 1, 1)
		end
	end)

	_G.QuestInfoTitleHeader:SetTextColor(1, 1, 1)
	_G.QuestInfoTitleHeader.SetTextColor = KUI.dummy
	_G.QuestInfoTitleHeader:SetShadowColor(0, 0, 0)

	_G.QuestInfoDescriptionHeader:SetTextColor(1, 1, 1)
	_G.QuestInfoDescriptionHeader.SetTextColor = KUI.dummy
	_G.QuestInfoDescriptionHeader:SetShadowColor(0, 0, 0)

	_G.QuestInfoObjectivesHeader:SetTextColor(1, 1, 1)
	_G.QuestInfoObjectivesHeader.SetTextColor = KUI.dummy
	_G.QuestInfoObjectivesHeader:SetShadowColor(0, 0, 0)

	_G.QuestInfoRewardsFrame.Header:SetTextColor(1, 1, 1)
	_G.QuestInfoRewardsFrame.Header.SetTextColor = KUI.dummy
	_G.QuestInfoRewardsFrame.Header:SetShadowColor(0, 0, 0)

	_G.QuestInfoDescriptionText:SetTextColor(1, 1, 1)
	_G.QuestInfoDescriptionText.SetTextColor = KUI.dummy

	_G.QuestInfoObjectivesText:SetTextColor(1, 1, 1)
	_G.QuestInfoObjectivesText.SetTextColor = KUI.dummy

	_G.QuestInfoGroupSize:SetTextColor(1, 1, 1)
	_G.QuestInfoGroupSize.SetTextColor = KUI.dummy

	_G.QuestInfoRewardText:SetTextColor(1, 1, 1)
	_G.QuestInfoRewardText.SetTextColor = KUI.dummy

	_G.QuestInfoSpellObjectiveLearnLabel:SetTextColor(1, 1, 1)
	_G.QuestInfoSpellObjectiveLearnLabel.SetTextColor = KUI.dummy

	_G.QuestInfoRewardsFrame.ItemChooseText:SetTextColor(1, 1, 1)
	_G.QuestInfoRewardsFrame.ItemChooseText.SetTextColor = KUI.dummy

	_G.QuestInfoRewardsFrame.ItemReceiveText:SetTextColor(1, 1, 1)
	_G.QuestInfoRewardsFrame.ItemReceiveText.SetTextColor = KUI.dummy

	_G.QuestInfoRewardsFrame.PlayerTitleText:SetTextColor(1, 1, 1)
	_G.QuestInfoRewardsFrame.PlayerTitleText.SetTextColor = KUI.dummy

	_G.QuestInfoRewardsFrame.XPFrame.ReceiveText:SetTextColor(1, 1, 1)
	_G.QuestInfoRewardsFrame.XPFrame.ReceiveText.SetTextColor = KUI.dummy

	_G.QuestInfoRewardsFrame.spellHeaderPool:Acquire():SetVertexColor(1, 1, 1)
	_G.QuestInfoRewardsFrame.spellHeaderPool:Acquire().SetVertexColor = KUI.dummy

	_G.QuestFont:SetTextColor(1, 1, 1)
end

S:AddCallback("KuiQuestInfo", styleQuestInfo)