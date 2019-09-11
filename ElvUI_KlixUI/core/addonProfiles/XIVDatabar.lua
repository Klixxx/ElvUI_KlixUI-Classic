local KUI, T, E, L, V, P, G = unpack(select(2, ...))

function KUI:LoadXIVProfile()
	XIVBarDB = {
		["profiles"] = {
			["Klix"] = {
				["modules"] = {
					["tradeskill"] = {
						["barCC"] = true,
					},
					["talent"] = {
						["barCC"] = true,
					},
					["currency"] = {
						["xpBarCC"] = true,
						["currencyTwo"] = "1220",
						["currencyOne"] = "1273",
					},
					["clock"] = {
						["timeFormat"] = "twoFour",
					},
					["MasterVolume"] = {
						["enabled"] = true,
					},
				},
				["text"] = {
					["flags"] = 2,
					["fontSize"] = 10,
					["font"] = "Expressway",
				},
				["general"] = {
					["moduleSpacing"] = 25,
					["barPosition"] = "TOP",
				},
				["color"] = {
					["barColor"] = {
						["a"] = 0.40,
						["r"] = 0,
						["g"] = 0,
						["b"] = 0,
					},
				},
			},
		},
	}
	local db = LibStub("AceDB-3.0"):New(XIVBarDB, nil, true)
	db:SetProfile("Klix")
end
