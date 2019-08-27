local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local MI = KUI:GetModule("KuiMisc")
--local COMP = KUI:GetModule("KuiCompatibility")
local KZ = KUI:GetModule("KuiZoom")
--[[local KAN = KUI:GetModule("KuiAnnounce")
local KBL = KUI:GetModule("KuiBloodLust")
local KEC = KUI:GetModule("KuiEasyCurve")
local PvP = KUI:GetModule("KuiPVP")
local THF = KUI:GetModule("TalkingHeadFrame")
local AL = KUI:GetModule("AutoLog")
local CSP = KUI:GetModule("ConfirmStaticPopups")
local SCRAP = KUI:GetModule("Scrapper")]]

local match = string.match
local CUSTOM, PVP, DUEL, PET_BATTLE_PVP_DUEL, KILLING_BLOWS = CUSTOM, PVP, DUEL, PET_BATTLE_PVP_DUEL, KILLING_BLOWS

local base = 15
local maxfactor = 4
--[[
local raid_lfr = {"43DGS", "52MGS", "53TES", "51HOF", "54TOT", "55SOO", "61BRF", "62HGM", "63HFC", "71TEN", "72TNH", "73TOV", "74TOS", "75ABT", "81UDI", "82BDZ", "83COS", "84ETP"}
local raid_normal = {"41BAH", "42BWD", "45BTW", "46TFW", "44FIR", "43DGS", "52MGS", "53TES", "51HOF", "54TOT", "55SOO", "61BRF", "62HGM", "63HFC", "71TEN", "72TNH", "73TOV", "74TOS", "75ABT", "81UDI", "82BDZ", "83COS", "84ETP"}
local raid_heroic = {"42BWD", "45BTW", "46TFW", "44FIR", "43DGS", "52MGS", "53TES", "51HOF", "54TOT", "55SOO", "61BRF", "62HGM", "63HFC", "71TEN", "72TNH", "73TOV", "74TOS", "75ABT", "81UDI", "82BDZ", "83COS", "84ETP"}
local raid_mythic = {"55SOO", "61BRF", "62HGM", "63HFC", "71TEN", "72TNH", "73TOV", "74TOS", "75ABT", "81UDI", "82BDZ", "83COS", "84ETP"}

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
]]
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
			--[[general = {
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
					talkingHead = {
						order = 7,
						type = "toggle",
						name = L["Hide TalkingHeadFrame"],
					},
					whistleLocation = {
						order = 8,
						type = "toggle",
						name = L["Flight Master's Whistle Location"],
						desc = L["Show the nearest Flight Master's Whistle Location on the minimap and in the tooltip."],
						disabled = function() return T.IsAddOnLoaded("WhistledAway") end,
						hidden = function() return T.IsAddOnLoaded("WhistledAway") end,
					},
					whistleSound = {
						order = 9,
						type = "toggle",
						name = L["Flight Master's Whistle Sound"],
						desc = L["Plays a sound when you use the Flight Master's Whistle."],
					},
					toggleSoundCustom = {
						order = 10,
						type = "toggle",
						name = L["Custom Flight Master's Whistle Sound"],
						desc = L["Use a custom sound when you use the Flight Master's Whistle."],
						disabled = function() return not E.db.KlixUI.misc.whistleSound end,
					},
					whistleSoundCustom = {
						type = 'input',
						order = 11,
						width = "double",
						name = L["Custom Sound Path"],
						desc = L["Example of a path string: path\\path\\path\\sound.mp3"],
						hidden = function() return not E.db.KlixUI.misc.toggleSoundCustom end,
						disabled = function() return not E.db.KlixUI.misc.whistleSound or not E.db.KlixUI.misc.toggleSoundCustom end,
						set = function(_, value) E.db.KlixUI.misc.whistleSoundCustom = (value and (not value:match("^%s-$")) and value) or nil end,
					},
					lootSound = {
						order = 12,
						type = "toggle",
						name = L["Loot container opening sound"],
						desc = L["Plays a sound when you open a container, chest etc."],
					},
					transmog = {
						type = "toggle",
						order = 13,
						name = L["Transmog Remover Button"],
						desc = L["Enable/Disable the transmog remover button in the transmogrify window."],
					},
					leaderSound = {
						order = 14,
						type = "toggle",
						name = L["Leader Change Sound"],
						desc = L["Plays a sound when you become the group leader."],
					},
					vehicleSeatMissing = {
						order = 15,
						type = "toggle",
						name = L["Missing Seat Indicators"],
						desc = L["Add a seat indicator, to passenger mounts without an indicator, e.g. The Hivemind, Sandstone Drake, Heart of the Nightwing and Travel Form."],
						get = function(info) return E.db.KlixUI.misc.vehicleSeat.missing end,
						set = function(info, value) E.db.KlixUI.misc.vehicleSeat.missing = value; E:StaticPopup_Show("PRIVATE_RL") end,
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
					AFKPetModel = {
						order = 30,
						type = "group",
						name = L["AFK Pet Model"],
						guiInline = true,
						get = function(info) return E.db.KlixUI.misc.AFKPetModel[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.misc.AFKPetModel[ info[#info] ] = value end,
						args = {
							pet = {
								order = 1,
								type = "input",
								name = L["Companion Pet Name"],
								width = "full",
								set = function(info, value)
									local speciesID = T.C_PetJournal_FindPetIDByName(value)
									if speciesID then
										E.db.KlixUI.misc.AFKPetModel[ info[#info] ] = value
									else
										E.db.KlixUI.misc.AFKPetModel[ info[#info] ] = T.select(8, T.C_PetJournal_GetPetInfoByIndex(1))
									end
									E.db.KlixUI.misc.AFKPetModel.modelScale = 1 --Reset scale when new pet is set
								end,
							},
							modelScale = {
								order = 2,
								type = "range",
								name = L["Model Scale"],
								desc = L["Some pets will appear huge. Lower the scale when that happens."],
								min = 0.05, max = 2, step = 0.05,
							},
							facing = {
								order = 3,
								type = "range",
								name = L["Model Facing Direction"],
								desc = L["Less than 0 faces the model to the left, more than 0 faces the model to the right"],
								min = -180, max = 180, step = 5,
							},
							animation = {
								order = 4,
								type = "range",
								name = L["Animation"],
								desc = L["NPC animations are not documented anywhere, and as such you will just have to try out various settings until you find the animation you want. Default animation is 0 (idle)"],
								min = 0, max = 822, step = 1,
								set = function(info, value)
									if value > 822 then value = 822 elseif value < 0 then value = 0 end
									E.db.KlixUI.misc.AFKPetModel[ info[#info] ] = value
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
					style = {
						order = 1,
						type = "toggle",
						name = L["Style"],
						desc = L["Display the MerchantFrame in one window instead of a small one with variouse amount of pages."],
						disabled = function() return not E.private.KlixUI.skins.blizzard.merchant end,
					},
					subpages = {
						order = 2,
						type = 'range',
						name = L["Subpages"],
						desc = L["Subpages are blocks of 10 items. This option set how many of subpages will be shown on a single page."],
						min = 2, max = 5, step = 1,
						disabled = function() return not E.private.KlixUI.skins.blizzard.merchant or E.db.KlixUI.misc.merchant.style ~= true end,
					},
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
			bloodlust = {
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
			},
			easyCurve = {
				order = 5,
				type = "group",
				name = L["Easy Curve"],
				get = function(info) return E.db.KlixUI.misc.easyCurve[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.misc.easyCurve[ info[#info] ] = value; end,
				args = {	
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc =  L["Enable/disable the Easy Curve popup frame."],
						get = function(info) return E.db.KlixUI.misc.easyCurve.enable end,
						set = function(info, value) E.db.KlixUI.misc.easyCurve.enable = value; E:StaticPopup_Show("PRIVATE_RL"); end,
					},
					override = {
						order = 2,
						name = L["Enable Override"],
						desc = L["Overrides the default achievements found and will always send the selected achievement from the dropdown."],
						type = "toggle",
						width = "full",
						disabled = function() return not E.db.KlixUI.misc.easyCurve.enable end,
						get = function() return E.db.KlixUI.misc.easyCurve.override end,
						set = function(info, value) E.db.KlixUI.misc.easyCurve.override = value; end
					},
					search = {
						order = 3,
						name = L["Search Achievements"],
						desc = L["Search term must be greater than 3 characters."],
						type = "input",
						width = "full",
						disabled = function() return not E.db.KlixUI.misc.easyCurve.override or not E.db.KlixUI.misc.easyCurve.enable end,
						set = function(info, value) 
							T.SetAchievementSearchString(value) 
							newSearch = true 
						end,
						validate = function(info, value) 
							if string.len(value) < 3 then 
								return L["Error: Search term must be greater than 3 characters"]
							else 
								return true 
							end 
						end
					},
					results = {
						order = 4,
						name = function()
							if newSearch then 
								return T.string_format("Select Override Achievement: %s Results Returned", T.tostring(KEC:TableLength(KEC.achievementSearchList)))
							else
								return L["Select Override Achievement"]
							end
						end,
						desc = L["Results are limited to 500 and only completed achievemnts. Please try a more specific search term if you cannot find the achievement listed."],
						type = "select",
						values = KEC.achievementSearchList,
						width = "full",
						disabled = function() 
							return not E.db.KlixUI.misc.easyCurve.override 
								   or not E.db.KlixUI.misc.easyCurve.enable 
								   or (not E.db.KlixUI.misc.easyCurve.overrideAchievement and not newSearch) 
						end,
						get = function() 
							if E.db.KlixUI.misc.easyCurve.overrideAchievement then
								return E.db.KlixUI.misc.easyCurve.overrideAchievement
							else
								return 1
							end
						end,
						set = function(info, value) E.db.KlixUI.misc.easyCurve.overrideAchievement = value end,
						validate = function(info, value) 
							if value == 1 then 
								return L["Error: Please select an achievement"] 
							else 
								return true 
							end 
						end
					},
					whispersAchievement = {
						order = 5,
						name = L["Always Check Achievement Whisper Dialog Checkbox"],
						desc = L["This will always check the achievement whisper dialog checkbox when signing up for a group by default."],
						type = "toggle",
						width = "double",
						disabled = function() return not E.db.KlixUI.misc.easyCurve.enable  end,
						get = function() return E.db.KlixUI.misc.easyCurve.whispersAchievement end,
						set = function(info, value) 
							E.db.KlixUI.misc.easyCurve.whispersAchievement = value 
							KEC.checkButtonAchievement:SetChecked(value) 
						end,
					},
					whispersKeystone = {
						order = 6,
						name = L["Always Check Keystone Whisper Dialog Checkbox"],
						desc = L["This will always check the keystone whisper dialog checkbox when signing up for a mythic plus group by default."],
						type = "toggle",
						width = "double",
						disabled = function() return not E.db.KlixUI.misc.easyCurve.enable end,
						get = function() return E.db.KlixUI.misc.easyCurve.whispersKeystone end,
						set = function(info, value) 
							E.db.KlixUI.misc.easyCurve.whispersKeystone = value 
							KEC.checkButtonKeystone:SetChecked(value)  
						end,
					},
				},
			},
			auto = {
				order = 6,
				type = "group",
				name = L["Automatization"],
				get = function(info) return E.db.KlixUI.misc.auto[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.misc.auto[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					keystones = {
						order = 1,
						type = "toggle",
						name = L["Auto Keystones"],
						desc = L["Automatically insert keystones when you open the keystonewindow in a dungeon."],
					},
					gossip = {
						order = 2,
						type = "toggle",
						name = L["Auto Gossip"],
						desc = L["This setting will auto gossip some NPC's.\n|cffff8000Note: Holding down any modifier key before visiting/talking to the respective NPC's will briefly disable the automatization.|r"],
					},
					auction = {
						order = 3,
						type = "toggle",
						name = L["Auto Auction"],
						desc = L["Shift + Right-Click to auto buy auctions at the auctionhouse."],
					},
					skipAA = {
						order = 4,
						type = "toggle",
						name = L["Skip Azerite Animations"],
						desc = L["Skips the reveal animation of a new azerite armor piece and the animation after you select a trait."],
					},
					teleportation = {
						order = 5,
						type = "toggle",
						name = L["Teleportation"]..E.NewSign,
						desc = L["Automatically reequips your last item, after using an item, with teleportation feature."],
					},
					space1 = {
						order = 9,
						type = "description",
						name = "",
					},
					workorder = {
						order = 10,
						type = "group",
						name = L["Work Orders"],
						get = function(info) return E.db.KlixUI.misc.auto.workorder[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.misc.auto.workorder[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
						args = {
							intro = {
								order = 1,
								type = "description",
								name = L["WO_DESC"],
							},
							orderhall = {
								order = 2,
								type = "toggle",
								name = L["OrderHall/Ship"],
								desc = L["Auto start orderhall/ship workorders when visiting the npc."],
								disabled = function() return COMP.SLE and (E.db.sle.legacy.warwampaign.autoOrder.enable or E.db.sle.legacy.orderhall.autoOrder.enable) end,
								hidden = function() return COMP.SLE and (E.db.sle.legacy.warwampaign.autoOrder.enable or E.db.sle.legacy.orderhall.autoOrder.enable) end,
							},
							nomi = {
								order = 3,
								type = "toggle",
								name = L["Nomi"],
								desc = L["Auto start workorders when visiting Nomi."],
							},
						},
					},
					invite = {
						order = 11,
						type = "group",
						name = L["Invite"],
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
					screenshot = {
						order = 12,
						type = "group",
						name = L["Screenshot"],
						get = function(info) return E.db.KlixUI.misc.auto.screenshot[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.misc.auto.screenshot[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								width = "full",
								name = L["Enable"],
								desc = L["Auto screenshot when you get an achievement."],
							},
							screenFormat = {
								order = 2,
								name = L["Screen Format"],
								type = "select",
								values = {
									["jpeg"] = "JPG",
									["tga"] = "TGA",
								},
								disabled = function() return not E.db.KlixUI.misc.auto.screenshot.enable end,
								get = function(info) return T.GetCVar("screenshotFormat") end,
								set = function(info, value) T.SetCVar("screenshotFormat", value) end,
							},
							screenQuality = {
								order = 3,
								name = L["Screen Quality"],
								type = "range",
								min = 3, max = 10, step = 1,
								disabled = function() return not E.db.KlixUI.misc.auto.screenshot.enable end,
								get = function(info) return T.tonumber(T.GetCVar("screenshotQuality")) end,
								set = function(info, value) T.SetCVar("screenshotQuality", T.tostring(value)) end,
							},
						},
					},
					rolecheck = {
						order = 13,
						type = "group",
						name = L["Role Check"],
						get = function(info) return E.db.KlixUI.misc.auto.rolecheck[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.misc.auto.rolecheck[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								desc =  L["Automatically accept all role check popups."],
							},
							confirm = {
								order = 2,
								type = "toggle",
								name = L["Confirm Role Checks"],
								desc =  L["After you join a custom group finder raid a box pops up telling you your role and won't dissapear until clicked, this gets rid of it."],
							},
							spacer1 = {
								order = 3,
								type = "description",
								name = "",
							},
							timewalking = {
								order = 4,
								type = "toggle",
								name = L["Timewalking"],
								desc =  L["Automatically accept timewalking role check popups."],
								disabled = function() return E.db.KlixUI.misc.auto.rolecheck.enable end,
							},
							love = {
								order = 5,
								type = "toggle",
								name = L["Love is in the Air"],
								desc =  L["Automatically accept Love is in the Air dungeon role check popups."],
								disabled = function() return E.db.KlixUI.misc.auto.rolecheck.enable end,
							},
							halloween = {
								order = 6,
								type = "toggle",
								name = L["Halloween"],
								desc =  L["Automatically accept Halloween dungeon role check popups."],
								disabled = function() return E.db.KlixUI.misc.auto.rolecheck.enable end,
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
			scrapper = {
				order = 8,
				type = "group",
				name = L["Scrap Machine"],
				get = function(info) return E.db.KlixUI.misc.scrapper[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.misc.scrapper[ info[#info] ] = value end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Show the scrapbutton at the scrappingmachineUI."],
						set = function(info, value) E.db.KlixUI.misc.scrapper[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
					},
					position = {
						order = 2,
						type = "select",
						name = L["Position"],
						desc = L["Place scrap button at the top or the bottom of the scrappingmachineUI."],
						disabled = function() return not E.db.KlixUI.misc.scrapper.enable end,
						set = function(info, value) E.db.KlixUI.misc.scrapper[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
						values = {
							["TOP"] = L["Top"],
							["BOTTOM"] = L["Bottom"],
						},
					},
					autoOpen = {
						order = 3,
						type = "toggle",
						name = L["Auto Open Bags"],
						desc = L["Auto open bags when visiting the scrapping machine."],
						disabled = function() return not E.private.bags.enable end,
					},
					equipmentsets = {
						order = 4,
						type = "toggle",
						name = L["Equipment Sets"],
						desc = L["Ignore items in equipment sets."],
						disabled = function() return not E.db.KlixUI.misc.scrapper.enable end,
					},
					azerite = {
						order = 5,
						type = "toggle",
						name = L["Azerite"],
						desc = L["Ignore azerite items."],
						disabled = function() return not E.db.KlixUI.misc.scrapper.enable end,
					},
					boe = {
						order = 6,
						type = "toggle",
						name = L["Bind-on-Equipped"],
						desc = L["Ignore bind-on-equipped items."],
						disabled = function() return not E.db.KlixUI.misc.scrapper.enable end,
					},
					Itemlvl = {
						order = 7,
						type = "toggle",
						name = L["Equipped Item Level"],
						desc = L["Don't insert items above equipped iLvl."],
						disabled = function() return not E.db.KlixUI.misc.scrapper.enable end,
					},
					Itemprint = {
						order = 8,
						type = "toggle",
						name = L["Item Print"],
						desc = L["Print inserted scrap items to the chat window."],
						disabled = function() return not E.db.KlixUI.misc.scrapper.enable end,
					},
					specificilvl = {
						order = 8,
						type = "toggle",
						name = L["Specific Item Level"],
						desc = L["Ignore items above specific item level."],
						disabled = function() return not E.db.KlixUI.misc.scrapper.enable end,
					},
					specificilvlbox = {
						order = 9,
						type = "input",
						width = 0.75,
						name = L["Item Level"],
						disabled = function() return not E.db.KlixUI.misc.scrapper.enable or not E.db.KlixUI.misc.scrapper.specificilvl end,
					},
					itemlevel = {
						order = 20,
						type = "group",
						name = L["Item Level"],
						get = function(info) return E.db.KlixUI.misc.scrapper.itemlevel[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.misc.scrapper.itemlevel[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
						guiInline = true,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								desc = L["Show the itemlevel on the items in the scrappingmachineUI."],
							},
							fontSize = {
								order = 2,
								name = FONT_SIZE,
								type = "range",
								min = 5, max = 22, step = 1,
								disabled = function() return not E.db.KlixUI.misc.scrapper.itemlevel.enable end,
							},
							fontOutline = {
								order = 3,
								type = "select",
								name = L["Font Outline"],
								values = {
									["NONE"] = NONE,
									["OUTLINE"] = "OUTLINE",
									["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
									["THICKOUTLINE"] = "THICKOUTLINE",
								},
								disabled = function() return not E.db.KlixUI.misc.scrapper.itemlevel.enable end,
							},
						},
					},
				},
			},]]
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
						get = function(info) return T.GetCVar("cameraDistanceMaxZoomFactor") * base end,
						set = function(info, value) E.db.KlixUI.misc.zoom.distance = value / base; T.SetCVar("cameraDistanceMaxZoomFactor", value / base) end,
						min = base, max = base * maxfactor, step = 1.5, -- cvar gets rounded to 1 decimal
					},
				},
			},
			--[[autolog = {
				order = 10,
				type = "group",
				name = L["AutoLog"],
				get = function(info) return E.db.KlixUI.misc.autolog[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.misc.autolog[ info[#info] ] = value; AL:CheckLog() end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Enable/disable automatically combat logging"],
						set = function(info, value) E.db.KlixUI.misc.autolog[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end
					},
					allraids = {
						order = 2,
						type = "toggle",
						name = L["All raids"],
						desc = L["Combat log all raids regardless of individual raid settings"],
						disabled = function() return not E.db.KlixUI.misc.autolog.enable end,
					},
					chatwarning = {
						order = 3,
						type = "toggle",
						name = L["Display in chat"],
						desc = L["Display the combat log status in the chat window"],
						disabled = function() return not E.db.KlixUI.misc.autolog.enable end,
					},
					dungeons = {
						order = 4,
						type = "toggle",
						name = L["5 player heroic instances"],
						desc = L["Combat log 5 player heroic instances"],
						disabled = function() return not E.db.KlixUI.misc.autolog.enable end,
					},
					challenge = {
						order = 5,
						type = "toggle",
						name = L["5 player challenge mode instances"],
						desc = L["Combat log 5 player challenge mode instances"],
						disabled = function() return not E.db.KlixUI.misc.autolog.enable end,
					},
					mythicdungeons = {
						order = 6,
						type = "toggle",
						name = L["5 player mythic instances"],
						desc = L["Combat log 5 player mythic instances"],
						disabled = function() return not E.db.KlixUI.misc.autolog.enable end,
					},
					mythiclevel = {
						order = 7,
						type = "select",
						width = 0.45,
						name = L["Minimum level"],
						desc = L["Logging will not be enabled for mythic levels lower than this"],
						disabled = function() return not E.db.KlixUI.misc.autolog.enable or not E.db.KlixUI.misc.autolog.mythicdungeons end,
						values = AL:getMythicLevelsList(),
					},
					lfr = {
						order = 10,
						type = "multiselect",
						name = L["LFR Raids"],
						desc = L["Raid finder instances where you want to log combat"],
						values = AL:MakeList(raid_lfr),
						tristate = false,
						disabled = function() return not E.db.KlixUI.misc.autolog.enable end,
						get = function(info, raid) return AL:GetSetting("lfr", raid) end,
						set = function(info, raid, value) AL:SetSetting("lfr", raid, value) end,
					},
					raidsn = {
						order = 11,
						type = "multiselect",
						name = L["Normal Raids"],
						desc = L["Raid instances where you want to log combat"],
						values = AL:MakeList(raid_normal),
						tristate = false,
						disabled = function() return not E.db.KlixUI.misc.autolog.enable end,
						get = function(info, raid) return AL:GetSetting("normal", raid) end,
						set = function(info, raid, value) AL:SetSetting("normal", raid, value) end,
					},
					raidsh = {
						order = 12,
						type = "multiselect",
						name = L["Heroic Raids"],
						desc = L["Raid instances where you want to log combat"],
						values = AL:MakeList(raid_heroic),
						tristate = false,
						disabled = function() return not E.db.KlixUI.misc.autolog.enable end,
						get = function(info, raid) return AL:GetSetting("heroic", raid) end,
						set = function(info, raid, value) AL:SetSetting("heroic", raid, value) end,
					},
					mythic = {
						order = 13,
						type = "multiselect",
						name = L["Mythic Raids"],
						desc = L["Raid instances where you want to log combat"],
						values = AL:MakeList(raid_mythic),
						tristate = false,
						disabled = function() return not E.db.KlixUI.misc.autolog.enable end,
						get = function(info, raid) return AL:GetSetting("mythic", raid) end,
						set = function(info, raid, value) AL:SetSetting("mythic", raid, value) end,
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
							pet = {
								order = 2,
								type = "toggle",
								name = PET_BATTLE_PVP_DUEL,
								desc = L["Automatically cancel pet battles duel requests."],
							},
							announce = {
								order = 3,
								type = "toggle",
								name = L["Announce"],
								desc = L["Announce in chat if duel was rejected."],
							},
						},
					},
					BossBanner = {
						order = 4,
						type = "group",
						name = KILLING_BLOWS,
						guiInline = true,
						disabled = function() return T.IsAddOnLoaded("ElvUI_SLE") end,
						hidden = function() return T.IsAddOnLoaded("ElvUI_SLE") end,
						get = function(info) return E.private.KlixUI.pvp.KBbanner[ info[#info] ] end,
						set = function(info, value) E.private.KlixUI.pvp.KBbanner[ info[#info] ] = value end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								desc = L["Show your PvP killing blows as a popup."],
								set = function(info, value) E.private.KlixUI.pvp.KBbanner[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
							},
							sound = {
								order = 2,
								type = "toggle",
								name = L["KB Sound"],
								desc = L["Play sound when killing blows popup is shown."],
								disabled = function() return not E.private.KlixUI.pvp.KBbanner.enable end,
							},
						},
					},
				},
			},
			CA = {
				order = 50,
				type = "group",
				name = L["Corrupted Ashbringer"],
				hidden = function() return not (KUI:IsDeveloper() and KUI:IsDeveloperRealm()) end,
				disabled = function() return not (KUI:IsDeveloper() and KUI:IsDeveloperRealm()) end,
				get = function(info) return E.db.KlixUI.misc.CA[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.misc.CA[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc =  L["Plays corrupted ashbringer sounds when entering combat."],
					},
					nextSound = {
						order = 2,
						type = "range",
						name = L["Sound Number"],
						desc =  L["Changes which of the corrupted ashbringer sounds it should play in a numeric order."],
						min = 1, max = 12, step = 1,
						disabled = function() return not E.db.KlixUI.misc.CA.enable end,
					},
					soundProbabilityPercent = {
						order = 3,
						type = "range",
						name = L["Sound Probability"],
						desc = L["Changes the probability value, in percent, how often the sounds will play."],
						min = 0, max = 100, step = 1,
						disabled = function() return not E.db.KlixUI.misc.CA.enable end,
					},
					passiveMode = {
						order = 4,
						type = "toggle",
						name = L["Always Whisper"],
						desc =  L["Plays the corrupted ashbringer while out of combat aswell."],
						disabled = function() return not E.db.KlixUI.misc.CA.enable end,
					},
					intervalProbability = {
						order = 5,
						type = "range",
						name = L["Interval Probability"],
						desc =  L["Changes the probability value, in seconds, how often the sounds will play."],
						min = 1, max = 1200, step = 1,
						disabled = function() return not E.db.KlixUI.misc.CA.enable or not E.db.KlixUI.misc.CA.passiveMode end,
					},
				},
			},]]
		},
	}
end
T.table_insert(KUI.Config, Misc)

--[[local function injectElvUIDataTextsOptions()
	E.Options.args.general.args.general.args.spacer1 = {
		order = 28,
		type = 'description',
		name = '',
	}

	E.Options.args.general.args.general.args.spacer2 = {
		order = 29,
		type = 'header',
		name = '',
	}
	
	E.Options.args.general.args.general.args.gotoklixui = {
		order = 30,
		type = "execute",
		name = KUI:cOption(L["KlixUI Panels"]),
		func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "KlixUI", "modules", "misc", "panels") end,
	}
end
T.table_insert(KUI.Config, injectElvUIDataTextsOptions)]]