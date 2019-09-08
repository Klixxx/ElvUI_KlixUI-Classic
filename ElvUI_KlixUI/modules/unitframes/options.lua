local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KUF = KUI:GetModule("KuiUnits")
local KEI = KUI:GetModule('KuiEliteIcon')
--local KUIC = KUI:GetModule('KuiCastbar')
local UF = E:GetModule("UnitFrames")

local isEnabled = E.private["unitframe"].enable and true or false

local texPath = [[Interface\AddOns\ElvUI_KlixUI\media\textures\roleIcons\]]
local texPathE = [[Interface\AddOns\ElvUI\media\textures\]]
local texPathR = [[Interface\RaidFrame\]]
local texPathB = [[Interface\AddOns\ElvUI_KlixUI\media\textures\readycheckIcons\]]
local texPathS = [[Interface\AddOns\ElvUI_KlixUI\media\textures\readycheckIcons\]]

local PointNames = {
	["CENTER"] = "CENTER",
	["BOTTOM"] = "BOTTOM",
	["TOP"] = "TOP",
	["LEFT"] = "LEFT",
	["RIGHT"] = "RIGHT",
	["BOTTOMLEFT"] = "BOTTOMLEFT",
	["BOTTOMRIGHT"] = "BOTTOMRIGHT",
	["TOPLEFT"] = "TOPLEFT",
	["TOPRIGHT"] = "TOPRIGHT",
}

