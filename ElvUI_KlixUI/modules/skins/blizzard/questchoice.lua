local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local function styleQuestChoice()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.questChoice ~= true or E.private.KlixUI.skins.blizzard.questChoice ~= true then return end

	local QuestChoiceFrame = _G.QuestChoiceFrame

	QuestChoiceFrame:StripTextures()

	if QuestChoiceFrame.backdrop then
		QuestChoiceFrame.backdrop:Hide()
	end

	KS:CreateBD(QuestChoiceFrame, .5)
	QuestChoiceFrame:Styling()

	for i = 1, 15 do
		T.select(i, QuestChoiceFrame:GetRegions()):Hide()
	end

	for i = 17, 19 do
		T.select(i, QuestChoiceFrame:GetRegions()):Hide()
	end

	for i = 1, #QuestChoiceFrame.Options do
		local option = QuestChoiceFrame["Option"..i]
		local rewards = option.Rewards
		local item = rewards.Item
		local currencies = rewards.Currencies

		option.Header.Background:Hide()
		option.Header.Text:SetTextColor(.9, .9, .9)

		option.Artwork:SetTexCoord(0.140625, 0.84375, 0.2265625, 0.78125)
		option.Artwork:SetSize(180, 71)
		option.Artwork:SetPoint("TOP", 0, -20)
		option.OptionText:SetTextColor(.9, .9, .9)

		item.Name:SetTextColor(1, 1, 1)
		item.Icon:SetTexCoord(.08, .92, .08, .92)
		item.bg = KS:CreateBG(item.Icon)

		for j = 1, 3 do
			local cu = currencies["Currency"..j]

			cu.Icon:SetTexCoord(.08, .92, .08, .92)
			KS:CreateBG(cu.Icon)
		end
	end

	-- hooksecurefunc("QuestChoiceFrame_ShowRewards", function(numOptions)
		-- for i = 1, numOptions do
			-- local rewards = QuestChoiceFrame["Option"..i].Rewards
			-- rewards.Item.bg:SetVertexColor(rewards.Item.IconBorder:GetVertexColor())
			-- rewards.Item.IconBorder:Hide()
		-- end
	-- end)
end

S:AddCallbackForAddon("Blizzard_QuestChoice", "KuiQuestChoice", styleQuestChoice)