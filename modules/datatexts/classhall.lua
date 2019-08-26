local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule('DataTexts')

local CAPACITANCE_WORK_ORDERS = CAPACITANCE_WORK_ORDERS
local COMPLETE = COMPLETE
local FOLLOWERLIST_LABEL_TROOPS = FOLLOWERLIST_LABEL_TROOPS
local GARRISON_LANDING_SHIPMENT_COUNT = GARRISON_LANDING_SHIPMENT_COUNT
local GARRISON_TALENT_ORDER_ADVANCEMENT = GARRISON_TALENT_ORDER_ADVANCEMENT
local LE_FOLLOWER_TYPE_GARRISON_7_0 = LE_FOLLOWER_TYPE_GARRISON_7_0
local LE_GARRISON_TYPE_7_0 = LE_GARRISON_TYPE_7_0
local ORDER_HALL_MISSIONS = ORDER_HALL_MISSIONS

local displayModifierString = ''
local lastPanel;

local function sortFunction(a, b)
	return a.missionEndTime < b.missionEndTime
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	T.C_Garrison_RequestLandingPageShipmentInfo()

	local firstLine = true

	--Missions
	local inProgressMissions = T.C_Garrison_GetInProgressMissions(LE_FOLLOWER_TYPE_GARRISON_7_0)
	local numMissions = (inProgressMissions and #inProgressMissions or 0)
	local AvailableMissions = T.C_Garrison_GetAvailableMissions(LE_FOLLOWER_TYPE_GARRISON_7_0)
	local numAvailableMissions = (AvailableMissions and #AvailableMissions or 0)
	
	if (numAvailableMissions > 0 and numMissions == 0) then
		DT.tooltip:AddLine(T.string_format(GARRISON_LANDING_AVAILABLE, numAvailableMissions))
	elseif (numMissions > 0) then
		T.table_sort(inProgressMissions, sortFunction) --Sort by time left, lowest first
		DT.tooltip:AddDoubleLine(T.string_format("%s", ORDER_HALL_MISSIONS), T.string_format("%s: %d", AVAILABLE, numAvailableMissions))

		firstLine = false
		for i=1, numMissions do
			local mission = inProgressMissions[i]
			local timeLeft = mission.timeLeft:match("%d")
			local r, g, b = 1, 1, 1
			if(mission.isRare) then
				r, g, b = 0.09, 0.51, 0.81
			end

			if(timeLeft and timeLeft == "0") then
				DT.tooltip:AddDoubleLine(mission.name, COMPLETE, r, g, b, 0, 1, 0)
			else
				DT.tooltip:AddDoubleLine(mission.name, mission.timeLeft, r, g, b)
			end
		end
	end

	-- Troop Work Orders
	local followerShipments = T.C_Garrison_GetFollowerShipments(LE_GARRISON_TYPE_7_0)
	local hasFollowers = false
	if (followerShipments) then
		for i = 1, #followerShipments do
			local name, _, _, shipmentsReady, shipmentsTotal = T.C_Garrison_GetLandingPageShipmentInfoByContainerID(followerShipments[i])
			if ( name and shipmentsReady and shipmentsTotal ) then
				if(hasFollowers == false) then
					if not firstLine then
						DT.tooltip:AddLine(" ")
					end
					firstLine = false
					DT.tooltip:AddLine(FOLLOWERLIST_LABEL_TROOPS) -- "Troops"
					hasFollowers = true
				end

				DT.tooltip:AddDoubleLine(name, T.string_format(GARRISON_LANDING_SHIPMENT_COUNT, shipmentsReady, shipmentsTotal), 1, 1, 1)
			end
		end
	end

	-- "Loose Work Orders" (i.e. research, equipment)
	local looseShipments = T.C_Garrison_GetLooseShipments(LE_GARRISON_TYPE_7_0)
	local hasLoose = false
	if (looseShipments) then
		for i = 1, #looseShipments do
			local name, _, _, shipmentsReady, shipmentsTotal = T.C_Garrison_GetLandingPageShipmentInfoByContainerID(looseShipments[i])
			if ( name and shipmentsReady and shipmentsTotal ) then
				if(hasLoose == false) then
					if not firstLine then
						DT.tooltip:AddLine(" ")
					end
					firstLine = false
					DT.tooltip:AddLine(CAPACITANCE_WORK_ORDERS) -- "Work Orders"
					hasLoose = true
				end

				DT.tooltip:AddDoubleLine(name, T.string_format(GARRISON_LANDING_SHIPMENT_COUNT, shipmentsReady, shipmentsTotal), 1, 1, 1)
			end
		end
	end

	-- Talents
	local talentTreeIDs = T.C_Garrison_GetTalentTreeIDsByClassID(LE_GARRISON_TYPE_7_0, T.select(3, T.UnitClass("player")));
	-- this is a talent that has completed, but has not been seen in the talent UI yet.
	local hasTalent = false
	if (talentTreeIDs) then
		local completeTalentID = T.C_Garrison_GetCompleteTalent(LE_GARRISON_TYPE_7_0)
		for treeIndex, treeID in T.ipairs(talentTreeIDs) do
			local _, _, tree = T.C_Garrison_GetTalentTreeInfoForID(treeID)
			for talentIndex, talent in T.ipairs(tree) do
				local showTalent = false;
				if (talent.isBeingResearched) then
					showTalent = true;
				end
				if (talent.id == completeTalentID) then
					showTalent = true;
				end
				if (showTalent) then
					if not firstLine then
						DT.tooltip:AddLine(" ")
					end
					firstLine = false
					DT.tooltip:AddLine(GARRISON_TALENT_ORDER_ADVANCEMENT); -- "Order Advancement"
					DT.tooltip:AddDoubleLine(talent.name, T.string_format(GARRISON_LANDING_SHIPMENT_COUNT, talent.isBeingResearched and 0 or 1, 1), 1, 1, 1);
					hasTalent = true
				end
			end
		end
	end

	if(numMissions > 0 or numAvailableMissions > 0 or hasFollowers or hasLoose or hasTalent) then
		DT.tooltip:Show()
	else
		DT.tooltip:Hide()
	end
end

local function OnClick()
	if not (T.C_Garrison_HasGarrison(LE_GARRISON_TYPE_7_0)) then
		return;
	end

	local isShown = GarrisonLandingPage and GarrisonLandingPage:IsShown();
	if (not isShown) then
		T.ShowGarrisonLandingPage(LE_GARRISON_TYPE_7_0);
	elseif (GarrisonLandingPage) then
		local currentGarrType = GarrisonLandingPage.garrTypeID;
		T.HideUIPanel(GarrisonLandingPage);
		if (currentGarrType ~= LE_GARRISON_TYPE_7_0) then
			T.ShowGarrisonLandingPage(LE_GARRISON_TYPE_7_0);
		end
	end
end

local _, class = T.UnitClass("player");
local function OnEvent(self)
	local inProgressMissions = {};
	T.C_Garrison_GetInProgressMissions(inProgressMissions, LE_FOLLOWER_TYPE_GARRISON_7_0)
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
	else
		self.text:SetText(_G["ORDER_HALL_"..class]) --or ORDER_HALL_LANDING_PAGE_TITLE
	end
	
	lastPanel = self
end

local function ValueColorUpdate(hex, r, g, b)
	displayModifierString = T.string_join("", "%s: ", hex, "%d/%d|r")
	
	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E['valueColorUpdateFuncs'][ValueColorUpdate] = true

DT:RegisterDatatext('Classhall (KUI)', {'PLAYER_ENTERING_WORLD', 'GARRISON_MISSION_LIST_UPDATE', 'GARRISON_MISSION_STARTED', 'GARRISON_MISSION_FINISHED', 'ZONE_CHANGED_NEW_AREA', 'GARRISON_MISSION_COMPLETE_RESPONSE'}, OnEvent, nil, OnClick, OnEnter)
