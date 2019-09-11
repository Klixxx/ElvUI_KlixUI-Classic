local KUI, T, E, L, V, P, G = unpack(select(2, ...))

function KUI:LoadClassicThreatMeterProfile()
	CTM_Options = {
		["font"] = {
			["shadow"] = true,
			["style"] = "OUTLINE",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["family"] = "Interface\\AddOns\\ClassicThreatMeter\\media\\NotoSans-SemiCondensedBold.ttf",
			["size"] = 12,
		},
		["general"] = {
			["hideOOC"] = false,
			["welcome"] = true,
			["ignorePets"] = false,
			["invertColors"] = false,
			["nameplateThreat"] = false,
			["update"] = 0.1,
			["minimap"] = false,
			["threatColors"] = {
				["good"] = {
					0.2, -- [1]
					0.8, -- [2]
					0.2, -- [3]
				},
				["bad"] = {
					1, -- [1]
					0, -- [2]
					0, -- [3]
				},
				["neutral"] = {
					1, -- [1]
					1, -- [2]
					0, -- [3]
				},
			},
			["hideSolo"] = false,
			["hideInPVP"] = true,
		},
		["warnings"] = {
			["threshold"] = 80,
			["pulledFile"] = "Sound\\Interface\\Aggro_Pulled_Aggro.ogg",
			["sounds"] = true,
			["warningFile"] = "Sound\\Interface\\Aggro_Enter_Warning_State.ogg",
			["visual"] = true,
		},
		["frame"] = {
			["headerShow"] = false,
			["scale"] = 1,
			["width"] = 396,
			["locked"] = true,
			["test"] = false,
			["headerColor"] = {
				0, -- [1]
				0, -- [2]
				0, -- [3]
				0.8, -- [4]
			},
			["height"] = 55,
			["color"] = {
				0, -- [1]
				0, -- [2]
				0, -- [3]
				0.35, -- [4]
			},
			["position"] = {
				"BOTTOMRIGHT", -- [1]
				"UIParent", -- [2]
				"BOTTOMRIGHT", -- [3]
				-11, -- [4]
				195, -- [5]
			},
			["strata"] = "3-MEDIUM",
		},
		["backdrop"] = {
			["bgColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.1, -- [4]
			},
			["bgFile"] = "Interface\\ChatFrame\\ChatFrameBackground",
			["tileSize"] = 0,
			["edgeFile"] = "Interface\\ChatFrame\\ChatFrameBackground",
			["edgeColor"] = {
				0, -- [1]
				0, -- [2]
				0, -- [3]
				1, -- [4]
			},
			["edgeSize"] = 1,
			["inset"] = 0,
			["tile"] = false,
		},
		["bar"] = {
			["descend"] = true,
			["marker"] = false,
			["alpha"] = 1,
			["classColor"] = true,
			["count"] = 3,
			["colorMod"] = 0,
			["height"] = 18,
			["padding"] = 1,
			["defaultColor"] = {
				0.8, -- [1]
				0, -- [2]
				0.8, -- [3]
				1, -- [4]
			},
			["texture"] = "Interface\\ChatFrame\\ChatFrameBackground",
		},
	}
end