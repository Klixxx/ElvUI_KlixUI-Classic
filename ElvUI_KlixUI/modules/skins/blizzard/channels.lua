local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleChannels()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.Channels ~= true or E.private.KlixUI.skins.blizzard.channels ~= true then return end

	local ChannelFrame = _G.ChannelFrame
	ChannelFrame:StripTextures()
	ChannelFrame:Styling()

	local CreateChannelPopup = _G.CreateChannelPopup
	CreateChannelPopup:Styling()
end

S:AddCallbackForAddon("Blizzard_Channels", "KuiChannels", styleChannels)