-------------------------------------------------------------------------------
-- Credits: RealUI - Gethe, Nibelheim
-------------------------------------------------------------------------------
local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local NF = KUI:NewModule("Notification", "AceEvent-3.0", "AceHook-3.0")
local CH = E:GetModule("Chat")
local S = E:GetModule("Skins")

local SOCIAL_QUEUE_QUEUED_FOR = SOCIAL_QUEUE_QUEUED_FOR:gsub(':%s?$','') --some language have `:` on end

local max_active_toasts = 3
local fadeout_delay = 5
local toasts = {}
local activeToasts = {}
local queuedToasts = {}
local anchorFrame
local alertBagsFull
local shouldAlertBags = false

local VignetteExclusionMapIDs = {
	[579] = true, -- Lunarfall: Alliance garrison
	[585] = true, -- Frostwall: Horde garrison
	[646] = true, -- Scenario: The Broken Shore
}

function NF:SpawnToast(toast)
	if not toast then return end

	if #activeToasts >= max_active_toasts then
		T.table_insert(queuedToasts, toast)

		return false
	end

	if T.UnitIsAFK("player") then
		T.table_insert(queuedToasts, toast)
		self:RegisterEvent("PLAYER_FLAGS_CHANGED")

		return false
	end

	local YOffset = 0
	if E:GetScreenQuadrant(anchorFrame):find("TOP") then
		YOffset = -54
	else
		YOffset = 54
	end

	toast:ClearAllPoints()
	if #activeToasts > 0 then
		if E:GetScreenQuadrant(anchorFrame):find("TOP") then
			toast:SetPoint("TOP", activeToasts[#activeToasts], "BOTTOM", 0, -4 - YOffset)
		else
			toast:SetPoint("BOTTOM", activeToasts[#activeToasts], "TOP", 0, 4 - YOffset)
		end
	else
		toast:SetPoint("TOP", anchorFrame, "TOP", 0, 1 - YOffset)
	end

	T.table_insert(activeToasts, toast)

	toast:Show()
	toast.AnimIn.AnimMove:SetOffset(0, YOffset)
	toast.AnimOut.AnimMove:SetOffset(0, -YOffset)
	toast.AnimIn:Play()
	toast.AnimOut:Play()
	
	if NF.db.noSound ~= true then
		T.PlaySound(18019, "Master")
	end
end

function NF:RefreshToasts()
	for i = 1, #activeToasts do
		local activeToast = activeToasts[i]
		local YOffset, _ = 0
		if activeToast.AnimIn.AnimMove:IsPlaying() then
			_, YOffset = activeToast.AnimIn.AnimMove:GetOffset()
		end
		if activeToast.AnimOut.AnimMove:IsPlaying() then
			_, YOffset = activeToast.AnimOut.AnimMove:GetOffset()
		end

		activeToast:ClearAllPoints()

		if i == 1 then
			activeToast:SetPoint("TOP", anchorFrame, "TOP", 0, 1 - YOffset)
		else
			if E:GetScreenQuadrant(anchorFrame):find("TOP") then
				activeToast:SetPoint("TOP", activeToasts[i - 1], "BOTTOM", 0, -4 - YOffset)
			else
				activeToast:SetPoint("BOTTOM", activeToasts[i - 1], "TOP", 0, 4 - YOffset)
			end
		end
	end

	local queuedToast = T.table_remove(queuedToasts, 1)

	if queuedToast then
		self:SpawnToast(queuedToast)
	end
end

function NF:HideToast(toast)
	for i, activeToast in T.pairs(activeToasts) do
		if toast == activeToast then
			T.table_remove(activeToasts, i)
		end
	end
	T.table_insert(toasts, toast)
	toast:Hide()
	T.C_Timer_After(0.1, function() self:RefreshToasts() end)
end

local function ToastButtonAnimOut_OnFinished(self)
	NF:HideToast(self:GetParent())
end

function NF:CreateToast()
	local toast = T.table_remove(toasts, 1)

	toast = T.CreateFrame("Frame", nil, E.UIParent)
	toast:SetFrameStrata("HIGH")
	toast:SetSize(NF.db.width or 300, NF.db.height or 50)
	toast:SetPoint("TOP", E.UIParent, "TOP")
	toast:Hide()
	KS:CreateBD(toast, .45)
	toast:Styling()
	toast:CreateCloseButton(10)

	local icon = toast:CreateTexture(nil, "OVERLAY")
	icon:SetSize(32, 32)
	icon:SetPoint("LEFT", toast, "LEFT", 9, 0)
	KS:CreateBG(icon)
	toast.icon = icon

	local sep = toast:CreateTexture(nil, "BACKGROUND")
	sep:SetSize(2, NF.db.height)
	sep:SetPoint("LEFT", icon, "RIGHT", 7, 0)
	sep:SetColorTexture(T.unpack(E.media.rgbvaluecolor))

	local title = KUI:CreateText(toast, "OVERLAY", NF.db.fontSize + 1, "OUTLINE")
	title:SetShadowOffset(1, -1)
	title:SetPoint("TOPLEFT", sep, "TOPRIGHT", 3, -6)
	title:SetPoint("TOP", toast, "TOP", 0, 0)
	title:SetJustifyH("LEFT")
	title:SetNonSpaceWrap(true)
	toast.title = title

	local text = KUI:CreateText(toast, "OVERLAY", NF.db.fontSize, nil)
	text:SetShadowOffset(1, -1)
	text:SetPoint("BOTTOMLEFT", sep, "BOTTOMRIGHT", 3, 9)
	text:SetPoint("RIGHT", toast, -9, 0)
	text:SetJustifyH("LEFT")
	text:SetWidth(toast:GetRight() - sep:GetLeft() - 5)
	toast.text = text

	toast.AnimIn = CreateAnimationGroup(toast)

	local animInAlpha = toast.AnimIn:CreateAnimation("Fade")
	animInAlpha:SetOrder(1)
	animInAlpha:SetChange(1)
	animInAlpha:SetDuration(0.5)
	toast.AnimIn.AnimAlpha = animInAlpha

	local animInMove = toast.AnimIn:CreateAnimation("Move")
	animInMove:SetOrder(1)
	animInMove:SetDuration(0.5)
	animInMove:SetSmoothing("Out")
	animInMove:SetOffset(-NF.db.width, 0)
	toast.AnimIn.AnimMove = animInMove

	toast.AnimOut = CreateAnimationGroup(toast)

	local animOutSleep = toast.AnimOut:CreateAnimation("Sleep")
	animOutSleep:SetOrder(1)
	animOutSleep:SetDuration(fadeout_delay)
	toast.AnimOut.AnimSleep = animOutSleep

	local animOutAlpha = toast.AnimOut:CreateAnimation("Fade")
	animOutAlpha:SetOrder(2)
	animOutAlpha:SetChange(0)
	animOutAlpha:SetDuration(0.5)
	toast.AnimOut.AnimAlpha = animOutAlpha

	local animOutMove = toast.AnimOut:CreateAnimation("Move")
	animOutMove:SetOrder(2)
	animOutMove:SetDuration(0.5)
	animOutMove:SetSmoothing("In")
	animOutMove:SetOffset(NF.db.width, 0)
	toast.AnimOut.AnimMove = animOutMove

	toast.AnimOut.AnimAlpha:SetScript("OnFinished", ToastButtonAnimOut_OnFinished)

	toast:SetScript("OnEnter", function(self)
		self.AnimOut:Stop()
	end)

	toast:SetScript("OnLeave", function(self)
		self.AnimOut:Play()
	end)

	toast:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" and self.clickFunc then
			self.clickFunc()
		end
	end)

	return toast
end

function NF:DisplayToast(name, message, clickFunc, texture, ...)
	local toast = self:CreateToast()

	if T.type(clickFunc) == "function" then
		toast.clickFunc = clickFunc
	else
		toast.clickFunc = nil
	end

	if texture then
		if T.C_Texture_GetAtlasInfo(texture) then
			toast.icon:SetAtlas(texture)
		else
			toast.icon:SetTexture(texture)

			if ... then
				toast.icon:SetTexCoord(...)
			else
				toast.icon:SetTexCoord(T.unpack(E.TexCoords))
			end
		end
	else
		toast.icon:SetTexture("Interface\\Icons\\achievement_general")
		toast.icon:SetTexCoord(T.unpack(E.TexCoords))
	end

	toast.title:SetText(name)
	toast.text:SetText(message)

	self:SpawnToast(toast)
end

function NF:PLAYER_FLAGS_CHANGED(event)
	self:UnregisterEvent(event)
	for i = 1, max_active_toasts - #activeToasts do
		self:RefreshToasts()
	end
end

function NF:PLAYER_REGEN_ENABLED()
	for i = 1, max_active_toasts - #activeToasts do
		self:RefreshToasts()
	end
end

-- Test function
local function testCallback()
	KUI:Print("Banner clicked!")
end

T.SlashCmdList.TESTNOTIFICATION = function(b)
	NF:DisplayToast(KUI:cOption("KlixUI:"), L["This is an example of a notification."], testCallback, b == "true" and "INTERFACE\\ICONS\\SPELL_FROST_ARCTICWINDS" or nil, .08, .92, .08, .92)
end
SLASH_TESTNOTIFICATION1 = "/testnotification"
SLASH_TESTNOTIFICATION2 = "/tn"

local hasMail = false
function NF:UPDATE_PENDING_MAIL()
	if NF.db.enable ~= true or NF.db.mail ~= true then return end
	local newMail = T.HasNewMail()
	if hasMail ~= newMail then
		hasMail = newMail
		if hasMail then
			self:DisplayToast(T.string_format("|cfff9ba22%s|r", MAIL_LABEL), HAVE_MAIL, nil, "Interface\\Icons\\inv_letter_15", .08, .92, .08, .92)
			if NF.db.noSound ~= true then
				T.PlaySoundFile([[Interface\AddOns\ElvUI_KlixUI\media\sounds\mail.mp3]])
			end
			if NF.db.message then 
				KUI:Print(L["You have a new mail!"])
			end
		end
	end
end

local showRepair = true

local Slots = {
	[1] = {1, INVTYPE_HEAD, 1000},
	[2] = {3, INVTYPE_SHOULDER, 1000},
	[3] = {5, INVTYPE_ROBE, 1000},
	[4] = {6, INVTYPE_WAIST, 1000},
	[5] = {9, INVTYPE_WRIST, 1000},
	[6] = {10, INVTYPE_HAND, 1000},
	[7] = {7, INVTYPE_LEGS, 1000},
	[8] = {8, INVTYPE_FEET, 1000},
	[9] = {16, INVTYPE_WEAPONMAINHAND, 1000},
	[10] = {17, INVTYPE_WEAPONOFFHAND, 1000},
	[11] = {18, INVTYPE_RANGED, 1000}
}

local function ResetRepairNotification()
	showRepair = true
end

function NF:UPDATE_INVENTORY_DURABILITY()
	local current, max

	for i = 1, 11 do
		if T.GetInventoryItemLink("player", Slots[i][1]) ~= nil then
			current, max = T.GetInventoryItemDurability(Slots[i][1])
			if current then
				Slots[i][3] = current/max
			end
		end
	end
	T.table_sort(Slots, function(a, b) return a[3] < b[3] end)
	local value = T.math_floor(Slots[1][3]*100)

	if showRepair and value < 20 then
		showRepair = false
		E:Delay(30, ResetRepairNotification)
		self:DisplayToast(MINIMAP_TRACKING_REPAIR, T.string_format(L["%s slot needs to repair, current durability is %d."], Slots[1][2], value))
		if NF.db.message then 
			KUI:Print((L["%s slot needs to repair, current durability is %d."]):format(Slots[1][2], value))
		end
	end
end

local numInvites = 0
local function GetGuildInvites()
    local numGuildInvites = 0
    local date = T.C_Calendar_GetDate()
    for index = 1, T.C_Calendar_GetNumGuildEvents() do
        local info = T.C_Calendar_GetGuildEventInfo(index)
        local monthOffset = info.month - date.month
        local numDayEvents = T.C_Calendar_GetNumDayEvents(monthOffset, info.monthDay)

        for i = 1, numDayEvents do
            local event = T.C_Calendar_GetDayEvent(monthOffset, info.monthDay, i)
            if event.inviteStatus == CALENDAR_INVITESTATUS_NOT_SIGNEDUP then
                numGuildInvites = numGuildInvites + 1
            end
        end
    end

    return numGuildInvites
end

local function toggleCalendar()
	if not _G.CalendarFrame then LoadAddOn("Blizzard_Calendar") end
	T.ShowUIPanel(_G.CalendarFrame)
end

local function alertEvents()
	if NF.db.enable ~= true or NF.db.invites ~= true then return end
	if _G.CalendarFrame and _G.CalendarFrame:IsShown() then return end
	local num = T.C_Calendar_GetNumPendingInvites()
	if num ~= numInvites then
		if num > 0 then
			NF:DisplayToast(CALENDAR, L["You have %s pending calendar |4invite:invites;."]:format(num), toggleCalendar)
			if NF.db.message then 
				KUI:Print((L["You have %s pending calendar |4invite:invites;."]):format((num), toggleCalendar))
			end
		end
		numInvites = num
	end

	--[[
	if num ~= numInvites then
		if num > 1 then
			NF:DisplayToast(CALENDAR, T.string_format(L["You have %s pending calendar invite(s)."], num), toggleCalendar)
		elseif num > 0 then
			NF:DisplayToast(CALENDAR, T.string_format(L["You have %s pending calendar invite(s)."], 1), toggleCalendar)
		end
		numInvites = num
	end
	]]
end

local function alertGuildEvents()
	if NF.db.enable ~= true or NF.db.guildEvents ~= true then return end
	if _G.CalendarFrame and _G.CalendarFrame:IsShown() then return end
	local num = GetGuildInvites()
	if num > 0 then
		NF:DisplayToast(CALENDAR, L["You have %s pending guild |4event:events;."]:format(num), toggleCalendar)
		if NF.db.message then 
			KUI:Print((L["You have %s pending guild |4event:events;."]):format((num), toggleCalendar))
		end
	end

	--[[
	if num > 1 then
		NF:DisplayToast(CALENDAR, T.string_format(L["You have %s pending guild event(s)."], num), toggleCalendar)
	elseif num > 0 then
		NF:DisplayToast(CALENDAR, T.string_format(L["You have %s pending guild event(s)."], 1), toggleCalendar)
	end
	]]
end

function NF:CALENDAR_UPDATE_PENDING_INVITES()
	alertEvents()
	alertGuildEvents()
end

function NF:CALENDAR_UPDATE_GUILD_EVENTS()
	alertGuildEvents()
end

local function LoginCheck()
	alertEvents()
	alertGuildEvents()
end

function NF:PLAYER_ENTERING_WORLD()
	T.C_Timer_After(7, LoginCheck)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

local SOUND_TIMEOUT = 20
function NF:VIGNETTE_MINIMAP_UPDATED(event, vignetteGUID, onMinimap)
	if not NF.db.vignette or T.InCombatLockdown() or VignetteExclusionMapIDs[T.C_Map_GetBestMapForUnit("player")] then return end

	local inGroup, inRaid, inPartyLFG = T.IsInGroup(), T.IsInRaid(), T.IsPartyLFG()
	if inGroup or inRaid or inPartyLFG then
		return
	end

	if onMinimap then
		if vignetteGUID ~= self.lastMinimapRare.id then
			local vignetteInfo = T.C_VignetteInfo_GetVignetteInfo(vignetteGUID)
			if vignetteInfo then
				vignetteInfo.name = T.string_format("|cff00c0fa%s|r", vignetteInfo.name:sub(1, 28))
				self:DisplayToast(vignetteInfo.name, L["has appeared on the MiniMap!"], nil, vignetteInfo.atlasName)
				
				if NF.db.message then 
					KUI:Print(vignetteInfo.name, L["has appeared on the MiniMap!"])
				end

				if (T.GetTime() > self.lastMinimapRare.time + SOUND_TIMEOUT) then
					if NF.db.noSound ~= true then
						T.PlaySound(63971) -- "Sound\Interface\UI_Legendary_Item_Toast.ogg"
						T.PlaySound(11773) -- "Sound\Event Sounds\Event_wardrum_ogre.ogg"
					end
				end
			end
		end
	end

	--Set last Vignette data
	self.lastMinimapRare.time = T.GetTime()
	self.lastMinimapRare.id = vignetteGUID
end

function NF:RESURRECT_REQUEST(name)
	if NF.db.noSound ~= true then
		T.PlaySound(46893, "Master")
	end
end

local function SocialQueueIsLeader(playerName, leaderName)
	if leaderName == playerName then
		return true
	end

	for i = 1, T.BNGetNumFriends() do
		local _, accountName, _, _, _, _, _, isOnline = T.BNGetFriendInfo(i)
		if isOnline then
			local numGameAccounts = T.BNGetNumFriendGameAccounts(i)
			for y = 1, numGameAccounts do
				local _, gameCharacterName, gameClient, realmName = T.BNGetFriendGameAccountInfo(i, y)
				if (gameClient == BNET_CLIENT_WOW) and (accountName == playerName) then
					playerName = gameCharacterName
					if realmName ~= E.myrealm then
						playerName = T.string_format('%s-%s', playerName, T.string_gsub(realmName,'[%s%-]',''))
					end
					if leaderName == playerName then
						return true
					end
				end
			end
		end
	end
end

local socialQueueCache = {}
local function RecentSocialQueue(TIME, MSG)
	local previousMessage = false
	if T.next(socialQueueCache) then
		for guid, tbl in T.pairs(socialQueueCache) do
			-- !dont break this loop! its used to keep the cache updated
			if TIME and (T.difftime(TIME, tbl[1]) >= 300) then
				socialQueueCache[guid] = nil --remove any older than 5m
			elseif MSG and (MSG == tbl[2]) then
				previousMessage = true --dont show any of the same message within 5m
			end
		end
	end
	return previousMessage
end

function NF:SocialQueueEvent(event, guid, numAddedItems)
	if not NF.db.quickJoin or T.InCombatLockdown() then return end
	if not (guid) then return end

	if ( numAddedItems == 0 or T.C_SocialQueue_GetGroupMembers(guid) == nil) then
		return
	end
	
	local players = T.C_SocialQueue_GetGroupMembers(guid)
	if not players then return end
	
	local firstMember, numMembers, extraCount, coloredName = players[1], #players, ''
	
	local playerName, nameColor = T.SocialQueueUtil_GetRelationshipInfo(firstMember.guid, nil, firstMember.clubId)
	if numMembers > 1 then
		extraCount = T.string_format(' +%s', numMembers - 1)
	end
	if playerName then
		coloredName = T.string_format('%s%s|r%s', nameColor, playerName, extraCount)
	else
		coloredName = T.string_format('{%s%s}', UNKNOWN, extraCount)
	end

	local isLFGList, firstQueue
	local queues = T.C_SocialQueue_GetGroupQueues(guid)
	local firstQueue = queues and queues[1]
	local isLFGList = firstQueue and firstQueue.queueData and firstQueue.queueData.queueType == 'lfglist'

	if isLFGList and firstQueue and firstQueue.eligible then
		local searchResultInfo, activityID, name, comment, leaderName, fullName, isLeader

		if firstQueue.queueData.lfgListID then
			searchResultInfo = T.C_LFGList_GetSearchResultInfo(firstQueue.queueData.lfgListID)
			if searchResultInfo then
				activityID, name, comment, leaderName = searchResultInfo.activityID, searchResultInfo.name, searchResultInfo.comment, searchResultInfo.leaderName
				isLeader = SocialQueueIsLeader(playerName, leaderName)
			end
		end

		-- ignore groups created by the addon World Quest Group Finder/World Quest Tracker/World Quest Assistant/HandyNotes_Argus to reduce spam
		if comment and (T.string_find(comment, "World Quest Group Finder") or T.string_find(comment, "World Quest Tracker") or T.string_find(comment, "World Quest Assistant") or T.string_find(comment, "HandyNotes_Argus")) then return end
		-- prevent duplicate messages within 5 minutes
		local TIME = T.time()
		if RecentSocialQueue(TIME, name) then return end
		socialQueueCache[guid] = {TIME, name}

		if activityID or firstQueue.queueData.activityID then
			fullName = T.C_LFGList_GetActivityInfo(activityID or firstQueue.queueData.activityID)
		end
		
		fullName = T.string_format("|cff00ff00%s|r", fullName)
		name = T.string_format("|cff00c0fa%s|r", name:sub(1,100))
		if name then
			self:DisplayToast(coloredName, ((isLeader and L["is looking for members"] or L["joined a group"]).."\n".."["..fullName or UNKNOWN).."]: "..name, _G["ToggleQuickJoinPanel"], "Interface\\Icons\\Achievement_GuildPerk_EverybodysFriend", .08, .92, .08, .92)
			if NF.db.message and not E.db.chat.socialQueueMessages then 
				KUI:Print(coloredName, ((isLeader and L["is looking for members"] or L["joined a group "]).."["..fullName or UNKNOWN).."]: "..name)
			end
		else
			self:DisplayToast(coloredName, ((isLeader and L["is looking for members"] or L["joined a group"]).."\n".."["..fullName or UNKNOWN).."]: ", _G["ToggleQuickJoinPanel"], "Interface\\Icons\\Achievement_GuildPerk_EverybodysFriend", .08, .92, .08, .92)
			if NF.db.message and not E.db.chat.socialQueueMessages then 
				KUI:Print(coloredName, ((isLeader and L["is looking for members"] or L["joined a group "]).."["..fullName or UNKNOWN).."]: ")
			end
		end
	elseif firstQueue then
		local output, outputCount, queueCount, queueName = '', '', 0
		for _, queue in T.pairs(queues) do
			if T.type(queue) == "table" and queue.eligible then
				queueName = (queue.queueData and T.SocialQueueUtil_GetQueueName(queue.queueData)) or ""
				if queueName ~= "" then
					if output == "" then
						output = queueName:gsub("\n.+","") -- grab only the first queue name
						queueCount = queueCount + T.select(2, queueName:gsub("\n","")) -- collect additional on single queue
					else
						queueCount = queueCount + 1 + T.select(2, queueName:gsub("\n","")) -- collect additional on additional queues
					end
				end
			end
		end
		if output ~= "" then
			output = T.string_format("|cff00c0fa%s |r", output)
			if queueCount > 0 then
				outputCount = T.string_format(LFG_LIST_AND_MORE, queueCount)
			end
			self:DisplayToast(coloredName, SOCIAL_QUEUE_QUEUED_FOR.. ": "..output..outputCount, _G["ToggleQuickJoinPanel"], "Interface\\Icons\\Achievement_GuildPerk_EverybodysFriend", .08, .92, .08, .92)
			if NF.db.message and not E.db.chat.socialQueueMessages then 
				KUI:Print(coloredName, SOCIAL_QUEUE_QUEUED_FOR.. ": "..output..outputCount)
			end
		end
	end
end

function NF:Initialize()
	NF.db = E.db.KlixUI.notification
	if NF.db.enable ~= true or (T.IsInRaid() and NF.db.raid) then return end

	KUI:RegisterDB(self, "notification")

	anchorFrame = T.CreateFrame("Frame", nil, E.UIParent)
	anchorFrame:SetSize(NF.db.width or 300, NF.db.height or 50)
	anchorFrame:SetPoint("TOP", 0, -70)
	E:CreateMover(anchorFrame, "Notification Mover", L["Notifications"], nil, nil, nil, "ALL,SOLO,KLIXUI", nil, "KlixUI,modules,notification")
	
	self:RegisterEvent("UPDATE_PENDING_MAIL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
	self:RegisterEvent("CALENDAR_UPDATE_GUILD_EVENTS")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
	self:RegisterEvent("RESURRECT_REQUEST")
	self:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	self:RegisterEvent("SOCIAL_QUEUE_UPDATE", "SocialQueueEvent")

	self.lastMinimapRare = {time = 0, id = nil}
end

local function InitializeCallback()
	NF:Initialize()
end

KUI:RegisterModule(NF:GetName(), InitializeCallback)