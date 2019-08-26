local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule('KuiSkins')
local S = E:GetModule('Skins')

local RETRIEVING_ITEM_INFO, MOUNT, ITEM_SPELL_KNOWN, SEARCH, MISCELLANEOUS = RETRIEVING_ITEM_INFO, MOUNT, ITEM_SPELL_KNOWN, SEARCH, MISCELLANEOUS
local MAX_MONEY_DISPLAY_WIDTH = 120

local RECIPE = T.GetItemClassInfo(LE_ITEM_CLASS_RECIPE)
local searchBox
local searching = ""

local IgnoreCurrency = {
	[T.GetCurrencyInfo(994)] = true,
}

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

local function SkinVendorItems(i)
	local button = _G["MerchantItem"..i.."ItemButton"]
	local icon = button.icon
	local iconBorder = button.IconBorder
	local item = _G["MerchantItem"..i]
	item:StripTextures(true)
	
	item.bd = T.CreateFrame("Frame", nil, item)
	item.bd:SetPoint("TOPLEFT", 39, 0)
	item.bd:SetPoint("BOTTOMRIGHT")
	item.bd:SetFrameLevel(0)
	KS:CreateBD(item.bd, .25)
	KS:CreateGradient(item.bd)
	
	button:StripTextures()
	button:StyleButton(false)
	button:SetTemplate("Default", true)
	
	local a1, p, a2= button:GetPoint()
	button:SetPoint(a1, p, a2, -1, -1)
	button:SetHighlightTexture("")
	button:SetNormalTexture("")
	button:SetPushedTexture("")
	button:SetSize(42, 42)
	
	icon:SetTexCoord(T.unpack(E.TexCoords))
	icon:SetInside()
	iconBorder:SetAlpha(0)
	hooksecurefunc(iconBorder, 'SetVertexColor', function(self, r, g, b)
		self:GetParent():SetBackdropBorderColor(r, g, b)
		self:SetTexture("")
	end)
	hooksecurefunc(iconBorder, 'Hide', function(self)
 		self:GetParent():SetBackdropBorderColor(T.unpack(E.media.bordercolor))
 	end)

	_G["MerchantItem"..i.."MoneyFrame"]:ClearAllPoints()
	_G["MerchantItem"..i.."MoneyFrame"]:Point("BOTTOMLEFT", button, "BOTTOMRIGHT", 3, 0)
	_G.MerchantBuyBackItemItemButton.IconBorder:SetAlpha(0)
end

local function UpdateButtonsPositions(isBuyBack)
	local btn;
	local vertSpacing, horizSpacing

	if (isBuyBack) then
		vertSpacing = -30
		horizSpacing = 50
		searchBox:Hide()
	else
		vertSpacing = -16
		horizSpacing = 12
		searchBox:Show()
	end
	for i = 1, MERCHANT_ITEMS_PER_PAGE do
		btn = _G["MerchantItem" .. i]
		if (isBuyBack) then
			if (i > BUYBACK_ITEMS_PER_PAGE) then
				btn:Hide()
			else
				if (i == 1) then
					btn:SetPoint("TOPLEFT", _G.MerchantFrame, "TOPLEFT", 64, -105)
				else
					if ((i % 3) == 1) then
						btn:SetPoint("TOPLEFT", _G["MerchantItem" .. (i-3)], "BOTTOMLEFT", 0, vertSpacing)
					else
						btn:SetPoint("TOPLEFT", _G["MerchantItem" .. (i-1)], "TOPRIGHT", horizSpacing, 0)
					end
				end
			end
		else
			btn:Show()
			if ((i % ItemsPerSubpage) == 1) then
				if (i == 1) then
					btn:SetPoint("TOPLEFT", _G.MerchantFrame, "TOPLEFT", 24, -70)
				else
					btn:SetPoint("TOPLEFT", _G["MerchantItem" .. (i-(ItemsPerSubpage - 1))], "TOPRIGHT", 12, 0)
				end
			else
				if ((i % 2) == 1) then
					btn:SetPoint("TOPLEFT", _G["MerchantItem" .. (i-2)], "BOTTOMLEFT", 0, vertSpacing)
				else
					btn:SetPoint("TOPLEFT", _G["MerchantItem" .. (i-1)], "TOPRIGHT", horizSpacing, 0)
				end
			end
		end
	end
end

local function UpdateBuybackInfo()
	if E.db.KlixUI.misc.merchant.style == true then UpdateButtonsPositions(true) end
	-- apply coloring
	local btn, link, quality, r, g, b, _
	for i = 1, BUYBACK_ITEMS_PER_PAGE, 1 do
		btn = _G["MerchantItem" .. i]
		if (btn) then
			link = T.GetBuybackItemLink(i)
			if (link) then
				_, _, quality = T.GetItemInfo(link)
				if quality then
					r, g, b = T.GetItemQualityColor(quality)
				else
					r, g, b = 1,1,1
				end
				_G["MerchantItem" .. i .. "Name"]:SetTextColor(r, g, b)
			end
		end
	end
