local KUI, T, E, L, V, P, G = unpack(select(2, ...))

if E.private.actionbar.enable ~= true then return end

local questAreas = {
	-- Global
	[24629] = true,

	-- Icecrown
	[14108] = 541,

	-- Northern Barrens
	[13998] = 11,

	-- Un'Goro Crater
	[24735] = 201,

	-- Darkmoon Island
	[29506] = 823,
	[29510] = 823,

	-- Mulgore
	[24440] = 9,
	[14491] = 9,
	[24456] = 9,
	[24524] = 9,

	-- Mount Hyjal
	[25577] = 606,
}

-- Quests items with incorrect or missing quest area blobs
local itemAreas = {
	-- Global
	[34862] = true,
	[34833] = true,
	[39700] = true,

	-- Deepholm
	[58167] = 640,
	[60490] = 640,

	-- Ashenvale
	[35237] = 43,

	-- Thousand Needles
	[56011] = 61,

	-- Tanaris
	[52715] = 161,

	-- The Jade Forest
	[84157] = 806,
	[89769] = 806,

	-- Hellfire Peninsula
	[28038] = 465,
	[28132] = 465,

	-- Borean Tundra
	[35352] = 486,
	[34772] = 486,
	[34711] = 486,
	[35288] = 486,
	[34782] = 486,

	-- Zul'Drak
	[41161] = 496,
	[39157] = 496,
	[39206] = 496,
	[39238] = 496,
	[39664] = 496,
	[38699] = 496,
	[41390] = 496,

	-- Dalaran (Broken Isles)
	[129047] = 1014,

	-- Stormheim
	[128287] = 1017,
	[129161] = 1017,

	-- Azsuna
	[118330] = 1015,

	-- Suramar
	[133882] = 1033,
}

local ExtraQuestButton = T.CreateFrame("Button", "ExtraQuestButton", UIParent, "SecureActionButtonTemplate, SecureHandlerStateTemplate, SecureHandlerAttributeTemplate")
ExtraQuestButton:SetMovable(true)
ExtraQuestButton:RegisterEvent("PLAYER_LOGIN")
ExtraQuestButton:SetScript("OnEvent", function(self, event, ...)
	if(self[event]) then
		self[event](self, event, ...)
	elseif(self:IsEnabled()) then
		self:Update()
	end
end)

local visibilityState = "[extrabar][petbattle] hide; show"
local onAttributeChanged = [[
	if(name == "item") then
		if(value and not self:IsShown() and not HasExtraActionBar()) then
			self:Show()
		elseif(not value) then
			self:Hide()
			self:ClearBindings()
		end
	elseif(name == "state-visible") then
		if(value == "show") then
			self:CallMethod("Update")
		else
			self:Hide()
			self:ClearBindings()
		end
	end
	if(self:IsShown() and (name == "item" or name == "binding")) then
		self:ClearBindings()
		local key = GetBindingKey("EXTRAACTIONBUTTON1")
		if(key) then
			self:SetBindingClick(1, key, self, "LeftButton")
		end
	end
]]

function ExtraQuestButton:BAG_UPDATE_COOLDOWN()
	-- if E.private.actionbar.enable ~= true then return; end
	if(self:IsShown() and self:IsEnabled()) then
		local start, duration, enable = T.GetItemCooldown(self.itemID)
		if(duration > 0) then
			self.Cooldown:SetCooldown(start, duration)
			self.Cooldown:Show()
		else
			self.Cooldown:Hide()
		end
	end
end

function ExtraQuestButton:BAG_UPDATE_DELAYED()
	self:Update()

	if(self:IsShown() and self:IsEnabled()) then
		local count = T.GetItemCount(self.itemLink)
		self.Count:SetText(count and count > 1 and count or "")
	end
end

function ExtraQuestButton:PLAYER_REGEN_ENABLED(event)
	self:SetAttribute("item", self.attribute)
	self:UnregisterEvent(event)
	self:BAG_UPDATE_COOLDOWN()
end

function ExtraQuestButton:UPDATE_BINDINGS()
	if(self:IsShown() and self:IsEnabled()) then
		self:SetItem()
		self:SetAttribute("binding", T.GetTime())
	end
end

