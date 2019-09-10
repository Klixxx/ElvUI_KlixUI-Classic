local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local SCT = KUI:GetModule("ScrollingCombatText")

local function rgbToHex(r, g, b)
    return T.string_format("%02x%02x%02x", T.math_floor(255 * r), T.math_floor(255 * g), T.math_floor(255 * b));
end

local function hexToRGB(hex)
    return T.tonumber(hex:sub(1,2), 16)/255, T.tonumber(hex:sub(3,4), 16)/255, T.tonumber(hex:sub(5,6), 16)/255, 1;
end

local iconValues = {
    ["none"] = L["No Icons"],
    ["left"] = L["Left Side"],
    ["right"] = L["Right Side"],
    ["both"] = L["Both Sides"],
    ["only"] = L["Icons Only (No Text)"],
};

local animationValues = {
    -- ["shake"] = "Shake",
    ["verticalUp"] = L["Vertical Up"],
    ["verticalDown"] = L["Vertical Down"],
    ["fountain"] = L["Fountain"],
    ["rainfall"] = L["Rainfall"],
	["disabled"] = L["Disabled"],
};

local fontFlags = {
    [""] = "None",
    ["OUTLINE"] = "Outline",
    ["THICKOUTLINE"] = "Thick Outline",
    ["nil, MONOCHROME"] = "Monochrome",
    ["OUTLINE , MONOCHROME"] = "Monochrome Outline",
    ["THICKOUTLINE , MONOCHROME"] = "Monochrome Thick Outline",
};

