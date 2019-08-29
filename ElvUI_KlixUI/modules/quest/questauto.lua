local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local QA = KUI:NewModule("QuestAuto", "AceEvent-3.0")

function QA:CheckConfigs()
    if T.UnitInRaid("player") and ( not QA.db.inraid ) then return end

	if T.IsModifierKeyDown() then
		if ( QA.db.diskey == 1 ) and T.IsAltKeyDown() then return
        elseif ( QA.db.diskey == 2 ) and T.IsControlKeyDown() then return
        elseif ( QA.db.diskey == 3 ) and T.IsShiftKeyDown() then return end
    end
	
	if (T.UnitGUID("target") and T.string_find(T.UnitGUID("target"), "(.*)-(.*)")) then
		local type, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = T.string_split("-", T.UnitGUID("target"))
		if (npc_id and ((T.tonumber(npc_id) == 141584) or (T.tonumber(npc_id) == 142063)) -- Seal of Wartron (BfA)
			or (T.tonumber(npc_id) == 111243) -- Seal of Broken Fate (Legion)
			or ((T.tonumber(npc_id) == 87391) or (T.tonumber(npc_id) == 88570) or (T.tonumber(npc_id) == 96130)) -- Seal of Inevitable Fate + Seal of Tempered Fate (WoD)
			or ((T.tonumber(npc_id) == 64029) or (T.tonumber(npc_id) == 63996)) -- Warforged Seals (MoP)
			or (T.tonumber(npc_id) == 73305)) -- Mogu Rune of Fate (MoP)
		then
			return
		end
	end
	
    return true
end

function QA:CheckQuestData()
    if QA.db.dailiesonly then return end
    if ( not QA.db.pvp ) then return end

    return true
end

function QA:QUEST_GREETING()
    if QA:CheckConfigs() and QA.db.greeting then
        local numact,numava = T.GetNumActiveQuests(), T.GetNumAvailableQuests()
        if numact+numava == 0 then return end

        if numava > 0 then
            T.SelectAvailableQuest(1)
        end
        if numact > 0 then
            T.SelectActiveQuest(1)
        end
    end
end

function QA:GOSSIP_SHOW()
    if QA:CheckConfigs() and QA.db.greeting then
        if T.GetGossipAvailableQuests() then
            T.SelectGossipAvailableQuest(1)
        elseif T.GetGossipActiveQuests() then
            T.SelectGossipActiveQuest(1)
        end
    end
end

function QA:QUEST_DETAIL()
    --if IsQuestIgnored() then
        --return
    --end

    if QA:CheckConfigs() and QA:CheckQuestData() and QA.db.accept then
        T.AcceptQuest()
    end
end

function QA:QUEST_ACCEPT_CONFIRM()
    if QA:CheckConfigs() and QA.db.escort then
        T.ConfirmAcceptQuest()
    end
end

function QA:QUEST_PROGRESS()
    if QA:CheckConfigs() and QA.db.complete then
        T.CompleteQuest()
    end
end

local dbg = 0;
function QA:SelectQuestReward(index)
	local frame = _G.QuestInfoFrame.rewardsFrame;
	
	if dbg == 1 then
		KUI:Print("index: "..index)
	end

	local button = T.QuestInfo_GetRewardButton(frame, index)
	if (button.type == "choice") then
		_G.QuestInfoItemHighlight:ClearAllPoints()
		_G.QuestInfoItemHighlight:SetOutside(button.Icon)

		if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.quest ~= true then
			_G.QuestInfoItemHighlight:SetPoint("TOPLEFT", button, "TOPLEFT", -8, 7);
		else
			button.Name:SetTextColor(1, 1, 0)
		end
		_G.QuestInfoItemHighlight:Show()

		-- set choice
		_G.QuestInfoFrame.itemChoice = button:GetID()
	end
end

function QA:QUEST_COMPLETE()
    if QA:CheckConfigs() and QA.db.complete then
        if T.GetNumQuestChoices() == 0 then
            T.GetQuestReward(_G.QuestFrameRewardPanel.itemChoice)
        elseif T.GetNumQuestChoices() == 1 and _G.QuestFrameRewardPanel.itemChoice == nil then
            T.GetQuestReward(1)
        end
    end
	
	if QA.db.reward then
		local choice, highest = 1, 0
		local num = T.GetNumQuestChoices()

		if dbg == 1 then
			KUI:Print("GetNumQuestChoices"..num)
		end
		
		if num <= 0 then return end -- no choices

		for index = 1, num do
			local link = T.GetQuestItemLink("choice", index);
			if link then
				local price = T.select(11, T.GetItemInfo(link))
				if price and price > highest then
					highest = price
					choice = index
				end
			end
		end
		if dbg == 1 then
			KUI:Print("Choice: "..choice)
		end
		QA:SelectQuestReward(choice)
	end
end

function QA:Initialize()
	if not E.db.KlixUI.quest.auto.enable or T.IsAddOnLoaded("AAP-Classic") or T.IsAddOnLoaded("Guidelime") then return end

	QA.db = E.db.KlixUI.quest.auto
	
	self:CheckConfigs()
	self:CheckQuestData()
		
	self:RegisterEvent("QUEST_GREETING")
	self:RegisterEvent("GOSSIP_SHOW")
	self:RegisterEvent("QUEST_DETAIL")
	self:RegisterEvent("QUEST_ACCEPT_CONFIRM")
	self:RegisterEvent("QUEST_PROGRESS")
	self:RegisterEvent("QUEST_COMPLETE")
end

local function InitializeCallback()
	QA:Initialize()
end

KUI:RegisterModule(QA:GetName(), InitializeCallback)