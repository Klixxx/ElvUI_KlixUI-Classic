local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleDressingroom()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.dressingroom ~= true or E.private.KlixUI.skins.blizzard.dressingroom ~= true then return end
	
	local DressUpFrame = _G.DressUpFrame
	if DressUpFrame.backdrop then
		DressUpFrame.backdrop:Styling()
	end
	
	DressUpFrameBackgroundTopLeft:Hide()
	DressUpFrameBackgroundTopRight:Hide()
	DressUpFrameBackgroundBot:Hide()
	
	if DressUpModelFrame.backdrop then
		DressUpModelFrame.backdrop:Hide()
	end
end

S:AddCallback("KuiDressingRoom", styleDressingroom)