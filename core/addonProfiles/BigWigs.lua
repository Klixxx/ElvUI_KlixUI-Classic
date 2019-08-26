local KUI, T, E, L, V, P, G = unpack(select(2, ...))

function KUI:LoadBigWigsProfile()
	BigWigs3DB = {
		["namespaces"] = {
		["BigWigs_Plugins_Victory"] = {
		},
		["BigWigs_Plugins_Colors"] = {
		},
		["BigWigs_Plugins_Alt Power"] = {
			["profiles"] = {
				["KlixUI - DPS"] = {
					["posx"] = 205,
					["posy"] = 450,
					["fontSize"] = 11,
					["disabled"] = true,
					["fontOutline"] = "",
					["fontName"] = "Expressway",
				},
				["KlixUI - Healer"] = {
					["posx"] = 205,
					["posy"] = 450,
					["fontSize"] = 11,
					["disabled"] = true,
					["fontOutline"] = "",
					["fontName"] = "Expressway",
				},
			},
		},
		["BigWigs_Plugins_InfoBox"] = {
			["profiles"] = {
				["KlixUI - DPS"] = {
					["posx"] = 185,
					["posy"] = 355,
				},
				["KlixUI - Healer"] = {
					["posx"] = 185,
					["posy"] = 355,
				},
			},
		},
		["BigWigs_Plugins_BossBlock"] = {
		},
		["BigWigs_Plugins_Bars"] = {
			["profiles"] = {
				["KlixUI - DPS"] = {
					["BigWigsAnchor_width"] = 227,
					["BigWigsAnchor_height"] = 20,
					["BigWigsAnchor_x"] = 421,
					["BigWigsAnchor_y"] = 185,
					["BigWigsEmphasizeAnchor_x"] = 798,
					["BigWigsEmphasizeAnchor_y"] = 185,
					["BigWigsEmphasizeAnchor_width"] = 226,
					["BigWigsEmphasizeAnchor_Height"] = 20,
					["fontSize"] = 11,
					["fontSizeEmph"] = 11,
					["growup"] = false,
					["emphasizeGrowup"] = false,
					["texture"] = "Klix",
					["barStyle"] = "|cfff960d9KlixUI|r",
					["fontName"] = "Expressway",
					["outline"] = "OUTLINE",
					["emphasizeScale"] = 1,
				},
				["KlixUI - Healer"] = {
					["BigWigsAnchor_width"] = 227,
					["BigWigsAnchor_height"] = 20,
					["BigWigsAnchor_x"] = 360.5,
					["BigWigsAnchor_y"] = 219,
					["BigWigsEmphasizeAnchor_x"] = 858,
					["BigWigsEmphasizeAnchor_y"] = 219,
					["BigWigsEmphasizeAnchor_width"] = 226,
					["BigWigsEmphasizeAnchor_Height"] = 20,
					["fontSize"] = 11,
					["fontSizeEmph"] = 11,
					["growup"] = false,
					["emphasizeGrowup"] = false,
					["texture"] = "Klix",
					["barStyle"] = "|cfff960d9KlixUI|r",
					["fontName"] = "Expressway",
					["outline"] = "OUTLINE",
					["emphasizeScale"] = 1,
				},
			},
		},
		["BigWigs_Plugins_Super Emphasize"] = {
			["profiles"] = {
				["KlixUI - DPS"] = {
					["fontName"] = "Expressway",
				},
				["KlixUI - Healer"] = {
					["fontName"] = "Expressway",
				},
			},
		},
		["BigWigs_Plugins_Sounds"] = {
			["profiles"] = {
				["KlixUI - DPS"] = {
					["Long"] = {
					},
					["Warning"] = {
					},
					["Info"] = {
					},
					["Alarm"] = {
					},
					["Alert"] = {
					},
				},
				["KlixUI - Healer"] = {
					["Long"] = {
					},
					["Warning"] = {
					},
					["Info"] = {
					},
					["Alarm"] = {
					},
					["Alert"] = {
					},
				},
			},
		},
		["BigWigs_Plugins_Messages"] = {
			["profiles"] = {
				["KlixUI - DPS"] = {
					["outline"] = "OUTLINE",
					["fontSize"] = 20,
					["BWMessageAnchor_x"] = 612,
					["BWEmphasizeMessageAnchor_x"] = 612,
					["growUpwards"] = false,
					["fontName"] = "Expressway",
					["BWMessageAnchor_y"] = 600,
					["BWEmphasizeMessageAnchor_y"] = 675,
				},
				["KlixUI - Healer"] = {
					["outline"] = "OUTLINE",
					["fontSize"] = 20,
					["BWMessageAnchor_x"] = 612,
					["BWEmphasizeMessageAnchor_x"] = 612,
					["growUpwards"] = false,
					["fontName"] = "Expressway",
					["BWMessageAnchor_y"] = 600,
					["BWEmphasizeMessageAnchor_y"] = 675,
				},
			},
		},
			["BigWigs_Plugins_Statistics"] = {
			},
			["BigWigs_Plugins_Respawn"] = {
			},
			["BigWigs_Plugins_Proximity"] = {
				["profiles"] = {
					["KlixUI - DPS"] = {
						["fontSize"] = 20,
						["fontName"] = "Expressway",
						["posx"] = 300,
						["posy"] = 360,
						["height"] = 120.000007629395,
						["lock"] = true
					},
					["KlixUI - Healer"] = {
						["fontSize"] = 20,
						["fontName"] = "Expressway",
						["posx"] = 300,
						["posy"] = 360,
						["height"] = 120.000007629395,
						["lock"] = true
					},
				},
			},
			["BigWigs_Plugins_Pull"] = {
				["profiles"] = {
					["KlixUI - DPS"] = {
						["voice"] = "Klix - Unreal Tournament 2003",
					},
					["KlixUI - Healer"] = {
						["voice"] = "Klix - Unreal Tournament 2003",
					},
				},
			},	
			["BigWigs_Plugins_Raid Icons"] = {
			},
			["LibDualSpec-1.0"] = {
			},
		},
		["profiles"] = {
			["KlixUI - DPS"] = {
				["fakeDBMVersion"] = true,
			},
			["KlixUI - Healer"] = {
				["fakeDBMVersion"] = true,
			},
		},
	}
	local db = LibStub("AceDB-3.0"):New(BigWigs3DB, nil, true)
	db:SetProfile("KlixUI - DPS")
end
