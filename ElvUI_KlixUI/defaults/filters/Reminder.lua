local KUI, T, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--Lua functions

--WoW API / Variables

-- Global variables that we don"t cache, list them here for the mikk"s Find Globals script
-- GLOBALS:

KUI.ReminderList = {
	DRUID = {
		["MarkOfTheWild"] = {
			["spellGroup"] = {
				[9884] = true,
				["defaultIcon"] = 9884, -- Mark of the Wild
			},
			["enable"] = true,
			["instance"] = true,
			["pvp"] = true,
			["strictFilter"] = true,
		},
	},
	
	MAGE = {
		["Intellect"] = {
			["spellGroup"] = {
				[23028] = true,
				["defaultIcon"] = 23028, -- Arcane Brilliance
			},
			["enable"] = true,
			["instance"] = true,
			["pvp"] = true,
			["strictFilter"] = true,
		},
	},

	PALADIN = {
		["BlessingKings"] = {
			["spellGroup"] = {
				[203538] = true,
				[203539] = true,
				["defaultIcon"] = 203538, -- Greater Blessings of Kings
			},
			["enable"] = true,
			["instance"] = true,
			["pvp"] = true,
			["strictFilter"] = true,
			["tree"] = 3,
		},
	},

	PRIEST = {
		["Stamina"] = {
			["spellGroup"] = {
				[21564] = true,
				["defaultIcon"] = 21564, -- Prayer of Fortitude
			},
			["enable"] = true,
			["instance"] = true,
			["pvp"] = true,
			["strictFilter"] = true,
		},
	},
	
	WARLOCK = {
		["Stamina"] = {
			["spellGroup"] = {
				[11767] = true, -- Blood Pact
				["defaultIcon"] = 11767,
			},
			["enable"] = true,
			["instance"] = true,
			["pvp"] = true,
			["strictFilter"] = true,
		},
	},
	
	WARRIOR = {
		["AttackPower"] = {
			["spellGroup"] = {
				[6673] = true, -- Battle Shout
				["defaultIcon"] = 6673,
			},
			["enable"] = true,
			["instance"] = true,
			["pvp"] = true,
			["strictFilter"] = true,
		},
	},
}