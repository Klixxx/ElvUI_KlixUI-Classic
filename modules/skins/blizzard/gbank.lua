local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleGBank()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.gbank ~= true or E.private.KlixUI.skins.blizzard.gbank ~= true then return end

	_G.GuildBankFrame:Styling()

	--Popup
	_G.GuildBankPopupFrame:Styling()
end

S:AddCallbackForAddon("Blizzard_GuildBankUI", "KuiGuildBank", styleGBank)