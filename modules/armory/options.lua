local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KA = KUI:GetModule("KuiArmory")

local FontStyleList = {
	["NONE"] = NONE,
	["OUTLINE"] = 'OUTLINE',
	["MONOCHROMEOUTLINE"] = 'MONOCROMEOUTLINE',
	["THICKOUTLINE"] = 'THICKOUTLINE'
}

KUI.BackgroundsTextures = {
    Keys = {
        ["0"] = "NONE",
        ["1"] = "CUSTOM",
        ["2"] = "CLASS",
        ["3"] = "FACTION",
        ["4"] = "RACE",
        ["5"] = "Superman",
        ["6"] = "Spiderman",
        ["7"] = "Alliance-bliz",
        ["8"] = "Horde-bliz",
        ["9"] = "Arena-bliz",
        ["10"] = "Space",
    },
    Config = {
        ["0"] = L["NONE"],
        ["1"] = CUSTOM,
        ["2"] = CLASS,
        ["3"] = FACTION,
        ["4"] = RACE,
        ["5"] = L["Superman"],
        ["6"] = L["Spiderman"],
        ["7"] = FACTION_ALLIANCE .. " Blizzard",
        ["8"] = FACTION_HORDE .. " Blizzard",
        ["9"] = ARENA .. " Blizzard",
        ["10"] = L["Space"],
    },
}

