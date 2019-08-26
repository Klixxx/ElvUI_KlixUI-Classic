local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KTT = KUI:GetModule("KuiTooltip")
local PI = KUI:GetModule("ProgressInfo")
--local RI = KUI:GetModule("RealmInfo")

local function Tooltip()
	E.Options.args.KlixUI.args.modules.args.tooltip = {
		order = 32,
		type = "group",
		name = L["Tooltip"],
		childGroups = "tab",
		disabled = function() return not E.private.tooltip.enable end,
		get = function(info) return E.db.KlixUI.tooltip[ info[#info] ] end,
		set = function(info, value) E.db.KlixUI.tooltip[ info[#info] ] = value; end,
		args = {
			header = {
				order = 1,
				type = "header",
				name = KUI:cOption(L["Tooltip"]),
			},
			general = {
				type = "group",
				name = L["General"],
				order = 2,
				guiInline = true,
				get = function(info) return E.db.KlixUI.tooltip[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.tooltip[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					tooltip = {
						order = 1,
						type = "toggle",
						name = L["Tooltip"],
						desc = L["Change the visual appearance of the Tooltip.\nCredit: |cffff7d0aMerathilisUI|r"],
					},
					titleColor = {
						order = 2,
						type = "toggle",
						name = L["Title Color"],
						desc = L["Change the color of the title to something more cool!"],
						disabled = function() return not E.private.tooltip.enable or not E.db.KlixUI.tooltip.tooltip end,
					},
					memberInfo = {
						order = 3,
						type = "toggle",
						name = L["LFG Member Info"],
						desc = L["Adds member info for the LFG group list tooltip."],
					},
					achievement = {
						order = 4,
						type = "toggle",
						name = ACHIEVEMENT_BUTTON,
						desc = L["Adds information to the tooltip, on which character you earned an achievement.\nCredit: |cffff7d0aMerathilisUI|r"],
					},
					keystone = {
						order = 5,
						type = "toggle",
						name = L["Keystone"],
						desc = L["Adds descriptions for mythic keystone properties to their tooltips."],
					},
				},
			},
			azerite = {
				type = "group",
				name = L["Azerite"],
				order = 3,
				disabled = function() return T.IsAddOnLoaded("AzeriteTooltip") end,
				hidden = function() return T.IsAddOnLoaded("AzeriteTooltip") end,
				get = function(info) return E.db.KlixUI.tooltip.azerite[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.tooltip.azerite[ info[#info] ] = value end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Enable/disable the azerite tooltip."],
						set = function(info, value) E.db.KlixUI.tooltip.azerite[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
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
					RemoveBlizzard = {
						order = 4,
						type = "toggle",
						name = L["Remove Blizzard"],
						desc = L["Replaces the blizzard azerite tooltip text."],
						disabled = function() return not E.db.KlixUI.tooltip.azerite.enable end,
					},
					OnlySpec = {
						order = 5,
						type = "toggle",
						name = L["Specialization"],
						desc = L["Only show the traits for your current specialization."],
						disabled = function() return not E.db.KlixUI.tooltip.azerite.enable end,
					},
					Compact = {
						order = 6,
						type = "toggle",
						name = L["Compact"],
						desc = L["Only show icons in the azerite tooltip."],
						disabled = function() return not E.db.KlixUI.tooltip.azerite.enable end,
					},
				},
			},
			progressInfo = {
				type = "group",
				name = L["Raid Progression"],
				order = 4,
				disabled = function() return not E.private.tooltip.enable or T.IsAddOnLoaded("RaiderIO") end,
				get = function(info) return E.db.KlixUI.tooltip.progressInfo[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.tooltip.progressInfo[ info[#info] ] = value end,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						desc = L["Shows raid progress of a character in the tooltip.\n|cffff8000Note: The visibility of the raid progress can be changed in the display option.|r"],
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
						type = "select",
						name = L["Display"],
						desc = L["Change how the raid progress should display in the tooltip."],
						disabled = function() return not E.db.KlixUI.tooltip.progressInfo.enable end,
						set = function(info, value) E.db.KlixUI.tooltip.progressInfo[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
						values = {
							["ALWAYS"] = L["Always"],
							["SHIFT"] = L["Shift"],
						},
					},
					NameStyle = {
						order = 5,
						name = L["Name Style"],
						type = "select",
						set = function(info, value) E.db.KlixUI.tooltip.progressInfo[ info[#info] ] = value; T.table_wipe(PI.Cache) end,
						disabled = function() return not E.db.KlixUI.tooltip.progressInfo.enable end,
						values = {
							["LONG"] = L["Full"],
							["SHORT"] = L["Short"],
						},
					},
					DifStyle = {
						order = 6,
						name = L["Difficulty Style"],
						type = "select",
						set = function(info, value) E.db.KlixUI.tooltip.progressInfo[ info[#info] ] = value; T.table_wipe(PI.Cache) end,
						disabled = function() return not E.db.KlixUI.tooltip.progressInfo.enable end,
						values = {
							["LONG"] = L["Full"],
							["SHORT"] = L["Short"],
						},
					},
					Raids = {
						order = 7,
						type = "group",
						name = RAIDS,
						guiInline = true,
						get = function(info) return E.db.KlixUI.tooltip.progressInfo.raids[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.tooltip.progressInfo.raids[ info[#info] ] = value end,
						disabled = function() return not E.db.KlixUI.tooltip.progressInfo.enable end,
						args = {
							uldir = { order = 1, type = "toggle", name = KUI:GetMapInfo(1148 , "name") },
							dazaralor = { order = 2, type = "toggle", name = KUI:GetMapInfo(1358 , "name") },
							crucible = { order = 3, type = "toggle", name = KUI:GetMapInfo(1345 , "name") },
							eternalpalace = { order = 4, type = "toggle", name = KUI:GetMapInfo(1512 , "name") },
						},
					},
				},
			},
			nameHover = {
				order = 5,
				type = "group",
				name = L["Name Hover"],
				desc = L["Shows the unit name, at the cursor, when hovering over a target."],
				get = function(info) return E.db.KlixUI.nameHover[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.nameHover[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
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
					guild = {
						order = 4,
						type = 'toggle',
						name = L["Guild Name"],
						desc = L["Shows the current mouseover units guild name."],
						disabled = function() return not E.db.KlixUI.nameHover.enable end,
					},
					guildRank = {
						order = 5,
						type = 'toggle',
						name = L["Guild Rank"],
						desc = L["Shows the current mouseover units guild rank."],
						disabled = function() return not E.db.KlixUI.nameHover.enable or not E.db.KlixUI.nameHover.guild end,
					},
					space3 = {
						order = 6,
						type = "description",
						name = "",
					},
					realm = {
						order = 7,
						type = 'toggle',
						name = L["Realm Name"],
						desc = L["Shows the current mouseover units realm name when holding down the shift-key."],
						disabled = function() return not E.db.KlixUI.nameHover.enable end,
					},
					realmAlways = {
						order = 8,
						type = 'toggle',
						name = L["Always Show Realm Name"],
						desc = L["Always show the current mouseover units realm name."],
						disabled = function() return not E.db.KlixUI.nameHover.enable or not E.db.KlixUI.nameHover.realm end,
					},
					titles = {
						order = 9,
						type = 'toggle',
						name = L["Titles"],
						desc = L["Shows the current mouseover units titles."],
						disabled = function() return not E.db.KlixUI.nameHover.enable end,
					},
					font = {
						order = 10,
						type = 'select', dialogControl = 'LSM30_Font',
						name = L["Font"],
						values = function()
							return AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font or {}
						end,
						disabled = function() return not E.db.KlixUI.nameHover.enable end,
					},
					fontSize = {
						order = 11,
						type = "range",
						name = L["Size"],
						min = 4, max = 24, step = 1,
						disabled = function() return not E.db.KlixUI.nameHover.enable end,
					},
					fontOutline = {
						order = 12,
						type = "select",
						name = L["Font Outline"],
						values = {
							["NONE"] = NONE,
							["OUTLINE"] = "OUTLINE",
							["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
							["THICKOUTLINE"] = "THICKOUTLINE",
						},
						disabled = function() return not E.db.KlixUI.nameHover.enable end,
					},
				},
			},
			--[[realmInfo = {
				type = "group",
				name = L["Realm Info"],
				order = 10,
				get = function(info) return E.db.KlixUI.tooltip.realmInfo[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.tooltip.realmInfo[ info[#info] ] = value end,
				disabled = function() return not E.private.tooltip.enable end,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						desc = L["Shows realm info in various tooltips."],
					},
					tooltips = {
						order = 2,
						type = "group",
						name = L["Tooltips"],
						disabled = function() return not  E.db.KlixUI.tooltip.realmInfo.enable end,
						get = function(info) return E.db.KlixUI.tooltip.realmInfo[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.tooltip.realmInfo[ info[#info] ] = value end,
						guiInline = true,
						args = {
							ttGrpFinder = {
								order = 1,
								type = "toggle",
								name = LFGLIST_NAME,
								desc = L["Show the realm info in the group finder tooltip."],
							},
							ttPlayer = {
								order = 2,
								type = "toggle",
								name = L["Player Tooltips"],
								desc = L["Show the realm info in the player tooltip."],
							},
							ttFriends = {
								order = 3,
								type = "toggle",
								name = L["Friend List"],
								desc = L["Show the realm info in the friend list tooltip."],
							},
						},
					},
					tooltipLines = {
						order = 3,
						type = "group",
						name = L["Tooltip Lines"],
						disabled = function() return not E.db.KlixUI.tooltip.realmInfo.enable end,
						get = function(info) return E.db.KlixUI.tooltip.realmInfo[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.tooltip.realmInfo[ info[#info] ] = value end,
						guiInline = true,
						args = {
							timezone = {
								order = 2,
								type = "toggle",
								name = L["Realm Timezone"],
								desc = L["Add realm timezone to the tooltip."],
							},
							type = {
								order = 3,
								type = "toggle",
								name = L["Realm Type"],
								desc = L["Add realm type to the tooltip."],
							},
							language = {
								order = 4,
								type = "toggle",
								name = L["Realm Language"],
								desc = L["Add realm language to the tooltip."],
							},
							connectedrealms = {
								order = 5,
								type = "toggle",
								name = L["Connected Realms"],
								desc = L["Add the connected realms to the tooltip."],
							},
							countryflag = {
								order = 6,
								type = "select",
								width = "full",
								name = L["Country Flag"],
								desc = L["Display the country flag without text on the left side in tooltip."],
								values = {
									languageline = L["Behind language in 'Realm language' line"],
									charactername = L["Behind the character name"],
									ownline = L["In own tooltip line on the left site"],
									none = ADDON_DISABLED
								},
							},
						},
					},
					country_flags = {
						order = 4,
						type = "group",
						name = L["Country Flag"],
						guiInline = true,
						disabled = function() return not E.db.KlixUI.tooltip.realmInfo.enable end,
						get = function(info) return E.db.KlixUI.tooltip.realmInfo[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.tooltip.realmInfo[ info[#info] ] = value end,
						args = {
							finder_counryflag = {
								order = 1,
								type = "toggle",
								name = LFGLIST_NAME,
								desc = L["Prepend country flag on character name in group finder."],
							},
							communities_countryflag = {
								order = 2,
								type = "toggle",
								name = COMMUNITIES,
								desc = L["Prepend country flag on character name in community member lists."],
							},
						},
					},
				},
			},]]		
		},
	}
end
T.table_insert(KUI.Config, Tooltip)