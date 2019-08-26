local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local function styleWarboard()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.Warboard ~= true or E.private.KlixUI.skins.blizzard.warboard ~= true then return end

	local WarboardQuestChoiceFrame = _G.WarboardQuestChoiceFrame
	WarboardQuestChoiceFrame:Styling()

	for i = 1, 4 do
		local option = WarboardQuestChoiceFrame["Option"..i]
		if not option.backdrop then
			option:CreateBackdrop("Transparent")
			option.backdrop:SetPoint("TOPLEFT", -2, 15)
			KS:CreateGradient(option.backdrop)
		end

		option.Header.Ribbon:Hide()
		option.Background:Hide()
		option.Header.Text:SetTextColor(1, 1, 1)
		option.Header.Text.SetTextColor = KUI.dummy
		option.OptionText:SetTextColor(1, 1, 1)
		option.OptionText.SetTextColor = KUI.dummy
		option.ArtworkBorder:SetAlpha(0)
	end
end

S:AddCallbackForAddon("Blizzard_WarboardUI", "KuiWarboard", styleWarboard)