function ExtraQuestButton:PLAYER_LOGIN()
	T.RegisterStateDriver(self, "visible", visibilityState)
	self:SetAttribute("_onattributechanged", onAttributeChanged)
	self:SetAttribute("type", "item")

	if(not self:GetPoint()) then
		self:SetPoint("CENTER", _G["BossButton"])
	end

	self:SetSize(_G["BossButton"]:GetSize())
	self:SetScale(_G["BossButton"]:GetScale()/1.10)
	self:SetHighlightTexture("")
	self:SetPushedTexture("")
	-- self:GetPushedTexture():SetBlendMode("ADD")
	self:SetScript("OnLeave", GameTooltip_Hide)
	self:SetClampedToScreen(true)
	self:SetToplevel(true)

	self:CreateBackdrop("Default")

	self.updateTimer = 0
	self.rangeTimer = 0
	self:Hide()

	local Icon = self:CreateTexture("$parentIcon", "ARTWORK")
	Icon:SetAllPoints()
	self.Icon = Icon

	local HotKey = self:CreateFontString("$parentHotKey", nil, "NumberFontNormalGray")
	HotKey:SetPoint('TOP', ExtraQuestButton, 'TOP', 1, -1)
	self.HotKey = HotKey

	local Count = self:CreateFontString("$parentCount", nil, "NumberFontNormal")
	Count:SetPoint("TOPLEFT", 7, -7)
	self.Count = Count

	local Cooldown = T.CreateFrame("Cooldown", "$parentCooldown", self, "CooldownFrameTemplate")
	Cooldown:SetFrameLevel(self:GetFrameLevel() + 2)
	Cooldown:ClearAllPoints()
	Cooldown:SetPoint("TOPRIGHT", -2, -3)
	Cooldown:SetPoint("BOTTOMLEFT", 2, 1)
	Cooldown:Hide()
	self.Cooldown = Cooldown
	
	self.Icon:SetTexCoord(.08, .92, .08, .92)
	self:StyleButton(true)
	self:CreateIconShadow()

	self:RegisterEvent("UPDATE_BINDINGS")
	self:RegisterEvent("BAG_UPDATE_COOLDOWN")
	self:RegisterEvent("BAG_UPDATE_DELAYED")
	self:RegisterEvent("QUEST_LOG_UPDATE")
	self:RegisterEvent("QUEST_POI_UPDATE")
	self:RegisterEvent("QUEST_WATCH_LIST_CHANGED")
	self:RegisterEvent("QUEST_ACCEPTED")
	self:RegisterEvent("QUEST_REMOVED")
	self:RegisterEvent("ZONE_CHANGED")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("VIGNETTES_UPDATED")
	self:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")
end

local worldQuests = {}
function ExtraQuestButton:QUEST_REMOVED(event, questID)
	if(worldQuests[questID]) then
		worldQuests[questID] = nil

		self:Update()
	end
end

function ExtraQuestButton:QUEST_ACCEPTED(event, questLogIndex, questID)
	if(questID and not T.IsQuestBounty(questID) and T.IsQuestTask(questID)) then
		local _, _, worldQuestType = T.GetQuestTagInfo(questID)
		if(worldQuestType and not worldQuests[questID]) then
			worldQuests[questID] = questLogIndex

			self:Update()
		end
	end
end

ExtraQuestButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetHyperlink(self.itemLink)
end)

ExtraQuestButton:SetScript("OnUpdate", function(self, elapsed)
	if(not self:IsEnabled()) then
		return
	end

	if(self.rangeTimer > TOOLTIP_UPDATE_TIME) then
		local HotKey = self.HotKey

		-- BUG: IsItemInRange() is broken versus friendly npcs (and possibly others)
		local inRange = T.IsItemInRange(self.itemLink, "target")
		if(HotKey:GetText() == RANGE_INDICATOR) then
			if(inRange == false) then
				HotKey:SetTextColor(1, 0.1, 0.1)
				HotKey:Show()
			elseif(inRange) then
				HotKey:SetTextColor(0.6, 0.6, 0.6)
				HotKey:Show()
			else
				HotKey:Hide()
			end
		else
			if(inRange == false) then
				HotKey:SetTextColor(1, 0.1, 0.1)
			else
				HotKey:SetTextColor(0.6, 0.6, 0.6)
			end
		end

		self.rangeTimer = 0
	else
		self.rangeTimer = self.rangeTimer + elapsed
	end

	if(self.updateTimer > 5) then
		self:Update()
		self.updateTimer = 0
	else
		self.updateTimer = self.updateTimer + elapsed
	end
end)

ExtraQuestButton:SetScript("OnEnable", function(self)
	T.RegisterStateDriver(self, "visible", visibilityState)
	self:SetAttribute("_onattributechanged", onAttributeChanged)
	self:Update()
	self:SetItem()
end)

ExtraQuestButton:SetScript("OnDisable", function(self)
	if(not self:IsMovable()) then
		self:SetMovable(true)
	end

	T.RegisterStateDriver(self, "visible", "show")
	self:SetAttribute("_onattributechanged", nil)
	self.Icon:SetTexture([[Interface\Icons\INV_Misc_Wrench_01]])
	self.HotKey:Hide()
end)

-- Sometimes blizzard does actually do what I want
local blacklist = {
	[113191] = true,
	[110799] = true,
	[109164] = true,
}

function ExtraQuestButton:SetItem(itemLink, texture)
	if(T.HasExtraActionBar()) then
		return
	end

	if(itemLink) then
		self.Icon:SetTexture(texture)

		if(itemLink == self.itemLink and self:IsShown()) then
			return
		end

		local itemID, itemName = T.string_match(itemLink, "|Hitem:(.-):.-|h%[(.+)%]|h")
		self.itemID = T.tonumber(itemID)
		self.itemName = itemName
		self.itemLink = itemLink

		if(blacklist[itemID]) then
			return
		end
	end

	local HotKey = self.HotKey
	local key = T.GetBindingKey("EXTRAACTIONBUTTON1")
	if(key) then
		HotKey:SetText(T.GetBindingText(key, 1))
		HotKey:Show()
	elseif(T.ItemHasRange(itemLink)) then
		HotKey:SetText(RANGE_INDICATOR)
		HotKey:Show()
	else
		HotKey:Hide()
	end

	if(T.InCombatLockdown()) then
		self.attribute = self.itemName
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
	else
		self:SetAttribute("item", self.itemName)
		self:BAG_UPDATE_COOLDOWN()
	end
