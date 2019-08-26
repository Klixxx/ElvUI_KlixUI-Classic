local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local function styleAzerite()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.AzeriteUI ~= true or E.private.KlixUI.skins.blizzard.azerite ~= true then return end

	local AzeriteEmpoweredItemUI = _G.AzeriteEmpoweredItemUI
	AzeriteEmpoweredItemUI:Styling()
end

S:AddCallbackForAddon("Blizzard_AzeriteUI", "KuiAzerite", styleAzerite)
