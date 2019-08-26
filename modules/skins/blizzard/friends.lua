local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local GUILD = GUILD

local function styleFriends()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.friends ~= true or E.private.KlixUI.skins.blizzard.friends ~= true then return end

	_G.FriendsFrame:Styling()
	_G.RecruitAFriendFrame:Styling()
	_G.RecruitAFriendSentFrame:Styling()
	_G.RecruitAFriendSentFrame.MoreDetails.Text:FontTemplate()

	-- GuildTab in FriendsFrame
	local n = _G.FriendsFrame.numTabs + 1
	local gtframe = T.CreateFrame("Button", "FriendsFrameTab"..n, _G.FriendsFrame, "FriendsFrameTabTemplate")
	gtframe:SetText(GUILD)
	gtframe:SetPoint("LEFT", _G["FriendsFrameTab"..n - 1], "RIGHT", -15, 0)
	T.PanelTemplates_DeselectTab(gtframe)
	gtframe:SetScript("OnClick", function() T.ToggleGuildFrame() end)
	S:HandleTab(_G.FriendsFrameTab4)
end

S:AddCallback("KuiFriends", styleFriends)