local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleTaxi()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.taxi ~= true or E.private.KlixUI.skins.blizzard.taxi ~= true then return end

	_G.TaxiFrame:Styling()
	_G.TaxiRouteMap:Styling()
end

S:AddCallback("KuiTaxi", styleTaxi)