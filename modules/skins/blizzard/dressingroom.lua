local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleDressingroom()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.dressingroom ~= true or E.private.KlixUI.skins.blizzard.dressingroom ~= true then return end

	_G.DressUpFrame:Styling()

	-- Wardrobe edit frame
	_G.WardrobeOutfitFrame:Styling() -- Dosen't work with the wardrobeoutfitframe from the Collectables file.
end

S:AddCallback("KuiDressingRoom", styleDressingroom)