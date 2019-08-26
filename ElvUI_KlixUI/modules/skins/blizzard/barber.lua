local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleBarber()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.barber ~= true or E.private.KlixUI.skins.blizzard.barber ~= true then return end

	_G.BarberShopFrame:Styling()
	_G.BarberShopAltFormFrame:Styling()
end

S:AddCallbackForAddon("Blizzard_BarbershopUI", "KuiBarber", styleBarber)