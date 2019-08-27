local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local PC = KUI:GetModule("PulseCooldown")

local function CooldownTable()
	E.Options.args.KlixUI.args.modules.args.cooldowns = {
		order = 9,
		type = "group",
		name = L["Cooldowns"],
		childGroups = 'tab',
		args = {
			name = {
				order = 1,
				type = "header",
				name = KUI:cOption(L["Cooldowns"]),
			},
			enemy = {
				order = 3,
				type = "group",
				name = L["Enemy"],
				get = function(info) return E.db.KlixUI.cooldowns.enemy[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.cooldowns.enemy[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					desc = {
						order = 1,
						type = "description",
						name = L["EC_DESC"],
					},
					enable = {
						order = 2,
						type = "toggle",
						name = L["Enable"],
					},
					space1 = {
						order = 3,
						type = "description",
						name = "",
					},
					size = {
						order = 4,
						type = "range",
						name = L["Size"],
						min = 5, max = 75, step = 1,
						disabled = function() return not E.db.KlixUI.cooldowns.enemy.enable end,
					},
					direction = {
						order = 5,
						type = "select",
						name = L["Direction"],
						values = {
							["UP"] = L["Up"],
							["DOWN"] = L["Down"],
							["LEFT"] = L["Left"],
							["RIGHT"] = L["Right"],
						},
						disabled = function() return not E.db.KlixUI.cooldowns.enemy.enable end,
					},
					show_always = {
						order = 6,
						type = "toggle",
						name = L["Show Always"],
						desc = L["Show the enemy cooldown spells in every related instance types."],
						disabled = function() return not E.db.KlixUI.cooldowns.enemy.enable end,
					},
					show_inpvp = {
						order = 7,
						type = "toggle",
						name = L["Show In PvP"],
						desc = L["Show the enemy cooldown spells in battlegrounds."],
						disabled = function() return not E.db.KlixUI.cooldowns.enemy.enable end,
					},
					show_inarena = {
						order = 8,
						type = "toggle",
						name = L["Show In Arena"],
						desc = L["Show the enemy cooldown spells in arenas."],
						disabled = function() return not E.db.KlixUI.cooldowns.enemy.enable end,
					},
				},
			},
			pulse = {
				order = 4,
				type = "group",
				name = L["Pulse"],
				get = function(info) return E.db.KlixUI.cooldowns.pulse[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.cooldowns.pulse[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					toggle = {
						order = 2,
						type = "toggle",
						name = L["Enable"],
						desc = L["Pulse"],
						get = function() return E.db.KlixUI.cooldowns.pulse.enable ~= false or false end,
						set = function(info, v) E.db.KlixUI.cooldowns.pulse.enable = v if v then PC:EnableCooldownFlash() else PC:DisableCooldownFlash() end E:StaticPopup_Show("PRIVATE_RL"); end,
					},
					test = {
						order = 3,
						name = L["Test"],
						type = "execute",
						func = function() PC:TestMode() end,
						hidden = function() return not E.db.KlixUI.cooldowns.pulse.enable end,
					},
					space1 = {
						order = 4,
						type = "description",
						name = "",
					},
					iconSize = {
						order = 5,
						name = L["Icon Size"],
						type = "range",
						min = 30, max = 125, step = 1,
						set = function(info, value) E.db.KlixUI.cooldowns.pulse[ info[#info] ] = value; PC.DCP:SetSize(value, value) end,
						hidden = function() return not E.db.KlixUI.cooldowns.pulse.enable end,
					},
					fadeInTime = {
						order = 6,
						name = L["Fadein duration"],
						type = "range",
						min = 0.5, max = 2.5, step = 0.1,
						hidden = function() return not E.db.KlixUI.cooldowns.pulse.enable end,
					},
					fadeOutTime = {
						order = 7,
						name = L["Fadeout duration"],
						type = "range",
						min = 0.5, max = 2.5, step = 0.1,
						hidden = function() return not E.db.KlixUI.cooldowns.pulse.enable end,
					},
					maxAlpha = {
						order = 8,
						name = L["Transparency"],
						type = "range",
						min = 0.25, max = 1, step = 0.05,
						isPercent = true,
						hidden = function() return not E.db.KlixUI.cooldowns.pulse.enable end,
					},
					holdTime = {
						order = 9,
						name = L["Duration time"],
						type = "range",
						min = 0.3, max = 2.5, step = 0.1,
						hidden = function() return not E.db.KlixUI.cooldowns.pulse.enable end,
					},
					animScale = {
						order = 10,
						name = L["Animation size"],
						type = "range",
						min = 0.5, max = 2, step = 0.1,
						hidden = function() return not E.db.KlixUI.cooldowns.pulse.enable end,
					},
					showSpellName = {
						order = 11,
						name = L["Display spell name"],
						type = "toggle",
						hidden = function() return not E.db.KlixUI.cooldowns.pulse.enable end,
					},
					enablePet = {
						order = 12,
						name = L["Watch on pet spell"],
						type = "toggle",
						get = function(info) return E.db.KlixUI.cooldowns.pulse[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.cooldowns.pulse[ info[#info] ] = value; if value then PC.DCP:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") else PC.DCP:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED") end end,
						hidden = function() return not E.db.KlixUI.cooldowns.pulse.enable end,
					},
				},
			},
		},		
	}
end
T.table_insert(KUI.Config, CooldownTable)