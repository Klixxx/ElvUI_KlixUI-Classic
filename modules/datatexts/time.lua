local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule('DataTexts')

local VOICE_CHAT_BATTLEGROUND = VOICE_CHAT_BATTLEGROUND
local WINTERGRASP_IN_PROGRESS = WINTERGRASP_IN_PROGRESS
local QUEUE_TIME_UNAVAILABLE = QUEUE_TIME_UNAVAILABLE
local TIMEMANAGER_TOOLTIP_REALMTIME = TIMEMANAGER_TOOLTIP_REALMTIME
local TIMEMANAGER_TOOLTIP_LOCALTIME = TIMEMANAGER_TOOLTIP_LOCALTIME
local TIME_PLAYED_MSG = TIME_PLAYED_MSG
local LEVEL = LEVEL
local TOTAL = TOTAL
local MAX_PLAYER_LEVEL = MAX_PLAYER_LEVEL
local RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS

local PlayedTimeFormatFull = "%d "..L["D"].." %02d:%02d:%02d"
local PlayedTimeFormatNoDay = "%02d:%02d:%02d"
local TotalPlayTime, LevelPlayTime, SessionPlayTime, LevelPlayedOffset, LastLevelTime
local MyRealm = E.myrealm
local MyName = E.myname
local MyClass = E.myclass
local LevelPlayTimeOffset
local eventRequesting = false
local WORLD_BOSSES_TEXT = RAID_INFO_WORLD_BOSS.."(s)"
local APM = { TIMEMANAGER_PM, TIMEMANAGER_AM }
local europeDisplayFormat = '';
local ukDisplayFormat = '';
local europeDisplayFormat_nocolor = T.string_join("", "%02d", ":|r%02d")
local ukDisplayFormat_nocolor = T.string_join("", "", "%d", ":|r%02d", " %s|r")
local lockoutInfoFormat = "%s%s %s |cffaaaaaa(%s, %s/%s)"
local lockoutInfoFormatNoEnc = "%s%s %s |cffaaaaaa(%s)"
local formatBattleGroundInfo = "%s: "
local lockoutColorExtended, lockoutColorNormal = { r=0.3,g=1,b=0.3 }, { r=.8,g=.8,b=.8 }
local curHr, curMin, curAmPm
local enteredFrame = false;

local Update, lastPanel; -- UpValue

local function ValueColorUpdate(hex)
	europeDisplayFormat = T.string_join("", "%02d", hex, ":|r%02d")
	ukDisplayFormat = T.string_join("", "", "%d", hex, ":|r%02d", hex, " %s|r")

	if lastPanel ~= nil then
		Update(lastPanel, 20000)
	end
end
E['valueColorUpdateFuncs'][ValueColorUpdate] = true

local function ConvertTime(h, m)
	local AmPm
	if E.db.datatexts.time24 == true then
		return h, m, -1
	else
		if h >= 12 then
			if h > 12 then h = h - 12 end
			AmPm = 1
		else
			if h == 0 then h = 12 end
			AmPm = 2
		end
	end
	return h, m, AmPm
end

local function CalculateTimeValues(tooltip)
	if (tooltip and E.db.datatexts.localtime) or (not tooltip and not E.db.datatexts.localtime) then
		return ConvertTime(T.GetGameTime())
	else
		local dateTable = T.date("*t")
		return ConvertTime(dateTable["hour"], dateTable["min"])
	end
end

local function OnLeave()
	DT.tooltip:Hide();
	enteredFrame = false;
end

-- use these to convert "The Eye" into "Tempest Keep"
local DUNGEON_FLOOR_TEMPESTKEEP1 = DUNGEON_FLOOR_TEMPESTKEEP1
local TempestKeep = T.select(2, T.GetAchievementInfo(1088)):match('%((.-)%)$')

local instanceIconByName = {}
local function GetInstanceImages(index, raid)
	local instanceID, name, _, _, buttonImage = T.EJ_GetInstanceByIndex(index, raid);
	while instanceID do
		if name == DUNGEON_FLOOR_TEMPESTKEEP1 then
			instanceIconByName[TempestKeep] = buttonImage
		else
			instanceIconByName[name] = buttonImage
		end
		index = index + 1
		instanceID, name, _, _, buttonImage = T.EJ_GetInstanceByIndex(index, raid);
	end
end

