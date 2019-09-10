local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KA = KUI:GetModule("KuiArmory")

local FontStyleList = {
	["NONE"] = NONE,
	["OUTLINE"] = 'OUTLINE',
	["MONOCHROMEOUTLINE"] = 'MONOCROMEOUTLINE',
	["THICKOUTLINE"] = 'THICKOUTLINE'
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
			durability = {
				order = 10,
				type = "group",
				name = L["Durability"],
				disabled = function() return not E.db.KlixUI.armory.enable end,
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
				--disabled = function() return not E.db.KlixUI.armory.enable or E.db.general.itemLevel.displayCharacterInfo end,
				disabled = true,
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
			--[[indicators = {
				order = 14,
				type = "group",
				name = L["Indicators"],
				disabled = function() return not E.db.KlixUI.armory.enable end,
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
				},
			},]]
			gradient = {
				order = 15,
				type = 'group',
				name = L["Gradient"],
				disabled = function() return not E.db.KlixUI.armory.enable end,
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
		},
	}
end
T.table_insert(KUI.Config, ArmoryTable)