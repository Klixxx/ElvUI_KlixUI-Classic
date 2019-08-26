local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local RCM = KUI:NewModule('RightClickMenu')

local locale = T.GetLocale()

local function urlencode(s)
	s = T.string_gsub(s, "([^%w%.%- ])", function(c)
			return T.string_format("%%%02X", T.string_byte(c))
		end)
	return T.string_gsub(s, " ", "-")
end

local function gethost()
	local host = "http://eu.battle.net/wow/en/character/"
	if (locale == "zhTW") then
		host = "http://tw.battle.net/wow/zh/character/"
	elseif (locale == "zhCN") then
		host = "http://www.battlenet.com.cn/wow/zh/character/"
	end
	return host
end

local function getfullname()
	local unit = UIDROPDOWNMENU_INIT_MENU.unit
	local name = UIDROPDOWNMENU_INIT_MENU.name
	local server = UIDROPDOWNMENU_INIT_MENU.server

	if (server and (not unit or T.UnitRealmRelationship(unit) ~= LE_REALM_RELATION_SAME)) then
		return name .. "-" .. server
	else
		return name
	end
end

RCM.friend_features = {
	"ARMORY",
	"MYSTATS",
	"NAME_COPY",
	"SEND_WHO",
	"FRIEND_ADD",
	"GUILD_ADD",
}
RCM.cr_features = {
	"NAME_COPY",
	"SEND_WHO",
	"FRIEND_ADD",
}
RCM.guild_features = {
	"ARMORY",
	"NAME_COPY",
	"FRIEND_ADD",
}
RCM.player_features = {
	"ARMORY",
	"NAME_COPY",
}

RCM.UnitPopupButtonsExtra = {
	["ARMORY"] = true,
	["SEND_WHO"] = true,
	["NAME_COPY"] = true,
	["GUILD_ADD"] = true,
	["FRIEND_ADD"] = true,
	["MYSTATS"] = true,
}

RCM.dropdownmenu_show = {
	["SELF"] = true,
	["PLAYER"] = true,
	["PARTY"] = true,
	["RAID_PLAYER"] = true,
	["TARGET"] = true,
}

StaticPopupDialogs["ARMORY"] = {
	text = L["Armory"],
	button2 = CANCEL,
	hasEditBox = true,
    hasWideEditBox = true,
	timeout = 0,
	exclusive = 1,
	hideOnEscape = 1,
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
	whileDead = 1,
	maxLetters = 255,
}

StaticPopupDialogs["NAME_COPY"] = {
	text = L["Get Name"],
	button2 = CANCEL,
	hasEditBox = true,
    hasWideEditBox = true,
	timeout = 0,
	exclusive = 1,
	hideOnEscape = 1,
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
	whileDead = 1,
	maxLetters = 255,
}

UnitPopupButtons["KLIXUI"] = {
	text = KUI.Title,
	isTitle = true,
	isUninteractable = true,
	isSubsection = true,
	isSubsectionTitle = true,
	isSubsectionSeparator = true,
}

UnitPopupButtons["ARMORY"] = {
	text = L["Armory"],
	func = function()
		local name = UIDROPDOWNMENU_INIT_MENU.name
		--local server = UIDROPDOWNMENU_INIT_MENU.server

		if name then
			local armory = gethost() .. urlencode(--[[server or ]]T.GetRealmName()) .. "/" .. urlencode(name) .. "/advanced"
			local dialog = T.StaticPopup_Show("ARMORY")
			local editbox = _G[dialog:GetName().."EditBox"]  
			editbox:SetText(armory)
			editbox:SetFocus()
			editbox:HighlightText()
			local button = _G[dialog:GetName().."Button2"]
			button:ClearAllPoints()
			button:SetPoint("CENTER", editbox, "CENTER", 0, -30)
		end
	end
}

UnitPopupButtons["SEND_WHO"] = {
	text = L["Query Detail"],
	func = function()
		local fullname = getfullname()

		if fullname then
			T.SendWho(fullname)
		end
	end
}

UnitPopupButtons["GUILD_ADD"] = {
	text = L["Guild Invite"],
	func = function()
		local fullname = getfullname()

		if fullname then
			T.GuildInvite(fullname)
		end
	end
}

UnitPopupButtons["FRIEND_ADD"] = {
	text = L["Add Friend"],
	func = function()
		local fullname = getfullname()

		if fullname then
			T.AddFriend(fullname)
		end
	end
}

UnitPopupButtons["MYSTATS"] = {
	text = L["Report MyStats"],
	func = function()
		local fullname = getfullname()

		if fullname then
			local CRITICAL = TEXT_MODE_A_STRING_RESULT_CRITICAL or STAT_CRITICAL_STRIKE
			CRITICAL = T.string_gsub(CRITICAL, "[()]","")
			T.SendChatMessage(T.string_format("%s:%.1f %s:%s", ITEM_LEVEL_ABBR, T.select(2,T.GetAverageItemLevel()), HP, T.AbbreviateNumbers(T.UnitHealthMax("player"))), "WHISPER", nil, fullname)
			T.SendChatMessage(T.string_format(" - %s:%.2f%%", STAT_HASTE, T.GetHaste()), "WHISPER", nil, fullname)
			T.SendChatMessage(T.string_format(" - %s:%.2f%%", STAT_MASTERY, T.GetMasteryEffect()), "WHISPER", nil, fullname)
			--T.SendChatMessage(T.string_format(" - %s:%.2f%%", STAT_LIFESTEAL, T.GetLifesteal()), "WHISPER", nil, fullname)
			T.SendChatMessage(T.string_format(" - %s:%.2f%%", CRITICAL, T.math_max(T.GetRangedCritChance(), T.GetCritChance(), T.GetSpellCritChance(2))), "WHISPER", nil, fullname)
			T.SendChatMessage(T.string_format(" - %s:%.2f%%", STAT_VERSATILITY, T.GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + T.GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)), "WHISPER", nil, fullname)
		end
	end
}

UnitPopupButtons["NAME_COPY"] = {
	text = L["Get Name"],
	func = function()
		local fullname = getfullname()

		if fullname then
			local dialog = T.StaticPopup_Show("NAME_COPY")
			local editbox = _G[dialog:GetName().."EditBox"]  
			editbox:SetText(fullname or "")
			editbox:SetFocus()
			editbox:HighlightText()
			local button = _G[dialog:GetName().."Button2"]
			button:ClearAllPoints()
			button:SetPoint("CENTER", editbox, "CENTER", 0, -30)
		end
	end
}

function RCM:Initialize()
	if not E.db.KlixUI.chat.rightclickmenu.enable then return end

	-- Friend
	T.table_insert(UnitPopupMenus["FRIEND"], #UnitPopupMenus["FRIEND"] - 1, "KLIXUI")
	for _, v in T.pairs(RCM.friend_features) do
		T.table_insert(UnitPopupMenus["FRIEND"], #UnitPopupMenus["FRIEND"] - 1, v)
	end

	hooksecurefunc("UnitPopup_ShowMenu", function(dropdownMenu, which, unit, name, userData, ...)
		for i=1, UIDROPDOWNMENU_MAXBUTTONS do
			local button = _G["DropDownList" .. UIDROPDOWNMENU_MENU_LEVEL .. "Button" .. i]
			if RCM.UnitPopupButtonsExtra[button.value] then
				button.func = UnitPopupButtons[button.value].func
			end
		end
	end)
end

local function InitializeCallback()
	RCM:Initialize()
end

KUI:RegisterModule(RCM:GetName(), InitializeCallback)