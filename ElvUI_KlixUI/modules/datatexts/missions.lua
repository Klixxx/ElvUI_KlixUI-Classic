local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule('DataTexts')

local GetRGB = GetRGB
local GOAL_COMPLETED = GOAL_COMPLETED
local RESEARCH_TIME_LABEL = RESEARCH_TIME_LABEL
local GARRISON_LANDING_SHIPMENT_COUNT = GARRISON_LANDING_SHIPMENT_COUNT
local FOLLOWERLIST_LABEL_TROOPS = FOLLOWERLIST_LABEL_TROOPS
local LE_FOLLOWER_TYPE_GARRISON_8_0 = LE_FOLLOWER_TYPE_GARRISON_8_0
local LE_GARRISON_TYPE_8_0 = LE_GARRISON_TYPE_8_0
local LE_EXPANSION_BATTLE_FOR_AZEROTH = LE_EXPANSION_BATTLE_FOR_AZEROTH
local ISLANDS_QUEUE_WEEKLY_QUEST_PROGRESS = ISLANDS_QUEUE_WEEKLY_QUEST_PROGRESS
local ISLANDS_HEADER = ISLANDS_HEADER
local ISLANDS_QUEUE_FRAME_TITLE = ISLANDS_QUEUE_FRAME_TITLE
local GREEN_FONT_COLOR = GREEN_FONT_COLOR

local displayModifierString = ''
local lastPanel;

local function sortFunction(a, b)
	return a.missionEndTime < b.missionEndTime
end

