local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KDT = KUI:GetModule("KuiDataTexts")
local DT = E:GetModule("DataTexts")
local DTC = KUI:GetModule("DataTextColors")
local LO = E:GetModule("Layout")

if E.db.KlixUI == nil then E.db.KlixUI = {} end

local function Datatexts()
	E.Options.args.KlixUI.args.modules.args.datatexts = {
		order = 11,
		type = "group",
		name = L["DataTexts"],
		childGroups = "tab",
		args = {
			name = {
				order = 1,
				type = "header",
				name = KUI:cOption(L["DataTexts"]),
			},
			intro = {
				order = 2,
				type = 'description',
				name = L["DT_DESC"],
			},
			space3 = {
				order = 3,
				type = "description",
				name = "",
			},
			general = {
				order = 4,
				type = "group",
				name = L["General"],
				args = {
					leftChatTabDatatextPanel = {
						order = 1,
						type = "toggle",
						name = L["Left ChatTab Panel"],
						desc = L["Show/Hide the left ChatTab DataTexts"],
						get = function(info) return E.db.KlixUI.datatexts.leftChatTabDatatextPanel.enable end,
						set = function(info, value) E.db.KlixUI.datatexts.leftChatTabDatatextPanel.enable = value; KUI:GetModule("KuiLayout"):ToggleLeftChatPanel(); E:StaticPopup_Show("PRIVATE_RL"); end,
					},
					rightChatTabDatatextPanel = {
						order = 1,
						type = "toggle",
						name = L["Right ChatTab Panel"],
						desc = L["Show/Hide the right ChatTab DataTexts"],
						get = function(info) return E.db.KlixUI.datatexts.rightChatTabDatatextPanel.enable end,
						set = function(info, value) E.db.KlixUI.datatexts.rightChatTabDatatextPanel.enable = value; KUI:GetModule("KuiLayout"):ToggleRightChatPanel(); E:StaticPopup_Show("PRIVATE_RL"); end,
					},
				},
			},
			panels = {
				order = 5,
				type = "group",
				name = L["Panels"],
				childGroups = "tab",
				args = {
					chat = {
						order = 1,
						type = "group",
						name = L["Chat Datatext Panel"],
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = ENABLE,
								desc = L["Show/Hide Chat DataTexts. ElvUI chat datatexts must be disabled"],
								get = function(info) return E.db.KlixUI.datatexts.chat[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.datatexts.chat[ info[#info] ] = value; LO:ToggleChatPanels(); E:GetModule("Chat"):UpdateAnchors(); end,
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
							transparent = {
								order = 4,
								type = 'toggle',
								name = L['Panel Transparency'],
								disabled = function() return not E.db.KlixUI.datatexts.chat.enable end,
								get = function(info) return E.db.KlixUI.datatexts.chat[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.datatexts.chat[ info[#info] ] = value; KUI:GetModule('KuiLayout'):ToggleTransparency(); end,
							},
							backdrop = {
								order = 5,
								type = 'toggle',
								name = L['Backdrop'],
								disabled = function() return not E.db.KlixUI.datatexts.chat.enable end,
								get = function(info) return E.db.KlixUI.datatexts.chat[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.datatexts.chat[ info[#info] ] = value; KUI:GetModule('KuiLayout'):ToggleTransparency(); end,
							},
							style = {
								order = 6,
								type = 'toggle',
								name = L["|cfff960d9KlixUI|r Style"],
								disabled = function() return not E.db.KlixUI.datatexts.chat.enable end,
								get = function(info) return E.db.KlixUI.datatexts.chat[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.datatexts.chat[ info[#info] ] = value; KUI:GetModule('KuiLayout'):Styles(); E:StaticPopup_Show('PRIVATE_RL'); end,
							},
							editBoxPosition = {
								order = 7,
								type = 'select',
								name = L['Chat EditBox Position'],
								desc = L['Position of the Chat EditBox, if datatexts are disabled this will be forced to be above chat.'],
								values = {
									['BELOW_CHAT'] = L['Below Chat'],
									['ABOVE_CHAT'] = L['Above Chat'],
								},
								disabled = function() return not E.db.KlixUI.datatexts.chat.enable end,
								get = function(info) return E.db.KlixUI.datatexts.chat[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.datatexts.chat[ info[#info] ] = value; E:GetModule('Chat'):UpdateAnchors() end,
							},
							strata = {
								order = 8,
								type = "select",
								name = L["Frame Strata"],
								get = function(info) return E.db.KlixUI.datatexts.chat[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.datatexts.chat[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
								values = {
									["BACKGROUND"] = "BACKGROUND",
									["LOW"] = "LOW",
									["MEDIUM"] = "MEDIUM",
									["HIGH"] = "HIGH",
									["DIALOG"] = "DIALOG",
									["TOOLTIP"] = "TOOLTIP",
								},
							},
							gameMenuDropdown = {
								order = 9,
								type = 'group',
								name = L['Game Menu Dropdown Color'],
								guiInline = true,
								args = {
									color = {
										order = 1,
										type = "select",
										name = "",
										values = {
											[1] = CLASS_COLORS,
											[2] = CUSTOM,
											[3] = L["Value Color"],
										},
										get = function(info) return E.db.KlixUI.gamemenu[ info[#info] ] end,
										set = function(info, value) E.db.KlixUI.gamemenu[ info[#info] ] = value; end,
									},
									customColor = {
										order = 2,
										type = "color",
										name = COLOR_PICKER,
										disabled = function() return E.db.KlixUI.gamemenu.color == 1 or E.db.KlixUI.gamemenu.color == 3 end,
										get = function(info)
											local t = E.db.KlixUI.gamemenu[ info[#info] ]
											local d = P.KlixUI.gamemenu[info[#info]]
											return t.r, t.g, t.b, t.a, d.r, d.g, d.b
											end,
										set = function(info, r, g, b)
											E.db.KlixUI.gamemenu[ info[#info] ] = {}
											local t = E.db.KlixUI.gamemenu[ info[#info] ]
											t.r, t.g, t.b, t.a = r, g, b, a
										end,
									},
								},
							},
						},
					},
					middle = {
						order = 2,
						type = 'group',
						name = L["Middle Datatext Panel"],
						args = {
							enable = {
								order = 1,
								type = 'toggle',
								name = ENABLE,
								desc = L['Show/Hide the Middle DataText Panel.'],
								get = function(info) return E.db.KlixUI.datatexts.middle[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.datatexts.middle[ info[#info] ] = value; KUI:GetModule('KuiLayout'):MiddleDatatextLayout(); end,
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
							transparent = {
								order = 4,
								type = 'toggle',
								name = L['Panel Transparency'],
								disabled = function() return not E.db.KlixUI.datatexts.middle.enable end,
								get = function(info) return E.db.KlixUI.datatexts.middle[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.datatexts.middle[ info[#info] ] = value; KUI:GetModule('KuiLayout'):MiddleDatatextLayout(); end,
							},
							backdrop = {
								order = 5,
								type = 'toggle',
								name = L['Backdrop'],
								disabled = function() return not E.db.KlixUI.datatexts.middle.enable end,
								get = function(info) return E.db.KlixUI.datatexts.middle[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.datatexts.middle[ info[#info] ] = value; KUI:GetModule('KuiLayout'):MiddleDatatextLayout(); end,
							},
							style = {
								order = 6,
								type = 'toggle',
								name = L["|cfff960d9KlixUI|r Style"],
								disabled = function() return not E.db.KlixUI.datatexts.middle.enable end,
								get = function(info) return E.db.KlixUI.datatexts.middle[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.datatexts.middle[ info[#info] ] = value; KUI:GetModule('KuiLayout'):Styles(); E:StaticPopup_Show('PRIVATE_RL'); end,
							},
							width = {
								order = 7,
								type = "range",
								name = L["Width"],
								min = 200, max = 1400, step = 1,
								disabled = function() return not E.db.KlixUI.datatexts.middle.enable end,
								get = function(info) return E.db.KlixUI.datatexts.middle[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.datatexts.middle[ info[#info] ] = value; KUI:GetModule('KuiLayout'):MiddleDatatextDimensions(); end,
							},
							height = {
								order = 8,
								type = "range",
								name = L["Height"],
								min = 10, max = 32, step = 1,
								disabled = function() return not E.db.KlixUI.datatexts.middle.enable end,
								get = function(info) return E.db.KlixUI.datatexts.middle[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.datatexts.middle[ info[#info] ] = value; KUI:GetModule('KuiLayout'):MiddleDatatextDimensions(); end,
							},
							strata = {
								order = 9,
								type = "select",
								name = L["Frame Strata"],
								get = function(info) return E.db.KlixUI.datatexts.middle[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.datatexts.middle[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
								values = {
									["BACKGROUND"] = "BACKGROUND",
									["LOW"] = "LOW",
									["MEDIUM"] = "MEDIUM",
									["HIGH"] = "HIGH",
									["DIALOG"] = "DIALOG",
									["TOOLTIP"] = "TOOLTIP",
								},
							},
						},
					},
				},
			},
			colors = {
				order = 7,
				type = 'group',
				name = L["Text Color"],
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
							get = function(info) return E.db.KlixUI.datatexts.colors[ info[#info] ] end,
							set = function(info, value) E.db.KlixUI.datatexts.colors[ info[#info] ] = value; DTC:ColorFont(); end,
						},
						userColor = {
							order = 2,
							type = "color",
							name = COLOR_PICKER,
							disabled = function() return E.db.KlixUI.datatexts.colors.customColor == 1 or E.db.KlixUI.datatexts.colors.customColor == 3 end,
						get = function(info)
							local t = E.db.KlixUI.datatexts.colors[ info[#info] ]
							return t.r, t.g, t.b, t.a
							end,
						set = function(info, r, g, b)
							local t = E.db.KlixUI.datatexts.colors[ info[#info] ]
							t.r, t.g, t.b = r, g, b
							DTC:ColorFont();
						end,
					},
				},
			},
			DataTexts = {
				order = 10,
				type = "group",
				name = L["Other DataTexts"],
				args = {
					KUITimeDT = {
						order = 1,
						type = "group",
						name = L["Time Datatext"],
						guiInline = true,
						get = function(info) return E.db.KlixUI.timeDT[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.timeDT[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
						args = {
							size = {
								order = 1,
								type = "range",
								name = L["Clock Size"],
								desc = L["Change the size of the time datatext individually from other datatexts."],
								min = 0.1, max = 3, step = 0.1,
							},
							played = {
								order = 2,
								type = "toggle",
								name = L["Time Played"],
								desc = L["Display session, level and total time played in the time datatext tooltip."],
							},
						},
					},
				},
			},
			--panels = {
				--order = 10,
				--type = "group",
				--name = KUI:cOption(L["DataTexts"]),
				--guiInline = true,
				--args = {},
			--},
			gotodatatexts = {
				order = 11,
				type = "execute",
				name = L["ElvUI DataTexts"],
				func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "datatexts") end,
			},
		},
	}
	
	--local datatexts = {}
	--for name, _ in T.pairs(DT.RegisteredDataTexts) do
		--datatexts[name] = name
	--end
	--datatexts[""] = NONE

	--local table = E.Options.args.KlixUI.args.datatexts.args.panels.args
	--local i = 0
	--for pointLoc, tab in T.pairs(P.KlixUI.datatexts.panels) do
		--i = i + 1
		--if not _G[pointLoc] then table[pointLoc] = nil; return; end
		--if type(tab) == "table" then
			--table[pointLoc] = {
				--type = "group",
				--args = {},
				--name = L[pointLoc] or pointLoc,
				--guiInline = true,
				--order = i,
			--}
			--for option, value in T.pairs(tab) do
				--table[pointLoc].args[option] = {
					--type = "select",
					--name = L[option] or option:upper(),
					--values = datatexts,
					--get = function(info) return E.db.KlixUI.datatexts.panels[pointLoc][ info[#info] ] end,
					--set = function(info, value) E.db.KlixUI.datatexts.panels[pointLoc][ info[#info] ] = value; DT:LoadDataTexts() end,
				--}
			--end
		--elseif type(tab) == "string" then
			--table[pointLoc] = {
				--type = "select",
				--name = L[pointLoc] or pointLoc,
				--values = datatexts,
				--get = function(info) return E.db.KlixUI.datatexts.panels[pointLoc] end,
				--set = function(info, value) E.db.KlixUI.datatexts.panels[pointLoc] = value; DT:LoadDataTexts() end,
				--T.print(pointLoc)
			--}
		--end
	--end
end
T.table_insert(KUI.Config, Datatexts)

local function CurrencyDT()
	local function OrderedPairs(t, f)
		local function orderednext(t, n)
			local key = t[t.__next]
			if not key then return end
			t.__next = t.__next + 1
			return key, t.__source[key]
		end

		local keys, kn = {__source = t, __next = 1}, 1
		for k in T.pairs(t) do
			keys[kn], kn = k, kn + 1
		end
		T.table_sort(keys, f)
		return orderednext, keys
	end


	local function CreateCurrencyConfig(i, text, name)
		local config = {
			order = i, type = "toggle", name = text,
			get = function(info) return E.db.KlixUI.currencyDT[name] end,
			set = function(info, value) E.db.KlixUI.currencyDT[name] = value; end,
		}
		return config
	end
	
	local function CreateCustomToonList()
		local config = {
			name = CUSTOM,
			order = 3,
			type = "group",
			guiInline = true,
			hidden = function() return E.db.KlixUI.currencyDT.gold.method ~= "order" end,
			args = {
				info = {
					order = 1,
					type = "description",
					name = L["Order of each toon. Smaller numbers will go first"],
				},
			},
		}
		if not ElvDB["gold"][E.myrealm] then
			ElvDB = ElvDB or { };
			ElvDB['gold'] = ElvDB['gold'] or {};
			ElvDB['gold'][E.myrealm] = ElvDB['gold'][E.myrealm] or {};
			ElvDB['gold'][E.myrealm][E.myname] = ElvDB['gold'][E.myrealm][E.myname] or T.GetMoney();
		end
		for k,_ in T.pairs(ElvDB["gold"][E.myrealm]) do
			config.args[k] = {
				type = "select",
				name = k,
				order = 10,
				width = "half",
				get = function(info) return (E.private.KlixUI.characterGoldsSorting[E.myrealm][k] or 1) end,
				set = function(info, value) E.private.KlixUI.characterGoldsSorting[E.myrealm][k] = value end,
				values = {
					[1] = "1",
					[2] = "2",
					[3] = "3",
					[4] = "4",
					[5] = "5",
					[6] = "6",
					[7] = "7",
					[8] = "8",
					[9] = "9",
					[10] = "10",
					[11] = "11",
					[12] = "12",
				},
			}
		end
		return config
	end

	E.Options.args.KlixUI.args.modules.args.datatexts.args.currencyDT = {
		type = "group",
		name = L["Currency"],
		order = 8,
		args = {
			--jewel = CreateCurrencyConfig(1, L["Show Jewelcrafting Tokens"], 'Jewelcrafting'),
			pvp = CreateCurrencyConfig(2, L["Show Player vs Player Currency"], 'PvP'),
			dungeon = CreateCurrencyConfig(3, L["Show Dungeon and Raid Currency"], 'Raid'),
			--cook = CreateCurrencyConfig(4, L["Show Cooking Awards"], 'Cooking'),
			misc = CreateCurrencyConfig(5, L["Show Miscellaneous Currency"], 'Miscellaneous'),
			bfa = CreateCurrencyConfig(6, L["Show Battle for Azeroth Currency"], 'BFA'),
			legion = CreateCurrencyConfig(7, L["Show Legion Currency"], 'LEGION'),
			wod = CreateCurrencyConfig(8, L["Show Warlords of Draenor Currency"], 'WOD'),
			mop = CreateCurrencyConfig(9, L["Show Mists of Pandaria Currency"], 'MOP'),
			cata = CreateCurrencyConfig(10, L["Show Cataclysm Currency"], 'CATA'),
			wolk = CreateCurrencyConfig(11, L["Show Wrath of the Lich King Currency"], 'WOLK'),
			token = CreateCurrencyConfig(12, L["Show WoW Token Price"], 'WoWToken'),
			arch = CreateCurrencyConfig(13, L["Show Archaeology Fragments"], 'Archaeology'),
			zero = CreateCurrencyConfig(14, L["Show Zero Currency"], 'Zero'),
			icons = CreateCurrencyConfig(15, L["Show Icons"], 'Icons'),
			faction = CreateCurrencyConfig(16, L["Show Faction Totals"], 'Faction'),
			unused = CreateCurrencyConfig(17, L["Show Unused Currencies"], 'Unused'),
			delete = {
				order = 20,
				type = "select",
				name = L["Delete character info"],
				desc = L["Remove selected character from the stored gold values"],
				values = function()
					local names = {};
					for rk,_ in OrderedPairs(ElvDB['gold']) do
						for k,_ in OrderedPairs(ElvDB['gold'][rk]) do
							if ElvDB['gold'][rk][k] then
								local name = T.string_format("%s-%s", k, rk);
								names[name] = name;
							end
						end
					end
					return names;
				end,
				set = function(info, value) 
					local name, realm, realm2 = T.string_split("-", value);
					if realm2 then realm = realm.."-"..realm2 end
					E.PopupDialogs['KUI_CONFIRM_DELETE_CURRENCY_CHARACTER'].text = T.string_format(L["Are you sure you want to remove |cff1784d1%s|r from currency datatexts?"], name..(realm and "-"..realm or ""))
					E:StaticPopup_Show('KUI_CONFIRM_DELETE_CURRENCY_CHARACTER', nil, nil, { ["name"] = name, ["realm"] = realm });
				end,
			},
			sortGold = {
				order = 30,
				name = L["Gold Sorting"],
				type = "group",
				guiInline = true,
				get = function(info) return E.db.KlixUI.currencyDT.gold[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.currencyDT.gold[ info[#info] ] = value; end,
				args = {
					direction = {
						order = 1,
						type = "select",
						name = L["Sort Direction"],
						width = "half",
						values = {
							["normal"] = L["Normal"],
							["reversed"] = L["Reversed"],
						},
					},
					method = {
						order = 2,
						type = "select",
						name = L["Sort Method"],
						width = "half",
						values = {
							["name"] = NAME,
							["amount"] = L["Amount"],
							["order"] = CUSTOM,
						},
					},
					customSort = CreateCustomToonList(),
				},
			},
			sortCurrency = {
				order = 31,
				name = L["Currency Sorting"],
				type = "group",
				guiInline = true,
				get = function(info) return E.db.KlixUI.currencyDT.cur[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.currencyDT.cur[ info[#info] ] = value; end,
				args = {
					direction = {
						order = 1,
						type = "select",
						name = L["Direction"],
						width = "half",
						values = {
							["normal"] = L["Normal"],
							["reversed"] = L["Reversed"],
						},
					},
					method = {
						order = 2,
						type = "select",
						name = L["Sort Method"],
						width = "half",
						values = {
							["name"] = NAME,
							["amount"] = L["Amount"],
							["r1"] = L["Tracked"],
						},
					},
				},
			},
		},
	}
end
T.table_insert(KUI.Config, CurrencyDT)

local function injectElvUIDataTextsOptions()
	E.Options.args.datatexts.args.general.args.spacer1 = {
		order = 21,
		type = 'description',
		name = '',
	}

	E.Options.args.datatexts.args.general.args.spacer2 = {
		order = 22,
		type = 'header',
		name = '',
	}
	
	E.Options.args.datatexts.args.general.args.gotoklixui = {
		order = 23,
		type = "execute",
		name = KUI:cOption(L["KlixUI DataTexts"]),
		func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "KlixUI", "modules", "datatexts") end,
	}
end
T.table_insert(KUI.Config, injectElvUIDataTextsOptions)