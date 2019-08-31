local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local QA = KUI:GetModule("QuestAuto")

local DEFAULT, MINIMIZE, HIDE, NONE = DEFAULT, MINIMIZE, HIDE, NONE
local GARRISON_LOCATION_TOOLTIP = GARRISON_LOCATION_TOOLTIP
local BATTLEGROUNDS, ARENA, DUNGEONS, RAIDS, SCENARIOS = BATTLEGROUNDS, ARENA, DUNGEONS, RAIDS, SCENARIOS

local settings = {
	["FULL"] = DEFAULT,
	["COLLAPSED"] = MINIMIZE,
	["HIDE"] = HIDE,
}

local function QuestTable()
	E.Options.args.KlixUI.args.modules.args.quest = {
		type = "group",
		order = 23,
		name = L["Quest"],
		childGroups = "tab",
		get = function(info) return E.db.KlixUI.quest[ info[#info] ] end,
		set = function(info, value) E.db.KlixUI.quest[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = KUI:cOption(L["Quest"]),
			},
			auto = {
				order = 3,
				type = "group",
				name = L["Auto Pilot"],
				disabled = function() return T.IsAddOnLoaded("AAP-Classic") or T.IsAddOnLoaded("Guidelime") end,
				get = function(info) return E.db.KlixUI.quest.auto[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.quest.auto[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					intro = {
						order = 1,
						type = 'description',
						name = L["AP_DESC"],
					},
					enable = {
						order = 2,
						type = "toggle",
						name = L["Enable"],
					},
					diskey = {
						order = 3,
						type = "select",
						name = L["Disable Key"],
						desc = L["When the specific key is down the quest automatization is disabled."],
						disabled = function() return not E.db.KlixUI.quest.auto.enable end,
						values = { "Alt", "Ctrl", "Shift" },
					},
					space1 = {
						order = 4,
						type = 'description',
						name = '',
					},
					accept = {
						order = 5,
						type = "toggle",
						name = L["Auto Accept Quests"],
						desc = L["Enable/Disable auto quest accepting"],
						disabled = function() return not E.db.KlixUI.quest.auto.enable end,
					},
					complete = {
						order = 6,
						type = "toggle",
						name = L["Auto Complete Quests"],
						desc = L["Enable/Disable auto quest complete"],
						disabled = function() return not E.db.KlixUI.quest.auto.enable end,
					},
					dailiesonly = {
						order = 7,
						type = "toggle",
						name = L["Dailies Only"],
						desc = L["Enable/Disable auto accepting for daily quests only"],
						disabled = function() return not E.db.KlixUI.quest.auto.enable end,
					},
					pvp = {
						order = 8,
						type = "toggle",
						name = L["Accept PVP Quests"],
						desc = L["Enable/Disable auto accepting for PvP flagging quests"],
						disabled = function() return not E.db.KlixUI.quest.auto.enable end,
					},
					escort = {
						order = 9,
						type = "toggle",
						name = L["Auto Accept Escorts"],
						desc = L["Enable/Disable auto escort accepting"],
						disabled = function() return not E.db.KlixUI.quest.auto.enable end,
					},
					inraid = {
						order = 10,
						type = "toggle",
						name = L["Enable in Raid"],
						desc = L["Enable/Disable auto accepting quests in raid"],
						disabled = function() return not E.db.KlixUI.quest.auto.enable end,
					},
					greeting = {
						order = 11,
						type = "toggle",
						name = L["Skip Greetings"],
						desc = L["Enable/Disable NPC's greetings skip for one or more quests"],
						disabled = function() return not E.db.KlixUI.quest.auto.enable end,
					},
					reward = {
						order = 12,
						type = "toggle",
						name = L["Auto Select Quest Reward"],
						desc = L["Automatically select the quest reward with the highest vendor sell value."],
						disabled = function() return not E.db.KlixUI.quest.auto.enable end,
					},
				},
			},
		},
	}
end
T.table_insert(KUI.Config, QuestTable)