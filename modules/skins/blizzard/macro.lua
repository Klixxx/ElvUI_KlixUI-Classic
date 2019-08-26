local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleMacro()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.macro ~= true or E.private.KlixUI.skins.blizzard.macro ~= true then return end

	_G.MacroFrame:Styling()
	_G.MacroPopupFrame:Styling()
	_G.MacroFrameTextBackground:Styling()
end

S:AddCallbackForAddon("Blizzard_MacroUI", "KuiMacro", styleMacro)