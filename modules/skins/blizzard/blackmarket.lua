local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local r, g, b = T.unpack(E.media.rgbvaluecolor)

local function styleBMAH()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.bmah ~= true or E.private.KlixUI.skins.blizzard.blackmarket ~= true then return end
	
	local BlackMarketFrame = _G.BlackMarketFrame

	BlackMarketFrame.Inset:DisableDrawLayer("BORDER")
	T.select(9, BlackMarketFrame.Inset:GetRegions()):Hide()
	BlackMarketFrame.MoneyFrameBorder:Hide()
	BlackMarketFrame.HotDeal.Left:Hide()
	BlackMarketFrame.HotDeal.Right:Hide()
	T.select(4, BlackMarketFrame.HotDeal:GetRegions()):Hide()

	BlackMarketFrame:Styling()

	KS:CreateBG(BlackMarketFrame.HotDeal.Item)

	local headers = {"ColumnName", "ColumnLevel", "ColumnType", "ColumnDuration", "ColumnHighBidder", "ColumnCurrentBid"}
	for _, headerName in T.pairs(headers) do
		local header = BlackMarketFrame[headerName]
		header.Left:Hide()
		header.Middle:Hide()
		header.Right:Hide()

		local bg = T.CreateFrame("Frame", nil, header)
		bg:SetPoint("TOPLEFT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", -1, 0)
		bg:SetFrameLevel(header:GetFrameLevel()-1)
		KS:CreateBD(bg, .25)
	end

	KS:CreateBD(BlackMarketFrame.HotDeal, .25)

	hooksecurefunc("BlackMarketScrollFrame_Update", function()
		local buttons = _G.BlackMarketScrollFrame.buttons
		for i = 1, #buttons do
			local bu = buttons[i]
			
			bu.Item.IconTexture:SetTexCoord(T.unpack(E.TexCoords))
			if not bu.reskinned then
				bu.Left:Hide()
				bu.Right:Hide()
				T.select(3, bu:GetRegions()):Hide()

				bu.Item:SetNormalTexture("")
				bu.Item:SetPushedTexture("")
				bu.Item:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
				bu.Item.IconBorder:SetAlpha(0)

				local bg = T.CreateFrame("Frame", nil, bu)
				bg:SetPoint("TOPLEFT")
				bg:SetPoint("BOTTOMRIGHT", 0, 5)
				bg:SetFrameLevel(bu:GetFrameLevel()-1)
				KS:CreateBD(bg, 0)

				local tex = bu:CreateTexture(nil, "BACKGROUND")
				tex:SetPoint("TOPLEFT")
				tex:SetPoint("BOTTOMRIGHT", 0, 5)
				tex:SetColorTexture(0, 0, 0, .25)

				bu:SetHighlightTexture(E.media.normTex)
				local hl = bu:GetHighlightTexture()
				hl:SetVertexColor(r, g, b, .2)
				hl.SetAlpha = KUI.dummy
				hl:ClearAllPoints()
				hl:SetPoint("TOPLEFT", 0, -1)
				hl:SetPoint("BOTTOMRIGHT", -1, 6)

				bu.Selection:ClearAllPoints()
				bu.Selection:SetPoint("TOPLEFT", 0, -1)
				bu.Selection:SetPoint("BOTTOMRIGHT", -1, 6)
				bu.Selection:SetTexture(E.media.normTex)
				bu.Selection:SetVertexColor(r, g, b, .1)

				bu.reskinned = true
			end
			
			if bu:IsShown() and bu.itemLink then
				local _, _, quality = T.GetItemInfo(bu.itemLink)
				bu.Name:SetTextColor(T.GetItemQualityColor(quality))
			end
		end
	end)

	hooksecurefunc("BlackMarketFrame_UpdateHotItem", function(self)
		local hotDeal = self.HotDeal
		if hotDeal:IsShown() and hotDeal.itemLink then
			local _, _, quality = T.GetItemInfo(hotDeal.itemLink)
			hotDeal.Name:SetTextColor(T.GetItemQualityColor(quality))
		end
		hotDeal.Item.IconBorder:Hide()
	end)
end

S:AddCallbackForAddon("Blizzard_BlackMarketUI", "KuiBlackMarket", styleBMAH)