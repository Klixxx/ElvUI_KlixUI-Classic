local KUI, T, E, L, V, P, G = unpack(select(2, ...))

if E.db.KlixUI == nil then E.db.KlixUI = {} end

--This function holds the options table which will be inserted into the ElvUI config
local function Core()
	local name = "|cfffe7b2cElvUI|r"..T.string_format(": |cff99ff33%s|r",E.version).." + |cfff960d9KlixUI|r"..T.string_format(": |cff99ff33%s|r", KUI.Version)
	E.Options.args.ElvUI_Header.name = name;
	local ACD = LibStub("AceConfigDialog-3.0-ElvUI")
	
	local function CreateButton(number, text, ...)
		local path = {}
		local num = T.select("#", ...)
		for i = 1, num do
			local name = T.select(i, ...)
			T.table_insert(path, #(path)+1, name)
		end
		local config = {
			order = number,
			type = 'execute',
			name = text,
			func = function() ACD:SelectGroup("ElvUI", "KlixUI", T.unpack(path)) end,
		}
		return config
	end
	
	local function CreateQuestion(i, text)
		local question = {
			type = 'group', name = '', order = i, guiInline = true,
			args = {
				q = { order = 1, type = 'description', fontSize = 'medium', name = text },
			},
		}
		return question
	end
	
	E.Options.args.KlixUI = {
		order = 216,
		type = 'group',
		name = KUI.Title,
		desc = L["A plugin for |cfffe7b2cElvUI|r by Klix (EU-Twisting Nether)"],
		args = {
			name = {
				order = 1,
				type = 'header',
				name = KUI.Title..L['v']..KUI:cOption(KUI.Version)..L['by Klix (EU-Twisting Nether)'],
			},
			logo = {
				order = 2,
				type = 'description',
				name = L["KUI_DESC"]..E.NewSign,
				fontSize = 'medium',
				image = function() return 'Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\KlixUILogo.tga', 155, 150 end,
			},
			install = {
				order = 3,
				type = 'execute',
				name = L['Install'],
				desc = L['Run the installation process.'],
				func = function() E:GetModule('PluginInstaller'):Queue(KUI.installTable); E:ToggleOptionsUI(); end,
			},
			reloadui = {
				order = 4,
				type = "execute",
				name = L["Reload"],
				desc = L['Reaload the UI'],
				func = function() T.ReloadUI() end,
			},
			changelog = {
				order = 5,
				type = "execute",
				name = L["Changelog"],
				desc = L['Open the changelog window.'],
				func = function() KUI:ToggleChangeLog(); E:ToggleOptionsUI() end,
			},
			modulesButton = CreateButton(6, L["Modules"], "modules"),
			mediaButtonKlix = {
				order = 7,
				type = "execute",
				name = L["Media"],
				func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "KlixUI", "media") end,
				disabled = function() return T.IsAddOnLoaded("ElvUI_SLE") end,
				hidden = function() return T.IsAddOnLoaded("ElvUI_SLE") end,
			},
			mediaButtonSLE = {
				order = 7,
				type = "execute",
				name = L["Media"],
				func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "sle", "media") end,
				disabled = function() return not T.IsAddOnLoaded("ElvUI_SLE") end,
				hidden = function() return not T.IsAddOnLoaded("ElvUI_SLE") end,
			},
			skinsButton = CreateButton(8, L["Skins & AddOns"], "skins"),
			discordButton = {
				order = 9,
				type = "execute",
				name = L["|cfff960d9KlixUI|r Discord"],
				func = function() E:StaticPopup_Show("KLIXUI_CREDITS", nil, nil, "https://discord.gg/GbQbDRX") end,
			},
			authorButton = {
				order = 10,
				type = "execute",
				name = L["Contact Author"],
				func = function() E:StaticPopup_Show("KLIXUI_CREDITS", nil, nil, "Klix#1645") end,
			},
			spacer2 = {
				order = 11,
				type = 'header',
				name = '',
			},
			general = {
				order = 15,
				type = 'group',
				name = KUI:cOption(L['General']),
				guiInline = true,
				get = function(info) return E.db.KlixUI.general[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.general[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
				args = {
					AFK = {
						order = 1,
						type = "toggle",
						name = L["AFK Screen"],
						desc = L["Enable/Disable the |cfff960d9KlixUI|r AFK Screen.\nCredit: |cff00c0faBenikUI|r"],
					},
					AFKChat = {
						order = 2,
						type = "toggle",
						name = L["AFK Screen Chat"],
						desc = L["Show the chat when entering AFK screen."],
						disabled = function() return not E.db.KlixUI.general.AFK end,
					},
					GameMenuScreen = {
						order = 3,
						type = "toggle",
						name = L["Game Menu Screen"],
						desc = L["Enable/Disable the |cfff960d9KlixUI|r Game Menu Screen.\nCredit: |cffff7d0aMerathilisUI|r"],
					},
					splashScreen = {
						order = 4,
						type = 'toggle',
						name = L['Splash Screen'],
						desc = L["Enable/Disable the |cfff960d9KlixUI|r Splash Screen.\nCredit: |cff00c0faBenikUI|r"],
					},
					loginMessage = {
						order = 5,
						type = 'toggle',
						name = L['Login Message'],
						desc = L["Enable/Disable the Login Message in Chat."],
					},
					GameMenuButton = {
						order = 6,
						type = "toggle",
						name = L["Game Menu Button"],
						desc = L["Show/Hide the |cfff960d9KlixUI|r Game Menu button"],
					},
					minimap = {
						order = 7,
						type = "toggle",
						name = L["Minimap Button"],
						desc = L["Show/Hide the |cfff960d9KlixUI|r minimap button."],
						get = function() return not E.db.KlixUI.general.minimap.hide end,
						set = function(info, value)
							E.db.KlixUI.general.minimap.hide = not value
							if value then
								LibStub("LibDBIcon-1.0"):Show(KUI.Title)
							else
								LibStub("LibDBIcon-1.0"):Hide(KUI.Title)
							end
						end,
					},
				},
			},
			tweaks = {
				order = 20,
				type = 'group',
				name = KUI:cOption(L['Tweaks']),
				guiInline = true,
				args = {
					speedyLoot = {
						order = 1,
						type = "toggle",
						name = L["Speedy Loot"],
						desc = L["Enable/Disable faster corpse looting."],
						get = function(info) return E.global.KlixUI.speedyLoot end,
						set = function(info, value) E.global.KlixUI.speedyLoot = value; E:StaticPopup_Show("GLOBAL_RL") end,
					},
					easyDelete = {
						order = 2,
						type = "toggle",
						name = L["Easy Delete"],
						desc = L['Enable/Disable the ability to delete an item without the need of typing: "delete".'],
						get = function(info) return E.global.KlixUI.easyDelete end,
						set = function(info, value) E.global.KlixUI.easyDelete = value; E:StaticPopup_Show("GLOBAL_RL") end,
					},
					cinematic = {
						order = 10,
						type = "group",
						name = KUI:cOption(L["Cinematic"]),
						guiInline = true,
						get = function(info) return E.global.KlixUI.cinematic[ info[#info] ] end,
						set = function(info, value) E.global.KlixUI.cinematic[ info[#info] ] = value; E:StaticPopup_Show("GLOBAL_RL") end,
						args = {
							kill = {
								order = 1,
								type = "toggle",
								name = L["Skip Cut Scenes"],
								desc = L["Enable/Disable cut scenes."],
							},
							enableSound = {
								order = 2,
								type = "toggle",
								name = L["Cut Scenes Sound"],
								desc = L["Enable/Disable sounds when a cut scene pops.\n|cffff8000Note: This will only enable if you have your sound disabled.|r"],
								disabled = function() return E.global.KlixUI.cinematic.kill end,
							},
						},
					},
				},
			},
			modules = {
				order = 20,
				type = "group",
				childGroups = "select",
				name = L["Modules"],
				args = {
					info = {
						type = "description",
						order = 1,
						name = L["Here you find the options for all the different |cfff960d9KlixUI|r modules.\nPlease use the dropdown to navigate through the modules."],
					},
				},
			},
			info = {
				order = 2000,
				type = 'group',
				name = L["Information"],
				childGroups = 'tab',
				args = {
					name = {
						order = 1,
						type = "header",
						name = KUI:cOption(L["Information"]),
					},
					about = {
						type = 'group', name = L["About"], order = 2,
						args = {
							content = { order = 1, type = 'description', fontSize = 'medium', name = L["KUI_DESC"]..E.NewSign },
						},
					},
					faq = {
						type = 'group',
						name = 'FAQ',
						order = 5,
						childGroups = "select",
						args = {
							desc = {
								order = 1,
								type = 'description',
								fontSize = 'medium',
								name = L["FAQ_DESC"],
							},
							elvui = {
								type = 'group', order = 1, name = "ElvUI",
								args = {
									q1 = CreateQuestion(1, L["FAQ_ELV_1"]),
									q2 = CreateQuestion(2, L["FAQ_ELV_2"]),
									q3 = CreateQuestion(3, L["FAQ_ELV_3"]),
									q4 = CreateQuestion(4, L["FAQ_ELV_4"]),
									q5 = CreateQuestion(5, L["FAQ_ELV_5"]),
									q6 = CreateQuestion(5, L["FAQ_ELV_6"]),
								},
							},
							klixui = {
								type = 'group', order = 2, name = "KlixUI",
								args = {
									q1 = CreateQuestion(1, L["FAQ_KUI_1"]),
									q2 = CreateQuestion(2, L["FAQ_KUI_2"]),
									q3 = CreateQuestion(3, L["FAQ_KUI_3"]),
									q4 = CreateQuestion(4, L["FAQ_KUI_4"]),
								},
							},
						},
					},
					links = {
						type = 'group',
						name = L["Links"],
						order = 10,
						args = {
							desc = {
								order = 1, type = 'description', fontSize = 'medium', name = L["LINK_DESC"]
							},
							kuidiscord = {
								order = 2, type = 'input', width = 'full', name = 'Discord Server',
								get = function(info) return 'https://discord.gg/GbQbDRX' end,
							},
							tukuilink = {
								order = 3, type = 'input', width = 'full', name = 'Tukui.org',
								get = function(info) return 'https://www.tukui.org/addons.php?id=89' end,
							},
							curselink= {
								order = 5, type = 'input', width = 'full', name = 'Curseforge.com',
								get = function(info) return 'https://www.curseforge.com/wow/addons/elvui_klixui-2-0' end,
							},
							gitlablink = {
								order = 6, type = 'input', width = 'full', name = L["Git Ticket Tracker"],
								get = function(info) return 'https://git.tukui.org/Klix/KlixUI/issues' end,
							},
							development = {
								order = 6, type = 'input', width = 'full', name = L["Development Version"],
								get = function(info) return 'https://git.tukui.org/Klix/KlixUI/repository/archive.zip?ref=development' end,
							},
							space1 = {
								order = 9,
								type = 'description',
								name = '',
							},
							addons = {
								order = 10,
								type = "group",
								name = L["My other Addons"],
								guiInline = true,
								args = {
									sfui = {
										order = 1,
										type = "execute",
										name = L["|cfffb4f4fSkullflowers UI C.A|r"],
										desc = L["A continuation of the popular and highly demanded Skullflower UI."],
										func = function() E:StaticPopup_Show("KLIXUI_CREDITS", nil, nil, "https://www.tukui.org/addons.php?id=63") end,
									},
									sfuitp = {
										order = 2,
										type = "execute",
										name = L["|cfffb4f4fSkullflowers UI Texture Pack|r"],
										desc = L["Texture pack for all the Skullflower textures."],
										func = function() E:StaticPopup_Show("KLIXUI_CREDITS", nil, nil, "https://www.tukui.org/addons.php?id=97") end,
									},
									fow = {
										order = 3,
										type = "execute",
										name = L["ElvUI Fog Remover"],
										desc = L["Removes the fog from the World map, thus displaying the artwork for all the undiscovered zones, optionally with a color overlay on undiscovered areas."],
										func = function() E:StaticPopup_Show("KLIXUI_CREDITS", nil, nil, "https://www.tukui.org/addons.php?id=116") end,
									},
									ctc = {
										order = 4,
										type = "execute",
										name = L["ElvUI Chat Tweaks Continued"],
										desc = L["Chat Tweaks adds various enhancements to the default ElvUI chat."],
										func = function() E:StaticPopup_Show("KLIXUI_CREDITS", nil, nil, "https://www.tukui.org/addons.php?id=118") end,
									},
									curr = {
										order = 5,
										type = "execute",
										name = L["ElvUI Enhanced Currency"],
										desc = L["A simple yet enhanced currency datatext."],
										func = function() E:StaticPopup_Show("KLIXUI_CREDITS", nil, nil, "https://www.tukui.org/addons.php?id=125") end,
									},
									cp = {
										order = 6,
										type = "execute",
										name = L["ElvUI Compass Points"],
										desc = L["Adds cardinal points to the elvui minimap."],
										func = function() E:StaticPopup_Show("KLIXUI_CREDITS", nil, nil, "https://www.tukui.org/addons.php?id=123") end,
									},
									cg = {
										order = 7,
										type = "execute",
										name = L["|cfff2f251Cool Glow|r"],
										desc = L["Changes the actionbar proc glow to something cool!"],
										func = function() E:StaticPopup_Show("KLIXUI_CREDITS", nil, nil, "https://wow.curseforge.com/projects/cool-glow") end,
									},
									mqk = {
										order = 8,
										type = "execute",
										name = L["Masque: |cfff960d9KlixUI|r"],
										desc = L["My masque skin to match the UI."],
										func = function() E:StaticPopup_Show("KLIXUI_CREDITS", nil, nil, "https://wow.curseforge.com/projects/masque-klixui") end,
									},
									mqk = {
										order = 9,
										type = "execute",
										name = L["ElvUI InfoBar"],
										desc = L["Adds an utility info bar bottom or top of your screen."],
										func = function() E:StaticPopup_Show("KLIXUI_CREDITS", nil, nil, "https://www.tukui.org/addons.php?id=134") end,
									},
								},
							},
						},
					},
					credits = {
						order = 400,
						type = 'group',
						name = L["Credits"],
						args = {
							credits = {
								order = 1,
								type = "description",
								name = L["ELVUI_KUI_CREDITS"]..'\n\n\n'..L["Submodules & Coding:"]..'\n\n'..L["ELVUI_KUI_CODERS"]..'\n\n\n'..L["ELVUI_KUI_DONORS_TITLE"]..'\n\n'..L["ELVUI_KUI_DONORS"]..'\n\n\n'..L["Testing & Inspiration:"]..'\n\n'..L["ELVUI_KUI_TESTING"]..'\n\n\n'..L["Other Support:"]..'\n\n'..L["ELVUI_KUI_SPECIAL"],
							},
						},
					},
				},
			},
		},
	}
end
T.table_insert(KUI.Config, Core)