-------------------------------------------------------------------------------
-- Credits: BonusRollFilter - Chawan111
-------------------------------------------------------------------------------
local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KBF = KUI:NewModule("KuiBonusFilter", "AceEvent-3.0", "AceHook-3.0");

local KBF_ShowBonusRoll = false
local KBF_RollFrame = nil
local KBF_RollFrameDifficultyIdBackup = nil
local KBF_RollFrameEncounterIdBackup = nil
local KBF_RollFrameEndTimeBackup = nil
local KBF_UserAction = false

local KBF_OptionsOrder = 1

-- MoP uses spellID instead of encounterID for raids before Siege of Orgrimmar since the rollframe does not include encounterID for those
local KBF_MopWorldBosses = {
    [132205] = "Sha of Anger",
    [132206] = "Salyis's Warband",
    [136381] = "Nalak, The Storm Lord",
    [137554] = "Oondasta",
    [148317] = "Timeless Isle Celestials",
    [148316] = "Ordos, Fire-God of the Yaungol",
}

local KBF_MogushanVaults = {
    [125144] = "The Stone Guard",
    [132189] = "Feng the Accursed",
    [132190] = "Gara'jal the Spiritbinder",
    [132191] = "The Spirit Kings",
    [132192] = "Elegon",
    [132193] = "Will of the Emperor",
}

local KBF_HeartOfFear = {
    [132194] = "Imperial Vizier Zor'lok",
    [132195] = "Blade Lord Ta'yak",
    [132196] = "Garalon",
    [132197] = "Wind Lord Mel'jarak",
    [132198] = "Amber-Shaper Un'sok",
    [132199] = "Grand Empress Shek'zeer",
}

local KBF_TerraceOfEndlessSpring = {
    [132200] =  "Protectors of the Endless",
    [132201] =  "Tsulong",
    [132202] =  "Lei Shi",
    [132203] =  "Sha of Fear",
}

local KBF_ThroneOfThunder = {
    [139674] = "Jin'rokh the Breaker",
    [139677] = "Horridon",
    [139679] = "Council of Elders",
    [139680] = "Tortos",
    [139682] = "Megaera",
    [139684] = "Ji-Kun",
    [139686] = "Durumu the Forgotten",
    [139687] = "Primordius",
    [139688] = "Dark Animus",
    [139689] = "Iron Qon",
    [139690] = "Twin Consorts",
    [139691] = "Lei Shen",
}

local KBF_SiegeOfOrgrimmar = {
    [852] = "Immerseus",
    [849] = "The Fallen Protectors",
    [866] = "Norushen",
    [867] = "Sha of Pride",
    [881] = "Galakras",
    [864] = "Iron Juggernaut",
    [856] = "Kor'kron Dark Shaman",
    [850] = "General Nazgrim",
    [846] = "Malkorok",
    [870] = "Spoils of Pandaria",
    [851] = "Thok the Bloodthirsty",
    [865] = "Siegecrafter Blackfuse",
    [853] = "Paragons of the Klaxxi",
    [869] = "Garrosh Hellscrea",
}

local KBF_DraenorWorldBosses = {
    [1291] = "Drov the Ruiner",
    [1211] = "Tarlna the Ageless",
    [1262] = "Rukhmar",
    [1452] = "Supreme Lord Kazzak",
}

local KBF_Highmaul = {
    [1128] = "Kargath Bladefist",
    [971] =  "The Butcher",
    [1195] = "Tectus",
    [1196] = "Brackenspore",
    [1148] = "Twin Ogron",
    [1153] = "Ko'ragh",
    [1197] = "Imperator Mar'gok",
}

local KBF_BlackrockFoundry = {
    [1202] = "Oregorger",
    [1155] = "Hans'gar and Franzok",
    [1122] = "Beastlord Darmac",
    [1161] = "Gruul",
    [1123] = "Flamebender Ka'graz",
    [1147] = "Operator Thogar",
    [1154] = "The Blast Furnace",
    [1162] = "Kromog",
    [1203] = "The Iron Maidens",
    [959] = "Blackhand",
}

