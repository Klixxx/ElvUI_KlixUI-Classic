local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local HM = KUI:NewModule("HealerMana", "AceEvent-3.0")

local function UpdateMana()
    if T.IsInRaid() then 
		return
    elseif T.IsInGroup() then
        local members = T.GetNumGroupMembers()
        for i = 1, members do
            local frame = _G["ElvUF_PartyGroup1UnitButton" .. i]
            frame.Power:Hide()
            if i == 1 then
                local role = T.UnitGroupRolesAssigned("player")
                if role == "HEALER" then frame.Power:Show() end
            else
                local k = i - 1
                local role = T.UnitGroupRolesAssigned("party" .. k)
                if role == "HEALER" then frame.Power:Show() end
            end
        end
    end
end

function HM:Initialize()
	if not E.db.unitframe.units.party.enable or not E.db.KlixUI.unitframes.healerMana or T.IsAddOnLoaded("ElvUI_HealerMana") then return end
	
	self:RegisterEvent("PLAYER_ENTERING_WORLD", UpdateMana)
	self:RegisterEvent("GROUP_ROSTER_UPDATE", UpdateMana)
	self:RegisterEvent("INSPECT_READY", UpdateMana)
end

KUI:RegisterModule(HM:GetName())
