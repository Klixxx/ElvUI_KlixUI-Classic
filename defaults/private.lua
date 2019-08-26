local KUI, T, E, L, V, P, G = unpack(select(2, ...))

if V["KlixUI"] == nil then V["KlixUI"] = {} end

V['KlixUI'] = {
	-- General
	['install_complete'] = nil,
		['session'] = {
		['day'] = 1,
	},
	
	["characterGoldsSorting"] = {},
	
	-- Bags
	["bags"] = {
		["transparentSlots"] = true,
		["bagFilter"] = true,
		["autoOpen"] = false,
	},
	
	-- Blizzard
	["module"] = {
		["blizzmove"] = {
			["enable"] = true,
			["remember"] = false,
			["points"] = {},
		},
	},
	
	-- Equip Manager
	["equip"] = {
		["enable"] = true,
		["spam"] = false,
		["onlyTalent"] = true,
		["conditions"] = "",
		["setoverlay"] = true,
		["lockbutton"] = true,
	},
	
	-- Professions
	["professions"] = {
		["deconButton"] = {
			["enable"] = true,
			["style"] = "PIXEL",
			["buttonGlow"] = true,
		},
		["enchant"] = {
			["enchScroll"] = false,
		},
		["fishing"] = {
			["EasyCast"] = false,
			["FromMount"] = false,
			["UseLures"] = true,
			["IgnorePole"] = false,
			["CastButton"] = "Shift",
			["relureThreshold"] = 8,
		},
	},
	
	-- PvP
	["pvp"] = {
		["KBbanner"] = {
			["enable"] = false,
			["sound"] = true,
		},
	},
	
	-- Skins
	["skins"] = {
		["blizzard"] = {
			["character"] = true,
			["encounterjournal"] = true,
			["gossip"] = true,
			["quest"] = true,
			["questChoice"] = true,
			["spellbook"] = true,
			["orderhall"] = true,
			["talent"] = true,
			["auctionhouse"] = true,
			["barber"] = true,
			["friends"] = true,
			["garrison"] = true,
			["contribution"] = true,
			["artifact"] = true,
			["collections"] = true,
			["calendar"] = true,
			["merchant"] = true,
			["worldmap"] = true,
			["pvp"] = true,
			["achievement"] = true,
			["tradeskill"] = true,
			["lfg"] = true,
			["lfguild"] = true,
			["itemUpgrade"] = true,
			["talkinghead"] = true,
			["guild"] = true,
			["objectiveTracker"] = true,
			["Obliterum"] = true,
			["addonManager"] = true,
			["archaeology"] = true,
			["mail"] = true,
			["raid"] = true,
			["dressingroom"] = true,
			["timemanager"] = true,
			["blackmarket"] = true,
			["guildcontrol"] = true,
			["macro"] = true,
			["binding"] = true,
			["gbank"] = true,
			["taxi"] = true,
			["help"] = true,
			["loot"] = true,
			["warboard"] = true,
			["deathRecap"] = true,
			["questPOI"] = true,
			["voidstorage"] = true,
			["communities"] = true,
			["azerite"] = true,
			["azeriteRespec"] = true,
			["challenges"] = true,
			["channels"] = true,
			["IslandQueue"] = true,
			["IslandsPartyPose"] = true,
			["minimap"] = true,
			["Scrapping"] = true,
			["trainer"] = true,
			["debug"] = true,
			["inspect"] = true,
			["socket"] = true,
			["itemUpgrade"] = true,
			["trade"] = true,
			["AlliedRaces"] = true,
		},
		["addonSkins"] = {
			["abp"] = true,
			["ba"] = true,
			["bs"] = true,
			["bw"] = true,
			["dbm"] = true,
			["dtb"] = true,
			["ls"] = true,
			["pa"] = true,
			["pw"] = true,
			["sle"] = true,
			["wa"] = true,
			["xiv"] = true,
		},
		["vehicleButton"] = true,
	},
}