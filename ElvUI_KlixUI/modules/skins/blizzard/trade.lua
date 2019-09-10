local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local function styleTradeFrame()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.trade ~= true or E.private.KlixUI.skins.blizzard.trade ~= true then return end

	local TradeFrame = _G.TradeFrame
	if TradeFrame.backdrop then
		TradeFrame.backdrop:Styling()
	end

	local function reskinButton(bu)
		bu:SetNormalTexture("")
		bu:SetPushedTexture("")
		bu.icon:SetTexCoord(T.unpack(E.TexCoords))
		bu.IconBorder:SetAlpha(0)
		bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		bu:CreateIconShadow()
	end

	for i = 1, MAX_TRADE_ITEMS do
		_G["TradePlayerItem"..i.."SlotTexture"]:Hide()
		_G["TradePlayerItem"..i.."NameFrame"]:Hide()
		_G["TradeRecipientItem"..i.."SlotTexture"]:Hide()
		_G["TradeRecipientItem"..i.."NameFrame"]:Hide()

		if _G["TradePlayerItem"..i.."ItemButton"].bg then _G["TradePlayerItem"..i.."ItemButton"].bg:SetTemplate("Transparent") end
		if _G["TradePlayerItem"..i.."ItemButton"].bg then KS:CreateGradient(_G["TradePlayerItem"..i.."ItemButton"].bg) end
		if _G["TradeRecipientItem"..i.."ItemButton"].bg then _G["TradeRecipientItem"..i.."ItemButton"].bg:SetTemplate("Transparent") end
		if _G["TradeRecipientItem"..i.."ItemButton"].bg then KS:CreateGradient(_G["TradeRecipientItem"..i.."ItemButton"].bg) end

		reskinButton(_G["TradePlayerItem"..i.."ItemButton"])
		reskinButton(_G["TradeRecipientItem"..i.."ItemButton"])
	end
end

S:AddCallback("KuiTradeFrame", styleTradeFrame)
