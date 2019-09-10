local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleGMChat()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.GMChat ~= true or E.private.KlixUI.skins.blizzard.gmchat ~= true then return end

	local GMChatFrame = _G.GMChatFrame
	if GMChatFrame.backdrop then
		GMChatFrame.backdrop:Styling()
	end
end

S:AddCallbackForAddon("Blizzard_GMChatUI", "KuiGMChat", styleGMChat)