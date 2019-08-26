local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleGuildControlUI()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.guildcontrol ~= true or E.private.KlixUI.skins.blizzard.guildcontrol ~= true then return end

	_G.GuildControlUI:Styling()
end

S:AddCallbackForAddon("Blizzard_GuildControlUI", "KuiGuildControl", styleGuildControlUI)