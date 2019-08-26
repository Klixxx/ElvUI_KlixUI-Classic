local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local r, g, b = T.unpack(E.media.rgbvaluecolor)

local function styleQuestMapFrame()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.quest ~= true or E.private.KlixUI.skins.blizzard.quest ~= true then return end

	local QuestMapFrame = _G.QuestMapFrame

	-- Quest scroll frame
	local QuestScrollFrame = _G.QuestScrollFrame
	local campaignHeader = QuestScrollFrame.Contents.WarCampaignHeader
	local StoryHeader = QuestScrollFrame.Contents.StoryHeader

	QuestMapFrame.VerticalSeparator:SetAlpha(0)
	QuestScrollFrame.Background:SetAlpha(0)
	QuestScrollFrame.DetailFrame.TopDetail:SetAlpha(0)
	QuestScrollFrame.DetailFrame.BottomDetail:SetAlpha(0)
	QuestScrollFrame.Contents.Separator:SetAlpha(0)

	for _, header in T.next, {campaignHeader, StoryHeader} do
		header.Background:SetAlpha(0)
		header.HighlightTexture:Hide()
		header.Text:SetPoint("TOPLEFT", 15, -20)

		local bg = KS:CreateBDFrame(header, .25)
		bg:SetPoint("TOPLEFT", 0, -8)
		bg:SetPoint("BOTTOMRIGHT", -4, 0)
		if header == campaignHeader then
			local newTex = bg:CreateTexture(nil, "OVERLAY")
			newTex:SetPoint("TOPRIGHT", -15, -3)
			newTex:SetSize(50, 50)
			newTex:SetBlendMode("ADD")
			newTex:SetAlpha(0)
			header.newTex = newTex
		end

		header:HookScript("OnEnter", function()
			bg:SetBackdropColor(r, g, b, .25)
		end)
		header:HookScript("OnLeave", function()
			bg:SetBackdropColor(0, 0, 0, .25)
		end)
	end

	local idToTexture = {
		[261] = "Interface\\FriendsFrame\\PlusManz-Alliance",
		[262] = "Interface\\FriendsFrame\\PlusManz-Horde",
	}

	local function UpdateCampaignHeader()
		campaignHeader.newTex:SetAlpha(0)
		if campaignHeader:IsShown() then
			local warCampaignInfo = T.C_CampaignInfo_GetCampaignInfo(T.C_CampaignInfo_GetCurrentCampaignID())
			local textureID = warCampaignInfo.uiTextureKitID
			if textureID and idToTexture[textureID] then
				campaignHeader.newTex:SetTexture(idToTexture[textureID])
				campaignHeader.newTex:SetAlpha(.7)
			end
		end
	end

	-- Quest details
	local DetailsFrame = QuestMapFrame.DetailsFrame
	local RewardsFrame = DetailsFrame.RewardsFrame
	local CompleteQuestFrame = DetailsFrame.CompleteQuestFrame

	DetailsFrame:StripTextures()
	T.select(6, DetailsFrame.ShareButton:GetRegions()):SetAlpha(0)
	T.select(7, DetailsFrame.ShareButton:GetRegions()):SetAlpha(0)
	DetailsFrame.SealMaterialBG:SetAlpha(0)

	DetailsFrame.AbandonButton:ClearAllPoints()
	DetailsFrame.AbandonButton:SetPoint("BOTTOMLEFT", DetailsFrame, -1, 0)
	DetailsFrame.AbandonButton:SetWidth(95)

	DetailsFrame.ShareButton:ClearAllPoints()
	DetailsFrame.ShareButton:SetPoint("LEFT", DetailsFrame.AbandonButton, "RIGHT", 1, 0)
	DetailsFrame.ShareButton:SetWidth(94)

	DetailsFrame.TrackButton:ClearAllPoints()
	DetailsFrame.TrackButton:SetPoint("LEFT", DetailsFrame.ShareButton, "RIGHT", 1, 0)
	DetailsFrame.TrackButton:SetWidth(96)

	-- Rewards frame
	RewardsFrame.Background:SetAlpha(0)
	T.select(2, RewardsFrame:GetRegions()):SetAlpha(0)

	-- Scroll frame
	hooksecurefunc("QuestLogQuests_Update", function()
		UpdateCampaignHeader()
	end)

	-- Complete quest frame
	CompleteQuestFrame:GetRegions():SetAlpha(0)
	T.select(2, CompleteQuestFrame:GetRegions()):SetAlpha(0)
	T.select(6, CompleteQuestFrame.CompleteButton:GetRegions()):SetAlpha(0)
	T.select(7, CompleteQuestFrame.CompleteButton:GetRegions()):SetAlpha(0)

	-- Quest log popup detail frame
	local QuestLogPopupDetailFrame = _G.QuestLogPopupDetailFrame

	T.select(18, QuestLogPopupDetailFrame:GetRegions()):SetAlpha(0)
	_G.QuestLogPopupDetailFrameScrollFrameTop:SetAlpha(0)
	_G.QuestLogPopupDetailFrameScrollFrameBottom:SetAlpha(0)
	_G.QuestLogPopupDetailFrameScrollFrameMiddle:SetAlpha(0)

	_G.QuestLogPopupDetailFrameScrollFrame:HookScript("OnUpdate", function(self)
		_G.QuestLogPopupDetailFrameScrollFrame.backdrop:Hide()
		_G.QuestLogPopupDetailFrameInset:Hide()
		_G.QuestLogPopupDetailFrameBg:Hide()
		self:SetTemplate("Transparent")
		if not E.private.skins.parchmentRemover.enable then
			self.spellTex:SetTexture("")
		end
	end)
	T.select(18, QuestLogPopupDetailFrame:GetRegions()):Hide()
	QuestLogPopupDetailFrame:Styling()

	-- Show map button
	local ShowMapButton = QuestLogPopupDetailFrame.ShowMapButton

	ShowMapButton.Texture:SetAlpha(0)
	ShowMapButton.Highlight:SetTexture("")
	ShowMapButton.Highlight:SetTexture("")

	ShowMapButton:SetSize(ShowMapButton.Text:GetStringWidth() + 14, 22)
	ShowMapButton.Text:ClearAllPoints()
	ShowMapButton.Text:SetPoint("CENTER", 1, 0)

	ShowMapButton:ClearAllPoints()
	ShowMapButton:SetPoint("TOPRIGHT", QuestLogPopupDetailFrame, -30, -25)

	ShowMapButton:HookScript("OnEnter", function(self)
		self.Text:SetTextColor(_G.GameFontHighlight:GetTextColor())
	end)

	ShowMapButton:HookScript("OnLeave", function(self)
		self.Text:SetTextColor(_G.GameFontNormal:GetTextColor())
	end)

	-- Bottom buttons
	QuestLogPopupDetailFrame.ShareButton:ClearAllPoints()
	QuestLogPopupDetailFrame.ShareButton:SetPoint("LEFT", QuestLogPopupDetailFrame.AbandonButton, "RIGHT", 1, 0)
	QuestLogPopupDetailFrame.ShareButton:SetPoint("RIGHT", QuestLogPopupDetailFrame.TrackButton, "LEFT", -1, 0)
end

S:AddCallback("KuiQuestMapFrame", styleQuestMapFrame)