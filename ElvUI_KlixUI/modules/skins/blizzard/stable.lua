local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleStable()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.stable ~= true or E.private.KlixUI.skins.blizzard.stable ~= true then return end

	local PetStableFrame = _G.PetStableFrame
	if PetStableFrame.backdrop then
		PetStableFrame.backdrop:Styling()
	end
end

S:AddCallback("KuiStable", styleStable)