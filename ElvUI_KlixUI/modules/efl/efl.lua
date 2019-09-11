local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local EFL = KUI:NewModule("EnhancedFriendsList", "AceHook-3.0")
local LSM = E.LSM or E.Libs.LSM

local MediaPath = "Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\"

EFL.GameIcons = {
	Default = {
		Alliance = T.BNet_GetClientTexture(BNET_CLIENT_WOW ),
		Horde = T.BNet_GetClientTexture(BNET_CLIENT_WOW ),
		Neutral = T.BNet_GetClientTexture(BNET_CLIENT_WOW ),
		D3 = T.BNet_GetClientTexture(BNET_CLIENT_D3),
		WTCG = T.BNet_GetClientTexture(BNET_CLIENT_WTCG),
		S1 = T.BNet_GetClientTexture(BNET_CLIENT_SC),
		S2 = T.BNet_GetClientTexture(BNET_CLIENT_SC2),
		App = T.BNet_GetClientTexture(BNET_CLIENT_APP),
		BSAp = T.BNet_GetClientTexture(BNET_CLIENT_APP),
		Hero = T.BNet_GetClientTexture(BNET_CLIENT_HEROES),
		Pro = T.BNet_GetClientTexture(BNET_CLIENT_OVERWATCH),
		DST2 = T.BNet_GetClientTexture(BNET_CLIENT_DESTINY2),
		VIPR = T.BNet_GetClientTexture(BNET_CLIENT_COD),
	},
	BlizzardChat = {
		Alliance = "Interface\\ChatFrame\\UI-ChatIcon-WoW",
		Horde = "Interface\\ChatFrame\\UI-ChatIcon-WoW",
		Neutral = "Interface\\ChatFrame\\UI-ChatIcon-WoW",
		D3 = "Interface\\ChatFrame\\UI-ChatIcon-D3",
		WTCG = "Interface\\ChatFrame\\UI-ChatIcon-WTCG",
		S1 = "Interface\\ChatFrame\\UI-ChatIcon-SC",
		S2 = "Interface\\ChatFrame\\UI-ChatIcon-SC2",
		App = "Interface\\ChatFrame\\UI-ChatIcon-Battlenet",
		BSAp = "Interface\\ChatFrame\\UI-ChatIcon-Battlenet",
		Hero = "Interface\\ChatFrame\\UI-ChatIcon-HotS",
		Pro = "Interface\\ChatFrame\\UI-ChatIcon-Overwatch",
		DST2 = "Interface\\ChatFrame\\UI-ChatIcon-Destiny2",
		VIPR = "Interface\\ChatFrame\\UI-ChatIcon-CallOfDutyBlackOps4"
	},
	Flat = {
		Alliance = MediaPath.."GameIcons\\Flat\\Alliance",
		Horde = MediaPath.."GameIcons\\Flat\\Horde",
		Neutral = MediaPath.."GameIcons\\Flat\\Neutral",
		D3 = MediaPath.."GameIcons\\Flat\\D3",
		WTCG = MediaPath.."GameIcons\\Flat\\Hearthstone",
		S1 = "Interface\\ChatFrame\\UI-ChatIcon-SC",
		S2 = MediaPath.."GameIcons\\Flat\\SC2",
		App = MediaPath.."GameIcons\\Flat\\BattleNet",
		BSAp = MediaPath.."GameIcons\\Flat\\BattleNet",
		Hero = MediaPath.."GameIcons\\Flat\\Heroes",
		Pro = MediaPath.."GameIcons\\Flat\\Overwatch",
		DST2 = "Interface\\ChatFrame\\UI-ChatIcon-Destiny2",
		VIPR = MediaPath.."GameIcons\\Flat\\COD4",
	},
	Gloss = {
		Alliance = MediaPath.."GameIcons\\Gloss\\Alliance",
		Horde = MediaPath.."GameIcons\\Gloss\\Horde",
		Neutral = MediaPath.."GameIcons\\Gloss\\Neutral",
		D3 = MediaPath.."GameIcons\\Gloss\\D3",
		WTCG = MediaPath.."GameIcons\\Gloss\\Hearthstone",
		S1 = "Interface\\ChatFrame\\UI-ChatIcon-SC",
		S2 = MediaPath.."GameIcons\\Gloss\\SC2",
		App = MediaPath.."GameIcons\\Gloss\\BattleNet",
		BSAp = MediaPath.."GameIcons\\Gloss\\BattleNet",
		Hero = MediaPath.."GameIcons\\Gloss\\Heroes",
		Pro = MediaPath.."GameIcons\\Gloss\\Overwatch",
		DST2 = "Interface\\ChatFrame\\UI-ChatIcon-Destiny2",
		VIPR = MediaPath.."GameIcons\\Gloss\\COD4",
	},
	Launcher = {
		Alliance = MediaPath.."GameIcons\\Launcher\\Alliance",
		Horde = MediaPath.."GameIcons\\Launcher\\Horde",
		Neutral = MediaPath.."GameIcons\\Launcher\\Neutral",
		D3 = MediaPath.."GameIcons\\Launcher\\D3",
		WTCG = MediaPath.."GameIcons\\Launcher\\Hearthstone",
		S1 = MediaPath.."GameIcons\\Launcher\\SC",
		S2 = MediaPath.."GameIcons\\Launcher\\SC2",
		App = MediaPath.."GameIcons\\Bnet",
		BSAp = MediaPath.."GameIcons\\Launcher\\BattleNet",
		Hero = MediaPath.."GameIcons\\Launcher\\Heroes",
		Pro = MediaPath.."GameIcons\\Launcher\\Overwatch",
		DST2 = MediaPath.."GameIcons\\Launcher\\Destiny2",
		VIPR = MediaPath.."GameIcons\\Launcher\\COD4",
	},
}