local function CombatTextTable()
	E.Options.args.KlixUI.args.modules.args.combattext = {
		type = "group",
		order = 8,
		name = L["Combat Text"],
		childGroups = "tab",
		disabled = function() return T.IsAddOnLoaded("NameplateSCT") or T.IsAddOnLoaded("ElvUI_FCT") end,
		hidden = function() return T.IsAddOnLoaded("NameplateSCT") or T.IsAddOnLoaded("ElvUI_FCT") end,
		get = function(info) return E.db.KlixUI.combattext[ info[#info] ] end,
		set = function(info, value) E.db.KlixUI.combattext[ info[#info] ] = value; end,
		args = {
			enable = {
				order = 1,
				type = "toggle",
				width = "half",
				name = L["Enable"],
				get = function(info) return E.db.KlixUI.combattext.enable end,
				set = function(info, value) E.db.KlixUI.combattext.enable = value; E:StaticPopup_Show("PRIVATE_RL"); end,
			},
			disableBlizzardFCT = {
				order = 2,
				type = "toggle",
				name = L["Disable Blizzard FCT"],
				desc = "",
				get = function(_, newValue) return GetCVar("floatingCombatTextCombatDamage") == "0" end,
				set = function(info, value)
					if (value) then
						SetCVar("floatingCombatTextCombatDamage", "0")
					else
						SetCVar("floatingCombatTextCombatDamage", "1")
					end
				end,
			},
			personalNameplate = {
				order = 3,
				type = "toggle",
				name = L["Personal SCT"],
				desc = L["Also show numbers when you take damage on your personal nameplate or in the center of the screen."],
				get = function(info) return E.db.KlixUI.combattext.personal end,
				set = function(info, value) E.db.KlixUI.combattext.personal = value; end,
			},
			animations = {
				order = 30,
				type = "group",
				name = L["Animations"],
				disabled = function() return not E.db.KlixUI.combattext.enable; end,
				get = function(info) return E.db.KlixUI.combattext.animations[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.combattext.animations[ info[#info] ] = value; end,
				args = {
					ability = {
						order = 1,
						type = "select",
						name = L["Abilities"],
						values = animationValues,
					},
					crit = {
						order = 2,
						type = "select",
						name = L["Criticals"],
						values = animationValues,
					},
					miss = {
						order = 3,
						type = "select",
						name = L["Miss/Parry/Dodge/etc."],
						values = animationValues,
					},
					autoattack = {
						type = 'select',
						name = L["Auto Attacks"],
						desc = "",
						values = animationValues,
						order = 4,
					},
					autoattackcrit = {
						type = 'select',
						name = L["Critical"],
						desc = L["Auto attacks that are critical hits"],
						values = animationValues,
						order = 5,
					},
				},
			},
			animationsPersonal = {
				order = 40,
				type = "group",
				name = L["Personal SCT Animations"],
				hidden = function() return not E.db.KlixUI.combattext.personal; end,
				disabled = function() return not E.db.KlixUI.combattext.enable; end;
				get = function(info) return E.db.KlixUI.combattext.animationsPersonal[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.combattext.animationsPersonal[ info[#info] ] = value; end,
				args = {
					normal = {
						order = 1,
						type = "select",
						name = L["Default"],
						values = animationValues,
					},
					crit = {
						order = 2,
						type = "select",
						name = L["Criticals"],
						values = animationValues,
					},
					miss = {
						order = 3,
						type = "select",
						name = L["Miss/Parry/Dodge/etc."],
						values = animationValues,
					},
				},
			},
			appearance = {
				order = 50,
				type = "group",
				name = L["Appearance/Offsets"],
				disabled = function() return not E.db.KlixUI.combattext.enable; end,
				get = function(info) return E.db.KlixUI.combattext[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.combattext[ info[#info] ] = value; end,
				args = {
					font = {
						order = 1,
						type = "select",
						dialogControl = "LSM30_Font",
						name = L["Font"],
						values = AceGUIWidgetLSMlists.font,
					},
					fontFlag = {
						order = 2,
						type = "select",
						name = L["Font Outline"],
						values = fontFlags,
					},
					fontShadow = {
						order = 3,
						type = "toggle",
						name = L["Font Shadow"],
					},
					space1 = {
						order = 4,
						type = "description",
						name = "",
					},
					damageColor = {
						order = 5,
						type = "toggle",
						name = L["Use Damage Type Color"],
					},
					defaultColor = {
						order = 6,
						type = "color",
						name = L["Default Color"],
						hasAlpha = false,
						disabled = function() return E.db.KlixUI.combattext.damageColor end,
						get = function(info) return hexToRGB(E.db.KlixUI.combattext.defaultColor); end,
						set = function(_, r, g, b) E.db.KlixUI.combattext.defaultColor = rgbToHex(r, g, b); end,
					},
					space2 = {
						order = 7,
						type = "description",
						name = "",
					},
					xOffset = {
						order = 10,
						type = "range",
						width = 1.5,
						name = L["X-Offset"],
						desc = L["Has soft min/max, you can type whatever you'd like into the editbox tho."],
						softMin = -75, softMax = 75, step = 1,
					},
					yOffset = {
						order = 11,
						type = "range",
						width = 1.5,
						name = L["Y-Offset"],
						desc = L["Has soft min/max, you can type whatever you'd like into the editbox tho."],
						softMin = -75, softMax = 75, step = 1,
					},
					space3 = {
						order = 12,
						type = "description",
						name = "",
					},
					damageColorPersonal = {
						order = 13,
						type = "toggle",
						name = L["Use Damage Type Color"],
					},

					defaultColorPersonal = {
						order = 14,
						type = "color",
						name = L["Default Color"],
						hasAlpha = false,
						disabled = function() return E.db.KlixUI.combattext.damageColorPersonal end,
						set = function(_, r, g, b) E.db.KlixUI.combattext.defaultColorPersonal = rgbToHex(r, g, b) end,
						get = function() return hexToRGB(E.db.KlixUI.combattext.defaultColorPersonal) end,
					},
					space4 = {
						order = 15,
						type = "description",
						name = "",
					},
					xOffsetPersonal = {
						order = 16,
						type = "range",
						width = 1.5,
						name = L["X-Offset Personal SCT"],
						desc = L["Only used if Personal Nameplate is Disabled."],
						softMin = -400, softMax = 400, step = 1,
					},
					yOffsetPersonal = {
						order = 17,
						type = "range",
						width = 1.5,
						name = L["Y-Offset Personal SCT"],
						desc = L["Only used if Personal Nameplate is Disabled."],
						softMin = -400, softMax = 400, step = 1,
					},
				},
			},
			formatting = {
				order = 90,
				type = "group",
				name = L["Text Formatting"],
				disabled = function() return not E.db.KlixUI.combattext.enable; end,
				get = function(info) return E.db.KlixUI.combattext.formatting[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.combattext.formatting[ info[#info] ] = value; end,
				args = {
					truncate = {
						order = 1,
						type = "toggle",
						name = L["Truncate Number"],
						desc = L["Condense combat text numbers."],
						get = function(info) return E.db.KlixUI.combattext.truncate; end,
						set = function(info, value) E.db.KlixUI.combattext.truncate = value; end,
					},
					truncateLetter = {
						order = 2,
						type = "toggle",
						name = L["Show Truncated Letter"],
						desc = "",
						disabled = function() return not E.db.KlixUI.combattext.enable or not E.db.KlixUI.combattext.truncate; end,
						get = function(info) return E.db.KlixUI.combattext.truncateLetter; end,
						set = function(info, value) E.db.KlixUI.combattext.truncateLetter = value; end,
					},
					commaSeperate = {
						order = 3,
						type = "toggle",
						name = L["Comma Seperate"],
						desc = L["e.g. 100000 -> 100,000"],
						disabled = function() return not E.db.KlixUI.combattext.enable or E.db.KlixUI.combattext.truncate; end,
						get = function(info) return E.db.KlixUI.combattext.commaSeperate; end,
						set = function(info, value) E.db.KlixUI.combattext.commaSeperate = value; end,
					},
					icon = {
						order = 51,
						type = "select",
						name = L["Icon"],
						values = iconValues,
					},
					size = {
						order = 52,
						type = "range",
						name = L["Size"],
						min = 5, max = 72, step = 1,
					},
					alpha = {
						order = 53,
						type = "range",
						name = L["Start Alpha"],
						min = 0.1, max = 1, step = .01,
					},
					useOffTarget = {
						order = 100,
						type = "toggle",
						width = "full",
						name = L["Use Seperate Off-Target Text Appearance"],
						get = function(info) return E.db.KlixUI.combattext.useOffTarget; end,
						set = function(info, value) E.db.KlixUI.combattext.useOffTarget = value; end,
					},
					offTarget = {
						order = 101,
						type = "group",
						name = L["Off-Target Text Appearance"],
						guiInline = true,
						hidden = function() return not E.db.KlixUI.combattext.useOffTarget; end,
						get = function(info) return E.db.KlixUI.combattext.offTargetFormatting[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.combattext.offTargetFormatting[ info[#info] ] = value; end,
						args = {
							icon = {
								order = 1,
								type = "select",
								name = L["Icon"],
								values = iconValues,
							},
							size = {
								order = 2,
								type = "range",
								name = L["Size"],
								min = 5, max = 72, step = 1,
							},
							alpha = {
								order = 3,
								type = "range",
								name = L["Start Alpha"],
								min = 0.1, max = 1, step = .01,
							},
						},
					},
				},
			},
			sizing = {
				order = 100,
				type = "group",
				name = L["Sizing Modifiers"],
				disabled = function() return not E.db.KlixUI.combattext.enable; end,
				get = function(info) return E.db.KlixUI.combattext.sizing[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.combattext.sizing[ info[#info] ] = value; end,
				args = {
					crits = {
						order = 1,
						type = "toggle",
						name = L["Embiggen Crits"],
					},
					autoattackcritsizing = {
						type = 'toggle',
						name = L["Embiggen Auto Attack Crits"],
						desc = L["Embiggen critical auto attacks"],
						order = 2,
					},
					critsScale = {
						order = 3,
						type = "range",
						width = "double",
						name = L["Embiggen Crits Scale"],
						min = 1, max = 3, step = .01,
						disabled = function() return not E.db.KlixUI.combattext.enable or not E.db.KlixUI.combattext.sizing.crits; end,
					},
					miss = {
						order = 10,
						type = "toggle",
						name = L["Embiggen Miss/Parry/Dodge/etc."],
					},
					missScale = {
						order = 11,
						type = "range",
						width = "double",
						name = L["Embiggen Miss/Parry/Dodge/etc. Scale"],
						min = 1, max = 3, step = .01,
						disabled = function() return not E.db.KlixUI.combattext.enable or not E.db.KlixUI.combattext.sizing.miss; end,
					},
					smallHits = {
						order = 20,
						type = "toggle",
						name = L["Scale Down Small Hits"],
						desc = L["Scale down hits that are below a running average of your recent damage output"],
					},
					smallHitsScale = {
						order = 21,
						type = "range",
						width = "double",
						name = L["Small Hits Scale"],
						min = 0.33, max = 1, step = .01,
						disabled = function() return not E.db.KlixUI.combattext.enable or not E.db.KlixUI.combattext.sizing.smallHits or E.db.KlixUI.combattext.sizing.smallHitsHide; end,
					},
					smallHitsHide = {
						type = 'toggle',
						name = L["Hide Small Hits"],
						desc = L["Hide hits that are below a running average of your recent damage output"],
						order = 22,
					},
				},
			},
		},
	}
end
T.table_insert(KUI.Config, CombatTextTable)