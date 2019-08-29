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

local locale = T.GetLocale()
local krcntw = locale == "koKR" or locale == "zhCN" or locale == "zhTW"
local difficultyTag = { -- Raid Finder, Normal, Heroic, Mythic
	(krcntw and PLAYER_DIFFICULTY3) or T.string_utf8sub(PLAYER_DIFFICULTY3, 1, 1), -- R
	(krcntw and PLAYER_DIFFICULTY1) or T.string_utf8sub(PLAYER_DIFFICULTY1, 1, 1), -- N
	(krcntw and PLAYER_DIFFICULTY2) or T.string_utf8sub(PLAYER_DIFFICULTY2, 1, 1), -- H
	(krcntw and PLAYER_DIFFICULTY6) or T.string_utf8sub(PLAYER_DIFFICULTY6, 1, 1)  -- M
}

local collectedInstanceImages = false
local function OnEnter(self)
	DT:SetupTooltip(self)

	if(not enteredFrame) then
		enteredFrame = true
		T.RequestRaidInfo()
	end

	local addedHeader = false

	local lockedInstances = {raids = {}, dungeons = {}}

	for i = 1, T.GetNumSavedInstances() do
		local name, _, _, difficulty, locked, extended, _, isRaid = T.GetSavedInstanceInfo(i)
		if (locked or extended) and name then
			local isLFR, isHeroicOrMythicDungeon = (difficulty == 7 or difficulty == 17), (difficulty == 2 or difficulty == 23)
			local _, _, isHeroic, _, displayHeroic, displayMythic = T.GetDifficultyInfo(difficulty)
			local sortName = name .. (displayMythic and 4 or (isHeroic or displayHeroic) and 3 or isLFR and 1 or 2)
			local difficultyLetter = (displayMythic and difficultyTag[4] or (isHeroic or displayHeroic) and difficultyTag[3] or isLFR and difficultyTag[1] or difficultyTag[2])
			local buttonImg = instanceIconByName[name] and T.string_format("|T%s:16:16:0:0:96:96:0:64:0:64|t ", instanceIconByName[name]) or ""

			if isRaid then
				T.table_insert(lockedInstances.raids, {sortName, difficultyLetter, buttonImg, {T.GetSavedInstanceInfo(i)}})
			elseif isHeroicOrMythicDungeon then
				T.table_insert(lockedInstances.dungeons, {sortName, difficultyLetter, buttonImg, {T.GetSavedInstanceInfo(i)}})
			end
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
		DT.tooltip:AddDoubleLine(L["Left Click:"], L["Toggle World Map"], 0.7, 0.7, 1.0)
	end 
	if E.db.KlixUI.timeDT.played then
		DT.tooltip:AddDoubleLine(L["Shift + Left Click:"], L["Reset account time played data"], 0.7, 0.7, 1.0)
	end
	DT.tooltip:AddDoubleLine(L["Right Click:"], L["Toggle Quest Log"], 0.7, 0.7, 1.0)
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
		else
			ToggleQuestLog()
		end
	elseif button == "RightButton" then
		T.ToggleWorldMap()
	end
end

DT:RegisterDatatext("Time (KUI)", {"TIME_PLAYED_MSG", "PLAYER_LEVEL_UP", "LOADING_SCREEN_DISABLED", "PLAYER_LOGOUT", "UPDATE_INSTANCE_INFO"}, OnEvent, Update, OnClick, OnEnter, OnLeave)