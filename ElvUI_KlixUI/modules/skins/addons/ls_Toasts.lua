local KUI, T, E, L, V, P, G = unpack(select(2, ...))

if not T.IsAddOnLoaded("ls_Toasts") then return end
local LST = T.unpack(ls_Toasts)

LST:RegisterSkin("KlixUI", {
	name = "|cfff960d9KlixUI|r",
	template = "elv-no-art",
	border = {
		texture = {0, 0, 0, 0.75},
	},
	icon = {
		tex_coords = {.08, .92, .08, .92},
	},
	icon_border = {
		offset = 1,
		texture = {1, 1, 1, 1},
	},
	icon_highlight = {
		hidden = true,
	},
	icon_text_1 = {
		flags = "OUTLINE",
	},
	icon_text_2 = {
		flags = "OUTLINE",
	},
	dragon = {
		hidden = true,
	},
	slot = {
		tex_coords = {.08, .92, .08, .92},
	},
	slot_border = {
		color = {0, 0, 0},
		offset = 0,
		size = 1,
		texture = {1, 1, 1, 1},
	},
	shine = {
		tex_coords = {403 / 512, 465 / 512, 15 / 256, 61 / 256},
		size = {67, 50},
		point = {
			y = -1,
		},
	},
	bg = {
		default = {
			color = {0, 0, 0, 0.75},
			texture = {0, 0, 0, 0.75},
			tex_coords = {1 / 512, 449 / 512, 1 / 128, 97 / 128},
			tile = true,
		},
	},
})

LST.RegisterCallback({}, "SetSkin", function(_, toast)
	if not toast.skinned then
		toast:Styling()
		toast.skinned = true
	end
end)