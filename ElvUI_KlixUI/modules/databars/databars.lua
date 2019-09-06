local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KDB = KUI:NewModule('KuiDatabars', 'AceHook-3.0', 'AceEvent-3.0')
local LSM = E.LSM or E.Libs.LSM

function KDB:StyleBackdrops()
	local db = E.db.KlixUI.databars
	
	if E.db.KlixUI.general.style then
		if db.style then
			-- Experience
			local experience = _G["ElvUI_ExperienceBar"]
			if experience then
				experience.statusBar:Styling()
			end
			
			-- Reputation
			local reputation = _G["ElvUI_ReputationBar"]
			if reputation then
				reputation.statusBar:Styling()
			end
		end
	end
end

function KDB:EnableDisable()
    -- these functions have both enable/disable checks
    KDB:HookXPText()
    KDB:HookXPTooltip()
    KDB:HookRepText()
    KDB:HookRepTooltip()

    if not E.db.KlixUI.databars.enable or T.IsAddOnLoaded("ElvUI_ProgressiveDataBarsColors") then
        KDB:UnhookAll() -- make sure no hooks are left behind
    end
end

function KDB:Round(num, idp)
    if num <= 0.1 then
        return 0.1
    end
    local mult = 10^(idp or 0)
    return T.math_floor(num * mult + 0.5) / mult
end

function KDB:Initialize()
	T.C_Timer_After(1, KDB.StyleBackdrops)
	
	KDB:EnableDisable()
	KDB:LoadWatchedFaction()
	KDB:UpdateFactionColors()
end

local function InitializeCallback()
	KDB:Initialize()
end

KUI:RegisterModule(KDB:GetName(), InitializeCallback)