local locale = T.GetLocale()
local krcntw = locale == "koKR" or locale == "zhCN" or locale == "zhTW"
local difficultyTag = { -- Raid Finder, Normal, Heroic, Mythic
	(krcntw and PLAYER_DIFFICULTY3) or T.string_utf8sub(PLAYER_DIFFICULTY3, 1, 1), -- R
	(krcntw and PLAYER_DIFFICULTY1) or T.string_utf8sub(PLAYER_DIFFICULTY1, 1, 1), -- N
	(krcntw and PLAYER_DIFFICULTY2) or T.string_utf8sub(PLAYER_DIFFICULTY2, 1, 1), -- H
	(krcntw and PLAYER_DIFFICULTY6) or T.string_utf8sub(PLAYER_DIFFICULTY6, 1, 1)  -- M
}

-- Invasion Code -- 
local region = T.GetCVar("portal")
if not region or #region ~= 2 then
    local regionID = T.GetCurrentRegion()
    region = regionID and ({ "US", "KR", "EU", "TW", "CN" })[regionID]
end

-- Invasion code from NDui by siwei
-- https://github.com/siweia/NDui/blob/master/Interface/AddOns/NDui/Modules/Infobar/Time.lua
-- Modified by Rhythm
-- Check Invasion Status
local invIndex = {
    {
        title = L["Faction Assault:"], -- BfA Invasions
        interval = 68400,
        duration = 25200,
        maps = {862, 863, 864, 896, 942, 895},
        timeTable = {4, 1, 6, 2, 5, 3},
        -- Drustvar Beginning
        baseTime = {
            US = 1548032400, -- 01/20/2019 17:00 UTC-8
            EU = 1548000000, -- 01/20/2019 16:00 UTC+0
            CN = 1546743600, -- 01/06/2019 11:00 UTC+8
        },
    },
    {
        title = L["Legion Invasion:"], -- Legion Invasions
        interval = 66600,
        duration = 21600,
        maps = {630, 641, 650, 634},
        timeTable = {4, 3, 2, 1, 4, 2, 3, 1, 2, 4, 1, 3},
        -- Stormheim Beginning then Highmountain
        baseTime = {
            US = 1547614800, -- 01/15/2019 21:00 UTC-8
            EU = 1547586000, -- 01/15/2019 21:00 UTC+0
            CN = 1546844400, -- 01/07/2019 15:00 UTC+8
        },
    }
}

local function GetCurrentInvasion(index)
    local inv = invIndex[index]
    local currentTime = T.time()
    local baseTime = inv.baseTime[region]
    local duration = inv.duration
    local interval = inv.interval
    local elapsed = T.mod(currentTime - baseTime, interval)
    if elapsed < duration then
        local count = #inv.timeTable
        local round = T.mod(T.math_floor((currentTime - baseTime) / interval) + 1, count)
        if round == 0 then round = count end
        return duration - elapsed, T.C_Map_GetMapInfo(inv.maps[inv.timeTable[round]]).name
    end
end

local function GetFutureInvasion(index, length)
    if not length then length = 1 end
    local tbl, i = {}
    local inv = invIndex[index]
    local currentTime = T.time()
    local baseTime = inv.baseTime[region]
    local interval = inv.interval
    local count = #inv.timeTable
    local elapsed = T.mod(currentTime - baseTime, interval)
    local nextTime = interval - elapsed + currentTime
    local round = T.mod(T.math_floor((nextTime - baseTime) / interval) + 1, count)
    for i = 1, length do
        if round == 0 then round = count end
		T.table_insert(tbl, {nextTime, T.C_Map_GetMapInfo(inv.maps[inv.timeTable[round]]).name})
        nextTime = nextTime + interval
        round = T.mod(round + 1, count)
    end
    return tbl
end

-- Fallback
local mapAreaPoiIDs = {
	[630] = 5175,
	[641] = 5210,
	[650] = 5177,
	[634] = 5178,
	[862] = 5973,
	[863] = 5969,
	[864] = 5970,
	[896] = 5964,
	[942] = 5966,
	[895] = 5896,
}

local function GetInvasionInfo(mapID)
	local areaPoiID = mapAreaPoiIDs[mapID]
	local seconds = T.C_AreaPoiInfo_GetAreaPOISecondsLeft(areaPoiID)
	local mapInfo = T.C_Map_GetMapInfo(mapID)
	return seconds, mapInfo.name
