local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KDT = KUI:GetModule('KuiDataTexts')
local DT = E:GetModule('DataTexts')

local JEWELCRAFTING, COOKING, ARCHAEOLOGY
local SHOW_CONQUEST_LEVEL = SHOW_CONQUEST_LEVEL
local FACTION_HORDE = FACTION_HORDE
local FACTION_ALLIANCE = FACTION_ALLIANCE
local ARCHAEOLOGY_RUNE_STONES = ARCHAEOLOGY_RUNE_STONES
local GROUP_FINDER = GROUP_FINDER
local PLAYER_V_PLAYER = PLAYER_V_PLAYER
local MISCELLANEOUS = MISCELLANEOUS
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

local defaultColor = { 1, 1, 1 }
local Profit = 0
local Spent = 0
local copperFormatter = T.string_join("", "%d", L.copperabbrev)
local silverFormatter = T.string_join("", "%d", L.silverabbrev, " %.2d", L.copperabbrev)
local goldFormatter =  T.string_join("", "%s", L.goldabbrev, " %.2d", L.silverabbrev, " %.2d", L.copperabbrev)
local resetInfoFormatter = T.string_join("", "|cffaaaaaa", L["Hold Shift + Right Click: Reset Data"], "|r")

local ArchaeologyFragments = {
	398, -- Draenei
	384, -- Dwarf
	393, -- Fossil
	677, -- Mogu
	400, -- Nerubian
	394, -- Night Elf
	828, -- Ogre
	397, -- Orc
	676, -- Pandaren
	401, -- Tol'vir
	385, -- Troll
	399, -- Vrykul
	754, -- Mantid
	829, -- Arakkoa
	821, -- Draenor Clans
	1174, --Demonic
	1172, --Highborn
	1173, --Highmountain tauren
	1534, --Zandalari
	1535, --Drust
}

--[[local CookingAwards = {
	81, -- Epicurean
	402 -- Ironpaw
}

local JewelcraftingTokens = {
	61, -- Dalaran
	361, -- Illustrious
}

local DungeonRaid = {
	776, -- Warforged Seal
	752, -- Mogu Rune of Fate
	697, -- Elder Charm
	738, -- Lesser Charm
	615, -- Essence of Corrupted Deathwing
	614, -- Mote of Darkness
	994, -- Seal of Tempered Fate
	1129, -- Seal of Inavitable Fate
	1166, --Timewarped Badge
	1191, -- Valor
	1273, --Seal of Broken Fate
	1314, --Lingering soul fragment
	1580, --Seal of Wartorn Fate
	1718, --Azerite Impurity
}

local PvPPoints = {
	391, -- Tol Barad
	1149, --Sightless Eye
	1356, --Echoes of battle
	1357, --Echoes of domination
	1602, --Conquest
}

local MiscellaneousCurrency = {
	241, -- Champion Seals
	416, -- Mark of the World Tree
	515, -- Darkmoon Prize Ticket
	777, -- Timeless Coins
	944, -- Artifact Fragment?
	789, -- Bloody Coin
	1416, --Coins of Air
	823, -- Apexis Crystal
	980, -- Dingy Iron Coins
	824, -- Garrison
	1101, -- Oil
	1220, --Order resousces
	1226, --Nethershard
	1275, --Curious Coin
	1155, --Ancient Mana
	1154, --Shadowy Coins
	1268, --Timeworn Artifact
	1342, --Legionfall war supplies
	1506, --Argus Waystone
	1299, --Brawler's Gold
	1508, --Veiled Argunite
	1533, --Wakening Essence
	1565, --Rich Azerite Fragment
	1710, --Seafarer's Dubloon
	1560, --War Resources
	1587, --War Supplies
	1379, --Trial of Style Token
	1388, --Armor Scraps
	1401, --Stronghold Supplies
	1540, --Wood
	1541, --Iron
	1559, --Essence of Storms
	1717, --7th Legion Commendation
	1716, --Honorbound Commendation
}]]

local DungeonRaid = {
	1166, -- Timewarped Badge
}

local PvPPoints = {
	391, -- Tol Barad Commendation
	1602, -- Conquest
}

