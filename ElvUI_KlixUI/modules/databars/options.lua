local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KDB = KUI:GetModule("KuiDatabars")
local EDB = E:GetModule("DataBars")
local QXP = KUI:GetModule('KuiQuestXP')

local function DataBarTable()
    E.Options.args.KlixUI.args.modules.args.databars = {
        order = 10,
        type = "group",
        name = L["DataBars"],
        childGroups = "tab",
        args = {
			name = {
				order = 1,
				type = "header",
				name = KUI:cOption(L["DataBars"]),
			},
            enable = {
                order = 2,
                name = ENABLE,
                desc = L["Enable/Disable the |cfff960d9KlixUI|r DataBar color mod."],
                type = "toggle",
				disabled = function() return T.IsAddOnLoaded("ElvUI_ProgressiveDataBarsColors") end,
                get = function()
                    return E.db.KlixUI.databars.enable
                end,
                set = function(info, value)
                    E.db.KlixUI.databars.enable = value
                    KDB:EnableDisable()
                end,
            },
			style = {
				order = 3,
				type = 'toggle',
				name = L["|cfff960d9KlixUI|r Style"],
				disabled = function() return not E.db.KlixUI.general.style end,
				get = function(info) return E.db.KlixUI.databars[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.databars[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
			},
            experienceBar = {
                order = 10,
                name = XPBAR_LABEL,
                type = "group",
                args = {
                    capped = {
                        order = 1,
                        name = L["Capped"],
                        desc = L["Replace XP text with the word 'Capped' at max level."],
                        type = "toggle",
						disabled = function() return not E.db.KlixUI.databars.enable or T.IsAddOnLoaded("ElvUI_ProgressiveDataBarsColors") end,
                        get = function()
                            return E.db.KlixUI.databars.experienceBar.capped
                        end,
                        set = function(info, value)
                            E.db.KlixUI.databars.experienceBar.capped = value
                            EDB:UpdateExperience()
                        end,
                    },
                    progress = {
                        order = 2,
                        name = L["Blend Progress"],
                        desc = L["Progressively blend the bar as you gain XP."],
                        type = "toggle",
						disabled = function() return not E.db.KlixUI.databars.enable or T.IsAddOnLoaded("ElvUI_ProgressiveDataBarsColors") end,
                        get = function()
                            return E.db.KlixUI.databars.experienceBar.progress
                        end,
                        set = function(info, value)
                            E.db.KlixUI.databars.experienceBar.progress = value
                            EDB:UpdateExperience()
                        end,
                    },
                    xpColor = {
                        order = 3,
                        name = L["XP Color"],
                        desc = L["Select your preferred XP color."],
                        type = "color",
                        hasAlpha = true,
						disabled = function() return not E.db.KlixUI.databars.enable or T.IsAddOnLoaded("ElvUI_ProgressiveDataBarsColors") end,
                        get = function()
                            local c = E.db.KlixUI.databars.experienceBar.xpColor
                            return c.r, c.g, c.b, c.a
                        end,
                        set = function(info, r, g, b, a)
                            local c = E.db.KlixUI.databars.experienceBar.xpColor
                            c.r, c.g, c.b, c.a = r, g, b, a
                            EDB:UpdateExperience()
                        end,
                    },
					restColor = {
                        order = 4,
                        name = L["Rested Color"],
                        desc = L["Select your preferred rested color."],
                        type = "color",
                        hasAlpha = true,
						disabled = function() return not E.db.KlixUI.databars.enable or T.IsAddOnLoaded("ElvUI_ProgressiveDataBarsColors") end,
                        get = function()
                            local c = E.db.KlixUI.databars.experienceBar.restColor
                            return c.r, c.g, c.b, c.a
                        end,
                        set = function(info, r, g, b, a)
                            local c = E.db.KlixUI.databars.experienceBar.restColor
                            c.r, c.g, c.b, c.a = r, g, b, a
                            EDB:UpdateExperience()
                        end
                    },
					questXP = {
						order = 10,
						type = "group",
						name = L["Quest XP"],
						hidden = function() return T.IsAddOnLoaded("ElvUI_QuestXP") end,
						disabled = function() return T.IsAddOnLoaded("ElvUI_QuestXP") end,
						guiInline = true,
						args = {
							intro = {
								order = 1,
								type = "description",
								name = L["QXP_DESC"],
							},
							enable = {
								order = 2,
								name = L["Enable"],
								desc = L["Enable/Disable the QuestXP overlay on the experiencebar."],
								type = "toggle",
								get = function()
									return E.db.KlixUI.databars.questXP.enable
								end,
								set = function(info, value)
									E.db.KlixUI.databars.questXP.enable = value; E:StaticPopup_Show("PRIVATE_RL");
								end,
							},
							space1 = {
								order = 3,
								type = "description",
								name = "",
							},						
							Color = {
								order = 4,
								type = "color",
								name = L["Overlay Color"],
								hasAlpha = true,
								disabled = function() return not E.db.KlixUI.databars.questXP.enable end,
								get = function()
									local t = E.db.KlixUI.databars.questXP.Color
									return t.r, t.g, t.b, t.a
								end,
								set = function(info, r, g, b, a)
									local t = E.db.KlixUI.databars.questXP.Color
									t.r, t.g, t.b, t.a = r, g, b, a
									QXP:Refresh()
								end,
							},
							IncludeIncompleted = {
								order = 6,
								type = "toggle",
								name = L["Include Incomplete Quests"],
								disabled = function() return not E.db.KlixUI.databars.questXP.enable end,
								get = function() return E.db.KlixUI.databars.questXP.IncludeIncomplete end,
								set = function(info, value) E.db.KlixUI.databars.questXP.IncludeIncomplete = value; QXP:Refresh() end,
							},
							CurrentZoneOnly = {
								order = 7,
								type = "toggle",
								name = L["Current Zone Quests Only"],
								disabled = function() return not E.db.KlixUI.databars.questXP.enable end,
								get = function() return E.db.KlixUI.databars.questXP.CurrentZoneOnly end,
								set = function(info, value) E.db.KlixUI.databars.questXP.CurrentZoneOnly = value; QXP:Refresh() end,
							},
							tooltip = {
								order = 8,
								type = "toggle",
								name = L["Add Quest XP To Tooltip"],
								get = function(info) return E.db.KlixUI.databars.questXP.tooltip end,
								set = function(info, value) E.db.KlixUI.databars.questXP.tooltip = value; QXP:HookXPBar(value) end
							},
						},
					},
                },
            },
            reputationBar = {
                order = 11,
                name = L["Reputation Bar"],
                type = "group",
				disabled = function() return not E.db.KlixUI.databars.enable or T.IsAddOnLoaded("ElvUI_ProgressiveDataBarsColors") end,
                args = {
                    capped = {
                        order = 1,
                        name = L["Capped"],
                        desc = L["Replace rep text with the word 'Capped' or 'Paragon' at max."],
                        type = "toggle",
                        get = function()
                            return E.db.KlixUI.databars.reputationBar.capped
                        end,
                        set = function(info, value)
                            E.db.KlixUI.databars.reputationBar.capped = value
                            EDB:UpdateReputation()
                        end,
                    },
                    progress = {
                        order = 2,
                        name = L["Blend Progress"],
                        desc = L["Progressively blend the bar as you gain reputation."],
                        type = "toggle",
                        get = function()
                            return E.db.KlixUI.databars.reputationBar.progress
                        end,
                        set = function(info, value)
                            E.db.KlixUI.databars.reputationBar.progress = value
                            EDB:UpdateReputation()
                        end,
                    },
					autotrack = {
						order = 3,
						type = "toggle",
						name = L["Auto Track Reputation"],
						desc = L["Automatically change your watched faction on the reputation bar to the faction you got reputation points for."],
						get = function()
                            return E.db.KlixUI.databars.reputationBar.autotrack
                        end,
                        set = function(info, value)
                            E.db.KlixUI.databars.reputationBar.autotrack = value
                            E:StaticPopup_Show("PRIVATE_RL");
                        end,
					},
                    --[[textFormat = {
                        order = 4,
                        name = L["'Paragon' Format"],
                        desc = L["If 'Capped' is toggled and watched faction is a Paragon then choose short or long."],
                        type = "select",
                        values = {
                            ["P"] = L["P"],
                            ["Paragon"] = L["Paragon"]
                        },
                        get = function()
                            return E.db.KlixUI.databars.reputationBar.textFormat
                        end,
                        set = function(info, value)
                            E.db.KlixUI.databars.reputationBar.textFormat = value
                            EDB:UpdateReputation()
                        end,
                    },]]
                    color = {
                        order = 5,
                        name = L["Progress Colour"],
                        desc = L["Change rep bar colour by standing."],
                        type = "select",
                        values = {
                            ["ascii"] = "ASCII",
                            ["blizzard"] = "Blizzard"
                        },
                        get = function()
                            return E.db.KlixUI.databars.reputationBar.color
                        end,
                        set = function(info, value)
                            E.db.KlixUI.databars.reputationBar.color = value
                            EDB:UpdateReputation()
                        end,
                    },
					repColors = {
						order = 20,
						type = "group",
						name = L["Reputation Colors"],
						guiInline = true,
						args = {},
					},
                },
            },
        },
    }
end
T.table_insert(KUI.Config, DataBarTable)

local function BetterReputationColorsTable()
    local db = E.db.KlixUI.betterreputationcolors;
    local order = 1;

    for i = 1, 8 do
        E.Options.args.KlixUI.args.modules.args.databars.args.reputationBar.args.repColors.args[tostring(i)] = {
            type = "color",
			order = order,
			name = T.UnitSex("player") == 3 and _G["FACTION_STANDING_LABEL"..i.."_FEMALE"] or _G["FACTION_STANDING_LABEL"..i],
			hasAlpha = false,
			get = function(info)
				local t = db[i]
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				db[i] = {}
				local t = db[i]
				t.r, t.g, t.b = r, g, b
                KDB:UpdateFactionColors();
			end,
        }
    end
end
T.table_insert(KUI.Config, BetterReputationColorsTable)