EFL.StatusIcons = {
	Default = {
		Online = FRIENDS_TEXTURE_ONLINE,
		Offline = FRIENDS_TEXTURE_OFFLINE,
		DND = FRIENDS_TEXTURE_DND,
		AFK = FRIENDS_TEXTURE_AFK,
	},
	Square = {
		Online = MediaPath.."StatusIcons\\Square\\Online",
		Offline = MediaPath.."StatusIcons\\Square\\Offline",
		DND = MediaPath.."StatusIcons\\Square\\DND",
		AFK = MediaPath.."StatusIcons\\Square\\AFK",
	},
	D3 = {
		Online = MediaPath.."StatusIcons\\D3\\Online",
		Offline = MediaPath.."StatusIcons\\D3\\Offline",
		DND = MediaPath.."StatusIcons\\D3\\DND",
		AFK = MediaPath.."StatusIcons\\D3\\AFK",
	},
}

local ClientColor = {
	S1 = "C495DD",
	S2 = "C495DD",
	D3 = "C41F3B",
	Pro = "00C0FA",
	WTCG = "4EFF00",
	Hero = "00CCFF",
	App = "82C5FF",
	BSAp = '82C5FF',
	DST2 = "00C0FA",
	VIPR = 'FFFFFF',
}

local function getDiffColorString(level)
	local color = T.GetQuestDifficultyColor(level)
	return E:RGBToHex(color.r, color.g, color.b)
end

