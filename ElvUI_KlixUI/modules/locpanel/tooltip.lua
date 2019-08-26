-------------------------------------------------------------------------------
-- Credits: ElvUI_LocationPlus - Benik
-------------------------------------------------------------------------------
local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local LP = KUI:GetModule("LocPanel")
local LT = LibStub('LibTourist-3.0')

local GameTooltip = _G.GameTooltip

local PLAYER, UNKNOWN, TRADE_SKILLS, TOKENS, DUNGEONS = PLAYER, UNKNOWN, TRADE_SKILLS, TOKENS, DUNGEONS
local PROFESSIONS_FISHING, LEVEL_RANGE, STATUS, HOME, CONTINENT, PVP, RAID = PROFESSIONS_FISHING, LEVEL_RANGE, STATUS, HOME, CONTINENT, PVP, RAID

-- Icons on Location Panel
local FISH_ICON = "|TInterface\\AddOns\\ElvUI_KlixUI\\media\\textures\\locationpanel\\fish.tga:14:14|t"
local PET_ICON = "|TInterface\\AddOns\\ElvUI_KlixUI\\media\\textures\\locationpanel\\pet.tga:14:14|t"
local LEVEL_ICON = "|TInterface\\AddOns\\ElvUI_KlixUI\\media\\textures\\locationpanel\\levelup.tga:14:14|t"

