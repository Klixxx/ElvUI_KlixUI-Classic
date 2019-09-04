local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local MM = KUI:GetModule("KuiMinimap")
local KWM = KUI:GetModule('KuiWorldMap')
local SMB = KUI:GetModule("KuiSquareMinimapButtons")

local function Maps()
	E.Options.args.KlixUI.args.modules.args.maps = {
		order = 17,
		type = "group",
		name = L["Maps"],
		childGroups = "tab",
		get = function(info) return E.db.KlixUI.maps[ info[#info] ] end,
		set = function(info, value) E.db.KlixUI.maps[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			header = {
				type = "header",
				name = KUI:cOption(L["Maps"]),
				order = 1,
			},
			minimap = {
				type = "group",
				name = MINIMAP_LABEL,
				order = 2,
				childGroups = "tab",
				get = function(info) return E.db.KlixUI.maps.minimap[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.maps.minimap[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					general = {
						order = 1,
						type = "group",
						name = L["General"],
						args = {
							rectangle = {
								order = 1,
								type = "toggle",
								name = L["Rectangular Minimap"],
								desc = L["Reshape the minimap to a rectangle."],
								hidden = function() return T.IsAddOnLoaded("ElvUI_RectangleMinimap") end,
							},
							glow = {
								order = 4,
								type = "toggle",
								name = L["Minimap Glow"],
								desc = L["Shows the minimap glow when a mail or a calendar invite is available."],
							},
							glowAlways = {
								order = 5,
								type = "toggle",
								name = L["Always Display Glow"],
								desc = L["Always display the minimap glow."],
								disabled = function() return not E.db.KlixUI.maps.minimap.glow end,
							},
							hideincombat = {
								order = 6,
								type = "toggle",
								name = L["Combat Hide"],
								desc = L["Hide minimap while in combat."],
								set = function(info, value) E.db.KlixUI.maps.minimap.hideincombat = value; MM:HideMinimapRegister() end,			
							},
							fadeindelay = {
								order = 7,
								type = "range",
								name = L["FadeIn Delay"],
								desc = L["The time to wait before fading the minimap back in after combat hide. (0 = Disabled)"],
								min = 0, max = 20, step = 1,	
								disabled = function() return not E.db.KlixUI.maps.minimap.hideincombat end,
							},
							space1 = {
								order = 9,
								type = "description",
								name = "",
							},
							mail = {
								type = "group",
								name = L["Mail"],
								order = 10,
								guiInline = true,
								get = function(info) return E.db.KlixUI.maps.minimap.mail[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.maps.minimap.mail[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
								args = {
									enhanced = {
										order = 1,
										type = "toggle",
										name = L["Enhanced Mail"],
										desc = L["Shows the enhanced mail tooltip and styling (Icon, color, and blink animation)."],
									},
									sound = {
										order = 2,
										type = "toggle",
										name = L["Play Sound"],
										desc = L["Plays a sound when a mail is received.\n|cffff8000Note: This will be disabled by default if notifcations or notification mail module is enabled.|r"],
										disabled = function() return E.db.KlixUI.notification.enable and E.db.KlixUI.notification.mail and not E.db.KlixUI.notification.noSound end,
									},
									hide = {
										order = 3,
										type = "toggle",
										name = L["Hide Mail Icon"],
										desc = L["Hide the mail Icon on the minimap."],
									},
								},
							},
						},
					},
					buttons = {
						order = 2,
						type = "group",
						name = L["Minimap Buttons"],
						get = function(info) return E.db.KlixUI.maps.minimap.buttons[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.maps.minimap.buttons[ info[#info] ] = value; SMB:Update(); end,
						disabled = function() return T.IsAddOnLoaded("ProjectAzilroka") end,
						hidden = function() return T.IsAddOnLoaded("ProjectAzilroka") end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								set = function(info, value) E.db.KlixUI.maps.minimap.buttons.enable = value; E:StaticPopup_Show("PRIVATE_RL"); end,
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
							barMouseOver = {
								order = 4,
								type = "toggle",
								name = L["Mouseover"],
								disabled = function() return not E.db.KlixUI.maps.minimap.buttons.enable end,
							},
							backdrop = {
								order = 5,
								type = "toggle",
								name = L["Bar Backdrop"],
								disabled = function() return not E.db.KlixUI.maps.minimap.buttons.enable end,
							},
							hideInCombat = {
								order = 6,
								type = "toggle",
								name = L["Hide In Combat"],
								disabled = function() return not E.db.KlixUI.maps.minimap.buttons.enable end,
							},
							iconSize = {
								order = 7,
								type = "range",
								name = L["Icon Size"],
								min = 12, max = 48, step = 0.5,
								disabled = function() return not E.db.KlixUI.maps.minimap.buttons.enable end,
							},
							buttonSpacing = {
								order = 8,
								type = "range",
								name = L["Button Spacing"],
								min = -1, max = 10, step = 1,
								disabled = function() return not E.db.KlixUI.maps.minimap.buttons.enable end,
							},
							buttonsPerRow = {
								order = 9,
								type = "range",
								name = L["Buttons Per Row"],
								min = 1, max = 12, step = 1,
								disabled = function() return not E.db.KlixUI.maps.minimap.buttons.enable end,
							},
							visibility = {
								order = 15,
								type = 'input',
								width = 'full',
								name = L["Visibility State"],
								disabled = function() return not E.db.KlixUI.maps.minimap.buttons.enable end,
								set = function(info, value) E.db.KlixUI.maps.minimap.buttons.visibility = value; SMB:UpdateVisibility() end,
							},
							blizzard = {
								order = 20,
								type = "group",
								name = L["Blizzard"],
								guiInline = true,
								disabled = function() return not E.db.KlixUI.maps.minimap.buttons.enable end,
								set = function(info, value) E.db.KlixUI.maps.minimap.buttons[ info[#info] ] = value; SMB:Update(); SMB:HandleBlizzardButtons(); E:StaticPopup_Show("PRIVATE_RL") end,
								args = {
									moveTracker  = {
										order = 1,
										type = "toggle",
										name = L["Move Tracker Icon"],
									},
									moveQueue  = {
										order = 2,
										type = "toggle",
										name = L["Move Queue Status Icon"],
									},
									moveMail  = {
										order = 3,
										type = "toggle",
										name = L["Move Mail Icon"],
									},
								},
							},
						},
					},
					ping = {
						order = 3,
						type = "group",
						name = L["Minimap Ping"],
						get = function(info) return E.db.KlixUI.maps.minimap.ping[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.maps.minimap.ping[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								desc = L["Shows the name of the player who pinged on the Minimap."],
							},
							space1 = {
								order = 2,
								type = "description",
								name = "",
							},
							position = {
								order = 3,
								type = "select",
								name = L["Position"],
								values = {
									["TOP"] = L["Top"],
									["BOTTOM"] = L["Bottom"],
									["LEFT"] = L["Left"],
									["RIGHT"] = L["Right"],
									["CENTER"] = L["Center"],
								},
								disabled = function() return not E.db.KlixUI.maps.minimap.ping.enable end,
							},
							xOffset = {
								order = 4,
								type = "range",
								name = L["X-Offset"],
								min = -100, max = 100, step = 1,
								disabled = function() return not E.db.KlixUI.maps.minimap.ping.enable end,
							},
							yOffset = {
								order = 5,
								type = "range",
								name = L["Y-Offset"],
								min = -100, max = 100, step = 1,
								disabled = function() return not E.db.KlixUI.maps.minimap.ping.enable end,
							},
						},
					},
					coords = {
						order = 4,
						type = "group",
						name = L["Coordinates"],
						get = function(info) return E.db.KlixUI.maps.minimap.coords[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.maps.minimap.coords[ info[#info] ] = value; MM:UpdateSettings() end,
						args = {
							enable = {
								type = "toggle",
								name = L["Enable"],
								order = 1,
								desc = L["Enable/Disable Square Minimap Coords."],
								disabled = function() return not E.private.general.minimap.enable end,
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
							display = {
								order = 4,
								type = 'select',
								name = L["Coords Display"],
								desc = L["Change settings for the display of the coordinates that are on the minimap."],
								disabled = function() return not E.private.general.minimap.enable or not E.db.KlixUI.maps.minimap.coords.enable end,
								values = {
									["MOUSEOVER"] = L["Minimap Mouseover"],
									["SHOW"] = L["Always Display"],
								},
							},
							position = {
								order = 5,
								type = "select",
								name = L["Coords Location"],
								desc = L["This will determine where the coords are shown on the minimap."],
								disabled = function() return not E.private.general.minimap.enable or not E.db.KlixUI.maps.minimap.coords.enable end,
								values = {
									["TOPLEFT"] = "TOPLEFT",
									["LEFT"] = "LEFT",
									["BOTTOMLEFT"] = "BOTTOMLEFT",
									["RIGHT"] = "RIGHT",
									["TOPRIGHT"] = "TOPRIGHT",
									["BOTTOMRIGHT"] = "BOTTOMRIGHT",
									["TOP"] = "TOP",
									["BOTTOM"] = "BOTTOM",
								}
							},
							format = {
								order = 6,
								name = L["Format"],
								type = "select",
								disabled = function() return not E.private.general.minimap.enable or not E.db.KlixUI.maps.minimap.coords.enable end,
								values = {
									["%.0f"] = DEFAULT,
									["%.1f"] = "45.3",
									["%.2f"] = "45.34",
								},
							},
							throttle = {
								order = 7,
								type = 'range',
								name = L["Update Throttle"],
								min = 0.1, max = 2, step = 0.1,
								disabled = function() return not E.db.KlixUI.maps.minimap.coords.enable or not E.private.general.minimap.enable end,
								set = function(info, value) E.db.KlixUI.maps.minimap.coords[ info[#info] ] = value; end,
							},
							xOffset = {
								order = 8,
								type = "range",
								name = L["X-Offset"],
								min = -100, max = 100, step = 1,
								disabled = function() return not E.private.general.minimap.enable or not E.db.KlixUI.maps.minimap.coords.enable end,
							},
							yOffset = {
								order = 9,
								type = "range",
								name = L["Y-Offset"],
								min = -100, max = 100, step = 1,
								disabled = function() return not E.private.general.minimap.enable or not E.db.KlixUI.maps.minimap.coords.enable end,
							},
							fontGroup = {
								order = 10,
								type = "group",
								name = L["Fonts"],
								guiInline = true,
								disabled = function() return not E.db.KlixUI.maps.minimap.coords.enable or not E.private.general.minimap.enable end,
								get = function(info) return E.db.KlixUI.maps.minimap.coords[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.maps.minimap.coords[ info[#info] ] = value; MM:CoordFont() end,
								args = {
									font = {
										type = "select", dialogControl = 'LSM30_Font',
										order = 1,
										name = L["Font"],
										values = AceGUIWidgetLSMlists.font,
									},
									fontSize = {
										order = 2,
										name = L["Font Size"],
										type = "range",
										min = 6, max = 22, step = 1,
										set = function(info, value) E.db.KlixUI.maps.minimap.coords[ info[#info] ] = value; MM:CoordFont(); MM:CoordsSize() end,
									},
									fontOutline = {
										order = 3,
										name = L["Font Outline"],
										type = "select",
										values = {
											["NONE"] = L["None"],
											["OUTLINE"] = 'OUTLINE',
											["MONOCHROMEOUTLINE"] = 'MONOCROMEOUTLINE',
											["THICKOUTLINE"] = 'THICKOUTLINE',
										},
									},
									color = {
										type = 'color',
										order = 4,
										name = L["Color"],
										get = function(info)
											local t = E.db.KlixUI.maps.minimap.coords[ info[#info] ]
											local d = P.KlixUI.maps.minimap.coords[info[#info]]
											return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
										end,
										set = function(info, r, g, b, a)
											E.db.KlixUI.maps.minimap.coords[ info[#info] ] = {}
											local t = E.db.KlixUI.maps.minimap.coords[ info[#info] ]
											t.r, t.g, t.b, t.a = r, g, b, a
											MM:SetCoordsColor()
										end,
									},
								},
							},
						},
					},
					cardinalPoints = {
						order = 5,
						type = "group",
						name = L["Cardinal Points"],
						disabled = function() return T.IsAddOnLoaded("ElvUI_CompassPoints") end,
						hidden = function() return T.IsAddOnLoaded("ElvUI_CompassPoints") end,
						get = function(info) return E.db.KlixUI.maps.minimap.cardinalPoints[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.maps.minimap.cardinalPoints[ info[#info] ] = value; MM:UpdateCardinalFrame() end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								width = "full",
								name = L["Enable"],
								desc = L["Places cardinal points on your minimap (N, S, E, W)"],
							},
							north = {
								order = 2,
								type = "toggle",
								width = "half",
								name = L["North"],
								desc = L["Places the north cardinal point on your minimap."],
								disabled = function() return not E.db.KlixUI.maps.minimap.cardinalPoints.enable end,
							},
							east = {
								order = 3,
								type = "toggle",
								width = "half",
								name = L["East"],
								desc = L["Places the east cardinal point on your minimap."],
								disabled = function() return not E.db.KlixUI.maps.minimap.cardinalPoints.enable end,
							},
							south = {
								order = 4,
								type = "toggle",
								width = "half",
								name = L["South"],
								desc = L["Places the south cardinal point on your minimap."],
								disabled = function() return not E.db.KlixUI.maps.minimap.cardinalPoints.enable end,
							},
							west = {
								order = 5,
								type = "toggle",
								width = "half",
								name = L["West"],
								desc = L["Places the west cardinal point on your minimap."],
								disabled = function() return not E.db.KlixUI.maps.minimap.cardinalPoints.enable end,
							},
							space1 = {
								order = 6,
								type = "description",
								name = "",
							},
							Font = {
								order = 7,
								type = "select",
								dialogControl = "LSM30_Font",
								name = L["Font"],
								values = AceGUIWidgetLSMlists.font,
								disabled = function() return not E.db.KlixUI.maps.minimap.cardinalPoints.enable end,
								set = function(info, value) E.db.KlixUI.maps.minimap.cardinalPoints.Font = value; MM:FontCardinalFrame() end,
							},
							FontSize = {
								order = 8,
								type = "range",
								name = FONT_SIZE,
								min = 5, max = 100, step = 1,
								disabled = function() return not E.db.KlixUI.maps.minimap.cardinalPoints.enable end,
								set = function(info, value) E.db.KlixUI.maps.minimap.cardinalPoints.FontSize = value; MM:FontCardinalFrame() end,
							},
							FontOutline = {
								order = 9,
								type = "select",
								name = L["Font Outline"],
								disabled = function() return not E.db.KlixUI.maps.minimap.cardinalPoints.enable end,
								set = function(info, value) E.db.KlixUI.maps.minimap.cardinalPoints.FontOutline = value; MM:FontCardinalFrame() end,
								values = {
									["NONE"] = NONE,
									["OUTLINE"] = "OUTLINE",
									["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
									["THICKOUTLINE"] = "THICKOUTLINE",
								},
							},
							color = {
								order = 10,
								type = "select",
								name = COLOR,
								values = {
									[1] = CLASS_COLORS,
									[2] = CUSTOM,
									[3] = L["Value Color"],
								},
								disabled = function() return not E.db.KlixUI.maps.minimap.cardinalPoints.enable end,
								set = function(info, value) E.db.KlixUI.maps.minimap.cardinalPoints[ info[#info] ] = value; MM:ColorCardinalFrame(); end,
							},
							customColor = {
								order = 11,
								type = "color",
								name = COLOR_PICKER,
								disabled = function() return not E.db.KlixUI.maps.minimap.cardinalPoints.enable or E.db.KlixUI.maps.minimap.cardinalPoints.color == 1 or E.db.KlixUI.maps.minimap.cardinalPoints.color == 3 end,
								get = function(info)
									local t = E.db.KlixUI.maps.minimap.cardinalPoints[ info[#info] ]
									return t.r, t.g, t.b, t.a
									end,
								set = function(info, r, g, b)
									local t = E.db.KlixUI.maps.minimap.cardinalPoints[ info[#info] ]
									t.r, t.g, t.b = r, g, b
									MM:ColorCardinalFrame();
								end,
							},
						},	
					},
				},
			},
			worldmap = {
				type = "group",
				name = L["Worldmap"],
				order = 3,
				get = function(info) return E.db.KlixUI.maps.worldmap[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.maps.worldmap[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
				args = {
					general = {
						order = 1,
						type = "group",
						name = L["General"],
						guiInline = true,
						args = {
							scale = {
								order = 1,
								type = "range",
								name = L["World Map Frame Size"],
								min = 0.1, max = 1, step = 0.1,
								set = function(info, value) E.db.KlixUI.maps.worldmap.scale = value; KWM:WorldMapScale() end,
							},
							zoom = {
								order = 2,
								type = "toggle",
								name = L["World Map Frame Zoom"],
								desc = L["Mouse scroll on the world map to zoom."],
							},
						},
					},
					reveal = {
						order = 2,
						type = "group",
						name = L["Reveal"]..E.NewSign,
						guiInline = true,
						disabled = function() return T.IsAddOnLoaded("ElvUI_FogRemover") or T.IsAddOnLoaded("ElvUI_FogofWar") end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								desc = L["Reveal all undiscovered areas on the world map."],
								get = function(info) return E.db.KlixUI.maps.worldmap.reveal[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.maps.worldmap.reveal[ info[#info] ] = value; KWM:Update() end,
							},
							overlay = {
								order = 2,
								type = "toggle",
								name = L["Overlay"],
								desc = L["Set an overlay tint on unexplored ares on the world map."],
								disabled = function() return not E.db.KlixUI.maps.worldmap.reveal.enable end,
								get = function(info) return E.db.KlixUI.maps.worldmap.reveal[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.maps.worldmap.reveal[ info[#info] ] = value; KWM:Refresh() end,
							},
							overlayColor = {
								type = "color",
								order = 3,
								name = L["Color"],
								hasAlpha = true,
								disabled = function() return not E.db.KlixUI.maps.worldmap.reveal.enable or not E.db.KlixUI.maps.worldmap.reveal.overlay end,
								get = function(info)
									local t = E.db.KlixUI.maps.worldmap.reveal[ info[#info] ]
									return t.r, t.g, t.b, t.a
								end,
								set = function(info, r, g, b, a)
									local t = E.db.KlixUI.maps.worldmap.reveal[ info[#info] ]
									t.r, t.g, t.b, t.a = r, g, b, a
									KWM:Refresh()
								end,
							},
						},
					},
				},
			},
		},
	}
end
T.table_insert(KUI.Config, Maps)

if E.db.KlixUI.maps == nil then E.db.KlixUI.maps = {} end
if E.db.KlixUI.maps.minimap == nil then E.db.KlixUI.maps.minimap = {} end
if E.db.KlixUI.maps.minimap.rectangle then
	local function InjectElvUIMapsOptions()
		E.Options.args.maps.args.minimap.args.generalGroup.args.size = {
			order = 2,
			type = "range",
			name = L["Size"],
			desc = L["Adjust the size of the minimap."],
			min = 150, max = 400, step = 1,
			get = function(info) return E.db.general.minimap.size end,
			set = function(info, value) E.db.general.minimap.size = value; MM:UpdateSettings(); E:StaticPopup_Show("PRIVATE_RL") end,
			disabled = function() return not E.private.general.minimap.enable end,
		}
	end
	T.table_insert(KUI.Config, InjectElvUIMapsOptions)
end

local function injectElvUIDataTextsOptions()
	E.Options.args.maps.args.minimap.args.locationTextGroup.args.spacer1 = {
		order = 21,
		type = 'description',
		name = '',
	}

	E.Options.args.maps.args.minimap.args.locationTextGroup.args.spacer2 = {
		order = 22,
		type = 'header',
		name = '',
	}
	
	E.Options.args.maps.args.minimap.args.locationTextGroup.args.locationdigits = {
		order = 23,
		type = 'range',
		name = KUI:cOption(L["Location Digits"]),
		desc = L["Change the decimals of the coords on the location bar."],
		min = 0, max = 2, step = 1,
		get = function(info) return E.db.KlixUI.maps.minimap.topbar.locationdigits end,
		set = function(info, value) E.db.KlixUI.maps.minimap.topbar.locationdigits = value; E:GetModule("Minimap"):UpdateSettings() end,					
		disabled = function() return E.db.general.minimap.locationText ~= "ABOVE" end,
	}
	
	E.Options.args.maps.args.minimap.args.locationTextGroup.args.locationtext = {
		order = 24,
		type = "select",
		name = KUI:cOption(L["Location Text"]),
		desc = L["Change the text on the location bar."],
		values = {
			["LOCATION"] = L["Location"],
			["VERSION"] = L["Version"],
		},
		get = function(info) return E.db.KlixUI.maps.minimap.topbar.locationtext end,
		set = function(info, value) E.db.KlixUI.maps.minimap.topbar.locationtext = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		disabled = function() return E.db.general.minimap.locationText ~= "ABOVE" end,
	}
	
	E.Options.args.maps.args.minimap.args.locationTextGroup.args.locationText.values = {
		['MOUSEOVER'] = L['Minimap Mouseover'],
		['SHOW'] = L['Always Display'],
		['ABOVE'] = KUI:cOption(L['Above Minimap']),
		['HIDE'] = L['Hide'],
	}
end
T.table_insert(KUI.Config, injectElvUIDataTextsOptions)