local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local AS = KUI:NewModule('AnnouncementSystem', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

local  gsub = string.gsub

local PlayerName, PlayerRelam = T.UnitName("player"), T.GetRealmName("player")
local PlayerNameWithServer = T.string_format("%s-%s", PlayerName, PlayerRelam)

-- Credits: WindTools

-- https://blog.csdn.net/sftxlin/article/details/48275197
local function BetterSplit(str, split_char)
    if str == "" or str == nil then 
        return {};
    end
	local split_len = T.string_len(split_char)
    local sub_str_tab = {};
    local i = 0;
    local j = 0;
    while true do
        j = T.string_find(str, split_char, i+split_len);
        if T.string_len(str) == i then 
            break;
        end
 
 
        if j == nil then
            T.table_insert(sub_str_tab, T.string_sub(str,i));
            break;
        end;
 
 
        T.table_insert(sub_str_tab, T.string_sub(str,i,j-1));
        i = j+split_len;
    end
    return sub_str_tab;
end

-- https://www.wowinterface.com/forums/showthread.php?t=43082
local tempTooltip = T.CreateFrame("GameTooltip", "FindPetOwnerToolTip", nil, "GameTooltipTemplate")
tempTooltip:SetOwner(_G.WorldFrame, "ANCHOR_NONE")
local tempPetDetails = _G["FindPetOwnerToolTipTextLeft2"]

local function GetPetInfo(pet_name)
	tempTooltip:ClearLines()
	tempTooltip:SetUnit(pet_name)
	local details = tempPetDetails:GetText()
	if not details then return nil end
	local split_word = "'"
	if GetLocale() == "zhCN" or GetLocale() == "zhTW" then split_word = "的" end
	local pet_owner = BetterSplit(details, split_word)[1]
	local pet_role = BetterSplit(details, split_word)[2]
	return pet_owner, pet_role
end

local Feasts = {
	[126492] = true,  -- Banquet of the Grill
	[126494] = true,  -- Great Banquet of the Grill
	[126495] = true,  -- Banquet of the Wok
	[126496] = true,  -- Great Banquet of the Wok
	[126501] = true,  -- Banquet of the Oven
	[126502] = true,  -- Great Banquet of the Oven
	[126497] = true,  -- Banquet of the Pot
	[126498] = true,  -- Great Banquet of the Pot
	[126499] = true,  -- Banquet of the Steamer
	[126500] = true,  -- Great Banquet of the Steamer
	[104958] = true,  -- Pandaren Banquet
	[126503] = true,  -- Banquet of the Brew
	[126504] = true,  -- Great Banquet of the Brew
	[145166] = true,  -- Noodle Cart
	[145169] = true,  -- Deluxe Noodle Cart
	[145196] = true,  -- Pandaren Treasure Noodle Cart
	[188036] = true,  -- Spirit Cauldron
	[201351] = true,  -- Hearty Feast
	[201352] = true,  -- Lavish Suramar Feast
	[259409] = true,  -- Galley Banquet
	[259410] = true,  -- Bountiful Captain's Feast
	[276972] = true,  -- Mystical Cauldron
	[286050] = true,  -- Sanguinated Feast
}

local Bots = {
	[22700] = true,		-- Field Repair Bot 74A
	[44389] = true,		-- Field Repair Bot 110G
	[54711] = true,		-- Scrapbot
	[67826] = true,		-- Jeeves
	[126459] = true,	-- Blingtron 4000
	[161414] = true,	-- Blingtron 5000
	[200061] = true,	-- Reaves
	[200204] = true,	-- Auto-Hammer Mode
	[200205] = true,	-- Auto-Hammer Mode
	[200210] = true,	-- Failure Detection Mode
	[200211] = true,	-- Failure Detection Mode
	[200212] = true,	-- Fireworks Display Mode
	[200214] = true,	-- Fireworks Display Mode
	[200215] = true,	-- Snack Distribution Mode
	[200216] = true,	-- Snack Distribution Mode
	[200217] = true,	-- Bling Mode (Blingtron 6000)
	[200218] = true,	-- Bling Mode (Blingtron 6000)
	[200219] = true,	-- Piloted Combat Mode
	[200220] = true,	-- Piloted Combat Mode
	[200221] = true,	-- Wormhole Generation Mode
	[200222] = true,	-- Wormhole Generation Mode
	[200223] = true,	-- Thermal Anvil Mode
	[200225] = true,	-- Thermal Anvil Mode
	[199109] = true,	-- Auto-Hammer
	[226241] = true,	-- Codex of the Tranquil Mind
	[256230] = true,	-- Codex of the Quiet Mind
}

local Toys = {
	[61031] = true,		-- Toy Train Set (FutFut!)
	[49844] = true,		-- Using Direbrew's Remote
}

local Portals = {
	-- Alliance
	[10059] = true,		-- Portal: Stormwind
	[11416] = true,		-- Portal: Ironforge
	[11419] = true,		-- Portal: Darnassus
	[32266] = true,		-- Portal: Exodar
	[49360] = true,		-- Portal: Theramore
	[33691] = true,		-- Portal: Shattrath
	[88345] = true,		-- Portal: Tol Barad
	[132620] = true,	-- Portal: Vale of Eternal Blossoms
	[176246] = true,	-- Portal: Stormshield
	[281400] = true,	-- Portal: Boralus
	-- Horde
	[11417] = true,		-- Portal: Orgrimmar
	[11420] = true,		-- Portal: Thunder Bluff
	[11418] = true,		-- Portal: Undercity
	[32267] = true,		-- Portal: Silvermoon
	[49361] = true,		-- Portal: Stonard
	[35717] = true,		-- Portal: Shattrath
	[88346] = true,		-- Portal: Tol Barad
	[132626] = true,	-- Portal: Vale of Eternal Blossoms
	[176244] = true,	-- Portal: Warspear
	[281402] = true,	-- Portal: Dazar'alor
	-- Neutral
	[53142] = true,		-- Portal: Dalaran - Northrend
	[224871] = true,	-- Portal: Dalaran - Broken Isles
	[120146] = true,	-- Ancient Portal: Dalaran
}

local Resurrection = {
	[20484] = true,		-- Rebirth
	[61999] = true,		-- Raise Ally
	[20707] = true,		-- Soulstone
	[50769] = true,		-- Revive
	[2006]  = true,		-- Resurrection
	[7328]  = true,		-- Redemption
	[2008]  = true,		-- Ancestral Spirit
	[115178] = true,	-- Resuscitate
	[265116] = true,	-- Unstable Temporal Time Shifter
}

local Taunt = {
	[355] = true,    -- Taunt
	[56222] = true,  -- Dark Command
	[6795] = true,   -- Growl
	[62124] = true,  -- Hand of Reckoning
	[116189] = true, -- Provoke
	[118635] = true, -- Provoke (Black Ox Statue)
	[196727] = true, -- Provoke (Guardian)
	[2649] = true,   -- Growl (Hunter Pet)
	[17735] = true,  -- Suffering (Warlock Pet)
	-- [36213] = true,  -- Angered Earth (Shaman - Guardian Earth Totem) needs testing!
}

local CombatResurrection = {
	[61999] = true,	    -- Raise Ally
	[20484] = true,	    -- Rebirth
	[20707] = true,	    -- Soulstone
	[265116] = true,	-- Unstable Temporal Time Shifter
}

local ThreatTransfer = {
	[34477] = true,	-- Misdirection
	[57934] = true,	-- Tricks of the Trade
}

function AS:SendMessage(text, channel, raid_warning, whisper_target)
	if channel == "NONE" then return end
	
	if channel == "SELF" then ChatFrame1:AddMessage(text) return end
	
	if channel == "WHISPER" then
		if whisper_target then 
			T.SendChatMessage(text, channel, nil, whisper_target)
		end
		return
	end
	
	if channel == "EMOTE" then text = ": "..text end
	
	if channel == "RAID" and raid_warning and T.IsInRaid(LE_PARTY_CATEGORY_HOME) then
		if T.UnitIsGroupLeader("player") or T.UnitIsGroupAssistant("player") or T.IsEveryoneAssistant() then
			channel = "RAID_WARNING"
		end
	end

	T.SendChatMessage(text, channel)
end

function AS:GetChannel(channel_db)
	if T.IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or T.IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then
		return channel_db.instance
	elseif T.IsInRaid(LE_PARTY_CATEGORY_HOME) then
		return channel_db.raid
	elseif T.IsInGroup(LE_PARTY_CATEGORY_HOME) then
		return channel_db.party
	elseif channel_db.solo then
		return channel_db.solo
	end
	return "NONE"
end

function AS:SendAddonMessage(message)
	if T.IsInGroup() and not T.IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and not T.IsInRaid() then
		T.C_ChatInfo_SendAddonMessage(self.Prefix, message, "PARTY")
	elseif T.IsInGroup() and not T.IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and T.IsInRaid() then
		T.C_ChatInfo_SendAddonMessage(self.Prefix, message, "RAID")
	end
end

function AS:CanIAnnounce()
	if not self then return end
	self.AllUsers = {}
	self.ActiveUser = nil
	self.ActiveUserAuthority = nil
	if T.IsInGroup() then self:SendAddonMessage("HELLO") else self.ActiveUser = PlayerNameWithServer end
end

function AS:Interrupt(...)
	local config = self.db.interrupt
	if not config.enable then return end
	if config.only_instance and T.select(2, T.IsInInstance()) == "none" then return end

	local _, _, _, sourceGUID, sourceName, _, _, _, destName, _, _, sourceSpellId, _, _, targetSpellId = ...
	if not (sourceSpellId and targetSpellId) then return end

	-- Format Custom String
	local function FormatMessage(custom_message)
		custom_message = T.string_gsub(custom_message, "%%player%%", sourceName)
		custom_message = T.string_gsub(custom_message, "%%target%%", destName)
		custom_message = T.string_gsub(custom_message, "%%player_spell%%", T.GetSpellLink(sourceSpellId))
		custom_message = T.string_gsub(custom_message, "%%target_spell%%", T.GetSpellLink(targetSpellId))
		return custom_message
	end

	-- Interrupted by yourself and your pet
	if sourceGUID == T.UnitGUID("player") or sourceGUID == T.UnitGUID("pet") then
		if config.player.enable then
			self:SendMessage(FormatMessage(config.player.text), self:GetChannel(config.player.channel))
		end
		return
	end

	-- Interrupted by others
	if config.others.enable then
		local sourceType = T.string_split("-", sourceGUID)
		if sourceType == "Pet" then sourceName = T.select(1, GetPetInfo(sourceName)) end
		if not T.UnitInRaid(sourceName) or not T.UnitInParty(sourceName) then return end
		self:SendMessage(FormatMessage(config.others.text), self:GetChannel(config.others.channel))
	end
end

function AS:Utility(...)
	local config = self.db.utility_spells
	if not config.enable then return end
	local _, event, _, sourceGUID, sourceName, _, _, _, destName, _, _, spellId = ...
	if T.InCombatLockdown() or not event or not spellId or not sourceName then return end
	if sourceName ~= PlayerName and not T.UnitInRaid(sourceName) and not T.UnitInParty(sourceName) then return end
	sourceName = sourceName:gsub("%-[^|]+", "")

	if self.ActiveUser ~= PlayerNameWithServer then return end

	-- Format Custom String
	local function FormatMessage(custom_message)
		custom_message = T.string_gsub(custom_message, "%%player%%", sourceName)
		custom_message = T.string_gsub(custom_message, "%%spell%%", GetSpellLink(spellId))
		return custom_message
	end

	-- Verification
	local function TryAnnounce(spell_db, spell_list)
		if (spell_db.id and spellId == spell_db.id) or (spell_list and spell_list[spellId]) then
			if spell_db.enable and (not spell_db.player_cast or spell_db.player_cast and sourceGUID == T.UnitGUID("player")) then
				self:SendMessage(FormatMessage(spell_db.text), self:GetChannel(config.channel), spell_db.use_raid_warning)
			end
			return true
		end
		return false
	end

	-- Binding Events
	if event == "SPELL_CAST_SUCCESS" then
		if TryAnnounce(config.spells.conjure_refreshment) then return end     -- Summon Refreshments
		if TryAnnounce(config.spells.feasts, Feasts) then return end          -- Big Cauldron
	elseif event == "SPELL_SUMMON" then
		if TryAnnounce(config.spells.bots, Bots) then return end              -- Repair Bots
		if TryAnnounce(config.spells.katy_stampwhistle) then return end       -- Katies Post
	elseif event == "SPELL_CREATE" then
		if TryAnnounce(config.spells.ritual_of_summoning) then return end     -- Ritual of Summoning
		if TryAnnounce(config.spells.moll_e) then return end                  -- MOLL-E Mailbox
		if TryAnnounce(config.spells.create_soulwell) then return end         -- Soulwell
		if TryAnnounce(config.spells.toys, Toys) then return end              -- Toys
		if TryAnnounce(config.spells.portals, Portals) then return end        -- Portal
	end
end

function AS:Combat(...)
	local config = self.db.combat_spells
	if not config.enable then return end
	local _, event, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId = ...
	local difficultyId = T.select(3, T.GetInstanceInfo())
	if not destName or not sourceName then return end
	if sourceName ~= PlayerName and not T.UnitInRaid(sourceName) and not T.UnitInParty(sourceName) then return end

	if self.ActiveUser ~= PlayerNameWithServer then return end

	-- Format Custom String
	local function FormatMessage(custom_message)
		destName = destName:gsub("%-[^|]+", "")
		sourceName = sourceName:gsub("%-[^|]+", "")
		custom_message = T.string_gsub(custom_message, "%%player%%", sourceName)
		custom_message = T.string_gsub(custom_message, "%%target%%", destName)
		custom_message = T.string_gsub(custom_message, "%%spell%%", T.GetSpellLink(spellId))
		return custom_message
	end

	-- Combat Ressurection
	if CombatResurrection[spellId] then
		if config.combat_resurrection.enable then
			if config.combat_resurrection.player_cast then
				if sourceGUID == T.UnitGUID("player") then
					self:SendMessage(FormatMessage(config.combat_resurrection.text), self:GetChannel(config.combat_resurrection.channel), config.combat_resurrection.use_raid_warning)
				end
			else
				self:SendMessage(FormatMessage(config.combat_resurrection.text), self:GetChannel(config.combat_resurrection.channel), config.combat_resurrection.use_raid_warning)
			end
		end
		return true
	end
	
	-- Threat Transfer
	if ThreatTransfer[spellId] then
		if config.threat_transfer.enable then
			local needAnnounce = false

			if config.threat_transfer.player_cast and sourceGUID == T.UnitGUID("player") then needAnnounce = true end
			if config.threat_transfer.target_is_me and destGUID == T.UnitGUID("player") then needAnnounce = true end
			if not config.threat_transfer.target_is_me and not config.threat_transfer.player_cast then needAnnounce = true end

			if config.threat_transfer.only_target_is_not_tank then
				local role = T.UnitGroupRolesAssigned(destName)
				if role == "TANK" or role == "NONE" then needAnnounce = false end
			end

			if needAnnounce then
				self:SendMessage(FormatMessage(config.threat_transfer.text), self:GetChannel(config.threat_transfer.channel), config.threat_transfer.use_raid_warning)
			end
		end
		return true
	end

	return false
end

function AS:Taunt(...)
	local config = self.db.taunt_spells
	if not config.enable then return end

	local timestamp, event, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId = ...
	if not spellId or not sourceGUID or not destGUID or not Taunt[spellId] then return false end

	local sourceType = T.string_split("-", sourceGUID)
	local petOwner, petRole
	
	-- Format Custom String
	local function FormatMessageWithPet(custom_message)
		petOwner = petOwner:gsub("%-[^|]+", "")
		destName = destName:gsub("%-[^|]+", "")
		sourceName = sourceName:gsub("%-[^|]+", "")
		custom_message = T.string_gsub(custom_message, "%%player%%", petOwner)
		custom_message = T.string_gsub(custom_message, "%%target%%", destName)
		custom_message = T.string_gsub(custom_message, "%%spell%%", T.GetSpellLink(spellId))
		custom_message = T.string_gsub(custom_message, "%%pet%%", sourceName)
		custom_message = T.string_gsub(custom_message, "%%pet_role%%", petRole)
		return custom_message
	end

	local function FormatMessageWithoutPet(custom_message)
		destName = destName:gsub("%-[^|]+", "")
		sourceName = sourceName:gsub("%-[^|]+", "")
		custom_message = T.string_gsub(custom_message, "%%player%%", sourceName)
		custom_message = T.string_gsub(custom_message, "%%target%%", destName)
		custom_message = T.string_gsub(custom_message, "%%spell%%", T.GetSpellLink(spellId))
		return custom_message
	end
	
	if event == "SPELL_AURA_APPLIED" then
		-- Taunt Success
		if sourceType == "Player" then
			if sourceName == PlayerName then
				if config.player.player.enable then
					if spellId == 118635 then
						-- Monk (Black Ox Statue)
						if not self.MonkProvokeAllTimeCache[sourceGUID] or timestamp - self.MonkProvokeAllTimeCache[sourceGUID] > 1 then
							self.MonkProvokeAllTimeCache[sourceGUID] = timestamp
							self:SendMessage(FormatMessageWithoutPet(config.player.player.provoke_all_text), self:GetChannel(config.player.player.success_channel))
						end
					else
						self:SendMessage(FormatMessageWithoutPet(config.player.player.success_text), self:GetChannel(config.player.player.success_channel))
					end
				end
			elseif config.others.player.enable then
				if spellId == 118635 then
					if not self.MonkProvokeAllTimeCache[sourceGUID] or timestamp - self.MonkProvokeAllTimeCache[sourceGUID] > 1 then
						self.MonkProvokeAllTimeCache[sourceGUID] = timestamp
						self:SendMessage(FormatMessageWithoutPet(config.others.player.provoke_all_text), self:GetChannel(config.others.player.success_channel))
					end
				else
					self:SendMessage(FormatMessageWithoutPet(config.others.player.success_text), self:GetChannel(config.others.player.success_channel))
				end
			end
		elseif sourceType == "Pet" or sourceType == "Creature" then
			petOwner, petRole = GetPetInfo(sourceName)
			if petOwner == PlayerName then
				if config.player.pet.enable then
					self:SendMessage(FormatMessageWithPet(config.player.pet.success_text), self:GetChannel(config.player.pet.success_channel))
				end
			elseif config.others.pet.enable then
				self:SendMessage(FormatMessageWithPet(config.others.pet.success_text), self:GetChannel(config.others.pet.success_channel))
			end
		end
	elseif event == "SPELL_MISSED" then
		-- Taunt Failure
		if sourceType == "Player" then
			if sourceName == PlayerName then
				if config.player.player.enable then
					self:SendMessage(FormatMessageWithoutPet(config.player.player.failed_text), self:GetChannel(config.player.player.failed_channel))
				end
			elseif config.others.player.enable then
				self:SendMessage(FormatMessageWithoutPet(config.others.player.failed_text), self:GetChannel(config.others.player.failed_channel))
			end
		elseif sourceType == "Pet" or sourceType == "Creature" then
			petOwner, petRole = GetPetInfo(sourceName)
			if petOwner == PlayerName then
				if config.player.pet.enable then
					self:SendMessage(FormatMessageWithPet(config.player.pet.failed_text), self:GetChannel(config.player.pet.failed_channel))
				end
			elseif config.others.pet.enable then
				self:SendMessage(FormatMessageWithPet(config.others.pet.failed_text), self:GetChannel(config.others.pet.failed_channel))
			end
		end
	end

	return true
end

function AS:SayThanks(...)
	local config = self.db.thanks
	if not config.enable then return end
	local _, event, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId = ...
	if not destGUID or not sourceGUID then return end

	local function FormatMessage(custom_message)
		destName = destName:gsub("%-[^|]+", "")
		sourceName = sourceName:gsub("%-[^|]+", "")
		custom_message = T.string_gsub(custom_message, "%%player%%", destName)
		custom_message = T.string_gsub(custom_message, "%%target%%", sourceName)
		custom_message = T.string_gsub(custom_message, "%%spell%%", T.GetSpellLink(spellId))
		return custom_message
	end
	
	if Resurrection[spellId] then
		-- Exclude pre-bound soul stone
		if not T.InCombatLockdown() and spellId == 20707 then return end
		if config.resurrection.enable and sourceGUID ~= T.UnitGUID("player") and destGUID == T.UnitGUID("player") then
			self:SendMessage(FormatMessage(config.resurrection.text), self:GetChannel(config.resurrection.channel), nil, sourceName)
		end
	end
end

function AS:SayThanks_Goodbye()
	local config = self.db.thanks
	if not config.enable or not config.goodbye.enable then return end
	self:SendMessage(config.goodbye.text, self:GetChannel(config.goodbye.channel))
end

function AS:LFG_COMPLETION_REWARD(event, ...)
	T.C_Timer_After(1, function() self:SayThanks_Goodbye() end)
end

function AS:CHALLENGE_MODE_COMPLETED(event, ...)
	T.C_Timer_After(1, function() self:SayThanks_Goodbye() end)
end

function AS:GROUP_ROSTER_UPDATE(event, ...)
	self:CanIAnnounce()
end

function AS:ZONE_CHANGED_NEW_AREA(event, ...)
	self:CanIAnnounce()
end

function AS:CHAT_MSG_ADDON(event, ...)
	local prefix, message, channel, sender = T.select(1, ...)
	if prefix ~= self.Prefix then return end
	-- The default user automatically greets when entering a team.
	if message == "HELLO" then
		local authority = 0
		if not T.IsInGroup() then return end
		if T.UnitIsGroupLeader("player") then authority = 2 end
		if T.UnitIsGroupAssistant("player") then authority = 1 end
		self:SendAddonMessage("FB_"..authority)
	elseif message:match("^FB_") then
		local authority = T.tonumber(T.select(2, T.string_split("_", message)))
		self.AllUsers[sender] = authority
		for user_name, user_authority in T.pairs(self.AllUsers) do
			if self.ActiveUser == nil then
				self.ActiveUser = user_name
				self.ActiveUserAuthority = user_authority
			elseif user_authority > self.ActiveUserAuthority then
				self.ActiveUser = user_name
				self.ActiveUserAuthority = user_authority
			elseif user_authority == self.ActiveUserAuthority and user_name < self.ActiveUser then
				self.ActiveUser = user_name
				self.ActiveUserAuthority = user_authority
			end
		end
		--T.print("[KlixUI DEBUG] ActiveUser is: ", self.ActiveUser)
	end
end

function AS:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
	local subEvent = T.select(2, T.CombatLogGetCurrentEventInfo())

	if subEvent == "SPELL_CAST_SUCCESS" then
		self:SayThanks(T.CombatLogGetCurrentEventInfo())
		if self:Combat(T.CombatLogGetCurrentEventInfo()) then return end
		self:Utility(T.CombatLogGetCurrentEventInfo())
	elseif subEvent == "SPELL_SUMMON" then
		self:Utility(T.CombatLogGetCurrentEventInfo())
	elseif subEvent == "SPELL_CREATE" then
		self:Utility(T.CombatLogGetCurrentEventInfo())
	elseif subEvent == "SPELL_INTERRUPT" then
		self:Interrupt(T.CombatLogGetCurrentEventInfo())
	elseif subEvent == "SPELL_AURA_APPLIED" then
		self:Taunt(T.CombatLogGetCurrentEventInfo())
	elseif subEvent == "SPELL_MISSED" then
		self:Taunt(T.CombatLogGetCurrentEventInfo())
	end
end

function AS:Initialize()
	self.db = E.db.KlixUI.announcement
	
	if not self.db.enable then return end

	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("LFG_COMPLETION_REWARD")
	self:RegisterEvent("CHALLENGE_MODE_COMPLETED")
	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("CHAT_MSG_ADDON")

	self.Prefix = "KlixUI AS"
	self.AllUsers = {}
	local regStatus = T.C_ChatInfo_RegisterAddonMessagePrefix(self.Prefix)
	if not regStatus then T.print("[KlixUI Announce System] Prefix error") end

	self.MonkProvokeAllTimeCache = {}

	self.CanIAnnounce()
end

local function InitializeCallback()
	AS:Initialize()
end

KUI:RegisterModule(AS:GetName(), InitializeCallback)