local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KC = KUI:GetModule("KuiChat")
local CH = E:GetModule("Chat")

local function ChatTable()
	E.Options.args.KlixUI.args.modules.args.chat = {
		order = 7,
		type = 'group',
		name = L['Chat'],
		args = {
			name = {
				order = 1,
				type = "header",
				name = KUI:cOption(L['Chat']),
			},
			chattabs = {
				order = 2,
				type = 'group',
				name = L['Chat Tabs'],
				guiInline = true,
				args = {
					select = {
						order = 1,
						type = "toggle",
						name = L["Selected Indicator"],
						desc = L["Shows you which of your docked chat tabs which is currently selected."],
						get = function(info) return E.db.KlixUI.chat[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.chat[ info[#info] ] = value; KC:SetSelectedTab(true) end,
					},
					styleTab = {
						order = 2,
						type = "select",
						name = L["Style"],
						values = {
							["DEFAULT"] = "|cff0CD809>|r "..NAME.." |cff0CD809<|r",
							["SQUARE"] = "|cff0CD809[|r "..NAME.." |cff0CD809]|r",
							["BEND"] = "|cff0CD809(|r "..NAME.." |cff0CD809)|r",
							["HALFDEFAULT"] = "|cff0CD809>|r "..NAME,
							["CHECKBOX"] = [[|TInterface\ACHIEVEMENTFRAME\UI-Achievement-Criteria-Check:26|t]]..NAME,
							["ARROWRIGHT"] = [[|TInterface\BUTTONS\UI-SpellbookIcon-NextPage-Up:26|t]]..NAME,
							["ARROWDOWN"] = [[|TInterface\BUTTONS\UI-MicroStream-Green:26|t]]..NAME,
						},
						disabled = function() return not E.db.KlixUI.chat.select end,
						get = function(info) return E.db.KlixUI.chat[ info[#info] ] end,
						set = function(info, value) E.db.KlixUI.chat[ info[#info] ] = value; KC:SetSelectedTab(true) end,
					},
					colorTab = {
						type = 'color',
						order = 3,
						name = COLOR,
						hasAlpha = false,
						disabled = function() return not E.db.KlixUI.chat.select or not (E.db.KlixUI.chat.styleTab == "DEFAULT" or E.db.KlixUI.chat.styleTab == "SQUARE" or E.db.KlixUI.chat.styleTab == "BEND" or E.db.KlixUI.chat.styleTab == "HALFDEFAULT") end,
						get = function(info)
							local t = E.db.KlixUI.chat[ info[#info] ]
							local d = P.KlixUI.chat[info[#info]]
							return t.r, t.g, t.b, d.r, d.g, d.b
						end,
						set = function(info, r, g, b)
							E.db.KlixUI.chat[ info[#info] ] = {}
							local t = E.db.KlixUI.chat[ info[#info] ]
							t.r, t.g, t.b = r, g, b
							KC:SetSelectedTab(true)
						end,
					},
					fade = {
						order = 4,
						type = 'toggle',
						name = L['Fade Chat Tabs'],
						desc = L['Fade out chat tabs except the currently selected chat tab.'],
						disabled = function() return not E.db.KlixUI.chat.select end,
						get = function(info) return E.db.KlixUI.chat.fadeChatTabs end,
						set = function(info, value) E.db.KlixUI.chat.fadeChatTabs = value; KC:SetSelectedTab(); end,
					},
					fadeAlpha = {
						order = 5,
						type = 'range',
						name = L['Chat Tab Alpha'],
						desc = L['Alpha of faded chat tabs.'],
						min = 0, max = 1, step = 0.05,
						disabled = function() return not E.db.KlixUI.chat.select or not E.db.KlixUI.chat.fadeChatTabs end,
						get = function(info) return E.db.KlixUI.chat.fadedChatTabAlpha end,
						set = function(info, value) E.db.KlixUI.chat.fadedChatTabAlpha = value; KC:SetSelectedTab(); end,
					},
					spacer = {
						order = 6,
						type = 'description',
						name = '',
					},
					forceShow = {
						order = 7,
						type = 'toggle',
						name = L['Force to Show'],
						desc = L['Force a tab to show when it is flashing. This works both for when chat panel backdrop is hidden and when chat tab is faded.'],
						disabled = function() return not E.db.KlixUI.chat.select end,
						get = function(info) return E.db.KlixUI.chat.forceShow end,
						set = function(info, value) E.db.KlixUI.chat.forceShow = value; KC:SetSelectedTab(); end,
					},
					forceShowBelowAlpha = {
						order = 8,
						type = 'range',
						name = L['Force Show Threshold'],
						desc = L['Threshold before a faded chat tab is forced to show. If a faded chat tab alpha is less than or equal to this value then it will be forced to show.'],
						min = 0, max = 1, step = 0.05,
						disabled = function() return not E.db.KlixUI.chat.select or not E.db.KlixUI.chat.forceShow end,
						get = function(info) return E.db.KlixUI.chat.forceShowBelowAlpha end,
						set = function(info, value) E.db.KlixUI.chat.forceShowBelowAlpha = value; end,
					},
					forceShowToAlpha = {
						order = 9,
						type = 'range',
						name = L['Force Show Alpha'],
						desc = L['Alpha of a chat tab when it is forced to show.'],
						min = 0, max = 1, step = 0.05,
						disabled = function() return not E.db.KlixUI.chat.select or not E.db.KlixUI.chat.forceShow end,
						get = function(info) return E.db.KlixUI.chat.forceShowToAlpha end,
						set = function(info, value) E.db.KlixUI.chat.forceShowToAlpha = value; end,
					},
				},
			},
			separators = {
				order = 3,
				type = "group",
				name = L["Chat Separators"],
				guiInline = true,
				args = {
					chatTabSeparator = {
						order = 1,
						type = "select",
						name = L["Chat Tab Separators"],
						desc = L["Add a thin black line below chat tabs to separate them from chat messages."],
						get = function(info) return E.db.KlixUI.chat.chatTabSeparator end,
						set = function(info, value) E.db.KlixUI.chat.chatTabSeparator = value; KUI:GetModule('KuiLayout'):ToggleChatSeparators(); end,
						values = {
							['HIDEBOTH'] = L['Hide Both'],
							['SHOWBOTH'] = L['Show Both'],
							['LEFTONLY'] = L['Left Only'],
							['RIGHTONLY'] = L['Right Only'],
						},
					},
					chatDataSeparator = {
						order = 2,
						type = "select",
						name = L["Chat Datatext Separators"],
						desc = L["Add a thin black line above chat datatexts to separate them from chat messages."],
						disabled = function() return E.db.KlixUI.datatexts.chat.enable end,
						get = function(info) return E.db.KlixUI.chat.chatDataSeparator end,
						set = function(info, value) E.db.KlixUI.chat.chatDataSeparator = value; KUI:GetModule('KuiLayout'):ToggleChatSeparators(); end,
						values = {
							['HIDEBOTH'] = L['Hide Both'],
							['SHOWBOTH'] = L['Show Both'],
							['LEFTONLY'] = L['Left Only'],
							['RIGHTONLY'] = L['Right Only'],
						},
					},
				},
			},
		},
	}
end
T.table_insert(KUI.Config, ChatTable)