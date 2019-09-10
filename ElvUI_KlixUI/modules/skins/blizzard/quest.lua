local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local function styleQuest()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.quest ~= true or E.private.KlixUI.skins.blizzard.quest ~= true then return end
	
	local QuestLogFrame = _G.QuestLogFrame
	if QuestLogFrame.backdrop then
		QuestLogFrame.backdrop:Styling()
	end
	
	-- Hide ElvUI backdrop
	_G.QuestLogListScrollFrame.backdrop:Hide()
	if _G.QuestLogDetailScrollFrame.backdrop then
		QuestLogDetailScrollFrame.backdrop:Hide()
	end
	
	for frame, numItems in pairs({['QuestLogItem'] = _G.MAX_NUM_ITEMS, ['QuestProgressItem'] = _G.MAX_REQUIRED_ITEMS, ['MapQuestInfoRewardsFrameQuestInfoItem'] = _G.MAX_REQUIRED_ITEMS}) do
		for i = 1, numItems do
			local item = _G[frame..i]
			local icon = _G[frame..i..'IconTexture']
			if item then
				item:CreateIconShadow()
				if E.db.KlixUI.general.iconShadow and not T.IsAddOnLoaded("Masque") then
					item.ishadow:SetInside(item, 0, 0)
				end
			end
		end
	end
	
	-- Quest Frame
	local QuestFrame = _G.QuestFrame
	QuestFrame.backdrop:Styling()
	
	-- Quest Timer Frame
	local QuestTimerFrame = _G.QuestTimerFrame
	QuestTimerFrame:Styling()
end

S:AddCallback("KuiQuest", styleQuest)