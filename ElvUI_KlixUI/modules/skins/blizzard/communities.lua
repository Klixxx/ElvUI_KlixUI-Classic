local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local r, g, b = T.unpack(E.media.rgbvaluecolor)

local function styleCommunities()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.Communities ~= true or E.private.KlixUI.skins.blizzard.communities ~= true then return end
	
	local CommunitiesFrame = _G.CommunitiesFrame
	if CommunitiesFrame.backdrop then
		CommunitiesFrame.backdrop:Styling()
	end
	

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
end

S:AddCallbackForAddon("Blizzard_Communities", "KuiCommunities", styleCommunities)
