local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local PI = KUI:NewModule("ProgressInfo", "AceHook-3.0", "AceEvent-3.0")
local KTT = KUI:GetModule('KuiTooltip')
local TT = E:GetModule('Tooltip')

local MAX_PLAYER_LEVEL = MAX_PLAYER_LEVEL

PI.Cache = {}
PI.playerGUID = T.UnitGUID("player")
PI.highestKill = 0

PI.bosses = {
	{ -- Uldir
		{ -- Mythic
			12789, 12793, 12797, 12801, 12805, 12811, 12816, 12820,
		},
		{ -- Heroic
			12788, 12792, 12796, 12800, 12804, 12810, 12815, 12819,
		},
		{ -- Normal
			12787, 12791, 12795, 12799, 12803, 12809, 12814, 12818,
		},
		{ -- LFR
			12786, 12790, 12794, 12798, 12802, 12808, 12813, 12817,
		},
		"uldir",
	},
	{ -- Battle of Dazar'alor
		{ -- Mythic
			13331, 13336 or 13353, 13357 or 13348, 13362, 13366, 13370, 13374, 13378, 13382,
		},
		{ -- Heroic
			13330, 13334 or 13351, 13356 or 13347, 13361, 13365, 13369, 13373, 13377, 13381,
		},
		{ -- Normal
			13329, 13333 or 13350, 13355 or 13346, 13359, 13364, 13368, 13372, 13376, 13380,
		},
		{ -- LFR
			13328, 13332 or 13349, 13354 or 13344, 13358, 13363, 13367, 13371, 13375, 13379,
		},
		"dazaralor",
	},
	{ -- Crucible of Storms
		{ -- Mythic
			13407, 13413,
		},
		{ -- Heroic
			13406, 13412,
		},
		{ -- Normal
			13405, 13411,
		},
		{ -- LFR
			13404, 13408,
		},
		"crucible",
	},
	{ -- Eternal Palace
		{ -- Mythic
			13590, 13594, 13598, 13603, 13607, 13611, 13615, 13619,
		},
		{ -- Heroic
			13589, 13593, 13597, 13602, 13606, 13610, 13614, 13618,
		},
		{ -- Normal
			13588, 13592, 13596, 13601, 13605, 13609, 13613, 13617,
		},
		{ -- LFR
			13587, 13591, 13595, 13600, 13604, 13608, 13612, 13616,
		},
		"eternalpalace"
	},
}

PI.Raids = {
	["LONG"] = {
		KUI:GetMapInfo(1148, "name"),
		KUI:GetMapInfo(1358, "name"),
		KUI:GetMapInfo(1345, "name"),
		KUI:GetMapInfo(1512, "name"),
	},
	["SHORT"] = {
		KUI:GetMapInfo(1148, "name"),
		L["RAID_BOD"],
		L["RAID_COS"],
		L["RAID_EP"],
	},
}
PI.modes = { 
	["LONG"] = {
		PLAYER_DIFFICULTY6,
		PLAYER_DIFFICULTY2, 
		PLAYER_DIFFICULTY1,
		PLAYER_DIFFICULTY3,
	},
	["SHORT"] = {
		T.string_utf8sub(PLAYER_DIFFICULTY6, 1 , 1),
		T.string_utf8sub(PLAYER_DIFFICULTY2, 1 , 1),
		T.string_utf8sub(PLAYER_DIFFICULTY1, 1 , 1),
		T.string_utf8sub(PLAYER_DIFFICULTY3, 1 , 1),
	},
}

