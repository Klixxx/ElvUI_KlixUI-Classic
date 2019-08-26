local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local MI = KUI:GetModule("KuiMisc")
local S = E:GetModule("Skins")

function MI:GMOTD()
	-- MainFrame
	if not gmotd then
		if not T.IsInGuild() then return end
		
		local gmotd = T.CreateFrame("Frame", "KUI.GMOTD", E.UIParent)
		gmotd:SetPoint("CENTER", 0, T.GetScreenHeight()/5)
		gmotd:SetSize(350, 150)
		gmotd:SetToplevel(true)
		gmotd:SetMovable(true)
		gmotd:EnableMouse(true)
		gmotd:SetClampedToScreen(true)
		gmotd:SetFrameStrata("TOOLTIP")
		gmotd:SetScript("OnMouseDown", gmotd.StartMoving)
		gmotd:SetScript("OnMouseUp", gmotd.StopMovingOrSizing)
		gmotd:CreateBackdrop("Transparent")
		gmotd.backdrop:SetAllPoints()
		gmotd:Styling()
		gmotd:Hide()

		gmotd.button = T.CreateFrame("Button", nil, gmotd, "UIPanelButtonTemplate")
		gmotd.button:SetText(L["Ok"])
		gmotd.button:SetPoint("TOP", gmotd, "BOTTOM", 0, -3)
		S:HandleButton(gmotd.button)
		gmotd.button:SetScript("OnClick", function(self)
			gmotd:Hide()
		end)

		gmotd.header = KUI:CreateText(gmotd, "OVERLAY", 14, "OUTLINE")
		gmotd.header:SetPoint("BOTTOM", gmotd, "TOP", 0, 4)
		gmotd.header:SetTextColor(1, 1, 0)

		gmotd.text = KUI:CreateText(gmotd, "OVERLAY", 12, "OUTLINE")
		gmotd.text:SetHeight(130)
		gmotd.text:SetPoint("TOPLEFT", gmotd, "TOPLEFT", 10, -10)
		gmotd.text:SetPoint("TOPRIGHT", gmotd, "TOPRIGHT", -10, -10)
		gmotd.text:SetJustifyV("TOP")
		gmotd.text:SetTextColor(1, 1, 1)
		gmotd.text:CanWordWrap(true)
		gmotd.text:SetWordWrap(true)

		gmotd:SetScript("OnEvent", function(self, event, message)
			local icon = "|TInterface\\CHATFRAME\\UI-ChatIcon-Share:18:18|t"

			local guild = false
			local msg = false

			if (event == "GUILD_MOTD") then
				msg = message
				guild = T.select(1, T.GetGuildInfo("player"))
			else
				msg = T.GetGuildRosterMOTD()
				guild = T.select(1, T.GetGuildInfo("player"))
			end
			
			if (msg and msg ~= "") and not T.InCombatLockdown() then
				T.PlaySound(12867) --[[Sound\Interface\alarmclockwarning2.ogg]]
				gmotd.msg = msg
				gmotd.text:SetText(msg)
				gmotd.header:SetText(icon..(T.string_format("|cff00c0fa%s|r", guild))..": ".._G.GUILD_MOTD_LABEL2)
				local numLines = gmotd.text:GetNumLines()
				gmotd:SetHeight(20 + (12.2  *numLines))
				gmotd:Show()
			else
				gmotd:Hide()
			end
		end)
		gmotd:RegisterEvent("PLAYER_LOGIN")
		gmotd:RegisterEvent("GUILD_MOTD")
	end
end

function MI:LoadGMOTD()
	if E.db.KlixUI.misc.gmotd then
		self:GMOTD()
		T.table_insert(_G.UISpecialFrames, "KUI.GMOTD")
	end
end