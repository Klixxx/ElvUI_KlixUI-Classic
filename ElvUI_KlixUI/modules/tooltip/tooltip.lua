local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KTT = KUI:NewModule("KuiTooltip", "AceTimer-3.0", "AceHook-3.0", "AceEvent-3.0")
local TT = E:GetModule("Tooltip")

local FOREIGN_SERVER_LABEL = FOREIGN_SERVER_LABEL
local LE_REALM_RELATION_COALESCED = LE_REALM_RELATION_COALESCED
local LE_REALM_RELATION_VIRTUAL = LE_REALM_RELATION_VIRTUAL
local INTERACTIVE_SERVER_LABEL = INTERACTIVE_SERVER_LABEL
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

local AFK_LABEL = "|cffFFFFFF<|r|cffFF0000"..L["AFK"].."|r|cffFFFFFF>|r"
local DND_LABEL = "|cffFFFFFF<|r|cffFFFF00"..L["DND"].."|r|cffFFFFFF>|r"

function KTT:GameTooltip_OnTooltipSetUnit(tt)
	if tt:IsForbidden() then return end
	local unit = T.select(2, tt:GetUnit())
	if((tt:GetOwner() ~= UIParent) and (self.db.visibility and self.db.visibility.unitFrames ~= 'NONE')) then
		local modifier = self.db.visibility.unitFrames

		if(modifier == 'ALL' or not ((modifier == 'SHIFT' and T.IsShiftKeyDown()) or (modifier == 'CTRL' and T.IsControlKeyDown()) or (modifier == 'ALT' and T.IsAltKeyDown()))) then
			tt:Hide()
			return
		end
	end

	if(not unit) then
		local GMF = T.GetMouseFocus()
		if(GMF and GMF.GetAttribute and GMF:GetAttribute("unit")) then
			unit = GMF:GetAttribute("unit")
		end
		if(not unit or not T.UnitExists(unit)) then
			return
		end
	end

	self:RemoveTrashLines(tt) --keep an eye on this may be buggy
	local level = T.UnitLevel(unit)
	local isShiftKeyDown = T.IsShiftKeyDown()
	local isAltKeyDown = T.IsAltKeyDown()

	local color
	if(T.UnitIsPlayer(unit)) then
		local localeClass, class = T.UnitClass(unit)
		local name, realm = T.UnitName(unit)
		local guildName, guildRankName, _, guildRealm = T.GetGuildInfo(unit)
		local pvpName = T.UnitPVPName(unit)
		local relationship = T.UnitRealmRelationship(unit)
		if not localeClass or not class then return end
		color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]

		local t1, t2 = '', ''
		if self.db.playerTitles and pvpName and (pvpName ~= name) then
			if E.db.KlixUI.tooltip.titleColor then
				local p1, p2 = pvpName:match('(.*)'..name..'(.*)')
				if p1 and p1 ~= '' then
					if (T.UnitIsAFK(unit)) then
						t1 = AFK_LABEL..' |cfff960d9'..p1..'|r'
					elseif (T.UnitIsDND(unit)) then
						t1 = DND_LABEL..' |cfff960d9'..p1..'|r'
					else
						t1 = '|cfff960d9'..p1..'|r'
					end
				end
				if p2 and p2 ~= '' then
					if (T.UnitIsAFK(unit)) then
						t2 = AFK_LABEL..' |cfff960d9'..p2..'|r'
					elseif (T.UnitIsDND(unit)) then
						t2 = DND_LABEL..' |cfff960d9'..p2..'|r'
					else
						t2 = '|cfff960d9'..p2..'|r'
					end
				end
			else
				name = pvpName
			end
		end

		if(realm and realm ~= "") then
			if(isShiftKeyDown) or self.db.alwaysShowRealm then
				realm = " - "..realm
			elseif(relationship == LE_REALM_RELATION_COALESCED) then
				realm = FOREIGN_SERVER_LABEL
			elseif(relationship == LE_REALM_RELATION_VIRTUAL) then
				realm = INTERACTIVE_SERVER_LABEL
			end
			realm = '|cfff960d9'..realm..'|r'
		else
			realm = ''
		end
		
		if not E.db.KlixUI.tooltip.titleColor then
			if (T.UnitIsAFK(unit)) then
				name = name.." "..AFK_LABEL
			elseif (T.UnitIsDND(unit)) then
				name = name.." "..DND_LABEL
			end
		end
		
		if E.db.KlixUI.tooltip.titleColor then
			_G.GameTooltipTextLeft1:SetFormattedText("%s|c%s%s|r%s%s", t1, color.colorStr, name, t2, realm)
		else
			_G.GameTooltipTextLeft1:SetFormattedText("|c%s%s%s|r", color.colorStr, name, realm)
		end

		local lineOffset = 2
		if(guildName) then
			if(guildRealm and isShiftKeyDown) then
				guildName = guildName.."-"..guildRealm
			end

			if(self.db.guildRanks) then
				_G.GameTooltipTextLeft2:SetText(("|cfff960d9[|r|cff00ff10%s|r|cfff960d9]|r <|cff00ff10%s|r>"):format(guildName, guildRankName))
			else
				_G.GameTooltipTextLeft2:SetText(("[|cff00ff10%s|r]"):format(guildName))
			end
			lineOffset = 3
		end
	end
