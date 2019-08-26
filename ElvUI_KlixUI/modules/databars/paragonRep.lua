local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local PR = KUI:NewModule("ParagonReputation", "AceHook-3.0")

--local ACTIVE_TOAST = false
--local WAITING_TOAST = {}

local PARAGON_QUEST_ID = { --[QuestID] = {factionID,rewardID}
	-- Legion
		[48976] = {2170, 152922}, -- Argussian Reach
		[46777] = {2045, 152108}, -- Armies of Legionfall
		[48977] = {2165, 152923}, -- Army of the Light
		[46745] = {1900, 152102}, -- Court of Farondis
		[46747] = {1883, 152103}, -- Dreamweavers
		[46743] = {1828, 152104}, -- Highmountain Tribes
		[46748] = {1859, 152105}, -- The Nightfallen
		[46749] = {1894, 152107}, -- The Wardens
		[46746] = {1948, 152106}, -- Valarjar
	
	-- Battle for Azeroth
		-- Neutral
		[54453] = {2164, 166298}, -- Champions of Azeroth
		[54451] = {2163, 166245}, -- Tortollan Seekers
		
		-- Horde
		[54460] = {2156, 166282}, -- Talanji's Expedition
		[54455] = {2157, 166299}, -- The Honorbound
		[54461] = {2158, 166290}, -- Voldunai
		[54462] = {2103, 166292}, -- Zandalari Empire
		
		-- Alliance
		[54456] = {2161, 166297}, -- Orber of Embers
		[54458] = {2160, 166295}, -- Proudmoore Admiralty
		[54457] = {2162, 166294}, -- Storm's Wake
		[54454] = {2159, 166300}, -- The 7th Legion
}

