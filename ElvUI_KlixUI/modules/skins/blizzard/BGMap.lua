local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleBGMap()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.bgmap ~= true or E.private.KlixUI.skins.blizzard.bgmap ~= true then return end

	local BattlefieldMapFrame = _G.BattlefieldMapFrame
	if BattlefieldMapFrame.backdrop then
		BattlefieldMapFrame.backdrop:Styling()
	end
end

S:AddCallbackForAddon("Blizzard_BattlefieldMap", "KuiBattlefieldMap", styleBGMap)