local KUI, T, E, L, V, P, G = unpack(select(2, ...))

----------------------------------------------------------------------------------------
--	Show item level and equipslot for weapons and armor at the merchant frame
----------------------------------------------------------------------------------------
local function MerchantItemInfo()
	local numItems = T.GetMerchantNumItems()

	for i = 1, MERCHANT_ITEMS_PER_PAGE do
		local index = (_G.MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE + i
		if index > numItems then return end

		local button = _G["MerchantItem"..i.."ItemButton"]
		if button and button:IsShown() then
			if not button.level then
				button.level = KUI:CreateText(button, "OVERLAY", 12, "OUTLINE")
				button.level:SetPoint("TOPLEFT", 1, -1)
				button.level:SetTextColor(1, 1, 0)
			else
				button.level:SetText("")
			end
			
			if not button.slot then
				button.slot = KUI:CreateText(button, "OVERLAY", 9, "OUTLINE")
				button.slot:SetPoint("BOTTOMRIGHT", 2, 2)
				button.slot:SetTextColor(1, 1, 0)
			else
				button.slot:SetText("")
			end
			
			local itemLink = T.GetMerchantItemLink(index)
			if itemLink then
				local _, _, quality, itemlevel, _, _, _, _, _, _, _, itemClassID = T.GetItemInfo(itemLink)
				if E.db.KlixUI.misc.merchant.itemlevel and (itemlevel and itemlevel > 1) and (quality and quality > 1) and (itemClassID == LE_ITEM_CLASS_WEAPON or itemClassID == LE_ITEM_CLASS_ARMOR) then
					button.level:SetText(itemlevel)
				end
			end
			
			local itemLink = T.GetMerchantItemLink(index)
			if itemLink then
				local _, _, _, _, _, _, _, _, equipSlot, _, _, _ = T.GetItemInfo(itemLink)
				if E.db.KlixUI.misc.merchant.equipslot and (equipSlot and T.string_find(equipSlot, "INVTYPE_")) then
					button.slot:SetText(_G[equipSlot])
				end
			end
		end
	end
end
hooksecurefunc("MerchantFrame_UpdateMerchantInfo", MerchantItemInfo)