local KBF_HellfireCitadel = {
    [1426] = "Hellfire Assault",
    [1425] = "Iron Reaver",
    [1392] = "Kormrok",
    [1432] = "Hellfire High Council",
    [1396] = "Kilrogg Deadeye",
    [1372] = "Gorefiend",
    [1433] = "Shadow-Lord Iskar",
    [1427] = "Socrethar the Eternal",
    [1391] = "Fel Lord Zakuun",
    [1447] = "Xhul'horac",
    [1394] = "Tyrant Velhari",
    [1395] = "Mannoroth",
    [1438] = "Archimond",
}

local KBF_TombOfSargerasEncounters = {
    [1862] = "Goroth", 
    [1867] = "Demonic Inquisition", 
    [1856] = "Harjatan", 
    [1903] = "Sisters of the Moon", 
    [1861] = "Mistress Sassz'ine", 
    [1896] = "The Desolate Host", 
    [1897] = "Maiden of Vigilance", 
    [1873] = "Fallen Avatar", 
    [1898] = "Kil'jaeden"
}

local KBF_NightholdEncounters = {
    [1706] = "Skorpyron",
    [1725] = "Chronomatic Anomaly",
    [1731] = "Trilliax",
    [1751] = "Spellblade Aluriel",
    [1762] = "Tichondrius",
    [1713] = "Krosus",
    [1761] = "High Botanist Tel'arn",
    [1732] = "Star Augur Etraeus",
    [1743] = "Grand Magistrix Elisande",
    [1737] = "Gul'dan",
}

local KBF_NightmareEncounters = {
    [1703] = "Nythendra",
    [1744] = "Elerethe Renferal",
    [1738] = "Il'gynoth, Heart of Corruption",
    [1667] = "Ursoc",
    [1704] = "Dragons of Nightmare",
    [1750] = "Cenarius",
    [1726] = "Xavius",
}

local KBF_TrialOfValorEncounters = {
    [1819] = "Odyn",
    [1830] = "Guarm",
    [1829] = "Helya",
}

local KBF_AntorusEncounters = {
    [1992] =  "Garothi Worldbreaker", 
    [1987] =  "Felhounds of Sargeras", 
    [1997] =  "Antoran High Command", 
    [1985] =  "Portal Keeper Hasabel", 
    [2025] =  "Eonar the Life-Binder", 
    [2009] =  "Imonar the Soulhunter", 
    [2004] =  "Kin'garoth", 
    [1983] =  "Varimathras", 
    [1986] =  "The Coven of Shivarra", 
    [1984] =  "Aggramar",
    [2031] =  "Argus the Unmaker",
}

local KBF_WorldBossEncountersLegion = {
    [1790] = "Ana-Mouz",
    [1956] = "Apocron",
    [1883] = "Brutallus",
    [1774] = "Calamir",
    [1789] = "Drugon the Frostblood",
    [1795] = "Flotsam",
    [1770] = "Humongris",
    [1769] = "Levantus",
    [1884] = "Malificus",
    [1783] = "Na'zak the Fiend",
    [1749] = "Nithogg",
    [1763] = "Shar'thos",
    [1885] = "Si'vash",
    [1756] = "The Soultakers",
    [1796] = "Withered J'im",
}

local KBF_ArugsInvasionEncounters = {
    [2010] = "Matron Folnuna",
    [2011] = "Mistress Alluradel",
    [2012] = "Inquisitor Meto",
    [2013] = "Occularus",
    [2014] = "Sotanathor",
    [2015] = "Pit Lord Vilemus",
}

local KBF_UldirEncounters = {
    [2168] = "Taloc",
    [2167] = "MOTHER",
    [2146] = "Fetid Devourer",
    [2169] = "Zek'voz, Herald of N'zoth",
    [2166] = "Vectis",
    [2195] = "Zul, Reborn",
    [2194] = "Mythrax the Unraveler",
    [2147] = "G'huun"
}

