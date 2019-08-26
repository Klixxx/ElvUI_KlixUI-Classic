local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local function styleIslandsPartyPose()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.IslandsPartyPose ~= true or E.private.KlixUI.skins.blizzard.IslandsPartyPose ~= true then return end

	local IslandsPartyPoseFrame = _G.IslandsPartyPoseFrame
	IslandsPartyPoseFrame:StripTextures() -- Maybe not needed? 
	IslandsPartyPoseFrame:CreateBackdrop("Transparent") -- Maybe not needed?
	IslandsPartyPoseFrame:Styling()

	KS:Reskin(IslandsPartyPoseFrame.LeaveButton) -- Maybe not needed?

	IslandsPartyPoseFrame.ModelScene:StripTextures()
	KS:CreateBDFrame(IslandsPartyPoseFrame.ModelScene, .25)

	IslandsPartyPoseFrame.Background:Hide()

	local rewardFrame = IslandsPartyPoseFrame.RewardAnimations.RewardFrame
	local bg = KS:CreateBDFrame(rewardFrame)
	bg:SetPoint("TOPLEFT", -5, 5)
	bg:SetPoint("BOTTOMRIGHT", rewardFrame.NameFrame, 0, -5)

	rewardFrame.NameFrame:SetAlpha(0)
	rewardFrame.IconBorder:SetAlpha(0)
	rewardFrame.Icon:SetTexCoord(T.unpack(E.TexCoords))
	KS:CreateBDFrame(rewardFrame.Icon)

end

S:AddCallbackForAddon("Blizzard_IslandsPartyPoseUI", "KuiIslandsPartyPose", styleIslandsPartyPose)