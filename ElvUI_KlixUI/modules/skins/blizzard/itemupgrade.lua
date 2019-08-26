local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local function styleItemUpgrade()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.itemUpgrade ~= true or E.private.KlixUI.skins.blizzard.itemUpgrade ~= true then return end
	
	local ItemUpgradeFrame = _G.ItemUpgradeFrame
	ItemUpgradeFrame:Styling()
end

S:AddCallbackForAddon("Blizzard_ItemUpgradeUI", "KuiItemUpgrade", styleItemUpgrade)