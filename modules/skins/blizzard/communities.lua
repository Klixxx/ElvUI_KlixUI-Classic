local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local r, g, b = T.unpack(E.media.rgbvaluecolor)

local function styleCommunities()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.Communities ~= true or E.private.KlixUI.skins.blizzard.communities ~= true then return end
	
	local CommunitiesFrame = _G.CommunitiesFrame
	CommunitiesFrame.backdrop:Styling()

	-- Active Communities
	hooksecurefunc(_G.CommunitiesListEntryMixin, "SetClubInfo", function(self, clubInfo, isInvitation, isTicket)
		if clubInfo then
			if self.bg and self.bg.backdrop then
				KS:CreateGradient(self.bg.backdrop)
			end
		end
	end)

	-- Add Community Button
	hooksecurefunc(_G.CommunitiesListEntryMixin, "SetAddCommunity", function(self)
		if self.bg and self.bg.backdrop then
			KS:CreateGradient(self.bg.backdrop)
		end
	end)

	for _, name in T.next, {"ChatTab", "RosterTab", "GuildBenefitsTab", "GuildInfoTab"} do
		local tab = CommunitiesFrame[name]
		tab:GetRegions():Hide()
		KS:ReskinIcon(tab.Icon)
		tab:GetHighlightTexture():SetColorTexture(r, g, b, .25)
	end

	-- Chat Tab
	local Dialog = CommunitiesFrame.NotificationSettingsDialog
	Dialog:StripTextures()
	Dialog.BG:Hide()
	Dialog.backdrop:Styling()

	KS:Reskin(Dialog.OkayButton)
	KS:Reskin(Dialog.CancelButton)
	Dialog.ScrollFrame.Child.QuickJoinButton:SetSize(25, 25)
	KS:Reskin(Dialog.ScrollFrame.Child.AllButton)
	KS:Reskin(Dialog.ScrollFrame.Child.NoneButton)

	hooksecurefunc(Dialog, "Refresh", function(self)
		local frame = self.ScrollFrame.Child
		for i = 1, frame:GetNumChildren() do
			local child = T.select(i, frame:GetChildren())
			if child.StreamName and not child.styled then
				KS:Reskin(child.ShowNotificationsButton)
				KS:Reskin(child.HideNotificationsButton)

				child.styled = true
			end
		end
	end)

	local Dialog = CommunitiesFrame.EditStreamDialog
	KS:CreateBDFrame(Dialog.Description, .25)
	Dialog.backdrop:Styling()

	-- Roster
	KS:CreateBDFrame(CommunitiesFrame.MemberList.ListScrollFrame, .25)

	local DetailFrame = CommunitiesFrame.GuildMemberDetailFrame
	DetailFrame:ClearAllPoints()
	DetailFrame:SetPoint("TOPLEFT", CommunitiesFrame, "TOPRIGHT", 34, 0)
	DetailFrame:Styling()

	-- Guild Perks
	hooksecurefunc("CommunitiesGuildPerks_Update", function(self)
		local buttons = self.Container.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if button and button.backdrop then
				button.backdrop:SetTemplate("Transparent")
				button.backdrop:SetPoint("TOPLEFT", button.Icon, -1, 1)
				button.backdrop:SetPoint("BOTTOMRIGHT", button.Right, 1, -1)
				KS:CreateGradient(button.backdrop)
			end
		end
	end)

	-- Guild Rewards
	hooksecurefunc("CommunitiesGuildRewards_Update", function(self)
		local buttons = self.RewardsContainer.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if button and button.backdrop then
				button.backdrop:SetTemplate("Transparent")
				button.backdrop:SetPoint("TOPLEFT", button.Icon, 0, 1)
				button.backdrop:SetPoint("BOTTOMRIGHT", 0, 3)
				KS:CreateGradient(button.backdrop)

				if button.hover then
					button.hover:SetInside(button.backdrop)
					button.hover:SetColorTexture(r, g, b, 0.3)
				end

				button.DisabledBG:Hide()
			end
		end
	end)

	-- Guild Recruitment
	local GuildRecruitmentFrame = _G.CommunitiesGuildRecruitmentFrame
	GuildRecruitmentFrame.backdrop:Styling()

	-- Guild Log
	local GuildLog = _G.CommunitiesGuildLogFrame
	GuildLog:Styling()

	--Guild MOTD Edit
	local GuildText = _G.CommunitiesGuildTextEditFrame
	GuildText:Styling()

	-- Guild News Filter
	local GuildNewsFilter = _G.CommunitiesGuildNewsFiltersFrame
	GuildNewsFilter.backdrop:Styling()
end

S:AddCallbackForAddon("Blizzard_Communities", "KuiCommunities", styleCommunities)
