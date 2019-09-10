local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local r, g, b = T.unpack(E.media.rgbvaluecolor)

local function styleGossip()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.gossip ~= true or E.private.KlixUI.skins.blizzard.gossip ~= true then return end
	
	-- ItemTextFrame
	local ItemTextFrame = _G.ItemTextFrame
	if ItemTextFrame.backdrop then
		ItemTextFrame.backdrop:Styling()
	end
	
	-- GossipFrame
	local GossipFrame = _G.GossipFrame
	if GossipFrame.backdrop then
		GossipFrame.backdrop:Styling()
	end

	_G.GossipGreetingScrollFrame:StripTextures()

	GossipGreetingText:SetTextColor(1, 1, 1)
	NPCFriendshipStatusBar:GetRegions():Hide()
	NPCFriendshipStatusBarNotch1:SetColorTexture(0, 0, 0)
	NPCFriendshipStatusBarNotch1:SetSize(1, 16)
	NPCFriendshipStatusBarNotch2:SetColorTexture(0, 0, 0)
	NPCFriendshipStatusBarNotch2:SetSize(1, 16)
	NPCFriendshipStatusBarNotch3:SetColorTexture(0, 0, 0)
	NPCFriendshipStatusBarNotch3:SetSize(1, 16)
	NPCFriendshipStatusBarNotch4:SetColorTexture(0, 0, 0)
	NPCFriendshipStatusBarNotch4:SetSize(1, 16)
	T.select(7, NPCFriendshipStatusBar:GetRegions()):Hide()

	NPCFriendshipStatusBar.icon:SetPoint("TOPLEFT", -30, 7)
	KS:CreateBDFrame(NPCFriendshipStatusBar, .25)

	GossipFrame:HookScript("OnShow", function()
		T.C_Timer_After(.01, function()
			local index = 1
			local titleButton = _G["GossipTitleButton"..index]
			while titleButton do
				if titleButton:GetText() ~= nil then
					titleButton:SetText(T.string_gsub(titleButton:GetText(), ":32:32:0:0", ":32:32:0:0:64:64:5:59:5:59"))
				end
				index = index + 1
				titleButton = _G["GossipTitleButton"..index]
			end
		end)
	end)

	local function GossipTitleButtonTemplate(Button)
		local highlight = Button:GetHighlightTexture()
		highlight:SetColorTexture(r, g, b, 0.3)
		highlight:SetInside(Button)

		Button:SetSize(300, 16)
		_G[Button:GetName().."GossipIcon"]:SetSize(16, 16)
		_G[Button:GetName().."GossipIcon"]:SetPoint("TOPLEFT", 3, 1)

		local text = Button:GetFontString()
		text:SetSize(257, 0)
		text:SetPoint("LEFT", 20, 0)
		text:SetTextColor(1, 1, 1)
	end

	local prevTitle
	for i = 1, NUMGOSSIPBUTTONS do
		GossipTitleButtonTemplate(_G["GossipTitleButton"..i])

		if not prevTitle then
			_G["GossipTitleButton"..i]:SetPoint("TOPLEFT", GossipGreetingText, "BOTTOMLEFT", -10, -20)
		else
			_G["GossipTitleButton"..i]:SetPoint("TOPLEFT", prevTitle, "BOTTOMLEFT", 0, -3)
		end
		prevTitle = _G["GossipTitleButton"..i]
	end

	local availDataPerQuest, activeDataPerQuest = 7, 6
	hooksecurefunc("GossipFrameAvailableQuestsUpdate", function(...)
		local numAvailQuestsData = T.select("#", ...)
		local buttonIndex = (GossipFrame.buttonIndex - 1) - (numAvailQuestsData / availDataPerQuest)
		for i = 1, numAvailQuestsData, availDataPerQuest do
			local titleText, _, isTrivial = T.select(i, ...)
			local titleButton = _G["GossipTitleButton" .. buttonIndex]
			if isTrivial then
				titleButton:SetFormattedText(KUI_TRIVIAL_QUEST_DISPLAY, titleText)
			else
				titleButton:SetFormattedText(KUI_NORMAL_QUEST_DISPLAY, titleText)
			end
			buttonIndex = buttonIndex + 1
		end
	end)

	hooksecurefunc("GossipFrameActiveQuestsUpdate", function(...)
		local numActiveQuestsData = T.select("#", ...)
		local buttonIndex = (GossipFrame.buttonIndex - 1) - (numActiveQuestsData / activeDataPerQuest)
		for i = 1, numActiveQuestsData, activeDataPerQuest do
			local titleText, _, isTrivial = T.select(i, ...)
			local titleButton = _G["GossipTitleButton" .. buttonIndex]
			if isTrivial then
				titleButton:SetFormattedText(KUI_TRIVIAL_QUEST_DISPLAY, titleText)
			else
				titleButton:SetFormattedText(KUI_NORMAL_QUEST_DISPLAY, titleText)
			end
			buttonIndex = buttonIndex + 1
		end
	end)

	hooksecurefunc("GossipResize", function(titleButton)
		titleButton:SetHeight(titleButton:GetTextHeight() + 4)
	end)
end

S:AddCallback("KuiGossip", styleGossip)