end

local function isKnown(link, itemType, itemSubType)
	if E.db.KlixUI.misc.alreadyknown.enable then return end
	
	if ( not link ) then
		return false
	end
	local upperLimit
	local isMount = false
	local isRecipe = false
	if itemType == RECIPE then
		isRecipe = true
	elseif itemType == MISCELLANEOUS and itemSubType == MOUNT then
		isMount = true
	end

	_G["KUI_Merchant_HiddenTooltip"]:SetOwner(UIParent, "ANCHOR_NONE")
	_G["KUI_Merchant_HiddenTooltip"]:SetHyperlink(link)
	upperLimit = isRecipe and _G["KUI_Merchant_HiddenTooltip"]:NumLines() or 0

	for i=2, _G["KUI_Merchant_HiddenTooltip"]:NumLines() do
		if (isRecipe and (i <= 5 or i >= upperLimit - 3)) or isMount or not isRecipe then
			local text = _G["KUI_Merchant_HiddenTooltipTextLeft"..i]
			local r, g, b = text:GetTextColor()
			local gettext = text:GetText()

			if ( gettext and r >= 0.9 and g <= 0.2 and b <= 0.2 and gettext ~= RETRIEVING_ITEM_INFO ) then
				if gettext == ITEM_SPELL_KNOWN then return true end
			end
		end
	end

	return false
end