end

local function CheckInvasion(index)
	for _, mapID in T.pairs(invIndex[index].maps) do
		local timeLeft, name = T.GetInvasionInfo(mapID)
		if timeLeft and timeLeft > 0 then
			return timeLeft, name
		end
	end
end

local collectedInstanceImages = false
local function OnEnter(self)
	DT:SetupTooltip(self)

	if(not enteredFrame) then
		enteredFrame = true;
		T.RequestRaidInfo()
	end

	if not collectedInstanceImages then
		local numTiers = (T.EJ_GetNumTiers() or 0)
		if numTiers > 0 then
			local currentTier = T.EJ_GetCurrentTier()

			-- Loop through the expansions to collect the textures
			for i=1, numTiers do
				T.EJ_SelectTier(i);
				GetInstanceImages(1, false); -- Populate for dungeon icons
				GetInstanceImages(1, true); -- Populate for raid icons
			end

			-- Set it back to the previous tier
			if currentTier then
				T.EJ_SelectTier(currentTier);
			end

			collectedInstanceImages = true
		end
	end

	local addedHeader = false
	local localizedName, isActive, startTime, canEnter, _

	for i = 1, T.GetNumWorldPVPAreas() do
		_, localizedName, isActive, _, startTime, canEnter = T.GetWorldPVPAreaInfo(i)
		if canEnter then
			if not addedHeader then
				DT.tooltip:AddLine(VOICE_CHAT_BATTLEGROUND)
				addedHeader = true
			end
			if isActive then
				startTime = WINTERGRASP_IN_PROGRESS
			elseif startTime == nil then
				startTime = QUEUE_TIME_UNAVAILABLE
			else
				startTime = T.SecondsToTime(startTime, false, nil, 3)
			end
			DT.tooltip:AddDoubleLine(T.string_format(formatBattleGroundInfo, localizedName), startTime, 1, 1, 1, lockoutColorNormal.r, lockoutColorNormal.g, lockoutColorNormal.b)
		end
	end

	local lockedInstances = {raids = {}, dungeons = {}}
	local name, difficulty, locked, extended, isRaid
	local isLFR, isHeroicOrMythicDungeon, isHeroic, displayHeroic, displayMythic, sortName, difficultyLetter, buttonImg

	for i = 1, T.GetNumSavedInstances() do
		name, _, _, difficulty, locked, extended, _, isRaid = T.GetSavedInstanceInfo(i);
		if (locked or extended) and name then
			isLFR, isHeroicOrMythicDungeon = (difficulty == 7 or difficulty == 17), (difficulty == 2 or difficulty == 23)
			_, _, isHeroic, _, displayHeroic, displayMythic = T.GetDifficultyInfo(difficulty)
			sortName = name .. (displayMythic and 4 or (isHeroic or displayHeroic) and 3 or isLFR and 1 or 2)
			difficultyLetter = (displayMythic and difficultyTag[4] or (isHeroic or displayHeroic) and difficultyTag[3] or isLFR and difficultyTag[1] or difficultyTag[2])
			buttonImg = instanceIconByName[name] and T.string_format("|T%s:16:16:0:0:96:96:0:64:0:64|t ", instanceIconByName[name]) or ""

			if isRaid then
				T.table_insert(lockedInstances["raids"], {sortName, difficultyLetter, buttonImg, {T.GetSavedInstanceInfo(i)}})
			elseif isHeroicOrMythicDungeon then
				T.table_insert(lockedInstances["dungeons"], {sortName, difficultyLetter, buttonImg, {T.GetSavedInstanceInfo(i)}})
			end
		end
	end

	local reset, maxPlayers, numEncounters, encounterProgress, lockoutColor
	if T.next(lockedInstances["raids"]) then
		if DT.tooltip:NumLines() > 0 then
			DT.tooltip:AddLine(" ")
		end
		DT.tooltip:AddLine(L["Saved Raid(s)"])

		T.table_sort(lockedInstances["raids"], function( a,b ) return a[1] < b[1] end)

		for i = 1, #lockedInstances["raids"] do
			difficultyLetter = lockedInstances["raids"][i][2]
			buttonImg = lockedInstances["raids"][i][3]
			name, _, reset, _, _, extended, _, _, maxPlayers, _, numEncounters, encounterProgress = T.unpack(lockedInstances["raids"][i][4])

			lockoutColor = extended and lockoutColorExtended or lockoutColorNormal
			if (numEncounters and numEncounters > 0) and (encounterProgress and encounterProgress > 0) then
				DT.tooltip:AddDoubleLine(T.string_format(lockoutInfoFormat, buttonImg, maxPlayers, difficultyLetter, name, encounterProgress, numEncounters), T.SecondsToTime(reset, false, nil, 3), 1, 1, 1, lockoutColor.r, lockoutColor.g, lockoutColor.b)
			else
				DT.tooltip:AddDoubleLine(T.string_format(lockoutInfoFormatNoEnc, buttonImg, maxPlayers, difficultyLetter, name), T.SecondsToTime(reset, false, nil, 3), 1, 1, 1, lockoutColor.r, lockoutColor.g, lockoutColor.b)
			end
		end
	end

	if next(lockedInstances["dungeons"]) then
		if DT.tooltip:NumLines() > 0 then
			DT.tooltip:AddLine(" ")
		end
		DT.tooltip:AddLine(L["Saved Dungeon(s)"])

		T.table_sort(lockedInstances["dungeons"], function( a,b ) return a[1] < b[1] end)

		for i = 1,#lockedInstances["dungeons"] do
			difficultyLetter = lockedInstances["dungeons"][i][2]
			buttonImg = lockedInstances["dungeons"][i][3]
			name, _, reset, _, _, extended, _, _, maxPlayers, _, numEncounters, encounterProgress = unpack(lockedInstances["dungeons"][i][4])

			lockoutColor = extended and lockoutColorExtended or lockoutColorNormal
			if (numEncounters and numEncounters > 0) and (encounterProgress and encounterProgress > 0) then
				DT.tooltip:AddDoubleLine(T.string_format(lockoutInfoFormat, buttonImg, maxPlayers, difficultyLetter, name, encounterProgress, numEncounters), T.SecondsToTime(reset, false, nil, 3), 1, 1, 1, lockoutColor.r, lockoutColor.g, lockoutColor.b)
			else
				DT.tooltip:AddDoubleLine(T.string_format(lockoutInfoFormatNoEnc, buttonImg, maxPlayers, difficultyLetter, name), T.SecondsToTime(reset, false, nil, 3), 1, 1, 1, lockoutColor.r, lockoutColor.g, lockoutColor.b)
			end
		end
	end

	local addedLine = false
	local worldbossLockoutList = {}
	for i = 1, T.GetNumSavedWorldBosses() do
		name, _, reset = T.GetSavedWorldBossInfo(i)
		T.table_insert(worldbossLockoutList, {name, reset})
	end
	T.table_sort(worldbossLockoutList, function( a,b ) return a[1] < b[1] end)
	for i = 1,#worldbossLockoutList do
		name, reset = T.unpack(worldbossLockoutList[i])
		if(reset) then
			if(not addedLine) then
				if DT.tooltip:NumLines() > 0 then
					DT.tooltip:AddLine(" ")
				end
				DT.tooltip:AddLine(WORLD_BOSSES_TEXT)
				addedLine = true
			end
			DT.tooltip:AddDoubleLine(name, T.SecondsToTime(reset, true, nil, 3), 1, 1, 1, 0.8, 0.8, 0.8)
		end
	end

	local Hr, Min, AmPm = CalculateTimeValues(true)
	if DT.tooltip:NumLines() > 0 then
		DT.tooltip:AddLine(" ")
	end
	if AmPm == -1 then
		DT.tooltip:AddDoubleLine(E.db.datatexts.localtime and TIMEMANAGER_TOOLTIP_REALMTIME or TIMEMANAGER_TOOLTIP_LOCALTIME,
			T.string_format(europeDisplayFormat_nocolor, Hr, Min), 1, .8, .1, 1, 1, 1)
	else
		DT.tooltip:AddDoubleLine(E.db.datatexts.localtime and TIMEMANAGER_TOOLTIP_REALMTIME or TIMEMANAGER_TOOLTIP_LOCALTIME,
			T.string_format(ukDisplayFormat_nocolor, Hr, Min, APM[AmPm]), 1, .8, .1, 1, 1, 1)
	end

	local monthAbr = {
		[1] = L["Jan"],
		[2] = L["Feb"],
		[3] = L["Mar"],
		[4] = L["Apr"],
		[5] = L["May"],
		[6] = L["Jun"],
		[7] = L["Jul"],
		[8] = L["Aug"],
		[9] = L["Sep"],
		[10] = L["Oct"],
		[11] = L["Nov"],
		[12] = L["Dec"],
	}

	local daysAbr = {
		[1] = L["Sun"],
		[2] = L["Mon"],
		[3] = L["Tue"],
		[4] = L["Wed"],
		[5] = L["Thu"],
		[6] = L["Fri"],
		[7] = L["Sat"],
	}

	DT.tooltip:AddLine(" ")
	local today = T.C_DateAndTime_GetCurrentCalendarTime();
	local presentWeekday = today.weekday;
	local presentMonth = today.month;
	local presentDay = today.monthDay;
	local presentYear = today.year;
	if E.db.KlixUI.timeDT.date then
		DT.tooltip:AddLine(T.string_format("%s, %s %d, %d", daysAbr[presentWeekday], monthAbr[presentMonth], presentDay, presentYear))
	else
		DT.tooltip:AddLine(T.string_format(FULLDATE, _G.CALENDAR_WEEKDAY_NAMES[presentWeekday], _G.CALENDAR_FULLDATE_MONTH_NAMES[presentMonth], presentDay, presentYear))
	end
	
	-- Invasions
	if E.db.KlixUI.timeDT.invasions then
		DT.tooltip:AddLine(" ")
		for index, value in T.ipairs(invIndex) do
			DT.tooltip:AddLine(value.title)
			if value.baseTime[region] then
				-- baseTime provided
				local timeLeft, zoneName = GetCurrentInvasion(index)
				if timeLeft then
					timeLeft = timeLeft / 60
					if timeLeft < 60 then r,g,b = 1,0,0 else r,g,b = 0,1,0 end
					DT.tooltip:AddDoubleLine(L["Current: "] .. zoneName, T.string_format("%dh %.2dm", timeLeft / 60, timeLeft % 60), 1, 1, 1, r, g, b)
				end
				local futureTable, i = GetFutureInvasion(index, 2)
				for i = 1, #futureTable do
					local nextTime, zoneName = T.unpack(futureTable[i])
					DT.tooltip:AddDoubleLine(L["Next: "] .. zoneName, T.date("%d/%m - %H:%M", nextTime), 1, 1, 1)
				end
			else
				local timeLeft, zoneName = CheckInvasion(index)
				if timeLeft then
					timeLeft = timeLeft / 60
					if timeLeft < 60 then r,g,b = 1,0,0 else r,g,b = 0,1,0 end
					DT.tooltip:AddDoubleLine(L["Current: "] .. zoneName, T.string_format("%dh %.2dm", timeLeft / 60, timeLeft % 60), 1, 1, 1, r, g, b)
				else
					DT.tooltip:AddLine(L["Missing invasion info on your realm."])
				end
			end
			DT.tooltip:AddLine(" ")
		end
	else
		DT.tooltip:AddLine(" ")
	end
	
	-- Time Played
	if E.db.KlixUI.timeDT.played and SessionPlayTime then
		local SessionDay, SessionHour, SessionMinute, SessionSecond = T.ChatFrame_TimeBreakDown(T.GetTime() - SessionPlayTime)
		local TotalDay, TotalHour, TotalMinute, TotalSecond = T.ChatFrame_TimeBreakDown(TotalPlayTime + (T.GetTime() - SessionPlayTime))
		local LevelDay, LevelHour, LevelMinute, LevelSecond = T.ChatFrame_TimeBreakDown(LevelPlayTime + (T.GetTime() - LevelPlayTimeOffset))
		local LastLevelDay, LastLevelHour, LastLevelMinute, LastLevelSecond = T.ChatFrame_TimeBreakDown(LastLevelTime)
		DT.tooltip:AddLine(TIME_PLAYED_MSG..":")
		DT.tooltip:AddDoubleLine(L["Session:"], SessionDay > 0 and T.string_format(PlayedTimeFormatFull, SessionDay, SessionHour, SessionMinute, SessionSecond) or T.string_format(PlayedTimeFormatNoDay, SessionHour, SessionMinute, SessionSecond), 1, 1, 1, 1, 1, 1)
		if LastLevelSecond > 0 then
			DT.tooltip:AddDoubleLine(L["Previous Level:"], LastLevelDay > 0 and T.string_format(PlayedTimeFormatFull, LastLevelDay, LastLevelHour, LastLevelMinute, LastLevelSecond) or T.string_format(PlayedTimeFormatNoDay, LastLevelHour, LastLevelMinute, LastLevelSecond), 1, 1, 1, 1, 1, 1)
		end
		DT.tooltip:AddDoubleLine(LEVEL..":", LevelDay > 0 and T.string_format(PlayedTimeFormatFull, LevelDay, LevelHour, LevelMinute, LevelSecond) or T.string_format(PlayedTimeFormatNoDay, LevelHour, LevelMinute, LevelSecond), 1, 1, 1, 1, 1, 1)
		DT.tooltip:AddDoubleLine(TOTAL..":", TotalDay > 0 and T.string_format(PlayedTimeFormatFull, TotalDay, TotalHour, TotalMinute, TotalSecond) or T.string_format(PlayedTimeFormatNoDay, TotalHour, TotalMinute, TotalSecond), 1, 1, 1, 1, 1, 1)
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(L["Account Time Played:"])
		local Class, Level, AccountDay, AccountHour, AccountMinute, AccountSecond, TotalAccountTime
		for player, subtable in T.pairs(ElvDB["KlixUI"]["TimePlayed"][MyRealm]) do
			for k, v in T.pairs(subtable) do
				if k == "TotalTime" then
					AccountDay, AccountHour, AccountMinute, AccountSecond = T.ChatFrame_TimeBreakDown(v)
					TotalAccountTime = (TotalAccountTime or 0) + v
				end
				if k == "Class" then Class = v end
				if k == "Level" then Level = v end
			end
			local color = RAID_CLASS_COLORS[Class]
			DT.tooltip:AddDoubleLine( T.string_format("%s |cFFFFFFFF- %s %d", player, LEVEL, Level), T.string_format(PlayedTimeFormatFull, AccountDay, AccountHour, AccountMinute, AccountSecond), color.r, color.g, color.b, 1, 1, 1)
		end
		DT.tooltip:AddLine(" ")
		local TotalAccountDay, TotalAccountHour, TotalAccountMinute, TotalAccountSecond = T.ChatFrame_TimeBreakDown(TotalAccountTime)
		DT.tooltip:AddDoubleLine(TOTAL..":", T.string_format(PlayedTimeFormatFull, TotalAccountDay, TotalAccountHour, TotalAccountMinute, TotalAccountSecond), 0.98, 0.38, 0.85, 1, 1, 1)
		DT.tooltip:AddLine(" ")
	end
	
	if E.db.KlixUI.timeDT.invasions then
		DT.tooltip:AddDoubleLine(L["Left Click:"], L["Toggle Map & Quest Log frame"], 0.7, 0.7, 1.0)
	end 
	if E.db.KlixUI.timeDT.played then
		DT.tooltip:AddDoubleLine(L["Shift + Left Click:"], L["Reset account time played data"], 0.7, 0.7, 1.0)
	end
	DT.tooltip:AddDoubleLine(L["Right Click:"], L["Toggle Calendar frame"], 0.7, 0.7, 1.0)
	DT.tooltip:Show()
