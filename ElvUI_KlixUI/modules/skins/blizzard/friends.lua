local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local GUILD = GUILD

local function styleFriends()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.friends ~= true or E.private.KlixUI.skins.blizzard.friends ~= true then return end
	
	--Friends
	local FriendsFrame = _G.FriendsFrame
	if FriendsFrame.backdrop then
		FriendsFrame.backdrop:Styling()
	end
	
	--Guild
	
	-- Raid Info Frame
	local RaidInfoFrame = _G.RaidInfoFrame
	RaidInfoFrame:Styling()
end

S:AddCallback("KuiFriends", styleFriends)