function PR:Initialize()
	if not E.db.KlixUI.databars.paragon.enable then return end
	
	PR.db = E.db.KlixUI.databars.paragon
	
	-- Color the Reputation Watchbar by the settings.
	hooksecurefunc(ReputationBarMixin, "Update", function(self)
		local _, _, _, _, _, factionID = T.GetWatchedFactionInfo()
		if factionID and T.C_Reputation_IsFactionParagon(factionID) then
			self:SetBarColor(PR.db.color.r, PR.db.color.g, PR.db.color.b)
		end
	end)

	-- Setup the Paragon Tooltip accordingly.
	hooksecurefunc("ReputationParagonFrame_SetupParagonTooltip", function(self)
		local _, _, rewardQuestID, hasRewardPending = T.C_Reputation_GetFactionParagonInfo(self.factionID)
		if hasRewardPending then
			local factionName = T.GetFactionInfoByID(self.factionID)
			local questIndex = T.GetQuestLogIndexByID(rewardQuestID)
			local description = T.GetQuestLogCompletionText(questIndex) or ""
			EmbeddedItemTooltip:SetText(L["Paragon"])
			EmbeddedItemTooltip:AddLine(description, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, 1)
			T.GameTooltip_AddQuestRewardsToTooltip(EmbeddedItemTooltip, rewardQuestID)
			EmbeddedItemTooltip:Show()
		else
			EmbeddedItemTooltip:Hide()
		end
	end)

	-- Show the GameTooltip with the Item Reward Hyperlink on mouseover. (Thanks Brudarek)
	function PR:Tooltip(self, event)
		if not self.questID then return end
		if event == "OnEnter" then
			local _, link = T.GetItemInfo(PARAGON_QUEST_ID[self.questID][2])
			if link ~= nil then
				GameTooltip:SetOwner(self, "ANCHOR_NONE")
				GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMRIGHT")
				GameTooltip:SetHyperlink(link)
				GameTooltip:Show()
			end
		elseif event == "OnLeave" then
			T.GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
			GameTooltip:Hide()
		end
	end

	-- Hook the Reputation Bars Scripts to show the Tooltip.
	function PR:HookScript()
		for n = 1, NUM_FACTIONS_DISPLAYED do
			if _G["ReputationBar"..n] then
				_G["ReputationBar"..n]:HookScript("OnEnter", function(self)
					PR:Tooltip(self, "OnEnter")
				end)
				_G["ReputationBar"..n]:HookScript("OnLeave", function(self)
					PR:Tooltip(self, "OnLeave")
				end)
			end
		end
	end

	-- TODO: Need to implement this in my Toast function!
	--[[
	-- Show the Paragon Toast if a Paragon Reward Quest is accepted.
	function PR:ShowToast(name, text)
		ACTIVE_TOAST = true
		if PR.db.sound then PlaySound(44295, "master", true) end
		PR.toast:EnableMouse(false)
		PR.toast.title:SetText(name)
		PR.toast.title:SetAlpha(0)
		PR.toast.description:SetText(text)
		PR.toast.description:SetAlpha(0)
		PR.toast.reset:Hide()
		PR.toast.lock:Hide()
		T.UIFrameFadeIn(PR.toast, .5 ,0, 1)
		T.C_Timer_After(.5, function()
			T.UIFrameFadeIn(PR.toast.title, .5, 0, 1)
		end)
		T.C_Timer_After(.75, function()
			T.UIFrameFadeIn(PR.toast.description, .5, 0, 1)
		end)
		T.C_Timer_After(PR.db.fade, function()
			T.UIFrameFadeOut(PR.toast, 1, 1, 0)
		end)
		T.C_Timer_After(PR.db.fade+1.25, function()
			PR.toast:Hide()
			ACTIVE_TOAST = false
			if #WAITING_TOAST > 0 then
				PR:WaitToast()
			end
		end)
	end

	-- Get next Paragon Reward Quest if more than two are accepted at the same time.
	function PR:WaitToast()
		local name, text = T.unpack(WAITING_TOAST[1])
		T.table_remove(WAITING_TOAST, 1)
		PR:ShowToast(name, text)
	end

	-- Handle the QUEST_ACCEPTED event.
	local reward = T.CreateFrame("FRAME")
	reward:RegisterEvent("QUEST_ACCEPTED")
	reward:SetScript("OnEvent", function(self, event, ...)
		local questIndex, questID = ...
		if PR.db.toast and PARAGON_QUEST_ID[questID] then
			local name = T.GetFactionInfoByID(PARAGON_QUEST_ID[questID][1])
			local text = T.GetQuestLogCompletionText(questIndex)
			if ACTIVE_TOAST then
				WAITING_TOAST[#WAITING_TOAST+1] = {name, text} -- Toast is already active, put this info on the line.
			else
				PR:ShowToast(name, text)
			end
		end
	end)
	]]

	-- Change the Reputation Bars accordingly.
	hooksecurefunc("ReputationFrame_Update", function()
		ReputationFrame.paragonFramesPool:ReleaseAll()
		local factionOffset = T.FauxScrollFrame_GetOffset(ReputationListScrollFrame)
		for n = 1, NUM_FACTIONS_DISPLAYED, 1 do
			local factionIndex = factionOffset+n
			local factionRow = _G["ReputationBar"..n]
			local factionBar = _G["ReputationBar"..n.."ReputationBar"]
			local factionStanding = _G["ReputationBar"..n.."ReputationBarFactionStanding"]
			if factionIndex <= T.GetNumFactions() then
				local name, _, _, _, _, _, _, _, _, _, _, _, _, factionID = T.GetFactionInfo(factionIndex)
				if factionID and T.C_Reputation_IsFactionParagon(factionID) then
					local currentValue, threshold, rewardQuestID, hasRewardPending = T.C_Reputation_GetFactionParagonInfo(factionID)
					factionRow.questID = rewardQuestID
					if currentValue then
						local value = T.mod(currentValue, threshold)
						if hasRewardPending then
							local paragonFrame = ReputationFrame.paragonFramesPool:Acquire()
							paragonFrame.factionID = factionID
							paragonFrame:SetPoint("RIGHT", factionRow, 11, 0)
							paragonFrame.Glow:SetShown(true)
							paragonFrame.Check:SetShown(true)
							paragonFrame:Show()
							value = value + threshold
						end
						factionBar:SetMinMaxValues(0, threshold)
						factionBar:SetValue(value)
						factionBar:SetStatusBarColor(PR.db.color.r, PR.db.color.g, PR.db.color.b)
						factionRow.rolloverText = HIGHLIGHT_FONT_COLOR_CODE.." "..T.string_format(REPUTATION_PROGRESS_FORMAT, T.BreakUpLargeNumbers(value), T.BreakUpLargeNumbers(threshold))..FONT_COLOR_CODE_CLOSE
						if PR.db.text == "PARAGON" then
							factionStanding:SetText(L["Paragon"])
							factionRow.standingText = L["Paragon"]
						elseif PR.db.text == "CURRENT"  then
							factionStanding:SetText(T.BreakUpLargeNumbers(value))
							factionRow.standingText = T.BreakUpLargeNumbers(value)
						elseif PR.db.text == "VALUE" then
							factionStanding:SetText(" "..T.BreakUpLargeNumbers(value).." / "..T.BreakUpLargeNumbers(threshold))
							factionRow.standingText = (" "..T.BreakUpLargeNumbers(value).." / "..T.BreakUpLargeNumbers(threshold))
							factionRow.rolloverText = nil					
						elseif PR.db.text == "DEFICIT" then
							if hasRewardPending then
								value = value - threshold
								factionStanding:SetText("+"..T.BreakUpLargeNumbers(value))
								factionRow.standingText = "+"..T.BreakUpLargeNumbers(value)
							else
								value = threshold - value
								factionStanding:SetText(T.BreakUpLargeNumbers(value))
								factionRow.standingText = T.BreakUpLargeNumbers(value)
							end
							factionRow.rolloverText = nil
						end
						if factionIndex == T.GetSelectedFaction() and ReputationDetailFrame:IsShown() then
							local count = T.math_floor(currentValue/threshold)
							if hasRewardPending then count = count-1 end
							if count > 0 then
								ReputationDetailFactionName:SetText(name.." |cffffffffx"..count.."|r")
							end
						end
					end
				else
					factionRow.questID = nil
				end
			else
				factionRow:Hide()
			end
		end
	end)
end

local function InitializeCallback()
	PR:Initialize()
end

KUI:RegisterModule(PR:GetName(), InitializeCallback)