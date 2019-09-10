local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleStackSplitFrame()
	if E.private.skins.blizzard.enable ~= true then return end

	local StackSplitFrame = _G.StackSplitFrame
	if StackSplitFrame.backdrop then
		StackSplitFrame.backdrop:Styling()
	end
end

S:AddCallback("KuiStackSplitFrame", styleStackSplitFrame)