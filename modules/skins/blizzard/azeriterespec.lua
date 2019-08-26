local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local function styleRespec()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.AzeriteRespec ~= true or E.private.KlixUI.skins.blizzard.azeriteRespec ~= true then return end

	local AzeriteRespecFrame = _G.AzeriteRespecFrame
	AzeriteRespecFrame:Styling()
end

S:AddCallbackForAddon("Blizzard_AzeriteRespecUI", "KuiAzeriteRespec", styleRespec)