end

local function OnEvent(self, event, ...)
	if not ElvDB["KlixUI"] then ElvDB["KlixUI"] = {} end
	if not ElvDB["KlixUI"]["TimePlayed"] then ElvDB["KlixUI"]["TimePlayed"] = {} end
	if not ElvDB["KlixUI"]["TimePlayed"][MyRealm] then ElvDB["KlixUI"]["TimePlayed"][MyRealm] = {} end
	if not ElvDB["KlixUI"]["TimePlayed"][MyRealm][MyName] then ElvDB["KlixUI"]["TimePlayed"][MyRealm][MyName] = {} end
	ElvDB["KlixUI"]["TimePlayed"][MyRealm][MyName]["Class"] = MyClass
	ElvDB["KlixUI"]["TimePlayed"][MyRealm][MyName]["Level"] = T.UnitLevel("player")
	LastLevelTime = ElvDB["KlixUI"]["TimePlayed"][MyRealm][MyName]["LastLevelTime"] or 0
	if event == "TIME_PLAYED_MSG" then
		local TotalTime, LevelTime = ...
		TotalPlayTime = TotalTime
		LevelPlayTime = LevelTime
		if SessionPlayTime == nil then SessionPlayTime = T.GetTime() end
		LevelPlayTimeOffset = T.GetTime()
		ElvDB["KlixUI"]["TimePlayed"][MyRealm][MyName]["TotalTime"] = TotalTime
		ElvDB["KlixUI"]["TimePlayed"][MyRealm][MyName]["LevelTime"] = LevelTime
		eventRequesting = false
	end
	if event == "PLAYER_LEVEL_UP" then
		if not LevelPlayTime then
			eventRequesting = true
			T.RequestTimePlayed()
		else
			LastLevelTime = T.math_floor(LevelPlayTime + (T.GetTime() - (LevelPlayTimeOffset or 0)))
			ElvDB["KlixUI"]["TimePlayed"][MyRealm][MyName]["LastLevelTime"] = LastLevelTime
			LevelPlayTime = 1
			LevelPlayTimeOffset = T.GetTime()
			ElvDB["KlixUI"]["TimePlayed"][MyRealm][MyName]["Level"] = T.UnitLevel("player")
			eventRequesting = false
		end
	end
	if event == "LOADING_SCREEN_DISABLED" then
		self:UnregisterEvent(event)
		if not T.IsAddOnLoaded("DataStore_Characters") and not eventRequesting then
			eventRequesting = true
			T.RequestTimePlayed()
		end
	end
	if event == "PLAYER_LOGOUT" and not eventRequesting then
		eventRequesting = true
		T.RequestTimePlayed()
	end
	if event == "UPDATE_INSTANCE_INFO" and enteredFrame then
		OnEnter(self)
	end
