local KUI, T, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: MasqueDB, LibStub

local playerName = UnitName("player")
local profileName = playerName.."-KUI"
local KlixTitle = "|cfff960d9KlixUI|r"

function KUI:LoadMasqueProfile()
	--[[----------------------------------
	--	Masque - Settings | Note: You have to create a seperate profile for each class to use the class color.
	--]]----------------------------------
	MasqueDB.profiles[profileName] = {
		["Groups"] = {
			["ElvUI"] = {
				["Colors"] = {
					["Normal"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
						1, -- [4]
					},
				},
				["SkinID"] = KlixTitle,
				["Gloss"] = 0,
			},
			["ElvUI_Buffs"] = {
				["Colors"] = {
					["Normal"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
						1, -- [4]
					},
				},
				["SkinID"] = KlixTitle,
				["Gloss"] = 0,
			},
			["ElvUI_Debuffs"] = {
				["Colors"] = {
					["Normal"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
						1, -- [4]
					},
				},
				["SkinID"] = KlixTitle,
				["Gloss"] = 0,
			},
			["ElvUI_Pet Bar"] = {
				["Gloss"] = 0,
				["SkinID"] = KlixTitle,
				["Backdrop"] = {
					["Backdrop"] = true,
					["Color"] = {
						0.07, -- [1]
						0.07, -- [2]
						0.07, -- [3]
						1, -- [4]
					},
				},
				["Colors"] = {
					["Normal"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
						1, -- [4]
					},
				},
			},
			["ElvUI_Consolidated Buffs"] = {
				["Gloss"] = 0,
				["SkinID"] = KlixTitle,
				["Colors"] = {
					["Normal"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
						1, -- [4]
					},
				},
			},
			["Masque"] = {
				["Gloss"] = 0,
				["SkinID"] = KlixTitle,
				["Colors"] = {
					["Normal"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
						1, -- [4]
					},
				},
			},
			["ElvUI_ActionBars"] = {
				["Gloss"] = 0,
				["SkinID"] = KlixTitle,
				["Backdrop"] = {
					["Backdrop"] = true,
					["Color"] = {
						0.07, -- [1]
						0.07, -- [2]
						0.07, -- [3]
						1, -- [4]
					},
				},
				["Colors"] = {
					["Normal"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
						1, -- [4]
					},
				},
			},
		},
		["LDB"] = {
			["hide"] = false,
		},
	}

	-- Profile creation
	local db = LibStub("AceDB-3.0"):New(MasqueDB)
	db:SetProfile(profileName)
end