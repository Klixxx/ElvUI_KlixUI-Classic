local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KAB = KUI:GetModule('KUIActionbars')
local MB = KUI:GetModule("MicroBar")

local function abTable()
	E.Options.args.KlixUI.args.modules.args.actionbars = {
		order = 1,
		type = 'group',
		name = L['ActionBars'],
		childGroups = 'tab',
		args = {
			name = {
				order = 1,
				type = 'header',
				name = KUI:cOption(L['ActionBars']),
			},
			microBar = {
				order = 2,
				type = "group",
				name = L["Micro Bar"],
				get = function(info) return E.db.KlixUI.microBar[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.microBar[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L['Show/Hide the |cfff960d9KlixUI|r MicroBar.'],
					},
					space1 = {
						order = 2,
						type = "description",
						name = "",
					},
					space2 = {
						order = 3,
						type = "description",
						name = "",
					},
					scale = {
						order = 4,
						type = "range",
						name = L["Microbar Scale"],
						isPercent = true,
						min = 0.5, max = 1.0, step = 0.01,
						disabled = function() return not E.db.KlixUI.microBar.enable end,
						hidden = function() return not E.db.KlixUI.microBar.enable end,
					},
					hideInCombat = {
						order = 5,
						type = "toggle",
						name = L["Hide In Combat"],
						desc = L['Show/Hide the |cfff960d9KlixUI|r MicroBar in combat.'],
						disabled = function() return not E.db.KlixUI.microBar.enable end,
						hidden = function() return not E.db.KlixUI.microBar.enable end,
					},
					highlight = {
						order = 6,
						type = "group",
						name = L["Highlight"],
						disabled = function() return not E.db.KlixUI.microBar.enable end,
						hidden = function() return not E.db.KlixUI.microBar.enable end,
						get = function(info) return E.db.KlixUI.microBar.highlight[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.microBar.highlight[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
						args = {
							enable = {		
								order = 1,
								type = "toggle",
								name = L["Enable"],
								desc = L['Show/Hide the highlight when hovering over the |cfff960d9KlixUI|r MicroBar buttons.'],
							},
							buttons = {		
								order = 2,
								type = "toggle",
								name = L["Buttons"],
								desc = L['Only show the highlight of the buttons when hovering over the |cfff960d9KlixUI|r MicroBar buttons.'],
								disabled = function() return not E.db.KlixUI.microBar.highlight.enable end,
							},
						},
					},
					space3 = {
						order = 7,
						type = "description",
						name = "",
					},
					text = {
						order = 8,
						type = "group",
						name = L["Text"],
						disabled = function() return not E.db.KlixUI.microBar.enable end,
						hidden = function() return not E.db.KlixUI.microBar.enable end,
						args = {
							buttons = {
								order = 1,
								type = "group",
								name = L["Buttons"],
								disabled = function() return not E.db.KlixUI.microBar.enable end,
								get = function(info) return E.db.KlixUI.microBar.text.buttons[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.microBar.text.buttons[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
								args = {			
									position = {
										order = 1,
										type = "select",
										name = L["Position"],
										values = {
											["TOP"] = L["Top"],
											["BOTTOM"] = L["Bottom"],
										},
									},
								},
							},
							friends = {
								order = 2,
								type = "group",
								name = FRIENDS,
								get = function(info) return E.db.KlixUI.microBar.text.friends[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.microBar.text.friends[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
								args = {
									enable = {
										order = 1,
										type = "toggle",
										name = L["Enable"],
										desc = L['Show/Hide the friend text on |cfff960d9KlixUI|r MicroBar.'],
									},
									space1 = {
										order = 2,
										type = "description",
										name = "",
									},
									space2 = {
										order = 3,
										type = "description",
										name = "",
									},
									textSize = {
										order = 4,
										name = FONT_SIZE,
										type = "range",
										min = 6, max = 20, step = 1,
										disabled = function() return not E.db.KlixUI.microBar.text.friends.enable end,
									},
									xOffset = {
										order = 5,
										type = "range",
										name = L["X-Offset"],
										min = -30, max = 30, step = 1,
										disabled = function() return not E.db.KlixUI.microBar.text.friends.enable end,
									},
									yOffset = {
										order = 6,
										type = "range",
										name = L["Y-Offset"],
										min = -30, max = 30, step = 1,
										disabled = function() return not E.db.KlixUI.microBar.text.friends.enable end,
									},
								},
							},
							guild = {
								order = 3,
								type = "group",
								name = GUILD,
								get = function(info) return E.db.KlixUI.microBar.text.guild[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.microBar.text.guild[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
								args = {
									enable = {
										order = 1,
										type = "toggle",
										name = L["Enable"],
										desc = L['Show/Hide the guild text on |cfff960d9KlixUI|r MicroBar.'],
									},
									space1 = {
										order = 2,
										type = "description",
										name = "",
									},
									space2 = {
										order = 3,
										type = "description",
										name = "",
									},
									textSize = {
										order = 4,
										name = FONT_SIZE,
										type = "range",
										min = 6, max = 20, step = 1,
										disabled = function() return not E.db.KlixUI.microBar.text.guild.enable end,
									},
									xOffset = {
										order = 5,
										type = "range",
										name = L["X-Offset"],
										min = -30, max = 30, step = 1,
										disabled = function() return not E.db.KlixUI.microBar.text.guild.enable end,
				
									},
									yOffset = {
										order = 6,
										type = "range",
										name = L["Y-Offset"],
										min = -30, max = 30, step = 1,
										disabled = function() return not E.db.KlixUI.microBar.text.guild.enable end,
									},
								},
							},
							colors = {
								order = 4,
								type = 'group',
								name = L["Color"],
								get = function(info) return E.db.KlixUI.microBar.text.colors[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.microBar.text.colors[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
								args = {
									customColor = {
										order = 1,
										type = "select",
										name = COLOR,
											values = {
												[1] = CLASS_COLORS,
												[2] = CUSTOM,
												[3] = L["Value Color"],
											},
										},
										userColor = {
											order = 2,
											type = "color",
											name = COLOR_PICKER,
											disabled = function() return E.db.KlixUI.microBar.text.colors.customColor == 1 or E.db.KlixUI.microBar.text.colors.customColor == 3 end,
										get = function(info)
											local t = E.db.KlixUI.microBar.text.colors[ info[#info] ]
											return t.r, t.g, t.b, t.a
											end,
										set = function(info, r, g, b)
											local t = E.db.KlixUI.microBar.text.colors[ info[#info] ]
											t.r, t.g, t.b = r, g, b
											E:StaticPopup_Show("PRIVATE_RL");
											end,
									},
								},
							},
						},
					},
				},
			},
		},
	}
	
	local available = available or 6

	if T.IsAddOnLoaded('ElvUI_ExtraActionBars') then
		available = 10
	else
		available = 6
	end
end
T.table_insert(KUI.Config, abTable)