function EFL:BasicUpdateFriends(button)
	local nameText, nameColor, infoText, broadcastText, _, Cooperate
	if button.buttonType == FRIENDS_BUTTON_TYPE_WOW then
		local name, level, class, area, connected, status = T.C_FriendList_GetFriendInfo(button.id)
		broadcastText = nil
		if connected then
			button.status:SetTexture(EFL.StatusIcons[EFL.db["StatusIconPack"]][(status == CHAT_FLAG_DND and 'DND' or status == CHAT_FLAG_AFK and "AFK" or "Online")])
			nameText = KUI:ClassColorCode(class) .. name.."|r, "..format(FRIENDS_LEVEL_TEMPLATE, getDiffColorString(level) .. level .. "|r", class)
			nameColor = _G.FRIENDS_WOW_NAME_COLOR
			Cooperate = true
		else
			button.status:SetTexture(EFL.StatusIcons[EFL.db["StatusIconPack"]].Offline)
			nameText = name
			nameColor = _G.FRIENDS_GRAY_COLOR
		end
		infoText = area
	elseif button.buttonType == FRIENDS_BUTTON_TYPE_BNET and T.BNConnected() then
		local presenceID, presenceName, battleTag, isBattleTagPresence, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isRIDFriend, messageTime, canSoR = T.BNGetFriendInfo(button.id)
		local realmName, realmID, faction, race, class, zoneName, level, gameText
		broadcastText = messageText
		local characterName = toonName
		if presenceName then
			nameText = presenceName
			if isOnline then
				characterName = T.BNet_GetValidatedCharacterName(characterName, battleTag, client)
			end
		else
			nameText = UNKNOWN
		end

		if characterName then
			_, _, _, realmName, realmID, faction, race, class, _, zoneName, level, gameText = T.BNGetGameAccountInfo(toonID)
			if client == BNET_CLIENT_WOW then
				if (level == nil or T.tonumber(level) == nil) then level = 0 end
				local classcolor = KUI:ClassColorCode(class)
				local diff = level ~= 0 and T.string_format('FF%02x%02x%02x', GetQuestDifficultyColor(level).r * 255, GetQuestDifficultyColor(level).g * 255, GetQuestDifficultyColor(level).b * 255) or 'FFFFFFFF'
				nameText = T.string_format('%s |cFFFFFFFF(|r%s - %s %s|cFFFFFFFF)|r', nameText, WrapTextInColorCode(characterName, classcolor), LEVEL, WrapTextInColorCode(level, diff))
				Cooperate = T.CanCooperateWithGameAccount(toonID)
			else
				if not ClientColor[client] then
					client = 'App'
				end
				nameText = T.string_format("|cFF%s%s|r", ClientColor[client] or 'FFFFFF', nameText)
			end
		end

		if isOnline then
			button.status:SetTexture(EFL.StatusIcons[EFL.db["StatusIconPack"]][(status == CHAT_FLAG_DND and "DND" or status == CHAT_FLAG_AFK and "AFK" or "Online")])
			if client == BNET_CLIENT_WOW then
				if not zoneName or zoneName == "" then
					infoText = UNKNOWN
				else
					if realmName == E.myRealm then
						infoText = zoneName
					else
						infoText = T.string_gsub(gameText, '&apos;', "'")
					end
				end
				button.gameIcon:SetTexture(EFL.GameIcons[EFL.db["GameIconPack"]][faction])
			else
				infoText = gameText
				button.gameIcon:SetTexture(EFL.GameIcons[EFL.db["GameIconPack"]][client])
			end
			nameColor = _G.FRIENDS_BNET_NAME_COLOR
			button.gameIcon:SetTexCoord(0, 1, 0, 1)
		else
			button.status:SetTexture(EFL.StatusIcons[EFL.db["StatusIconPack"]].Offline)
			nameColor = _G.FRIENDS_GRAY_COLOR
			infoText = lastOnline == 0 and FRIENDS_LIST_OFFLINE or T.string_format(BNET_LAST_ONLINE_TIME, T.FriendsFrame_GetLastOnline(lastOnline))
		end
	end

	if button.summonButton:IsShown() then
		button.gameIcon:SetPoint("TOPRIGHT", -50, -2)
	else
		button.gameIcon:SetPoint("TOPRIGHT", -21, -2)
	end

	if not button.isUpdateHooked then
		button:HookScript("OnUpdate", function(self, elapsed)
			if button.gameIcon:GetTexture() == MediaPath..'GameIcons\\Bnet' then
				T.AnimateTexCoords(self.gameIcon, 512, 256, 64, 64, 25, elapsed, 0.02)
			end
		end)
		button.isUpdateHooked = true
	end

	if nameText then
		button.name:SetText(nameText)
		button.name:SetTextColor(nameColor.r, nameColor.g, nameColor.b)
		button.info:SetText(infoText)
		button.info:SetTextColor(.49, .52, .54)
		if Cooperate then
			button.info:SetTextColor(1, .96, .45)
		end
		if LSM then
			button.name:SetFont(LSM:Fetch("font", EFL.db.NameFont), EFL.db.NameFontSize, EFL.db.NameFontFlag)
			button.info:SetFont(LSM:Fetch("font",EFL.db.InfoFont), EFL.db.InfoFontSize, EFL.db.InfoFontFlag)
		end
	end
end

function EFL:Initialize()
	if not E.db.KlixUI.efl.enable or T.IsAddOnLoaded("ProjectAzilroka") then return end

	EFL.db = E.db.KlixUI.efl
	
	KUI:RegisterDB(self, "efl")
	
	EFL:SecureHook("FriendsFrame_UpdateFriendButton", 'BasicUpdateFriends')
end

local function InitializeCallback()
	EFL:Initialize()
end

KUI:RegisterModule(EFL:GetName(), InitializeCallback)