local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local LP = KUI:GetModule("LocPanel")

local GameTooltip = _G.GameTooltip

local PLAYER, UNKNOWN, TRADE_SKILLS, TOKENS, DUNGEONS = PLAYER, UNKNOWN, TRADE_SKILLS, TOKENS, DUNGEONS
local PROFESSIONS_FISHING, LEVEL_RANGE, STATUS, HOME, CONTINENT, PVP, RAID = PROFESSIONS_FISHING, LEVEL_RANGE, STATUS, HOME, CONTINENT, PVP, RAID


-----------------------
-- Tooltip functions --
-----------------------

-- Status
function LP:GetStatus(color)
	local status = ""
	local statusText
	local r, g, b = 1, 1, 0
	local pvpType = T.GetZonePVPInfo()
	local inInstance, _ = T.IsInInstance()

	if (pvpType == "sanctuary") then
		status = SANCTUARY_TERRITORY
		r, g, b = 0.41, 0.8, 0.94
	elseif(pvpType == "arena") then
		status = ARENA
		r, g, b = 1, 0.1, 0.1
	elseif(pvpType == "friendly") then
		status = FRIENDLY
		r, g, b = 0.1, 1, 0.1
	elseif(pvpType == "hostile") then
		status = HOSTILE
		r, g, b = 1, 0.1, 0.1
	elseif(pvpType == "contested") then
		status = CONTESTED_TERRITORY
		r, g, b = 1, 0.7, 0.10
	elseif(pvpType == "combat" ) then
		status = COMBAT
		r, g, b = 1, 0.1, 0.1
	elseif inInstance then
		status = AGGRO_WARNING_IN_INSTANCE
		r, g, b = 1, 0.1, 0.1
	else
		status = CONTESTED_TERRITORY
	end

	statusText = T.string_format("|cff%02x%02x%02x%s|r", r*255, g*255, b*255, status)

	if color then
		return r, g, b
	else
		return statusText
	end
end

function LP:UpdateTooltip()

	GameTooltip:ClearLines()

	-- Home
	GameTooltip:AddDoubleLine(HOME.." :", T.GetBindLocation(), 1, 1, 1, 0.41, 0.8, 0.94)

	-- Status
	if E.db.KlixUI.locPanel.tooltip.ttst then
		GameTooltip:AddDoubleLine(STATUS.." :", LP:GetStatus(false), 1, 1, 1)
	end

	-- Hints
	if E.db.KlixUI.locPanel.tooltip.tt then
		if E.db.KlixUI.locPanel.tooltip.tthint then
			GameTooltip:AddLine(" ")
			GameTooltip:AddDoubleLine(L["Left Click: "], L["Toggle WorldMap"], 0.7, 0.7, 1, 0.7, 0.7, 1)
			GameTooltip:AddDoubleLine(L["Shift + Click: "], L["Send position to chat"],0.7, 0.7, 1, 0.7, 0.7, 1)
			GameTooltip:AddDoubleLine(L["Control + Click: "], L["Toggle Datatexts"],0.7, 0.7, 1, 0.7, 0.7, 1)
		end
		GameTooltip:Show()
	else
		GameTooltip:Hide()
	end
end