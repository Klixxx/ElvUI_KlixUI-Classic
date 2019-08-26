local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleObliterum()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.Obliterum ~= true or E.private.KlixUI.skins.blizzard.Obliterum ~= true then return end

	_G.ObliterumForgeFrame:Styling()
end

S:AddCallbackForAddon("Blizzard_ObliterumUI", "KuiObliterum", styleObliterum)