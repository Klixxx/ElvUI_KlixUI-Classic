local KUI, T, E, L, V, P, G = unpack(select(2, ...))

local WQ = T.CreateFrame("Frame")
WQ:RegisterEvent("PLAYER_ENTERING_WORLD")
WQ:SetScript("OnEvent", function(self, event)
	if E.db.KlixUI.maps.worldmap == nil then E.db.KlixUI.maps.worldmap = {} end
	if not E.db.KlixUI.maps.worldmap.worldquests then return end
	if T.IsAddOnLoaded("BetterWorldQuests")
	or T.IsAddOnLoaded("WorldQuestTracker")
	or T.IsAddOnLoaded("WorldQuestsList")
	or T.IsAddOnLoaded("WorldQuestTab") then 
		return 
	end

	local parentMaps = {
		-- list of all continents and their sub-zones that have world quests
		[619] = { -- Broken Isles
			[630] = true, -- Azsuna
			[641] = true, -- Val'sharah
			[650] = true, -- Highmountain
			[634] = true, -- Stormheim
			[680] = true, -- Suramar
			[627] = true, -- Dalaran
			[790] = true, -- Eye of Azshara (world version)
			[646] = true, -- Broken Shore
		},
		[994] = { -- Argus (our modified one, the original ID is 905)
			[830] = true, -- Krokuun
			[885] = true, -- Antoran Wastes
			[882] = true, -- Mac'Aree
		},
		[875] = { -- Zandalar
			[862] = true, -- Zuldazar
			[864] = true, -- Vol'Dun
			[863] = true, -- Nazmir
		},
		[876] = { -- Kul Tiras
			[895] = true, -- Tiragarde Sound
			[896] = true, -- Drustvar
			[942] = true, -- Stormsong Valley
		},
		[13] = { -- Eastern Kingdoms
			[14] = true, -- Arathi Highlands (Warfronts)
		},
		[12] = { -- Kalimdor
			[62] = true, -- Darkshore (Warfronts)
		},
	}
	local factionAssaultAtlasName = UnitFactionGroup('player') == 'Horde' and 'worldquest-icon-horde' or 'worldquest-icon-alliance'

	local function AdjustedMapID(mapID)
		-- this will replace the Argus map ID with the one used by the taxi UI, since one of the
		-- features of this addon is replacing the Argus map art with the taxi UI one
		return mapID == 905 and 994 or mapID
	end

	-- create a new data provider that will display the world quests on zones from the list above,
	-- based on WorldQuestDataProviderMixin
	local DataProvider = CreateFromMixins(WorldQuestDataProviderMixin)
	DataProvider:SetMatchWorldMapFilters(true)
	DataProvider:SetUsesSpellEffect(true)
	DataProvider:SetCheckBounties(true)
	DataProvider:SetMarkActiveQuests(true)

	function DataProvider:GetPinTemplate()
		-- we use our own copy of the WorldMap_WorldQuestPinTemplate template to avoid interference
		return 'KuiWorldQuestPinTemplate'
	end

	function DataProvider:ShouldShowQuest(questInfo)
		local questID = questInfo.questId
		if(self.focusedQuestID or self:IsQuestSuppressed(questID)) then
			return false
		else
			-- returns true if the given quest is a world quest on one of the maps in our list
			local mapID = AdjustedMapID(self:GetMap():GetMapID())
			local questMapID = questInfo.mapID
			if(mapID == questMapID or (parentMaps[mapID] and parentMaps[mapID][questMapID])) then
				return HaveQuestData(questID) and QuestUtils_IsQuestWorldQuest(questID)
			end
		end
	end

	function DataProvider:RefreshAllData()
		-- map is updated, draw world quest pins
		local pinsToRemove = {}
		for questID in next, self.activePins do
			-- mark all pins for removal
			pinsToRemove[questID] = true
		end

		local Map = self:GetMap()
		local mapID = AdjustedMapID(Map:GetMapID())

		local quests = mapID and C_TaskQuest.GetQuestsForPlayerByMapID(mapID)
		if(quests) then
			for _, questInfo in next, quests do
				if(self:ShouldShowQuest(questInfo) and self:DoesWorldQuestInfoPassFilters(questInfo)) then
					local questID = questInfo.questId
					pinsToRemove[questID] = nil -- unmark the pin for removal

					local Pin = self.activePins[questID]
					if(Pin) then
						-- update existing pin
						Pin:RefreshVisuals()
						Pin:SetPosition(questInfo.x, questInfo.y)

						if(self.pingPin and self.pingPin:IsAttachedToQuest(questID)) then
							self.pingPin:SetScalingLimits(1, 1, 1)
							self.pingPin:SetPosition(questInfo.x, questInfo.y)
						end
					else
						-- create a new pin
						self.activePins[questID] = self:AddWorldQuest(questInfo)
					end
				end
			end
		end

		for questID in next, pinsToRemove do
			-- iterate and remove all pins marked for removal
			if(self.pingPin and self.pingPin:IsAttachedToQuest(questID)) then
				self.pingPin:Stop()
			end

			Map:RemovePin(self.activePins[questID])
			self.activePins[questID] = nil
		end

		-- trigger callbacks like WorldQuestDataProviderMixin.RefreshAllData does
		Map:TriggerEvent('WorldQuestUpdate', Map:GetNumActivePinsByTemplate(self:GetPinTemplate()))
	end

	WorldMapFrame:AddDataProvider(DataProvider)

	KuiWorldQuestPinMixin = CreateFromMixins(WorldMap_WorldQuestPinMixin)
	function KuiWorldQuestPinMixin:OnLoad()
		WorldQuestPinMixin.OnLoad(self)

		-- create any extra widgets we need if they don't already exist
		local Border = self:CreateTexture(nil, 'OVERLAY', nil, 1)
		Border:SetPoint('CENTER', 0, -3)
		Border:SetAtlas('worldquest-emissary-ring')
		Border:SetSize(72, 72)
		--Border:SetVertexColor(KUI.r, KUI.g, KUI.b)
		self.Border = Border

		-- create the indicator on a subframe so highlights don't overlap
		local Indicator = CreateFrame('Frame', nil, self):CreateTexture(nil, 'OVERLAY', nil, 2)
		Indicator:SetPoint('CENTER', self, -19, 19)
		Indicator:SetSize(44, 44)
		self.Indicator = Indicator

		local Bounty = self:CreateTexture(nil, 'OVERLAY', nil, 2)
		Bounty:SetSize(44, 44)
		Bounty:SetAtlas('QuestNormal')
		Bounty:SetPoint('CENTER', 22, 0)
		self.Bounty = Bounty

		-- make sure the tracked check mark doesn't appear underneath any of our widgets
		self.TrackedCheck:SetDrawLayer('OVERLAY', 3)
	end

	local function IsParentMap(mapID)
		return not not parentMaps[AdjustedMapID(mapID)]
	end

	function KuiWorldQuestPinMixin:RefreshVisuals()
		WorldMap_WorldQuestPinMixin.RefreshVisuals(self)

		-- update scale
		if(IsParentMap(self:GetMap():GetMapID())) then
			self:SetScalingLimits(1, 0.3, 0.5)
		else
			self:SetScalingLimits(1, 0.425, 0.425)
		end

		-- hide frames we don't want to use
		self.BountyRing:Hide()
	
		-- set texture to the item/currency/value it rewards
		local questID = self.questID
		if(GetNumQuestLogRewards(questID) > 0) then
			local _, texture, _, quality = GetQuestLogRewardInfo(1, questID)
			SetPortraitToTexture(self.Texture, texture)
			self.Texture:SetSize(self:GetSize())
		elseif(GetNumQuestLogRewardCurrencies(questID) > 0) then
			local _, texture = GetQuestLogRewardCurrencyInfo(1, questID)
			SetPortraitToTexture(self.Texture, texture)
			self.Texture:SetSize(self:GetSize())
		elseif(GetQuestLogRewardMoney(questID) > 0) then
			SetPortraitToTexture(self.Texture, [[Interface\Icons\inv_misc_coin_01]])
			self.Texture:SetSize(self:GetSize())
		end
		--[[
		-- poi ring color
		for i = 1, GetNumQuestLogRewardCurrencies(questID) do
			local name, texture, numItems, currencyID = GetQuestLogRewardCurrencyInfo(i, questID)
			if currencyID == 1508 or currencyID == 1533 or currencyID == 1721 then -- Veiled Argunite, Wakening Essence, Prismatic Manapearl
				self.Border:SetVertexColor(1, 0, 1)
			elseif currencyID == 1553 then -- Azerite
				self.Border:SetVertexColor(0, 0.69, 1)
			elseif currencyID == 1560 or 1220 then -- War and Order ressources
				self.Border:SetVertexColor(0.64, 0.35, 0.19)
			end
		end
		]]
		-- update our own widgets
		local bountyQuestID = self.dataProvider:GetBountyQuestID()
		self.Bounty:SetShown(bountyQuestID and IsQuestCriteriaForBounty(questID, bountyQuestID))

		local Indicator = self.Indicator
		local _, _, worldQuestType, _, _, professionID = GetQuestTagInfo(questID)
		if(worldQuestType == LE_QUEST_TAG_TYPE_PVP) then
			self.Indicator:SetAtlas('Warfronts-BaseMapIcons-Empty-Barracks-Minimap')
			self.Indicator:SetSize(58, 58)
			self.Indicator:Show()
		else
			self.Indicator:SetSize(44, 44)
			if(worldQuestType == LE_QUEST_TAG_TYPE_PET_BATTLE) then
				self.Indicator:SetAtlas('WildBattlePetCapturable')
				self.Indicator:Show()
			elseif(worldQuestType == LE_QUEST_TAG_TYPE_PROFESSION) then
				self.Indicator:SetAtlas(WORLD_QUEST_ICONS_BY_PROFESSION[professionID])
				self.Indicator:Show()
			elseif(worldQuestType == LE_QUEST_TAG_TYPE_DUNGEON) then
				self.Indicator:SetAtlas('Dungeon')
				self.Indicator:Show()
			elseif(worldQuestType == LE_QUEST_TAG_TYPE_RAID) then
				self.Indicator:SetAtlas('Raid')
				self.Indicator:Show()
			elseif(worldQuestType == LE_QUEST_TAG_TYPE_INVASION) then
				self.Indicator:SetAtlas('worldquest-icon-burninglegion')
				self.Indicator:Show()
			elseif(worldQuestType == LE_QUEST_TAG_TYPE_FACTION_ASSAULT) then
				self.Indicator:SetAtlas(factionAssaultAtlasName)
				self.Indicator:SetSize(38, 38)
				self.Indicator:Show()
			else
				self.Indicator:Hide()
			end
		end
	end

	-- we need to remove the default data provider mixin
	for provider in next, WorldMapFrame.dataProviders do
		if(provider.GetPinTemplate and provider.GetPinTemplate() == 'WorldMap_WorldQuestPinTemplate') then
			WorldMapFrame:RemoveDataProvider(provider)
		end
	end
end)
