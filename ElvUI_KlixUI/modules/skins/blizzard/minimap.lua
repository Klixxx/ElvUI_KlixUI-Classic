local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local function styleMinimap()
	if E.private.skins.blizzard.enable ~= true or E.private.KlixUI.skins.blizzard.minimap ~= true or E.private.general.minimap.enable ~= true then return end
	
	local Minimap = _G.Minimap 
	Minimap:Styling(true, true, false, 180, 180, .75)
end

S:AddCallback("KuiSkinMinimap", styleMinimap)