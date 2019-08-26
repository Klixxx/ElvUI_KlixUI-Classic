local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local QAN = KUI:NewModule('QuestAnnouncement', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

local LE_PARTY_CATEGORY_HOME, LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_HOME, LE_PARTY_CATEGORY_INSTANCE
local ClientLocale = T.GetLocale()

local QN_Locale   = {
	["Colon"]       = ":",
	["Quest"]       = "Quest",
	["Progress"]    = "Progress",
	["Complete"]    = "Completed!", 
	["Accept"]      = "Accept Quest",
}
if ClientLocale == 'zhCN' then
	QN_Locale = {
		["Colon"]       = "：",
		["Quest"]       = "任务",
		["Progress"]    = "进度",
		["Complete"]    = "已完成!",
		["Accept"]      = "接受任务",
	}
elseif ClientLocale == 'zhTW' then
	QN_Locale = {
		["Colon"]       = ":",
		["Quest"]       = "任務",
		["Progress"]    = "進度",
		["Complete"]    = "已完成!",
		["Accept"]      = "接受任務",
	}
end

local QHisFirst = true
local lastList
local RGBStr = {
	R = "|CFFFF0000",
	G = "|CFF00FF00",
	B = "|CFF0000FF",
	Y = "|CFFFFFF00",
	K = "|CFF00FFFF",
	D = "|C0000AAFF",
	P = "|CFFD74DE1"
}

local function RScanQuests()
	local QuestList = {}
	local qIndex = 1
	local qLink
	local splitdot = QN_Locale["Colon"]
	while T.GetQuestLogTitle(qIndex) do
		local qTitle, qLevel, qGroup, qisHeader, qisCollapsed, qisComplete, frequency, qID = T.GetQuestLogTitle(qIndex)
		local qTag, qTagName = T.GetQuestTagInfo(qID)
		if not qisHeader then
			qLink = T.GetQuestLink(qID)
				QuestList[qID] = {
				Title    = qTitle,       -- String
				Level    = qLevel,       -- Integer
				Tag      = qTagName,         -- String
				Group    = qGroup,       -- Integer
				Header   = qisHeader,    -- boolean
				Collapsed= qisCollapsed, -- boolean
				Complete = qisComplete,  -- Integer
				Daily    = 0, --frequency,     -- Integer
				QuestID  = qID,          -- Integer
				Link     = qLink
			}
			if qisComplete == 1 and ( T.IsQuestWatched(qIndex) ) then
				T.RemoveQuestWatch(qIndex)
			--	WatchFrame_Update()
				T.ObjectiveTracker_Update()
			end
			for i = 1, T.GetNumQuestLeaderBoards(qIndex) do
				local leaderboardTxt, itemType, isDone = T.GetQuestLogLeaderBoard(i, qIndex);
			--	local j, k, itemName, numItems, numNeeded = T.string_find(leaderboardTxt, "(.*)"..splitdot.."%s*([%d]+)%s*/%s*([%d]+)");
				local _, _, numItems, numNeeded, itemName = T.string_find(leaderboardTxt, "(%d+)/(%d+) ?(.*)")
			--	local numstr, itemName = T.string_split(" ", leaderboardTxt)
			--	local numItems, numNeeded = T.string_split("/", numstr)
				-- T.print(qID, qTitle, qLevel, qTag, qGroup, qisHeader, qisCollapsed, qisComplete, qisDaily, leaderboardTxt, itemType, isDone, j, k, itemName, numItems, numNeeded)
				QuestList[qID][i] = {
					NeedItem = itemName,             -- String
					NeedNum  = numNeeded,            -- Integer
					DoneNum  = numItems             -- Integer
				}
			end
		end

		qIndex = qIndex + 1
	end
	return QuestList
end

local function PrtChatMsg(msg)
	if (not T.IsInGroup(LE_PARTY_CATEGORY_HOME) or T.IsInRaid(LE_PARTY_CATEGORY_HOME)) and T.IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		if E.db.KlixUI.quest.announce.instance then
			T.SendChatMessage(msg, "INSTANCE_CHAT", nil)
		end
	elseif T.UnitInRaid("player") then
		if E.db.KlixUI.quest.announce.raid then
			T.SendChatMessage(msg, "RAID", nil)
		end
	elseif T.UnitInParty("Party1") then
		if E.db.KlixUI.quest.announce.party then
			T.SendChatMessage(msg, "PARTY", nil)
		end
	else
		if E.db.KlixUI.quest.announce.solo then
			_G.ChatFrame1:AddMessage(msg)
		end
	end
end

local function isSuppliesQuest(title)
	if E.db.KlixUI.quest.announce.ignore_supplies then
		if ClientLocale == 'zhCN' then
			if T.string_find(title, "补给需求：") then return true end
			if T.string_find(title, "产品订单：") then return true end
		elseif ClientLocale == 'zhTW' then
			if T.string_find(title, "需要的補給品：") then return true end
			if T.string_find(title, "工作訂單：") then return true end
		elseif ClientLocale == 'enUS' then
			if T.string_find(title, "Supplies Needed:") then return true end
			if T.string_find(title, "Work Order:") then return true end
		end
	end

	return false
end

function QAN:Initialize()
	if not E.db.KlixUI.quest.announce.enable then return end
	
	local QN = T.CreateFrame("Frame")
	QN:RegisterEvent("QUEST_LOG_UPDATE")
	QN:SetScript("OnEvent", function(self, event)
		local QN_Progress = QN_Locale["Progress"]
		local QN_ItemMsg, QN_ItemColorMsg = " ", " "

		if QHisFirst then
			lastList = RScanQuests()
			QHisFirst = false
		end

		local currList = RScanQuests()

		for i, v in T.pairs(currList) do
			local TagStr = " ";
			if currList[i].Tag and (currList[i].Group < 2) then TagStr = RGBStr.Y .. "["..currList[i].Tag.."]|r" end
			if currList[i].Tag and (currList[i].Group > 1) then TagStr = RGBStr.Y .. "["..currList[i].Tag..currList[i].Group.."]|r" end
			if currList[i].Daily == 1 and currList[i].Tag then
				TagStr = RGBStr.D .. "[" .. DAILY .. currList[i].Tag .. "]|r" ;
			elseif currList[i].Daily == 1 then
				TagStr = RGBStr.D .. "[" .. DAILY .. "]|r";
			elseif currList[i].Tag then
				TagStr = "["..currList[i].Tag .. "]";
			end

			if lastList[i] then
				if not lastList[i].Complete then
					if (#currList[i] > 0) and (#lastList[i] > 0) then
						for j=1,#currList[i] do
							if currList[i][j] and lastList[i][j] and currList[i][j].DoneNum and lastList[i][j].DoneNum then
								if currList[i][j].DoneNum > lastList[i][j].DoneNum then
									--QN_ItemMsg = QN_Locale["Quest"]..currList[i].Link..QN_Progress ..": ".. currList[i][j].NeedItem ..":".. currList[i][j].DoneNum .. "/"..currList[i][j].NeedNum
									QN_ItemMsg = QN_Progress ..": " .. currList[i][j].NeedItem ..": ".. currList[i][j].DoneNum .. "/"..currList[i][j].NeedNum
									QN_ItemColorMsg = RGBStr.G..QN_Locale["Quest"].."|r ".. RGBStr.P .. "["..currList[i].Level.."]|r "..currList[i].Link..RGBStr.G..QN_Progress..": |r"..RGBStr.K..currList[i][j].NeedItem..":|r"..RGBStr.Y..currList[i][j].DoneNum .. "/"..currList[i][j].NeedNum .."|r"
									if not E.db.KlixUI.quest.announce.noDetail then
										PrtChatMsg(QN_ItemMsg)
									end
								end
							end
						end
					end
				end
				if (#currList[i] > 0) and (#lastList[i] > 0) and (currList[i].Complete == 1) then
					if not lastList[i].Complete then
						if (currList[i].Group > 1) and currList[i].Tag then
							QN_ItemMsg = QN_Locale["Quest"].." ["..currList[i].Level.."]".." ["..currList[i].Tag..currList[i].Group.."] "..currList[i].Link.." "..QN_Locale["Complete"]
						else
							QN_ItemMsg = QN_Locale["Quest"].." ["..currList[i].Level.."] "..currList[i].Link.." "..QN_Locale["Complete"]
						end
						QN_ItemColorMsg = RGBStr.G .. QN_Locale["Quest"] .. "|r" .. RGBStr.P .. " [" .. currList[i].Level .. "]|r " .. currList[i].Link .. TagStr .. RGBStr.K .. QN_Locale["Complete"] .. "|r"
						PrtChatMsg(QN_ItemMsg)
						_G.UIErrorsFrame:AddMessage(QN_ItemColorMsg);
					end
				end
			end

			if not lastList[i] and not isSuppliesQuest(currList[i].Title) then  -- last List have not the Quest, New Quest Accepted
				if (currList[i].Group > 1) and currList[i].Tag then
					QN_ItemMsg = QN_Locale["Accept"]..": ["..currList[i].Level.."]".." ["..currList[i].Tag..currList[i].Group.."] "..currList[i].Link
				elseif currList[i].Daily == 1 then
					QN_ItemMsg = QN_Locale["Accept"]..": ["..currList[i].Level.."]".." [" .. DAILY .. "]"..currList[i].Link
				else
					QN_ItemMsg = QN_Locale["Accept"]..": ["..currList[i].Level.."] "..currList[i].Link
				end
				QN_ItemColorMsg = RGBStr.K .. QN_Locale["Accept"]..":|r" .. RGBStr.P .." ["..currList[i].Level.."]|r "..TagStr..currList[i].Link
				PrtChatMsg(QN_ItemMsg)
			end
		end

		lastList = currList
	end)
end

local function InitializeCallback()
	QAN:Initialize()
end

KUI:RegisterModule(QAN:GetName(), InitializeCallback)
