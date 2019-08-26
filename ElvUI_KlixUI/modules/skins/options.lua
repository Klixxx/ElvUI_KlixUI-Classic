local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")

local SupportedProfiles = {
	{'AddOnSkins', 'AddOnSkins'},
	{'BigWigs', 'BigWigs'},
	{'DBM-Core', 'Deadly Boss Mods'},
	{'Details', 'Details'},
	{'ElvUI_SLE', 'Shadow & Light'},
	{"ls_Toasts", "ls_Toasts"},
	{"Masque", "Masque"},
	{"ProjectAzilroka", "ProjectAzilroka"},
	{'XIV_Databar', 'XIV_Databar'},
}

local DecorAddons = {
	{"ActionBarProfiles", L["ActonBarProfiles"], "abp"},
	{"Baggins", L["Baggins"], "ba"},
	{"BigWigs", L["BigWigs"], "bw"},
	{"BugSack", L["BugSack"], "bs"},
	{"DBM-Core", L["Deadly Boss Mods"], "dbm"},
	{"ElvUI_DTBars2", L["ElvUI_DTBars2"], "dtb"},
	{"ElvUI_SLE", L["Shadow & Light"], "sle"},
	{"ls_Toasts", L["ls_Toasts"], "ls"},
	{"Pawn", L["Pawn"], "pw"},
	{"ProjectAzilroka", L["ProjectAzilroka"], "pa"},
	{"WeakAuras", L["WeakAuras"], "wa"},
	{"XIV_Databar", L["XIV_Databar"], "xiv"},
}

local profileString = T.string_format('|cfffff400%s |r', L['KlixUI successfully created and applied profile(s) for:'])

