local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local r, g, b = T.unpack(E.media.rgbvaluecolor)

local function styleWorldmap()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.worldmap ~= true or E.private.KlixUI.skins.blizzard.worldmap ~= true then return end
	
	local WorldMapFrame = _G.WorldMapFrame
	if WorldMapFrame.BorderFrame.backdrop then
		WorldMapFrame.BorderFrame.backdrop:Styling()
	end
end

S:AddCallback("KuiWorldmap", styleWorldmap)
