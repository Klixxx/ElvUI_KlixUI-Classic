local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local SCRAP = KUI:NewModule("Scrapper", "AceEvent-3.0", "AceHook-3.0")
local S = E:GetModule("Skins")

local itemLocation = itemLocation or _G.ItemLocation:CreateEmpty()

local function ItemPrint(text, ...)
	if E.db.KlixUI.misc.scrapper.Itemprint then
		KUI:Print(T.string_format("Inserting %s (%s)", text, ...))
	end
end

local function PositionScrapButton(self)
	if E.db.KlixUI.misc.scrapper.position == "BOTTOM" then
		self:ClearAllPoints()
		self:SetPoint("CENTER", _G.ScrappingMachineFrame, "BOTTOM", 0, 42)
	elseif E.db.KlixUI.misc.scrapper.position == "TOP" then
		self:ClearAllPoints()
		self:SetPoint("CENTER", _G.ScrappingMachineFrame, "TOP", 0, -45)
	end
end

local function CreateEmptyTooltip()
    local tip = T.CreateFrame("GameTooltip")
	local leftside = {}
	local rightside = {}
	local L, R
	-- 50 is max tooltip length atm (might need change)
	for i = 1, 50 do
		L, R = tip:CreateFontString(), tip:CreateFontString()
		L:SetFontObject(_G.GameFontNormal)
		R:SetFontObject(_G.GameFontNormal)
		tip:AddFontStrings(L, R)
		leftside[i] = L
		rightside[i] = R
	end
	tip.leftside = leftside
	tip.rightside = rightside
	return tip
end

local function ItemLvlComparison(equipped, itemlvl)
	if (not E.db.KlixUI.misc.scrapper.Itemlvl and not E.db.KlixUI.misc.scrapper.specificilvl) then
		return true
	end
	
	local ItemLvlLessThanEquip, ItemLvlLessThanSpecific = false, false
	if itemlvl and equipped then
		ItemLvlLessThanEquip = itemlvl < equipped
	end
	if itemlvl and E.db.KlixUI.misc.scrapper.specificilvlbox then
		ItemLvlLessThanSpecific = itemlvl < T.tonumber(E.db.KlixUI.misc.scrapper.specificilvlbox)
	end

	--returns
	if E.db.KlixUI.misc.scrapper.Itemlvl and E.db.KlixUI.misc.scrapper.specificilvl then
		if ItemLvlLessThanEquip and ItemLvlLessThanSpecific then
			return true
		else
			return false
		end
	elseif E.db.KlixUI.misc.scrapper.Itemlvl then
		return ItemLvlLessThanEquip
	elseif E.db.KlixUI.misc.scrapper.specificilvl then
		return ItemLvlLessThanSpecific
	end
end

local function IsPartOfEquipmentSet(bag, slot)
	if E.db.KlixUI.misc.scrapper.equipmentsets then
		local isInSet, _ = T.GetContainerItemEquipmentSetInfo(bag, slot)
		return isInSet
	end

	return false
end

local function IsAzeriteItem(itemLocation)
	if E.db.KlixUI.misc.scrapper.azerite then
		local isAzerite = T.C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItem(itemLocation)
		return isAzerite
	end

	return false
end

---------------------------------------------------
-- SCRAPPING FUNCTIONS
---------------------------------------------------
local function ReadTooltip(itemString)
	local tooltipReader = tooltipReader or CreateEmptyTooltip()
	tooltipReader:SetOwner(_G.WorldFrame, "ANCHOR_NONE")
	tooltipReader:ClearLines()
	local scrappable = false
	local boe = false

	if itemString then
		tooltipReader:SetHyperlink(itemString)
		for i = tooltipReader:NumLines(), 1, -1 do
			local line = tooltipReader.leftside[i]:GetText()
			if line and line == "Scrappable" then
				scrappable = true
				break
			end
		end

		if E.db.KlixUI.misc.scrapper.boe then
			local boe = false
			for i = 2, 4 do
				local t = tooltipReader.leftside[i]:GetText()
				if t then
					if t == "Binds when equipped" then
						boe = true
						break
					end
				end
			end
			return scrappable, boe
		end
	end
	
	return scrappable, false
