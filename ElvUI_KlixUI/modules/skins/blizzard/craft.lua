local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleCraft()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.craft ~= true or E.private.KlixUI.skins.blizzard.craft ~= true then return end

	local CraftFrame = _G.CraftFrame
	if CraftFrame.backdrop then
		CraftFrame.backdrop:Styling()
	end
end

S:AddCallbackForAddon("Blizzard_CraftUI", "KuiCraft", styleCraft)