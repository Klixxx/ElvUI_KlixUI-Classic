local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local QA = KUI:GetModule("QuestAuto");
local SQT = KUI:GetModule("SmartQuestTracker");
local QT = KUI:GetModule("QuestTracker");

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
			objectiveProgress = {
				order = 2,
				type = "toggle",
				name = L["Objective Progress"],
				desc = L["Adds quest/mythic+ dungeon progress to the tooltip."],
				
			},
			auto = {
				order = 3,
				type = "group",
				name = L["Auto Pilot"],
				disabled = function() return T.IsAddOnLoaded("AAP-Core") end,
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
			announce = {
				order = 4,
				type = "group",
				name = L["Quest Announce"],
				get = function(info) return E.db.KlixUI.quest.announce[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.quest.announce[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					intro = {
						order = 1,
						type = 'description',
						name = L["This section enables the quest announcement module which will alert you when a quest is completed."],
					},
					enable = {
						order = 2,
						type = "toggle",
						name = L["Enable"],
					},
					space1 = {
						order = 3,
						type = 'description',
						name = '',
					},
					space2 = {
						order = 4,
						type = 'description',
						name = '',
					},
					noDetail = {
						order = 5,
						type = "toggle",
						name = L["No Detail"],
						disabled = function() return not E.db.KlixUI.quest.announce.enable end,
					},
					instance = {
						order = 6,
						type = "toggle",
						name = L["Instance"],
						disabled = function() return not E.db.KlixUI.quest.announce.enable end,
					},
					raid = {
						order = 7,
						type = "toggle",
						name = L["Raid"],
						disabled = function() return not E.db.KlixUI.quest.announce.enable end,
					},
					party = {
						order = 8,
						type = "toggle",
						name = L["Party"],
						disabled = function() return not E.db.KlixUI.quest.announce.enable end,
					},
					solo = {
						order = 9,
						type = "toggle",
						name = L["Solo"],
						disabled = function() return not E.db.KlixUI.quest.announce.enable end,
					},
					ignore_supplies = {
						order = 10,
						type = "toggle",
						name = L["Ignore supplies quest"],
						disabled = function() return not E.db.KlixUI.quest.announce.enable end,
					},
				},
		    },
			smart = {
				type = "group",
				order = 5,
				name = L["Smart Quest Tracker"],
				get = function(info) return E.db.KlixUI.quest.smart[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.quest.smart[ info[#info] ] = value; SQT:Update() end,
				args = {
					intro = {
						order = 1,
						type = 'description',
						name = L["This section modify the ObjectiveTracker to only display your quests available for completion in your current zone."],
					},
					enable = {
						order = 2,
						type = "toggle",
						name = L["Enable"],
						set = function(info, value) E.db.KlixUI.quest.smart.enable = value; E:StaticPopup_Show("PRIVATE_RL"); end,
					},
					clear = {
						order = 3,
						type = "group",
						name = L['Untrack quests when changing area'],
						guiInline = true,
						disabled = function() return not E.db.KlixUI.quest.smart.enable end,
						args = {
							removecomplete = {
								order = 1,
								type = "toggle",
								name = L["Completed quests"],
								get = function(info)
									return E.db.KlixUI.quest.smart.RemoveComplete
								end,
								set = function(info, value)
									E.db.KlixUI.quest.smart.RemoveComplete = value
									SQT:Update()
								end,
							},
							autoremove = {
								order = 2,
								type = "toggle",
								name = L["Quests from other areas"],
								get = function(info)
									return E.db.KlixUI.quest.smart.AutoRemove
								end,
								set = function(info, value)
									E.db.KlixUI.quest.smart.AutoRemove = value
									SQT:Update()
								end,
							},
							showDailies = {
								order = 3,
								type = "toggle",
								name = L["Keep daily and weekly quest tracked"],
								get = function(info)
									return E.db.KlixUI.quest.smart.ShowDailies
								end,
								set = function(info, value)
									E.db.KlixUI.quest.smart.ShowDailies = value
									SQT:Update()
								end,
							},
						},
					},
					sort = {
						order = 4,
						type = "group",
						name = L['Sorting of quests in tracker'],
						guiInline = true,
						disabled = function() return not E.db.KlixUI.quest.smart.enable end,
						args = {
							autosort = {
								order = 1,
								type = "toggle",
								name = L["Automatically sort quests"],
								get = function(info)
									return E.db.KlixUI.quest.smart.AutoSort
								end,
								set = function(info, value)
									E.db.KlixUI.quest.smart.AutoSort = value
									SQT:Update()
								end,
							},
						},
					},
					debug = {
						order = 5,
						type = "group",
						name = L["Debug"],
						guiInline = true,
						disabled = function() return not E.db.KlixUI.quest.smart.enable end,
						args = {
							print = {
								type = 'execute',
								buttonElvUI = true,
								order = 2,
								name = L["Print all quests to chat"],
								func = function() SQT:debugPrintQuestsHelper(false) end,
							},
							printWatched = {
								type = 'execute',
								buttonElvUI = true,
								order = 3,
								name = L["Print tracked quests to chat"],
								func = function() SQT:debugPrintQuestsHelper(true) end,
							},
							untrack = {
								type = 'execute',
								buttonElvUI = true,
								order = 1,
								name = L["Untrack all quests"],
								func = function() SQT:untrackAllQuests() end,
							},
							update = {
								type = 'execute',
								buttonElvUI = true,
								order = 4,
								name = L["Force update of tracked quests"],
								func = function() SQT:run_update() end,
							},
						},
					},
				},
			},
			tracker = {
				type = "group",
				order = 6,
				name = L["Quest Tracker Visibility"],
				get = function(info) return E.db.KlixUI.quest.visibility[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.quest.visibility[ info[#info] ] = value; QT:ChangeState() end,
				args = {
					intro = {
						order = 1,
						type = 'description',
						name = L["Adjust the settings for the visibility of the questtracker (questlog) to your personal preference."],
					},
					enable = {
						order = 2,
						type = "toggle",
						name = L["Enable"],
					},
					space1 = {
						order = 3,
						type = "description",
						name = "",
					},
					rested = {
						order = 4,
						type = "select",
						name = L["Rested"],
						disabled = function() return not E.db.KlixUI.quest.visibility.enable end,
						values = settings,
					},
					garrison = {
						order = 5,
						type = "select",
						name = GARRISON_LOCATION_TOOLTIP,
						disabled = function() return not E.db.KlixUI.quest.visibility.enable end,
						values = settings,
					},
					orderhall = {
						order = 6,
						type = "select",
						name = L["Class Hall"],
						disabled = function() return not E.db.KlixUI.quest.visibility.enable end,
						values = settings,
					},
					bg = {
						order = 7,
						type = "select",
						name = BATTLEGROUNDS,
						disabled = function() return not E.db.KlixUI.quest.visibility.enable end,
						values = settings,
					},
					arena = {
						order = 8,
						type = "select",
						name = ARENA,
						disabled = function() return not E.db.KlixUI.quest.visibility.enable end,
						values = settings,
					},
					dungeon = {
						order = 9,
						type = "select",
						name = DUNGEONS,
						disabled = function() return not E.db.KlixUI.quest.visibility.enable end,
						values = settings,
					},
					scenario = {
						order = 10,
						type = "select",
						name = SCENARIOS,
						disabled = function() return not E.db.KlixUI.quest.visibility.enable end,
						values = settings,
					},
					raid = {
						order = 11,
						type = "select",
						name = RAIDS,
						disabled = function() return not E.db.KlixUI.quest.visibility.enable end,
						values = settings,
					},
					combat = {
						order = 12,
						type = "select",
						name = COMBAT,
						disabled = function() return not E.db.KlixUI.quest.visibility.enable end,
						values = {
							["FULL"] = DEFAULT,
							["COLLAPSED"] = MINIMIZE,
							["HIDE"] = HIDE,
							["NONE"] = NONE,
						},
					},
				},	
			},
		},
	}
end
T.table_insert(KUI.Config, QuestTable)