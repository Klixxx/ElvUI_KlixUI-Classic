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
			["addonManager"] = true,
			["auctionhouse"] = true,
			["bags"] = true,
			["battlefield"] = true,
			["bgmap"] = true,
			["bgscore"] = true,
			["binding"] = true,
			["channels"] = true,
			["character"] = true,
			["communities"] = true,
			["craft"] = true,
			["debug"] = true,
			["dressingroom"] = true,
			["friends"] = true,
			["gmchat"] = true,
			["gossip"] = true,
			["guildregistrar"] = true,
			["help"] = true,
			["inspect"] = true,
			["loot"] = true,
			["macro"] = true,
			["mail"] = true,
			["merchant"] = true,
			["minimap"] = true,
			["petition"] = true,
			["quest"] = true,
			["raid"] = true,
			["spellbook"] = true,
			["stable"] = true,
			["tabard"] = true,
			["talent"] = true,
			["taxi"] = true,
			["timemanager"] = true,
			["trade"] = true,
			["tradeskill"] = true,
			["trainer"] = true,
			["worldmap"] = true,
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