local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local function styleContribution()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.Contribution ~= true or E.private.KlixUI.skins.blizzard.contribution ~= true then return end

	local ContributionCollectionFrame = _G.ContributionCollectionFrame
	ContributionCollectionFrame:StripTextures()
	KS:CreateBD(ContributionCollectionFrame, .25)

	ContributionCollectionFrame:Styling()

	local function styleText(self)
		self.Description:SetVertexColor(1, 1, 1)
	end
	hooksecurefunc(_G.ContributionMixin, "Setup", styleText)

	local function styleRewardText(self)
		self.RewardName:SetTextColor(1, 1, 1)
	end
	hooksecurefunc(_G.ContributionRewardMixin, "Setup", styleRewardText)
end

S:AddCallbackForAddon("Blizzard_Contribution", "KuiContribution", styleContribution)