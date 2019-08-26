local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local function styleChatFrame()
	if E.private.chat.enable ~= true then return end

	local VoiceChatPromptActivateChannel = _G.VoiceChatPromptActivateChannel
	KS:CreateBD(VoiceChatPromptActivateChannel)
	VoiceChatPromptActivateChannel:Styling()
	KS:CreateBD(_G.VoiceChatChannelActivatedNotification)
	_G.VoiceChatChannelActivatedNotification:Styling()

	-- Revert my Styling function on these buttons
	if not E.db.chat.hideVoiceButtons then
		if E.db.chat.pinVoiceButtons then
			if _G.ChatFrameChannelButton then
				_G.ChatFrameChannelButton:StripTextures()
				_G.ChatFrameChannelButton.glow:Hide()
			end

			if _G.ChatFrameToggleVoiceDeafenButton then
				_G.ChatFrameToggleVoiceDeafenButton:StripTextures()
				_G.ChatFrameToggleVoiceDeafenButton.glow:Hide()
			end

			if _G.ChatFrameToggleVoiceMuteButton then
				_G.ChatFrameToggleVoiceMuteButton:StripTextures()
				_G.ChatFrameToggleVoiceMuteButton.glow:Hide()
			end
		else
			-- ElvUI ChatButtonHolder
			if _G.ChatButtonHolder then
				_G.ChatButtonHolder:Styling()
			end
		end
	end
end

S:AddCallback("KuiChat", styleChatFrame)