local KUI, T, E, L, V, P, G = unpack(select(2, ...))
--local KRR = KUI:GetModule("KuiRaidReminder")
local KSR = KUI:GetModule("KuiSoloReminder")

local DEFAULT, CUSTOM, AGGRO_WARNING_IN_PARTY = DEFAULT, CUSTOM, AGGRO_WARNING_IN_PARTY

local function Reminder()
	E.Options.args.KlixUI.args.modules.args.reminder = {
		type = "group",
		name = L["Reminders"],
		order = 28,
		args = {
			name = {
				order = 1,
				type = "header",
				name = KUI:cOption(L["Reminders"]),
			},
			solo = {
				order = 2,
				type = "group",
				name = L["Solo"],
				guiInline = true,
				get = function(info) return E.db.KlixUI.reminder.solo[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.reminder.solo[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						desc = L["Reminds you on self Buffs."],
					},
					space1 = {
						order = 2,
						type = 'description',
						name = "",
					},
					space2 = {
						order = 3,
						type = 'description',
						name = "",
					},
					size = {
						order = 4,
						type = "range",
						name = L["Size"],
						min = 10, max = 60, step = 1,
						disabled = function() return not E.db.KlixUI.reminder.solo.enable end,
					},
					strata = {
						order = 5,
						type = "select",
						name = L["Frame Strata"],
						values = {
							["BACKGROUND"] = "BACKGROUND",
							["LOW"] = "LOW",
							["MEDIUM"] = "MEDIUM",
							["HIGH"] = "HIGH",
							["DIALOG"] = "DIALOG",
							["TOOLTIP"] = "TOOLTIP",
						},
						disabled = function() return not E.db.KlixUI.reminder.solo.enable end,
					},
					glow = {
						order = 6,
						type = "toggle",
						name = L["Glow"],
						desc = L["Shows the pixel glow on missing buffs."],
						disabled = function() return not E.db.KlixUI.reminder.solo.enable end,
					},
				},
			},
			--[[raid = {
				order = 3,
				type = "group",
				name = L["Raid"],
				guiInline = true,
				get = function(info) return E.db.KlixUI.reminder.raid[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.reminder.raid[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Shows a frame with flask/food/rune."],
						set = function(info, value) E.db.KlixUI.reminder.raid.enable = value; KRR:Visibility() end,
					},
					space1 = {
						order = 2,
						type = 'description',
						name = "",
					},
					space2 = {
						order = 3,
						type = 'description',
						name = "",
					},
					backdrop = {
						type = 'toggle',
						order = 4,
						name = L["Backdrop"],
						desc = L["Toggles the display of the raidbuffs backdrop."],
						disabled = function() return not E.db.KlixUI.reminder.raid.enable end,
						set = function(info, value) E.db.KlixUI.reminder.raid.backdrop = value; KRR:Backdrop() end,
					},
					size = {
						order = 5,
						type = 'range',
						name = L["Size"],
						desc = L["Changes the size of the icons."],
						min = 10, max = 50, step = 1,
						disabled = function() return not E.db.KlixUI.reminder.raid.enable end,
					},
					alpha = {
						order = 6,
						type = "range",
						name = L["Alpha"],
						desc = L["Change the alpha level of the icons."],
						min = 0, max = 1, step = 0.1,
						disabled = function() return not E.db.KlixUI.reminder.raid.enable end,
					},
					class = {
						order = 7,
						type = "toggle",
						name = L["Class Specific Buffs"],
						desc = L["Shows all the class specific raidbuffs."],
						disabled = function() return not E.db.KlixUI.reminder.raid.enable end,
					},
					glow = {
						order = 8,
						type = "toggle",
						name = L["Glow"],
						desc = L["Shows the pixel glow on missing raidbuffs."],
						disabled = function() return not E.db.KlixUI.reminder.raid.enable end,
					},
					visibility = {
						type = 'select',
						order = 9,
						name = L["Visibility"],
						disabled = function() return not E.db.KlixUI.reminder.raid.enable end,
						set = function(info, value) E.db.KlixUI.reminder.raid.visibility = value; KRR:Visibility() end,
						values = {
							["DEFAULT"] = DEFAULT,
							["INPARTY"] = AGGRO_WARNING_IN_PARTY,
							["ALWAYS"] = L["Always Display"],
							["CUSTOM"] = CUSTOM,
						},
					},
					customVisibility = {
						order = 15,
						type = 'input',
						width = 'full',
						name = L["Visibility State"],
						disabled = function() return E.db.KlixUI.reminder.raid.visibility ~= "CUSTOM" or not E.db.KlixUI.reminder.raid.enable end,
						set = function(info, value) E.db.KlixUI.reminder.raid.customVisibility = value; KRR:Visibility() end,
					},
				},
			},]]
		},
	}
end
T.table_insert(KUI.Config, Reminder)