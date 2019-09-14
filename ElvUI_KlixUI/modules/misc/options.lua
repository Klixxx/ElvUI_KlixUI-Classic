local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local MI = KUI:GetModule("KuiMisc")
local KZ = KUI:GetModule("KuiZoom")
local KAN = KUI:GetModule("KuiAnnounce")
local PvP = KUI:GetModule("KuiPVP")
local CSP = KUI:GetModule("ConfirmStaticPopups")

local match = string.match
local CUSTOM, PVP, DUEL, PET_BATTLE_PVP_DUEL, KILLING_BLOWS = CUSTOM, PVP, DUEL, PET_BATTLE_PVP_DUEL, KILLING_BLOWS

local base = 15
local maxfactor = 4

local function PopupOptions()
	local args, index = {}, 1
	for key, val in CSP:orderedPairs(E.db.KlixUI.misc.popups) do -- put options sorted order by pop-up constant name
		args[key] = {
			order = index,
			type = "toggle",
			width = 1.5, 
			name = key,
			desc = _G[key],
			get = function(info) return E.db.KlixUI.misc.popups[ info[#info] ] end,
			set = function(info, value) E.db.KlixUI.misc.popups[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		}
		index = index + 1
	end
	return args
end

local function Misc()
	E.Options.args.KlixUI.args.modules.args.misc = {
		order = 19,
		type = "group",
		name = L['Miscellaneous'],
		childGroups = 'tab',
		get = function(info) return E.db.KlixUI.misc[ info[#info] ] end,
		set = function(info, value) E.db.KlixUI.misc[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			header = {
				order = 1,
				type = "header",
				name = KUI:cOption(L["Miscellaneous"]),
			},
			general = {
				order = 2,
				type = "group",
				name = L["General"],
				args = {
					combatState = {
						order = 1,
						type = "toggle",
						name = L["Announce Combat Status"],
						desc = L["Announce combat status in a textfield in the middle of the screen.\nCredit: |cffff7d0aMerathilisUI|r"],
					},
					skillGains = {
						order = 2,
						type = "toggle",
						name = L["Announce Skill Gains"],
						desc = L["Announce skill gains in a textfield in the middle of the screen.\nCredit: |cffff7d0aMerathilisUI|r"],
					},
					gmotd = {
						order = 3,
						type = "toggle",
						name = GUILD_MOTD_LABEL2,
						desc = L["Display the Guild Message of the Day in an extra window, if updated.\nCredit: |cffff7d0aMerathilisUI|r"],
					},
					Movertransparancy = {
						order = 4,
						type = "range",
						name = L["Mover Transparency"],
						desc = L["Changes the transparency of all the movers."],
						isPercent = true,
						min = 0, max = 1, step = 0.01,
						get = function(info) return E.db.KlixUI.general.Movertransparancy end,
						set = function(info, value) E.db.KlixUI.general.Movertransparancy = value MI:UpdateMoverTransparancy() end,
					},
					buyall = {
						order = 5,
						type = "toggle",
						name = L["Buy Max Stack"],
						desc = L["Alt-Click on an item, sold buy a merchant, to buy a full stack."],
					},
					space = {
						order = 25,
						type = "description",
						name = "",
					},
					cursorFlash = {
						order = 26,
						type = "group",
						name = L["Cursor Flash"],
						guiInline = true,
						get = function(info) return E.db.KlixUI.misc.cursorFlash[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.misc.cursorFlash[ info[#info] ] = value; end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								desc = L["Shows a flashing star as the cursor trail."],
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
							alpha = {
								order = 4,
								type = "range",
								name = L["Alpha"],
								desc = L["Change the alpha level of the cursor trail."],
								min = 0, max = 1, step = 0.01,
								disabled = function() return not E.db.KlixUI.misc.cursorFlash.enable end,
							},
							color = {
								order = 5,
								type = "color",
								name = L["Color"],
								hasAlpha = false,
								disabled = function() return not E.db.KlixUI.misc.cursorFlash.enable end,
								get = function(info)
									local t = E.db.KlixUI.misc.cursorFlash.color
									return t.r, t.g, t.b
								end,
								set = function(info, r, g, b)
									E.db.KlixUI.misc.cursorFlash.color = {}
									local t = E.db.KlixUI.misc.cursorFlash.color
									t.r, t.g, t.b = r, g, b
								end,
							},
							visibility = {
								order = 6,
								type = "select",
								name = L["Visibility"],
								desc = L["Change how/when the cursor trail is shown."],
								values = {
									["MODIFIER"] = L["Modifier"],
									["COMBAT"] = L["Combat"],
									["ALWAYS"] = L["Always"],
								},
								disabled = function() return not E.db.KlixUI.misc.cursorFlash.enable end,
							},
						},
					},
					alreadyknown = {
						order = 27,
						type = "group",
						name = L["Already Known"],
						guiInline = true,
						get = function(info) return E.db.KlixUI.misc.alreadyknown[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.misc.alreadyknown[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								desc = L["Display a color overlay of already known/learned items."],
							},
							color = {
								order = 2,
								type = "color",
								name = L["Overlay Color"],
								hasAlpha = false,
								disabled = function() return not E.db.KlixUI.misc.alreadyknown.enable end,
								get = function(info)
									local t = E.db.KlixUI.misc.alreadyknown.color
									return t.r, t.g, t.b
								end,
								set = function(info, r, g, b)
									E.db.KlixUI.misc.alreadyknown.color = {}
									local t = E.db.KlixUI.misc.alreadyknown.color
									t.r, t.g, t.b = r, g, b
								end,
							},
						},
					},
				},
			},
			merchant = {
				order = 3,
				type = "group",
				name = L["Merchant"],
				get = function(info) return E.db.KlixUI.misc.merchant[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.misc.merchant[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					itemlevel = {
						order = 3,
						type = "toggle",
						name = L["ItemLevel"],
						desc = L["Display the item level on the MerchantFrame."],
					},
					equipslot = {
						order = 4,
						type = "toggle",
						name = L["EquipSlot"],
						desc = L["Display the equip slot on the MerchantFrame."],
					},
				},
			},
			--[[bloodlust = {
				order = 4,
				type = "group",
				name = L["Bloodlust"],
				get = function(info) return E.db.KlixUI.misc.bloodlust[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.misc.bloodlust[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
					},
					spacer1 = {
						order = 2,
						type = "description",
						name = "",
					},
					spacer2 = {
						order = 3,
						type = "description",
						name = "",
					},
					sound = {
						order = 4,
						type = "toggle",
						name = L["Sound"],
						desc =  L["Play a sound when bloodlust/heroism is popped."],
						disabled = function() return not E.db.KlixUI.misc.bloodlust.enable end,
					},
					text = {
						order = 5,
						type = "toggle",
						name = L["Text"],
						desc =  L["Print a chat message of whom who popped bloodlust/heroism."],
						disabled = function() return not E.db.KlixUI.misc.bloodlust.enable end,
					},
					faction = {
						type = 'select',
						order = 6,
						name = L["Sound Type"],
						disabled = function() return not E.db.KlixUI.misc.bloodlust.enable or not E.db.KlixUI.misc.bloodlust.sound end,
						values = {
							["HORDE"] = L["Horde"],
							["ALLIANCE"] = L["Alliance"],
							["ILLIDAN"] = L["Illidan"],
							["CUSTOM"] = CUSTOM,
						},
					},
					SoundOverride = {
						order = 7,
						type = "toggle",
						name = L["Sound Override"],
						desc =  L["Force to play even when other sounds are disabled."],
						disabled = function() return not E.db.KlixUI.misc.bloodlust.enable or not E.db.KlixUI.misc.bloodlust.sound end,
					},
					UseCustomVolume = {
						order = 8,
						type = "toggle",
						name = L["Use Custom Volume"],
						desc =  L["Use custom volume.\n|cffff8000Note: This will only work if 'Sound Override' is enabled.|r"],
						disabled = function() return not E.db.KlixUI.misc.bloodlust.enable or not E.db.KlixUI.misc.bloodlust.sound or not E.db.KlixUI.misc.bloodlust.SoundOverride end,
					},
					CustomVolume = {
						order = 9,
						type = "range",
						name = L["Volume"],
						min = 1, max = 100, step = 1,
						disabled = function() return not E.db.KlixUI.misc.bloodlust.enable or not E.db.KlixUI.misc.bloodlust.sound or not E.db.KlixUI.misc.bloodlust.SoundOverride or not E.db.KlixUI.misc.bloodlust.UseCustomVolume end,
					},
					customSound = {
						type = 'input',
						order = 40,
						customWidth = 300,
						name = L["Custom Sound Path"],
						desc = L["Example of a path string: path\\path\\path\\sound.mp3"],
						hidden = function() return E.db.KlixUI.misc.bloodlust.faction ~= "CUSTOM" end,
						disabled = function() return not E.db.KlixUI.misc.bloodlust.enable or not E.db.KlixUI.misc.bloodlust.sound or E.db.KlixUI.misc.bloodlust.faction ~= "CUSTOM" end,
						set = function(_, value) E.db.KlixUI.misc.bloodlust.customSound = (value and (not value:match("^%s-$")) and value) or nil end,
					},
				},
			},]]
			auto = {
				order = 6,
				type = "group",
				name = L["Automatization"],
				get = function(info) return E.db.KlixUI.misc.auto[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.misc.auto[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					auction = {
						order = 1,
						type = "toggle",
						name = L["Auto Auction"],
						desc = L["Shift + Right-Click to auto buy auctions at the auctionhouse."],
					},
					gossip = {
						order = 2,
						type = "toggle",
						name = L["Auto Gossip"],
						desc = L["This setting will auto gossip some NPC's.\n|cffff8000Note: Holding down any modifier key before visiting/talking to the respective NPC's will briefly disable the automatization.|r"],
					},
					space1 = {
						order = 9,
						type = "description",
						name = "",
					},
					invite = {
						order = 11,
						type = "group",
						name = L["Invite"],
						guiInline = true,
						get = function(info) return E.db.KlixUI.misc.auto.invite[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.misc.auto.invite[ info[#info] ] = value end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								set = function(info, value) E.db.KlixUI.misc.auto.invite.enable = value E:StaticPopup_Show("PRIVATE_RL") end,
							},
							ainvkeyword = {
								order = 2,
								type = "input",
								name = L["Auto Invite Keyword"],
								disabled = function(info) return not E.db.KlixUI.misc.auto.invite.enable end,
							},
							space1 = {
								order = 3,
								type = "description",
								name = "",
							},
							inviteRank = {
								order = 4,
								type = "multiselect",
								name = L["Invite Rank"],
								values = MI:GetGuildRanks(),
								disabled = function(info) return not T.IsInGuild() or not E.db.KlixUI.misc.auto.invite.enable end,
								get = function(info, k) return E.db.KlixUI.misc.auto.invite.inviteRank[k] end,
								set = function(info, k, v) E.db.KlixUI.misc.auto.invite.inviteRank[k] = v end,
							},
							refreshRank = {
								order = 5,
								type = "execute",
								name = L["Refresh Rank"],
								buttonElvUI = true,
								disabled = function(info) return not T.IsInGuild() or not E.db.KlixUI.misc.auto.invite.enable
								end,
								func = function() E.Options.args.KlixUI.args.modules.args.misc.args.auto.args.invite.args.inviteRank.values = MI:GetGuildRanks() end,
							},
							startInvite = {
								order = 6,
								type = "execute",
								name = L["Start Invite"],
								buttonElvUI = true,
								disabled = function(info) return not T.IsInGuild() or not E.db.KlixUI.misc.auto.invite.enable end,
								func = function()
									for k, v in T.pairs(E.db.KlixUI.misc.auto.invite.inviteRank) do
										if v then
											T.SendChatMessage(T.string_format(L["KUI_INVITEGROUP_MSG"], T.GuildControlGetRankName(k)), "GUILD")
										end
									end
									E:ScheduleTimer(MI.InviteRanks, 10)
								end,
							},
						},
					},
				},
			},
			panels = {
				order = 7,
				type = "group",
				name = L["Panels"],
				args = {
					top = {
						order = 1,
						type = 'group',
						guiInline = true,
						name = L['Top Panel'],
						get = function(info) return E.db.KlixUI.misc.panels.top[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.misc.panels.top[ info[#info] ] = value; KUI:GetModule('KuiLayout'):TopPanelLayout() end,
						args = {
							show = {
								order = 1,
								type = 'toggle',
								name = SHOW,
								desc = L["Display a panel across the top of the screen. This is for cosmetic only."],
								get = function(info) return E.db.general.topPanel end,
								set = function(info, value) E.db.general.topPanel = value; E:GetModule('Layout'):TopPanelVisibility() end
							},
							spacer1 = {
								order = 2,
								type = "description",
								name = "",
							},
							spacer2 = {
								order = 3,
								type = "description",
								name = "",
							},
							style = {
								order = 4,
								type = 'toggle',
								name = L["|cfff960d9KlixUI|r Style"],
								disabled = function() return not E.db.KlixUI.general.style end,
							},
							transparency = {
								order = 5,
								type = 'toggle',
								name = L['Panel Transparency'],
							},
							height = {
								order = 6,
								type = "range",
								name = L["Height"],
								min = 8, max = 60, step = 1,
							},
						},
					},
					bottom = {
						order = 2,
						type = 'group',
						guiInline = true,
						name = L['Bottom Panel'],
						get = function(info) return E.db.KlixUI.misc.panels.bottom[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.misc.panels.bottom[ info[#info] ] = value; KUI:GetModule('KuiLayout'):BottomPanelLayout() end,
						args = {
							show = {
								order = 1,
								type = 'toggle',
								name = SHOW,
								desc = L["Display a panel across the bottom of the screen. This is for cosmetic only."],
								get = function(info) return E.db.general.bottomPanel end,
								set = function(info, value) E.db.general.bottomPanel = value; E:GetModule('Layout'):BottomPanelVisibility() end
							},
							spacer1 = {
								order = 2,
								type = "description",
								name = "",
							},
							spacer2 = {
								order = 3,
								type = "description",
								name = "",
							},
							style = {
								order = 4,
								type = 'toggle',
								name = L["|cfff960d9KlixUI|r Style"],
								disabled = function() return not E.db.KlixUI.general.style end,
							},
							transparency = {
								order = 5,
								type = 'toggle',
								name = L['Panel Transparency'],
							},
							height = {
								order = 6,
								type = "range",
								name = L["Height"],
								min = 8, max = 60, step = 1,
							},
						},
					},
					gotogeneral = {
						order = 3,
						type = "execute",
						name = L["ElvUI Panels"],
						func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "general") end,
					},
				},
			},
			zoom = {
				order = 9,
				type = "group",
				name = L["Character Zoom"],
				get = function(info) return E.db.KlixUI.misc.zoom[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.misc.zoom[ info[#info] ] = value end,
				args = {
					increment = {
						order = 1,
						type = "range",
						desc = L["Adjust the increment the camera will follow behind you."],
						name = L["Zoom Increment"],
						get = function(info) return E.db.KlixUI.misc.zoom.increment end,
						set = function(info, value) E.db.KlixUI.misc.zoom.increment = value end,
						min = 1, max = 10, softMax = 5, step = .5,
					},
					speed = {
						order = 2,
						type = "range",
						desc = L["Adjust the zoom speed the camera will follow behind you."],
						name = L["Zoom Speed"],
						get = function(info) return T.tonumber(T.GetCVar("cameraZoomSpeed")) end,
						set = function(info, value)  E.db.KlixUI.misc.zoom.speed = value; T.SetCVar("cameraZoomSpeed", value) end,
						min = 1, max = 50, step = 1,
					},
					distance = {
						order = 3,
						type = "range",
						desc = OPTION_TOOLTIP_MAX_FOLLOW_DIST,
						name = MAX_FOLLOW_DIST,
						disabled = function() return E.db.KlixUI.misc.zoom.maxZoom end,
						get = function(info) return T.GetCVar("cameraDistanceMaxZoomFactor") * base end,
						set = function(info, value) E.db.KlixUI.misc.zoom.distance = value / base; T.SetCVar("cameraDistanceMaxZoomFactor", value / base) end,
						min = base, max = base * maxfactor, step = 1.5, -- cvar gets rounded to 1 decimal
					},
					maxZoom = {
						order = 4,
						type = "toggle",
						name = L["Force Max Zoom"]..E.NewSign,
						desc = L["This will force max zoom every time you enter the world"],
						set = function(info, value) E.db.KlixUI.misc.zoom[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
				},
			},
			popups = {
				order = 11,
				type = "group",
				name = L["Confirm Static Popups"],
				get = function(info) return E.db.KlixUI.misc.popups[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.misc.popups[ info[#info] ] = value; end,
				args = {
					info = {
						order = 1,
						type = "description",
						name = L["CSP_DESC"],
					},
					enable = {
						order = 2,
						type = "toggle",
						name = L["Enable"],
						desc = L["Automatically accept various static popups encountered in-game."],
						get = function(info) return E.db.KlixUI.misc.popupsEnable end,
						set = function(info, value) E.db.KlixUI.misc.popupsEnable = value; end
					},	
					toggle = {
						order = 3,
						type = "group",
						name = L["Auto Answer"],
						guiInline = true,
						disabled = function() return not E.db.KlixUI.misc.popupsEnable end,
						args = PopupOptions(),
					},
				},
			},
			pvp = {
				type = "group",
				name = L["PvP"],
				order = 40,
				args = {
					killStreaks = {
						order = 1,
						type = "toggle",
						name = L["KillStreak Sounds"]..E.NewSign,
						desc = L["Unreal Tournament sound effects for killing blow streaks."],
						get = function(info) return E.db.KlixUI.pvp.killStreaks end,
						set = function(info, value) E.db.KlixUI.pvp.killStreaks = value; E:StaticPopup_Show("PRIVATE_RL") end
					},
					autorelease = {
						type = "group",
						name = PVP,
						order = 2,
						guiInline = true,
						disabled = function() return T.IsAddOnLoaded("ElvUI_SLE") end,
						hidden = function() return T.IsAddOnLoaded("ElvUI_SLE") end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								desc = L["Automatically release body when killed inside a battleground."],
								get = function(info) return E.db.KlixUI.pvp.autorelease end,
								set = function(info, value) E.db.KlixUI.pvp.autorelease = value; end
							},
							rebirth = {
								order = 2,
								type = "toggle",
								name = L["Check for rebirth mechanics"],
								desc = L["Do not release if reincarnation or soulstone is up."],
								disabled = function() return not E.db.KlixUI.pvp.autorelease end,
								get = function(info) return E.db.KlixUI.pvp.rebirth end,
								set = function(info, value) E.db.KlixUI.pvp.rebirth = value; end
							},
						},
					},
					duels = {
						type = "group",
						name = DUEL,
						order = 3,
						guiInline = true,
						disabled = function() return T.IsAddOnLoaded("ElvUI_SLE") end,
						hidden = function() return T.IsAddOnLoaded("ElvUI_SLE") end,
						get = function(info) return E.db.KlixUI.pvp.duels[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.pvp.duels[ info[#info] ] = value end,
						args = {
							regular = {
								order = 1,
								type = "toggle",
								name = PVP,
								desc = L["Automatically cancel PvP duel requests."],
							},
							announce = {
								order = 3,
								type = "toggle",
								name = L["Announce"],
								desc = L["Announce in chat if duel was rejected."],
							},
						},
					},
				},
			},
		},
	}
end
T.table_insert(KUI.Config, Misc)