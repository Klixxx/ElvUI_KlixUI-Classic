-------------------------------------------------------------------------------
-- Based on: WatchFrameHider - Sortokk and ElvUI_Enhanced
-------------------------------------------------------------------------------
local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local QT = KUI:NewModule('QuestTracker', 'AceEvent-3.0')

local statedriver = {
	['FULL'] = function(frame) 
		T.ObjectiveTracker_Expand()
		frame:Show()
	end,
	['COLLAPSED'] = function(frame)
		T.ObjectiveTracker_Collapse()
		frame:Show()
	end,
	['HIDE'] = function(frame)
		frame:Hide()
	end,
}

function QT:ChangeState(event)
	if not QT.db then return end
	if not QT.db.visibility then return end
	if not QT.db.visibility.enable then return end
	if T.InCombatLockdown() and event ~= "PLAYER_REGEN_DISABLED" then return end
	local inCombat = event == "PLAYER_REGEN_DISABLED" and true or false

	if inCombat and QT.db.visibility.combat ~= "NONE" then
		statedriver[QT.db.visibility.combat](QT.frame)
	elseif T.C_Garrison_IsPlayerInGarrison(2) then
		statedriver[QT.db.visibility.garrison](QT.frame)
	elseif T.C_Garrison_IsPlayerInGarrison(3) then -- Order Halls
		statedriver[QT.db.visibility.orderhall](QT.frame)
	elseif T.IsResting() then
		statedriver[QT.db.visibility.rested](QT.frame)
	else
		local instance, instanceType = T.IsInInstance()
		if instance then
			if instanceType == 'pvp' then
				statedriver[QT.db.visibility.bg](QT.frame)
			elseif instanceType == 'arena' then
				statedriver[QT.db.visibility.arena](QT.frame)
			elseif instanceType == 'party' then
				statedriver[QT.db.visibility.dungeon](QT.frame)
			elseif instanceType == 'scenario' then
				statedriver[QT.db.visibility.scenario](QT.frame)
			elseif instanceType == 'raid' then
				statedriver[QT.db.visibility.raid](QT.frame)
			end
		else
			statedriver["FULL"](QT.frame)
		end
	end
	if T.IsAddOnLoaded("WorldQuestTracker") then
		local y = 0
		for i = 1, #QT.frame.MODULES do
			local module = QT.frame.MODULES[i]
			if (module.Header:IsShown()) then
				y = y + module.contentsHeight
			end
		end
		if (QT.frame.collapsed) then
			WorldQuestTrackerAddon.TrackerHeight = 20
		else
			WorldQuestTrackerAddon.TrackerHeight = y
		end

		WorldQuestTrackerAddon.RefreshTrackerAnchor()
	end
end

function QT:Initialize()
	QT.db = E.db.KlixUI.quest
	
	QT.frame = _G.ObjectiveTrackerFrame
	
	self:RegisterEvent("LOADING_SCREEN_DISABLED", "ChangeState")
	self:RegisterEvent("PLAYER_UPDATE_RESTING", "ChangeState")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "ChangeState")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "ChangeState")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "ChangeState")

	function QT:ForUpdateAll()
		QT.db = E.db.KlixUI.quest
		QT:ChangeState()
	end
end

KUI:RegisterModule(QT:GetName())