local function UpdateMerchantInfo()
	UpdateButtonsPositions()

	local totalMerchantItems = T.GetMerchantNumItems()
	local visibleMerchantItems = 0
	local indexes = {}
	local _, name, texture, price, quantity, numAvailable, isUsable, extendedCost, r, g, b, notOptimal
	local link, quality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemSellPrice, itemId
	
	for i = 1, totalMerchantItems do
		T.table_insert(indexes, i)
		visibleMerchantItems = visibleMerchantItems + 1
	end
	
	 -- validate current page shown
	if (_G.MerchantFrame.page > T.math_max(1, T.math_ceil(visibleMerchantItems / MERCHANT_ITEMS_PER_PAGE))) then
		_G.MerchantFrame.page = T.math_max(1, T.math_ceil(visibleMerchantItems / MERCHANT_ITEMS_PER_PAGE))
	end

	-- Show correct page count based on number of items shown
	_G.MerchantPageText:SetFormattedText(MERCHANT_PAGE_NUMBER, _G["MerchantFrame"].page, T.math_ceil(visibleMerchantItems / MERCHANT_ITEMS_PER_PAGE))
	
	--Display shit
	for i = 1, MERCHANT_ITEMS_PER_PAGE do
		 local index = ((_G["MerchantFrame"].page - 1) * MERCHANT_ITEMS_PER_PAGE) + i
		local itemButton = _G["MerchantItem" .. i .. "ItemButton"]
		itemButton.link = nil
		local merchantButton = _G["MerchantItem" .. i]
		local merchantMoney = _G["MerchantItem" .. i .. "MoneyFrame"]
		local merchantAltCurrency = _G["MerchantItem" .. i .. "AltCurrencyFrame"]
		if (index <= visibleMerchantItems) then
			name, texture, price, quantity, numAvailable, isPurchasable, isUsable, extendedCost = T.GetMerchantItemInfo(indexes[index])
			if (name ~= nil) then
				local canAfford = T.CanAffordMerchantItem(index)
				_G["MerchantItem"..i.."Name"]:SetText(name)
				T.SetItemButtonCount(itemButton, quantity)
				T.SetItemButtonStock(itemButton, numAvailable)
				T.SetItemButtonTexture(itemButton, texture)

				if ( extendedCost and (price <= 0) ) then -- update item's currency info
					itemButton.price = nil
					itemButton.extendedCost = true
					itemButton.name = name
					itemButton.link = T.GetMerchantItemLink(indexes[index])
					itemButton.texture = texture
					T.MerchantFrame_UpdateAltCurrency(index, i, canAfford)
					merchantAltCurrency:ClearAllPoints()
					merchantAltCurrency:SetPoint("BOTTOMLEFT", "MerchantItem"..i.."NameFrame", "BOTTOMLEFT", 0, 31)
					merchantMoney:Hide()
					merchantAltCurrency:Show()
				elseif ( extendedCost and (price > 0) ) then
					itemButton.price = price
					itemButton.extendedCost = true
					itemButton.name = name
					itemButton.link = T.GetMerchantItemLink(indexes[index])
					itemButton.texture = texture
					local altCurrencyWidth = T.MerchantFrame_UpdateAltCurrency(index, i, canAfford)
					T.MoneyFrame_SetMaxDisplayWidth(merchantMoney, MAX_MONEY_DISPLAY_WIDTH - altCurrencyWidth)
					T.MoneyFrame_Update(merchantMoney:GetName(), price)
					local color
					if (canAfford == false) then
						color = "red"
					end
					T.SetMoneyFrameColor(merchantMoney:GetName(), color)
					merchantAltCurrency:ClearAllPoints()
					merchantAltCurrency:SetPoint("LEFT", merchantMoney:GetName(), "RIGHT", -14, 0)
					merchantAltCurrency:Show()
					merchantMoney:Show()
				else
					itemButton.price = price
					itemButton.extendedCost = nil
					itemButton.name = name
					itemButton.link = T.GetMerchantItemLink(indexes[index])
					itemButton.texture = texture
					T.MoneyFrame_SetMaxDisplayWidth(merchantMoney, MAX_MONEY_DISPLAY_WIDTH)
					T.MoneyFrame_Update(merchantMoney:GetName(), price)
					local color
					if (canAfford == false) then
						color = "red"
					end
					T.SetMoneyFrameColor(merchantMoney:GetName(), color)
					merchantAltCurrency:Hide()
					merchantMoney:Show()
				end

				T.MerchantFrameItem_UpdateQuality(merchantButton, itemButton.link)
				
				local merchantItemID = T.GetMerchantItemID(index)
				local isHeirloom = merchantItemID and T.C_Heirloom_IsItemHeirloom(merchantItemID)
				local isKnownHeirloom = isHeirloom and T.C_Heirloom_PlayerHasHeirloom(merchantItemID)

				itemButton.showNonrefundablePrompt = isHeirloom
				
				itemButton.hasItem = true
				itemButton:SetID(indexes[index])
				itemButton:Show()
			
				if not E.db.KlixUI.misc.alreadyknown.enable then 
					local tintRed = not isPurchasable or (not isUsable and not isHeirloom)
					
					local colorMult = 1.0
					local detailColor = {}
					local slotColor = {}
					-- unavailable items (limited stock, bought out) are darkened
					if ( numAvailable == 0 or isKnownHeirloom) then
						colorMult = 0.5
					end
					if ( tintRed ) then
						slotColor = {r = 1.0, g = 0, b = 0}
						detailColor = {r = 1.0, g = 0, b = 0}
					else
						if not isKnown(itemButton.link, itemType, itemSubType) then
							slotColor = {r = 1.0, g = 1.0, b = 1.0}
							detailColor = {r = 0.5, g = 0.5, b = 0.5}
						else
							slotColor = {r = 1.0, g = 0, b = 0}
							detailColor = {r = 1.0, g = 0, b = 0}
						end
					end
					local alpha = 0.3;
					if ( searching == "" or searching == SEARCH:lower() or name:lower():match(searching) 
						or ( quality and ( T.tostring(quality):lower():match(searching) or _G["ITEM_QUALITY"..T.tostring(quality).."_DESC"]:lower():match(searching) ) )
						or ( itemType and itemType:lower():match(searching) ) 
						or ( itemSubType and itemSubType:lower():match(searching) )
						) then
						alpha = 1
					end
					merchantButton:SetAlpha(alpha)
					T.SetItemButtonNameFrameVertexColor(merchantButton, detailColor.r * colorMult, detailColor.g * colorMult, detailColor.b * colorMult)
					T.SetItemButtonSlotVertexColor(merchantButton, slotColor.r * colorMult, slotColor.g * colorMult, slotColor.b * colorMult)
					T.SetItemButtonTextureVertexColor(itemButton, slotColor.r * colorMult, slotColor.g * colorMult, slotColor.b * colorMult)
					T.SetItemButtonNormalTextureVertexColor(itemButton, slotColor.r * colorMult, slotColor.g * colorMult, slotColor.b * colorMult)
				end
			end
		else
			itemButton.price = nil
			itemButton.hasItem = nil
			itemButton.name = nil
			itemButton:Hide()
			T.SetItemButtonNameFrameVertexColor(merchantButton, 0.5, 0.5, 0.5)
			T.SetItemButtonSlotVertexColor(merchantButton,0.4, 0.4, 0.4)
			_G["MerchantItem"..i.."Name"]:SetText("")
			_G["MerchantItem"..i.."MoneyFrame"]:Hide()
			_G["MerchantItem"..i.."AltCurrencyFrame"]:Hide()
		end
	end
end

