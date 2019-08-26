-------------------------------------------------------------------------------
-- Credits: FlightQueue - notbitingsock
-------------------------------------------------------------------------------
local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local FQ = KUI:NewModule("FlightQueue", "AceEvent-3.0", "AceTimer-3.0")

local WorldMapFrame = _G.WorldMapFrame

local queueSlotIndex = 0
local queueIsFerry = false
local queueNodeID = 0
local queueContinent = 0
local bypass = false
--local changed = false
--local firstRun = false

function GetCurrentMapContinent(relative)
	local currentMapId = WorldMapFrame:GetMapID() or 0
	if relative == "player" then
		currentMapId = T.C_Map_GetBestMapForUnit('player')
	end
	local continentInfo = MapUtil.GetMapParentInfo(currentMapId, Enum.UIMapType.Continent, true)
	if continentInfo then 
		return continentInfo.mapID
	else
		return 0
	end
end

function OnUpdateHandler(poi)
	poi:SetSize(24,24)
end

function OnEnterHandler(poi)
	for i in T.pairs(nodes) do
		if nodes[i].name == poi.name then
			GameTooltip:SetOwner(poi, "ANCHOR_RIGHT")
			GameTooltip:SetText("|cfff960d9KlixUI|r: "..nodes[i].name)
			GameTooltip:Show()
		end
	end
end

function ClickHandler(poi,button)
	local c = GetCurrentMapContinent()
	if button == "LeftButton" then
		local poiIsFerry = T.string_find(poi.Texture:GetAtlas(), "Ferry")
		for i in T.pairs(nodes) do
			local nodeIsFerry = nodes[i].textureKitPrefix == "FlightMaster_Ferry"
			if nodes[i].name == poi.name then
				if (poiIsFerry and nodeIsFerry) or (not poiIsFerry and not nodeIsFerry) then
					if queueSlotIndex == nodes[i].slotIndex then
						queueSlotIndex = 0
						queueNodeID = 0
						KUI:Print("Flight Point Cleared")
						return
					elseif fcontinent[c] ~= nil then
						queueSlotIndex = nodes[i].slotIndex
						queueNodeID = nodes[i].nodeID
						queueIsFerry = poiIsFerry
						queueContinent = c
						KUI:Print(nodes[i].name)
						return
					end
				end
			end
		end
		if fcontinent[c] == true then
			KUI:Print("You have not visited a flight master on this continent yet.")
		else
			KUI:Print(TAXI_PATH_UNREACHABLE) --Not Discovered
		end
	end

end

--[[function FQ:ZONE_CHANGED_NEW_AREA()
	changed = true
	KUI:Print(changed)
end]]

function FQ:TAXIMAP_OPENED()
	local newnodes = T.C_TaxiMap_GetTaxiNodesForMap(mapID)
	if nodes == nil then
		nodes = newnodes
		for k in T.pairs(nodes) do 
			if nodes[k].state == Enum.FlightPathState.Unreachable then 
				nodes[k]=nil
			end
		end
	end
	local added = ""
	for k in T.pairs(newnodes) do
		if newnodes[k].state ~= Enum.FlightPathState.Unreachable then 
			local mergeNode = true
			for K in T.pairs(nodes) do
				if nodes[K].nodeID == newnodes[k].nodeID then
					mergeNode = false
					nodes[K].state=newnodes[k].state
				end
			end
			if mergeNode == true then
				T.table_insert(nodes,newnodes[k])
				added = added..T.string_match(newnodes[k].name, "(.+),")..", "
			end
		end
	end
	if added~="" then
		KUI:Print("New Nodes: "..T.string_sub(added,1,-3))
	end
	fcontinent[GetCurrentMapContinent("player")]=false
	if queueSlotIndex > 0 then
		bypass = false
		local nodeState
		local destinationIsFerry
		local departureIsFerry
		for k in T.pairs(newnodes) do
			if newnodes[k].nodeID == queueNodeID then
				nodeState=newnodes[k].state
				destinationIsFerry = newnodes[k].textureKitPrefix == "FlightMaster_Ferry"
			end
			if newnodes[k].state == 0 then
				--KUI:Print(newnodes[k].textureKitPrefix)
				departureIsFerry = newnodes[k].textureKitPrefix == "FlightMaster_Ferry"
			end
		end
		--KUI:Print(departureIsFerry)
		--KUI:Print(destinationIsFerry)
		if T.IsShiftKeyDown() ~= true and 
		GetCurrentMapContinent("player") == queueContinent and 
		((departureIsFerry and destinationIsFerry) or (not departureIsFerry and not destinationIsFerry)) and
		nodeState==1 then
			T.TakeTaxiNode(queueSlotIndex);
			for i=1,8 do
				T.C_Timer_After(i/4,function () if T.UnitOnTaxi("player") == false then T.TakeTaxiNode(queueSlotIndex) end;end)
			end
		elseif T.IsShiftKeyDown() then
			bypass = true
		end
	end
end

function FQ:PLAYER_CONTROL_LOST()
	if bypass == false then
		if queueSlotIndex > 0 and GetCurrentMapContinent("player") == queueContinent then
			T.C_Timer_After(5,function()
				if T.UnitOnTaxi("player") then
					queueSlotIndex = 0
					queueNodeID = 0
				end
			end)
		end
	end
end

function FQ:QUEST_LOG_UPDATE()
	if not T.IsInInstance() then
		local NewContinent = GetCurrentMapContinent("player")
		if fcontinent[NewContinent] == nil and NewContinent > 0 then
		--changed and not T.IsInInstance() then
		
		--KUI:Print("player"..NewContinent)
		
		--for k in pairs(fcontinent) do
			--KUI:Print(k..tostring(fcontinent[k]))
			--fcontinent[k] = false
		--end
		--if fcontinent[NewContinent] == nil and NewContinent > 0 then
			KUI:Print("New Continent. Visit a Flight Master to load new taxi nodes.")
			fcontinent[NewContinent] = true
		end
		--changed = false
	end
	if WorldMapFrame:IsVisible() and nodes ~= nil then
		for pin in WorldMapFrame:EnumeratePinsByTemplate("GroupMembersPinTemplate") do
			if E.db.KlixUI.misc.whistleLocation then
				pin:SetFrameStrata("MEDIUM")
			else
				pin:SetFrameStrata("FULLSCREEN_DIALOG")
			end
		end
		for node in WorldMapFrame:EnumeratePinsByTemplate("FlightPointPinTemplate") do
			node:HookScript("OnEnter",OnEnterHandler)
			node:SetScript("OnMouseDown", ClickHandler)
			node:HookScript("OnLeave",function()
				T.GameTooltip_Hide()
			end)
			node:HookScript("OnUpdate",OnUpdateHandler)
			if WorldMapFrame:GetFrameStrata() == "FULLSCREEN" then
				node:SetFrameStrata("FULLSCREEN_DIALOG")
			else
				if E.db.KlixUI.misc.whistleLocation then
					node:SetFrameStrata("MEDIUM")
				else
					node:SetFrameStrata("DIALOG")
				end
			end
		end
	end
end

function FQ:Initialize()
	if not E.db.KlixUI.maps.worldmap.flightQ then return end

	self:RegisterEvent("TAXIMAP_OPENED")
	self:RegisterEvent("QUEST_LOG_UPDATE") 
	--self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("PLAYER_CONTROL_LOST")
	
	if fcontinent == nil then
		fcontinent = {}
	end
end


local function InitializeCallback()
	FQ:Initialize()
end

KUI:RegisterModule(FQ:GetName(), InitializeCallback)