local MiscellaneousCurrency = {
	1388, -- Armor Scraps
	515, -- Darkmoon Prize Ticket
	81, -- Epicurean's Award
	402, -- Ironpaw Token
	1401, -- Stronghold Supplies
	1379, -- Trial of Style Token
}

local BattleForAzertoh = {
	1717, -- 7th Legion Service Medal
	1716, -- Honorbound Service Medal
	1565, -- Rich Azerite Fragment
	1710, -- Seafarer's Dubloon
	1580, -- Seal of Wartorn Fate
	1718, -- Titan Residuum
	1560, -- War Resources
	1587, -- War Supplies
}

local Legion = {
	1155, -- Ancient Mana
	1299, -- Brawler's Gold
	1416, -- Coins of Air
	1275, -- Curious Coin
	1356, -- Echoes of Battle
	1357, -- Echoes of Domination
	1355, -- Felessence
	1342, -- Legionfall War Supplies
	1314, -- Lingering Soul Fragment
	1226, -- Nethershard
	1220, -- Order Resources
	1273, -- Seal of Broken Fate
	1154, -- Shadowy Coins
	1149, -- Sightless Eye
	1268, -- Timeworn Artifact
	1508, -- Veiled Argunite
	1533, -- Wakening Essence
}

local WarlordsOfDraenor = {
	823, -- Apexis Crystal
	944, -- Artifact Fragment
	980, -- Dingy Iron Coins
	824, -- Garrison Resources
	1101, -- Oil
	1129, -- Seal of Inevitable Fate
	994, -- Seal of Tempered Fate
}

local MistsOfPandaria = {
	789, -- Bloody Coin
	697, -- Elder Charm of Good Fortune
	738, -- Lesser Charm of Good Fortune
	752, -- Mogu Rune of Fate
	777, -- Timeless Coin
	776, -- Warforged Seal
}

local Cataclysm = {
	615, -- Essence of Corrupted Deathwing
	361, -- Illustrious Jewelcrafter's Token
	416, -- Mark of the World Tree
	614, -- Mote of Darkness
}

local WrathOfTheLichKing = {
	241, -- Champion's Seal
	61, -- Dalaran Jewelcrafter's Token
}

local HordeColor = RAID_CLASS_COLORS["DEATHKNIGHT"]
local AllianceColor = RAID_CLASS_COLORS["SHAMAN"]

local function ToggleOption(name)
	if E.db.KlixUI.currencyDT[name] then
		E.db.KlixUI.currencyDT[name] = false
	else
		E.db.KlixUI.currencyDT[name] = true
	end
end

local function GetOption(name)
	return E.db.KlixUI.currencyDT[name]
end

local HiddenCurrency = {}