--------------------
-- Currency Table --
--------------------
-- Add below the currency id you wish to track. 
-- Find the currency ids: http://www.wowhead.com/currencies .
-- Click on the wanted currency and in the address you will see the id.
-- e.g. for Bloody Coin, you will see http://www.wowhead.com/currency=789 . 789 is the id.
-- So, on this case, add 789, (don't forget the comma).
-- If there are 0 earned points, the currency will be filtered out.

local currency = {
	--395,	-- Justice Points
	--396,	-- Valor Points
	--777,	-- Timeless Coins
	--697,	-- Elder Charm of Good Fortune
	--738,	-- Lesser Charm of Good Fortune
	--390,	-- Conquest Points
	--392,	-- Honor Points
	--515,	-- Darkmoon Prize Ticket
	--402,	-- Ironpaw Token
	--776,	-- Warforged Seal
	
	-- WoD
	--824,	-- Garrison Resources
	--823,	-- Apexis Crystal (for gear, like the valors)
	--994,	-- Seal of Tempered Fate (Raid loot roll)
	--980,	-- Dingy Iron Coins (rogue only, from pickpocketing)
	--944,	-- Artifact Fragment (PvP)
	--1101,	-- Oil
	--1129,	-- Seal of Inevitable Fate
	--821,	-- Draenor Clans Archaeology Fragment
	--828,	-- Ogre Archaeology Fragment
	--829,	-- Arakkoa Archaeology Fragment
	--1166, 	-- Timewarped Badge (6.22)
	--1191,	-- Valor Points (6.23)
	
	-- Legion
	--1226,	-- Nethershard (Invasion scenarios)
	--1172,	-- Highborne Archaeology Fragment
	--1173,	-- Highmountain Tauren Archaeology Fragment
	--1155,	-- Ancient Mana
	--1220,	-- Order Resources
	--1275,	-- Curious Coin (Buy stuff :P)
	--1226,	-- Nethershard (Invasion scenarios)
	--1273,	-- Seal of Broken Fate (Raid)
	--1154,	-- Shadowy Coins
	--1149,	-- Sightless Eye (PvP)
	--1268,	-- Timeworn Artifact (Honor Points?)
	--1299,	-- Brawler's Gold
	--1314,	-- Lingering Soul Fragment (Good luck with this one :D)
	--1342,	-- Legionfall War Supplies (Construction at the Broken Shore)
	--1355,	-- Felessence (Craft Legentary items)
	--1356,	-- Echoes of Battle (PvP Gear)
	--1357,	-- Echoes of Domination (Elite PvP Gear)
	--1416,	-- Coins of Air
	--1506,	-- Argus Waystone
	--1508,	-- Veiled Argunite
	--1533,	-- Wakening Essence
	
	-- BfA
	1560, 	-- War Resources
	1565,	-- Rich Azerite Fragment
	1580,	-- Seal of Wartorn Fate
	1587,	-- War Supplies
	1710,	-- Seafarer's Dubloon

}

-----------------------
-- Tooltip functions --
-----------------------

-- Dungeon coords
local function GetDungeonCoords(zone)
	local z, x, y = "", 0, 0
	local dcoords
	
	if LT:IsInstance(zone) then
		z, x, y = LT:GetEntrancePortalLocation(zone)
	end
	
	if z == nil then
		dcoords = ""
	elseif E.db.KlixUI.locPanel.tooltip.ttcoords then
		x = T.tonumber(E:Round(x*100, 0))
		y = T.tonumber(E:Round(y*100, 0))
		dcoords = T.string_format(" |cffffffff(%d, %d)|r", x, y)
	else 
		dcoords = ""
	end

	return dcoords
end

-- PvP/Raid filter
 local function PvPorRaidFilter(zone)
	local isPvP, isRaid

	isPvP = nil
	isRaid = nil

	if(LT:IsArena(zone) or LT:IsBattleground(zone)) then
		if E.db.KlixUI.locPanel.tooltip.tthidepvp then
			return
		end
		isPvP = true
	end

	if(not isPvP and LT:GetInstanceGroupSize(zone) >= 10) then
		if E.db.KlixUI.locPanel.tooltip.tthideraid then
			return
		end
		isRaid = true
	end

	return (isPvP and "|cffff0000 "..PVP.."|r" or "")..(isRaid and "|cffff4400 "..RAID.."|r" or "")
end

-- Recommended zones
local function GetRecomZones(zone)
	local low, high = LT:GetLevel(zone)
	local r, g, b = LT:GetLevelColor(zone)
	local zContinent = LT:GetContinent(zone)

	if PvPorRaidFilter(zone) == nil then return end

	GameTooltip:AddDoubleLine(
	"|cffffffff"..zone
	..PvPorRaidFilter(zone) or "",
	T.string_format("|cff%02xff00%s|r", continent == zContinent and 0 or 255, zContinent)
	..(" |cff%02x%02x%02x%s|r"):format(r *255, g *255, b *255,(low == high and low or ("%d-%d"):format(low, high))))
end

-- Dungeons in the zone
local function GetZoneDungeons(dungeon)
	local low, high = LT:GetLevel(dungeon)
	local r, g, b = LT:GetLevelColor(dungeon)
	local groupSize = LT:GetInstanceGroupSize(dungeon)
	local altGroupSize = LT:GetInstanceAltGroupSize(dungeon)
	local groupSizeStyle = (groupSize > 0 and T.string_format("|cFFFFFF00|r (%d", groupSize) or "")
	local altGroupSizeStyle = (altGroupSize > 0 and T.string_format("|cFFFFFF00|r/%d", altGroupSize) or "")
	local name = dungeon

	if PvPorRaidFilter(dungeon) == nil then return end

	GameTooltip:AddDoubleLine(
	"|cffffffff"..name
	..(groupSizeStyle or "")
	..(altGroupSizeStyle or "").."-"..PLAYER..") "
	..GetDungeonCoords(dungeon)
	..PvPorRaidFilter(dungeon) or "",
	("|cff%02x%02x%02x%s|r"):format(r *255, g *255, b *255,(low == high and low or ("%d-%d"):format(low, high))))
end

-- Recommended Dungeons
local function GetRecomDungeons(dungeon)
	local low, high = LT:GetLevel(dungeon)
	local r, g, b = LT:GetLevelColor(dungeon)
	local instZone = LT:GetInstanceZone(dungeon)
	local name = dungeon

	if PvPorRaidFilter(dungeon) == nil then return end

	if instZone == nil then
		instZone = ""
	else
		instZone = "|cFFFFA500 ("..instZone..")"
	end

	GameTooltip:AddDoubleLine(
	"|cffffffff"..name
	..instZone
	..GetDungeonCoords(dungeon)
	..PvPorRaidFilter(dungeon) or "",
	("|cff%02x%02x%02x%s|r"):format(r *255, g *255, b *255,(low == high and low or ("%d-%d"):format(low, high))))
end

-- Status
function LP:GetStatus(color)
	local status = ""
	local statusText
	local r, g, b = 1, 1, 0
	local pvpType = T.GetZonePVPInfo()
	local inInstance, _ = T.IsInInstance()

	if (pvpType == "sanctuary") then
		status = SANCTUARY_TERRITORY
		r, g, b = 0.41, 0.8, 0.94
	elseif(pvpType == "arena") then
		status = ARENA
		r, g, b = 1, 0.1, 0.1
	elseif(pvpType == "friendly") then
		status = FRIENDLY
		r, g, b = 0.1, 1, 0.1
	elseif(pvpType == "hostile") then
		status = HOSTILE
		r, g, b = 1, 0.1, 0.1
	elseif(pvpType == "contested") then
		status = CONTESTED_TERRITORY
		r, g, b = 1, 0.7, 0.10
	elseif(pvpType == "combat" ) then
		status = COMBAT
		r, g, b = 1, 0.1, 0.1
	elseif inInstance then
		status = AGGRO_WARNING_IN_INSTANCE
		r, g, b = 1, 0.1, 0.1
	else
		status = CONTESTED_TERRITORY
	end

	statusText = T.string_format("|cff%02x%02x%02x%s|r", r*255, g*255, b*255, status)

	if color then
		return r, g, b
	else
		return statusText
	end
end

-- Get Fishing Level
function LP:GetFishingLvl(minFish, ontt)
		local mapID = T.C_Map_GetBestMapForUnit("player")
	local zoneText = LT:GetMapNameByIDAlt(mapID) or UNKNOWN
	local uniqueZone = LT:GetUniqueZoneNameForLookup(zoneText, continentID)
	local minFish = LT:GetFishingLevel(uniqueZone)
	local _, _, _, fishing = T.GetProfessions()
	local r, g, b = 1, 0, 0
	local r1, g1, b1 = 1, 0, 0
	local dfish
	
	if minFish then
		if fishing ~= nil then
			local _, _, rank = T.GetProfessionInfo(fishing)
			if minFish < rank then
				r, g, b = 0, 1, 0
				r1, g1, b1 = 0, 1, 0
			elseif minFish == rank then
				r, g, b = 1, 1, 0
				r1, g1, b1 = 1, 1, 0
			end
		end
		
		dfish = T.string_format("|cff%02x%02x%02x%d|r", r*255, g*255, b*255, minFish)
		if ontt then
			return dfish
		else
			if E.db.KlixUI.locPanel.showicon then
				return T.string_format(" (%s) ", dfish)..FISH_ICON
			else
				return T.string_format(" (%s) ", dfish)
			end
		end
	else
		return ""
	end
end

-- Zone level range
function LP:GetLevelRange(zoneText, ontt)
	local mapID = T.C_Map_GetBestMapForUnit("player")
	local zoneText = LT:GetMapNameByIDAlt(mapID) or UNKNOWN
	local low, high = LT:GetLevel(zoneText)
	local dlevel
	if low > 0 and high > 0 then
		local r, g, b = LT:GetLevelColor(zoneText)
		if low ~= high then
			dlevel = T.string_format("|cff%02x%02x%02x%d-%d|r", r*255, g*255, b*255, low, high) or ""
		else
			dlevel = T.string_format("|cff%02x%02x%02x%d|r", r*255, g*255, b*255, high) or ""
		end

		if ontt then
			return dlevel
		else
			if E.db.KlixUI.locPanel.showicon then
				dlevel = T.string_format(" (%s) ", dlevel)..LEVEL_ICON
			else
				dlevel = T.string_format(" (%s) ", dlevel)
			end
		end
	end

	return dlevel or ""
end

-- PetBattle Range
function LP:GetBattlePetLvl(zoneText, ontt)
	local mapID = T.C_Map_GetBestMapForUnit("player")
	local zoneText = LT:GetMapNameByIDAlt(mapID) or UNKNOWN
	local uniqueZone = LT:GetUniqueZoneNameForLookup(zoneText, continentID)
	local low,high = LT:GetBattlePetLevel(uniqueZone)
	local plevel
	if low ~= nil or high ~= nil then
		if low ~= high then
			plevel = T.string_format("%d-%d", low, high)
		else
			plevel = T.string_format("%d", high)
		end

		if ontt then
			return plevel
		else
			if E.db.KlixUI.locPanel.showicon then
				plevel = T.string_format(" (%s) ", plevel)..PET_ICON
			else
				plevel = T.string_format(" (%s) ", plevel)
			end
		end
	end

	return plevel or ""
end

function LP:UpdateTooltip()
	local mapID = T.C_Map_GetBestMapForUnit("player")
	local zoneText = LT:GetMapNameByIDAlt(mapID) or UNKNOWN
	local curPos = (zoneText.." ") or ""

	GameTooltip:ClearLines()

	-- Zone
	GameTooltip:AddDoubleLine(L["Zone : "], zoneText, 1, 1, 1, selectioncolor)

	-- Continent
	GameTooltip:AddDoubleLine(CONTINENT.." : ", LT:GetContinent(zoneText), 1, 1, 1, selectioncolor)

	-- Home
	GameTooltip:AddDoubleLine(HOME.." :", T.GetBindLocation(), 1, 1, 1, 0.41, 0.8, 0.94)

	-- Status
	if E.db.KlixUI.locPanel.tooltip.ttst then
		GameTooltip:AddDoubleLine(STATUS.." :", LP:GetStatus(false), 1, 1, 1)
	end

    -- Zone level range
	if E.db.KlixUI.locPanel.tooltip.ttlvl then
		local checklvl = LP:GetLevelRange(zoneText, true)
		if checklvl ~= "" then
			GameTooltip:AddDoubleLine(LEVEL_RANGE.." : ", checklvl, 1, 1, 1)
		end
	end

	-- Fishing
	if E.db.KlixUI.locPanel.tooltip.fish then
		local checkfish = LP:GetFishingLvl(true, true)
		if checkfish ~= "" then
			GameTooltip:AddDoubleLine(PROFESSIONS_FISHING.." : ", checkfish, 1, 1, 1)
		end
	end

	-- Battle Pet Levels
	if E.db.KlixUI.locPanel.tooltip.petlevel then
		local checkbpet = LP:GetBattlePetLvl(zoneText, true)
		if checkbpet ~= "" then
			GameTooltip:AddDoubleLine(L["Battle Pet level"].. " :", checkbpet, 1, 1, 1, selectioncolor)
		end
	end

	-- Recommended zones
	if E.db.KlixUI.locPanel.tooltip.ttreczones then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L["Recommended Zones :"], selectioncolor)
	
		for zone in LT:IterateRecommendedZones() do
			GetRecomZones(zone)
		end
	end

	-- Instances in the zone
	if E.db.KlixUI.locPanel.tooltip.ttinst and LT:DoesZoneHaveInstances(zoneText) then 
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(curPos..DUNGEONS.." :", selectioncolor)
			
		for dungeon in LT:IterateZoneInstances(zoneText) do
			GetZoneDungeons(dungeon)
		end	
	end

	-- Recommended Instances
	local level = T.UnitLevel('player')
	if E.db.KlixUI.locPanel.tooltip.ttrecinst and LT:HasRecommendedInstances() and level >= 15 then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L["Recommended Dungeons :"], selectioncolor)
			
		for dungeon in LT:IterateRecommendedInstances() do
			GetRecomDungeons(dungeon)
		end
	end

	-- Currency
	local numEntries = T.GetCurrencyListSize() -- Check for entries to disable the tooltip title when no currency
	if E.db.KlixUI.locPanel.tooltip.curr and numEntries > 3 then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(TOKENS.." :", selectioncolor)

		for _, id in pairs(currency) do
			local name, amount, icon, _, _, totalMax = T.GetCurrencyInfo(id)

			if(name and amount > 0) then
				icon = ("|T%s:12:12:1:0|t"):format(icon)
				if totalMax == 0 then
					GameTooltip:AddDoubleLine(icon..T.string_format(" %s : ", name), T.string_format("%s", amount ), 1, 1, 1, selectioncolor)
				else
					GameTooltip:AddDoubleLine(icon..T.string_format(" %s : ", name), T.string_format("%s / %s", amount, totalMax ), 1, 1, 1, selectioncolor)
				end
			end
		end
	end

	-- Professions
	local prof1, prof2, archy, fishing, cooking, firstAid = T.GetProfessions()
	if E.db.KlixUI.locPanel.tooltip.prof and (prof1 or prof2 or archy or fishing or cooking or firstAid) then	
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(TRADE_SKILLS.." :", selectioncolor)
		
		local proftable = { T.GetProfessions() }
		for _, id in T.pairs(proftable) do
			local name, icon, rank, maxRank, _, _, _, rankModifier = T.GetProfessionInfo(id)

			if rank < maxRank or (not E.db.KlixUI.locPanel.tooltip.profcap) then
				icon = ("|T%s:12:12:1:0|t"):format(icon)
				if (rankModifier and rankModifier > 0) then
					GameTooltip:AddDoubleLine(T.string_format("%s %s :", icon, name), (T.string_format("%s |cFF6b8df4+ %s|r / %s", rank, rankModifier, maxRank)), 1, 1, 1, selectioncolor)				
				else
					GameTooltip:AddDoubleLine(T.string_format("%s %s :", icon, name), (T.string_format("%s / %s", rank, maxRank)), 1, 1, 1, selectioncolor)
				end
			end
		end
	end

	-- Hints
	if E.db.KlixUI.locPanel.tooltip.tt then
		if E.db.KlixUI.locPanel.tooltip.tthint then
			GameTooltip:AddLine(" ")
			GameTooltip:AddDoubleLine(L["Left Click: "], L["Toggle WorldMap"], 0.7, 0.7, 1, 0.7, 0.7, 1)
			GameTooltip:AddDoubleLine(L["Right Click: "], L["Toggle Relocating Menu"],0.7, 0.7, 1, 0.7, 0.7, 1)
			GameTooltip:AddDoubleLine(L["Shift + Click: "], L["Send position to chat"],0.7, 0.7, 1, 0.7, 0.7, 1)
			GameTooltip:AddDoubleLine(L["Control + Click: "], L["Toggle Datatexts"],0.7, 0.7, 1, 0.7, 0.7, 1)
		end
		GameTooltip:Show()
	else
		GameTooltip:Hide()
	end
end