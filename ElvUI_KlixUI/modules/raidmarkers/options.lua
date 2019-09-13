local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local RMA = KUI:GetModule("RaidMarkers")

local SHIFT_KEY, CTRL_KEY, ALT_KEY = SHIFT_KEY, CTRL_KEY, ALT_KEY
local AGGRO_WARNING_IN_PARTY = AGGRO_WARNING_IN_PARTY
local CUSTOM, DEFAULT = CUSTOM, DEFAULT

local texPathAn = [[Interface\AddOns\ElvUI_KlixUI\media\textures\raidmarkers\anime\]]
local texPathAu = [[Interface\AddOns\ElvUI_KlixUI\media\textures\raidmarkers\aurora\]]
local texPathM = [[Interface\AddOns\ElvUI_KlixUI\media\textures\raidmarkers\myth\]]
local texPathC = [[Interface\TargetingFrame\]]

local function RaidMarkers()
	E.Options.args.KlixUI.args.modules.args.raidmarkers = {
		type = "group",
		name = L["Raid Markers"],
		order = 25,
		get = function(info) return E.db.KlixUI.raidmarkers[ info[#info] ] end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = KUI:cOption(L["Raid Markers"]),
			},
			marksheader = {
				order = 2,
				type = "group",
				name = L["Raid Markers"],
				args = {
					info = {
						order = 1,
						type = "description",
						name = L["Options for panels providing fast access to raid markers and flares."],
						},
					enable = {
						order = 2,
						type = "toggle",
						name = L["Enable"],
						desc = L["Show/Hide raid marks."],
						set = function(info, value) E.db.KlixUI.raidmarkers.enable = value; RMA:Visibility() end,
					},
					reset = {
						order = 3,
						type = 'execute',
						name = L["Restore Defaults"],
						desc = L["Reset these options to defaults"],
						disabled = function() return not E.db.KlixUI.raidmarkers.enable end,
						hidden = function() return not E.db.KlixUI.raidmarkers.enable end,
						func = function() KUI:Reset("marks") end,
					},
					space1 = {
						order = 4,
						type = "description",
						name = "",
					},
					backdrop = {
						type = 'toggle',
						order = 5,
						name = L["Backdrop"],
						disabled = function() return not E.db.KlixUI.raidmarkers.enable end,
						hidden = function() return not E.db.KlixUI.raidmarkers.enable end,
						set = function(info, value) E.db.KlixUI.raidmarkers.backdrop = value; RMA:Backdrop() end,
					},
					buttonSize = {
						order = 6,
						type = 'range',
						name = L["Button Size"],
						min = 16, max = 40, step = 1,
						disabled = function() return not E.db.KlixUI.raidmarkers.enable end,
						hidden = function() return not E.db.KlixUI.raidmarkers.enable end,
						set = function(info, value) E.db.KlixUI.raidmarkers.buttonSize = value; RMA:UpdateBar() end,
					},
					spacing = {
						order = 7,
						type = 'range',
						name = L["Button Spacing"],
						min = -4, max = 10, step = 1,
						disabled = function() return not E.db.KlixUI.raidmarkers.enable end,
						hidden = function() return not E.db.KlixUI.raidmarkers.enable end,
						set = function(info, value) E.db.KlixUI.raidmarkers.spacing = value; RMA:UpdateBar() end,
					},
					orientation = {
						order = 8,
						type = 'select',
						name = L["Orientation"],
						disabled = function() return not E.db.KlixUI.raidmarkers.enable end,
						hidden = function() return not E.db.KlixUI.raidmarkers.enable end,
						set = function(info, value) E.db.KlixUI.raidmarkers.orientation = value; RMA:UpdateBar() end,
						values = {
							["HORIZONTAL"] = L["Horizontal"],
							["VERTICAL"] = L["Vertical"],
						},
					},
					reverse = {
						type = 'toggle',
						order = 9,
						name = L["Reverse"],
						disabled = function() return not E.db.KlixUI.raidmarkers.enable end,
						hidden = function() return not E.db.KlixUI.raidmarkers.enable end,
						set = function(info, value) E.db.KlixUI.raidmarkers.reverse = value; RMA:UpdateBar() end,
					},
					modifier = {
						order = 10,
						type = 'select',
						name = L["Modifier Key"],
						desc = L["Set the modifier key for placing world markers."],
						disabled = function() return not E.db.KlixUI.raidmarkers.enable end,
						hidden = function() return not E.db.KlixUI.raidmarkers.enable end,
						set = function(info, value) E.db.KlixUI.raidmarkers.modifier = value; RMA:UpdateWorldMarkersAndTooltips() end,
						values = {
							["shift-"] = SHIFT_KEY,
							["ctrl-"] = CTRL_KEY,
							["alt-"] = ALT_KEY,
						},
					},
					mouseover = {
						order = 11,
						type = "toggle",
						name = L["Mouseover"],
						disabled = function() return not E.db.KlixUI.raidmarkers.enable end,
						hidden = function() return not E.db.KlixUI.raidmarkers.enable end,
						set = function(info, value) E.db.KlixUI.raidmarkers.mouseover = value; RMA:UpdateMouseover() end,
					},
					notooltip = {
						order = 12,
						type = "toggle",
						name = L["No tooltips"],
						disabled = function() return not E.db.KlixUI.raidmarkers.enable end,
						hidden = function() return not E.db.KlixUI.raidmarkers.enable end,
						set = function(info, value) E.db.KlixUI.raidmarkers.notooltip = value; end,
					},
					raidicons = {
						order = 13,
						type = "select",
						name = L["Raid Marker Icons"],
						desc = L["Choose what Raid Marker Icon Set the bar will display."],
						get = function(info) return E.db.KlixUI.raidmarkers.raidicons end,
						set = function(info, value) E.db.KlixUI.raidmarkers.raidicons = value; E:StaticPopup_Show('PRIVATE_RL'); end,
						values = {
							["Classic"] = "Classic:  ".."|T"..texPathC.."UI-RaidTargetingIcon_8:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPathC.."UI-RaidTargetingIcon_7:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPathC.."UI-RaidTargetingIcon_6:15:15:0:0:64:64:2:56:2:56|t ",
							["Anime"] = "Anime:  ".."|T"..texPathAn.."UI-RaidTargetingIcon_8:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPathAn.."UI-RaidTargetingIcon_7:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPathAn.."UI-RaidTargetingIcon_6:15:15:0:0:64:64:2:56:2:56|t ",
							["Aurora"] = "Aurora:  ".."|T"..texPathAu.."UI-RaidTargetingIcon_8:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPathAu.."UI-RaidTargetingIcon_7:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPathAu.."UI-RaidTargetingIcon_6:15:15:0:0:64:64:2:56:2:56|t ",
							["Myth"] = "Myth:  ".."|T"..texPathM.."UI-RaidTargetingIcon_8:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPathM.."UI-RaidTargetingIcon_7:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPathM.."UI-RaidTargetingIcon_6:15:15:0:0:64:64:2:56:2:56|t ",
						},
					},
					visibility = {
						type = 'select',
						order = 14,
						name = L["Visibility"],
						disabled = function() return not E.db.KlixUI.raidmarkers.enable end,
						hidden = function() return not E.db.KlixUI.raidmarkers.enable end,
						set = function(info, value) E.db.KlixUI.raidmarkers.visibility = value; RMA:Visibility() end,
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
						disabled = function() return E.db.KlixUI.raidmarkers.visibility ~= "CUSTOM" or not E.db.KlixUI.raidmarkers.enable end,
						hidden = function() return not E.db.KlixUI.raidmarkers.enable end,
						set = function(info, value) E.db.KlixUI.raidmarkers.customVisibility = value; RMA:Visibility() end,
					},
				},
			},
			quickmark = {
				order = 3,
				type = "group",
				name = L["Quick Mark"],
				get = function(info) return E.db.KlixUI.raidmarkers.quickmark[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.raidmarkers.quickmark[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						width = 'full',
						name = L["Enable"],
						desc = L["Show the quick mark dropdown when pressing the specific key combination chosen below."],
					},
					markingButton1 = {
						order = 2,
						type = "select",
						name = L["RaidMarkingButton"]..'1',
						disabled = function() return not E.db.KlixUI.raidmarkers.quickmark.enable end,
						values = {
							['ctrl'] = "Ctrl",
							['alt'] = "Alt",
							['shift'] = "Shift",
						},
					},
					markingButton2 = {
						order = 3,
						type = "select",
						name = L["RaidMarkingButton"]..'2',
						disabled = function() return not E.db.KlixUI.raidmarkers.quickmark.enable end,
						values = {
							["LeftButton"] = L["MouseButton1"],
							["RightButton"] = L["MouseButton2"],
						},
					},
				},
			},
		},
	}
end
T.table_insert(KUI.Config, RaidMarkers)