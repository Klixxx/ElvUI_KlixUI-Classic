local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local QXP = KUI:NewModule('KuiQuestXP', 'AceEvent-3.0', 'AceHook-3.0')
local KDB = KUI:GetModule("KuiDatabars")

local questBar
local questLogXP

function QXP:Refresh(event)
	local maxXP = T.UnitXPMax("player");
	
    questBar:SetMinMaxValues(0, maxXP);

    local mapID = T.C_Map_GetBestMapForUnit("player")
	
	if mapID == nil then
		return
	end
	
	
    local zoneName = T.C_Map_GetMapInfo(mapID).name

    local currentXP = T.UnitXP("player")

    local i = 1
	local lastHeader
    local currentQuestXPTotal = 0
    while T.GetQuestLogTitle(i) do
      local questLogTitleText, level, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = T.GetQuestLogTitle(i)
        if (not isHeader) then
            local incompleteCheck = true
            local zoneCheck = true

            if (not QXP.db.IncludeIncomplete) then
                if not isComplete then
                    incompleteCheck = false                    
                end
            end

            if QXP.db.CurrentZoneOnly then
                if lastHeader ~= zoneName then
                    zoneCheck = false
                end
            end

            if incompleteCheck and zoneCheck then
                currentQuestXPTotal = currentQuestXPTotal + GetQuestLogRewardXP(questID)
            end
        else
            lastHeader = questLogTitleText
      end
      i = i + 1
    end
	
	questLogXP = currentQuestXPTotal
    questBar:SetValue(T.math_min(currentXP + currentQuestXPTotal, T.UnitXPMax("player")))
	
	local color = E.db.KlixUI.databars.questXP.Color
	if (currentXP + currentQuestXPTotal) >= maxXP then
		questBar:SetStatusBarColor(0/255, 255/255, 0/255, 0.5)
	else
		questBar:SetStatusBarColor(color.r, color.g, color.b, color.a)
	end
end

function QXP:AddExpBarTooltip(frame)
    self.hooks[frame].OnEnter(frame)
    local GameTooltip = _G.GameTooltip
    GameTooltip:AddDoubleLine("Quest Log XP:", questLogXP, 1, 1, 1)
	GameTooltip:Show()
end

function QXP:HookXPBar(val)
    if (val) then
        QXP:RawHookScript(ElvUI_ExperienceBar, "OnEnter", "AddExpBarTooltip")
    else
        QXP:Unhook(ElvUI_ExperienceBar, "OnEnter")
    end

end

function QXP:Initialize()
	if not E.db.KlixUI.databars.questXP.enable or T.IsAddOnLoaded("ElvUI_QuestXP_Classic") then return end
	QXP.db = E.db.KlixUI.databars.questXP
	
    local bar = ElvUI_ExperienceBar
    questBar = T.CreateFrame('StatusBar', nil, bar)
    bar.questBar = questBar
    questBar:SetInside()
    questBar:SetStatusBarTexture(E.media.normTex)
    E:RegisterStatusBar(bar.questBar)

    questBar:SetOrientation(E.db.databars.experience.orientation)
    questBar:SetReverseFill(E.db.databars.experience.reverseFill)

    questBar.eventFrame = T.CreateFrame("Frame")
    questBar.eventFrame:Hide()
    
    questBar.eventFrame:RegisterEvent("QUEST_LOG_UPDATE")
    questBar.eventFrame:RegisterEvent("PLAYER_XP_UPDATE")
    questBar.eventFrame:RegisterEvent("ZONE_CHANGED")
    questBar.eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    questBar.eventFrame:RegisterEvent("UNIT_PORTRAIT_UPDATE")
    questBar.eventFrame:SetScript("OnEvent", function(self, event) QXP:Refresh(event) end)
	
    QXP:Refresh()
	
	self:HookXPBar(E.db.KlixUI.databars.questXP.tooltip)
end

KUI:RegisterModule(QXP:GetName())