local KBF_BFAWorldBosses = {
    [2139] = "T'zane",
    [2141] = "Ji'arak",
    [2197] = "Hailstone Construct",
    [2199] = "Azurethos, The Winged Typhoon",
    [2198] = "Warbringer Yenajz",
    [2210] = "Dunegorger Kraulok",
	[2329] = "Ivus the Forest Lord",
}

local KBF_BattleOfDazaralor = nil -- Some differences in bosses between horde and alliance so it's set below

local KBF_CrucibleOfStorms = {
    [2328] = "The Restless Cabal",
    [2332] = "Uu'nat, Harbinger of the Void"
}

local faction, locFaction = T.UnitFactionGroup("player")

if (faction == FACTION_ALLIANCE or locFaction == FACTION_ALLIANCE) then
    KBF_BFAWorldBosses[2213] = "Doom's Howl"

    KBF_BattleOfDazaralor = {
        [2344] = "Champion of the Light",
        [2323] = "Jadefire Masters",
        [2340] = "Grong, the Revenant",
        [2342] = "Opulence",
        [2330] = "Conclave of the Chosen",
        [2335] = "King Rastakhan",
        [2334] = "High Tinker Mekkatorque",
        [2337] = "Stormwall Blockade",
        [2343] = "Lady Jaina Proudmoore"
    }

else
    KBF_BFAWorldBosses[2212] = "The Lion's Roar"

    KBF_BattleOfDazaralor = {
        [2333] = "Champion of the Light",
        [2325] = "Grong, the Jungle Lord",
        [2341] = "Jadefire Masters",
        [2342] = "Opulence",
        [2330] = "Conclave of the Chosen",
        [2335] = "King Rastakhan",
        [2334] = "High Tinker Mekkatorque",
        [2337] = "Stormwall Blockade",
        [2343] = "Lady Jaina Proudmoore"
    }
end

local KBF_EternalPalace = {
    [2352] = "Abyssal Commander Sivara",
    [2347] = "Blackwater Behemoth",
    [2353] = "Radiance of Azshara",
    [2354] = "Lady Ashvane",
    [2351] = "Orgozoa",
    [2359] = "The Queen's Court",
    [2349] = "Za'qul, Harbinger of Ny'alotha",
    [2361] = "Queen Azshara"
}

function KBF:GenerateWorldbossSettings(name, encounters)
    local tempTable = {}

    tempTable.name = name
    tempTable.type = "group"
    tempTable.order = KBF_OptionsOrder
    tempTable.args = {
            worldBossesAllOn = {
				order = 1,
                type = "execute",
                name = L["Hide rolls for all bosses"],
                desc = L["Hide bonus rolls for all bosses"],
                func = function(info, val)
                    for key, value in pairs(encounters) do
                        E.db.KlixUI.loot.bonusFilter[14][key] = true
                    end
                end,
            },
            worldBossesAllOff = {
				order = 1,
                type = "execute",
                name = L["Show rolls for all bosses"],
                desc = L["Show bonus rolls for all bosses"],
                func = function(info, val)
                    for key, value in pairs(encounters) do
                        E.db.KlixUI.loot.bonusFilter[14][key] = false
                    end
                end,
            },
            normal = {
				order = 3,
                type = "multiselect",
				name = L["Bosses"],
                set = function(info, key, value)
                    E.db.KlixUI.loot.bonusFilter[14][key] = value
                end,
                get = function(info, key)
                    return E.db.KlixUI.loot.bonusFilter[14][key]
                end,
                values = encounters
            },
        }

    KBF_OptionsOrder = KBF_OptionsOrder + 1
    return tempTable
end

