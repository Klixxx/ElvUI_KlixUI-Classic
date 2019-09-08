local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local PvP = KUI:NewModule('KuiPVP','AceHook-3.0', 'AceEvent-3.0')

local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local SOUNDKIT = SOUNDKIT
local COMBATLOG_OBJECT_TYPE_PLAYER = COMBATLOG_OBJECT_TYPE_PLAYER
local COMBATLOG_HONORGAIN, COMBATLOG_HONORGAIN_NO_RANK, COMBATLOG_HONORAWARD = COMBATLOG_HONORGAIN, COMBATLOG_HONORGAIN_NO_RANK, COMBATLOG_HONORAWARD
local PVP_RANK_0_0 =PVP_RANK_0_0

PvP.HonorStrings = {}
local BG_Opponents = {
}

function PvP:Release()
	local resOptions = T.GetSortedSelfResurrectOptions()
	if (PvP.db.rebirth and not resOptions[1]) or not PvP.db.rebirth then T.RepopMe() end
end

function PvP:Dead()
	local inInstance, instanceType = T.IsInInstance()
	if not PvP.db.autorelease then return end -- Option disabled = do nothing!
	if (inInstance and instanceType == "pvp") then
		PvP:Release()
		return -- To prevent the rest of the function from execution when not needed
	end
end

function PvP:Duels(event, name)
	local cancelled = false
	if event == "DUEL_REQUESTED" and PvP.db.duels.regular then
		T.CancelDuel()
		T.StaticPopup_Hide("DUEL_REQUESTED")
		cancelled = "REGULAR"
	end
	if cancelled then
		KUI:Print(T.string_format(L["KUI_DuelCancel_"..cancelled], name))
	end
end

function PvP:Initialize()
	if T.IsAddOnLoaded("ElvUI_SLE") then return end
	
	PvP.db = E.db.KlixUI.pvp
	PvP.ScoreWidget = _G.UIWidgetTopCenterContainerFrame

	-- AutoRes event
	self:RegisterEvent("PLAYER_DEAD", "Dead");

	if E.db.movers["PvPMover"] then E.db.movers["TopCenterContainerMover"] = E.db.movers["PvPMover"]; E.db.movers["PvPMover"] = nil end
	
	self:RegisterEvent("DUEL_REQUESTED", "Duels")

	function PvP:ForUpdateAll()
		PvP.db = E.db.KlixUI.pvp
	end
end

KUI:RegisterModule(PvP:GetName())