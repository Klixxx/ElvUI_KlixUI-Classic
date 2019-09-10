local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleTabard()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.tabard ~= true or E.private.KlixUI.skins.blizzard.tabard ~= true then return end

	local TabardFrame = _G.TabardFrame
	if TabardFrame.backdrop then
		TabardFrame.backdrop:Styling()
	end
end

S:AddCallback("KuiTabard", styleTabard)