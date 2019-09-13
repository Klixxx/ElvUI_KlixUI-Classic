local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local B = KUI:GetModule("Blizzard")

local function BlizzardTable()
	E.Options.args.KlixUI.args.modules.args.blizzard = {
		order = 6,
		type = "group",
		name = L["Blizzard"],
		disabled = function() return T.IsAddOnLoaded("ElvUI_SLE") end,
		hidden = function() return T.IsAddOnLoaded("ElvUI_SLE") end,
		args = {
			header = {
				order = 1,
				type = "header",
				name = KUI:cOption(L["Blizzard"]),
			},
			rumouseover = {
				order = 2,
				type = "toggle",
				name = L["Raid Utility Mouse Over"],
				desc = L["Enabling mouse over will make ElvUI's raid utility show on mouse over instead of always showing."],
				get = function(info) return E.db.KlixUI.blizzard.rumouseover end,
				set = function(info, value) E.db.KlixUI.blizzard.rumouseover = value; B:RUReset() end,
			},
			errorframe = {
				order = 5,
				type = "group",
				name = L["Error Frame"],
				guiInline = true,
				get = function(info) return E.db.KlixUI.blizzard.errorframe[ info[#info] ] end,
				set = function(info, value) E.db.KlixUI.blizzard.errorframe[ info[#info] ] = value; B:ErrorFrameSize() end,
				args = {
					width = {
						order = 1,
						name = L["Width"],
						desc = L["Set the width of Error Frame. Too narrow frame may cause messages to be split in several lines"],
						type = "range",
						min = 100, max = 1000, step = 1,
					},
					height = {
						order = 2,
						name = L["Height"],
						desc = L["Set the height of Error Frame. Higher frame can show more lines at once."],
						type = "range",
						min = 30, max = 300, step = 15,
					},
				},
			},
			blizzmove = {
				order = 6,
				type = "group",
				name = L["Move Blizzard frames"],
				guiInline = true,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Allow some Blizzard frames to be moved around."],
						get = function(info) return E.private.KlixUI.module.blizzmove.enable end,
						set = function(info, value) E.private.KlixUI.module.blizzmove.enable = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
					remember = {
						order = 2,
						type = "toggle",
						name = L["Remember"],
						desc = L["Remember positions of frames after moving them."],
						get = function(info) return E.private.KlixUI.module.blizzmove.remember end,
						set = function(info, value) E.private.KlixUI.module.blizzmove.remember = value; E:StaticPopup_Show("PRIVATE_RL") end,
						disabled = function() return not E.private.KlixUI.module.blizzmove.enable end,
					},
				},
			},
		},
	}
end
tinsert(KUI.Config, BlizzardTable)