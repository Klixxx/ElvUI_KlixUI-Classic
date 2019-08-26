local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local function styleMerchant()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.gossip ~= true or E.private.KlixUI.skins.blizzard.gossip ~= true then return end

	local ItemTextFrame = _G.ItemTextFrame
	T.select(18, ItemTextFrame:GetRegions()):Hide()

	ItemTextFrame:Styling()
end

S:AddCallback("KuiItemText", styleMerchant)
