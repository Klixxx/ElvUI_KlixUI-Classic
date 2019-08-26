local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule('Skins')

local r, g, b = T.unpack(E.media.rgbvaluecolor)

local function stylePvP()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.pvp ~= true or E.private.KlixUI.skins.blizzard.pvp ~= true then return end
	
	_G.PVPReadyDialog:Styling()

	local PVPQueueFrame = _G.PVPQueueFrame
	local HonorFrame = _G.HonorFrame
	local ConquestFrame = _G.ConquestFrame
	local WarGamesFrame = _G.WarGamesFrame

	for i = 1, 3 do
		local bu = PVPQueueFrame["CategoryButton"..i]
		local cu = bu.CurrencyDisplay

		KS:Reskin(bu)

		bu.Icon:Size(54)
		bu.Icon:SetDrawLayer("OVERLAY")
		bu.Icon:ClearAllPoints()
		bu.Icon:SetPoint("LEFT", bu, "LEFT", 4, 0)

		if cu then
			local ic = cu.Icon

			ic:SetSize(16, 16)
			ic:SetPoint("TOPLEFT", bu.Name, "BOTTOMLEFT", 0, -8)
			cu.Amount:SetPoint("LEFT", ic, "RIGHT", 4, 0)

			ic:SetTexCoord(T.unpack(E.TexCoords))
			ic.bg = KS:CreateBG(ic)
			ic.bg:SetDrawLayer("BACKGROUND", 1)
		end
	end

	-- Casual - HonorFrame
	local Inset = HonorFrame.Inset
	local BonusFrame = HonorFrame.BonusFrame

	BonusFrame.WorldBattlesTexture:Hide()
	BonusFrame.ShadowOverlay:Hide()

	local buttons = { ['RandomBGButton'] = HonorFrame.BonusFrame, ['RandomEpicBGButton'] = HonorFrame.BonusFrame, ['Arena1Button'] = HonorFrame.BonusFrame, ['BrawlButton'] = HonorFrame.BonusFrame, ['RatedBG'] = ConquestFrame, ['Arena2v2'] = ConquestFrame, ['Arena3v3'] = ConquestFrame }

	for section, parent in T.pairs(buttons) do
		local button = parent[section]

		if button.backdrop then button.backdrop:Hide() end

		button.SelectedTexture:SetDrawLayer("BACKGROUND")
		button.SelectedTexture:SetColorTexture(r, g, b, .2)
		button.SelectedTexture:SetAllPoints()

		button.Reward.Icon:SetInside(button.Reward)

		KS:CreateBackdrop(button.Reward)
		button.Reward.backdrop:SetOutside(button.Reward)
	end

	hooksecurefunc('PVPUIFrame_ConfigureRewardFrame', function(rewardFrame, honor, experience, itemRewards, currencyRewards)
		local rewardTexture, rewardQuaility = nil, 1

		if currencyRewards then
			for _, reward in T.ipairs(currencyRewards) do
				local name, _, texture, _, _, _, _, quality = T.GetCurrencyInfo(reward.id);
				if quality == LE_ITEM_QUALITY_ARTIFACT then
					_, rewardTexture, _, rewardQuaility = CurrencyContainerUtil.GetCurrencyContainerInfo(reward.id, reward.quantity, name, texture, quality);
				end
			end
		end

		if not rewardTexture and itemRewards then
			local reward = itemRewards[1]
			if reward then
				_, _, rewardQuaility, _, _, _, _, _, _, rewardTexture = T.GetItemInfo(reward.id)
			end
		end

		if rewardTexture then
			rewardFrame.Icon:SetTexture(rewardTexture)
			rewardFrame.backdrop:SetBackdropBorderColor(T.GetItemQualityColor(rewardQuaility))
		end
	end)

	-- Honor frame specific
	for _, bu in T.pairs(HonorFrame.SpecificFrame.buttons) do
		bu.Bg:Hide()
		bu.Border:Hide()

		KS:Reskin(bu)

		-- Hide ElvUI backdrop
		if bu.backdrop then
			bu.backdrop:Hide()
		end

		bu:SetNormalTexture("")
		bu:SetHighlightTexture("")

		local bg = T.CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", -1, 2)
		KS:CreateBD(bg, 0)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)

		bu.tex = KS:CreateGradient(bu)
		bu.tex:SetDrawLayer("BACKGROUND")
		bu.tex:SetPoint("TOPLEFT", bg, 1, -1)
		bu.tex:SetPoint("BOTTOMRIGHT", bg, -1, 1)

		bu.SelectedTexture:SetDrawLayer("BACKGROUND")
		bu.SelectedTexture:SetColorTexture(r, g, b, .2)
		bu.SelectedTexture:SetAllPoints(bu.tex)

		bu.Icon:SetTexCoord(T.unpack(E.TexCoords))
		bu.Icon.bg = KS:CreateBG(bu.Icon)
		bu.Icon.bg:SetDrawLayer("BACKGROUND", 1)
		bu.Icon:SetPoint("TOPLEFT", 5, -3)
	end

	local rewardIcon = HonorFrame.ConquestBar.Reward.Icon
	if not rewardIcon.backdrop then
		KS:CreateBackdrop(rewardIcon)
		rewardIcon.backdrop:SetOutside(rewardIcon)
	end

	-- Credits Azilroka
	hooksecurefunc(HonorFrame.ConquestBar.Reward.Icon, 'SetTexture', function(self) -- Code taken from :GetConquestLevelInfo the function isn't returning the correct id somehow.
		local Quality
		for _, questID in T.ipairs(T.C_QuestLine_GetQuestLineQuests(782)) do
			if not T.IsQuestFlaggedCompleted(questID) and not T.C_QuestLog_IsOnQuest(questID) then
				break;
			end
			if T.HaveQuestRewardData(questID) then
				local itemID = T.select(6, T.GetQuestLogRewardInfo(1, questID))
				Quality = T.select(3, T.GetItemInfo(itemID))
			else
				T.C_TaskQuest_RequestPreloadRewardData(questID) -- Taken from WorldMapFrame
			end
		end
		if Quality then
			self.backdrop:SetBackdropBorderColor(T.GetItemQualityColor(Quality))
		else
			self.backdrop:SetBackdropBorderColor(T.unpack(E.media.bordercolor))
		end
	end)

	-- Rated - ConquestFrame
	local rewardIcon = ConquestFrame.ConquestBar.Reward.Icon
	if not rewardIcon.backdrop then
		KS:CreateBackdrop(rewardIcon)
		rewardIcon.backdrop:SetOutside(rewardIcon)
	end

	-- Credits Azilroka
	hooksecurefunc(ConquestFrame.ConquestBar.Reward.Icon, 'SetTexture', function(self) -- Code taken from :GetConquestLevelInfo the function isn't returning the correct id somehow.
		local Quality
		for _, questID in T.ipairs(T.C_QuestLine_GetQuestLineQuests(782)) do
			if not T.IsQuestFlaggedCompleted(questID) and not T.C_QuestLog_IsOnQuest(questID) then
				break;
			end
			if T.HaveQuestRewardData(questID) then
				local itemID = T.select(6, T.GetQuestLogRewardInfo(1, questID))
				Quality = T.select(3, T.GetItemInfo(itemID))
			else
				T.C_TaskQuest_RequestPreloadRewardData(questID) -- Taken from WorldMapFrame
			end
		end
		if Quality then
			self.backdrop:SetBackdropBorderColor(T.GetItemQualityColor(Quality))
		else
			self.backdrop:SetBackdropBorderColor(T.unpack(E.media.bordercolor))
		end
	end)
end

S:AddCallbackForAddon("Blizzard_PVPUI", "KuiPvPUI", stylePvP)