local function UnusedCheck()
	if GetOption('Unused') then return end
	T.table_wipe(HiddenCurrency)
	for i = 1, T.GetCurrencyListSize() do
		local name, isHeader, _, isUnused = T.GetCurrencyListInfo(i)
		if not isHeader and isUnused then
			if not KUI:SimpleTable(HiddenCurrency, name) then
				T.table_insert(HiddenCurrency,#(HiddenCurrency)+1, name)
			end
		else
			if KUI:SimpleTable(HiddenCurrency, name) then
				HiddenCurrency[i] = nil
			end
		end
	end
end

local function SortCurrency(a,b)
	local method = E.db.KlixUI.currencyDT.cur.method
	if E.db.KlixUI.currencyDT.cur.direction == "normal" then
		return a[method] < b[method]
	else
		return a[method] > b[method]
	end
end

local function SortGold(a,b)
	local method = E.db.KlixUI.currencyDT.gold.method
	if method == "name" or method == "order" and E.db.KlixUI.currencyDT.gold.direction == "normal" then
		return a[method] < b[method]
	elseif method == "amount" and E.db.KlixUI.currencyDT.gold.direction == "normal" then
		return a[method] > b[method]
	elseif method == "amount" and E.db.KlixUI.currencyDT.gold.direction ~= "normal" then
		return a[method] < b[method]
	else
		return a[method] > b[method]
	end
end

local function GetCurrency(CurrencyTable, Text)
	local Seperator = false
	UnusedCheck()
	local ShownTable = {}
	for key, id in T.pairs(CurrencyTable) do
		local name, amount, texture, week, weekmax, maxed, discovered = T.GetCurrencyInfo(id)
		if name and name ~= "" then
			local LeftString = GetOption('Icons') and T.string_format('%s %s', T.string_format('|T%s:14:14:0:0:64:64:4:60:4:60|t', texture), name) or name
			local RightString = amount
			local unused = KUI:SimpleTable(HiddenCurrency, name) or nil

			if maxed > 0 then
				RightString = T.string_format('%s / %s', amount, maxed)
			end

			local r1, g1, b1 = 1, 1, 1
			for i = 1, T.GetNumWatchedTokens() do
				local _, _, _, itemID = T.GetBackpackCurrencyInfo(i)
				if id == itemID then
					r1, g1, b1 = .24, .54, .78
				end
			end
			local r2, g2, b2 = r1, g1, b1
			if maxed > 0 and (amount == maxed) or weekmax > 0 and (week == weekmax) then r2, g2, b2 = .77, .12, .23 end
			if not (amount == 0 and not GetOption('Zero') and r1 == 1) and discovered and not unused then
				if not Seperator then
					DT.tooltip:AddLine(' ')
					DT.tooltip:AddLine(Text)
					Seperator = true
				end
				T.table_insert(ShownTable,
					{
						name = name,
						left = LeftString,
						right = RightString,
						r1 = r1, g1 = g1, b1 = b1,
						r2 = r2, g2 = g2, b2 = b2,
						amount = amount
					}
				)
			end
		end
	end
	T.table_sort(ShownTable, SortCurrency)
	for i = 1, #ShownTable do
		local t = ShownTable[i]
		DT.tooltip:AddDoubleLine(t.left, t.right, t.r1, t.g1, t.b1, t.r2, t.g2, t.b2)
	end
end

local function OnEvent(self, event, ...)
	if not T.IsLoggedIn() then return end
	local NewMoney = T.GetMoney();
	ElvDB = ElvDB or { };
	ElvDB["gold"] = ElvDB["gold"] or {};
	ElvDB["gold"][E.myrealm] = ElvDB["gold"][E.myrealm] or {};
	ElvDB["gold"][E.myrealm][E.myname] = ElvDB["gold"][E.myrealm][E.myname] or NewMoney;
	ElvDB["class"] = ElvDB["class"] or {};
	ElvDB["class"][E.myrealm] = ElvDB["class"][E.myrealm] or {};
	ElvDB["class"][E.myrealm][E.myname] = T.select(2, T.UnitClass('player'))
	ElvDB["faction"] = ElvDB["faction"] or {};
	ElvDB["faction"][E.myrealm] = ElvDB["faction"][E.myrealm] or {};
	ElvDB["faction"][E.myrealm]["Horde"] = ElvDB["faction"][E.myrealm]["Horde"] or {};
	ElvDB["faction"][E.myrealm]["Alliance"] = ElvDB["faction"][E.myrealm]["Alliance"] or {};

	local OldMoney = ElvDB["gold"][E.myrealm][E.myname] or NewMoney

	local calculateChange = false;
	
	if (NewMoney == 0) then
		if (self.seenZeroAlready) then
			calculateChange = true
			self.seenZeroAlready = false
		else
			self.seenZeroAlready = true
		end
	else
		self.seenZeroAlready = false
		calculateChange = true
	end

	if (calculateChange) then
		local Change = NewMoney - OldMoney

		if OldMoney > NewMoney then
			Spent = Spent - Change
		else
			Profit = Profit + Change
		end

		self.text:SetText(E:FormatMoney(NewMoney, E.db.datatexts.goldFormat or "BLIZZARD", not E.db.datatexts.goldCoins))

		ElvDB["gold"][E.myrealm][E.myname] = NewMoney
		if (E.myfaction ~= "Neutral") then
			ElvDB["faction"][E.myrealm][E.myfaction][E.myname] = NewMoney
		end
	end

	if event == 'LOADING_SCREEN_DISABLED' or event == 'SPELLS_CHANGED' then
		JEWELCRAFTING = nil
		for k, v in T.pairs({T.GetProfessions()}) do
			if v then
				local name, _, _, _, _, _, skillid = T.GetProfessionInfo(v)
				if skillid == 755 then
					JEWELCRAFTING = name
				elseif skillid == 185 then
					COOKING = name
				elseif skillid == 794 then
					ARCHAEOLOGY = name
				end
			end
		end
	end
end

local function Click(self, btn)
	if btn == "RightButton" then
		if T.IsShiftKeyDown() then
			ElvDB.gold = nil;
			OnEvent(self)
			DT.tooltip:Hide();
		end
	else
		T.ToggleCharacter("TokenFrame")
	end
end

T.C_Timer_NewTicker(60, function () T.C_WowTokenPublic_UpdateMarketPrice() end)

local HeaderListExpanded = {}
local function ToggleCurrencies(open)
	for i = T.GetCurrencyListSize(), 1, -1 do
		local name, isHeader, isExpanded = T.GetCurrencyListInfo(i)
		if open then
			if not HeaderListExpanded[name] and isHeader and isExpanded then
				HeaderListExpanded[name] = true
			else
				T.ExpandCurrencyList(i, 1)
			end
		else
			if isHeader then
				if not HeaderListExpanded[name] then
					T.ExpandCurrencyList(i, 0)
				else
					HeaderListExpanded[name] = nil
				end
			end
		end
	end
	T.TokenFrame_Update()
end

local function OnEnter(self)
	if T.InCombatLockdown() then return end
	DT:SetupTooltip(self)

	DT.tooltip:AddLine(L["Session:"])
	DT.tooltip:AddDoubleLine(L["Earned:"], E:FormatMoney(Profit, E.db.datatexts.goldFormat or "BLIZZARD", not E.db.datatexts.goldCoins), 1, 1, 1, 1, 1, 1)
	DT.tooltip:AddDoubleLine(L["Spent:"], E:FormatMoney(Spent, E.db.datatexts.goldFormat or "BLIZZARD", not E.db.datatexts.goldCoins), 1, 1, 1, 1, 1, 1)
	if Profit < Spent then
		DT.tooltip:AddDoubleLine(L["Deficit:"], E:FormatMoney(Profit-Spent, E.db.datatexts.goldFormat or "BLIZZARD", not E.db.datatexts.goldCoins), 1, 0, 0, 1, 1, 1)
	elseif (Profit-Spent)>0 then
		DT.tooltip:AddDoubleLine(L["Profit:"], E:FormatMoney(Profit-Spent, E.db.datatexts.goldFormat or "BLIZZARD", not E.db.datatexts.goldCoins), 0, 1, 0, 1, 1, 1)
	end
	DT.tooltip:AddLine' '

	local totalGold, AllianceGold, HordeGold = 0, 0, 0
	DT.tooltip:AddLine(L["Character: "])
	local ShownGold = {}
	for k, _ in T.pairs(ElvDB["gold"][E.myrealm]) do
		if ElvDB["gold"][E.myrealm][k] then
			local class = ElvDB["class"][E.myrealm][k]
			local color = RAID_CLASS_COLORS[class or "PRIEST"]
			local order = E.private.KlixUI.characterGoldsSorting[E.myrealm][k] or 1
			tinsert(ShownGold,
				{
					name = k,
					amount = ElvDB["gold"][E.myrealm][k],
					amountText = E:FormatMoney(ElvDB["gold"][E.myrealm][k], E.db.datatexts.goldFormat or "BLIZZARD", not E.db.datatexts.goldCoins),
					r = color.r, g = color.g, b =color.b,
					order = order,
				}
			)
			if ElvDB["faction"][E.myrealm]["Alliance"][k] then
				AllianceGold = AllianceGold + ElvDB["gold"][E.myrealm][k]
			end
			if ElvDB["faction"][E.myrealm]["Horde"][k] then
				HordeGold = HordeGold + ElvDB["gold"][E.myrealm][k]
			end
			totalGold = totalGold + ElvDB["gold"][E.myrealm][k]
		end
	end
	T.table_sort(ShownGold, SortGold)
	for i = 1, #ShownGold do
		local t = ShownGold[i]
		DT.tooltip:AddDoubleLine(t.name == E.myname and t.name.." |TInterface\\RAIDFRAME\\ReadyCheck-Ready:12|t" or t.name, t.amountText, t.r, t.g, t.b, 1, 1, 1)
	end

	DT.tooltip:AddLine' '
	DT.tooltip:AddLine(L["Server: "])
	if GetOption('Faction') then
		DT.tooltip:AddDoubleLine(T.string_format('%s: ', FACTION_ALLIANCE), E:FormatMoney(AllianceGold, E.db.datatexts.goldFormat or "BLIZZARD", not E.db.datatexts.goldCoins), AllianceColor.r, AllianceColor.g, AllianceColor.b, 1, 1, 1)
		DT.tooltip:AddDoubleLine(T.string_format('%s: ', FACTION_HORDE), E:FormatMoney(HordeGold, E.db.datatexts.goldFormat or "BLIZZARD", not E.db.datatexts.goldCoins), HordeColor.r, HordeColor.g, HordeColor.b, 1, 1, 1)
	end
	DT.tooltip:AddDoubleLine(L["Total: "], E:FormatMoney(totalGold, E.db.datatexts.goldFormat or "BLIZZARD", not E.db.datatexts.goldCoins), 1, 1, 1, 1, 1, 1)

	ToggleCurrencies(true)
	
	if ARCHAEOLOGY ~= nil and GetOption('Archaeology') then
		GetCurrency(ArchaeologyFragments, T.string_format('%s %s:', ARCHAEOLOGY, ARCHAEOLOGY_RUNE_STONES))
	end
	--[[if COOKING ~= nil and GetOption('Cooking') then
		GetCurrency(CookingAwards, T.string_format("%s:", COOKING))
	end
	if JEWELCRAFTING ~= nil and GetOption('Jewelcrafting') then
		GetCurrency(JewelcraftingTokens, T.string_format("%s:", JEWELCRAFTING))
	end]]
	if GetOption('Raid') then
		GetCurrency(DungeonRaid, T.string_format("%s:", GROUP_FINDER))
	end
	if GetOption('PvP') then
		GetCurrency(PvPPoints, T.string_format("%s:", PLAYER_V_PLAYER))
	end
	if GetOption('Miscellaneous') then
		GetCurrency(MiscellaneousCurrency, T.string_format("%s:", MISCELLANEOUS))
	end
	if GetOption("BFA") then
		GetCurrency(BattleForAzertoh, T.string_format("%s:", L["Battle For Azeroth"]))
	end
	if GetOption("LEGION") then
		GetCurrency(Legion, T.string_format("%s:", L["Legion"]))
	end
	if GetOption("WOD") then
		GetCurrency(WarlordsOfDraenor, T.string_format("%s:", L["Warlords of Draenor"]))
	end
	if GetOption("MOP") then
		GetCurrency(MistsOfPandaria, T.string_format("%s:", L["Mists of Pandaria"]))
	end
	if GetOption("CATA") then
		GetCurrency(Cataclysm, T.string_format("%s:", L["Cataclysm"]))
	end
	if GetOption("WOLK") then
		GetCurrency(WrathOfTheLichKing, T.string_format("%s:", L["Wrath of the Lich King"]))
	end
	
	ToggleCurrencies(false)
	
	if E.db.KlixUI.currencyDT.WoWToken then
		local Token = T.C_WowTokenPublic_GetCurrentMarketPrice()
		if Token and WToken ~= "" then
			DT.tooltip:AddLine(' ')
			DT.tooltip:AddDoubleLine("|TInterface\\Icons\\WoW_Token01:14:14:0:0:64:64:4:60:4:60|t "..ITEM_QUALITY8_DESC, E:FormatMoney(Token, E.db.datatexts.goldFormat or "BLIZZARD", not E.db.datatexts.goldCoins), 1, 1, 1)
		end
	end
	
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddDoubleLine(L["Hold Shift + Right Click:"], L["Reset Data"], 0.7, 0.7, 1.0)
	DT.tooltip:Show()
end

DT:RegisterDatatext('Currency (KUI)', {'LOADING_SCREEN_DISABLED', 'PLAYER_MONEY', 'SEND_MAIL_MONEY_CHANGED', 'SEND_MAIL_COD_CHANGED', 'PLAYER_TRADE_MONEY', 'TRADE_MONEY_CHANGED', 'SPELLS_CHANGED'}, OnEvent, nil, Click, OnEnter)
