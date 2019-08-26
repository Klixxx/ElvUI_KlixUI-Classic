local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local function styleTalkingHead()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.talkinghead ~= true or E.private.KlixUI.skins.blizzard.talkinghead ~= true then return end

	local TalkingHeadFrame = _G.TalkingHeadFrame
	if TalkingHeadFrame.backdrop then TalkingHeadFrame.backdrop:Styling() end

	TalkingHeadFrame.BackgroundFrame.TextBackground:SetAtlas(nil)
	TalkingHeadFrame.PortraitFrame.Portrait:SetAtlas(nil)
	TalkingHeadFrame.MainFrame.Model.PortraitBg:SetAtlas(nil)
	TalkingHeadFrame.BackgroundFrame.TextBackground.SetAtlas = KUI.dummy
	TalkingHeadFrame.PortraitFrame.Portrait.SetAtlas = KUI.dummy
	TalkingHeadFrame.MainFrame.Model.PortraitBg.SetAtlas = KUI.dummy

	TalkingHeadFrame.MainFrame.Model.ModelShadow = TalkingHeadFrame.MainFrame.Model:CreateTexture(nil, "OVERLAY", nil, 2)
	TalkingHeadFrame.MainFrame.Model.ModelShadow:SetAtlas("Artifacts-BG-Shadow")
	TalkingHeadFrame.MainFrame.Model.ModelShadow:SetOutside()
	TalkingHeadFrame.MainFrame.Model.PortraitBg:Hide()

	TalkingHeadFrame.MainFrame.CloseButton:ClearAllPoints()
	TalkingHeadFrame.MainFrame.CloseButton:Point("TOPRIGHT", TalkingHeadFrame.BackgroundFrame, "TOPRIGHT", 0, -2)

	TalkingHeadFrame.NameFrame.Name:SetTextColor(1, 0.82, 0.02)
	TalkingHeadFrame.NameFrame.Name.SetTextColor = KUI.dummy
	TalkingHeadFrame.NameFrame.Name:SetShadowColor(0, 0, 0, 1)
	TalkingHeadFrame.NameFrame.Name:SetShadowOffset(2, -2)

	TalkingHeadFrame.TextFrame.Text:SetTextColor(1, 1, 1)
	TalkingHeadFrame.TextFrame.Text.SetTextColor = KUI.dummy
	TalkingHeadFrame.TextFrame.Text:SetShadowColor(0, 0, 0, 1)
	TalkingHeadFrame.TextFrame.Text:SetShadowOffset(2, -2)
end

S:AddCallbackForAddon("Blizzard_TalkingHeadUI", "KuiTalkingHead", styleTalkingHead)