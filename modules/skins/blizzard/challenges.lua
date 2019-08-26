local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local function styleChallenges()
	if E.private.skins.blizzard.enable ~= true or E.private.KlixUI.skins.blizzard.challenges ~= true then return end


	local KeyStoneFrame = _G.ChallengesKeystoneFrame
	KeyStoneFrame:Styling()

	-- Copied from ElvUI
	local function HandleAffixIcons(self)
		for _, frame in T.ipairs(self.Affixes) do
			frame.Border:SetTexture(nil)
			frame.Portrait:SetTexture(nil)
			if not frame.bg then
				frame.bg = KS:ReskinIcon(frame.Portrait)
			end

			if frame.info then
				frame.Portrait:SetTexture(CHALLENGE_MODE_EXTRA_AFFIX_INFO[frame.info.key].texture)
			elseif frame.affixID then
				local _, _, filedataid = T.C_ChallengeMode_GetAffixInfo(frame.affixID)
				frame.Portrait:SetTexture(filedataid)
			end
		end
	end

	-- Angy Keystone Skinning
	local angryStyle
	local function UpdateIcons(self)
		if T.IsAddOnLoaded("AngryKeystones") and not angryStyle then
			local scheduel, party = T.select(4, self:GetChildren())
			scheduel:GetRegions():SetAlpha(0)
			T.select(3, scheduel:GetRegions()):SetAlpha(0)
			KS:CreateBD(scheduel, .3)
			if scheduel.Entries then
				for i = 1, 3 do
					HandleAffixIcons(scheduel.Entries[i])
				end
			end

			party:GetRegions():SetAlpha(0)
			T.select(3, party:GetRegions()):SetAlpha(0)
			KS:CreateBD(party, .3)

			angryStyle = true
		end
	end
	hooksecurefunc("ChallengesFrame_Update", UpdateIcons)
end

S:AddCallbackForAddon("Blizzard_ChallengesUI", "KuiChallenges", styleChallenges)