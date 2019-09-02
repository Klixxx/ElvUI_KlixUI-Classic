local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local LP = KUI:GetModule("LocPanel")

local CLASS, CUSTOM, DEFAULT = CLASS, CUSTOM, DEFAULT

local function LocPanelTable()
	E.Options.args.KlixUI.args.modules.args.locPanel = {
		type = "group",
		name = L["Location Panel"],
		order = 15,
		childGroups = "tab",
		disabled = function() return T.IsAddOnLoaded("ElvUI_LocationPlus") end,
		hidden = function() return T.IsAddOnLoaded("ElvUI_LocationPlus") end,
		get = function(info) return E.db.KlixUI.locPanel[ info[#info] ] end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = KUI:cOption(L["Location Panel"]),
			},
			general = {
				order = 2,
				type = "group",
				name = L["General"],
				args = {
					enable = {
						type = "toggle",
						name = L["Enable"],
						order = 1,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:Toggle() end,
					},
					style = {
						order = 2,
						type = "toggle",
						name = L["|cfff960d9KlixUI|r Style"],
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					space1 = {
						order = 3,
						type = "description",
						name = "",
					},
					linkcoords = {
						type = "toggle",
						name = L["Link Position"],
						desc = L["Allow pasting of your coordinates in chat editbox via holding shift and clicking on the location name."],
						order = 4,
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; end,
					},
					template = {
						order = 5,
						name = L["Template"],
						type = "select",
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:Template() end,
						values = {
							["Default"] = DEFAULT,
							["Transparent"] = L["Transparent"],
							["NoBackdrop"] = L["NoBackdrop"],
						},
					},
					autowidth = {
						type = "toggle",
						name = L["Auto Width"],
						desc = L["Change width based on the zone name length."],
						order = 6,
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:Resize() end,
					},
					width = {
						order = 7,
						type = "range",
						name = L["Width"],
						min = 100, max = E.screenwidth/2, step = 1,
						disabled = function() return not E.db.KlixUI.locPanel.enable or E.db.KlixUI.locPanel.autowidth end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:Resize() end,
					},
					height = {
						order = 8,
						type = "range",
						name = L["Height"],
						min = 10, max = 50, step = 1,
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:Resize() end,
					},
					spacing = {
						order = 9,
						type = "range",
						name = L["Spacing"],
						min = -1, max = 5, step = 1,
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:HideCoords() end,
					},
					throttle = {
						order = 10,
						type = "range",
						name = L["Update Throttle"],
						desc = L["The frequency of coordinates and zonetext updates. Check will be done more often with lower values."],
						min = 0.1, max = 2, step = 0.1,
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; end,
					},
					combathide = {
						order = 11,
						type = "toggle",
						name = L["Hide In Combat"],
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; end,
					},
					orderhallhide = {
						order = 12,
						type = "toggle",
						name = L["Hide In Orderhall"],
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:Toggle() end,
					},
					blizzText = {
						order = 13,
						name = L["Hide Blizzard Zone Text"],
						type = 'toggle',
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:ToggleBlizZoneText() end,					
					},
					mouseover = {
						order = 14,
						name = L["Mouse Over"],
						desc = L["The frame is not shown unless you mouse over the frame"],
						type = 'toggle',
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,						
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:MouseOver() end,					
					},
					malpha = {
						order = 15,
						type = "range",
						name = L["Alpha"],
						desc = L["Change the alpha level of the frame."],
						min = 0, max = 1, step = 0.1,
						disabled = function() return not E.db.KlixUI.locPanel.mouseover or not E.db.KlixUI.locPanel.enable end,
						hidden = function() return not E.db.KlixUI.locPanel.enable end,	
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:MouseOver() end,
					},
				},
			},
			location = {
				order = 20,
				type = "group",
				name = L["Location"],
				hidden = function() return not E.db.KlixUI.locPanel.enable end,
				args = {
					zoneText = {
						type = "toggle",
						name = L["Full Location"],
						order = 1,
						disabled = function() return not  E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; end,
					},
					colorType = {
						order = 2,
						name = L["Color Type"],
						type = "select",
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; end,
						values = {
							["REACTION"] = L["Reaction"],
							["DEFAULT"] = DEFAULT,
							["CLASS"] = CLASS,
							["CUSTOM"] = CUSTOM,
						},
					},
					customColor = {
						type = "color",
						order = 3,
						name = L["Custom Color"],
						disabled = function() return not E.db.KlixUI.locPanel.enable or not E.db.KlixUI.locPanel.colorType == "CUSTOM" end,
						get = function(info)
							local t = E.db.KlixUI.locPanel[ info[#info] ]
							local d = P.KlixUI.locPanel[info[#info]]
							return t.r, t.g, t.b, d.r, d.g, d.b
						end,
						set = function(info, r, g, b)
							E.db.KlixUI.locPanel[ info[#info] ] = {}
							local t = E.db.KlixUI.locPanel[ info[#info] ]
							t.r, t.g, t.b = r, g, b
						end,
					},
				},
			},
			coordinates = {
				order = 21,
				type = "group",
				name = L["Coordinates"],
				hidden = function() return not E.db.KlixUI.locPanel.enable end,
				args = {
					format = {
						order = 1,
						name = L["Format"],
						type = "select",
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; end,
						values = {
							["%.0f"] = DEFAULT,
							["%.1f"] = "45.3",
							["%.2f"] = "45.34",
						},
					},
					colorType_Coords = {
						order = 2,
						name = L["Color Type"],
						type = "select",
						disabled = function() return not E.db.KlixUI.locPanel.enable end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; end,
						values = {
							["REACTION"] = L["Reaction"],
							["DEFAULT"] = DEFAULT,
							["CLASS"] = CLASS,
							["CUSTOM"] = CUSTOM,
						},
					},
					customColor_Coords = {
						type = "color",
						order = 3,
						name = L["Custom Color"],
						disabled = function() return not E.db.KlixUI.locPanel.enable or not E.db.KlixUI.locPanel.colorType_Coords == "CUSTOM" end,
						get = function(info)
							local t = E.db.KlixUI.locPanel[ info[#info] ]
							local d = P.KlixUI.locPanel[info[#info]]
							return t.r, t.g, t.b, d.r, d.g, d.b
						end,
						set = function(info, r, g, b)
							E.db.KlixUI.locPanel[ info[#info] ] = {}
							local t = E.db.KlixUI.locPanel[ info[#info] ]
							t.r, t.g, t.b = r, g, b
						end,
					},
					hidecoords = {
						order = 4,
						name = L["Hide Coords"],
						desc = L["Show/Hide the coord frames"],
						type = 'toggle',
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:HideCoords() end,					
					},
					hidecoordsInInstance = {
						order = 5,
						name = L["Hide Coords in Instance"],
						type = 'toggle',
						disabled = function() return E.db.KlixUI.locPanel.hidecoords end,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:HideCoords() end,					
					},
				},
			},
			fontGroup = {
				order = 22,
				type = "group",
				name = L["Fonts"],
				disabled = function() return not E.db.KlixUI.locPanel.enable end,
				hidden = function() return not E.db.KlixUI.locPanel.enable end,
				get = function(info) return E.db.KlixUI.locPanel[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:Fonts() end,
				args = {
					font = {
						type = "select", dialogControl = "LSM30_Font",
						order = 1,
						name = L["Font"],
						values = AceGUIWidgetLSMlists.font,
					},
					fontSize = {
						order = 2,
						name = L["Font Size"],
						type = "range",
						min = 6, max = 22, step = 1,
						set = function(info, value) E.db.KlixUI.locPanel[ info[#info] ] = value; LP:Fonts(); LP:Resize() end,
					},
					fontOutline = {
						order = 3,
						name = L["Font Outline"],
						type = "select",
						values = {
							["NONE"] = L["None"],
							["OUTLINE"] = "OUTLINE",
							["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
							["THICKOUTLINE"] = "THICKOUTLINE",
						},
					},
				},
			},
			tooltip = {
				order = 24,
				type = "group",
				name =  L["Tooltip"],
				disabled = function() return not E.db.KlixUI.locPanel.enable end,
				hidden = function() return not E.db.KlixUI.locPanel.enable end,
				get = function(info) return E.db.KlixUI.locPanel.tooltip[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.locPanel.tooltip[ info[#info] ] = value; end,						
				args = {			
					enable = {
						order = 1,
						name = L["Show/Hide tooltip"],
						type = 'toggle',
					},
					combathide = {
						order = 2,
						name = L["Combat Hide"],
						desc = L["Hide tooltip while in combat."],
						type = 'toggle',
						disabled = function() return not E.db.KlixUI.locPanel.tooltip.enable end,			
					},
					hint = {
						order = 3,
						name = L["Show Hints"],
						desc = L["Enable/Disable hints on Tooltip."],
						type = 'toggle',
						disabled = function() return not E.db.KlixUI.locPanel.tooltip.enable end,			
					},
					status = {
						order = 4,
						name = STATUS,
						desc = L["Enable/Disable status on Tooltip."],
						type = 'toggle',
						width = "full",
						disabled = function() return not E.db.KlixUI.locPanel.tooltip.enable end,			
					},
				},
			},
		},
	}
end
T.table_insert(KUI.Config, LocPanelTable)