local OnEvent = function(self)
	local inProgressMissions = {};
	T.C_Garrison_GetInProgressMissions(inProgressMissions, LE_FOLLOWER_TYPE_GARRISON_8_0)
	local CountInProgress = 0
	local CountCompleted = 0

	for i = 1, #inProgressMissions do
		if inProgressMissions[i].inProgress then
			local TimeLeft = inProgressMissions[i].timeLeft:match("%d")

			if (TimeLeft ~= "0") then
				CountInProgress = CountInProgress + 1
			else
				CountCompleted = CountCompleted + 1
			end
		end
	end

	if (CountInProgress > 0) then
		self.text:SetFormattedText(displayModifierString, GARRISON_MISSIONS, CountCompleted, #inProgressMissions)
	elseif (CountInProgress == 0) and CountCompleted > 0 then
		self.text:SetFormattedText("|cff00ff00%s|r", GARRISON_TYPE_8_0_LANDING_PAGE_TITLE) -- green text when there are completed missions
	else
		self.text:SetFormattedText(GARRISON_TYPE_8_0_LANDING_PAGE_TITLE)
	end

	lastPanel = self
end

local function OnClick()
	if _G.GarrisonLandingPageMinimapButton then
		T.GarrisonLandingPageMinimapButton_OnClick()
	end
end

local OnEnter = function(self)
	DT:SetupTooltip(self)

	T.C_Garrison_RequestLandingPageShipmentInfo()

	local firstLine = true

	--Missions
	local inProgressMissions = {}
	T.C_Garrison_GetInProgressMissions(inProgressMissions, LE_FOLLOWER_TYPE_GARRISON_8_0)
	local numMissions = #inProgressMissions

	local AvailableMissions = {};
	T.C_Garrison_GetAvailableMissions(AvailableMissions, LE_FOLLOWER_TYPE_GARRISON_8_0);

	DT.tooltip:AddLine(T.string_format(GARRISON_LANDING_AVAILABLE:gsub('-', ': '), #AvailableMissions), selectioncolor)
	DT.tooltip:AddLine(" ")

	if(numMissions > 0) then
		T.table_sort(inProgressMissions, sortFunction) --Sort by time left, lowest first
		firstLine = false
		DT.tooltip:AddLine(L["Mission(s) Report:"])
		for i=1, numMissions do
			local mission = inProgressMissions[i]
			local timeLeft = mission.timeLeft:match("%d")
			local r, g, b = 1, 1, 1
			if(mission.isRare) then
				r, g, b = 0.09, 0.51, 0.81
			end

			if(timeLeft and timeLeft == "0") then
				DT.tooltip:AddDoubleLine(mission.name, GOAL_COMPLETED, r, g, b, GREEN_FONT_COLOR:GetRGB())
			else
				DT.tooltip:AddDoubleLine(mission.name, mission.timeLeft, r, g, b)
			end
		end
	end

	-- Troop Work Orders
	local followerShipments = T.C_Garrison_GetFollowerShipments(LE_GARRISON_TYPE_8_0)
	local hasFollowers = false
	if(followerShipments) then
		for i = 1, #followerShipments do
			local name, _, _, shipmentsReady, shipmentsTotal, _, _, timeleftString = T.C_Garrison_GetLandingPageShipmentInfoByContainerID(followerShipments[i])
			if(name and shipmentsReady and shipmentsTotal) then
				if(hasFollowers == false) then
					if not firstLine then
						DT.tooltip:AddLine(" ")
					end
					firstLine = false
					DT.tooltip:AddLine(FOLLOWERLIST_LABEL_TROOPS) -- "Troops"
					hasFollowers = true
				end

				if timeleftString then
					timeleftString = timeleftString.." "
				else
					timeleftString = ""
				end
				DT.tooltip:AddDoubleLine(name, timeleftString..T.string_format(GARRISON_LANDING_SHIPMENT_COUNT, shipmentsReady, shipmentsTotal), 1, 1, 1)
			end
		end
	end

	-- Talents
	local talentTreeIDs = T.C_Garrison_GetTalentTreeIDsByClassID(LE_GARRISON_TYPE_8_0, E.myClassID)
	local hasTalent = false
	if(talentTreeIDs) then
		-- this is a talent that has completed, but has not been seen in the talent UI yet.
		local completeTalentID = T.C_Garrison_GetCompleteTalent(LE_GARRISON_TYPE_8_0)
		for _, treeID in T.ipairs(talentTreeIDs) do
			local _, _, tree = T.C_Garrison_GetTalentTreeInfoForID(treeID)
			for _, talent in T.ipairs(tree) do
				local showTalent = false
				if(talent.isBeingResearched) then
					showTalent = true
				end
				if(talent.id == completeTalentID) then
					showTalent = true
				end
				if(showTalent) then
					if not firstLine then
						DT.tooltip:AddLine(" ")
					end
					firstLine = false
					DT.tooltip:AddLine(RESEARCH_TIME_LABEL) -- "Research Time:"
					if(talent.researchTimeRemaining and talent.researchTimeRemaining == 0) then
						DT.tooltip:AddDoubleLine(talent.name, GOAL_COMPLETED, 1, 1, 1, GREEN_FONT_COLOR:GetRGB())
					else
						DT.tooltip:AddDoubleLine(talent.name, T.SecondsToTime(talent.researchTimeRemaining), 1, 1, 1)
					end

					hasTalent = true
				end
			end
		end
	end

	-- Island Expeditions
	local hasIsland = false
	if(T.UnitLevel("player") >= T.GetMaxLevelForExpansionLevel(LE_EXPANSION_BATTLE_FOR_AZEROTH)) then
		local questID = T.C_IslandsQueue_GetIslandsWeeklyQuestID()
		if questID then
			local _, _, finished, numFulfilled, numRequired = T.GetQuestObjectiveInfo(questID, 1, false);
			local text = ""
			local r1, g1 ,b1

			if finished or T.IsQuestFlaggedCompleted(questID) then
				text = GOAL_COMPLETED
				r1, g1, b1 = GREEN_FONT_COLOR:GetRGB()
			else
				text = ISLANDS_QUEUE_WEEKLY_QUEST_PROGRESS:format(numFulfilled, numRequired)
				r1, g1, b1 = selectioncolor
			end
			
			if not firstLine then
				DT.tooltip:AddLine(" ")
			end
			firstLine = false
			
			DT.tooltip:AddLine(ISLANDS_HEADER..":")
			DT.tooltip:AddDoubleLine(ISLANDS_QUEUE_FRAME_TITLE, text, 1, 1, 1, r1, g1, b1)
			hasIsland = true
		end
	end
	
	if(numMissions > 0 or hasFollowers or hasTalent or hasIsland) then
		DT.tooltip:AddLine(" ")
	end
	DT.tooltip:AddLine(GARRISON_TYPE_8_0_LANDING_PAGE_TOOLTIP, 0.7, 0.7, 1)

	DT.tooltip:Show()
end

local function ValueColorUpdate(hex)
	displayModifierString = T.string_join("", "%s: ", hex, "%d/%d|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E['valueColorUpdateFuncs'][ValueColorUpdate] = true

DT:RegisterDatatext('BfA Missions (KUI)', {'PLAYER_ENTERING_WORLD', 'GARRISON_MISSION_LIST_UPDATE', 'GARRISON_MISSION_STARTED', 'GARRISON_MISSION_FINISHED', 'ZONE_CHANGED_NEW_AREA', 'GARRISON_MISSION_COMPLETE_RESPONSE'}, OnEvent, nil, OnClick, OnEnter)