function KBF:GenerateRaidSettings(name, encounters, enableLFR, enableNormal, enableHeroic, enableMythic)
    local tempTable = {}

    tempTable.name = name
    tempTable.type = "group"
    tempTable.order = KBF_OptionsOrder
    tempTable.args = {}
	
		if enableLFR then
            tempTable.args.AllLFROn = {
				order = 1,
                type = "execute",
                name = L["Hide all rolls in LFR"],
                desc = L["Hide bonus rolls for all "..name.." bosses in LFR"],
                func = function(info, val)
                    for key, value in T.pairs(encounters) do
                        E.db.KlixUI.loot.bonusFilter[17][key] = true
                    end
                end,
            }
            tempTable.args.AllLFROff = {
				order = 1,
                type = "execute",
                name = L["Show all rolls in LFR"],
                desc = L["Show bonus rolls for all "..name.." bosses in LFR"],
                func = function(info, val)
                    for key, value in T.pairs(encounters) do
                        E.db.KlixUI.loot.bonusFilter[17][key] = false
                    end
                end,
            }
            tempTable.args.lfr = {
				order = 3,
                type = "multiselect",
				name = L["LFR"],
                set = function(info, key, value)
                    E.db.KlixUI.loot.bonusFilter[17][key] = value
                end,
                get = function(info, key)
                    return E.db.KlixUI.loot.bonusFilter[17][key]
                end,
                values = encounters
            }
		end
		
		if enableNormal then
            tempTable.args.AllNormalOn = {
				order = 4,
                type = "execute",
                name = L["Hide all rolls on normal"],
                desc = L["Hide bonus rolls for all "..name.." bosses on normal"],
                func = function(info, val)
                    for key, value in T.pairs(encounters) do
                        E.db.KlixUI.loot.bonusFilter[14][key] = true
                    end
                end,
            }
            tempTable.args.AllNormalOff = {
				order = 5,
                type = "execute",
                name = L["Show all rolls on normal"],
                desc = L["Show bonus rolls for all "..name.." bosses on normal"],
                func = function(info, val)
                    for key, value in T.pairs(encounters) do
                        E.db.KlixUI.loot.bonusFilter[14][key] = false
                    end
                end,
            }
            tempTable.args.normal={
				order = 6,
				type = "multiselect",
                name = L["Normal"],
                set = function(info, key, value)
                    E.db.KlixUI.loot.bonusFilter[14][key] = value
                end,
                get = function(info, key)
                    return E.db.KlixUI.loot.bonusFilter[14][key]
                end,
                values = encounters
            }
		end
		
		if enableHeroic then
            tempTable.args.AllHeroicOn = {
				order = 7,
                type = "execute",
                name = L["Hide all rolls on heroic"],
                desc = L["Hide bonus rolls for all "..name.." bosses on heroic"],
                func = function(info, val)
                    for key, value in T.pairs(encounters) do
                        E.db.KlixUI.loot.bonusFilter[15][key] = true
                    end
                end,
            }
            tempTable.args.AllHeroicOff = {
				order = 8,
                type = "execute",
                name = L["Show all rolls on heroic"],
                desc = L["Show bonus rolls for all "..name.." bosses on heroic"],
                func = function(info, val)
                    for key, value in T.pairs(encounters) do
                        E.db.KlixUI.loot.bonusFilter[15][key] = false
                    end
                end,
            }
            tempTable.args.heroic={
				order = 9,
                type = "multiselect",
				name = L["Heroic"],
                set = function(info, key, value)
                    E.db.KlixUI.loot.bonusFilter[15][key] = value
                end,
                get = function(info, key)
                    return E.db.KlixUI.loot.bonusFilter[15][key]
                end,
                values = encounters
            }
		end
		
		if enableMythic then
            tempTable.args.AllMythicOn = {
				order = 10,
                type = "execute",
                name = L["Hide all rolls on mythic"],
                desc = L["Hides bonus rolls for all "..name.." bosses on mythic"],
                func = function(info, val)
                    for key, value in T.pairs(encounters) do
                        E.db.KlixUI.loot.bonusFilter[16][key] = true
                    end
                end,
            }
            tempTable.args.AllMythicOff = {
				order = 11,
                type = "execute",
                name = L["Show all rolls on mythic"],
                desc = L["Show bonus rolls for all "..name.." bosses on mythic"],
                func = function(info, val)
                    for key, value in T.pairs(encounters) do
                        E.db.KlixUI.loot.bonusFilter[16][key] = false
                    end
                end,
            }
            tempTable.args.mythic = {
				order = 12,
				type = "multiselect",
                name = L["Mythic"],
                set = function(info, key, value)
                    E.db.KlixUI.loot.bonusFilter[16][key] = value
                end,
                get = function(info, key)
                    return E.db.KlixUI.loot.bonusFilter[16][key]
                end,
                values = encounters
			}
		end

    KBF_OptionsOrder = KBF_OptionsOrder + 1
    return tempTable
