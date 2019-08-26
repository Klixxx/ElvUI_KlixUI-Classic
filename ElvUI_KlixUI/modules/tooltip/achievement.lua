local KUI, T, E, L, V, P, G = unpack(select(2, ...))

local function SetHyperlink(tooltip, refString)
	if E.db.KlixUI.tooltip.achievement ~= true then return end
	if tooltip:IsForbidden() then return; end
	if T.select(3, T.string_find(refString, "(%a-):")) ~= "achievement" then return end

	local _, _, achievementID = T.string_find(refString, ":(%d+):")
	local _, _, GUID = T.string_find(refString, ":%d+:(.-):")

	if GUID == T.UnitGUID("player") then
		tooltip:Show()
		return
	end

	tooltip:AddLine(" ")
	local _, _, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe, earnedBy = T.GetAchievementInfo(achievementID)

	if completed then
		if earnedBy then
			if earnedBy ~= "" then
				tooltip:AddLine(T.string_format(ACHIEVEMENT_EARNED_BY, earnedBy))
			end
			if not wasEarnedByMe then
				tooltip:AddLine(T.string_format(ACHIEVEMENT_NOT_COMPLETED_BY, E.myname))
			elseif E.myname ~= earnedBy then
				tooltip:AddLine(T.string_format(ACHIEVEMENT_COMPLETED_BY, E.myname))
			end
		end
	end
	tooltip:Show()
end
hooksecurefunc(_G.GameTooltip, "SetHyperlink", SetHyperlink)
hooksecurefunc(_G.ItemRefTooltip, "SetHyperlink", SetHyperlink)