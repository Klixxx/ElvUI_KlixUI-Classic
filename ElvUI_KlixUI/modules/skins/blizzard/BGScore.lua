local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleBGScore()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.bgmap ~= true or E.private.KlixUI.skins.blizzard.bgmap ~= true then return end

	local WorldStateScoreFrame = _G.WorldStateScoreFrame
	if WorldStateScoreFrame.backdrop then
		WorldStateScoreFrame.backdrop:Styling()
	end
end

S:AddCallback("KuiWorldStateScore", styleBGScore)