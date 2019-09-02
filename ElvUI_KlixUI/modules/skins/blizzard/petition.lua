local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function stylePetition()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.petition ~= true or E.private.KlixUI.skins.blizzard.petition ~= true then return end

	local PetitionFrame = _G.PetitionFrame
	PetitionFrame.backdrop:Styling()
end

S:AddCallback("KuiPetition", stylePetition)