local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local AS = KUI:GetModule("AnnouncementSystem")

local function FormatDesc(code, helpText)
	return KUI:ColorStr(code).." = "..helpText
end

local function AnnouncementSystemTable()
	E.Options.args.KlixUI.args.modules.args.announcement = {
		type = "group",
		order = 3,
		name = L["Announcement"],
		childGroups = 'tab',
		get = function(info) return E.db.KlixUI.announcement[ info[#info] ] end,
		set = function(info, value) E.db.KlixUI.announcement[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = KUI:cOption(L["Announcement"]),
			},
			enable = {
				order = 2,
				type = "toggle",
				width = "full",
				name = L["Enable"],
			}, 
			interrupt = {
				order = 3,
				type = "group",
				name = L["Interrupt"],
				disabled = function(info) return not E.db.KlixUI.announcement.enable end,
				get = function(info) return E.db.KlixUI.announcement.interrupt[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.announcement.interrupt[ info[#info] ] = value; end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
					},
					only_instance = {
						order = 2,
						type = "toggle",
						name = L["Only instance / arena"],
						hidden = function(info) return not E.db.KlixUI.announcement.interrupt.enable end,
					},
					player = {
						order = 3,
						type = "group",
						name = L["Player(Only you)"],
						hidden = function(info) return not E.db.KlixUI.announcement.interrupt.enable end,
						get = function(info) return E.db.KlixUI.announcement.interrupt.player[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.announcement.interrupt.player[ info[#info] ] = value; end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
							},
							default_text = {
								order = 2,
								type = "execute",
								name = L["Use default text"],
								buttonElvUI = true,
								disabled = function(info) return not E.db.KlixUI.announcement.interrupt.player.enable end,
								func = function() E.db.KlixUI.announcement.interrupt.player.text = P.KlixUI.announcement.interrupt.player.text end
							},
							text = {
								order = 3,
								type = "input",
								width = 'full',
								name = L["Text for the interrupt casted by you"],
								desc = FormatDesc("%player%", L["Your name"]).."\n"..FormatDesc("%target%", L["Target name"]).."\n"..FormatDesc("%player_spell%", L["Your spell link"]).."\n"..FormatDesc("%target_spell%", L["Interrupted spell link"]),
								disabled = function(info) return not E.db.KlixUI.announcement.interrupt.player.enable end,
							},
							text_example = {
								order = 4,
								type = "description",
								hidden = function(info) return not E.db.KlixUI.announcement.interrupt.player.enable end,
								name = function()
									local custom_message = E.db.KlixUI.announcement.interrupt.player.text
									custom_message = T.string_gsub(custom_message, "%%player%%", T.UnitName("player"))
									custom_message = T.string_gsub(custom_message, "%%target%%", L["Sylvanas"])
									custom_message = T.string_gsub(custom_message, "%%player_spell%%", T.GetSpellLink(31935))
									custom_message = T.string_gsub(custom_message, "%%target_spell%%", T.GetSpellLink(252150))
									return "\n"..KUI:ColorStr(L["Example"])..": "..custom_message
								end
							},
							channel = {
								order = 5,
								type = "group",
								name = L["Channel"],
								disabled = function(info) return not E.db.KlixUI.announcement.interrupt.player.enable end,
								get = function(info) return E.db.KlixUI.announcement.interrupt.player.channel[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.announcement.interrupt.player.channel[ info[#info] ] = value; end,
								args = {
									solo = {
										order = 1,
										name = L["Solo"],
										type = "select",
										values = {
											["NONE"] = L["None"],
											["SELF"] = L["Self(Chat Frame)"],
											["EMOTE"] = L["Emote"],
											["YELL"] = L["Yell"],
											["SAY"] = L["Say"],
										},
									},
									party = {
										order = 2,
										name = L["In party"],
										type = "select",
										values = {
											["NONE"] = L["None"],
											["SELF"] = L["Self(Chat Frame)"],
											["EMOTE"] = L["Emote"],
											["PARTY"] = L["Party"],
											["YELL"] = L["Yell"],
											["SAY"] = L["Say"],
										},
									},
									instance = {
										order = 3,
										name = L["In instance"],
										type = "select",
										values = {
											["NONE"] = L["None"],
											["SELF"] = L["Self(Chat Frame)"],
											["EMOTE"] = L["Emote"],
											["PARTY"] = L["Party"],
											["INSTANCE_CHAT"] = L["Instance"],
											["YELL"] = L["Yell"],
											["SAY"] = L["Say"],
										},
									},
									raid = {
										order = 4,
										name = L["In raid"],
										type = "select",
										values = {
											["NONE"] = L["None"],
											["SELF"] = L["Self(Chat Frame)"],
											["EMOTE"] = L["Emote"],
											["PARTY"] = L["Party"],
											["RAID"] = L["Raid"],
											["YELL"] = L["Yell"],
											["SAY"] = L["Say"],
										},
									},
								}
							},
						},
					},
					others = {
						order = 4,
						type = "group",
						name = L["Other players"],
						hidden = function(info) return not E.db.KlixUI.announcement.interrupt.enable end,
						get = function(info) return E.db.KlixUI.announcement.interrupt.others[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.announcement.interrupt.others[ info[#info] ] = value; end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
							},
							default_text = {
								order = 2,
								type = "execute",
								name = L["Use default text"],
								buttonElvUI = true,
								disabled = function(info) return not E.db.KlixUI.announcement.interrupt.others.enable end,
								func = function() E.db.KlixUI.announcement.interrupt.others.text = P.KlixUI.announcement.interrupt.others.text end
							},
							text = {
								order = 3,
								type = "input",
								width = 'full',
								name = L["Text for the interrupt casted by others"],
								desc = FormatDesc("%player%", L["Name of the player"]).."\n"..FormatDesc("%target%", L["Target name"]).."\n"..FormatDesc("%player_spell%", L["The spell link"]).."\n"..FormatDesc("%target_spell%", L["Interrupted spell link"]),
								disabled = function(info) return not E.db.KlixUI.announcement.interrupt.others.enable end,
							},
							text_example = {
								order = 4,
								type = "description",
								hidden = function(info) return not E.db.KlixUI.announcement.interrupt.others.enable end,
								name = function()
									local custom_message = E.db.KlixUI.announcement.interrupt.others.text
									custom_message = T.string_gsub(custom_message, "%%player%%", T.UnitName("player"))
									custom_message = T.string_gsub(custom_message, "%%target%%", L["Sylvanas"])
									custom_message = T.string_gsub(custom_message, "%%player_spell%%", T.GetSpellLink(31935))
									custom_message = T.string_gsub(custom_message, "%%target_spell%%", T.GetSpellLink(252150))
									return "\n"..KUI:ColorStr(L["Example"])..": "..custom_message
								end
							},
							channel = {
								order = 5,
								type = "group",
								name = L["Channel"],
								disabled = function(info) return not E.db.KlixUI.announcement.interrupt.others.enable end,
								get = function(info) return E.db.KlixUI.announcement.interrupt.others.channel[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.announcement.interrupt.others.channel[ info[#info] ] = value; end,
								args = {
									["party"] = {
										order = 1,
										name = L["In party"],
										type = "select",
										values = {
											["NONE"] = L["None"],
											["SELF"] = L["Self(Chat Frame)"],
											["EMOTE"] = L["Emote"],
											["PARTY"] = L["Party"],
											["YELL"] = L["Yell"],
											["SAY"] = L["Say"],
										},
									},
									["instance"] = {
										order = 2,
										name = L["In instance"],
										type = "select",
										values = {
											["NONE"] = L["None"],
											["SELF"] = L["Self(Chat Frame)"],
											["EMOTE"] = L["Emote"],
											["PARTY"] = L["Party"],
											["INSTANCE_CHAT"] = L["Instance"],
											["YELL"] = L["Yell"],
											["SAY"] = L["Say"],
										},
									},
									["raid"] = {
										order = 3,
										name = L["In raid"],
										type = "select",
										values = {
											["NONE"] = L["None"],
											["SELF"] = L["Self(Chat Frame)"],
											["EMOTE"] = L["Emote"],
											["PARTY"] = L["Party"],
											["RAID"] = L["Raid"],
											["YELL"] = L["Yell"],
											["SAY"] = L["Say"],
										},
									},
								}
							}

						}
					},
				},
			},
			utility_spells = {
				order = 6,
				type = "group",
				name = L["Utility spells"],
				disabled = function(info) return not E.db.KlixUI.announcement.enable end,
				get = function(info) return E.db.KlixUI.announcement.utility_spells[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.announcement.utility_spells[ info[#info] ] = value; end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
					},
					channel = {
						order = 2,
						type = "group",
						name = L["Channel"],
						hidden = function(info) return not E.db.KlixUI.announcement.utility_spells.enable end,
						get = function(info) return E.db.KlixUI.announcement.utility_spells.channel[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.announcement.utility_spells.channel[ info[#info] ] = value; end,
						args = {
							["solo"] = {
								order = 1,
								name = L["Solo"],
								type = "select",
								values = {
									["NONE"] = L["None"],
									["SELF"] = L["Self(Chat Frame)"],
									["EMOTE"] = L["Emote"],
									["YELL"] = L["Yell"],
									["SAY"] = L["Say"],
								},
							},
							["party"] = {
								order = 2,
								name = L["In party"],
								type = "select",
								values = {
									["NONE"] = L["None"],
									["SELF"] = L["Self(Chat Frame)"],
									["EMOTE"] = L["Emote"],
									["PARTY"] = L["Party"],
									["YELL"] = L["Yell"],
									["SAY"] = L["Say"],
								},
							},
							["instance"] = {
								order = 3,
								name = L["In instance"],
								type = "select",
								values = {
									["NONE"] = L["None"],
									["SELF"] = L["Self(Chat Frame)"],
									["EMOTE"] = L["Emote"],
									["PARTY"] = L["Party"],
									["INSTANCE_CHAT"] = L["Instance"],
									["YELL"] = L["Yell"],
									["SAY"] = L["Say"],
								},
							},
							["raid"] = {
								order = 4,
								name = L["In raid"],
								type = "select",
								values = {
									["NONE"] = L["None"],
									["SELF"] = L["Self(Chat Frame)"],
									["EMOTE"] = L["Emote"],
									["PARTY"] = L["Party"],
									["RAID"] = L["Raid"],
									["YELL"] = L["Yell"],
									["SAY"] = L["Say"],
								},
							},
						}
					},
					ritual_of_summoning = {
						order = 10,
						type = "group",
						--name = L["Ritual of Summoning"],
						name = function(info)
							return T.select(1, T.GetSpellInfo(P.KlixUI.announcement.utility_spells.spells.ritual_of_summoning.id))
						end,
						hidden = function(info)
							return not E.db.KlixUI.announcement.utility_spells.enable
						end,
						get = function(info)
							return E.db.KlixUI.announcement.utility_spells.spells.ritual_of_summoning[ info[#info] ]
						end,
						set = function(info, value)
							E.db.KlixUI.announcement.utility_spells.spells.ritual_of_summoning[ info[#info] ] = value
						end,
						func = function(info)
							E.db.KlixUI.announcement.utility_spells.spells.ritual_of_summoning.text = P.KlixUI.announcement.utility_spells.spells.ritual_of_summoning.text
						end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								disabled = false,
								name = L["Enable"],
							},
							use_raid_warning = {
								order = 2,
								type = "toggle",
								name = L["Use raid warning"],
								desc = L["Use raid warning when you is raid leader or assistant."],
								hidden = function(info) return E.db.KlixUI.announcement.utility_spells.channel.raid ~= "RAID" end,
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.ritual_of_summoning.enable end,
							},
							player_cast = {
								order = 3,
								type = "toggle",
								name = L["Only I casted"],
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.ritual_of_summoning.enable end,
							},
							default_text = {
								order = 4,
								type = "execute",
								name = L["Use default text"],
								buttonElvUI = true,
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.ritual_of_summoning.enable end,
							},
							text = {
								order = 5,
								type = "input",
								width = 'full',
								name = L["Text"],
								desc = FormatDesc("%player%", L["Name of the player"]).."\n"..FormatDesc("%spell%", L["The spell link"]),
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.ritual_of_summoning.enable end,
							},
							text_example = {
								order = 6,
								type = "description",
								hidden = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.ritual_of_summoning.enable end,
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.ritual_of_summoning.enable end,
								name = function(info)
									local custom_message = E.db.KlixUI.announcement.utility_spells.spells.ritual_of_summoning.text
									custom_message = T.string_gsub(custom_message, "%%player%%", T.UnitName("player"))
									custom_message = T.string_gsub(custom_message, "%%spell%%", T.GetSpellLink(E.db.KlixUI.announcement.utility_spells.spells.ritual_of_summoning.id))
									return "\n"..KUI:ColorStr(L["Example"])..": "..custom_message
								end
							},
						},
					},
					create_soulwell = {
						order = 11,
						type = "group",
						--name = L["Soulwell"],
						name = function(info)
							return T.select(1, T.GetSpellInfo(P.KlixUI.announcement.utility_spells.spells.create_soulwell.id))
						end,
						hidden = function(info)
							return not E.db.KlixUI.announcement.utility_spells.enable
						end,
						get = function(info)
							return E.db.KlixUI.announcement.utility_spells.spells.create_soulwell[ info[#info] ]
						end,
						set = function(info, value)
							E.db.KlixUI.announcement.utility_spells.spells.create_soulwell[ info[#info] ] = value
						end,
						func = function(info)
							E.db.KlixUI.announcement.utility_spells.spells.create_soulwell.text = P.KlixUI.announcement.utility_spells.spells.create_soulwell.text
						end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								disabled = false,
								name = L["Enable"],
							},
							use_raid_warning = {
								order = 2,
								type = "toggle",
								name = L["Use raid warning"],
								desc = L["Use raid warning when you is raid leader or assistant."],
								hidden = function(info) return E.db.KlixUI.announcement.utility_spells.channel.raid ~= "RAID" end,
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.create_soulwell.enable end,
							},
							player_cast = {
								order = 3,
								type = "toggle",
								name = L["Only I casted"],
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.create_soulwell.enable end,
							},
							default_text = {
								order = 4,
								type = "execute",
								name = L["Use default text"],
								buttonElvUI = true,
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.create_soulwell.enable end,
							},
							text = {
								order = 5,
								type = "input",
								width = 'full',
								name = L["Text"],
								desc = FormatDesc("%player%", L["Name of the player"]).."\n"..FormatDesc("%spell%", L["The spell link"]),
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.create_soulwell.enable end,
							},
							text_example = {
								order = 6,
								type = "description",
								hidden = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.create_soulwell.enable end,
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.create_soulwell.enable end,
								name = function(info)
									local custom_message = E.db.KlixUI.announcement.utility_spells.spells.create_soulwell.text
									custom_message = T.string_gsub(custom_message, "%%player%%", T.UnitName("player"))
									custom_message = T.string_gsub(custom_message, "%%spell%%", T.GetSpellLink(E.db.KlixUI.announcement.utility_spells.spells.create_soulwell.id))
									return "\n"..KUI:ColorStr(L["Example"])..": "..custom_message
								end
							},
						},
					},
					moll_e = {
						order = 12,
						type = "group",
						--name = L["MOLL-E"],
						name = function(info)
							return T.select(1, T.GetSpellInfo(P.KlixUI.announcement.utility_spells.spells.moll_e.id))
						end,
						hidden = function(info)
							return not E.db.KlixUI.announcement.utility_spells.enable
						end,
						get = function(info)
							return E.db.KlixUI.announcement.utility_spells.spells.moll_e[ info[#info] ]
						end,
						set = function(info, value)
							E.db.KlixUI.announcement.utility_spells.spells.moll_e[ info[#info] ] = value
						end,
						func = function(info)
							E.db.KlixUI.announcement.utility_spells.spells.moll_e.text = P.KlixUI.announcement.utility_spells.spells.moll_e.text
						end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								disabled = false,
								name = L["Enable"],
							},
							use_raid_warning = {
								order = 2,
								type = "toggle",
								name = L["Use raid warning"],
								desc = L["Use raid warning when you is raid leader or assistant."],
								hidden = function(info) return E.db.KlixUI.announcement.utility_spells.channel.raid ~= "RAID" end,
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.moll_e.enable end,
							},
							player_cast = {
								order = 3,
								type = "toggle",
								name = L["Only I casted"],
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.moll_e.enable end,
							},
							default_text = {
								order = 4,
								type = "execute",
								name = L["Use default text"],
								buttonElvUI = true,
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.moll_e.enable end,
							},
							text = {
								order = 5,
								type = "input",
								width = 'full',
								name = L["Text"],
								desc = FormatDesc("%player%", L["Name of the player"]).."\n"..FormatDesc("%spell%", L["The spell link"]),
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.moll_e.enable end,
							},
							text_example = {
								order = 6,
								type = "description",
								hidden = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.moll_e.enable end,
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.moll_e.enable end,
								name = function(info)
									local custom_message = E.db.KlixUI.announcement.utility_spells.spells.moll_e.text
									custom_message = T.string_gsub(custom_message, "%%player%%", T.UnitName("player"))
									custom_message = T.string_gsub(custom_message, "%%spell%%", T.GetSpellLink(E.db.KlixUI.announcement.utility_spells.spells.moll_e.id))
									return "\n"..KUI:ColorStr(L["Example"])..": "..custom_message
								end
							},
						},
					},
					katy_stampwhistle = {
						order = 13,
						type = "group",
						--name = L["Stampwhistle"],
						name = function(info)
							return T.select(1, T.GetSpellInfo(P.KlixUI.announcement.utility_spells.spells.katy_stampwhistle.id))
						end,
						hidden = function(info)
							return not E.db.KlixUI.announcement.utility_spells.enable
						end,
						get = function(info)
							return E.db.KlixUI.announcement.utility_spells.spells.katy_stampwhistle[ info[#info] ]
						end,
						set = function(info, value)
							E.db.KlixUI.announcement.utility_spells.spells.katy_stampwhistle[ info[#info] ] = value
						end,
						func = function(info)
							E.db.KlixUI.announcement.utility_spells.spells.katy_stampwhistle.text = P.KlixUI.announcement.utility_spells.spells.katy_stampwhistle.text
						end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								disabled = false,
								name = L["Enable"],
							},
							use_raid_warning = {
								order = 2,
								type = "toggle",
								name = L["Use raid warning"],
								desc = L["Use raid warning when you is raid leader or assistant."],
								hidden = function(info) return E.db.KlixUI.announcement.utility_spells.channel.raid ~= "RAID" end,
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.katy_stampwhistle.enable end,
							},
							player_cast = {
								order = 3,
								type = "toggle",
								name = L["Only I casted"],
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.katy_stampwhistle.enable end,
							},
							default_text = {
								order = 4,
								type = "execute",
								name = L["Use default text"],
								buttonElvUI = true,
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.katy_stampwhistle.enable end,
							},
							text = {
								order = 5,
								type = "input",
								width = 'full',
								name = L["Text"],
								desc = FormatDesc("%player%", L["Name of the player"]).."\n"..FormatDesc("%spell%", L["The spell link"]),
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.katy_stampwhistle.enable end,
							},
							text_example = {
								order = 6,
								type = "description",
								hidden = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.katy_stampwhistle.enable end,
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.katy_stampwhistle.enable end,
								name = function(info)
									local custom_message = E.db.KlixUI.announcement.utility_spells.spells.katy_stampwhistle.text
									custom_message = T.string_gsub(custom_message, "%%player%%", T.UnitName("player"))
									custom_message = T.string_gsub(custom_message, "%%spell%%", T.GetSpellLink(E.db.KlixUI.announcement.utility_spells.spells.katy_stampwhistle.id))
									return "\n"..KUI:ColorStr(L["Example"])..": "..custom_message
								end
							},
						},
					},
					conjure_refreshment = {
						order = 14,
						type = "group",
						--name = L["Conjure Refreshment"],
						name = function(info)
							return T.select(1, T.GetSpellInfo(P.KlixUI.announcement.utility_spells.spells.conjure_refreshment.id))
						end,
						hidden = function(info)
							return not E.db.KlixUI.announcement.utility_spells.enable
						end,
						get = function(info)
							return E.db.KlixUI.announcement.utility_spells.spells.conjure_refreshment[ info[#info] ]
						end,
						set = function(info, value)
							E.db.KlixUI.announcement.utility_spells.spells.conjure_refreshment[ info[#info] ] = value
						end,
						func = function(info)
							E.db.KlixUI.announcement.utility_spells.spells.conjure_refreshment.text = P.KlixUI.announcement.utility_spells.spells.conjure_refreshment.text
						end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								disabled = false,
								name = L["Enable"],
							},
							use_raid_warning = {
								order = 2,
								type = "toggle",
								name = L["Use raid warning"],
								desc = L["Use raid warning when you is raid leader or assistant."],
								hidden = function(info) return E.db.KlixUI.announcement.utility_spells.channel.raid ~= "RAID" end,
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.conjure_refreshment.enable end,
							},
							player_cast = {
								order = 3,
								type = "toggle",
								name = L["Only I casted"],
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.conjure_refreshment.enable end,
							},
							default_text = {
								order = 4,
								type = "execute",
								name = L["Use default text"],
								buttonElvUI = true,
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.conjure_refreshment.enable end,
							},
							text = {
								order = 5,
								type = "input",
								width = 'full',
								name = L["Text"],
								desc = FormatDesc("%player%", L["Name of the player"]).."\n"..FormatDesc("%spell%", L["The spell link"]),
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.conjure_refreshment.enable end,
							},
							text_example = {
								order = 6,
								type = "description",
								hidden = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.conjure_refreshment.enable end,
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.conjure_refreshment.enable end,
								name = function(info)
									local custom_message = E.db.KlixUI.announcement.utility_spells.spells.conjure_refreshment.text
									custom_message = T.string_gsub(custom_message, "%%player%%", T.UnitName("player"))
									custom_message = T.string_gsub(custom_message, "%%spell%%", T.GetSpellLink(E.db.KlixUI.announcement.utility_spells.spells.conjure_refreshment.id))
									return "\n"..KUI:ColorStr(L["Example"])..": "..custom_message
								end
							},
						},
					},
					portals = {
						order = 15,
						type = "group",
						name = L["Portals"],
						hidden = function(info)
							return not E.db.KlixUI.announcement.utility_spells.enable
						end,
						get = function(info)
							return E.db.KlixUI.announcement.utility_spells.spells.portals[ info[#info] ]
						end,
						set = function(info, value)
							E.db.KlixUI.announcement.utility_spells.spells.portals[ info[#info] ] = value
						end,
						func = function(info)
							E.db.KlixUI.announcement.utility_spells.spells.portals.text = P.KlixUI.announcement.utility_spells.spells.portals.text
						end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								disabled = false,
								name = L["Enable"],
							},
							use_raid_warning = {
								order = 2,
								type = "toggle",
								name = L["Use raid warning"],
								desc = L["Use raid warning when you is raid leader or assistant."],
								hidden = function(info) return E.db.KlixUI.announcement.utility_spells.channel.raid ~= "RAID" end,
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.portals.enable end,
							},
							player_cast = {
								order = 3,
								type = "toggle",
								name = L["Only I casted"],
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.portals.enable end,
							},
							default_text = {
								order = 4,
								type = "execute",
								name = L["Use default text"],
								buttonElvUI = true,
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.portals.enable end,
							},
							text = {
								order = 5,
								type = "input",
								width = 'full',
								name = L["Text"],
								desc = FormatDesc("%player%", L["Name of the player"]).."\n"..FormatDesc("%spell%", L["The spell link"]),
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.portals.enable end,
							},
							text_example = {
								order = 6,
								type = "description",
								hidden = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.portals.enable end,
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.portals.enable end,
								name = function(info)
									local custom_message = E.db.KlixUI.announcement.utility_spells.spells.portals.text
									custom_message = T.string_gsub(custom_message, "%%player%%", T.UnitName("player"))
									custom_message = T.string_gsub(custom_message, "%%spell%%", T.GetSpellLink(10059))
									return "\n"..KUI:ColorStr(L["Example"])..": "..custom_message
								end
							},
						},
					},
					feasts = {
						order = 16,
						type = "group",
						name = L["Feasts"],
						hidden = function(info)
							return not E.db.KlixUI.announcement.utility_spells.enable
						end,
						get = function(info)
							return E.db.KlixUI.announcement.utility_spells.spells.feasts[ info[#info] ]
						end,
						set = function(info, value)
							E.db.KlixUI.announcement.utility_spells.spells.feasts[ info[#info] ] = value
						end,
						func = function(info)
							E.db.KlixUI.announcement.utility_spells.spells.feasts.text = P.KlixUI.announcement.utility_spells.spells.feasts.text
						end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								disabled = false,
								name = L["Enable"],
							},
							use_raid_warning = {
								order = 2,
								type = "toggle",
								name = L["Use raid warning"],
								desc = L["Use raid warning when you is raid leader or assistant."],
								hidden = function(info) return E.db.KlixUI.announcement.utility_spells.channel.raid ~= "RAID" end,
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.feasts.enable end,
							},
							player_cast = {
								order = 3,
								type = "toggle",
								name = L["Only I casted"],
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.feasts.enable end,
							},
							default_text = {
								order = 4,
								type = "execute",
								name = L["Use default text"],
								buttonElvUI = true,
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.feasts.enable end,
							},
							text = {
								order = 5,
								type = "input",
								width = 'full',
								name = L["Text"],
								desc = FormatDesc("%player%", L["Name of the player"]).."\n"..FormatDesc("%spell%", L["The spell link"]),
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.feasts.enable end,
							},
							text_example = {
								order = 6,
								type = "description",
								hidden = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.feasts.enable end,
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.feasts.enable end,
								name = function(info)
									local custom_message = E.db.KlixUI.announcement.utility_spells.spells.feasts.text
									custom_message = T.string_gsub(custom_message, "%%player%%", T.UnitName("player"))
									custom_message = T.string_gsub(custom_message, "%%spell%%", T.GetSpellLink(286050))
									return "\n"..KUI:ColorStr(L["Example"])..": "..custom_message
								end
							},
						},
					},
					bots = {
						order = 17,
						type = "group",
						name = L["Bots"],
						hidden = function(info)
							return not E.db.KlixUI.announcement.utility_spells.enable
						end,
						get = function(info)
							return E.db.KlixUI.announcement.utility_spells.spells.bots[ info[#info] ]
						end,
						set = function(info, value)
							E.db.KlixUI.announcement.utility_spells.spells.bots[ info[#info] ] = value
						end,
						func = function(info)
							E.db.KlixUI.announcement.utility_spells.spells.bots.text = P.KlixUI.announcement.utility_spells.spells.bots.text
						end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								disabled = false,
								name = L["Enable"],
							},
							use_raid_warning = {
								order = 2,
								type = "toggle",
								name = L["Use raid warning"],
								desc = L["Use raid warning when you is raid leader or assistant."],
								hidden = function(info) return E.db.KlixUI.announcement.utility_spells.channel.raid ~= "RAID" end,
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.bots.enable end,
							},
							player_cast = {
								order = 3,
								type = "toggle",
								name = L["Only I casted"],
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.bots.enable end,
							},
							default_text = {
								order = 4,
								type = "execute",
								name = L["Use default text"],
								buttonElvUI = true,
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.bots.enable end,
							},
							text = {
								order = 5,
								type = "input",
								width = 'full',
								name = L["Text"],
								desc = FormatDesc("%player%", L["Name of the player"]).."\n"..FormatDesc("%spell%", L["The spell link"]),
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.bots.enable end,
							},
							text_example = {
								order = 6,
								type = "description",
								hidden = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.bots.enable end,
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.bots.enable end,
								name = function(info)
									local custom_message = E.db.KlixUI.announcement.utility_spells.spells.bots.text
									custom_message = T.string_gsub(custom_message, "%%player%%", T.UnitName("player"))
									custom_message = T.string_gsub(custom_message, "%%spell%%", T.GetSpellLink(67826))
									return "\n"..KUI:ColorStr(L["Example"])..": "..custom_message
								end
							},
						},
					},
					toys = {
						order = 18,
						type = "group",
						name = L["Toys"],
						hidden = function(info)
							return not E.db.KlixUI.announcement.utility_spells.enable
						end,
						get = function(info)
							return E.db.KlixUI.announcement.utility_spells.spells.toys[ info[#info] ]
						end,
						set = function(info, value)
							E.db.KlixUI.announcement.utility_spells.spells.toys[ info[#info] ] = value
						end,
						func = function(info)
							E.db.KlixUI.announcement.utility_spells.spells.toys.text = P.KlixUI.announcement.utility_spells.spells.toys.text
						end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								disabled = false,
								name = L["Enable"],
							},
							use_raid_warning = {
								order = 2,
								type = "toggle",
								name = L["Use raid warning"],
								desc = L["Use raid warning when you is raid leader or assistant."],
								hidden = function(info) return E.db.KlixUI.announcement.utility_spells.channel.raid ~= "RAID" end,
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.toys.enable end,
							},
							player_cast = {
								order = 3,
								type = "toggle",
								name = L["Only I casted"],
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.toys.enable end,
							},
							default_text = {
								order = 4,
								type = "execute",
								name = L["Use default text"],
								buttonElvUI = true,
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.toys.enable end,
							},
							text = {
								order = 5,
								type = "input",
								width = 'full',
								name = L["Text"],
								desc = FormatDesc("%player%", L["Name of the player"]).."\n"..FormatDesc("%spell%", L["The spell link"]),
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.toys.enable end,
							},
							text_example = {
								order = 6,
								type = "description",
								hidden = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.toys.enable end,
								disabled = function(info) return not E.db.KlixUI.announcement.utility_spells.spells.toys.enable end,
								name = function(info)
									local custom_message = E.db.KlixUI.announcement.utility_spells.spells.toys.text
									custom_message = T.string_gsub(custom_message, "%%player%%", T.UnitName("player"))
									custom_message = T.string_gsub(custom_message, "%%spell%%", T.GetSpellLink(61031))
									return "\n"..KUI:ColorStr(L["Example"])..": "..custom_message
								end
							},
						},
					},
				},
			},
			combat_spells = {
				order = 7,
				type = "group",
				name = L["Combat spells"],
				disabled = function(info) return not E.db.KlixUI.announcement.enable end,
				get = function(info) return E.db.KlixUI.announcement.combat_spells[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.announcement.combat_spells[ info[#info] ] = value; end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
					},	
					combat_resurrection = {
						order = 10,
						type = "group",
						name = L["Combat resurrection"],
						hidden = function(info)
							return not E.db.KlixUI.announcement.combat_spells.enable
						end,
						get = function(info)
							return E.db.KlixUI.announcement.combat_spells.combat_resurrection[ info[#info] ]
						end,
						set = function(info, value)
							E.db.KlixUI.announcement.combat_spells.combat_resurrection[ info[#info] ] = value
						end,
						func = function(info)
							E.db.KlixUI.announcement.combat_spells.combat_resurrection.text = P.KlixUI.announcement.combat_spells.combat_resurrection.text
						end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
							},
							use_raid_warning = {
								order = 2,
								type = "toggle",
								name = L["Use raid warning"],
								desc = L["Use raid warning when you is raid leader or assistant."],
								hidden = function(info)
									return E.db.KlixUI.announcement.combat_spells.combat_resurrection.channel.raid ~= "RAID"
								end,
								disabled = function(info)
									return not E.db.KlixUI.announcement.combat_spells.combat_resurrection.enable
								end,
							},
							player_cast = {
								order = 3,
								type = "toggle",
								name = L["Only I casted"],
								disabled = function(info)
									return not E.db.KlixUI.announcement.combat_spells.combat_resurrection.enable
								end,
							},
							default_text = {
								order = 4,
								type = "execute",
								name = L["Use default text"],
								buttonElvUI = true,
								disabled = function(info)
									return not E.db.KlixUI.announcement.combat_spells.combat_resurrection.enable
								end,
							},
							text = {
								order = 5,
								type = "input",
								width = 'full',
								name = L["Text"],
								desc = FormatDesc("%player%", L["Name of the player"]).."\n"..FormatDesc("%target%", L["Target name"]).."\n"..FormatDesc("%spell%", L["The spell link"]),
								disabled = function(info)
									return not E.db.KlixUI.announcement.combat_spells.combat_resurrection.enable
								end,
							},
							text_example = {
								order = 6,
								type = "description",
								hidden = function(info) return not E.db.KlixUI.announcement.combat_spells.combat_resurrection.enable end,
								name = function(info)
									local custom_message = E.db.KlixUI.announcement.combat_spells.combat_resurrection.text
									custom_message = T.string_gsub(custom_message, "%%player%%", L["Sylvanas"])
									custom_message = T.string_gsub(custom_message, "%%target%%", T.UnitName("player"))
									custom_message = T.string_gsub(custom_message, "%%spell%%", T.GetSpellLink(20484))
									return "\n"..KUI:ColorStr(L["Example"])..": "..custom_message.."\n"
								end
							},
							channel = {
								order = 7,
								type = "group",
								name = L["Channel"],
								hidden = function(info) return not E.db.KlixUI.announcement.combat_spells.enable end,
								disabled = function(info) return not E.db.KlixUI.announcement.combat_spells.combat_resurrection.enable end,
								get = function(info) return E.db.KlixUI.announcement.combat_spells.combat_resurrection.channel[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.announcement.combat_spells.combat_resurrection.channel[ info[#info] ] = value end,
								args = {
									["solo"] = {
										order = 1,
										name = L["Solo"],
										type = "select",
										values = {
											["NONE"] = L["None"],
											["SELF"] = L["Self(Chat Frame)"],
											["EMOTE"] = L["Emote"],
											["YELL"] = L["Yell"],
											["SAY"] = L["Say"],
										},
									},
									["party"] = {
										order = 2,
										name = L["In party"],
										type = "select",
										values = {
											["NONE"] = L["None"],
											["SELF"] = L["Self(Chat Frame)"],
											["EMOTE"] = L["Emote"],
											["PARTY"] = L["Party"],
											["YELL"] = L["Yell"],
											["SAY"] = L["Say"],
										},
									},
									["instance"] = {
										order = 3,
										name = L["In instance"],
										type = "select",
										values = {
											["NONE"] = L["None"],
											["SELF"] = L["Self(Chat Frame)"],
											["EMOTE"] = L["Emote"],
											["PARTY"] = L["Party"],
											["INSTANCE_CHAT"] = L["Instance"],
											["YELL"] = L["Yell"],
											["SAY"] = L["Say"],
										},
									},
									["raid"] = {
										order = 4,
										name = L["In raid"],
										type = "select",
										values = {
											["NONE"] = L["None"],
											["SELF"] = L["Self(Chat Frame)"],
											["EMOTE"] = L["Emote"],
											["PARTY"] = L["Party"],
											["RAID"] = L["Raid"],
											["YELL"] = L["Yell"],
											["SAY"] = L["Say"],
										},
									},
								}
							},
						}
					},
					threat_transfer = {
						order = 11,
						type = "group",
						name = L["Threat transfer"],
						hidden = function(info)
							return not E.db.KlixUI.announcement.combat_spells.enable
						end,
						get = function(info)
							return E.db.KlixUI.announcement.combat_spells.threat_transfer[ info[#info] ]
						end,
						set = function(info, value)
							E.db.KlixUI.announcement.combat_spells.threat_transfer[ info[#info] ] = value
						end,
						func = function(info)
							E.db.KlixUI.announcement.combat_spells.threat_transfer.text = P.KlixUI.announcement.combat_spells.threat_transfer.text
						end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
							},
							use_raid_warning = {
								order = 2,
								type = "toggle",
								name = L["Use raid warning"],
								desc = L["Use raid warning when you is raid leader or assistant."],
								hidden = function(info)
									return E.db.KlixUI.announcement.combat_spells.threat_transfer.channel.raid ~= "RAID"
								end,
								disabled = function(info)
									return not E.db.KlixUI.announcement.combat_spells.threat_transfer.enable
								end,
							},
							player_cast = {
								order = 3,
								type = "toggle",
								name = L["Only I casted"],
								desc = L["If you do not check this, the spell casted by other players will be announced."],
								disabled = function(info)
									return not E.db.KlixUI.announcement.combat_spells.threat_transfer.enable
								end,
							},
							target_is_me = {
								order = 4,
								type = "toggle",
								name = L["Target is me"],
								disabled = function(info)
									return not E.db.KlixUI.announcement.combat_spells.threat_transfer.enable
								end,
							},
							only_target_is_not_tank = {
								order = 5,
								type = "toggle",
								name = L["Only target is not tank"],
								disabled = function(info)
									return not E.db.KlixUI.announcement.combat_spells.threat_transfer.enable
								end,
							},
							default_text = {
								order = 6,
								type = "execute",
								name = L["Use default text"],
								buttonElvUI = true,
								disabled = function(info)
									return not E.db.KlixUI.announcement.combat_spells.threat_transfer.enable
								end,
							},
							text = {
								order = 7,
								type = "input",
								width = 'full',
								name = L["Text"],
								desc = FormatDesc("%player%", L["Name of the player"]).."\n"..FormatDesc("%target%", L["Target name"]).."\n"..FormatDesc("%spell%", L["The spell link"]),
								disabled = function(info)
									return not E.db.KlixUI.announcement.combat_spells.threat_transfer.enable
								end,
							},
							text_example = {
								order = 8,
								type = "description",
								hidden = function(info) return not E.db.KlixUI.announcement.combat_spells.threat_transfer.enable end,
								name = function(info)
									local custom_message = E.db.KlixUI.announcement.combat_spells.threat_transfer.text
									custom_message = T.string_gsub(custom_message, "%%player%%", L["Sylvanas"])
									custom_message = T.string_gsub(custom_message, "%%target%%", T.UnitName("player"))
									custom_message = T.string_gsub(custom_message, "%%spell%%", T.GetSpellLink(34477))
									return "\n"..KUI:ColorStr(L["Example"])..": "..custom_message.."\n"
								end
							},
							channel = {
								order = 9,
								type = "group",
								name = L["Channel"],
								hidden = function(info) return not E.db.KlixUI.announcement.combat_spells.enable end,
								disabled = function(info)
									return not E.db.KlixUI.announcement.combat_spells.threat_transfer.enable
								end,
								get = function(info) return E.db.KlixUI.announcement.combat_spells.threat_transfer.channel[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.announcement.combat_spells.threat_transfer.channel[ info[#info] ] = value end,
								args = {
									["solo"] = {
										order = 1,
										name = L["Solo"],
										type = "select",
										values = {
											["NONE"] = L["None"],
											["SELF"] = L["Self(Chat Frame)"],
											["EMOTE"] = L["Emote"],
											["YELL"] = L["Yell"],
											["SAY"] = L["Say"],
										},
									},
									["party"] = {
										order = 2,
										name = L["In party"],
										type = "select",
										values = {
											["NONE"] = L["None"],
											["SELF"] = L["Self(Chat Frame)"],
											["EMOTE"] = L["Emote"],
											["PARTY"] = L["Party"],
											["YELL"] = L["Yell"],
											["SAY"] = L["Say"],
										},
									},
									["instance"] = {
										order = 3,
										name = L["In instance"],
										type = "select",
										values = {
											["NONE"] = L["None"],
											["SELF"] = L["Self(Chat Frame)"],
											["EMOTE"] = L["Emote"],
											["PARTY"] = L["Party"],
											["INSTANCE_CHAT"] = L["Instance"],
											["YELL"] = L["Yell"],
											["SAY"] = L["Say"],
										},
									},
									["raid"] = {
										order = 4,
										name = L["In raid"],
										type = "select",
										values = {
											["NONE"] = L["None"],
											["SELF"] = L["Self(Chat Frame)"],
											["EMOTE"] = L["Emote"],
											["PARTY"] = L["Party"],
											["RAID"] = L["Raid"],
											["YELL"] = L["Yell"],
											["SAY"] = L["Say"],
										},
									},
								}
							},
						}
					},
				},
			},
			taunt_spells = {
				order = 8,
				type = "group",
				name = L["Taunt spells"],
				disabled = function(info) return not E.db.KlixUI.announcement.enable end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						get = function(info) return E.db.KlixUI.announcement.taunt_spells.enable end,
						set = function(info, value) E.db.KlixUI.announcement.taunt_spells.enable = value end,
					},
					player = {
						order = 2,
						type = "group",
						name = L["Player(Only you)"],
						hidden = function(info)
							return not E.db.KlixUI.announcement.taunt_spells.enable
						end,
						disabled = function(info)
							return not E.db.KlixUI.announcement.taunt_spells.enable
						end,
						args = {
							player = {
								order = 1,
								type = "group",
								name = L["Player"],
								get = function(info)
									return E.db.KlixUI.announcement.taunt_spells.player.player[ info[#info] ]
								end,
								set = function(info, value)
									E.db.KlixUI.announcement.taunt_spells.player.player[ info[#info] ] = value
								end,
								args = {
									enable = {
										order = 1,
										type = "toggle",
										name = L["Enable"],
									},
									default_sucess_text = {
										order = 2,
										type = "execute",
										name = L["Use default text"].."-"..L["Success"],
										buttonElvUI = true,
										disabled = function(info) return not E.db.KlixUI.announcement.taunt_spells.player.player.enable end,
										func = function(info)
											E.db.KlixUI.announcement.taunt_spells.player.player.success_text = P.KlixUI.announcement.taunt_spells.player.player.success_text
										end,
									},
									default_failed_text = {
										order = 3,
										type = "execute",
										name = L["Use default text"].."-"..L["Failed"],
										buttonElvUI = true,
										disabled = function(info) return not E.db.KlixUI.announcement.taunt_spells.player.player.enable end,
										func = function(info)
											E.db.KlixUI.announcement.taunt_spells.player.player.failed_text = P.KlixUI.announcement.taunt_spells.player.player.failed_text
										end,
									},
									success_text = {
										order = 4,
										type = "input",
										width = 'full',
										name = L["Text"].." - "..L["Success"],
										desc = FormatDesc("%player%", L["Your name"]).."\n"..FormatDesc("%target%", L["Target name"]).."\n"..FormatDesc("%spell%", L["Your spell link"]),
										disabled = function(info) return not E.db.KlixUI.announcement.taunt_spells.player.player.enable end,
									},
									success_text_example = {
										order = 5,
										type = "description",
										hidden = function(info) return not E.db.KlixUI.announcement.taunt_spells.player.player.enable end,
										name = function(info)
											local custom_message = E.db.KlixUI.announcement.taunt_spells.player.player.success_text
											custom_message = T.string_gsub(custom_message, "%%player%%", T.UnitName("player") )
											custom_message = T.string_gsub(custom_message, "%%target%%", L["Sylvanas"])
											custom_message = T.string_gsub(custom_message, "%%spell%%", T.GetSpellLink(20484))
											return "\n"..KUI:ColorStr(L["Example"])..": "..custom_message.."\n"
										end
									},
									provoke_all_text = {
										order = 6,
										type = "input",
										width = 'full',
										name = L["Text"].." - "..L["Provoke all(Monk)"],
										desc = FormatDesc("%player%", L["Your name"]).."\n"..FormatDesc("%spell%", L["Your spell link"]),
										disabled = function(info) return not E.db.KlixUI.announcement.taunt_spells.player.player.enable end,
									},
									provoke_all_text_example = {
										order = 7,
										type = "description",
										hidden = function(info) return not E.db.KlixUI.announcement.taunt_spells.player.player.enable end,
										name = function(info)
											local custom_message = E.db.KlixUI.announcement.taunt_spells.player.player.provoke_all_text
											custom_message = T.string_gsub(custom_message, "%%player%%", T.UnitName("player") )
											custom_message = T.string_gsub(custom_message, "%%target%%", L["Sylvanas"])
											custom_message = T.string_gsub(custom_message, "%%spell%%", T.GetSpellLink(20484))
											return "\n"..KUI:ColorStr(L["Example"])..": "..custom_message.."\n"
										end
									},
									failed_text = {
										order = 8,
										type = "input",
										width = 'full',
										name = L["Text"].." - "..L["Failed"],
										desc = FormatDesc("%player%", L["Your name"]).."\n"..FormatDesc("%target%", L["Target name"]).."\n"..FormatDesc("%spell%", L["Your spell link"]),
										disabled = function(info) return not E.db.KlixUI.announcement.taunt_spells.player.player.enable end,
									},
									failed_text_example = {
										order = 9,
										type = "description",
										hidden = function(info) return not E.db.KlixUI.announcement.taunt_spells.player.player.enable end,
										name = function(info)
											local custom_message = E.db.KlixUI.announcement.taunt_spells.player.player.failed_text
											custom_message = T.string_gsub(custom_message, "%%player%%", T.UnitName("player") )
											custom_message = T.string_gsub(custom_message, "%%target%%", L["Sylvanas"])
											custom_message = T.string_gsub(custom_message, "%%spell%%", T.GetSpellLink(20484))
											return "\n"..KUI:ColorStr(L["Example"])..": "..custom_message.."\n"
										end
									},
									success_channel = {
										order = 10,
										type = "group",
										name = L["Channel"].." - "..L["Success"],
										disabled = function(info) return not E.db.KlixUI.announcement.taunt_spells.player.player.enable end,
										get = function(info) return E.db.KlixUI.announcement.taunt_spells.player.player.success_channel[ info[#info] ] end,
										set = function(info, value) E.db.KlixUI.announcement.taunt_spells.player.player.success_channel[ info[#info] ] = value end,
										args = {
											["solo"] = {
												order = 1,
												name = L["Solo"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
											["party"] = {
												order = 2,
												name = L["In party"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["PARTY"] = L["Party"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
											["instance"] = {
												order = 3,
												name = L["In instance"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["PARTY"] = L["Party"],
													["INSTANCE_CHAT"] = L["Instance"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
											["raid"] = {
												order = 4,
												name = L["In raid"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["PARTY"] = L["Party"],
													["RAID"] = L["Raid"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
										},
									},
									failed_channel = {
										order = 11,
										type = "group",
										name = L["Channel"].." - "..L["Failed"],
										disabled = function(info) return not E.db.KlixUI.announcement.taunt_spells.player.player.enable end,
										get = function(info) return E.db.KlixUI.announcement.taunt_spells.player.player.failed_channel[ info[#info] ] end,
										set = function(info, value) E.db.KlixUI.announcement.taunt_spells.player.player.failed_channel[ info[#info] ] = value end,
										args = {
											["solo"] = {
												order = 1,
												name = L["Solo"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
											["party"] = {
												order = 2,
												name = L["In party"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["PARTY"] = L["Party"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
											["instance"] = {
												order = 3,
												name = L["In instance"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["PARTY"] = L["Party"],
													["INSTANCE_CHAT"] = L["Instance"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
											["raid"] = {
												order = 4,
												name = L["In raid"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["PARTY"] = L["Party"],
													["RAID"] = L["Raid"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
										},
									},
								},
							},
							pet = {
								order = 2,
								name = L["Pet"],
								type = "group",
								get = function(info)
									return E.db.KlixUI.announcement.taunt_spells.player.pet[ info[#info] ]
								end,
								set = function(info, value)
									E.db.KlixUI.announcement.taunt_spells.player.pet[ info[#info] ] = value
								end,
								args = {
									enable = {
										order = 1,
										type = "toggle",
										name = L["Enable"],
									},
									default_sucess_text = {
										order = 2,
										type = "execute",
										name = L["Use default text"].."-"..L["Success"],
										buttonElvUI = true,
										disabled = function(info) return not E.db.KlixUI.announcement.taunt_spells.player.pet.enable end,
										func = function(info)
											E.db.KlixUI.announcement.taunt_spells.player.pet.success_text = P.KlixUI.announcement.taunt_spells.player.pet.success_text
										end,
									},
									default_failed_text = {
										order = 3,
										type = "execute",
										buttonElvUI = true,
										disabled = function(info) return not E.db.KlixUI.announcement.taunt_spells.player.pet.enable end,
										func = function(info)
											E.db.KlixUI.announcement.taunt_spells.player.pet.failed_text = P.KlixUI.announcement.taunt_spells.player.pet.failed_text
										end,
										name = L["Use default text"].."-"..L["Failed"],
									},
									success_text = {
										order = 4,
										type = "input",
										width = 'full',
										name = L["Text"].." - "..L["Success"],
										desc = FormatDesc("%player%",  L["Your name"]).."\n"..FormatDesc("%pet%", L["Pet name"]).."\n"..FormatDesc("%pet_role%", L["Pet role"]).."\n"..FormatDesc("%target%", L["Target name"]).."\n"..FormatDesc("%spell%", L["The spell link"]),
										disabled = function(info) return not E.db.KlixUI.announcement.taunt_spells.player.pet.enable end,
									},
									success_text_example = {
										order = 5,
										type = "description",
										hidden = function(info) return not E.db.KlixUI.announcement.taunt_spells.player.pet.enable end,
										name = function(info)
											local custom_message = E.db.KlixUI.announcement.taunt_spells.player.pet.success_text
											custom_message = T.string_gsub(custom_message, "%%player%%", T.UnitName("player"))
											custom_message = T.string_gsub(custom_message, "%%pet%%", L["Niuzao"])
											custom_message = T.string_gsub(custom_message, "%%pet_role%%", L["Totem"])
											custom_message = T.string_gsub(custom_message, "%%target%%", L["Sylvanas"])
											custom_message = T.string_gsub(custom_message, "%%spell%%", T.GetSpellLink(20484))
											return "\n"..KUI:ColorStr(L["Example"])..": "..custom_message.."\n"
										end
									},
									failed_text = {
										order = 6,
										type = "input",
										width = 'full',
										name = L["Text"].." - "..L["Failed"],
										desc = FormatDesc("%player%",  L["Your name"]).."\n"..FormatDesc("%pet%", L["Pet name"]).."\n"..FormatDesc("%pet_role%", L["Pet role"]).."\n"..FormatDesc("%target%", L["Target name"]).."\n"..FormatDesc("%spell%", L["The spell link"]),
										disabled = function(info) return not E.db.KlixUI.announcement.taunt_spells.player.pet.enable end,
									},
									failed_text_example = {
										order = 7,
										type = "description",
										hidden = function(info) return not E.db.KlixUI.announcement.taunt_spells.player.pet.enable end,
										name = function(info)
											local custom_message = E.db.KlixUI.announcement.taunt_spells.player.pet.failed_text
											custom_message = T.string_gsub(custom_message, "%%player%%", T.UnitName("player"))
											custom_message = T.string_gsub(custom_message, "%%pet%%", L["Niuzao"])
											custom_message = T.string_gsub(custom_message, "%%pet_role%%", L["Totem"])
											custom_message = T.string_gsub(custom_message, "%%target%%", L["Sylvanas"])
											custom_message = T.string_gsub(custom_message, "%%spell%%", T.GetSpellLink(20484))
											return "\n"..KUI:ColorStr(L["Example"])..": "..custom_message.."\n"
										end
									},
									success_channel = {
										order = 8,
										type = "group",
										name = L["Channel"].." - "..L["Success"],
										disabled = function(info) return not E.db.KlixUI.announcement.taunt_spells.player.pet.enable end,
										get = function(info) return E.db.KlixUI.announcement.taunt_spells.player.pet.success_channel[ info[#info] ] end,
										set = function(info, value) E.db.KlixUI.announcement.taunt_spells.player.pet.success_channel[ info[#info] ] = value end,
										args = {
											["solo"] = {
												order = 1,
												name = L["Solo"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
											["party"] = {
												order = 2,
												name = L["In party"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["PARTY"] = L["Party"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
											["instance"] = {
												order = 3,
												name = L["In instance"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["PARTY"] = L["Party"],
													["INSTANCE_CHAT"] = L["Instance"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
											["raid"] = {
												order = 4,
												name = L["In raid"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["PARTY"] = L["Party"],
													["RAID"] = L["Raid"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
										},
									},
									failed_channel = {
										order = 9,
										type = "group",
										name = L["Channel"].." - "..L["Failed"],
										disabled = function(info) return not E.db.KlixUI.announcement.taunt_spells.player.pet.enable end,
										get = function(info) return E.db.KlixUI.announcement.taunt_spells.player.pet.failed_channel[ info[#info] ] end,
										set = function(info, value) E.db.KlixUI.announcement.taunt_spells.player.pet.failed_channel[ info[#info] ] = value end,
										args = {
											["solo"] = {
												order = 1,
												name = L["Solo"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
											["party"] = {
												order = 2,
												name = L["In party"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["PARTY"] = L["Party"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
											["instance"] = {
												order = 3,
												name = L["In instance"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["PARTY"] = L["Party"],
													["INSTANCE_CHAT"] = L["Instance"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
											["raid"] = {
												order = 4,
												name = L["In raid"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["PARTY"] = L["Party"],
													["RAID"] = L["Raid"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
										},
									},
								},
							},
						},
					},
					others = {
						order = 3,
						type = "group",
						name = L["Other players"],
						hidden = function(info)
							return not E.db.KlixUI.announcement.taunt_spells.enable
						end,
						disabled = function(info)
							return not E.db.KlixUI.announcement.taunt_spells.enable
						end,
						args = {
							player = {
								order = 1,
								type = "group",
								name = L["Player"],
								get = function(info)
									return E.db.KlixUI.announcement.taunt_spells.others.player[ info[#info] ]
								end,
								set = function(info, value)
									E.db.KlixUI.announcement.taunt_spells.others.player[ info[#info] ] = value
								end,
								args = {
									enable = {
										order = 1,
										type = "toggle",
										name = L["Enable"],
									},
									default_sucess_text = {
										order = 2,
										type = "execute",
										name = L["Use default text"].."-"..L["Success"],
										buttonElvUI = true,
										disabled = function(info) return not E.db.KlixUI.announcement.taunt_spells.others.player.enable end,
										func = function(info)
											E.db.KlixUI.announcement.taunt_spells.others.player.success_text = P.KlixUI.announcement.taunt_spells.others.player.success_text
										end,
									},
									default_failed_text = {
										order = 3,
										type = "execute",
										name = L["Use default text"].."-"..L["Failed"],
										buttonElvUI = true,
										disabled = function(info) return not E.db.KlixUI.announcement.taunt_spells.others.player.enable end,
										func = function(info)
											E.db.KlixUI.announcement.taunt_spells.others.player.failed_text = P.KlixUI.announcement.taunt_spells.others.player.failed_text
										end,
									},
									success_text = {
										order = 4,
										type = "input",
										width = 'full',
										name = L["Text"].." - "..L["Success"],
										desc = FormatDesc("%player%", L["Name of the player"]).."\n"..FormatDesc("%target%", L["Target name"]).."\n"..FormatDesc("%spell%", L["The spell link"]),
										disabled = function(info) return not E.db.KlixUI.announcement.taunt_spells.others.player.enable end,
									},
									success_text_example = {
										order = 5,
										type = "description",
										hidden = function(info) return not E.db.KlixUI.announcement.taunt_spells.others.player.enable end,
										name = function(info)
											local custom_message = E.db.KlixUI.announcement.taunt_spells.others.player.success_text
											custom_message = T.string_gsub(custom_message, "%%player%%", T.UnitName("player") )
											custom_message = T.string_gsub(custom_message, "%%target%%", L["Sylvanas"])
											custom_message = T.string_gsub(custom_message, "%%spell%%", T.GetSpellLink(20484))
											return "\n"..KUI:ColorStr(L["Example"])..": "..custom_message.."\n"
										end
									},
									provoke_all_text = {
										order = 6,
										type = "input",
										width = 'full',
										name = L["Text"].." - "..L["Provoke all(Monk)"],
										desc = FormatDesc("%player%", L["Your name"]).."\n"..FormatDesc("%spell%", L["Your spell link"]),
										disabled = function(info) return not E.db.KlixUI.announcement.taunt_spells.others.player.enable end,
									},
									provoke_all_text_example = {
										order = 7,
										type = "description",
										hidden = function(info) return not E.db.KlixUI.announcement.taunt_spells.others.player.enable end,
										name = function(info)
											local custom_message = E.db.KlixUI.announcement.taunt_spells.others.player.provoke_all_text
											custom_message = T.string_gsub(custom_message, "%%player%%", T.UnitName("player") )
											custom_message = T.string_gsub(custom_message, "%%target%%", L["Sylvanas"])
											custom_message = T.string_gsub(custom_message, "%%spell%%", T.GetSpellLink(20484))
											return "\n"..KUI:ColorStr(L["Example"])..": "..custom_message.."\n"
										end
									},
									failed_text = {
										order = 8,
										type = "input",
										width = 'full',
										name = L["Text"].." - "..L["Failed"],
										desc = FormatDesc("%player%", L["Name of the player"]).."\n"..FormatDesc("%target%", L["Target name"]).."\n"..FormatDesc("%spell%", L["The spell link"]),
										disabled = function(info) return not E.db.KlixUI.announcement.taunt_spells.others.player.enable end,
									},
									failed_text_example = {
										order = 9,
										type = "description",
										hidden = function(info) return not E.db.KlixUI.announcement.taunt_spells.others.player.enable end,
										name = function(info)
											local custom_message = E.db.KlixUI.announcement.taunt_spells.others.player.failed_text
											custom_message = T.string_gsub(custom_message, "%%player%%", T.UnitName("player") )
											custom_message = T.string_gsub(custom_message, "%%target%%", L["Sylvanas"])
											custom_message = T.string_gsub(custom_message, "%%spell%%", T.GetSpellLink(20484))
											return "\n"..KUI:ColorStr(L["Example"])..": "..custom_message.."\n"
										end
									},
									success_channel = {
										order = 10,
										type = "group",
										name = L["Channel"].." - "..L["Success"],
										disabled = function(info) return not E.db.KlixUI.announcement.taunt_spells.others.player.enable end,
										get = function(info) return E.db.KlixUI.announcement.taunt_spells.others.player.success_channel[ info[#info] ] end,
										set = function(info, value) E.db.KlixUI.announcement.taunt_spells.others.player.success_channel[ info[#info] ] = value end,
										args = {
											["solo"] = {
												order = 1,
												name = L["Solo"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
											["party"] = {
												order = 2,
												name = L["In party"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["PARTY"] = L["Party"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
											["instance"] = {
												order = 3,
												name = L["In instance"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["PARTY"] = L["Party"],
													["INSTANCE_CHAT"] = L["Instance"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
											["raid"] = {
												order = 4,
												name = L["In raid"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["PARTY"] = L["Party"],
													["RAID"] = L["Raid"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
										},
									},
									failed_channel = {
										order = 11,
										type = "group",
										name = L["Channel"].." - "..L["Failed"],
										disabled = function(info) return not E.db.KlixUI.announcement.taunt_spells.others.player.enable end,
										get = function(info) return E.db.KlixUI.announcement.taunt_spells.others.player.failed_channel[ info[#info] ] end,
										set = function(info, value) E.db.KlixUI.announcement.taunt_spells.others.player.failed_channel[ info[#info] ] = value end,
										args = {
											["solo"] = {
												order = 1,
												name = L["Solo"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
											["party"] = {
												order = 2,
												name = L["In party"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["PARTY"] = L["Party"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
											["instance"] = {
												order = 3,
												name = L["In instance"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["PARTY"] = L["Party"],
													["INSTANCE_CHAT"] = L["Instance"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
											["raid"] = {
												order = 4,
												name = L["In raid"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["PARTY"] = L["Party"],
													["RAID"] = L["Raid"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
										},
									},
								},
							},
							pet = {
								order = 2,
								type = "group",
								name = L["Other players\' pet"],
								get = function(info)
									return E.db.KlixUI.announcement.taunt_spells.others.pet[ info[#info] ]
								end,
								set = function(info, value)
									E.db.KlixUI.announcement.taunt_spells.others.pet[ info[#info] ] = value
								end,
								args = {
									enable = {
										order = 1,
										type = "toggle",
										name = L["Enable"],
									},
									default_sucess_text = {
										order = 2,
										type = "execute",
										name = L["Use default text"].."-"..L["Success"],
										buttonElvUI = true,
										disabled = function(info) return not E.db.KlixUI.announcement.taunt_spells.others.pet.enable end,
										func = function(info)
											E.db.KlixUI.announcement.taunt_spells.others.pet.success_text = P.KlixUI.announcement.taunt_spells.others.pet.success_text
										end,
									},
									default_failed_text = {
										order = 3,
										type = "execute",
										name = L["Use default text"].."-"..L["Failed"],
										buttonElvUI = true,
										disabled = function(info) return not E.db.KlixUI.announcement.taunt_spells.others.pet.enable end,
										func = function(info)
											E.db.KlixUI.announcement.taunt_spells.others.pet.failed_text = P.KlixUI.announcement.taunt_spells.others.pet.failed_text
										end,
									},
									success_text = {
										order = 4,
										type = "input",
										width = 'full',
										name = L["Text"].." - "..L["Success"],
										desc = FormatDesc("%player%",  L["Name of the player"]).."\n"..FormatDesc("%pet%", L["Pet name"]).."\n"..FormatDesc("%pet_role%", L["Pet role"]).."\n"..FormatDesc("%target%", L["Target name"]).."\n"..FormatDesc("%spell%", L["The spell link"]),
										disabled = function(info) return not E.db.KlixUI.announcement.taunt_spells.others.pet.enable end,
									},
									success_text_example = {
										order = 5,
										type = "description",
										hidden = function(info) return not E.db.KlixUI.announcement.taunt_spells.others.pet.enable end,
										name = function(info)
											local custom_message = E.db.KlixUI.announcement.taunt_spells.others.pet.success_text
											custom_message = T.string_gsub(custom_message, "%%player%%", T.UnitName("player"))
											custom_message = T.string_gsub(custom_message, "%%pet%%", L["Niuzao"])
											custom_message = T.string_gsub(custom_message, "%%pet_role%%", L["Totem"])
											custom_message = T.string_gsub(custom_message, "%%target%%", L["Sylvanas"])
											custom_message = T.string_gsub(custom_message, "%%spell%%", T.GetSpellLink(20484))
											return "\n"..KUI:ColorStr(L["Example"])..": "..custom_message.."\n"
										end
									},
									failed_text = {
										order = 6,
										type = "input",
										width = 'full',
										name = L["Text"].." - "..L["Failed"],
										desc = FormatDesc("%player%",  L["Name of the player"]).."\n"..FormatDesc("%pet%", L["Pet name"]).."\n"..FormatDesc("%pet_role%", L["Pet role"]).."\n"..FormatDesc("%target%", L["Target name"]).."\n"..FormatDesc("%spell%", L["The spell link"]),
										disabled = function(info) return not E.db.KlixUI.announcement.taunt_spells.others.pet.enable end,
									},
									failed_text_example = {
										order = 7,
										type = "description",
										hidden = function(info) return not E.db.KlixUI.announcement.taunt_spells.others.pet.enable end,
										name = function(info)
											local custom_message = E.db.KlixUI.announcement.taunt_spells.others.pet.failed_text
											custom_message = T.string_gsub(custom_message, "%%player%%", T.UnitName("player"))
											custom_message = T.string_gsub(custom_message, "%%pet%%", L["Niuzao"])
											custom_message = T.string_gsub(custom_message, "%%pet_role%%", L["Totem"])
											custom_message = T.string_gsub(custom_message, "%%target%%", L["Sylvanas"])
											custom_message = T.string_gsub(custom_message, "%%spell%%", T.GetSpellLink(20484))
											return "\n"..KUI:ColorStr(L["Example"])..": "..custom_message.."\n"
										end
									},
									success_channel = {
										order = 8,
										type = "group",
										name = L["Channel"].." - "..L["Success"],
										disabled = function(info) return not E.db.KlixUI.announcement.taunt_spells.others.pet.enable end,
										get = function(info) return E.db.KlixUI.announcement.taunt_spells.others.pet.success_channel[ info[#info] ] end,
										set = function(info, value) E.db.KlixUI.announcement.taunt_spells.others.pet.success_channel[ info[#info] ] = value end,
										args = {
											["solo"] = {
												order = 1,
												name = L["Solo"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
											["party"] = {
												order = 2,
												name = L["In party"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["PARTY"] = L["Party"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
											["instance"] = {
												order = 3,
												name = L["In instance"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["PARTY"] = L["Party"],
													["INSTANCE_CHAT"] = L["Instance"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
											["raid"] = {
												order = 4,
												name = L["In raid"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["PARTY"] = L["Party"],
													["RAID"] = L["Raid"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
										},
									},
									failed_channel = {
										order = 9,
										type = "group",
										name = L["Channel"].." - "..L["Failed"],
										disabled = function(info) return not E.db.KlixUI.announcement.taunt_spells.others.pet.enable end,
										get = function(info) return E.db.KlixUI.announcement.taunt_spells.others.pet.failed_channel[ info[#info] ] end,
										set = function(info, value) E.db.KlixUI.announcement.taunt_spells.others.pet.failed_channel[ info[#info] ] = value end,
										args = {
											["solo"] = {
												order = 1,
												name = L["Solo"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
											["party"] = {
												order = 2,
												name = L["In party"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["PARTY"] = L["Party"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
											["instance"] = {
												order = 3,
												name = L["In instance"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["PARTY"] = L["Party"],
													["INSTANCE_CHAT"] = L["Instance"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
											["raid"] = {
												order = 4,
												name = L["In raid"],
												type = "select",
												values = {
													["NONE"] = L["None"],
													["SELF"] = L["Self(Chat Frame)"],
													["EMOTE"] = L["Emote"],
													["PARTY"] = L["Party"],
													["RAID"] = L["Raid"],
													["YELL"] = L["Yell"],
													["SAY"] = L["Say"],
												},
											},
										},
									},
								},
							},
						},
					},
				},
			},
			thanks = {
				order = 9,
				type = "group",
				name = L["Say thanks"],
				disabled = function(info) return not E.db.KlixUI.announcement.enable end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						get = function(info) return E.db.KlixUI.announcement.thanks.enable end,
						set = function(info, value) E.db.KlixUI.announcement.thanks.enable = value end,
					},
					goodbye = {
						order = 2,
						type = "group",
						name = L["Goodbye"],
						disabled = function(info)
							return not E.db.KlixUI.announcement.thanks.enable
						end,
						get = function(info)
							return E.db.KlixUI.announcement.thanks.goodbye[ info[#info] ]
						end,
						set = function(info, value)
							E.db.KlixUI.announcement.thanks.goodbye[ info[#info] ] = value
						end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
							},
							default_text = {
								order = 2,
								type = "execute",
								name = L["Use default text"],
								buttonElvUI = true,
								disabled = function(info) return not E.db.KlixUI.announcement.thanks.goodbye.enable end,
								func = function(info)
									E.db.KlixUI.announcement.thanks.goodbye.text = P.KlixUI.announcement.thanks.goodbye.text
								end,
							},
							text = {
								order = 3,
								type = "input",
								width = 'full',
								name = L["Text"],
								disabled = function(info) return not E.db.KlixUI.announcement.thanks.goodbye.enable end,
							},
							channel = {
								order = 4,
								type = "group",
								name = L["Channel"],
								disabled = function(info) return not E.db.KlixUI.announcement.thanks.goodbye.enable end,
								get = function(info) return E.db.KlixUI.announcement.thanks.goodbye.channel[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.announcement.thanks.goodbye.channel[ info[#info] ] = value end,
								args = {
									["party"] = {
										order = 1,
										name = L["In party"],
										type = "select",
										values = {
											["NONE"] = L["None"],
											["EMOTE"] = L["Emote"],
											["PARTY"] = L["Party"],
											["YELL"] = L["Yell"],
											["SAY"] = L["Say"],
										},
									},
									["instance"] = {
										order = 2,
										name = L["In instance"],
										type = "select",
										values = {
											["NONE"] = L["None"],
											["EMOTE"] = L["Emote"],
											["PARTY"] = L["Party"],
											["INSTANCE_CHAT"] = L["Instance"],
											["YELL"] = L["Yell"],
											["SAY"] = L["Say"],
										},
									},
									["raid"] = {
										order = 3,
										name = L["In raid"],
										type = "select",
										values = {
											["NONE"] = L["None"],
											["EMOTE"] = L["Emote"],
											["PARTY"] = L["Party"],
											["RAID"] = L["Raid"],
											["YELL"] = L["Yell"],
											["SAY"] = L["Say"],
										},
									},
								},
							},
						},
					},
					resurrection = {
						order = 3,
						type = "group",
						name = L["Resurrection"],
						disabled = function(info)
							return not E.db.KlixUI.announcement.thanks.enable
						end,
						get = function(info)
							return E.db.KlixUI.announcement.thanks.resurrection[ info[#info] ]
						end,
						set = function(info, value)
							E.db.KlixUI.announcement.thanks.resurrection[ info[#info] ] = value
						end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
							},
							default_text = {
								order = 2,
								type = "execute",
								name = L["Use default text"],
								buttonElvUI = true,
								disabled = function(info) return not E.db.KlixUI.announcement.thanks.resurrection.enable end,
								func = function(info)
									E.db.KlixUI.announcement.thanks.resurrection.text = P.KlixUI.announcement.thanks.resurrection.text
								end,
							},
							text = {
								order = 3,
								type = "input",
								width = 'full',
								name = L["Text"],
								desc = FormatDesc("%player%", L["Your name"]).."\n"..FormatDesc("%target%", L["Target name"]).."\n"..FormatDesc("%spell%", L["The spell link"]),
								disabled = function(info) return not E.db.KlixUI.announcement.thanks.resurrection.enable end,
							},
							example = {
								order = 4,
								type = "description",
								hidden = function(info) return not E.db.KlixUI.announcement.thanks.resurrection.enable end,
								name = function(info)
									local custom_message = E.db.KlixUI.announcement.thanks.resurrection.text
									custom_message = T.string_gsub(custom_message, "%%player%%", T.UnitName("player"))
									custom_message = T.string_gsub(custom_message, "%%target%%", L["Sylvanas"])
									custom_message = T.string_gsub(custom_message, "%%spell%%", T.GetSpellLink(61999))
									return "\n"..KUI:ColorStr(L["Example"])..": "..custom_message.."\n"
								end
							},
							channel = {
								order = 5,
								type = "group",
								name = L["Channel"],
								disabled = function(info) return not E.db.KlixUI.announcement.thanks.resurrection.enable end,
								get = function(info) return E.db.KlixUI.announcement.thanks.resurrection.channel[ info[#info] ] end,
								set = function(info, value) E.db.KlixUI.announcement.thanks.resurrection.channel[ info[#info] ] = value end,
								args = {
									["solo"] = {
										order = 1,
										name = L["Solo"],
										type = "select",
										values = {
											["NONE"] = L["None"],
											["WHISPER"] = L["Whisper"],
											["SELF"] = L["Self(Chat Frame)"],
											["EMOTE"] = L["Emote"],
											["YELL"] = L["Yell"],
											["SAY"] = L["Say"],
										},
									},
									["party"] = {
										order = 2,
										name = L["In party"],
										type = "select",
										values = {
											["NONE"] = L["None"],
											["WHISPER"] = L["Whisper"],
											["SELF"] = L["Self(Chat Frame)"],
											["EMOTE"] = L["Emote"],
											["PARTY"] = L["Party"],
											["YELL"] = L["Yell"],
											["SAY"] = L["Say"],
										},
									},
									["instance"] = {
										order = 3,
										name = L["In instance"],
										type = "select",
										values = {
											["NONE"] = L["None"],
											["WHISPER"] = L["Whisper"],
											["SELF"] = L["Self(Chat Frame)"],
											["EMOTE"] = L["Emote"],
											["PARTY"] = L["Party"],
											["INSTANCE_CHAT"] = L["Instance"],
											["YELL"] = L["Yell"],
											["SAY"] = L["Say"],
										},
									},
									["raid"] = {
										order = 4,
										name = L["In raid"],
										type = "select",
										values = {
											["NONE"] = L["None"],
											["WHISPER"] = L["Whisper"],
											["SELF"] = L["Self(Chat Frame)"],
											["EMOTE"] = L["Emote"],
											["PARTY"] = L["Party"],
											["RAID"] = L["Raid"],
											["YELL"] = L["Yell"],
											["SAY"] = L["Say"],
										},
									},
								},
							},
						},
					},
				},	
			},
		},
	}
end
T.table_insert(KUI.Config, AnnouncementSystemTable)