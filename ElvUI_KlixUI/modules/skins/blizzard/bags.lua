local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleBags()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.bags ~= true or E.private.KlixUI.skins.blizzard.bags ~= true or E.private.bags.enable then return end

	for i = 1, NUM_CONTAINER_FRAMES, 1 do
		containerFrame = _G['ContainerFrame'..i]
		
		if containerFrame.backdrop then
			containerFrame.backdrop:Styling()
		end

		for k = 1, MAX_CONTAINER_ITEMS, 1 do
			itemButton = _G['ContainerFrame'..i..'Item'..k]
			
			itemButton:CreateIconShadow()
		end
	end
end

S:AddCallback('KuiBags', styleBags)