local function UnitFramesTable()
	E.Options.args.KlixUI.args.modules.args.unitframes = {
		order = 35,
		type = "group",
		name = L["UnitFrames"],
		childGroups = 'tab',
		disabled = function() return not E.private.unitframe.enable end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = KUI:cOption(L["UnitFrames"]),
			},
			general = {
				order = 2,
				type = "group",
				name = L["General"],
				args = {
					powerBar = {
						type = 'toggle',
						order = 1,
						name = L['Power Bar'],
						desc = L['This will enable/disable the |cfff960d9KlixUI|r powerbar modification.|r'],
						get = function(info) return E.db.KlixUI.unitframes.powerBar end,
						set = function(info, value) E.db.KlixUI.unitframes.powerBar = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
					space1 = {
						order = 9,
						type = "description",
						name = "",
					},
					tags = {
						order = 15,
						type = "group",
						name = KUI.Title..L["Tags"],
						guiInline = true,
						args = {
							health = {
								order = 1,
								type = "group",
								name = L["Health"],
								args = {
									desc1 = {
										order = 1,
										type = "description",
										name = "[health:current-kui] - "..L["Example:"].." Display current health no decimals e.g. 100k",
									},
									desc2 = {
										order = 2,
										type = "description",
										name = "[health:percent-kui] - "..L["Example:"].." Display health percent no decimals e.g. 100%",
									},
									desc3 = {
										order = 3,
										type = "description",
										name = "[health:current-percent-kui] - "..L["Example:"].." 100k | 100% and RIP text instead of Dead",
									},
									desc4 = {
										order = 4,
										type = "description",
										name = "[health:current-percent1-kui] - "..L["Example:"].." 100% | 100k RIP text instead of Dead",
									},
									desc5 = {
										order = 5,
										type = "description",
										name = "[health:deficit-kui] - "..L["Example:"].." Classic deficit with RIP text instead of Dead",
									},
								},
							},
							power = {
								order = 2,
								type = "group",
								name = L["Power"],
								args = {
									desc1 = {
										order = 1,
										type = "description",
										name = "[power:current-kui] - "..L["Example:"].." Display current power and 0 when no power",
									},
									desc2 = {
										order = 2,
										type = "description",
										name = "[power:percent-kui] - "..L["Example:"].." Display power percent no decimals e.g. 100",
									},
								},
							},
						},
					},
				},
			},
			auras = {
				order = 3,
				type = "group",
				name = L["Auras"],
				childGroups = 'tab',
				args = {
					auraiconspacing = {
						order = 1,
						type = "group",
						name = L["Aura Icon Spacing"],
						args = {
							spacing = {
								type = 'range',
								order = 1,
								name = L["Aura Spacing"],
								desc = L["Sets space between individual aura icons."],
								get = function(info) return E.db.KlixUI.unitframes.AuraIconSpacing.spacing end,
								set = function(info, value) E.db.KlixUI.unitframes.AuraIconSpacing.spacing = value; KUF:UpdateAuraSettings(); end,
								disabled = function() return not isEnabled end,
								min = 0, max = 10, step = 1,
							},
							units = {
								type = "multiselect",
								order = 2,
								name = L["Set Aura Spacing On Following Units"],
								get = function(info, key) return E.db.KlixUI.unitframes.AuraIconSpacing.units[key] end,
								set = function(info, key, value) E.db.KlixUI.unitframes.AuraIconSpacing.units[key] = value; KUF:UpdateAuraSettings(); end,
								disabled = function() return not isEnabled end,
								values = {
									['player'] = L["Player"],
									['target'] = L["Target"],
									['targettarget'] = L["TargetTarget"],
									['targettargettarget'] = L["TargetTargetTarget"],
									['focus'] = L["Focus"],
									['focustarget'] = L["FocusTarget"],
									['pet'] = L["Pet"],
									['pettarget'] = L["PetTarget"],
									['arena'] = L["Arena"],
									['boss'] = L["Boss"],
									['party'] = L["Party"],
									['raid'] = L["Raid"],
									['raid40'] = L["Raid40"],
									['raidpet'] = L["RaidPet"],
									["tank"] = L["Tank"],
									["assist"] = L["Assist"],
								},
							},
						},
					},
				},
			},
			textures = {
				order = 6,
				type = 'group',
				name = L['Textures'],
				args = {
					health = {
						type = 'select', dialogControl = 'LSM30_Statusbar',
						order = 1,
						name = L['Health'],
						desc = L['Health statusbar texture. Applies only on Group Frames'],
						values = AceGUIWidgetLSMlists.statusbar,
						get = function(info) return E.db.KlixUI.unitframes.textures[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.unitframes.textures[ info[#info] ] = value; KUF:ChangeHealthBarTexture() end,
					},
					ignoreTransparency = {
						type = 'toggle',
						order = 2,
						name = L['Ignore Transparency'],
						desc = L['This will ignore ElvUI Health Transparency setting on all Group Frames.'],
						get = function(info) return E.db.KlixUI.unitframes.textures[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.unitframes.textures[ info[#info] ] = value; UF:Update_AllFrames(); end,
					},
					spacer = {
						order = 3,
						type = 'header',
						name = '',
					},
					power = {
						type = 'select', dialogControl = 'LSM30_Statusbar',
						order = 4,
						name = L['Power'],
						desc = L['Power statusbar texture.'],
						values = AceGUIWidgetLSMlists.statusbar,
						get = function(info) return E.db.KlixUI.unitframes.textures[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.unitframes.textures[ info[#info] ] = value; KUF:ChangePowerBarTexture() end,
					},
				},
			},
			eliteicon = {
				order = 9,
				type = "group",
				name = L["Elite Icon"],
				get = function(info) return E.db.KlixUI.unitframes.eliteicon[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.unitframes.eliteicon[ info[#info] ] = value; KEI:SetEliteIcon(); end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Show the elite icon on the target frame."],
						get = function(info) return E.db.KlixUI.unitframes.eliteicon.enable end,
						set = function(info, value) E.db.KlixUI.unitframes.eliteicon.enable = value; E:StaticPopup_Show("PRIVATE_RL"); end,
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
					size = {
						order = 4,
						type = "range",
						name = L["Icon Size"],
						disabled = function() return not E.db.KlixUI.unitframes.eliteicon.enable end,
						min = 1, max = 40, step = 1,
					},
					point = {
						order = 5,
						type = "select",
						name = L["Anchor Point"],
						disabled = function() return not E.db.KlixUI.unitframes.eliteicon.enable end,
						values = PointNames,
					},
					relativePoint = {
						order = 6,
						type = "select",
						name = L["Relative Point"],
						disabled = function() return not E.db.KlixUI.unitframes.eliteicon.enable end,
						values = PointNames,
					},
					xOffset = {
						order = 7,
						type = "range",
						name = L["X-Offset"],
						disabled = function() return not E.db.KlixUI.unitframes.eliteicon.enable end,
						min = -350, max = 350, step = 1,
					},
					yOffset = {
						order = 8,
						type = "range",
						name = L["Y-Offset"],
						disabled = function() return not E.db.KlixUI.unitframes.eliteicon.enable end,
						min = -350, max = 350, step = 1,
					},
					strata = {
						order = 9,
						type = "select",
						name = L["Frame Strata"],
						disabled = function() return not E.db.KlixUI.unitframes.eliteicon.enable end,
						values = {
							["1-BACKGROUND"] = "BACKGROUND",
							["2-LOW"] = "LOW",
							["3-MEDIUM"] = "MEDIUM",
							["4-HIGH"] = "HIGH",
							["5-DIALOG"] = "DIALOG",
							["6-FULLSCREEN"] = "FULLSCREEN",
							["7-FULLSCREEN_DIALOG"] = "FULLSCREEN_DIALOG",
							["8-TOOLTIP"] = "TOOLTIP",
						},
					},
					level = {
						order = 10,
						type = "range",
						name = L["Frame Level"],
						disabled = function() return not E.db.KlixUI.unitframes.eliteicon.enable end,
						min = 0, max = 255, step = 1,
					},
				},
			},
			attackicon = {
				order = 10,
				type = 'group',
				name = L['Attack Icon'],
				get = function(info) return E.db.KlixUI.unitframes.attackicon[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.unitframes.attackicon[ info[#info] ] = value; KEI:SetEliteIcon(); end,
				args = {
					enable = {
						type = 'toggle',
						order = 1,
						name = L['Enable'],
						desc = L['Show attack icon for units that are not tapped by you or your group, but still give kill credit when attacked.'],
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
					size = {
						order = 4,
						type = "range",
						name = L["Icon Size"],
						disabled = function() return not E.db.KlixUI.unitframes.attackicon.enable end,
						min = 1, max = 40, step = 1,
					},
					point = {
						order = 5,
						type = "select",
						name = L["Anchor Point"],
						disabled = function() return not E.db.KlixUI.unitframes.attackicon.enable end,
						values = PointNames,
					},
					relativePoint = {
						order = 6,
						type = "select",
						name = L["Relative Point"],
						disabled = function() return not E.db.KlixUI.unitframes.attackicon.enable end,
						values = PointNames,
					},
					xOffset = {
						order = 7,
						type = "range",
						name = L["X-Offset"],
						disabled = function() return not E.db.KlixUI.unitframes.attackicon.enable end,
						min = -350, max = 350, step = 1,
					},
					yOffset = {
						order = 8,
						type = "range",
						name = L["Y-Offset"],
						disabled = function() return not E.db.KlixUI.unitframes.attackicon.enable end,
						min = -350, max = 350, step = 1,
					},
					strata = {
						order = 9,
						type = "select",
						name = L["Frame Strata"],
						disabled = function() return not E.db.KlixUI.unitframes.attackicon.enable end,
						values = {
							["1-BACKGROUND"] = "BACKGROUND",
							["2-LOW"] = "LOW",
							["3-MEDIUM"] = "MEDIUM",
							["4-HIGH"] = "HIGH",
							["5-DIALOG"] = "DIALOG",
							["6-FULLSCREEN"] = "FULLSCREEN",
							["7-FULLSCREEN_DIALOG"] = "FULLSCREEN_DIALOG",
							["8-TOOLTIP"] = "TOOLTIP",
						},
					},
					level = {
						order = 10,
						type = "range",
						name = L["Frame Level"],
						disabled = function() return not E.db.KlixUI.unitframes.attackicon.enable end,
						min = 0, max = 255, step = 1,
					},
				},
			},
			icons = {
				order = 15,
				type = 'group',
				name = L['Icons'],
				args = {
					role = {
						order = 1,
						type = "select",
						name = L["LFG Icons"],
						desc = L["Choose what icon set there will be used on unitframes and in the chat."],
						disabled = function() return T.IsAddOnLoaded("ElvUI_SLE") end,
						hidden = function() return T.IsAddOnLoaded("ElvUI_SLE") end,
						get = function(info) return E.db.KlixUI.unitframes.icons.role end,
						set = function(info, value) E.db.KlixUI.unitframes.icons.role = value; E:GetModule('Chat'):CheckLFGRoles(); UF:UpdateAllHeaders() end,
						values = {
							["ElvUI"] = "ElvUI ".."|T"..texPathE.."tank:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPathE.."healer:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPathE.."dps:15:15:0:0:64:64:2:56:2:56|t ",
							["SupervillainUI"] = "Supervillain UI ".."|T"..texPath.."svui-tank:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPath.."svui-healer:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPath.."svui-dps:15:15:0:0:64:64:2:56:2:56|t ",
							["Blizzard"] = "Blizzard ".."|T"..texPath.."blizz-tank:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPath.."blizz-healer:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPath.."blizz-dps:15:15:0:0:64:64:2:56:2:56|t ",
							["MiirGui"] = "MiirGui ".."|T"..texPath.."mg-tank:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPath.."mg-healer:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPath.."mg-dps:15:15:0:0:64:64:2:56:2:56|t ",
							["Lyn"] = "Lyn ".."|T"..texPath.."lyn-tank:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPath.."lyn-healer:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPath.."lyn-dps:15:15:0:0:64:64:2:56:2:56|t ",
						},
					},
					rdy = {
						order = 1,
						type = "select",
						name = L["ReadyCheck Icons"],
						desc = L["Choose what icon set there will be used on unitframes and in the chat."],
						get = function(info) return E.db.KlixUI.unitframes.icons.rdy end,
						set = function(info, value) E.db.KlixUI.unitframes.icons.rdy = value; E:StaticPopup_Show("PRIVATE_RL"); end,
						values = {
							["Default"] = "Default ".."|T"..texPathR.."ReadyCheck-Ready:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPathR.."ReadyCheck-NotReady:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPathR.."ReadyCheck-Waiting:15:15:0:0:64:64:2:56:2:56|t ",
							["BenikUI"] = "Benik UI ".."|T"..texPathB.."bui-ready:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPathB.."bui-notready:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPathB.."bui-waiting:15:15:0:0:64:64:2:56:2:56|t ",
							["Smiley"] = "Smiley ".."|T"..texPathS.."smiley-ready:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPathS.."smiley-notready:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPathS.."smiley-waiting:15:15:0:0:64:64:2:56:2:56|t ",
						},
					},
					klixri = {
						order = 2,
						type = 'toggle',
						name = L['|cfff960d9KlixUI|r Raid Icons'],
						desc = L['Replaces the default Raid Icons with the |cfff960d9KlixUI|r ones.\n|cffff8000Note: The Raid Icons Set can be changed in the |cfff960d9KlixUI|r |cffff8000Raid Markers option.|r'],
						get = function(info) return E.db.KlixUI.unitframes.icons[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.unitframes.icons[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
				},
			},
		},
	}
end
T.table_insert(KUI.Config, UnitFramesTable)