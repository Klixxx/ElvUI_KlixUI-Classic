local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.lfguild ~= true or E.private.KlixUI.skins.blizzard.lfguild ~= true then return end

	local function SkinLFGuild(self)
		self:Styling()
	end
	hooksecurefunc("LookingForGuildFrame_OnShow", SkinLFGuild)
end

S:AddCallbackForAddon("Blizzard_LookingForGuildUI", "KuiLookingForGuild", LoadSkin)