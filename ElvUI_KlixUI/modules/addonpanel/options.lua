local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local AP = KUI:GetModule("AddonControlPanel")

local function AddonPanelTable()
	E.Options.args.KlixUI.args.modules.args.addonpanel = {
		type = "group",
		order = 2,
		name = L["Addon Control Panel"],
		disabled = function() return T.IsAddOnLoaded("ProjectAzilroka") end,
		hidden = function() return T.IsAddOnLoaded("ProjectAzilroka") end,
		get = function(info) return E.db.KlixUI.addonpanel[ info[#info] ] end,
		set = function(info, value) E.db.KlixUI.addonpanel[ info[#info] ] = value; AP:Update() end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = KUI:cOption(L["Addon Control Panel"]),
			},
			general = {
				order = 2,
				type = "group",
				guiInline = true,
				name = L["General"],
				args = {
					Enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						set = function(info, value) E.db.KlixUI.addonpanel[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
					},
					Space1 = {
						order = 2,
						type = "description",
						name = "",
					},
					Space2 = {
						order = 3,
						type = "description",
						name = "",
					},
					NumAddOns = {
						order = 4,
						type = 'range',
						name = L['# Shown AddOns'],
						min = 3, max = 30, step = 1,
						disabled = function() return not E.db.KlixUI.addonpanel.Enable end,
					},
					FrameWidth = {
						order = 5,
						type = 'range',
						name = L['Frame Width'],
						min = 225, max = 1024, step = 1,
						disabled = function() return not E.db.KlixUI.addonpanel.Enable end,
					},
					ButtonHeight = {
						order = 6,
						type = 'range',
						name = L['Button Height'],
						min = 3, max = 30, step = 1,
						disabled = function() return not E.db.KlixUI.addonpanel.Enable end,
					},
					ButtonWidth = {
						order = 7,
						type = 'range',
						name = L['Button Width'],
						min = 3, max = 30, step = 1,
						disabled = function() return not E.db.KlixUI.addonpanel.Enable end,
					},
					Font = {
						type = 'select', dialogControl = 'LSM30_Font',
						order = 8,
						name = L['Font'],
						values = E.LSM:HashTable('font'),
						disabled = function() return not E.db.KlixUI.addonpanel.Enable end,
					},
					FontSize = {
						order = 9,
						name = FONT_SIZE,
						type = 'range',
						min = 6, max = 22, step = 1,
						disabled = function() return not E.db.KlixUI.addonpanel.Enable end,
					},
					FontFlag = {
						order = 10,
						name = L['Font Outline'],
						type = 'select',
						values = {
							['NONE'] = 'None',
							['OUTLINE'] = 'OUTLINE',
							['MONOCHROME'] = 'MONOCHROME',
							['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
							['THICKOUTLINE'] = 'THICKOUTLINE',
						},
						disabled = function() return not E.db.KlixUI.addonpanel.Enable end,
					},
					FontColor = {
						order = 11,
						type = "select",
						name = COLOR,
						values = {
							[1] = CLASS_COLORS,
							[2] = CUSTOM,
							[3] = L["Value Color"],
						},
						disabled = function() return not E.db.KlixUI.addonpanel.Enable end,
					},
					FontCustomColor = {
						order = 12,
						type = "color",
						name = L["Font Color"],
						disabled = function() return E.db.KlixUI.addonpanel.FontColor == 1 or E.db.KlixUI.addonpanel.FontColor == 3 or not E.db.KlixUI.addonpanel.Enable end,
						get = function(info)
							local t = E.db.KlixUI.addonpanel[ info[#info] ]
							local d = E.db.KlixUI.addonpanel[info[#info]]
							return t.r, t.g, t.b, t.a, d.r, d.g, d.b
							end,
						set = function(info, r, g, b)
							E.db.KlixUI.addonpanel[ info[#info] ] = {}
							local t = E.db.KlixUI.addonpanel[ info[#info] ]
							t.r, t.g, t.b, t.a = r, g, b, a
							AP:Update()
						end,
					},
					CheckTexture = {
						order = 13,
						type = 'select', dialogControl = 'LSM30_Statusbar',
						name = L['Texture'],
						values = E.LSM:HashTable('statusbar'),
						disabled = function() return not E.db.KlixUI.addonpanel.Enable end,
					},
					CheckColor = {
						order = 14,
						type = 'color',
						name = COLOR_PICKER,
						hasAlpha = true,
						get = function(info) return unpack(E.db.KlixUI.addonpanel[info[#info]]) end,
						set = function(info, r, g, b, a) E.db.KlixUI.addonpanel[info[#info]] = { r, g, b, a} AP:Update() end,
						disabled = function() return not E.db.KlixUI.addonpanel.Enable or E.db.KlixUI.addonpanel['ClassColor'] end,
					},
					ClassColor = {
						order = 15,
						type = 'toggle',
						name = L['Class Color Check Texture'],
						disabled = function() return not E.db.KlixUI.addonpanel.Enable end,
					},
				},
			},
		},
	}
end
T.table_insert(KUI.Config, AddonPanelTable)