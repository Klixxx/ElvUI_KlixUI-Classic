local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local r, g, b = T.unpack(E.media.rgbvaluecolor)

local function styleUIWidgets()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.Warboard ~= true or E.private.KlixUI.skins.blizzard.warboard ~= true then return end

	-- Used for Currency Fonts (Warfront only?)
end

S:AddCallbackForAddon("Blizzard_UIWidgets", "KuiUIWidgets", styleUIWidgets)