local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KAB = KUI:GetModule('KUIActionbars');
local MB = KUI:GetModule("MicroBar");
local ABS = KUI:GetModule("AutoButtons");
local SEB = KUI:GetModule("SpecEquipBar");
local EVB = KUI:GetModule("EnhancedVehicleBar")

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
			general = {
				order = 2,
				type = "group",
				name = L["General"],
				args = {
					transparent = {
						order = 1,
						type = 'toggle',
						name = L['Transparent Backdrops'],
						desc = L['Applies transparency in all actionbar backdrops and actionbar buttons.'],
						disabled = function() return not E.private.actionbar.enable end,
						get = function(info) return E.db.KlixUI.actionbars[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.actionbars[ info[#info] ] = value; KAB:TransparentBackdrops() end,	
					},
					questButton = {
						order = 2,
						type = 'toggle',
						name = L['Quest Button'],
						desc = L['Shows a button with the quest item for the closest quest with an item.'],
						disabled = function() return not E.private.actionbar.enable or T.IsAddOnLoaded("ExtraQuestButton") end,
						get = function(info) return E.db.KlixUI.actionbars[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.actionbars[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
					},
					cleanButton = {
						order = 3,
						type = 'toggle',
						name = L['Clean Button'],
						desc = L['Removes the textures around the Bossbutton and the Zoneability button.'],
						disabled = function() return not E.private.actionbar.enable end,
						get = function(info) return E.db.KlixUI.actionbars[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.actionbars[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
					},
					space1 = {
						order = 4,
						type = "description",
						name = "",
					},
					vehicle = {
						type = "group",
						name = L["Enhanced Vehicle Bar"],
						order = 10,
						guiInline = true,
						args = {
							info = {
								order = 1,
								type = "description",
								name = L["A different look/feel of the default vehicle bar."],
							},
							enable = {
								order = 2,
								type = "toggle",
								name = L["Enable"],
								get = function(info) return E.db.KlixUI.actionbars.vehicle[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.actionbars.vehicle[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
							},
							numButtons = {
								order = 3,
								type = 'range',
								name = L["Buttons"],
								desc = L["The amount of buttons to display."],
								min = 5, max = 7, step = 1,
								disabled = function() return not E.db.KlixUI.actionbars.vehicle.enable end,
								get = function(info) return E.db.KlixUI.actionbars.vehicle[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.actionbars.vehicle[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
							},
							buttonsize = {
								order = 4,
								type = 'range',
								name = L["Button Size"],
								desc = L["The size of the enhanced vehicle bar buttons."],
								min = 15, max = 60, step = 1,
								disabled = function() return not E.db.KlixUI.actionbars.vehicle.enable end,
								get = function(info) return E.db.KlixUI.actionbars.vehicle[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.actionbars.vehicle[ info[#info] ] = value; EVB:BarSize(); EVB:ButtonsSize() end,
							},
							buttonspacing = {
								order = 5,
								type = 'range',
								name = L["Button Spacing"],
								desc = L["The spacing between the enhanced vehicle bar buttons."],
								min = -4, max = 20, step = 1,
								disabled = function() return not E.db.KlixUI.actionbars.vehicle.enable end,
								get = function(info) return E.db.KlixUI.actionbars.vehicle[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.actionbars.vehicle[ info[#info] ] = value; EVB:BarSize(); EVB:ButtonsSize() end,
							},
							template = {
								order = 6,
								type = "select",
								name = L["Template"],
								disabled = function() return not E.db.KlixUI.actionbars.vehicle.enable end,
								get = function(info) return E.db.KlixUI.actionbars.vehicle[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.actionbars.vehicle[ info[#info] ] = value; EVB:BarSize(); EVB:BarBackdrop() end,
								values = {
									["Default"] = DEFAULT,
									["Transparent"] = L["Transparent"],
									["NoBackdrop"] = NONE,
								},
							},
						},
					},
					RandomHearthstone = {
						order = 15,
						type = "group",
						guiInline = true,
						name = L["Random Hearthstone"],
						get = function(info) return E.db.KlixUI.actionbars.hearthstone[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.actionbars.hearthstone[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
						args = {
							info = {
								order = 1,
								type = "description",
								name = L["RHS_DESC"],
							},
							enable = {
								order = 2,
								type = "toggle",
								name = L["Enable"],
							},
							delete = {
								order = 3,
								type = "toggle",
								name = L["Delete Hearthstone"],
								desc = L['Automatically delete the classic hearthstone, you receive, when you change hearth location.'],
							},
							CreateRHS = {
								order = 4,
								type = 'execute',
								name = L["Create |cfff960d9KlixUI|r Hearthstone"],
								buttonElvUI = true,
								disabled = function(info) return not E.db.KlixUI.actionbars.hearthstone.enable end,
								func = function() KAB:Macro_Refresh(); E:ToggleOptionsUI(); end,
							},
						},
					},
				},
			},
			glow = {
				order = 3,
				type = "group",
				name = L["Glow"],
				hidden = function() return T.IsAddOnLoaded("CoolGlow") end,
				disabled = function() return T.IsAddOnLoaded("CoolGlow") end,
				get = function(info) return E.db.KlixUI.actionbars.glow[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.actionbars.glow[ info[#info] ] = value; KAB:SpellActivationGlow(); end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						set = function(info, value) E.db.KlixUI.actionbars.glow[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
					},
					finishMove = {
						order = 2,
						type = "toggle",
						name = L["Finishing Move Glow"],
						desc = L["This will display glow, when reaching 5 combopoints, on spells which utilize 1-5 combopoints."],
						disabled = function() return not E.db.KlixUI.actionbars.glow.enable or not E.myclass == "ROGUE" or not E.myclass == "DRUID" end,
						set = function(info, value) E.db.KlixUI.actionbars.glow[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
					},
					color = {
						order = 3,
						type = "color",
						name = L["Color"],
						hasAlpha = true,
						disabled = function() return not E.db.KlixUI.actionbars.glow.enable end,
						get = function(info)
							local t = E.db.KlixUI.actionbars.glow.color
							return t.r, t.g, t.b, t.a
						end,
						set = function(info, r, g, b, a)
							local t = E.db.KlixUI.actionbars.glow.color
							t.r, t.g, t.b, t.a = r, g, b, a
							KAB:SpellActivationGlow()
						end,
					},
					number = {
						order = 4,
						type = "range",
						name = L["Num Lines"],
						desc = L["Defines the number of lines the glow will spawn."],
						min = 4, max = 16, step = 1,
						disabled = function() return not E.db.KlixUI.actionbars.glow.enable end,
					},
					frequency = {
						order = 5,
						type = "range",
						name = L["Frequency"],
						desc = L["Sets the animation speed of the glow. Negative values will rotate the glow anti-clockwise."],
						min = -2, max = 2, step = 0.01,
						disabled = function() return not E.db.KlixUI.actionbars.glow.enable end,
					},
					length = {
						order = 6,
						type = "range",
						name = L["Length"],
						desc = L["Defines the length of each individual glow lines."],
						min = 2, max = 16, step = 1,
						disabled = function() return not E.db.KlixUI.actionbars.glow.enable end,
					},
					thickness = {
						order = 7,
						type = "range",
						name = L["Thickness"],
						desc = L["Defines the thickness of the glow lines."],
						min = 1, max = 6, step = 1,
						disabled = function() return not E.db.KlixUI.actionbars.glow.enable end,
					},
					xOffset = {
						order = 8,
						type = "range",
						name = L["X-Offset"],
						min = -5, max = 5, step = 1,
						disabled = function() return not E.db.KlixUI.actionbars.glow.enable end,
					},
					yOffset = {
						order = 9,
						type = "range",
						name = L["Y-Offset"],
						min = -5, max = 5, step = 1,
						disabled = function() return not E.db.KlixUI.actionbars.glow.enable end,
					},
				},
			},
			SEBar = {
				order = 4,
				type = "group",
				name = L["Specialization & Equipment Bar"],
				get = function(info) return E.db.KlixUI.actionbars.SEBar[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.actionbars.SEBar[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L['Show/Hide the |cfff960d9KlixUI|r Spec & EquipBar.'],
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
					borderGlow = {
						order = 4,
						type = "toggle",
						name = L["Border Glow"],
						desc = L["Shows an animated border glow for the currently active specialization and loot specialization."],
						disabled = function() return not E.db.KlixUI.actionbars.SEBar.enable end,
						
					},
					mouseover = {
						order = 5,
						type = "toggle",
						name = L["Mouseover"],
						disabled = function() return not E.db.KlixUI.actionbars.SEBar.enable end,
					},
					malpha = {
						order = 6,
						type = "range",
						name = L["Alpha"],
						desc = L["Change the alpha level of the frame."],
						min = 0, max = 1, step = 0.1,
						disabled = function() return not E.db.KlixUI.actionbars.SEBar.mouseover or not E.db.KlixUI.actionbars.SEBar.enable end,
					},
					hideInCombat = {
						order = 7,
						type = "toggle",
						name = L["Hide In Combat"],
						desc = L['Show/Hide the |cfff960d9KlixUI|r Spec & EquipBar in combat.'],
						disabled = function() return not E.db.KlixUI.actionbars.SEBar.enable end,
					},
					hideInOrderHall = {
						order = 8,
						type = "toggle",
						name = L["Hide In Orderhall"],
						desc = L['Show/Hide the |cfff960d9KlixUI|r Spec & Equip Bar in the class hall.'],
						disabled = function() return not E.db.KlixUI.actionbars.SEBar.enable end,
					},
				},
			},
			microBar = {
				order = 5,
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
					hideInOrderHall = {
						order = 6,
						type = "toggle",
						name = L["Hide In Orderhall"],
						desc = L['Show/Hide the |cfff960d9KlixUI|r MicroBar in the class hall.'],
						disabled = function() return not E.db.KlixUI.microBar.enable end,
						hidden = function() return not E.db.KlixUI.microBar.enable end,
					},
					highlight = {
						order = 7,
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
						order = 8,
						type = "description",
						name = "",
					},
					text = {
						order = 9,
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
			autoButtons = {
				order = 6,
				type = "group",
				name = L["Auto Buttons"],
				hidden = function() return (KUI:IsDeveloper() and KUI:IsDeveloperRealm()) end,
				get = function(info)return E.db.KlixUI.actionbars.autoButtons[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.actionbars.autoButtons[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
					},
					featureconfig = {
						order = 2,
						type = "group",
						guiInline = true,
						name = L["Feature Config"],
						hidden = function()
							return not E.db.KlixUI.actionbars.autoButtons.enable
						end,
						get = function(info)
							return E.db.KlixUI.actionbars.autoButtons[info[#info]]
						end,
						set = function(info, value)
							E.db.KlixUI.actionbars.autoButtons[info[#info]] = value
							ABS:UpdateAutoButton()
						end,
						args = {
							bindFont = {
								order = 1,
								type = "select",
								dialogControl = "LSM30_Font",
								name = L["Hot Key Font"],
								values = AceGUIWidgetLSMlists.font,
							},
							countFont = {
								order = 2,
								type = "select",
								dialogControl = "LSM30_Font",
								name = L["Count Font"],
								values = AceGUIWidgetLSMlists.font,
							},
							bindFontSize = {
								order = 3,
								type = "range",
								min = 4, max = 40, step = 1,
								name = L["Hot Key Font Size"],
							},
							countFontSize = {
								order = 4,
								type = "range",
								min = 4, max = 40, step = 1,
								name = L["Count Font Size"],
							},
							soltAutoButtons = {
								order = 5,
								type = "group",
								guiInline = true,
								name = L["Inventory Auto Buttons"],
								get = function(info)
									return E.db.KlixUI.actionbars.autoButtons.soltAutoButtons[info[#info]]
								end,
								set = function(info, value)
									E.db.KlixUI.actionbars.autoButtons.soltAutoButtons[info[#info]] = value
									ABS:UpdateAutoButton()
								end,
								args = {
									enable = {
										order = 1,
										type = "toggle",
										name = L["Enable"],
									},
									slotBBColorByItem = {
										order = 2,
										type = "toggle",
										name = L["Color By Item"],
										hidden = function()
											return not E.db.KlixUI.actionbars.autoButtons.soltAutoButtons.enable
										end,
									},
									slotBBColor = {
										order = 3,
										type = "color",
										name = L["Custom Color"],
										hidden = function()
											return not E.db.KlixUI.actionbars.autoButtons.soltAutoButtons.enable
										end,
										disabled = function()
											return E.db.KlixUI.actionbars.autoButtons.soltAutoButtons.slotBBColorByItem
										end,
										get = function(info)
											local t = E.db.KlixUI.actionbars.autoButtons.soltAutoButtons[info[#info]]
											local d = P.KlixUI.actionbars.autoButtons.soltAutoButtons[info[#info]]
											return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
										end,
										set = function(info, r, g, b, a)
											E.db.KlixUI.actionbars.autoButtons.soltAutoButtons[info[#info]] = {}
											local t = E.db.KlixUI.actionbars.autoButtons.soltAutoButtons[info[#info]]
											t.r, t.g, t.b, t.a = r, g, b, a
											ABS:UpdateAutoButton()
										end,
									},
									slotSpace = {
										order = 4,
										type = "range",
										name = L["Spacing"],
										min = -1, max = 10, step = 1,
										hidden = function()
											return not E.db.KlixUI.actionbars.autoButtons.soltAutoButtons.enable
										end,
									},
									slotDirection = {
										order = 5,
										type = "select",
										name = L["Direction"],
										values = {
											["RIGHT"] = L["Right"],
											["LEFT"] = L["Left"],
										},
										hidden = function()
											return not E.db.KlixUI.actionbars.autoButtons.soltAutoButtons.enable
										end,
									},
									slotNum = {
										order = 6,
										type = "range",
										name = L["Number of Buttons"],
										min = 0, max = 12, step = 1,
										hidden = function()
											return not E.db.KlixUI.actionbars.autoButtons.soltAutoButtons.enable
										end,
									},
									slotPerRow = {
										order = 7,
										type = "range",
										name = L["Buttons Per Row"],
										min = 1, max = 12, step = 1,
										hidden = function()
											return not E.db.KlixUI.actionbars.autoButtons.soltAutoButtons.enable
										end,
									},
									slotSize = {
										order = 8,
										type = "range",
										name = L["Button Size"],
										min = 10, max = 100, step = 1,
										hidden = function()
											return not E.db.KlixUI.actionbars.autoButtons.soltAutoButtons.enable
										end,
									},
								},
							},
							questAutoButtons = {
								order = 4,
								type = "group",
								guiInline = true,
								name = L["Quest Auto Buttons"],
								get = function(info)
									return E.db.KlixUI.actionbars.autoButtons.questAutoButtons[info[#info]]
								end,
								set = function(info, value)
									E.db.KlixUI.actionbars.autoButtons.questAutoButtons[info[#info]] = value
									ABS:UpdateAutoButton()
								end,
								args = {
									enable = {
										order = 1,
										type = "toggle",
										name = L["Enable"],
									},
									questBBColorByItem = {
										order = 2,
										type = "toggle",
										name = L["Color By Item"],
										hidden = function()
											return not E.db.KlixUI.actionbars.autoButtons.questAutoButtons.enable
										end,
									},
									questBBColor = {
										order = 3,
										type = "color",
										name = L["Custom Color"],
										hidden = function()
											return not E.db.KlixUI.actionbars.autoButtons.questAutoButtons.enable
										end,
										disabled = function()
											return E.db.KlixUI.actionbars.autoButtons.questAutoButtons.questBBColorByItem
										end,
										get = function(info)
											local t = E.db.KlixUI.actionbars.autoButtons.questAutoButtons[info[#info]]
											local d = P.KlixUI.actionbars.autoButtons.questAutoButtons[info[#info]]
											return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
										end,
										set = function(info, r, g, b, a)
											E.db.KlixUI.actionbars.autoButtons.questAutoButtons[info[#info]] = {}
											local t = E.db.KlixUI.actionbars.autoButtons.questAutoButtons[info[#info]]
											t.r, t.g, t.b, t.a = r, g, b, a
											ABS:UpdateAutoButton()
										end,
									},
									questSpace = {
										order = 4,
										type = "range",
										name = L["Spacing"],
										min = -1, max = 10, step = 1,
										hidden = function()
											return not E.db.KlixUI.actionbars.autoButtons.questAutoButtons.enable
										end,
									},
									questDirection = {
										order = 5,
										type = "select",
										name = L["Direction"],
										values = {
											["RIGHT"] = L["Right"],
											["LEFT"] = L["Left"],
										},
										hidden = function()
											return not E.db.KlixUI.actionbars.autoButtons.questAutoButtons.enable
										end,
									},
									questNum = {
										order = 6,
										type = "range",
										name = L["Number of Buttons"],
										min = 0, max = 12, step = 1,
										hidden = function()
											return not E.db.KlixUI.actionbars.autoButtons.questAutoButtons.enable
										end,
									},
									questPerRow = {
										order = 7,
										type = "range",
										name = L["Buttons Per Row"],
										min = 1, max = 12, step = 1,
										hidden = function()
											return not E.db.KlixUI.actionbars.autoButtons.questAutoButtons.enable
										end,
									},
									questSize = {
										order = 8,
										type = "range",
										name = L["Button Size"],
										min = 10, max = 100, step = 1,
										hidden = function()
											return not E.db.KlixUI.actionbars.autoButtons.questAutoButtons.enable
										end,
									},
								},
							},
							whiteItemID = {
								order = 6,
								type = "input",
								name = L["Whitelist"],
								get = function()
									return whiteItemID or ""
								end,
								set = function(info, value)
									whiteItemID = value
								end,
							},
							AddItemID = {
								order = 7,
								type = "execute",
								name = L["Add ItemID"],
								func = function()
									if not tonumber(whiteItemID) then
										KUI:Print(L["Must be an itemID!"])
										return
									end
									local id = tonumber(whiteItemID)
									if not T.GetItemInfo(id) then
										KUI:Print(whiteItemID .. L["is not an itemID"])
										return
									end
									E.db.KlixUI.actionbars.autoButtons.whiteList[id] = true
									E.Options.args.KlixUI.args.modules.args.actionbars.args.autoButtons.args.featureconfig.args.whiteList.values[id] = T.GetItemInfo(id)
									ABS:UpdateAutoButton()
								end,
							},
							DeleteItemID = {
								order = 8,
								type = "execute",
								name = L["Delete ItemID"],
								func = function()
									if not T.tonumber(whiteItemID) then
										KUI:Print(L["Must be an itemID!"])
										return
									end
									local id = T.tonumber(whiteItemID)
									if not T.GetItemInfo(id) then
										KUI:Print(whiteItemID .. L["is not an itemID"])
										return
									end
									if E.db.KlixUI.actionbars.autoButtons.whiteList[id] == true or E.db.KlixUI.actionbars.autoButtons.whiteList[id] == false then
										E.db.KlixUI.actionbars.autoButtons.whiteList[id] = nil
										E.Options.args.KlixUI.args.modules.args.actionbars.args.autoButtons.args.featureconfig.args.whiteList.values[id] = nil
									end
									ABS:UpdateAutoButton()
								end,
							},
							whiteList = {
								order = 9,
								type = "multiselect",
								name = L["Whitelist"],
								get = function(info, k)
									return E.db.KlixUI.actionbars.autoButtons.whiteList[k]
								end,
								set = function(info, k, v)
									E.db.KlixUI.actionbars.autoButtons.whiteList[k] = v
									ABS:UpdateAutoButton()
								end,
								values = {}
							},
							blackitemID = {
								order = 10,
								type = "input",
								name = L["Blacklist"],
								get = function()
									return blackItemID or ""
								end,
								set = function(info, value)
									blackItemID = value
								end,
							},
							AddblackItemID = {
								order = 11,
								type = "execute",
								name = L["Add Blacklist ItemID"],
								func = function()
									if not T.tonumber(blackItemID) then
										KUI:Print(L["Must be an itemID!"])
										return
									end
										local id = T.tonumber(blackItemID)
										if not T.GetItemInfo(id) then
											KUI:Print(blackItemID .. L["is not an itemID"])
											return
										end
										E.db.KlixUI.actionbars.autoButtons.blackList[id] = true
										E.Options.args.KlixUI.args.modules.args.actionbars.args.autoButtons.args.featureconfig.args.blackList.values[id] = T.GetItemInfo(id)
										ABS:UpdateAutoButton()
									end,
							},
							DeleteblackItemID = {
								order = 12,
								type = "execute",
								name = L["Delete Blacklist ItemID"],
								func = function()
									if not T.tonumber(blackItemID) then
										KUI:Print(L["Must be an itemID!"])
										return
									end
									local id = T.tonumber(blackItemID)
									if not T.GetItemInfo(id) then
										KUI:Print(blackItemID .. L["is not an itemID"])
										return
									end
									if E.db.KlixUI.actionbars.autoButtons.blackList[id] == true or E.db.KlixUI.actionbars.autoButtons.blackList[id] == false then
										E.db.KlixUI.actionbars.autoButtons.blackList[id] = nil
										E.Options.args.KlixUI.args.modules.args.actionbars.args.autoButtons.args.featureconfig.args.blackList.values[id] = nil
									end
									ABS:UpdateAutoButton()
								end,
							},
							blackList = {
								order = 13,
								type = "multiselect",
								name = L["Blacklist"],
								get = function(info, k)
									return E.db.KlixUI.actionbars.autoButtons.blackList[k]
								end,
								set = function(info, k, v)
									E.db.KlixUI.actionbars.autoButtons.blackList[k] = v
									ABS:UpdateAutoButton()
								end,
								values = {}
							},
						},
					},
				},
			},
		},
	}
	
	for k, v in T.pairs(E.db.KlixUI.actionbars.autoButtons.whiteList) do
		if T.type(k) == "string" then k = T.tonumber(k) end
		if T.GetItemInfo(k) then
		
			local name = T.select(1, T.GetItemInfo(k))
			local tex = T.select(10, T.GetItemInfo(k))
			
			E.Options.args.KlixUI.args.modules.args.actionbars.args.autoButtons.args.featureconfig.args.whiteList.values[k] = '|T'..tex..':18:18:0:0:64:64:4:60:4:60|t '..name
		end
	end
	for k, v in T.pairs(E.db.KlixUI.actionbars.autoButtons.blackList) do
		if T.type(k) == "string" then k = T.tonumber(k) end
		if T.GetItemInfo(k) then
		
			local name = T.select(1, T.GetItemInfo(k))
			local tex = T.select(10, T.GetItemInfo(k))
			
			E.Options.args.KlixUI.args.modules.args.actionbars.args.autoButtons.args.featureconfig.args.blackList.values[k] = '|T'..tex..':18:18:0:0:64:64:4:60:4:60|t '..name
		end
	end
	
	local available = available or 6

	if T.IsAddOnLoaded('ElvUI_ExtraActionBars') then
		available = 10
	else
		available = 6
	end
end
T.table_insert(KUI.Config, abTable)