end

local int = 3
function Update(self, t)
	self.db = E.db.datatexts
	int = int - t

	if int > 0 then return end

	if _G.GameTimeFrame.flashInvite then
		E:Flash(self, 0.53, true)
	else
		E:StopFlash(self)
	end

	if enteredFrame then
		OnEnter(self)
	end

	local Hr, Min, AmPm = CalculateTimeValues(false)

	-- no update quick exit
	if (Hr == curHr and Min == curMin and AmPm == curAmPm) and not (int < -15000) then
		int = 5
		return
	end

	curHr = Hr
	curMin = Min
	curAmPm = AmPm

	if AmPm == -1 then
		self.text:FontTemplate(nil, self.db.fontSize*E.db.KlixUI.timeDT.size, self.db.fontOutline)
		self.text:SetFormattedText(europeDisplayFormat, Hr, Min)
	else
		self.text:FontTemplate(nil, self.db.fontSize*E.db.KlixUI.timeDT.size, self.db.fontOutline)
		self.text:SetFormattedText(ukDisplayFormat, Hr, Min, APM[AmPm])
	end
	lastPanel = self
	int = 5
end

local oldTimePlayedFunction = ChatFrame_DisplayTimePlayed
ChatFrame_DisplayTimePlayed = function(...)
	if eventRequesting then
		eventRequesting = false
		return
	end
	return oldTimePlayedFunction(...)
