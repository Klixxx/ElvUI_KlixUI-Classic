local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KT = KUI:GetModule("KuiToasts")

local function ToastTable()
	E.Options.args.KlixUI.args.modules.args.toasts = {
		type = "group",
		order = 30,
		childGroups = 'tab',
		name = L["Toasts"],
		hidden = function() return T.IsAddOnLoaded('ls_Toasts') end,
		disabled = function() return T.IsAddOnLoaded('ls_Toasts') end,
		get = function(info) return E.db.KlixUI.toasts[ info[#info] ] end,
		set = function(info, value) E.db.KlixUI.toasts[ info[#info] ] = value; end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = KUI:cOption(L["Toasts"]),
			},
			desc = {
				order = 2,
				type = "description",
				name = L["TOAST_DESC"],
			},
			enable = {
				order = 3,
				type = "toggle",
				width = "full",
				name = L["Enable"],
				set = function(info, value) E.db.KlixUI.toasts.enable = value; E:StaticPopup_Show("PRIVATE_RL"); end,
			},
			growth_direction = {
				order = 4,
				type = "select",
				name = L["Growth Direction"],
				values = {
					["UP"] = L["Up"],
					["DOWN"] = L["Down"],
					["LEFT"] = L["Left"],
					["RIGHT"] = L["Right"],
				},
				disabled = function() return not E.db.KlixUI.toasts.enable end,
			},
			max_active_toasts = {
				order = 5,
				type = "range",
				name = L["Number of Toasts"],
				min = 1, max = 30, step = 1,
				disabled = function() return not E.db.KlixUI.toasts.enable end,
			},
			sfx_enabled = {
				order = 6,
				type = "toggle",
				name = L["Sound Effects"],
				desc = "",
				disabled = function() return not E.db.KlixUI.toasts.enable end,
			},
			fadeout_delay = {
				order = 7,
				type = "range",
				name = L["Fade Out Delay"],
				min = 0.8, max = 10, step = 0.4,
				disabled = function() return not E.db.KlixUI.toasts.enable end,
			},
			scale = {
				order = 8,
				type = "range",
				name = L["Scale"],
				min = 0.8, max = 2, step = 0.1,
				disabled = function() return not E.db.KlixUI.toasts.enable end,
			},
			colored_names_enabled = {
				order = 9,
				type = "toggle",
				name = L["Colored Names"],
				disabled = function() return not E.db.KlixUI.toasts.enable end,
			},
			types = {
				order = 15,
				type = "group",
				name = L["Toast Types"],
				disabled = function() return not E.db.KlixUI.toasts.enable end,
				args = {
					achievement = {
						order = 1,
						type = "group",
						name = L["Achievement"],
						args = {
							achievement_enabled = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								get = function(info) return E.db.KlixUI.toasts.achievement_enabled end,
								set = function(info, value) E.db.KlixUI.toasts.achievement_enabled = value; end,
							},
							dnd = {
								order = 2,
								type = "toggle",
								name = L["DND"],
								disabled = function() return not E.db.KlixUI.toasts.achievement_enabled end,
								get = function(info) return E.db.KlixUI.toasts.dnd.achievement end,
								set = function(info, value) E.db.KlixUI.toasts.dnd.achievement = value; end,
							},
						},
					},
					archaeology = {
						order = 2,
						type = "group",
						name = L["Archaeology"],
						args = {
							archaeology_enabled = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								get = function(info) return E.db.KlixUI.toasts.archaeology_enabled end,
								set = function(info, value) E.db.KlixUI.toasts.archaeology_enabled = value; end,
							},
							dnd = {
								order = 2,
								type = "toggle",
								name = L["DND"],
								disabled = function() return not E.db.KlixUI.toasts.archaeology_enabled end,
								get = function(info) return E.db.KlixUI.toasts.dnd.archaeology end,
								set = function(info, value) E.db.KlixUI.toasts.dnd.archaeology = value; end,
							},
						},
					},
					garrison_6_0 = {
						order = 3,
						type = "group",
						name = L["Garrison"],
						args = {
							garrison_6_0_enabled = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								get = function(info) return E.db.KlixUI.toasts.garrison_6_0_enabled end,
								set = function(info, value) E.db.KlixUI.toasts.garrison_6_0_enabled = value; end,
							},
							dnd = {
								order = 2,
								type = "toggle",
								name = L["DND"],
								disabled = function() return not E.db.KlixUI.toasts.garrison_6_0_enabled end,
								get = function(info) return E.db.KlixUI.toasts.dnd.garrison_6_0 end,
								set = function(info, value) E.db.KlixUI.toasts.dnd.garrison_6_0 = value; end,
							},
						},
					},
					garrison_7_0 = {
						order = 4,
						type = "group",
						name = L["Class Hall"],
						args = {
							garrison_7_0_enabled = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								get = function(info) return E.db.KlixUI.toasts.garrison_7_0_enabled end,
								set = function(info, value) E.db.KlixUI.toasts.garrison_7_0_enabled = value; end,
							},
							dnd = {
								order = 2,
								type = "toggle",
								name = L["DND"],
								disabled = function() return not E.db.KlixUI.toasts.garrison_7_0_enabled end,
								get = function(info) return E.db.KlixUI.toasts.dnd.garrison_7_0 end,
								set = function(info, value) E.db.KlixUI.toasts.dnd.garrison_7_0 = value; end,
							},
						},
					},
					garrison_8_0 = {
						order = 5,
						type = "group",
						name = L["War Effort"],
						args = {
							garrison_8_0_enabled = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								get = function(info) return E.db.KlixUI.toasts.garrison_8_0_enabled end,
								set = function(info, value) E.db.KlixUI.toasts.garrison_8_0_enabled = value; end,
							},
							dnd = {
								order = 2,
								type = "toggle",
								name = L["DND"],
								disabled = function() return not E.db.KlixUI.toasts.garrison_8_0_enabled end,
								get = function(info) return E.db.KlixUI.toasts.dnd.garrison_8_0 end,
								set = function(info, value) E.db.KlixUI.toasts.dnd.garrison_8_0 = value; end,
							},
						},
					},
					instance = {
						order = 6,
						type = "group",
						name = L["Dungeon"],
						args = {
							instance_enabled = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								get = function(info) return E.db.KlixUI.toasts.instance_enabled end,
								set = function(info, value) E.db.KlixUI.toasts.instance_enabled = value; end,
							},
							dnd = {
								order = 2,
								type = "toggle",
								name = L["DND"],
								disabled = function() return not E.db.KlixUI.toasts.instance_enabled end,
								get = function(info) return E.db.KlixUI.toasts.dnd.instance end,
								set = function(info, value) E.db.KlixUI.toasts.dnd.instance = value; end,
							},
						},
					},
					loot_common = {
						order = 7,
						type = "group",
						name = L["Loot (Common)"],
						args = {
							loot_common_enabled = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								get = function(info) return E.db.KlixUI.toasts.loot_common_enabled end,
								set = function(info, value) E.db.KlixUI.toasts.loot_common_enabled = value; end,
							},
							dnd = {
								order = 2,
								type = "toggle",
								name = L["DND"],
								disabled = function() return not E.db.KlixUI.toasts.loot_common_enabled end,
								get = function(info) return E.db.KlixUI.toasts.dnd.loot_common end,
								set = function(info, value) E.db.KlixUI.toasts.dnd.loot_common = value; end,
							},
							threshold = {
								order = 3,
								type = "select",
								name = L["Loot Threshold"],
								values = {
									[1] = ITEM_QUALITY_COLORS[1].hex .. ITEM_QUALITY1_DESC .. "|r",
									[2] = ITEM_QUALITY_COLORS[2].hex .. ITEM_QUALITY2_DESC .. "|r",
									[3] = ITEM_QUALITY_COLORS[3].hex .. ITEM_QUALITY3_DESC .. "|r",
									[4] = ITEM_QUALITY_COLORS[4].hex .. ITEM_QUALITY4_DESC .. "|r",
								},
								disabled = function() return not E.db.KlixUI.toasts.loot_common_enabled end,
								get = function(info) return E.db.KlixUI.toasts.loot_common_quality_threshold end,
								set = function(info, value) E.db.KlixUI.toasts.loot_common_quality_threshold = value; end,
							},
						},
					},
					loot_currency = {
						order = 8,
						type = "group",
						name = L["Loot (Currency)"],
						args = {
							loot_currency_enabled = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								get = function(info) return E.db.KlixUI.toasts.loot_currency_enabled end,
								set = function(info, value) E.db.KlixUI.toasts.loot_currency_enabled = value; end,
							},
							dnd = {
								order = 2,
								type = "toggle",
								name = L["DND"],
								disabled = function() return not E.db.KlixUI.toasts.loot_currency_enabled end,
								get = function(info) return E.db.KlixUI.toasts.dnd.loot_currency end,
								set = function(info, value) E.db.KlixUI.toasts.dnd.loot_currency = value; end,
							},
						},
					},
					--[[loot_gold = {
						order = 9,
						type = "group",
						name = L["Loot (Gold)"],
						args = {
							loot_gold_enabled = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								get = function(info) return E.db.KlixUI.toasts.loot_gold_enabled end,
								set = function(info, value) E.db.KlixUI.toasts.loot_gold_enabled = value; end,
							},
							dnd = {
								order = 2,
								type = "toggle",
								name = L["DND"],
								disabled = function() return not E.db.KlixUI.toasts.loot_gold_enabled end,
								get = function(info) return E.db.KlixUI.toasts.dnd.loot_gold end,
								set = function(info, value) E.db.KlixUI.toasts.dnd.loot_gold = value; end,
							},
							threshold = {
								order = 4,
								type = "input",
								name = L["Copper Threshold"],
								desc = L["Minimum amount of copper to create a toast for."],
								disabled = function() return not E.db.KlixUI.toasts.loot_gold_enabled end,
								get = function()
									return tostring(E.db.KlixUI.toasts.loot_gold_threshold)
								end,
								set = function(info, value)
									value = tonumber(value)
										E.db.KlixUI.toasts.loot_gold_threshold = value >= 1 and value or 1
								end,
							},
						},
					},]]
					loot_special = {
						order = 10,
						type = "group",
						name = L["Loot (Special)"],
						args = {
							loot_special_enabled = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								get = function(info) return E.db.KlixUI.toasts.loot_special_enabled end,
								set = function(info, value) E.db.KlixUI.toasts.loot_special_enabled = value; end,
							},
							dnd = {
								order = 2,
								type = "toggle",
								name = L["DND"],
								disabled = function() return not E.db.KlixUI.toasts.loot_special_enabled end,
								get = function(info) return E.db.KlixUI.toasts.dnd.loot_special end,
								set = function(info, value) E.db.KlixUI.toasts.dnd.loot_special = value; end,
							},
						},
					},
					recipe = {
						order = 11,
						type = "group",
						name = L["Recipe"],
						args = {
							recipe_enabled = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								get = function(info) return E.db.KlixUI.toasts.recipe_enabled end,
								set = function(info, value) E.db.KlixUI.toasts.recipe_enabled = value; end,
							},
							dnd = {
								order = 2,
								type = "toggle",
								name = L["DND"],
								disabled = function() return not E.db.KlixUI.toasts.recipe_enabled end,
								get = function(info) return E.db.KlixUI.toasts.dnd.recipe end,
								set = function(info, value) E.db.KlixUI.toasts.dnd.recipe = value; end,
							},
						},
					},
					transmog = {
						order = 12,
						type = "group",
						name = L["Transmogrification"],
						args = {
							world_enabled = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								get = function(info) return E.db.KlixUI.toasts.transmog_enabled end,
								set = function(info, value) E.db.KlixUI.toasts.transmog_enabled = value; end,
							},
							dnd = {
								order = 2,
								type = "toggle",
								name = L["DND"],
								disabled = function() return not E.db.KlixUI.toasts.transmog_enabled end,
								get = function(info) return E.db.KlixUI.toasts.dnd.transmog end,
								set = function(info, value) E.db.KlixUI.toasts.dnd.transmog = value; end,
							},
						},
					},
					world = {
						order = 13,
						type = "group",
						name = L["World Quest"],
						args = {
							world_enabled = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								get = function(info) return E.db.KlixUI.toasts.world_enabled end,
								set = function(info, value) E.db.KlixUI.toasts.world_enabled = value; end,
							},
							dnd = {
								order = 2,
								type = "toggle",
								name = L["DND"],
								disabled = function() return not E.db.KlixUI.toasts.world_enabled end,
								get = function(info) return E.db.KlixUI.toasts.dnd.world end,
								set = function(info, value) E.db.KlixUI.toasts.dnd.world = value; end,
							},
						},
					},
				},
			},
		},
	}
end
T.table_insert(KUI.Config, ToastTable)