local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local function styleMerchant()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.merchant ~= true or E.private.KlixUI.skins.blizzard.merchant ~= true then return end

	local MerchantFrame = _G.MerchantFrame
	if MerchantFrame.backdrop then
		MerchantFrame.backdrop:Styling()
	end

	for i = 1, _G.BUYBACK_ITEMS_PER_PAGE do
		local button = _G["MerchantItem"..i]
		local bu = _G["MerchantItem"..i.."ItemButton"]
		local mo = _G["MerchantItem"..i.."MoneyFrame"]
		local ic = bu.icon

		-- Hide ElvUI's backdrop
		if button.backdrop then
			button.backdrop:Hide()
		end
		
		if bu and bu:IsShown() then
			bu:CreateIconShadow()
		end
		
		bu:SetHighlightTexture("")
		bu.IconBorder:SetAlpha(0)

		_G["MerchantItem"..i.."SlotTexture"]:Hide()
		_G["MerchantItem"..i.."NameFrame"]:Hide()
		_G["MerchantItem"..i.."Name"]:SetHeight(20)

		local a1, p, a2= bu:GetPoint()
		bu:SetPoint(a1, p, a2, 0, 0)
		bu:SetNormalTexture("")
		bu:SetPushedTexture("")
		bu:SetSize(44, 44)

		local a3, p2, a4, x, y = mo:GetPoint()
		mo:SetPoint(a3, p2, a4, x, y+2)

		KS:CreateBD(bu, 0)

		button.bd = T.CreateFrame("Frame", nil, button)
		button.bd:SetPoint("TOPLEFT", 39, 0)
		button.bd:SetPoint("BOTTOMRIGHT")
		button.bd:SetFrameLevel(0)
		KS:CreateBD(button.bd, .25)
		KS:CreateGradient(button.bd)

		ic:SetTexCoord(T.unpack(E.TexCoords))
		ic:ClearAllPoints()
		ic:SetPoint("TOPLEFT", 1, -1)
		ic:SetPoint("BOTTOMRIGHT", -1, 1)

		for j = 1, 3 do
			KS:CreateBG(_G["MerchantItem"..i.."AltCurrencyFrameItem"..j.."Texture"])
			_G["MerchantItem"..i.."AltCurrencyFrameItem"..j.."Texture"]:SetTexCoord(T.unpack(E.TexCoords))
		end
	end
	
	-- buy back item icon
	_G.MerchantBuyBackItemItemButton:CreateIconShadow()
	
	hooksecurefunc("MerchantFrame_UpdateMerchantInfo", function()
		local numMerchantItems = T.GetMerchantNumItems()
		for i = 1, _G.MERCHANT_ITEMS_PER_PAGE do
			local index = ((MerchantFrame.page - 1) * _G.MERCHANT_ITEMS_PER_PAGE) + i
			if index <= numMerchantItems then
				local _, _, price, _, _, _, extendedCost = T.GetMerchantItemInfo(index)
				if extendedCost and (price <= 0) then
					_G["MerchantItem"..i.."AltCurrencyFrame"]:SetPoint("BOTTOMLEFT", "MerchantItem"..i.."NameFrame", "BOTTOMLEFT", 0, 35)
				end

				local bu = _G["MerchantItem"..i.."ItemButton"]
				local name = _G["MerchantItem"..i.."Name"]
				if bu.link then
					local _, _, quality = T.GetItemInfo(bu.link)
					if quality then
						local r, g, b = T.GetItemQualityColor(quality)
						name:SetTextColor(r, g, b)
					else
						name:SetTextColor(1, 1, 1)
					end
				else
					name:SetTextColor(1, 1, 1)
				end
			end
		end

		local name = T.GetBuybackItemLink(T.GetNumBuybackItems())
		if name then
			local _, _, quality = T.GetItemInfo(name)
			local r, g, b = T.GetItemQualityColor(quality or 1)

			_G.MerchantBuyBackItemName:SetTextColor(r, g, b)
		end
	end)

	hooksecurefunc("MerchantFrame_UpdateBuybackInfo", function()
		for i = 1, _G.BUYBACK_ITEMS_PER_PAGE do
			local itemLink = T.GetBuybackItemLink(i)
			local name = _G["MerchantItem"..i.."Name"]

			if itemLink then
				local _, _, quality = T.GetItemInfo(itemLink)
				local r, g, b = T.GetItemQualityColor(quality)

				name:SetTextColor(r, g, b)
			else
				name:SetTextColor(1, 1, 1)
			end
		end
	end)
end

S:AddCallback("KuiMerchant", styleMerchant)