local function SkinsTable()
	E.Options.args.KlixUI.args.skins = {
		order = 100,
		type = "group",
		name = L["Skins & AddOns"],
		childGroups = 'tab',
		args = {
			name = {
				order = 1,
				type = "header",
				name = KUI:cOption(L["Skins & AddOns"]),
			},
			general = {
				order = 2,
				type = "group",
				name = L["General"],
				args = {
					style = {
						order = 1,
						type = "toggle",
						name = L["|cfff960d9KlixUI|r Style |cffff8000(Beta)|r"],
						desc = L["Creates decorative squares, a gradient and a shadow overlay on some frames.\n|cffff8000Note: This is still in beta state, not every blizzard frames are skinned yet!|r"],
						get = function(info) return E.db.KlixUI.general[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.general[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
					iconShadow = {
						order = 2,
						type = "toggle",
						name = L["|cfff960d9KlixUI|r Icon Shadow"]..E.NewSign,
						desc = L["Creates a shadow overlay around various icons.\n|cffff8000Note: There is still some icons that miss the shadow overlay, i'm working on them!|r"],
						disabled = function() return T.IsAddOnLoaded("Masque") end,
						get = function(info) return E.db.KlixUI.general[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.general[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
					vehicleButton = {
						order = 3,
						type = "toggle",
						name = L["KlixUI Vehicle"],
						desc = L["Redesign the standard vehicle button with a custom one."],
						get = function(info) return E.private.KlixUI.skins[ info[#info] ] end,
						set = function(info, value) E.private.KlixUI.skins[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
					shadowOverlay = {
						order = 4,
						type = "group",
						name = L["Shadow Overlay"],
						guiInline = true,
						get = function(info) return E.db.KlixUI.general.shadowOverlay[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.general.shadowOverlay[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Enable"],
								desc = L["Creates a shadow overlay around the whole screen for a more darker finish."],
							},
							alpha = {
								order = 2,
								type = "range",
								name = L["Shadow Level"],
								desc = L["Change the dark finish of the shadow overlay."],
								min = 1, max = 100, step = 1,
								disabled = function() return not E.db.KlixUI.general.shadowOverlay.enable end,
								set = function(info, value) E.db.KlixUI.general.shadowOverlay[ info[#info] ] = value; KUI:GetModule("KuiLayout"):SetShadowLevel(value) end,
							},
						},
					},
				},
			},
		},
	}

	E.Options.args.KlixUI.args.skins.args.addonskins = {
		order = 6,
		type = "group",
		name = L["Addon Skins"],
		get = function(info) return E.private.KlixUI.skins.addonSkins[ info[#info] ] end,
		set = function(info, value) E.private.KlixUI.skins.addonSkins[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
		args = {
			info = {
				order = 1,
				type = "description",
				name = L["KUI_ADDONSKINS_DESC"],
			},
			space1 = {
				order = 2,
				type = "description",
				name = "",
			},
		},
	}

	local addorder = 3
	for i, v in T.ipairs(DecorAddons) do
		local addonName, addonString, addonOption = T.unpack(v)
		E.Options.args.KlixUI.args.skins.args.addonskins.args[addonOption] = {
			order = addorder + 1,
			type = "toggle",
			name = addonString,
			disabled = function() return not T.IsAddOnLoaded(addonName) end,
		}
	end
	
	local blizzOrder = 5
	E.Options.args.KlixUI.args.skins.args.blizzard = {
		order = blizzOrder + 1,
		type = "group",
		name = L["Blizzard Skins"],
		get = function(info) return E.private.KlixUI.skins.blizzard[ info[#info] ] end,
		set = function(info, value) E.private.KlixUI.skins.blizzard[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
		args = {
			info = {
				order = 1,
				type = "description",
				name = L["KUI_SKINS_DESC"],
			},
			space1 = {
				order = 2,
				type = "description",
				name = "",
			},
			gotoskins = {
				order = 3,
				type = "execute",
				name = L["ElvUI Skins"],
				func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "skins") end,
			},
			space2 = {
				order = 4,
				type = "description",
				name = "",
			},
			encounterjournal = {
				type = "toggle",
				name = ENCOUNTER_JOURNAL,
				disabled = function () return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.encounterjournal end
			},
			spellbook = {
				type = "toggle",
				name = SPELLBOOK,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.spellbook end,
			},
			character = {
				type = "toggle",
				name = L["Character Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.character end,
			},
			gossip = {
				type = "toggle",
				name = L["Gossip Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.gossip end,
			},
			quest = {
				type = "toggle",
				name = L["Quest Frames"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.quest end,
			},
			questChoice = {
				type = "toggle",
				name = L["Quest Choice"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.questChoice end,
			},
			orderhall = {
				type = "toggle",
				name = L["Orderhall"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.orderhall end,
			},
			garrison = {
				type = "toggle",
				name = GARRISON_LOCATION_TOOLTIP,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.garrison end,
			},
			talent = {
				type = "toggle",
				name = TALENTS,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.talent end,
			},
			archaeology = {
				type = "toggle",
				name = L["Archaeology Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.archaeology end,
			},
			auctionhouse = {
				type = "toggle",
				name = AUCTIONS,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.auctionhouse end,
			},
			barber = {
				type = "toggle",
				name = L["Barber Shop"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.barber end,
			},
			friends = {
				type = "toggle",
				name = FRIENDS,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.friends end,
			},
			contribution = {
				type = "toggle",
				name = L["Contribution"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.Contribution end,
			},
			artifact = {
				type = "toggle",
				name = ITEM_QUALITY6_DESC,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.artifact end,
			},
			collections = {
				type = "toggle",
				name = COLLECTIONS,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.collections end,
			},
			calendar = {
				type = "toggle",
				name = L["Calendar Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.calendar end,
			},
			merchant = {
				type = "toggle",
				name = L["Merchant Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.merchant end,
			},
			worldmap = {
				type = "toggle",
				name = WORLD_MAP,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.worldmap end,
			},
			pvp = {
				type = "toggle",
				name = L["PvP Frames"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.pvp end,
			},
			achievement = {
				type = "toggle",
				name = ACHIEVEMENTS,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.achievement end,
			},
			tradeskill = {
				type = "toggle",
				name = TRADESKILLS,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.tradeskill end,
			},
			itemUpgrade = {
				type = "toggle",
				name = L["Item Upgrade"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.itemUpgrade end,
			},
			lfg = {
				type = "toggle",
				name = LFG_TITLE,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.lfg end,
			},
			lfguild = {
				type = "toggle",
				name = L["LF Guild Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.lfguild end,
			},
			talkinghead = {
				type = "toggle",
				name = L["TalkingHead"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.talkinghead end,
			},
			guild = {
				type = "toggle",
				name = GUILD,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.guild end,
			},
			objectiveTracker = {
				type = "toggle",
				name = OBJECTIVES_TRACKER_LABEL,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.objectiveTracker end,
			},
			addonManager = {
				type = "toggle",
				name = L["AddOn Manager"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.addonManager end,
			},
			mail = {
				type = "toggle",
				name =  L["Mail Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.mail end,
			},
			raid = {
				type = "toggle",
				name = L["Raid Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.raid end,
			},
			dressingroom = {
				type = "toggle",
				name = DRESSUP_FRAME,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.dressingroom end,
			},
			timemanager = {
				type = "toggle",
				name = TIMEMANAGER_TITLE,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.timemanager end,
			},
			guildcontrol = {
				type = "toggle",
				name = L["Guild Control Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.guildcontrol end,
			},
			macro = {
				type = "toggle",
				name = MACROS,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.macro end,
			},
			binding = {
				type = "toggle",
				name = KEY_BINDING,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.binding end,
			},
			gbank = {
				type = "toggle",
				name = GUILD_BANK,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.gbank end,
			},
			taxi = {
				type = "toggle",
				name = FLIGHT_MAP,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.taxi end,
			},
			help = {
				type = "toggle",
				name = L["Help Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.help end,
			},
			loot = {
				type = "toggle",
				name = L["Loot Frames"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.loot end,
			},
			deathRecap = {
				type = "toggle",
				name = DEATH_RECAP_TITLE,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.deathRecap end,
			},
			challenges = {
				type = "toggle",
				name = CHALLENGES,
				disabled = function() return not E.private.skins.blizzard.enable end, -- No ElvUI skin yet
			},
			channels = {
				type = "toggle",
				name = CHANNELS,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.Channels end,
			},
			minimap = {
				type = "toggle",
				name = L["Minimap"],
				disabled = function() return not E.private.skins.blizzard.enable end,
			},
			trainer = {
				type = "toggle",
				name = L["Trainer Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.trainer end,
			},
			debug = {
				type = "toggle",
				name = L["Debug Tools"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.debug end,
			},
			inspect = {
				type = "toggle",
				name = L["Inspect Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.inspect end,
			},
			socket = {
				type = "toggle",
				name = L["Socket Frame"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.socket end,
			},
			itemUpgrade = {
				type = "toggle",
				name = L["Item Upgrade"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.itemUpgrade end,
			},
			trade = {
				type = "toggle",
				name = TRADESKILLS,
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.trade end,
			},
			AlliedRaces = {
				type = "toggle",
				name = L["Allied Races"],
				disabled = function() return not E.private.skins.blizzard.enable or not E.private.skins.blizzard.AlliedRaces end,
			},
		},
	}
	
	E.Options.args.KlixUI.args.skins.args.profiles = {
		order = 7,
		type = "group",
		name = L["Addon Profiles"],
		args = {
			info = {
				order = 1,
				type = "description",
				name = L["KUI_PROFILE_DESC"],
			},
		},
	}
	
	local optionOrder = 1
	for i, v in T.ipairs(SupportedProfiles) do
		local addon, addonName = T.unpack(v)
		E.Options.args.KlixUI.args.skins.args.profiles.args[addon] = {
			order = optionOrder + 1,
			type = 'execute',
			name = addonName,
			desc = L['This will create and apply profile for ']..addonName,
			buttonElvUI = true,
			func = function()
				if addon == 'DBM-Core' then
					KUI:LoadDBMProfile()
					E:StaticPopup_Show('PRIVATE_RL')
				elseif addon == 'BigWigs' then
					KUI:LoadBigWigsProfile()
					E:StaticPopup_Show('PRIVATE_RL')
				elseif addon == 'Details' then
					KUI:LoadDetailsProfile()
					E:StaticPopup_Show('PRIVATE_RL')
				elseif addon == 'ElvUI_SLE' then
					KUI:LoadSLEProfile()
					E:StaticPopup_Show('PRIVATE_RL')
				elseif addon == 'XIV_Databar' then
					KUI:LoadXIVProfile()
					E:StaticPopup_Show('PRIVATE_RL')
				elseif addon == 'AddOnSkins' then
					KUI:LoadAddOnSkinsProfile()
					E:StaticPopup_Show('PRIVATE_RL')
				elseif addon == 'ls_Toasts' then
					KUI:LoadLSProfile()
					E:StaticPopup_Show('PRIVATE_RL')
				elseif addon == 'Masque' then
					KUI:LoadMasqueProfile()
					E:StaticPopup_Show('PRIVATE_RL')
				elseif addon == 'ProjectAzilroka' then
					KUI:LoadPAProfile()
					E:StaticPopup_Show('PRIVATE_RL')
				end
				T.print(profileString..addonName)
			end,
			disabled = function() return not T.IsAddOnLoaded(addon) end,
		}
	end
end
T.table_insert(KUI.Config, SkinsTable)

local function injectElvUISkinsOptions()
	E.Options.args.skins.args.blizzard.args.gotoklixui = {
		order = 1,
		type = "execute",
		name = KUI:cOption(L["KlixUI Skins"]),
		func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "KlixUI", "skins") end,
	}
	
	E.Options.args.skins.args.blizzard.args.spacer1 = {
		order = 2,
		type = 'description',
		name = '',
	}
	
	E.Options.args.skins.args.blizzard.args.spacer2 = {
		order = 3,
		type = 'description',
		name = '',
	}
end
T.table_insert(KUI.Config, injectElvUISkinsOptions)