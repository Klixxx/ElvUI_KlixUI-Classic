local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleBattlefield()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.battlefield ~= true or E.private.KlixUI.skins.blizzard.battlefield ~= true then return end

	local BattlefieldFrame = _G.BattlefieldFrame
	if BattlefieldFrame.backdrop then
		BattlefieldFrame.backdrop:Styling()
	end
end

S:AddCallback('KuiBattlefield', styleBattlefield)