end

local function ShouldInsert(item, bag, slot, equipped)
	local scrappable, boe = ReadTooltip(item)
	itemLocation:SetBagAndSlot(bag, slot)	

	if scrappable then
		local azerite_item = IsAzeriteItem(itemLocation)
		local itemlvl, _, _ = T.GetDetailedItemLevelInfo(item) or 0
		local part_of_set = IsPartOfEquipmentSet(bag, slot)
		local itemCompare = ItemLvlComparison(equipped, itemlvl)
		if (scrappable and itemCompare and not boe and not part_of_set and not azerite_item) then
			ItemPrint(item, itemlvl)
			return true
		end
	end

	return false
end

local function InsertScrapItems()
	if not E.db.KlixUI.misc.scrapper.enable then return end
	local _, avgEquipped, _ = T.GetAverageItemLevel()
	for bag = 0, 4 do
		for slot = 1, T.GetContainerNumSlots(bag) do
			local item = T.GetContainerItemLink(bag, slot)
			if item and T.string_sub(item, 13, 16) == "item" then
				if ShouldInsert(item, bag, slot, avgEquipped) then
					T.UseContainerItem(bag, slot)
				end
			end
		end
	end
end

function SCRAP:CreateScrapButton()
	T.LoadAddOn("Blizzard_ScrappingMachineUI")
	local scrapButton = T.CreateFrame("Button", "KUI_ScrapButton", _G.ScrappingMachineFrame, "UIPanelButtonTemplate")
	scrapButton:SetSize(150, 23)
	PositionScrapButton(scrapButton)
	scrapButton:SetText("Insert Scrap")
	S:HandleButton(scrapButton)

	scrapButton:SetScript("OnClick", function() 
		if T.UnitCastingInfo("player") ~= nil then
			KUI:Print("You cannot insert items while actively scrapping, cancel your cast to refill.")
			return
		end
		T.C_ScrappingMachineUI_RemoveAllScrapItems()
		T.ClearCursor()
		InsertScrapItems()
		T.PlaySound(115314)
		collectgarbage()
	end)
end

-- Itemlevel on gear in scrapmachine
local function ScrappingMachineUpdate(self)
	if not self.iLvl then
		self.iLvl = KUI:CreateText(self, "OVERLAY", E.db.KlixUI.misc.scrapper.itemlevel.fontSize or 12, E.db.KlixUI.misc.scrapper.itemlevel.fontOutline or "OUTLINE")
		self.iLvl:SetPoint("BOTTOMRIGHT", 0, 2)
	end
	
	if not self.itemLink then self.iLvl:SetText("") return end
	
	local quality = 1
	if self.itemLocation and not self.item:IsItemEmpty() and self.item:GetItemName() then
		quality = self.item:GetItemQuality()
	end

	local level = KUI:GetItemLevel(self.itemLink)
	local color = BAG_ITEM_QUALITY_COLORS[quality or 1]
	self.iLvl:SetText(level)
	self.iLvl:SetTextColor(color.r, color.g, color.b)
end

local function ScrappingiLvL(event, addon)
	if addon == "Blizzard_ScrappingMachineUI" then
		for button in T.pairs(_G.ScrappingMachineFrame.ItemSlots.scrapButtons.activeObjects) do
			if E.db.KlixUI.misc.scrapper.itemlevel.enable then
				hooksecurefunc(button, "RefreshIcon", ScrappingMachineUpdate)
			end
			button:CreateIconShadow()
		end

		KUI:UnregisterEvent(event, ScrappingiLvL)
	end
end
KUI:RegisterEvent("ADDON_LOADED", ScrappingiLvL)

function SCRAP:Initialize()
	if not E.db.KlixUI.misc.scrapper.enable and not IsAddOnLoaded("Blizzard_ScrappingMachineUI") then return end
	self:CreateScrapButton()
end

KUI:RegisterModule(SCRAP:GetName())