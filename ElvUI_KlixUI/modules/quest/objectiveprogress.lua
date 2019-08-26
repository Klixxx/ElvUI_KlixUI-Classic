local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local OP = KUI:NewModule('ObjectiveProgress', 'AceHook-3.0', 'AceEvent-3.0');
local LOP = LibStub("LibObjectiveProgress-1.0")

-- OnTooltipSetUnit hook function
local function OP_OnTooltipSetUnit(self)
    if not E.db.KlixUI.quest.objectiveProgress or not self or not self.NumLines or self:NumLines() == 0 then return end

    local name, unit = self:GetUnit()
    if not unit then return end

    local GUID = T.UnitGUID(unit)
    if not GUID or GUID == "" then return end

    local npcID = T.select(6, ("-"):split(GUID))
    if not npcID or npcID == "" then return end

    local weightsTable = LOP:GetNPCWeightByCurrentQuests(T.tonumber(npcID))
    if not weightsTable then return end

    for questID, npcWeight in T.next, weightsTable do
        local questTitle = T.C_TaskQuest_GetQuestInfoByQuestID(questID)
        for j = 1, self:NumLines() do
            if _G["GameTooltipTextLeft" .. j] and _G["GameTooltipTextLeft" .. j]:GetText() == questTitle then
                _G["GameTooltipTextLeft" .. j]:SetText(_G["GameTooltipTextLeft" .. j]:GetText() .. " - " .. T.tostring(T.math_floor((npcWeight * 100) + 0.5) / 100) .. "%")
            end
        end
    end
end

function OP:Initialize()
    _G.GameTooltip:HookScript("OnTooltipSetUnit", OP_OnTooltipSetUnit)
end

local function InitializeCallback()
	OP:Initialize()
end

KUI:RegisterModule(OP:GetName(), InitializeCallback)