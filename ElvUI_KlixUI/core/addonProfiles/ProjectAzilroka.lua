local KUI, T, E, L, V, P, G = unpack(select(2, ...))

function KUI:LoadPAProfile()
	local PA = _G.ProjectAzilroka
	PA.data:SetProfile('KlixUI')
	
	-- ProjectAzilrokaDB
	PA.db['BigButtons']['Enable'] = false
	PA.db['BrokerLDB']['Enable'] = false
	PA.db['DragonOverlay']['Enable'] = false
	PA.db['EnhancedShadows']['Enable'] = false
	PA.db['FasterLoot']['Enable'] = false
	--PA.db['FriendGroup']['Enable'] = false
	--PA.db['LootConfirm']['Enable'] = false
	PA.db['MovableFrames']['Enable'] = false
	PA.db['QuestSounds']['Enable'] = false

	--	EnhancedFriendsListProfilesDB
	PA.db["EnhancedFriendsList"]["NameFont"] = "Expressway"
	PA.db["EnhancedFriendsList"]["NameFontSize"] = 11
	PA.db["EnhancedFriendsList"]['NameFontFlag'] = "OUTLINE"
	PA.db["EnhancedFriendsList"]["InfoFont"] = "Expressway"
	PA.db["EnhancedFriendsList"]["InfoFontSize"] = 10
	PA.db["EnhancedFriendsList"]['InfoFontFlag'] = "OUTLINE"
	PA.db["EnhancedFriendsList"]["StatusIconPack"] = "D3"
	PA.db["EnhancedFriendsList"]['Alliance']  = "Launcher"
	PA.db["EnhancedFriendsList"]['Horde']  = "Launcher"
	PA.db["EnhancedFriendsList"]['Neutral']  = "Launcher"
	PA.db["EnhancedFriendsList"]['D3']  = "Launcher"
	PA.db["EnhancedFriendsList"]['WTCG']  = "Launcher"
	PA.db["EnhancedFriendsList"]['S1']  = "Launcher"
	PA.db["EnhancedFriendsList"]['S2']  = "Launcher"
	PA.db["EnhancedFriendsList"]['App']  = "Animated"
	PA.db["EnhancedFriendsList"]['BSAp'] = "Animated"
	PA.db["EnhancedFriendsList"]['Hero'] = "Launcher"
	PA.db["EnhancedFriendsList"]['Pro'] = "Launcher"
	PA.db["EnhancedFriendsList"]['DST2'] = "Launcher"
	
	-- SquareMinimapButtonsProfilesDB
	PA.db['SquareMinimapButtons']['BarEnabled'] = true
	PA.db['SquareMinimapButtons']['ButtonsPerRow'] = 6
	PA.db['SquareMinimapButtons']['IconSize'] = 24
	PA.db['SquareMinimapButtons']['ButtonSpacing'] = 1
	PA.db['SquareMinimapButtons']['MoveGarrison'] = false
	PA.db['SquareMinimapButtons']['MoveMail'] = false
	PA.db['SquareMinimapButtons']['MoveTracker'] = false
	PA.db['SquareMinimapButtons']['MoveQueue'] = false
	if IsAddOnLoaded('XIV_Databar') then
		E.db["movers"]["SquareMinimapButtonBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-10,-211"
	else
		E.db["movers"]["SquareMinimapButtonBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-10,-196"
	end

	-- stAddonManagerProfilesDB
	PA.db["stAddonManager"]['NumAddOns'] = 30
	PA.db["stAddonManager"]["ButtonHeight"] = 20
	PA.db["stAddonManager"]["ButtonWidth"] = 20
	PA.db["stAddonManager"]["Font"] = "Expressway"
	PA.db["stAddonManager"]['FontSize'] = 12
	PA.db["stAddonManager"]['FontFlag'] = 'OUTLINE'
	PA.db["stAddonManager"]["ClassColor"] = true
	PA.db["stAddonManager"]["CheckTexture"] = "Klix"
end