-------------------------------------------------------------------------------
-- Baased on: TeleportCloak - Jordon
-------------------------------------------------------------------------------
local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local TP = KUI:NewModule("Teleportation", "AceEvent-3.0")

local List = {
	Cloak = {
		65274, -- Cloak of Coordination (Horde)
		65360, -- Cloak of Coordination (Alliance)
		63206, -- Wrap of Unity (Alliance)
		63207, -- Wrap of Unity (Horde)
		63352, -- Shroud of Cooperation (Alliance)
		63353, -- Shroud of Cooperation (Horde)
	},
	Trinket = {
		103678, -- Time-Lost Artifact
		17691, -- Stormpike Insignia Rank 1
		17900, -- Stormpike Insignia Rank 2
		17901, -- Stormpike Insignia Rank 3
		17902, -- Stormpike Insignia Rank 4
		17903, -- Stormpike Insignia Rank 5
		17904, -- Stormpike Insignia Rank 6
		17690, -- Frostwolf Insignia Rank 1
		17905, -- Frostwolf Insignia Rank 2
		17906, -- Frostwolf Insignia Rank 3
		17907, -- Frostwolf Insignia Rank 4
		17908, -- Frostwolf Insignia Rank 5
		17909, -- Frostwolf Insignia Rank 6
	},
	Ring = {
		40585, -- Signet of the Kirin Tor
		40586, -- Band of the Kirin Tor
		44934, -- Loop of the Kirin Tor
		44935, -- Ring of the Kirin Tor
		45688, -- Inscribed Band of the Kirin Tor
		45689, -- Inscribed Loop of the Kirin Tor
		45690, -- Inscribed Ring of the Kirin Tor
		45691, -- Inscribed Signet of the Kirin Tor
		48954, -- Etched Band of the Kirin Tor
		48955, -- Etched Loop of the Kirin Tor
		48956, -- Etched Ring of the Kirin Tor
		48957, -- Etched Signet of the Kirin Tor
		51557, -- Runed Signet of the Kirin Tor
		51558, -- Runed Loop of the Kirin Tor
		51559, -- Runed Ring of the Kirin Tor
		51560, -- Runed Band of the Kirin Tor
		95050, -- Brassiest Knuckle (Horde)
		95051, -- Brassiest Knuckle (Alliance)
		142469, -- Violet Seal of the Grand Magus
	},
	Feet = {
		50287, -- Boots of the Bay
		28585, -- Ruby Slippers
	},
	Neck = {
		32757, -- Blessed Medallion of Karabor
	},
	Tabard = {
		46874, -- Argent Crusader's Tabard
		63378, -- Hellscream's Reach Tabard
		63379, -- Baradin's Wardens Tabard
	}
}

local InventoryType = {
	INVTYPE_NECK = INVSLOT_NECK,
	INVTYPE_FEET = INVSLOT_FEET,
	INVTYPE_FINGER = INVSLOT_FINGER1,
	INVTYPE_TRINKET = INVSLOT_TRINKET1,
	INVTYPE_CLOAK = INVSLOT_BACK,
	INVTYPE_TABARD = INVSLOT_TABARD,
}

local function IsTeleportItem(item)
	for slot, _ in T.pairs(List) do
		for j = 1, #List[slot] do
			if List[slot][j] == item then return true end
		end
	end
	return false
end

local Slots = {
	INVSLOT_NECK,
	INVSLOT_FEET,
	INVSLOT_FINGER1,
	INVSLOT_FINGER2,
	INVSLOT_TRINKET1,
	INVSLOT_TRINKET2,
	INVSLOT_BACK,
	INVSLOT_TABARD,
}

local Saved = {}

function TP:SaveItems()
	for i=1, #Slots do
		local item = T.GetInventoryItemID("player", Slots[i])
		if item and not IsTeleportItem(item) then
			Saved[Slots[i]] = item
		end
	end
end

function TP:RestoreItems()
	for i=1, #Slots do
		local item = T.GetInventoryItemID("player", Slots[i])
		if item and IsTeleportItem(item) then
			if Saved[Slots[i]] and not T.InCombatLockdown() then
				T.EquipItemByName(Saved[Slots[i]])
				if Slots[i] ~= INVSLOT_TABARD then
					KUI:Print("|cffff0000Warning|r: " .. T.GetItemInfo(item))
				end
			end
		end
	end
end

function TP:Initialize()
	if not E.db.KlixUI.misc.auto.teleportation then return end
	
	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "SaveItems")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "SaveItems")
	self:RegisterEvent("ZONE_CHANGED", "RestoreItems")
	self:RegisterEvent("ZONE_CHANGED_INDOORS", "RestoreItems")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "RestoreItems")
end

KUI:RegisterModule(TP:GetName())
