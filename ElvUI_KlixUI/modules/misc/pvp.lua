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
	-- Euto resurrection for world PvP area...when active
	for index = 1, T.GetNumWorldPVPAreas() do
		local _, localizedName, isActive, canQueue = T.GetWorldPVPAreaInfo(index)
		if (T.GetRealZoneText() == localizedName and isActive) or (T.GetRealZoneText() == localizedName and canQueue) then PvP:Release() end
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

function PvP:OpponentsTable()
	T.table_wipe(BG_Opponents)
	for index = 1, T.GetNumBattlefieldScores() do
		local name, _, _, _, _, faction, _, _, classToken = T.GetBattlefieldScore(index)
		if (KUI.myfaction == "Horde" and faction == 1) or (KUI.myfaction == "Alliance" and faction == 0) then
			BG_Opponents[name] = classToken
		end
	end
end

function PvP:LogParse()
	local _, subevent, _, _, Caster, _, _, _, TargetName, TargetFlags = T.CombatLogGetCurrentEventInfo()
	if subevent == "PARTY_KILL" then
		local mask = T.bit_band(TargetFlags, COMBATLOG_OBJECT_TYPE_PLAYER)
		if Caster == E.myname and (BG_Opponents[TargetName] or mask > 0) then
			if mask > 0 and BG_Opponents[TargetName] then TargetName = "|c"..RAID_CLASS_COLORS[BG_Opponents[TargetName]].colorStr..TargetName.."|r" end
			T.TopBannerManager_Show(_G.BossBanner, { name = TargetName, mode = "PVPKILL" });
		end
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

	if E.private.KlixUI.pvp.KBbanner.enable then
		hooksecurefunc(_G.BossBanner, "PlayBanner", function(self, data)
			if ( data ) then
				if ( data.mode == "PVPKILL" ) then
					self.Title:SetText(data.name);
					self.Title:Show();
					self.SubTitle:Hide();
					self:Show();
					T.BossBanner_BeginAnims(self);
					if E.private.KlixUI.pvp.KBbanner.sound then
						T.PlaySound(SOUNDKIT.UI_RAID_BOSS_DEFEATED)
					end
				end
			end
		end)
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "LogParse")
		self:RegisterEvent("UPDATE_BATTLEFIELD_SCORE", "OpponentsTable")
	end
end

KUI:RegisterModule(PvP:GetName())