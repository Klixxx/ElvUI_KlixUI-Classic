local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local r, g, b = T.unpack(E.media.rgbvaluecolor)

local function styleAuctionhouse()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.auctionhouse ~= true or E.private.KlixUI.skins.blizzard.auctionhouse ~= true then return end

	local AuctionFrame = _G.AuctionFrame
	if AuctionFrame.backdrop then
		AuctionFrame.backdrop:Styling()
	end

	--Change ElvUI's backdrop to be Transparent
	if AuctionFrameBrowse.bg1 then AuctionFrameBrowse.bg1:SetTemplate("Transparent") end
	if AuctionFrameBrowse.bg2 then AuctionFrameBrowse.bg2:SetTemplate("Transparent") end
	if AuctionFrameBid.bg then AuctionFrameBid.bg:SetTemplate("Transparent") end
	if AuctionFrameAuctions.bg1 then AuctionFrameAuctions.bg1:SetTemplate("Transparent") end
	if AuctionFrameAuctions.bg2 then AuctionFrameAuctions.bg2:SetTemplate("Transparent") end
	
	AuctionProgressBar.Text:ClearAllPoints()
	AuctionProgressBar.Text:SetPoint("CENTER", 0, 1)

	BrowseQualitySort:DisableDrawLayer("BACKGROUND")
	BrowseLevelSort:DisableDrawLayer("BACKGROUND")
	BrowseDurationSort:DisableDrawLayer("BACKGROUND")
	BrowseHighBidderSort:DisableDrawLayer("BACKGROUND")
	BrowseCurrentBidSort:DisableDrawLayer("BACKGROUND")
	BidQualitySort:DisableDrawLayer("BACKGROUND")
	BidLevelSort:DisableDrawLayer("BACKGROUND")
	BidDurationSort:DisableDrawLayer("BACKGROUND")
	BidBuyoutSort:DisableDrawLayer("BACKGROUND")
	BidStatusSort:DisableDrawLayer("BACKGROUND")
	BidBidSort:DisableDrawLayer("BACKGROUND")
	AuctionsQualitySort:DisableDrawLayer("BACKGROUND")
	AuctionsDurationSort:DisableDrawLayer("BACKGROUND")
	AuctionsHighBidderSort:DisableDrawLayer("BACKGROUND")
	AuctionsBidSort:DisableDrawLayer("BACKGROUND")
	T.select(6, BrowseCloseButton:GetRegions()):Hide()
	T.select(6, BrowseBuyoutButton:GetRegions()):Hide()
	T.select(6, BrowseBidButton:GetRegions()):Hide()
	T.select(6, BidCloseButton:GetRegions()):Hide()
	T.select(6, BidBuyoutButton:GetRegions()):Hide()
	T.select(6, BidBidButton:GetRegions()):Hide()

	T.hooksecurefunc("FilterButton_SetUp", function(button)
		button:SetNormalTexture("")
	end)

	local lastSkinnedTab = 1
	AuctionFrame:HookScript("OnShow", function()
		local tab = _G["AuctionFrameTab"..lastSkinnedTab]

		while tab do
			KS:ReskinTab(tab)
			lastSkinnedTab = lastSkinnedTab + 1
			tab = _G["AuctionFrameTab"..lastSkinnedTab]
		end
	end)

	local abuttons = {"BrowseBidButton", "BrowseBuyoutButton", "BrowseCloseButton", "BrowseSearchButton", "BidBidButton", "BidBuyoutButton", "BidCloseButton", "AuctionsCloseButton", "AuctionsCancelAuctionButton", "AuctionsCreateAuctionButton", "AuctionsNumStacksMaxButton", "AuctionsStackSizeMaxButton"}
	for i = 1, #abuttons do
		KS:Reskin(_G[abuttons[i]])
	end

	BrowseCloseButton:ClearAllPoints()
	BrowseCloseButton:SetPoint("BOTTOMRIGHT", AuctionFrameBrowse, "BOTTOMRIGHT", 66, 13)
	BrowseBuyoutButton:ClearAllPoints()
	BrowseBuyoutButton:SetPoint("RIGHT", BrowseCloseButton, "LEFT", -1, 0)
	BrowseBidButton:ClearAllPoints()
	BrowseBidButton:SetPoint("RIGHT", BrowseBuyoutButton, "LEFT", -1, 0)
	BidBuyoutButton:ClearAllPoints()
	BidBuyoutButton:SetPoint("RIGHT", BidCloseButton, "LEFT", -1, 0)
	BidBidButton:ClearAllPoints()
	BidBidButton:SetPoint("RIGHT", BidBuyoutButton, "LEFT", -1, 0)
	AuctionsCancelAuctionButton:ClearAllPoints()
	AuctionsCancelAuctionButton:SetPoint("RIGHT", AuctionsCloseButton, "LEFT", -1, 0)
	
	local function reskinAuctionButtons(button, i)
		local bu = _G[button..i]
		local it = _G[button..i.."Item"]
		local ic = _G[button..i.."ItemIconTexture"]

		if bu and it then
			it:SetNormalTexture("")
			it:SetPushedTexture("")
			it:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
			KS:ReskinIcon(ic)
			it.IconBorder:SetAlpha(0)
			bu:StripTextures()

			local bg = KS:CreateBDFrame(bu, .25)
			bg:SetPoint("TOPLEFT")
			bg:SetPoint("BOTTOMRIGHT", 0, 5)
			KS:CreateGradient(bg)

			bu:SetHighlightTexture(E["media"].normTex)
			local hl = bu:GetHighlightTexture()
			hl:SetVertexColor(r, g, b, .2)
			hl:ClearAllPoints()
			hl:SetPoint("TOPLEFT", 0, -1)
			hl:SetPoint("BOTTOMRIGHT", -1, 6)
		end
	end

	for i = 1, NUM_BROWSE_TO_DISPLAY do
		reskinAuctionButtons("BrowseButton", i)
	end

	for i = 1, NUM_BIDS_TO_DISPLAY do
		reskinAuctionButtons("BidButton", i)
	end

	for i = 1, NUM_AUCTIONS_TO_DISPLAY do
		reskinAuctionButtons("AuctionsButton", i)
	end

	local auctionhandler = T.CreateFrame("Frame")
	auctionhandler:RegisterEvent("NEW_AUCTION_UPDATE")
	auctionhandler:SetScript("OnEvent", function()
		local AuctionsItemButtonIconTexture = AuctionsItemButton:GetNormalTexture()
		if AuctionsItemButtonIconTexture then
			AuctionsItemButtonIconTexture:SetTexCoord(unpack(E.TexCoords))
			AuctionsItemButtonIconTexture:SetPoint("TOPLEFT", 1, -1)
			AuctionsItemButtonIconTexture:SetPoint("BOTTOMRIGHT", -1, 1)
		end
		AuctionsItemButton.IconBorder:SetTexture("")
	end)

	local _, AuctionsItemButtonNameFrame = AuctionsItemButton:GetRegions()
	AuctionsItemButtonNameFrame:Hide()

	BrowsePrevPageButton:SetPoint("TOPLEFT", 660, -60)
	BrowseNextPageButton:SetPoint("TOPRIGHT", 67, -60)
	BrowsePrevPageButton:GetRegions():SetPoint("LEFT", BrowsePrevPageButton, "RIGHT", 2, 0)

	BrowseDropDownLeft:SetAlpha(0)
	BrowseDropDownMiddle:SetAlpha(0)
	BrowseDropDownRight:SetAlpha(0)

	local a1, p, a2, x, y = BrowseDropDownButton:GetPoint()
	BrowseDropDownButton:SetPoint(a1, p, a2, x, y-4)
	BrowseDropDownButton:SetSize(16, 16)
	
	hooksecurefunc("AuctionFrameBrowse_Update", function()
		local offset = T.FauxScrollFrame_GetOffset(BrowseScrollFrame)
		local itemButton
		for i = 1, NUM_BROWSE_TO_DISPLAY do
			itemButton = _G["BrowseButton"..i.."Item"]
			if (itemButton) then
			
				itemButton:CreateIconShadow()
				
				if not itemButton.level then
					itemButton.level = KUI:CreateText(itemButton, "OVERLAY", 12, "OUTLINE")
					itemButton.level:SetPoint("TOPLEFT", 1, -1)
					itemButton.level:SetTextColor(1, 1, 0)
				else
					itemButton.level:SetText("")
				end
					
				if not itemButton.slot then
					itemButton.slot = KUI:CreateText(itemButton, "OVERLAY", 8, "OUTLINE")
					itemButton.slot:SetPoint("BOTTOMRIGHT", 2, 2)
					itemButton.slot:SetTextColor(1, 1, 0)
				else
					itemButton.slot:SetText("")
				end
					
				local itemLink = T.GetAuctionItemLink("list", offset+i)
				if itemLink then
					local _, _, quality, itemlevel, _, _, _, _, _, _, _, itemClassID = T.GetItemInfo(itemLink)
					if (itemlevel and itemlevel > 1) and (quality and quality > 1) and (itemClassID == LE_ITEM_CLASS_WEAPON or itemClassID == LE_ITEM_CLASS_ARMOR) then
						itemButton.level:SetText(itemlevel)
					end
				end
					
				local itemLink = T.GetAuctionItemLink("list", offset+i)
				if itemLink then
					local _, _, _, _, _, _, _, _, equipSlot, _, _, _ = GetItemInfo(itemLink)
					if (equipSlot and T.string_find(equipSlot, "INVTYPE_")) then
						itemButton.slot:SetText(_G[equipSlot])
					end
				end
			end
		end
	end)
	hooksecurefunc("AuctionFrameBid_Update", function()
		local offset = T.FauxScrollFrame_GetOffset(BidScrollFrame)
		local itemButton
		for i = 1, NUM_BIDS_TO_DISPLAY do
			itemButton = _G["BidButton"..i.."Item"]
			if (itemButton) then
			
				itemButton:CreateIconShadow()
				
				if not itemButton.level then
					itemButton.level = KUI:CreateText(itemButton, "OVERLAY", 12, "OUTLINE")
					itemButton.level:SetPoint("TOPLEFT", 1, -1)
					itemButton.level:SetTextColor(1, 1, 0)
				else
					itemButton.level:SetText("")
				end
				
				if not itemButton.slot then
					itemButton.slot = KUI:CreateText(itemButton, "OVERLAY", 8, "OUTLINE")
					itemButton.slot:SetPoint("BOTTOMRIGHT", 2, 2)
					itemButton.slot:SetTextColor(1, 1, 0)
				else
					itemButton.slot:SetText("")
				end
				
				local itemLink = T.GetAuctionItemLink("bidder", offset+i)
				if itemLink then
					local _, _, quality, itemlevel, _, _, _, _, _, _, _, itemClassID = T.GetItemInfo(itemLink)
					if (itemlevel and itemlevel > 1) and (quality and quality > 1) and (itemClassID == LE_ITEM_CLASS_WEAPON or itemClassID == LE_ITEM_CLASS_ARMOR) then
						itemButton.level:SetText(itemlevel)
					end
				end
				
				local itemLink = T.GetAuctionItemLink("bidder", offset+i)
				if itemLink then
					local _, _, _, _, _, _, _, _, equipSlot, _, _, _ = T.GetItemInfo(itemLink)
					if (equipSlot and T.string_find(equipSlot, "INVTYPE_")) then
						itemButton.slot:SetText(_G[equipSlot])
					end
				end
			end
		end
	end)
	hooksecurefunc("AuctionFrameAuctions_Update", function()
		local offset = T.FauxScrollFrame_GetOffset(AuctionsScrollFrame)
		local itemButton
		for i = 1, NUM_AUCTIONS_TO_DISPLAY do
			itemButton = _G["AuctionsButton"..i.."Item"]
			if (itemButton) then
			
				itemButton:CreateIconShadow()
				
				if not itemButton.level then
					itemButton.level = KUI:CreateText(itemButton, "OVERLAY", 12, "OUTLINE")
					itemButton.level:SetPoint("TOPLEFT", 1, -1)
					itemButton.level:SetTextColor(1, 1, 0)
				else
					itemButton.level:SetText("")
				end
				
				if not itemButton.slot then
					itemButton.slot = KUI:CreateText(itemButton, "OVERLAY", 8, "OUTLINE")
					itemButton.slot:SetPoint("BOTTOMRIGHT", 2, 2)
					itemButton.slot:SetTextColor(1, 1, 0)
				else
					itemButton.slot:SetText("")
				end
				
				local itemLink = T.GetAuctionItemLink("owner", offset+i)
				if itemLink then
					local _, _, quality, itemlevel, _, _, _, _, _, _, _, itemClassID = T.GetItemInfo(itemLink)
					if (itemlevel and itemlevel > 1) and (quality and quality > 1) and (itemClassID == LE_ITEM_CLASS_WEAPON or itemClassID == LE_ITEM_CLASS_ARMOR) then
						itemButton.level:SetText(itemlevel)
					end
				end
				
				local itemLink = T.GetAuctionItemLink("owner", offset+i)
				if itemLink then
					local _, _, _, _, _, _, _, _, equipSlot, _, _, _ = T.GetItemInfo(itemLink)
					if (equipSlot and T.string_find(equipSlot, "INVTYPE_")) then
						itemButton.slot:SetText(_G[equipSlot])
					end
				end
			end
		end
	end)
end

S:AddCallbackForAddon("Blizzard_AuctionUI", "KuiAuctionhouse", styleAuctionhouse)