function PI:GetProgression(guid)
	local kills, complete, pos = 0, false, 0
	local statFunc = guid == PI.playerGUID and T.GetStatistic or T.GetComparisonStatistic
	
	for raid = 1, #PI.Raids["LONG"] do
		local option = PI.bosses[raid][5]
		if E.db.KlixUI.tooltip.progressInfo.raids[option] then
			PI.Cache[guid].header[raid] = {}
			PI.Cache[guid].info[raid] = {}
			for level = 1, 4 do
				PI.highestKill = 0
				for statInfo = 1, #PI.bosses[raid][level] do
					local bossTable =PI.bosses[raid][level][statInfo]
					kills = T.tonumber((statFunc(bossTable)))
					if kills and kills > 0 then
						PI.highestKill = PI.highestKill + 1
					end
				end
				pos = PI.highestKill
				if (PI.highestKill > 0) then
					PI.Cache[guid].header[raid][level] = T.string_format("%s [%s]:", PI.Raids[E.db.KlixUI.tooltip.progressInfo.NameStyle][raid], PI.modes[E.db.KlixUI.tooltip.progressInfo.DifStyle][level])
					PI.Cache[guid].info[raid][level] = T.string_format("%d/%d", PI.highestKill, #PI.bosses[raid][level])
					if PI.highestKill == #PI.bosses[raid][level] then
						break
					end
				end
			end
		end
	end	
end

function PI:UpdateProgression(guid)
	PI.Cache[guid] = PI.Cache[guid] or {}
	PI.Cache[guid].header = PI.Cache[guid].header or {}
	PI.Cache[guid].info =  PI.Cache[guid].info or {}
	PI.Cache[guid].timer = T.GetTime()

	PI:GetProgression(guid)
end

function PI:SetProgressionInfo(guid, tt)
	if PI.Cache[guid] and PI.Cache[guid].header then
		local updated = 0
		for i=1, tt:NumLines() do
			local leftTipText = _G["GameTooltipTextLeft"..i]
			for raid = 1, #PI.Raids["LONG"] do
				for level = 1, 4 do
					if (leftTipText:GetText() and leftTipText:GetText():find(PI.Raids[E.db.KlixUI.tooltip.progressInfo.NameStyle][raid]) and leftTipText:GetText():find(PI.modes[E.db.KlixUI.tooltip.progressInfo.DifStyle][level]) and (PI.Cache[guid].header[raid][level] and PI.Cache[guid].info[raid][level])) then
						-- update found tooltip text line
						local rightTipText = _G["GameTooltipTextRight"..i]
						leftTipText:SetText(PI.Cache[guid].header[raid][level])
						rightTipText:SetText(PI.Cache[guid].info[raid][level])
						updated = 1
					end
				end
			end
		end
		if updated == 1 then return end
		-- add progression tooltip line
		if PI.highestKill > 0 then tt:AddLine(" ") end
		for raid = 1, #PI.Raids["LONG"] do
			local option = PI.bosses[raid][5]
			if E.db.KlixUI.tooltip.progressInfo.raids[option] then
				for level = 1, 4 do
					tt:AddDoubleLine(PI.Cache[guid].header[raid][level], PI.Cache[guid].info[raid][level], nil, nil, nil, 1, 1, 1)
				end
			end
		end
	end
end

local function AchieveReady(event, GUID)
	if (TT.compareGUID ~= GUID) then return end
	local unit = "mouseover"
	if T.UnitExists(unit) then
		PI:UpdateProgression(GUID)
		_G["GameTooltip"]:SetUnit(unit)
	end
	T.ClearAchievementComparisonUnit()
	TT:UnregisterEvent("INSPECT_ACHIEVEMENT_READY")
end

local function OnInspectInfo(self, tt, unit, level, r, g, b, numTries)
	if T.InCombatLockdown() then return end
	if not E.db.KlixUI.tooltip.progressInfo.enable then return end
	if E.db.KlixUI.tooltip.progressInfo.display == "SHIFT" and not T.IsShiftKeyDown() then return end 
	if not (unit and T.CanInspect(unit)) then return end
	local level = T.UnitLevel(unit)
	if not level or level < MAX_PLAYER_LEVEL then return end
	
	local guid = T.UnitGUID(unit)
	if not PI.Cache[guid] or (T.GetTime() - PI.Cache[guid].timer) > 600 then
		if guid == PI.playerGUID then
			PI:UpdateProgression(guid)
		else
			T.ClearAchievementComparisonUnit()
			if not self.loadedComparison and T.select(2, T.IsAddOnLoaded("Blizzard_AchievementUI")) then
				T.AchievementFrame_DisplayComparison(unit)
				T.HideUIPanel(_G["AchievementFrame"])
				T.ClearAchievementComparisonUnit()
				self.loadedComparison = true
			end
			self.compareGUID = guid
			if T.SetAchievementComparisonUnit(unit) then
				self:RegisterEvent("INSPECT_ACHIEVEMENT_READY", AchieveReady)
			end
			return
		end
	end

	PI:SetProgressionInfo(guid, tt)
end

function PI:Initialize()
	if not E.private.tooltip.enable or T.IsAddOnLoaded("RaiderIO") then return end
	
	hooksecurefunc(TT, 'AddInspectInfo', OnInspectInfo) 
end

KUI:RegisterModule(PI:GetName())