end

function ExtraQuestButton:RemoveItem()
	if(T.InCombatLockdown()) then
		self.attribute = nil
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
	else
		self:SetAttribute("item", nil)
	end
end

local function GetClosestQuestItem()
	-- Basically a copy of QuestSuperTracking_ChooseClosestQuest from Blizzard_ObjectiveTracker
	local closestQuestLink, closestQuestTexture
	local shortestDistanceSq = 62500 -- 250 yards
	local numItems = 0

	for questID, questLogIndex in T.next, worldQuests do
		local itemLink, texture, _, showCompleted = T.GetQuestLogSpecialItemInfo(questLogIndex)
		if(itemLink) then
			local areaID = questAreas[questID]
			if(not areaID) then
				areaID = itemAreas[T.tonumber(T.string_match(itemLink, "item:(%d+)"))]
			end

			local _, _, _, _, _, isComplete = T.GetQuestLogTitle(questLogIndex)
			if(areaID and (T.type(areaID) == "boolean" or areaID == T.C_Map_GetBestMapForUnit("player"))) then
				closestQuestLink = itemLink
				closestQuestTexture = texture
			elseif(not isComplete or (isComplete and showCompleted)) then
				local distanceSq, onContinent = T.GetDistanceSqToQuest(questLogIndex)
				if(onContinent and distanceSq <= shortestDistanceSq) then
					shortestDistanceSq = distanceSq
					closestQuestLink = itemLink
					closestQuestTexture = texture
				end
			end

			numItems = numItems + 1
		end
	end

	if(not closestQuestLink) then
		for index = 1, T.GetNumQuestWatches() do
			local questID, _, questLogIndex, _, _, isComplete = T.GetQuestWatchInfo(index)
			if(questID and T.QuestHasPOIInfo(questID)) then
				local itemLink, texture, _, showCompleted = T.GetQuestLogSpecialItemInfo(questLogIndex)
				if(itemLink) then
					local areaID = questAreas[questID]
					if(not areaID) then
						areaID = itemAreas[T.tonumber(T.string_match(itemLink, "item:(%d+)"))]
					end

					if(areaID and (T.type(areaID) == "boolean" or areaID == T.C_Map_GetBestMapForUnit("player"))) then
						closestQuestLink = itemLink
						closestQuestTexture = texture
					elseif(not isComplete or (isComplete and showCompleted)) then
						local distanceSq, onContinent = T.GetDistanceSqToQuest(questLogIndex)
						if(onContinent and distanceSq <= shortestDistanceSq) then
							shortestDistanceSq = distanceSq
							closestQuestLink = itemLink
							closestQuestTexture = texture
						end
					end

					numItems = numItems + 1
				end
			end
		end
	end

	if(not closestQuestLink) then
		for questLogIndex = 1, T.GetNumQuestLogEntries() do
			local _, _, _, isHeader, _, isComplete, _, questID = T.GetQuestLogTitle(questLogIndex)
			if(not isHeader and T.QuestHasPOIInfo(questID)) then
				local itemLink, texture, _, showCompleted = T.GetQuestLogSpecialItemInfo(questLogIndex)
				if(itemLink) then
					local areaID = questAreas[questID]
					if(not areaID) then
						areaID = itemAreas[T.tonumber(T.string_match(itemLink, "item:(%d+)"))]
					end

					if(areaID and (T.type(areaID) == "boolean" or areaID == T.C_Map_GetBestMapForUnit("player"))) then
						closestQuestLink = itemLink
						closestQuestTexture = texture
					elseif(not isComplete or (isComplete and showCompleted)) then
						local distanceSq, onContinent = T.GetDistanceSqToQuest(questLogIndex)
						if(onContinent and distanceSq <= shortestDistanceSq) then
							shortestDistanceSq = distanceSq
							closestQuestLink = itemLink
							closestQuestTexture = texture
						end
					end

					numItems = numItems + 1
				end
			end
		end
	end

	return closestQuestLink, closestQuestTexture, numItems
end

local ticker
function ExtraQuestButton:Update()
	if(not self:IsEnabled() or self.locked or not E.private.actionbar.enable or not E.db.KlixUI.actionbars.questButton or T.IsAddOnLoaded("ExtraQuestButton")) then
		return
	end

	local itemLink, texture, numItems = GetClosestQuestItem()
	if(itemLink) then
		self:SetItem(itemLink, texture)
	elseif(self:IsShown()) then
		self:RemoveItem()
	end

	if(numItems > 0 and not ticker) then
		ticker = T.C_Timer_NewTicker(30, function() -- might want to lower this
			ExtraQuestButton:Update()
		end)
	elseif(numItems == 0 and ticker) then
		ticker:Cancel()
		ticker = nil
	end
end