local function RebuildMerchantFrame()
	ItemsPerSubpage = MERCHANT_ITEMS_PER_PAGE
	SubpagesPerPage = E.db.KlixUI.misc.merchant.subpages
	MERCHANT_ITEMS_PER_PAGE = SubpagesPerPage * 10 --Haven't seen this causing any taints so I asume it's ok
	_G.MerchantFrame:SetWidth(42 + (318 * SubpagesPerPage) + (12 * (SubpagesPerPage - 1)))

	for i = 1, MERCHANT_ITEMS_PER_PAGE do
		if (not _G["MerchantItem" .. i]) then
			T.CreateFrame("Frame", "MerchantItem" .. i, _G.MerchantFrame, "MerchantItemTemplate")
			SkinVendorItems(i)
		end
	end
	 -- alter the position of the buyback item slot on the merchant tab
	_G.MerchantBuyBackItem:ClearAllPoints()
	_G.MerchantBuyBackItem:SetPoint("TOPLEFT", _G.MerchantItem10, "BOTTOMLEFT", -14, -20)
	
	-- move the next/previous page buttons
	_G.MerchantPrevPageButton:ClearAllPoints()
	_G.MerchantPrevPageButton:SetPoint("CENTER", _G.MerchantFrame, "BOTTOM", 50, 70)
	_G.MerchantPageText:ClearAllPoints()
	_G.MerchantPageText:SetPoint("BOTTOM", _G.MerchantFrame, "BOTTOM", 160, 65)
	_G.MerchantNextPageButton:ClearAllPoints()
	_G.MerchantNextPageButton:SetPoint("CENTER", _G.MerchantFrame, "BOTTOM", 270, 70)

	-- currency insets
	_G.MerchantExtraCurrencyInset:ClearAllPoints();
	_G.MerchantExtraCurrencyInset:SetPoint("BOTTOMRIGHT", _G.MerchantMoneyInset, "BOTTOMLEFT", 0, 0)
	_G.MerchantExtraCurrencyInset:SetPoint("TOPLEFT", _G.MerchantMoneyInset, "TOPLEFT", -165, 0)
	_G.MerchantExtraCurrencyBg:ClearAllPoints()
	_G.MerchantExtraCurrencyBg:SetPoint("TOPLEFT", _G.MerchantExtraCurrencyInset, "TOPLEFT", 3, -2)
	_G.MerchantExtraCurrencyBg:SetPoint("BOTTOMRIGHT", _G.MerchantExtraCurrencyInset, "BOTTOMRIGHT", -3, 2)

	searchBox = T.CreateFrame("EditBox", "$parentSearchBox", _G.MerchantFrame, "InputBoxTemplate")
	searchBox:SetWidth(_G.MerchantItem1:GetWidth())
	searchBox:SetHeight(24)
	searchBox:SetPoint("BOTTOMLEFT", _G.MerchantItem1, "TOPLEFT", 0, 9)
	searchBox:SetAutoFocus(false)
	searchBox:SetFontObject(_G.ChatFontSmall)
	searchBox:SetScript("OnTextChanged", function(self) searching = self:GetText():trim():lower(); UpdateMerchantInfo() end)
	searchBox:SetScript("OnShow", function(self) self:SetText(SEARCH); searching = "" end)
	searchBox:SetScript("OnEnterPressed", function(self)  self:ClearFocus() end)
	searchBox:SetScript("OnEscapePressed", function(self)  self:ClearFocus(); self:SetText(SEARCH); searching = "" end)
	searchBox:SetScript("OnEditFocusLost", function(self)
		self:HighlightText(0, 0)
		if ( T.strtrim(self:GetText()) == "" ) then
			self:SetText(SEARCH)
			searching = ""
		end
	end)
	searchBox:SetScript("OnEditFocusGained", function(self)
		self:HighlightText()
		if ( self:GetText():trim():lower() == SEARCH:lower() ) then
			self:SetText("")
		end
	end)
	searchBox:SetText(SEARCH);
	S:HandleEditBox(searchBox)
end

local function MerchantSkinInit()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.merchant ~= true or E.private.KlixUI.skins.blizzard.merchant ~= true then return end
	hooksecurefunc("MerchantFrame_UpdateBuybackInfo", UpdateBuybackInfo)
	if E.db.KlixUI.misc.merchant.style ~= true then return end
	RebuildMerchantFrame()
	UpdateButtonsPositions()
	T.CreateFrame("GameTooltip", "KUI_Merchant_HiddenTooltip", UIParent, "GameTooltipTemplate");

	hooksecurefunc("MerchantFrame_UpdateMerchantInfo", UpdateMerchantInfo)
end
hooksecurefunc(S, "Initialize", MerchantSkinInit)