end

function KTT_LFGListUtil_SetSearchEntryTooltip(tooltip, resultID, autoAcceptOption)
	local searchResultInfo = T.C_LFGList_GetSearchResultInfo(resultID)
	local activityName, shortName, categoryID, groupID, minItemLevel, filters, minLevel, maxPlayers, displayType, orderIndex, useHonorLevel = T.C_LFGList_GetActivityInfo(searchResultInfo.activityID)
	local memberCounts = T.C_LFGList_GetSearchResultMemberCounts(resultID)
	tooltip:SetText(searchResultInfo.name, 1, 1, 1, true)
	tooltip:AddLine(activityName)
	if ( searchResultInfo.comment and searchResultInfo.comment == "" and searchResultInfo.questID ) then
		searchResultInfo.comment = T.LFGListUtil_GetQuestDescription(searchResultInfo.questID)
	end
	if ( searchResultInfo.comment ~= "" ) then
		tooltip:AddLine(T.string_format(LFG_LIST_COMMENT_FORMAT, searchResultInfo.comment), LFG_LIST_COMMENT_FONT_COLOR.r, LFG_LIST_COMMENT_FONT_COLOR.g, LFG_LIST_COMMENT_FONT_COLOR.b, true)
	end
	tooltip:AddLine(" ")
	if ( searchResultInfo.requiredItemLevel > 0 ) then
		tooltip:AddLine(T.string_format(LFG_LIST_TOOLTIP_ILVL, searchResultInfo.requiredItemLevel))
	end
	if ( useHonorLevel and searchResultInfo.requiredHonorLevel > 0 ) then
		tooltip:AddLine(T.string_format(LFG_LIST_TOOLTIP_HONOR_LEVEL, searchResultInfo.requiredHonorLevel))
	end
	if ( searchResultInfo.voiceChat ~= "" ) then
		tooltip:AddLine(T.string_format(LFG_LIST_TOOLTIP_VOICE_CHAT, searchResultInfo.voiceChat), nil, nil, nil, true)
	end
	if ( searchResultInfo.requiredItemLevel > 0 or (useHonorLevel and searchResultInfo.requiredHonorLevel > 0) or searchResultInfo.voiceChat ~= "" ) then
		tooltip:AddLine(" ")
	end

	if ( searchResultInfo.leaderName ) then
		tooltip:AddLine(T.string_format(LFG_LIST_TOOLTIP_LEADER, searchResultInfo.leaderName))
	end
	if ( searchResultInfo.age > 0 ) then
		tooltip:AddLine(T.string_format(LFG_LIST_TOOLTIP_AGE, T.SecondsToTime(searchResultInfo.age, false, false, 1, false)))
	end

	if ( searchResultInfo.leaderName or searchResultInfo.age > 0 ) then
		tooltip:AddLine(" ")
	end

	if ( E.db.KlixUI.tooltip.memberInfo ) then
		tooltip:AddLine(T.string_format(LFG_LIST_TOOLTIP_MEMBERS, searchResultInfo.numMembers, memberCounts.TANK, memberCounts.HEALER, memberCounts.DAMAGER))
		local roleClasses = {}
		for i=1, searchResultInfo.numMembers do
			local role, class, classLocalized = T.C_LFGList_GetSearchResultMemberInfo(resultID, i)
			local classcounts = roleClasses[role] or {}
			roleClasses[role] = classcounts
			if not classcounts[class] then
				classcounts[class] = 1
			else
				classcounts[class] = classcounts[class] + 1
			end
		end
		T.table_sort(roleClasses, function(a,b) return a > b end)
		for role, classcnts in T.pairs(roleClasses) do
			--tooltip:AddLine(_G[role]..":")
			for class, cnt in T.pairs(classcnts) do
				local classColor = RAID_CLASS_COLORS[class] or NORMAL_FONT_COLOR
				tooltip:AddLine(T.string_format(LFG_LIST_TOOLTIP_CLASS_ROLE.." - %d", LOCALIZED_CLASS_NAMES_MALE[class], _G[role], cnt), classColor.r, classColor.g, classColor.b)
			end
			T.table_wipe(classcnts)
		end
		T.table_wipe(roleClasses)
	else
		tooltip:AddLine(T.string_format(LFG_LIST_TOOLTIP_MEMBERS, searchResultInfo.numMembers, memberCounts.TANK, memberCounts.HEALER, memberCounts.DAMAGER))
	end

	if ( searchResultInfo.numBNetFriends + searchResultInfo.numCharFriends + searchResultInfo.numGuildMates > 0 ) then
		tooltip:AddLine(" ")
		tooltip:AddLine(LFG_LIST_TOOLTIP_FRIENDS_IN_GROUP)
		tooltip:AddLine(T.LFGListSearchEntryUtil_GetFriendList(resultID), 1, 1, 1, true)
	end

	local completedEncounters = T.C_LFGList_GetSearchResultEncounterInfo(resultID)
	if ( completedEncounters and #completedEncounters > 0 ) then
		tooltip:AddLine(" ")
		tooltip:AddLine(LFG_LIST_BOSSES_DEFEATED)
		for i=1, #completedEncounters do
			tooltip:AddLine(completedEncounters[i], RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
		end
	end

	autoAcceptOption = autoAcceptOption or LFG_LIST_UTIL_ALLOW_AUTO_ACCEPT_LINE

	if autoAcceptOption == LFG_LIST_UTIL_ALLOW_AUTO_ACCEPT_LINE and searchResultInfo.autoAccept then
		tooltip:AddLine(" ")
		tooltip:AddLine(LFG_LIST_TOOLTIP_AUTO_ACCEPT, LIGHTBLUE_FONT_COLOR:GetRGB())
	end

	if ( searchResultInfo.isDelisted ) then
		tooltip:AddLine(" ")
		tooltip:AddLine(LFG_LIST_ENTRY_DELISTED, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, true)
	end

	tooltip:Show()
end
hooksecurefunc("LFGListUtil_SetSearchEntryTooltip", KTT_LFGListUtil_SetSearchEntryTooltip)

function KTT:Initialize()
	if E.private.tooltip.enable ~= true or E.db.KlixUI.tooltip.tooltip ~= true then return end
	self.db = E.db.tooltip

	hooksecurefunc(TT, "GameTooltip_OnTooltipSetUnit", KTT.GameTooltip_OnTooltipSetUnit)
	
	--[[if E.db.KlixUI.tooltip.arenaXP then
		self:InitializeArenaXP()
	end]]
end

local function InitializeCallback()
	KTT:Initialize()
end

KUI:RegisterModule(KTT:GetName(), InitializeCallback)