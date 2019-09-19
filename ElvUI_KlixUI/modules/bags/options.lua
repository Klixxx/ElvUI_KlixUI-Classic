local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KB = KUI:GetModule("KuiBags")
local B = E:GetModule("Bags")

local function BagTable()
	E.Options.args.KlixUI.args.modules.args.bags = {
		order = 5,
		type = 'group',
		name = L["Bags"],
		childGroups = "tab",
		args = {
			name = {
				order = 1,
				type = "header",
				name = KUI:cOption(L["Bags"]),
			},
			general = {
				order = 2,
				type = "group",
				name = L["General"],
				get = function(info) return E.private.KlixUI.bags[ info[#info] ] end,
				set = function(info, value)	E.private.KlixUI.bags[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL') end,
				args = {
					bagFilter = {
						order = 1,
						type = "toggle",
						name = L["Bag Filter"],
						desc = L["Enable/disable the bagfilter button."],
						disabled = function() return not E.private.bags.enable end,
					},
				},
			},
			itemSelect = {
				order = 3,
				type = "group",
				name = L["Item Selection"],
				disabled = function() return not E.private.bags.enable end,
				get = function(info) return E.db.KlixUI.bags.itemSelect[ info[#info] ] end,
				set = function(info, value)	E.db.KlixUI.bags.itemSelect[ info[#info] ] = value; end,
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["The item selection module allows deletion / vendoring of multiple items at once."],
					},
					enable = {
						order = 2,
						type = "toggle",
						name = L["Enable"],
						set = function(info, value) E.db.KlixUI.bags.itemSelect.enable = value; E:StaticPopup_Show('PRIVATE_RL') end
					},
					General = {
						order = 3,
						type = "group",
						name = L["General"],
						disabled = function() return not E.db.KlixUI.bags.itemSelect.enable end,
						args = {
							displayProgressFrame = {
								order = 1,
								type = "toggle",
								name = L["Display Progress Frame"],
							},
							listHandledItems = {
								order = 2,
								type = "toggle",
								name = L["List Processed Items"],
							},
							processInterval = {
								order = 3,
								type = "range",
								name = L["Process Interval"],
								desc = L["The delay between processing items, e.g. between items being deleted."],
								min = 0.1, max = 1, step = 0.1,
							},
						},
					},
					QuestItems = {
						order = 4,
						type = "group",
						name = L["Quest Items"],
						disabled = function() return not E.db.KlixUI.bags.itemSelect.enable end,
						args = {
							processQuestItems = {
								order = 1,
								type = "select",
								name = L["Process Quest Items"],
								desc = L["Toggle whether Quest Items should be deleted/sold. Quest Items with sell value are usually related to repeatable quests."],
								values = {
									[0] = L["Never process"],
									[1] = L["Merchant only"],
									[2] = L["Process if sellable"],
									[3] = L["Always process"],
								},
							},
						},
					},
					BoEItems = {
						order = 5,
						type = "group",
						name = L["BoE Items"],
						disabled = function() return not E.db.KlixUI.bags.itemSelect.enable end,
						args = {
							processBoEItems = {
								order = 1,
								type = "select",
								name = L["Process BoE Items"],
								desc = L["Toggle when you wish BoEs to be handled when processing items."],
								values = {
									[0] = L["Never process"],
									[1] = L["Merchant only"],
									[2] = L["Process if sellable"],
									[3] = L["Always process"],
								},
							},
							thresholdBoE = {
								order = 2,
								type = "select",
								name = L["Threshold for BoEs"],
								desc = L["Set the threshold for which BoE items should be processed."],
								values = {
									[0] = "|cff1eff00Uncommon|r",
									[1] = "|cff0070ddRare|r",
									[2] = "|cffa335eeEpic|r",
									[3] = "|cffff8000Legendary|r"
								},
							},
							processMissingMogBoE = {
								order = 3,
								type = "toggle",
								name = L["Process If Missing Appearance"],
								desc = L["Process items even if we haven't unlocked their appearance."],
							},
						},
					},
					CraftingReagents = {
						order = 6,
						type = "group",
						name = L["Crafting Reagents"],
						disabled = function() return not E.db.KlixUI.bags.itemSelect.enable end,
						args = {
							processCraftingReagents = {
								order = 1,
								type = "toggle",
								name = L["Process Crafting Reagents"],
							},
						},
					},
				},
			},
		},
	}
end
tinsert(KUI.Config, BagTable)