end

local function LootTable()
	E.Options.args.KlixUI.args.modules.args.loot = {
		type = "group",
		name = L["Loot"],
		order = 16,
		childGroups = "tab",
		get = function(info) return E.db.KlixUI.loot[ info[#info] ] end,
		set = function(info, value) E.db.KlixUI.loot[ info[#info] ] = value; end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = KUI:cOption(L["Loot"]),
			},
			bonusFilter = {
				order = 2,
				type = "group",
				name = L["Bonus Roll Filter"],
				args = {
					helpText = {
						order = 1,
						type = "description",
						name = L["Select bosses below that you DON'T want bonus rolls to appear on"],
					},
					space1 = {
						order = 2,
						type = "description",
						name = "",
					},
					bfaCategory = {
						order = 3,
						type = "group",
						name = L["Battle for Azeroth"],
						args = {
							palace         = KBF:GenerateRaidSettings("The Eternal Palace", KBF_EternalPalace, true, true, true, true),
							crucible       = KBF:GenerateRaidSettings("Crucible of Storms", KBF_CrucibleOfStorms, true, true, true, true),
							dazaralor      = KBF:GenerateRaidSettings("Battle of Dazar'alor", KBF_BattleOfDazaralor, true, true, true, true),
							uldir          = KBF:GenerateRaidSettings("Uldir", KBF_UldirEncounters, true, true, true, true),
							worldBossesBFA = KBF:GenerateWorldbossSettings("World Bosses", KBF_BFAWorldBosses),
						}
					},
					legionCategory = {
						order = 4,
						type = "group",
						name = L["Legion"],
						args = {
							antorus           = KBF:GenerateRaidSettings("Antorus, the Burning Throne", KBF_AntorusEncounters, true, true, true, true),
							tombOfSargeras    = KBF:GenerateRaidSettings("Tomb of Sargeras", KBF_TombOfSargerasEncounters, true, true, true, true),
							nighthold         = KBF:GenerateRaidSettings("The Nighthold", KBF_NightholdEncounters, true, true, true, true),
							trialOfValor      = KBF:GenerateRaidSettings("Trial of Valor", KBF_TrialOfValorEncounters, true, true, true, true),
							emeraldNightmare  = KBF:GenerateRaidSettings("Emerald Nightmare", KBF_NightmareEncounters, true, true, true, true),
							argusInvasions    = KBF:GenerateWorldbossSettings("Argus Invasion Points", KBF_ArugsInvasionEncounters),
							worldBossesLegion = KBF:GenerateWorldbossSettings("World Bosses", KBF_WorldBossEncountersLegion),
						}
					},
					wodCategory = {
						order = 5,
						type = "group",
						name = L["Warlords of Draenor"],
						args = {
							citadel           = KBF:GenerateRaidSettings("Hellfire Citadel", KBF_HellfireCitadel, true, true, true, true),
							foundry           = KBF:GenerateRaidSettings("Blackrock Foundry", KBF_BlackrockFoundry, true, true, true, true),
							highmaul          = KBF:GenerateRaidSettings("Highmaul", KBF_Highmaul, true, true, true, true),
							worldBossesWOD    = KBF:GenerateWorldbossSettings("World Bosses", KBF_DraenorWorldBosses)
						}
					},
					mopCategory = {
						order = 6,
						type = "group",
						name = L["Mists of Pandaria"],
						args = {
							siege           = KBF:GenerateRaidSettings("Siege of Orgrimmar", KBF_SiegeOfOrgrimmar, true, true, true, true),
							throne          = KBF:GenerateRaidSettings("Throne of Thunder", KBF_ThroneOfThunder, true, true, true, false),
							terrace         = KBF:GenerateRaidSettings("Terrace of Endless Spring", KBF_TerraceOfEndlessSpring, true, true, true, false),
							hearthOfFear    = KBF:GenerateRaidSettings("Heart of Fear", KBF_HeartOfFear, true, true, true, false),
							vaults          = KBF:GenerateRaidSettings("Mogu'shan Vaults", KBF_MogushanVaults, true, true, true, false),
							worldBossesMOP  = KBF:GenerateWorldbossSettings("World Bosses", KBF_MopWorldBosses)
						}
					},
					dungeons = {
						order = 7,
						type = "group",
						name = L["Mythic Dungeons"],
						args={
							mythicHeader = {
								order = 1,
								type = "header",
								name = "Normal mythic",
								type = "header",
							},
							disable = {
								order = 2,
								type = "toggle",
								name = L["Mythic Dungeons"],
								desc = L["Disables bonus rolls in mythic dungeons"],
								descStyle = "inline",
								set = function(info, val) E.db.KlixUI.loot.bonusFilter[23] = val end,
								get = function(info) return E.db.KlixUI.loot.bonusFilter[23] end
							},
							mythicPlusHeader = {
								order = 3,
								type = "header",
								name = L["Mythic+"],
							},
							disableAllMythicPlus = {
								order = 4,
								type = "toggle",
								width = "full",
								name = L["Disable bonus rolls in all mythic+"],
								descStyle = "inline",
								set = function(info, val) 
									E.db.KlixUI.loot.bonusFilter[8] = val

									if E.db.KlixUI.loot.bonusFilter.disableKeystoneLevelToggle then
										E.db.KlixUI.loot.bonusFilter.disableKeystoneLevelToggle = false
									end
								end,
								get = function(info) return E.db.KlixUI.loot.bonusFilter[8] end
							},
							disableKeystoneLevelToggle = {
								order = 5,
								type = "toggle",
								width = 1.5,
								name = L["Disable bonus rolls if keystone level is lower than: "],
								set = function(info, val) 
									E.db.KlixUI.loot.bonusFilter.disableKeystoneLevelToggle = val 

									if E.db.KlixUI.loot.bonusFilter[8] then
										E.db.KlixUI.loot.bonusFilter[8] = false
									end
								end,
								get = function(info) return E.db.KlixUI.loot.bonusFilter.disableKeystoneLevelToggle end
							},
							disableKeystoneLevel = {
								order = 6,
								type = "input",
								width = 0.8,
								name = L["Keystone level"],
								validate = ValidateNumeric,
								set = function(info, val) 
									E.db.KlixUI.loot.bonusFilter.disableKeystoneLevel = val
								end,
								get = function(info) return E.db.KlixUI.loot.bonusFilter.disableKeystoneLevel end
							},
						},
					},
				},
			},
		},
	}
end
T.table_insert(KUI.Config, LootTable)

function ValidateNumeric(info,val)
    if not T.tonumber(val) then
      return false;
    end

    return true
end

function KBF:LoadingScreen_Enabled()
    if KBF_RollFrame ~= nil then
        KBF_RollFrameDifficultyIdBackup = KBF_RollFrame.difficultyID
        KBF_RollFrameEncounterIdBackup = KBF_RollFrame.encounterID
        KBF_RollFrameEndTimeBackup = KBF_RollFrame.endTime
    end
    
end

function KBF:RollButton_OnClick()
    KBF_UserAction = true
end

function KBF:PassButton_OnClick()
    KBF_UserAction = true
end

function KBF:BonusRollFrame_OnShow(frame)
    KBF_UserAction = false

    if (KBF_RollFrame == nil) then
        KBF_RollFrame = frame
    elseif (KBF_RollFrameDifficultyIdBackup ~= nil and KBF_RollFrameEndTimeBackup ~= nil and frame.difficultyID ~= KBF_RollFrameDifficultyIdBackup and T.time() <= KBF_RollFrameEndTimeBackup) then
        KBF_RollFrame = frame
        KBF_RollFrame.difficultyID = KBF_RollFrameDifficultyIdBackup
    else
        KBF_RollFrame = frame
    end

    if (KBF_RollFrame.difficultyID == 8) then
        if (E.db.KlixUI.loot.bonusFilter[KBF_RollFrame.difficultyID] == true and KBF_ShowBonusRoll == false) then
            KBF:HideRoll()
        elseif (E.db.KlixUI.loot.bonusFilter.disableKeystoneLevelToggle == true and KBF_ShowBonusRoll == false) then
            local _, level, _, _, _ = T.C_ChallengeMode_GetCompletionInfo()

            if (level < T.tonumber(E.db.KlixUI.loot.bonusFilter.disableKeystoneLevel)) then
                KBF:HideRoll()
            end
        end
     elseif (KBF_RollFrame.difficultyID == 23) then -- Normal mythics
        if (E.db.KlixUI.loot.bonusFilter[KBF_RollFrame.difficultyID] == true and KBF_ShowBonusRoll == false) then
            KBF:HideRoll()
        end
    elseif (KBF_RollFrame.difficultyID == 3) or (KBF_RollFrame.difficultyID == 4) then -- 10 or 25 man normal for MoP raids
        if (E.db.KlixUI.loot.bonusFilter[14][KBF_RollFrame.spellID] == true and KBF_ShowBonusRoll == false) then
            KBF:HideRoll()
        end
    elseif (KBF_RollFrame.difficultyID == 5) or (KBF_RollFrame.difficultyID == 6) then -- 10 or 25 man heroic for MoP raids
        if (E.db.KlixUI.loot.bonusFilter[15][KBF_RollFrame.spellID] == true and KBF_ShowBonusRoll == false) then
            KBF:HideRoll()
        end
    elseif (E.db.KlixUI.loot.bonusFilter[KBF_RollFrame.difficultyID][KBF_RollFrame.encounterID] == true and KBF_ShowBonusRoll == false) or (E.db.KlixUI.loot.bonusFilter[KBF_RollFrame.difficultyID][KBF_RollFrame.spellID] == true and KBF_ShowBonusRoll == false) then -- Raids
        KBF:HideRoll()
    end

    KBF_ShowBonusRoll = false
end

function KBF:HideRoll()
    KBF_RollFrame:Hide()
    T.GroupLootContainer_RemoveFrame(_G.GroupLootContainer, KBF_RollFrame);
	KUI:Print("Bonus Roll hidden")
end

function KBF:ShowRoll()
    if KBF_RollFrame ~= nil and (KBF_RollFrame:IsVisible() == false and T.time() <= KBF_RollFrame.endTime and KBF_UserAction == false) then
        KBF_ShowBonusRoll = true
        T.GroupLootContainer_AddFrame(_G.GroupLootContainer, KBF_RollFrame);

        -- For some reason if you are using ElvUI the timer bar will be behind the roll frame when you open it again after hiding it
        if ElvUI then
            local FrameLevel = KBF_RollFrame:GetFrameLevel();
            KBF_RollFrame.PromptFrame.Timer:SetFrameLevel(FrameLevel + 1);
            KBF_RollFrame.BlackBackgroundHoist:SetFrameLevel(FrameLevel);
        end

        KBF_RollFrame:Show()
    else
	KUI:Print("No active bonus roll to show")
    end
end

function KBF:Initialize()
    self:SecureHookScript(BonusRollFrame, "OnShow", "BonusRollFrame_OnShow")
    self:SecureHookScript(BonusRollFrame.PromptFrame.RollButton, "OnClick", "RollButton_OnClick")
    self:SecureHookScript(BonusRollFrame.PromptFrame.PassButton, "OnClick", "PassButton_OnClick")

    self:RegisterEvent("LOADING_SCREEN_ENABLED", "LoadingScreen_Enabled")
end

KUI:RegisterModule(KBF:GetName())