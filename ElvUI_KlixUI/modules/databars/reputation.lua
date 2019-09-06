local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KDB = KUI:GetModule("KuiDatabars")
local EDB = E:GetModule("DataBars")

local incpat = T.string_gsub(T.string_gsub(FACTION_STANDING_INCREASED, "(%%s)", "(.+)"), "(%%d)", "(.+)")
local changedpat = T.string_gsub(T.string_gsub(FACTION_STANDING_CHANGED, "(%%s)", "(.+)"), "(%%d)", "(.+)")
local decpat = T.string_gsub(T.string_gsub(FACTION_STANDING_DECREASED, "(%%s)", "(.+)"), "(%%d)", "(.+)")
local standing = ('%s:'):format(STANDING)
local reputation = ('%s:'):format(REPUTATION)

-- local variables ------------------------------------------------------------
-- Blizzard's FACTION_BAR_COLORS only has 8 entries but we'll fix that
local KDB_REP_BAR_COLORS = {
    [1] = {r = 1, g = 0, b = 0, a = 1},             -- hated
    [2] = {r = 1, g = 0.55, b = 0, a = 1},          -- hostile
    [3] = {r = 1, g = 1, b = 0, a = 1},             -- unfriendly
    [4] = {r = 1, g = 1, b = 1, a = 1},             -- neutral
    [5] = {r = 0, g = 1, b = 0, a = 1},             -- friendly
    [6] = {r = 0.25,  g = 0.4,  b = 0.9, a = 1},    -- honored
    [7] = {r = 0.6, g = 0.2, b = 0.8, a = 1},       -- revered
    [8] = {r = 0.9, g = 0.8,  b = 0.5, a = 1},      -- exalted
    [9] = {r = 0.75,  g = 0.75, b = 0.75, a = 1},   -- paragon
}
local BACKUP = FACTION_BAR_COLORS[1]

-- helper function ------------------------------------------------------------
local function CheckRep(standingID, factionID, friendID, nextFriendThreshold)
    local isCapped = false

    if standingID == MAX_REPUTATION_REACTION then
        isCapped = true
    elseif nextFriendThreshold then
        isCapped = false
    elseif not nextFriendThreshold and friendID then
        isCapped = true
    end

    return isCapped
end

-- local functions called via hooking -----------------------------------------
local function ReputationBar_OnEnter()
    local name, standingID, minimum, maximum, value, factionID = T.GetWatchedFactionInfo()
    local isCapped, isParagon = CheckRep(standingID, factionID, friendID, nextFriendThreshold)


    if name and E.db.KlixUI.databars.reputationBar.capped then
        if isCapped then
            GameTooltip:ClearLines()

            if friendID then
                GameTooltip:AddLine(friendName)
                GameTooltip:AddLine(name)
            end

            GameTooltip:AddLine(" ")
            GameTooltip:AddDoubleLine(REPUTATION .. ":", L["Capped"])
            GameTooltip:Show()
        end
    end
end

local function UpdateReputation(self)
    local bar = self.repBar
    local name, standingID, minimum, maximum, value, factionID = T.GetWatchedFactionInfo()
    local isCapped, isParagon = CheckRep(standingID, factionID, friendID, nextFriendThreshold)

    if isCapped then
        -- don't want a blank bar at non-Paragon Exalted
        bar.statusBar:SetMinMaxValues(0, 1)
        bar.statusBar:SetValue(1)
    end

    if name then -- only do stuff if name has value
        if E.db.KlixUI.databars.reputationBar.capped then
            if isCapped then
				bar.text:SetText(name .. ": " .. L["Capped"])
            end
        end

        -- color the rep bar
        if E.db.KlixUI.databars.reputationBar.color == "ascii" then
            local color = KDB_REP_BAR_COLORS[standingID] or BACKUP
            bar.statusBar:SetStatusBarColor(color.r, color.g, color.b)
        else
            local color = FACTION_BAR_COLORS[standingID] or BACKUP
            bar.statusBar:SetStatusBarColor(color.r, color.g, color.b)
        end

        -- blend the bar
        local avg = value / maximum
        avg = KDB:Round(avg, 2)
        if E.db.KlixUI.databars.reputationBar.progress then
            bar.statusBar:SetAlpha(avg)
        else
            bar.statusBar:SetAlpha(1)
        end
    end
end

-- Auto change reputation
function KDB:SetWatchedFactionOnReputationBar(event, msg)
	if not E.db.KlixUI.databars.reputationBar.autotrack then return end
	
	local _, _, faction, amount = T.string_find(msg, incpat)
	if not faction then _, _, faction, amount = T.string_find(msg, changedpat) or T.string_find(msg, decpat) end
	if faction then
		if faction == GUILD then
			faction = T.GetGuildInfo("player")
		end

		local active = T.GetWatchedFactionInfo()
		for factionIndex = 1, T.GetNumFactions() do
			local name = T.GetFactionInfo(factionIndex)
			if name == faction and name ~= active then
				-- check if watch has been disabled by user
				local inactive = T.IsFactionInactive(factionIndex) or T.SetWatchedFactionIndex(factionIndex)
				break
			end
		end
	end
end

function KDB:LoadWatchedFaction()
	if E.db.KlixUI.databars.reputationBar.autotrack then
		self:RegisterEvent('CHAT_MSG_COMBAT_FACTION_CHANGE', 'SetWatchedFactionOnReputationBar')
	else
		self:UnregisterEvent('CHAT_MSG_COMBAT_FACTION_CHANGE')
	end
end

-- hooking fuctions -----------------------------------------------------------
function KDB:HookRepTooltip()
    if E.db.KlixUI.databars.enable and EDB.repBar then
        if not KDB:IsHooked(_G["ElvUI_ReputationBar"], "OnEnter") then
            KDB:SecureHookScript(_G["ElvUI_ReputationBar"], "OnEnter", ReputationBar_OnEnter)
        end
    elseif not E.db.KlixUI.databars.enable or not EDB.repBar then
        if KDB:IsHooked(_G["ElvUI_ReputationBar"], "OnEnter") then
            KDB:Unhook(_G["ElvUI_ReputationBar"], "OnEnter")
        end
    end
end

function KDB:HookRepText()
    if E.db.KlixUI.databars.enable and EDB.repBar then
        if not KDB:IsHooked(EDB, "UpdateReputation") then
            KDB:SecureHook(EDB, "UpdateReputation", UpdateReputation)
        end
    elseif not E.db.KlixUI.databars.enable or not EDB.repBar then
        if KDB:IsHooked(EDB, "UpdateReputation") then
            KDB:Unhook(EDB, "UpdateReputation")
        end
        KDB:RestoreRepColors()
    end
    EDB:UpdateReputation()
end

function KDB:RestoreRepColors()
    local bar = EDB.repBar
    if bar then
        local _, standingID = T.GetWatchedFactionInfo()
        local color = FACTION_BAR_COLORS[standingID] or BACKUP

        bar.statusBar:SetStatusBarColor(color.r, color.g, color.b)
        bar.statusBar:SetAlpha(1)
    end
end

-- Character Reputation Colors
function KDB:UpdateFactionColors()
	E:CopyTable(FACTION_BAR_COLORS, E.db.KlixUI.betterreputationcolors);
end