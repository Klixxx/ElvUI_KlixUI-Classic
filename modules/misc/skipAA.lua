local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local SAA = KUI:NewModule('SkipAzeriteAnimations', 'AceHook-3.0', 'AceEvent-3.0');

function SAA:ADDON_LOADED(event,name)
    if name == "Blizzard_AzeriteUI" then
		self:SecureHook(_G.AzeriteEmpoweredItemUI, "OnItemSet", SAA.OnItemSet)
		self:UnregisterEvent("ADDON_LOADED")
    end
end

function SAA:AZERITE_EMPOWERED_ITEM_LOOTED(event,item)
	local itemId = T.GetItemInfoFromHyperlink(item)
	local bag
	local slot
	
	T.C_Timer_After(0.2, function() 
			for i = 0, NUM_BAG_SLOTS do
				for j = 1, T.GetContainerNumSlots(i) do
					local id = T.GetContainerItemID(i, j)
					if id and id == itemId then
						slot = j
						bag = i
					end
				end
			end
			
			if slot then
				local location = _G.ItemLocation:CreateFromBagAndSlot(bag, slot)
				
				T.C_AzeriteEmpoweredItem_SetHasBeenViewed(location)
				T.C_AzeriteEmpoweredItem_HasBeenViewed(location)
			end
	end)
end

function SAA:AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED(event, itemLocation)
	T.OpenAzeriteEmpoweredItemUIFromItemLocation(itemLocation)
end

function SAA.OnItemSet(self)
	local itemLocation = self.azeriteItemDataSource:GetItemLocation()
	if self:IsAnyTierRevealing() then
		T.C_Timer_After(0.5, function() 
				T.OpenAzeriteEmpoweredItemUIFromItemLocation(itemLocation)
		end)
	end
end

function SAA:Initialize()
	if not E.db.KlixUI.misc.auto.skipAA then return end

	if not (T.IsAddOnLoaded("Blizzard_AzeriteUI")) then
		self:RegisterEvent("ADDON_LOADED")
		T.UIParentLoadAddOn("Blizzard_AzeriteUI")
	else
		self:SecureHook(_G.AzeriteEmpoweredItemUI, "OnItemSet", SAA.OnItemSet)
	end

	self:RegisterEvent("AZERITE_EMPOWERED_ITEM_LOOTED")
	self:RegisterEvent("AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED")
end

local function InitializeCallback()
	SAA:Initialize()
end

KUI:RegisterModule(SAA:GetName(), InitializeCallback)