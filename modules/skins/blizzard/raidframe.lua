local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local r, g, b = T.unpack(E.media.rgbvaluecolor)

local function styleRaidFrame()
	if E.private.skins.blizzard.enable ~= true then return; end

	local RaidInfoFrame = _G.RaidInfoFrame
	if RaidInfoFrame.backdrop then
		RaidInfoFrame.backdrop:Styling()
	end
end

S:AddCallback("KuiRaidFrame", styleRaidFrame)