local function ArmoryTable()
	E.Options.args.KlixUI.args.modules.args.armory = {
		type = "group",
		order = 4,
		name = L["Armory"],
		childGroups = 'tab',
		get = function(info) return E.db.KlixUI.armory[ info[#info] ] end,
		set = function(info, value) E.db.KlixUI.armory[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = KUI:cOption(L["Armory"]),
			},
			info = {
				order = 2,
				type = "description",
				name = L["ARMORY_DESC"],
			},
			enable = {
				type = "toggle",
				order = 3,
				name = L["Enable"],
				desc = L["Enable/Disable the |cfff960d9KlixUI|r Armory Mode."],
				disabled = function() return T.IsAddOnLoaded("ElvUI_SLE") end,
			},
			gotoarmory = {
				order = 4,
				type = "execute",
				name = L["ElvUI Armory"],
				func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "general", "blizzUIImprovements") end,
			},
			space2 = {
				order = 5,
				type = "description",
				name = "",
			},
			azeritebtn = {
				type = "toggle",
				order = 6,
				name = L["Azerite Buttons"],
				desc = L["Enable/Disable the Azerite Buttons on the character window."],
			},
			naked = {
				type = "toggle",
				order = 7,
				name = L["Naked Button"],
				desc = L["Enable/Disable the Naked Button on the character window."],
			},
			classCrests = {
				type = "toggle",
				order = 8,
				name = L["Class Crests"],
				desc = L["Shows an overlay of the class crests on the character window."],
			},
			durability = {
				order = 10,
				type = "group",
				name = L["Durability"],
				disabled = function() return not E.db.KlixUI.armory.enable or T.IsAddOnLoaded("ElvUI_SLE") end,
				get = function(info) return E.db.KlixUI.armory.durability[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.armory.durability[ info[#info] ] = value; KA:UpdatePaperDoll() end,
				args = {
					enable = {
						type = "toggle",
						order = 1,
						name = L["Enable"],
						desc = L["Enable/Disable the display of durability information on the character window."],
					},
					onlydamaged = {
						type = "toggle",
						order = 2,
						name = L["Damaged Only"],
						desc = L["Only show durability information for items that are damaged."],
						disabled = function() return not E.db.KlixUI.armory.durability.enable end,
					},
					space1 = {
						order = 3,
						type = "description",
						name = "",
					},
					font = {
						order = 4,
						type = "select", dialogControl = "LSM30_Font",
						name = L["Font"],
						values = AceGUIWidgetLSMlists.font,
						disabled = function() return not E.db.KlixUI.armory.durability.enable end,
						set = function(info, value) E.db.KlixUI.armory.durability[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end, 
					},
					textSize = {
						order = 5,
						name = FONT_SIZE,
						type = "range",
						min = 6, max = 22, step = 1,
						disabled = function() return not E.db.KlixUI.armory.durability.enable end,
						set = function(info, value) E.db.KlixUI.armory.durability[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end, 
					},
					fontOutline = {
						order = 6,
						type = "select",
						name = L["Font Outline"],
						values = {
							["NONE"] = NONE,
							["OUTLINE"] = "OUTLINE",
							["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
							["THICKOUTLINE"] = "THICKOUTLINE",
						},
						disabled = function() return not E.db.KlixUI.armory.durability.enable end,
						set = function(info, value) E.db.KlixUI.armory.durability[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end, 
					},
				},
			},
			itemlevel = {
				order = 11,
				type = "group",
				name = L["Itemlevel"],
				disabled = function() return not E.db.KlixUI.armory.enable or E.db.general.itemLevel.displayCharacterInfo or T.IsAddOnLoaded("ElvUI_SLE") end,
				get = function(info) return E.db.KlixUI.armory.ilvl[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.armory.ilvl[ info[#info] ] = value; KA:UpdatePaperDoll() end,
				args = {
					enable = {
						type = "toggle",
						order = 1,
						name = L["Enable"],
						desc = L["Enable/Disable the display of item levels on the character window."],
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
					font = {
						order = 4,
						type = "select", dialogControl = "LSM30_Font",
						name = L["Font"],
						values = AceGUIWidgetLSMlists.font,
						disabled = function() return not E.db.KlixUI.armory.ilvl.enable end,
						set = function(info, value) E.db.KlixUI.armory.ilvl[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL")  end, 
					},
					textSize = {
						order = 5,
						name = FONT_SIZE,
						type = "range",
						min = 6, max = 22, step = 1,
						disabled = function() return not E.db.KlixUI.armory.ilvl.enable end,
						set = function(info, value) E.db.KlixUI.armory.ilvl[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL")  end, 
					},
					fontOutline = {
						order = 6,
						type = "select",
						name = L["Font Outline"],
						values = {
							["NONE"] = NONE,
							["OUTLINE"] = "OUTLINE",
							["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
							["THICKOUTLINE"] = "THICKOUTLINE",
						},
						disabled = function() return not E.db.KlixUI.armory.ilvl.enable end,
						set = function(info, value) E.db.KlixUI.armory.ilvl[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL")  end, 
					},
					colorStyle = {
						order = 7,
						type = "select",
						name = COLOR,
						values = {
							["RARITY"] = RARITY,
							["LEVEL"] = L["Level"],
							["CUSTOM"] = CUSTOM,
						},
						disabled = function() return not E.db.KlixUI.armory.ilvl.enable end,
					},
					color = {
						order = 8,
						type = "color",
						name = COLOR_PICKER,
						disabled = function() return E.db.KlixUI.armory.ilvl.colorStyle == "RARITY" or E.db.KlixUI.armory.ilvl.colorStyle == "LEVEL" or not E.db.KlixUI.armory.ilvl.enable end,
						get = function(info)
							local t = E.db.KlixUI.armory.ilvl[ info[#info] ]
							local d = P.KlixUI.armory.ilvl[info[#info]]
							return t.r, t.g, t.b, t.a, d.r, d.g, d.b
						end,
						set = function(info, r, g, b)
							E.db.KlixUI.armory.ilvl[ info[#info] ] = {}
							local t = E.db.KlixUI.armory.ilvl[ info[#info] ]
							t.r, t.g, t.b, t.a = r, g, b, a
							KA:UpdatePaperDoll()
						end,
					},
				},
			},
			stats = {
				type = 'group',
				name = STAT_CATEGORY_ATTRIBUTES,
				order = 12,
				disabled = function() return not E.db.KlixUI.armory.enable or T.IsAddOnLoaded("DejaCharacterStats") or T.IsAddOnLoaded("ElvUI_SLE") end,
				get = function(info) return E.db.KlixUI.armory.stats[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.armory.stats[ info[#info] ] = value; PaperDollFrame_UpdateStats() end,
				args = {
					IlvlFull = {
						order = 1,
						type = "toggle",
						name = L["Full Item Level"],
						desc = L["Show both equipped and average item levels."],
					},
					IlvlColor = {
						order = 2,
						type = "toggle",
						name = L["Item Level Coloring"],
						desc = L["Color code item levels values. Equipped will be gradient, average - selected color."],
						disabled = function() return not E.db.KlixUI.armory.stats.IlvlFull end,
					},
					AverageColor = {
						type = 'color',
						order = 3,
						name = L["Color of Average"],
						desc = L["Sets the color of average item level."],
						hasAlpha = false,
						disabled = function() return not E.db.KlixUI.armory.stats.IlvlFull or not E.db.KlixUI.armory.stats.IlvlColor end,
						get = function(info)
							local t = E.db.KlixUI.armory.stats[ info[#info] ]
							local d = E.db.KlixUI.armory.stats[info[#info]]
							return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
						end,
						set = function(info, r, g, b, a)
							E.db.KlixUI.armory.stats[ info[#info] ] = {}
							local t = E.db.KlixUI.armory.stats[ info[#info] ]
							t.r, t.g, t.b, t.a = r, g, b, a
							PaperDollFrame_UpdateStats()
						end,
					},
					OnlyPrimary = {
						order = 4,
						type = "toggle",
						name = L["Only Relevant Stats"],
						desc = L["Show only those primary stats relevant to your spec."],
					},
					Stats = {
						type = 'group',
						name = STAT_CATEGORY_ATTRIBUTES,
						order = 7,
						guiInline = true,
						get = function(info) return E.db.KlixUI.armory.stats.List[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.armory.stats.List[ info[#info] ] = value; KA:ToggleStats() end,
						args = {
							HEALTH = { order = 1,type = "toggle",name = HEALTH,},
							POWER = { order = 2,type = "toggle",name = _G[T.select(2, T.UnitPowerType("player"))],},
							ALTERNATEMANA = { order = 3,type = "toggle",name = ALTERNATE_RESOURCE_TEXT,},
							ATTACK_DAMAGE = { order = 4,type = "toggle",name = DAMAGE,},
							ATTACK_AP = { order = 5,type = "toggle",name = ATTACK_POWER,},
							ATTACK_ATTACKSPEED = { order = 6,type = "toggle",name = ATTACK_SPEED,},
							SPELLPOWER = { order = 7,type = "toggle",name = STAT_SPELLPOWER,},
							ENERGY_REGEN = { order = 8,type = "toggle",name = STAT_ENERGY_REGEN,},
							RUNE_REGEN = { order = 9,type = "toggle",name = STAT_RUNE_REGEN,},
							FOCUS_REGEN = { order = 10,type = "toggle",name = STAT_FOCUS_REGEN,},
							MOVESPEED = { order = 11,type = "toggle",name = STAT_SPEED,},
						},
					},
				},
			},
			Fonts = {
				type = "group",
				name = STAT_CATEGORY_ATTRIBUTES..": "..L["Fonts"],
				order = 13,
				disabled = function() return not E.db.KlixUI.armory.enable or E.db.general.itemLevel.displayCharacterInfo or T.IsAddOnLoaded("DejaCharacterStats") or IsAddOnLoaded("ElvUI_SLE") end,
				args = {
					IlvlFont = {
						type = 'group',
						name = STAT_AVERAGE_ITEM_LEVEL,
						order = 1,
						get = function(info) return E.db.KlixUI.armory.stats.ItemLevel[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.armory.stats.ItemLevel[ info[#info] ] = value; KA:UpdateIlvlFont() end,
						args = {
							font = {
								type = 'select', dialogControl = 'LSM30_Font',
								name = L["Font"],
								order = 1,
								values = function()
									return AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font or {}
								end,
							},
							size = {
								type = 'range',
								name = L["Font Size"],
								order = 2,
								min = 6, max = 30, step = 1,
							},
							outline = {
								type = 'select',
								name = L["Font Outline"],
								order = 3,
								values = FontStyleList,
							},
						},
					},
					statFonts = {
						type = 'group',
						name = STAT_CATEGORY_ATTRIBUTES,
						order = 2,
						get = function(info) return E.db.KlixUI.armory.stats.statFonts[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.armory.stats.statFonts[ info[#info] ] = value; KA:PaperDollFrame_UpdateStats() end,
						args = {
							font = {
								type = 'select', dialogControl = 'LSM30_Font',
								name = L["Font"],
								order = 1,
								values = function()
									return AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font or {}
								end,
							},
							size = {
								type = 'range',
								name = L["Font Size"],
								order = 2,
								min = 6,max = 22,step = 1,
							},
							outline = {
								type = 'select',
								name = L["Font Outline"],
								order = 3,
								values = FontStyleList,
							},
						},
					},
					catFonts = {
						type = 'group',
						name = L["Categories"],
						order = 3,
						get = function(info) return E.db.KlixUI.armory.stats.catFonts[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.armory.stats.catFonts[ info[#info] ] = value; KA:PaperDollFrame_UpdateStats() end,
						args = {
							font = {
								type = 'select', dialogControl = 'LSM30_Font',
								name = L["Font"],
								order = 1,
								values = function()
									return AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font or {}
								end,
							},
							size = {
								type = 'range',
								name = L["Font Size"],
								order = 2,
								min = 6,max = 22,step = 1,
							},
							outline = {
								type = 'select',
								name = L["Font Outline"],
								order = 3,
								values = FontStyleList,
							},
						},
					},
				},
			},
			indicators = {
				order = 14,
				type = "group",
				name = L["Indicators"],
				disabled = function() return not E.db.KlixUI.armory.enable or T.IsAddOnLoaded("ElvUI_SLE") end,
				args = {
					enchant = {
						order = 1,
						type = "group",
						name = L["Enchant"],
						disabled = function() return E.db.general.itemLevel.displayCharacterInfo end,
						get = function(info) return E.db.KlixUI.armory.indicators.enchant[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.armory.indicators.enchant[ info[#info] ] = value; KA:UpdatePaperDoll() end,
						args = {
							enable = {
								type = "toggle",
								order = 1,
								name = L["Enable"],
								desc = L["Shows an indictor for enchanted/not enchanted items."],
							},
							glow = {
								order = 2,
								type = "group",
								name = L["Glow Indicator"],
								guiInline = true,
								disabled = function() return not E.db.KlixUI.armory.indicators.enchant.enable end,
								get = function(info) return E.db.KlixUI.armory.indicators.enchant.glow[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.armory.indicators.enchant.glow[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
								args = {
									enable = {
										order = 1,
										type = "toggle",
										name = L["Enable"],
										desc = L["Shows a glow indicator of not enchanted items only."],
									},
									style = {
										order = 2,
										type = "select",
										name = L["Style"],
										values = {
											["Button"] = L["Button Glow"],
											["Pixel"] = L["Pixel Glow"],
											["AutoCast"] = L["AutoCast Glow"],
										},
										disabled = function() return not E.db.KlixUI.armory.indicators.enchant.glow.enable end,
										set = function(info, value) E.db.KlixUI.armory.indicators.enchant.glow.style = value; KA:UpdatePaperDoll() end,
									},
									color = {
										order = 3,
										type = "color",
										name = L["Color"],
										hasAlpha = true,
										disabled = function() return not E.db.KlixUI.armory.indicators.enchant.glow.enable end,
										get = function(info)
											local t = E.db.KlixUI.armory.indicators.enchant.glow.color
											return t.r, t.g, t.b, t.a
										end,
										set = function(info, r, g, b, a)
											local t = E.db.KlixUI.armory.indicators.enchant.glow.color
											t.r, t.g, t.b, t.a = r, g, b, a
											KA:UpdatePaperDoll()
										end,
									},
								},
							},
						},
					},
					socket = {
						order = 2,
						type = "group",
						name = L["Socket"],
						disabled = function() return E.db.general.itemLevel.displayCharacterInfo end,
						get = function(info) return E.db.KlixUI.armory.indicators.socket[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.armory.indicators.socket[ info[#info] ] = value; KA:UpdatePaperDoll() end,
						args = {
							enable = {
								type = "toggle",
								order = 1,
								name = L["Enable"],
								desc = L["Shows an indictor for socketed/unsocketed items."],
							},
							glow = {
								order = 2,
								type = "group",
								name = L["Glow Indicator"],
								guiInline = true,
								disabled = function() return not E.db.KlixUI.armory.indicators.socket.enable end,
								get = function(info) return E.db.KlixUI.armory.indicators.socket.glow[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.armory.indicators.socket.glow[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
								args = {
									enable = {
										type = "toggle",
										order = 1,
										name = L["Enable"],
										desc = L["Shows a glow indictor for unsocketed items only."],
									},
									style = {
										order = 2,
										type = "select",
										name = L["Style"],
										values = {
											["Button"] = L["Button Glow"],
											["Pixel"] = L["Pixel Glow"],
											["AutoCast"] = L["AutoCast Glow"],
										},
										disabled = function() return not E.db.KlixUI.armory.indicators.socket.glow.enable end,
										set = function(info, value) E.db.KlixUI.armory.indicators.socket.glow.style = value; KA:UpdatePaperDoll() end,
									},
									color = {
										order = 3,
										type = "color",
										name = L["Color"],
										hasAlpha = true,
										disabled = function() return not E.db.KlixUI.armory.indicators.socket.glow.enable end,
										get = function(info)
											local t = E.db.KlixUI.armory.indicators.socket.glow.color
											return t.r, t.g, t.b, t.a
										end,
										set = function(info, r, g, b, a)
											local t = E.db.KlixUI.armory.indicators.socket.glow.color
											t.r, t.g, t.b, t.a = r, g, b, a
											KA:UpdatePaperDoll()
										end,
									},
								},
							},
						},
					},
					transmog = {
						order = 3,
						type = "group",
						name = L["Transmog"],
						get = function(info) return E.db.KlixUI.armory.indicators.transmog[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.armory.indicators.transmog[ info[#info] ] = value; KA:UpdatePaperDoll() end,
						args = {
							enable = {
								type = "toggle",
								order = 1,
								name = L["Enable"],
								desc = L["Shows an arrow indictor for currently transmogrified items."],
							},
						},
					},
					illusion = {
						order = 4,
						type = "group",
						name = L["Illusion"],
						get = function(info) return E.db.KlixUI.armory.indicators.illusion[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.armory.indicators.illusion[ info[#info] ] = value; KA:UpdatePaperDoll() end,
						args = {
							enable = {
								type = "toggle",
								order = 1,
								name = L["Enable"],
								desc = L["Shows an indictor for weapon illusions."],
							},
						},
					},
				},
			},
			gradient = {
				order = 15,
				type = 'group',
				name = L["Gradient"],
				disabled = function() return not E.db.KlixUI.armory.enable or T.IsAddOnLoaded("ElvUI_SLE") end,
				get = function(info) return E.db.KlixUI.armory.gradient[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.armory.gradient[ info[#info] ] = value; KA:UpdatePaperDoll() end,
				args = {
					enable = {
						type = 'toggle',
						name = L["Enable"],
						order = 1,
					},
					colorStyle = {
						order = 2,
						type = "select",
						name = COLOR,
						values = {
							["RARITY"] = RARITY,
							["VALUE"] = L["Value"],
							["CUSTOM"] = CUSTOM,
						},
					},
					color = {
						order = 3,
						type = "color",
						name = COLOR_PICKER,
						disabled = function() return E.db.KlixUI.armory.gradient.colorStyle == "RARITY" or E.db.KlixUI.armory.gradient.colorStyle == "VALUE" or not E.db.KlixUI.armory.gradient.enable end,
						get = function(info)
							local t = E.db.KlixUI.armory.gradient[ info[#info] ]
							local d = P.KlixUI.armory.gradient[info[#info]]
							return t.r, t.g, t.b, d.r, d.g, d.b
						end,
						set = function(info, r, g, b)
							E.db.KlixUI.armory.gradient[ info[#info] ] = {}
							local t = E.db.KlixUI.armory.gradient[ info[#info] ]
							t.r, t.g, t.b = r, g, b
							KA:UpdatePaperDoll()
						end,
					},
					alpha = {
						order = 4,
						type = "range",
						name = L["alpha"],
						min = 0, max = 1, step = .1,
					},
				},
			},
			backdrop = {
                order = 16,
                type = "group",
                name = L["Background"],
                disabled = function() return not E.db.KlixUI.armory.enable or T.IsAddOnLoaded("ElvUI_SLE") end,
				get = function(info) return E.db.KlixUI.armory.backdrop[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.armory.backdrop[ info[#info] ] = value; end,
                args = {
                    selectedBG = {
                        order = 1,
                        type = "select",
                        name = L["Select Image"],
                        get = function()
                            for Index, Key in pairs(KUI.BackgroundsTextures.Keys) do
                                if Key == E.db.KlixUI.armory.backdrop.selectedBG then
                                    return Index
								end
                            end
                            return "1"
                        end,
                        set = function(_, value)
                            E.db.KlixUI.armory.backdrop.selectedBG = KUI.BackgroundsTextures.Keys[value];
                            KA:Update_BG(_G["KuiCharacterArmory"])
                        end,
                        values = function()
                            return KUI.BackgroundsTextures.Config
                        end,
                    },
                    overlay = {
                        order = 2,
                        type = "toggle",
                        name = L["Overlay"],
                        set = function(_, value) E.db.KlixUI.armory.backdrop.overlay = value; KA:ElvOverlayToggle() end,
                    },
                    alpha = {
                        order = 3,
                        name = L["Alpha"],
                        type = "range",
                        min = 0, max = 1, step = .1,
                        set = function(_, value) E.db.KlixUI.armory.backdrop.alpha = value; KA:Update_BG(_G["KuiCharacterArmory"]) end,
                    },
                    space1 = {
                        order = 4,
                        type = "description",
                        name = "",
                    },
                    customAddress = {
                        order = 5,
                        type = "input",
                        width = "double",
                        name = L["Custom Image Path"],
                        set = function(_, value) E.db.KlixUI.armory.backdrop.customAddress = value; KA:Update_BG(_G["KuiCharacterArmory"]) end,
                        hidden = function() return E.db.KlixUI.armory.backdrop.selectedBG ~= "CUSTOM" end,
                    },
                },
            },
			statsPanel = {
				order = 20,
				type = "group",
				name = L["Stats Panel"],
				disabled = function() return not E.db.KlixUI.armory.enable or T.IsAddOnLoaded("ElvUI_SLE") end,
				get = function(info) return E.db.KlixUI.armory.statsPanel[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.armory.statsPanel[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
				args = {
					enable = {
						type = "toggle",
						order = 1,
						name = L["Enable"],
						desc = L["Shows the stats panel on the character window.\n|cffff8000Note: Recommended stats pulled from Icy-Veins.com the 09th of Februrary.|r"],
					},
					height = {
						order = 2,
						name = L["Height"],
						type = "range",
						min = 10, max = 100, step = 1,
						disabled = function() return not E.db.KlixUI.armory.statsPanel.enable end,
						set = function(info, value) E.db.KlixUI.armory.statsPanel.height = value; KA:UpdatePanel() end, 
					},
					position = {
						order = 3,
						name = L["Position"],
						type = "select",
						values = {
							["TOP"] = L["Top"],
							["BOTTOM"] = L["Bottom"],
						},
						disabled = function() return not E.db.KlixUI.armory.statsPanel.enable end,
						set = function(info, value) E.db.KlixUI.armory.statsPanel.position = value; KA:UpdatePanel() end, 
					},
					customStats = {
						order = 5,
						type = "input",
						width = "full",
						multiline = true,
						name = L["Custom Text"],
						desc = L["Add, remove and edit the text on the stats panel to your preference."],
						disabled = function() return not E.db.KlixUI.armory.statsPanel.enable end,
						set = function(info, value) E.db.KlixUI.armory.statsPanel.customStats = value; KA:UpdatePanel() end,
					},
				},
			},
		},
	}
end
T.table_insert(KUI.Config, ArmoryTable)

local function injectElvUIArmoryOptions()
	E.Options.args.general.args.blizzUIImprovements.args.itemLevelInfo.args.displayCharacterInfo = {
		order = 1,
		type = "toggle",
		name = L["Display Character Info"],
		desc = L["Shows item level of each item, enchants, and gems on the character page."],
		set = function(info, value)
			E.db.general.itemLevel.displayCharacterInfo = value;
			E:GetModule('Misc'):ToggleItemLevelInfo(); E:StaticPopup_Show("PRIVATE_RL")
		end
	}
	
	E.Options.args.general.args.blizzUIImprovements.args.itemLevelInfo.args.gotoklixui = {
		order = 2,
		type = "execute",
		name = KUI:cOption(L["KlixUI Armory"]),
		func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "KlixUI", "modules", "armory") end,
	}
end
T.table_insert(KUI.Config, injectElvUIArmoryOptions)