end

local function Reset()
	ElvDB["KlixUI"]["TimePlayed"][MyRealm] = {}
	ElvDB["KlixUI"]["TimePlayed"][MyRealm][MyName] = {}
	ElvDB["KlixUI"]["TimePlayed"][MyRealm][MyName]["Level"] = T.UnitLevel("player")
	ElvDB["KlixUI"]["TimePlayed"][MyRealm][MyName]["LastLevelTime"] = LastLevelTime
	ElvDB["KlixUI"]["TimePlayed"][MyRealm][MyName]["Class"] = MyClass
	if not eventRequesting then
		eventRequesting = true
		T.RequestTimePlayed()
	end
	KUI:Print(L["Account Time Played data has been reset!"])
end

local function OnClick(_, button)
	if button == "LeftButton" then
		if T.IsShiftKeyDown() and E.db.KlixUI.timeDT.played then
			Reset()
		elseif E.db.KlixUI.timeDT.invasions then
			T.ToggleWorldMap()
		end
	elseif button == "RightButton" then
		_G.GameTimeFrame:Click()
	end
end

DT:RegisterDatatext("Time (KUI)", {"TIME_PLAYED_MSG", "PLAYER_LEVEL_UP", "LOADING_SCREEN_DISABLED", "PLAYER_LOGOUT", "UPDATE_INSTANCE_INFO"}, OnEvent, Update, OnClick, OnEnter, OnLeave)