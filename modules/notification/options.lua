local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local NF = KUI:GetModule("Notification")

local function NotificationTable()
	E.Options.args.KlixUI.args.modules.args.notification = {
		type = "group",
		order = 21,
		name = L["Notification"],
		get = function(info) return E.db.KlixUI.notification[ info[#info] ] end,
		set = function(info, value) E.db.KlixUI.notification[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = KUI:cOption(L["Notification"]),
			},
			general = {
				order = 2,
				type = "group",
				guiInline = true,
				name = L["General"],
				args = {
					desc = {
						order = 1,
						type = "description",
						name = L["NOTIFY_DESC"],
						disabled = function() return not E.db.KlixUI.notification.enable end,
						hidden = function() return not E.db.KlixUI.notification.enable end,
					},
					enable = {
						order = 2,
						type = "toggle",
						width = "full",
						name = L["Enable"],
					},
					width = {
						order = 3,
						type = 'range',
						name = L['Width'],
						min = 100, max = 500, step = 1,
						disabled = function() return not E.db.KlixUI.notification.enable end,
						hidden = function() return not E.db.KlixUI.notification.enable end,
					},
					height = {
						order = 4,
						type = 'range',
						name = L['Height'],
						min = 50, max = 250, step = 1,
						disabled = function() return not E.db.KlixUI.notification.enable end,
						hidden = function() return not E.db.KlixUI.notification.enable end,
					},
					fontSize = {
						order = 5,
						type = 'range',
						name = L['Font Size'],
						min = 5, max = 20, step = 1,
						disabled = function() return not E.db.KlixUI.notification.enable end,
						hidden = function() return not E.db.KlixUI.notification.enable end,
					},
					raid = {
						order = 6,
						type = "toggle",
						name = L["Raid Disabler"],
						desc = L["Enable/disable the notification toasts while in a raid group."],
						disabled = function() return not E.db.KlixUI.notification.enable end,
						hidden = function() return not E.db.KlixUI.notification.enable end,
					},
					noSound = {
						order = 7,
						type = "toggle",
						name = L["No Sounds"],
						desc = L["Enable/disable the sound effect of the notification toasts."],
						disabled = function() return not E.db.KlixUI.notification.enable end,
						hidden = function() return not E.db.KlixUI.notification.enable end,
					},
					message = {
						order = 8,
						type = "toggle",
						name = L["Chat Message"],
						desc = L["Enable/disable the notification message in chat."],
						disabled = function() return not E.db.KlixUI.notification.enable end,
						hidden = function() return not E.db.KlixUI.notification.enable end,
					},
					mail = {
						order = 9,
						type = "toggle",
						name = L["Mail"],
						disabled = function() return not E.db.KlixUI.notification.enable end,
						hidden = function() return not E.db.KlixUI.notification.enable end,
					},
					vignette = {
						order = 10,
						type = "toggle",
						name = L["Vignette"],
						desc = L["If a Rare Mob or a treasure gets spotted on the minimap."],
						disabled = function() return not E.db.KlixUI.notification.enable end,
						hidden = function() return not E.db.KlixUI.notification.enable end,
					},
					invites = {
						order = 11,
						type = "toggle",
						name = L["Invites"],
						disabled = function() return not E.db.KlixUI.notification.enable end,
						hidden = function() return not E.db.KlixUI.notification.enable end,
					},
					guildEvents = {
						order = 12,
						type = "toggle",
						name = L["Guild Events"],
						disabled = function() return not E.db.KlixUI.notification.enable end,
						hidden = function() return not E.db.KlixUI.notification.enable end,
					},
					quickJoin = {
						order = 13,
						type = "toggle",
						name = L["Quick Join Notification"],
						disabled = function() return not E.db.KlixUI.notification.enable end,
						hidden = function() return not E.db.KlixUI.notification.enable end,
					},
				},
			},
		},
	}
end
T.table_insert(KUI.Config, NotificationTable)