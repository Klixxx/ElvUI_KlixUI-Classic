local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local AFK = E:GetModule('AFK')

local lower = string.lower
local TIMEMANAGER_TOOLTIP_LOCALTIME, TIMEMANAGER_TOOLTIP_REALMTIME, MAX_PLAYER_LEVEL_TABLE = TIMEMANAGER_TOOLTIP_LOCALTIME, TIMEMANAGER_TOOLTIP_REALMTIME, MAX_PLAYER_LEVEL_TABLE
local LEVEL, NONE = LEVEL, NONE
local ITEM_UPGRADE_STAT_AVERAGE_ITEM_LEVEL, MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY = ITEM_UPGRADE_STAT_AVERAGE_ITEM_LEVEL, MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY

-- Source wowhead.com
local stats = {
	60,		-- Total deaths
	94,		-- Quests abandoned
	97,		-- Daily quests completed
	98,		-- Quests completed
	107,	-- Creatures killed
	108, 	-- Critters Killed
	112,	-- Deaths from drowning
	113, 	-- Deaths from fatique
	114,	-- Deaths from falling
	115, 	-- Deaths from fire and lava
	319,	-- Duels won
	320,	-- Duels lost
	321,	-- Total raid and dungeon deaths
	326,	-- Gold from quest rewards
	328,	-- Total gold acquired
	329,	-- Auction Posted
	330, 	-- Auction Purchases
	331, 	-- Most Expensive bid on Auction
	333,	-- Gold looted
	334,	-- Most gold ever owned
	338,	-- Vanity pets owned
	339,	-- Mounts owned
	342,	-- Epic items acquired
	346, 	-- Beverages Consumed
	347, 	-- Food Eaten
	349,	-- Flight paths taken
	353,	-- Number of times hearthed
	370, 	-- Highest 2 man personal Rating
	374,	-- Highest 2 man Team Rating
	377,	-- Most factions at Exalted
	588,	-- Total Honorable Kills
	589, 	-- Highest 5 man Team Rating
	590, 	-- Highest 3 man Team Rating
	595, 	-- Highest 3 man Personal rating
	596,	-- Highest 5 man Personal rating
	837,	-- Arenas won
	838,	-- Arenas played
	839,	-- Battlegrounds played
	840,	-- Battlegrounds won
	919,	-- Gold earned from auctions
	921, 	-- Gold from vendors
	931,	-- Total factions encountered
	932,	-- Total 5-player dungeons entered
	933,	-- Total 10-player raids entered
	934,	-- Total 25-player raids entered
	1042,	-- Number of hugs
	1044, 	-- Need rolls made on loot
	1045,	-- Total cheers
	1047,	-- Total facepalms
	1057, 	-- Deaths in 2v2
	1065,	-- Total waves
	1066,	-- Total times LOL'd
	1107, 	-- Deaths in 3v3
	1108, 	-- Deaths in 5v5
	1043, 	-- Greed rolls made on loot
	1146, 	-- Gold spent on travel
	1147, 	-- Gold spent at barber shops
	1148, 	-- Gold spent on postage
	1149,	-- Talent tree respecs
	1150,	-- Gold spent on talent tree respecs
	1197,	-- Total kills
	1198,	-- Total kills that grant experience or honor
	1339,	-- Mage portal taken most
	1456, 	-- Fish and other things caught
	1487,	-- Killing Blows
	1491,	-- Battleground Killing Blows
	1518,	-- Fish caught
	1716,	-- Battleground with the most Killing Blows
	1745,	-- Cooking Recipes known
	2397, 	-- Battleground won the most
	2277,	-- Summons accepted
	5692,	-- Rated battlegrounds played
	5694,	-- Rated battlegrounds won
	7399,	-- Challenge mode dungeons completed
	8278,	-- Pet Battles won at max level
	10060,	-- Garrison Followers recruited
	10181,	-- Garrision Missions completed
	10184,	-- Garrision Rare Missions completed
	11234,	-- Class Hall Champions recruited
	11235,	-- Class Hall Troops recruited
	11236,	-- Class Hall Missions completed
	11237,	-- Class Hall Rare Missions completed
}

-- Create Time
local function createTime()
	local hour, hour24, minute, ampm = T.tonumber(T.date("%I")), T.tonumber(T.date("%H")), T.tonumber(T.date("%M")), T.date("%p"):lower()
	local sHour, sMinute = T.GetGameTime()

	local localTime = T.string_format("|cffb3b3b3%s|r %d:%02d|cffb3b3b3%s|r", TIMEMANAGER_TOOLTIP_LOCALTIME, hour, minute, ampm)
	local localTime24 = T.string_format("|cffb3b3b3%s|r %02d:%02d", TIMEMANAGER_TOOLTIP_LOCALTIME, hour24, minute)
	local realmTime = T.string_format("|cffb3b3b3%s|r %d:%02d|cffb3b3b3%s|r", TIMEMANAGER_TOOLTIP_REALMTIME, sHour, sMinute, ampm)
	local realmTime24 = T.string_format("|cffb3b3b3%s|r %02d:%02d", TIMEMANAGER_TOOLTIP_REALMTIME, sHour, sMinute)

	if E.db.datatexts.localtime then
		if E.db.datatexts.time24 then
			return localTime24
		else
			return localTime
		end
	else
		if E.db.datatexts.time24 then
			return realmTime24
		else
			return realmTime
		end
	end
end

local monthAbr = {
	[1] = L["Jan"],
	[2] = L["Feb"],
	[3] = L["Mar"],
	[4] = L["Apr"],
	[5] = L["May"],
	[6] = L["Jun"],
	[7] = L["Jul"],
	[8] = L["Aug"],
	[9] = L["Sep"],
	[10] = L["Oct"],
	[11] = L["Nov"],
	[12] = L["Dec"],
}

local daysAbr = {
	[1] = L["Sun"],
	[2] = L["Mon"],
	[3] = L["Tue"],
	[4] = L["Wed"],
	[5] = L["Thu"],
	[6] = L["Fri"],
	[7] = L["Sat"],
}

-- Create Date
local function createDate()
	local date = T.C_Calendar_GetDate();
	local presentWeekday = date.weekday;
	local presentMonth = date.month;
	local presentDay = date.monthDay;
	local presentYear = date.year;
	AFK.AFKMode.top.date:SetFormattedText("%s, %s %d, %d", daysAbr[presentWeekday], monthAbr[presentMonth], presentDay, presentYear)
end

-- Create random stats
local function createStats()
	local id = stats[T.math_random( #stats )]
	local _, name = T.GetAchievementInfo(id)
	local result = T.GetStatistic(id)
	if result == "--" then result = NONE end
	return T.string_format("%s: |cfff0ff00%s|r", name, result)
end

local active
local function getSpec()
	local specIndex = T.GetSpecialization()
	if not specIndex then return end

	active = T.GetActiveSpecGroup()

	local talent = ''
	local i = T.GetSpecialization(false, false, active)
	if i then
		i = T.select(2, T.GetSpecializationInfo(i))
		if(i) then
			talent = T.string_format('%s', i)
		end
	end

	return T.string_format('%s', talent)
end

local function getItemLevel()
	local level = T.UnitLevel("player");
	local _, equipped = T.GetAverageItemLevel()
	local ilvl = ''
	if (level >= MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY) then
		ilvl = T.string_format('\n%s: %d', ITEM_UPGRADE_STAT_AVERAGE_ITEM_LEVEL, equipped)
	end
	return ilvl
end

function AFK:UpdateStatMessage()
	E:UIFrameFadeIn(self.AFKMode.statMsg.info, 1, 1, 0)
	local createdStat = createStats()
	self.AFKMode.statMsg.info:SetText(createdStat)
	E:UIFrameFadeIn(self.AFKMode.statMsg.info, 1, 0, 1)
end

function AFK:UpdateLogOff()
	local timePassed = T.GetTime() - self.startTime
	local minutes = T.math_floor(timePassed/60)
	local neg_seconds = -timePassed % 60

	self.AFKMode.top.Status:SetValue(T.math_floor(timePassed))

	if minutes - 29 == 0 and T.math_floor(neg_seconds) == 0 then
		self:CancelTimer(self.logoffTimer)
		self.AFKMode.countd.text:SetFormattedText("%s: |cfff0ff0000:00|r", L["Logout Timer"])
	else
		self.AFKMode.countd.text:SetFormattedText("%s: |cfff0ff00%02d:%02d|r", L["Logout Timer"], minutes -29, neg_seconds)
	end
end

local function UpdateTimer()
	if E.db.KlixUI.general.AFK ~= true then return end

	local createdTime = createTime()

	-- Set time
	AFK.AFKMode.top.time:SetFormattedText(createdTime)

	-- Set Date
	createDate()

	-- Don't need the default timer
	AFK.AFKMode.bottom.time:SetText(nil)
end
hooksecurefunc(AFK, "UpdateTimer", UpdateTimer)

-- XP string
local M = E:GetModule('DataBars');
local function GetXPinfo()
	local maxLevel = MAX_PLAYER_LEVEL_TABLE[T.GetExpansionLevel()];
	if(T.UnitLevel('player') == maxLevel) or T.IsXPUserDisabled() then return end

	local cur, max = M:GetXP('player')
	local curlvl = T.UnitLevel('player')
	return T.string_format('|cfff0ff00%d%%|r (%s) %s |cfff0ff00%d|r', (max - cur) / max * 100, E:ShortValue(max - cur), L["remaining till level"], curlvl + 1)
end

AFK.SetAFKKui = AFK.SetAFK
function AFK:SetAFK(status)
	self:SetAFKKui(status)
	if E.db.KlixUI.general.AFK ~= true then return end

	if(status) then
		local xptxt = GetXPinfo()
		local level = T.UnitLevel('player')
		local race = T.UnitRace('player')
		local localizedClass = T.UnitClass('player')
		local spec = getSpec()
		local ilvl = getItemLevel()
		local petName = E.db.KlixUI.misc.AFKPetModel.pet
		local scale = E.db.KlixUI.misc.AFKPetModel.modelScale
		local facingRad = E.db.KlixUI.misc.AFKPetModel.facing * (T.math_pi/180)
		local animation = E.db.KlixUI.misc.AFKPetModel.animation
		local speciesID	= T.C_PetJournal_FindPetIDByName(petName)
		local displayID = T.select(12, T.C_PetJournal_GetPetInfoBySpeciesID(speciesID));
		self.AFKMode.top:SetHeight(0)
		self.AFKMode.top.anim.height:Play()
		self.AFKMode.bottom:SetHeight(0)
		self.AFKMode.bottom.anim.height:Play()
		self.startTime = T.GetTime()
		self.statsTimer = self:ScheduleRepeatingTimer("UpdateStatMessage", 5)
		self.logoffTimer = self:ScheduleRepeatingTimer("UpdateLogOff", 1)
		if petName ~= "" then
			self.AFKMode.pet.model:SetModelScale(scale)
			self.AFKMode.pet.model:SetFacing(facingRad)
			self.AFKMode.pet.model:ClearModel()
			self.AFKMode.pet.model:SetDisplayInfo(displayID)
			--Animation types are undocumented. Some are listed here: http://us.battle.net/wow/en/forum/topic/8569600188
			self.AFKMode.pet.model:SetAnimation(animation)
			self.AFKMode.pet.model:SetCustomCamera(1)
			self.AFKMode.pet.model:SetCameraDistance(20) --Zoom out, otherwise we get a huge model
		end
		if xptxt then
			self.AFKMode.xp:Show()
			self.AFKMode.xp.text:SetText(xptxt)
		else
			self.AFKMode.xp:Hide()
			self.AFKMode.xp.text:SetText("")
		end
		self.AFKMode.bottom.name:SetFormattedText("%s - %s\n%s %s %s %s %s%s", E.myname, E.myrealm, LEVEL, level, race, spec, localizedClass, ilvl)
		
		self.isAFK = true
	else
		self:CancelTimer(self.statsTimer)
		self:CancelTimer(self.logoffTimer)

		self.AFKMode.countd.text:SetFormattedText("%s: |cfff0ff00-30:00|r", L["Logout Timer"])
		self.AFKMode.statMsg.info:SetFormattedText("|cffb3b3b3%s|r", L["Random Stats"])
		self.isAFK = false
	end
end

local function createPetModel(self)
	self.AFKMode.pet = T.CreateFrame("Frame", nil, self.AFKMode)
	self.AFKMode.pet:SetSize(150, 150)
	self.AFKMode.pet:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 400, 60)
	E:CreateMover(self.AFKMode.pet, "AFKPetModelMover", "AFK Pet Model", nil, nil, nil, "AFK")
	
	self.AFKMode.pet.model = T.CreateFrame("PlayerModel", "ElvUIAFKPetModel", self.AFKMode.pet)
	self.AFKMode.pet.model:SetPoint("CENTER", self.AFKMode.pet, "CENTER")
	--Use a large frame so borders don't become visible when pets do one of their special animations
	self.AFKMode.pet.model:SetSize(T.GetScreenWidth()*2, T.GetScreenHeight()*2)
end
hooksecurefunc(AFK, "Initialize", createPetModel)

local find = string.find

local function IsFoolsDay()
	if T.string_find(T.date(), '04/01/') then
		return true;
	else
		return false;
	end
end

local function prank(self, status)
	if(T.InCombatLockdown()) then return end
	if not IsFoolsDay() then return end

	if(status) then

	end
end
--hooksecurefunc(AFK, "SetAFK", prank)

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

local function Initialize()
	if E.db.general.afk ~= true or E.db.KlixUI.general.AFK ~= true then return end

	local level = T.UnitLevel('player')
	local race = T.UnitRace('player')
	local localizedClass = T.UnitClass('player')
	local className = E.myclass
	local spec = getSpec()
	local ilvl = getItemLevel()

	-- Create Top frame
	AFK.AFKMode.top = T.CreateFrame('Frame', nil, AFK.AFKMode)
	AFK.AFKMode.top:SetFrameLevel(0)
	AFK.AFKMode.top:SetTemplate('Transparent', true, true)
	AFK.AFKMode.top:SetBackdropBorderColor(.3, .3, .3, 1)
	AFK.AFKMode.top:CreateWideShadow()
	AFK.AFKMode.top:ClearAllPoints()
	AFK.AFKMode.top:SetPoint("TOP", AFK.AFKMode, "TOP", 0, E.Border)
	AFK.AFKMode.top:SetWidth(T.GetScreenWidth() + (E.Border*2))
	
	-- Frame Styling
	AFK.AFKMode.top:Styling()
	AFK.AFKMode.bottom:Styling()

	-- Top Animation
	AFK.AFKMode.top.anim = CreateAnimationGroup(AFK.AFKMode.top)
	AFK.AFKMode.top.anim.height = AFK.AFKMode.top.anim:CreateAnimation("Height")
	AFK.AFKMode.top.anim.height:SetChange(T.GetScreenHeight() * (1 / 20))
	AFK.AFKMode.top.anim.height:SetDuration(1)
	AFK.AFKMode.top.anim.height:SetSmoothing("Bounce")

	-- move the chat lower or disable it
	if E.db.KlixUI.general.AFKChat then
		AFK.AFKMode.chat:SetPoint("TOPLEFT", AFK.AFKMode.top, "BOTTOMLEFT", 4, -10)
	else
		AFK.AFKMode.chat:Hide()
	end

	-- WoW logo
	AFK.AFKMode.top.wowlogo = T.CreateFrame('Frame', nil, AFK.AFKMode) -- need this to upper the logo layer
	AFK.AFKMode.top.wowlogo:SetPoint("TOP", AFK.AFKMode.top, "TOP", 0, -5)
	AFK.AFKMode.top.wowlogo:SetFrameStrata("MEDIUM")
	AFK.AFKMode.top.wowlogo:SetSize(300, 150)
	AFK.AFKMode.top.wowlogo.tex = AFK.AFKMode.top.wowlogo:CreateTexture(nil, 'OVERLAY')
	local currentExpansionLevel = T.GetClampedCurrentExpansionLevel()
	local expansionDisplayInfo = T.GetExpansionDisplayInfo(currentExpansionLevel)
	if expansionDisplayInfo then
		AFK.AFKMode.top.wowlogo.tex:SetTexture(expansionDisplayInfo.logo)
	end
	AFK.AFKMode.top.wowlogo.tex:SetInside()

	-- Server/Local Time text
	AFK.AFKMode.top.time = AFK.AFKMode.top:CreateFontString(nil, 'OVERLAY')
	AFK.AFKMode.top.time:FontTemplate(nil, 16)
	AFK.AFKMode.top.time:SetText("")
	AFK.AFKMode.top.time:SetPoint("RIGHT", AFK.AFKMode.top, "RIGHT", -20, 0)
	AFK.AFKMode.top.time:SetJustifyH("LEFT")
	AFK.AFKMode.top.time:SetTextColor(T.unpack(E.media.rgbvaluecolor))

	-- Date text
	AFK.AFKMode.top.date = AFK.AFKMode.top:CreateFontString(nil, 'OVERLAY')
	AFK.AFKMode.top.date:FontTemplate(nil, 16)
	AFK.AFKMode.top.date:SetText("")
	AFK.AFKMode.top.date:SetPoint("LEFT", AFK.AFKMode.top, "LEFT", 20, 0)
	AFK.AFKMode.top.date:SetJustifyH("RIGHT")
	AFK.AFKMode.top.date:SetTextColor(T.unpack(E.media.rgbvaluecolor))

	-- Statusbar on Top frame decor showing time to log off (30mins)
	AFK.AFKMode.top.Status = T.CreateFrame('StatusBar', nil, AFK.AFKMode.top)
	AFK.AFKMode.top.Status:SetStatusBarTexture((E.media.normTex))
	AFK.AFKMode.top.Status:SetMinMaxValues(0, 1800)
	AFK.AFKMode.top.Status:SetStatusBarColor(T.unpack(E.media.rgbvaluecolor))
	AFK.AFKMode.top.Status:SetFrameLevel(2)
	AFK.AFKMode.top.Status:Point('TOPRIGHT', AFK.AFKMode.top, 'BOTTOMRIGHT', 0, E.PixelMode and 5 or 5)
	AFK.AFKMode.top.Status:Point('BOTTOMLEFT', AFK.AFKMode.top, 'BOTTOMLEFT', 0, E.PixelMode and 1 or 2)
	AFK.AFKMode.top.Status:SetValue(0)

	AFK.AFKMode.bottom:SetTemplate('Transparent', true, true)
	AFK.AFKMode.bottom:SetBackdropBorderColor(.3, .3, .3, 1)
	AFK.AFKMode.bottom:CreateWideShadow()
	AFK.AFKMode.bottom.modelHolder:SetFrameLevel(7)

	-- Bottom Frame Animation
	AFK.AFKMode.bottom.anim = CreateAnimationGroup(AFK.AFKMode.bottom)
	AFK.AFKMode.bottom.anim.height = AFK.AFKMode.bottom.anim:CreateAnimation("Height")
	AFK.AFKMode.bottom.anim.height:SetChange(T.GetScreenHeight() * (1 / 9))
	AFK.AFKMode.bottom.anim.height:SetDuration(1)
	AFK.AFKMode.bottom.anim.height:SetSmoothing("Bounce")

	-- Move the factiongroup sign to the center
	AFK.AFKMode.bottom.factionb = T.CreateFrame('Frame', nil, AFK.AFKMode) -- need this to upper the faction logo layer
	AFK.AFKMode.bottom.factionb:SetPoint("BOTTOM", AFK.AFKMode.bottom, "TOP", 0, -40)
	AFK.AFKMode.bottom.factionb:SetFrameStrata("MEDIUM")
	AFK.AFKMode.bottom.factionb:SetFrameLevel(10)
	AFK.AFKMode.bottom.factionb:SetSize(220, 220)
	AFK.AFKMode.bottom.faction:ClearAllPoints()
	AFK.AFKMode.bottom.faction:SetParent(AFK.AFKMode.bottom.factionb)
	AFK.AFKMode.bottom.faction:SetInside()
	-- Apply class texture rather than the faction
	AFK.AFKMode.bottom.faction:SetTexture('Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\classIcons\\CLASS-'..className)

	-- Add more info in the name and position it to the center
	AFK.AFKMode.bottom.name:ClearAllPoints()
	AFK.AFKMode.bottom.name:SetPoint("TOP", AFK.AFKMode.bottom.factionb, "BOTTOM", 0, 5)
	AFK.AFKMode.bottom.name:SetFormattedText("%s - %s\n%s %s %s %s %s%s", E.myname, E.myrealm, LEVEL, level, race, spec, localizedClass, ilvl)
	AFK.AFKMode.bottom.name:SetJustifyH("CENTER")
	AFK.AFKMode.bottom.name:FontTemplate(nil, 18)

	-- Lower the guild text size a bit
	AFK.AFKMode.bottom.guild:ClearAllPoints()
	AFK.AFKMode.bottom.guild:SetPoint("TOP", AFK.AFKMode.bottom.name, "BOTTOM", 0, -6)
	AFK.AFKMode.bottom.guild:FontTemplate(nil, 12)
	AFK.AFKMode.bottom.guild:SetJustifyH("CENTER")

	
	-- ElvUI Logo
	AFK.AFKMode.bottom.logo:ClearAllPoints()
	AFK.AFKMode.bottom.logo:SetParent(AFK.AFKMode.bottom)
	AFK.AFKMode.bottom.logo:Point("LEFT", AFK.AFKMode.bottom, "LEFT", 50, 8)
	AFK.AFKMode.bottom.logo:SetSize(120, 55)
	-- AFK.AFKMode.bottom.logo:Hide() -- Hide ElvUI Logo

	-- ElvUI Version
	AFK.AFKMode.bottom.eversion = KUI:CreateText(AFK.AFKMode.bottom, "OVERLAY", 12, nil)
	AFK.AFKMode.bottom.eversion:SetText("v"..E.version)
	AFK.AFKMode.bottom.eversion:SetPoint("TOP", AFK.AFKMode.bottom.logo, "BOTTOM")
	AFK.AFKMode.bottom.eversion:SetTextColor(T.unpack(E.media.rgbvaluecolor))

	-- KlixUI Logo
	AFK.AFKMode.bottom.KuiLogo = AFK.AFKMode.bottom:CreateTexture(nil, "OVERLAY")
	AFK.AFKMode.bottom.KuiLogo:SetTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\KlixUILogo.tga")
	AFK.AFKMode.bottom.KuiLogo:SetPoint("RIGHT", AFK.AFKMode.bottom, "RIGHT", -50, 8)
	AFK.AFKMode.bottom.KuiLogo:Size(80, 80)

	-- KlixUI Version
	AFK.AFKMode.bottom.mversion = KUI:CreateText(AFK.AFKMode.bottom, "OVERLAY", 12, nil)
	AFK.AFKMode.bottom.mversion:SetText("v"..KUI.Version)
	AFK.AFKMode.bottom.mversion:SetPoint("TOP", AFK.AFKMode.bottom.KuiLogo, "BOTTOM")
	AFK.AFKMode.bottom.mversion:SetTextColor(T.unpack(E.media.rgbvaluecolor))

	
	-- Random stats decor (taken from install routine)
	AFK.AFKMode.statMsg = CreateFrame("Frame", nil, AFK.AFKMode)
	AFK.AFKMode.statMsg:Size(418, 72)
	AFK.AFKMode.statMsg:Point("CENTER", 0, 200)

	AFK.AFKMode.statMsg.bg = AFK.AFKMode.statMsg:CreateTexture(nil, 'BACKGROUND')
	AFK.AFKMode.statMsg.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
	AFK.AFKMode.statMsg.bg:SetPoint('BOTTOM')
	AFK.AFKMode.statMsg.bg:Size(326, 103)
	AFK.AFKMode.statMsg.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
	AFK.AFKMode.statMsg.bg:SetVertexColor(1, 1, 1, 0.7)

	AFK.AFKMode.statMsg.lineTop = AFK.AFKMode.statMsg:CreateTexture(nil, 'BACKGROUND')
	AFK.AFKMode.statMsg.lineTop:SetDrawLayer('BACKGROUND', 2)
	AFK.AFKMode.statMsg.lineTop:SetTexture([[Interface\LevelUp\LevelUpTex]])
	AFK.AFKMode.statMsg.lineTop:SetPoint("TOP")
	AFK.AFKMode.statMsg.lineTop:Size(418, 7)
	AFK.AFKMode.statMsg.lineTop:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

	AFK.AFKMode.statMsg.lineBottom = AFK.AFKMode.statMsg:CreateTexture(nil, 'BACKGROUND')
	AFK.AFKMode.statMsg.lineBottom:SetDrawLayer('BACKGROUND', 2)
	AFK.AFKMode.statMsg.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
	AFK.AFKMode.statMsg.lineBottom:SetPoint("BOTTOM")
	AFK.AFKMode.statMsg.lineBottom:Size(418, 7)
	AFK.AFKMode.statMsg.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

	-- Countdown decor
	AFK.AFKMode.countd = T.CreateFrame("Frame", nil, AFK.AFKMode)
	AFK.AFKMode.countd:Size(418, 36)
	AFK.AFKMode.countd:Point("TOP", AFK.AFKMode.statMsg.lineBottom, "BOTTOM")

	AFK.AFKMode.countd.bg = AFK.AFKMode.countd:CreateTexture(nil, 'BACKGROUND')
	AFK.AFKMode.countd.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
	AFK.AFKMode.countd.bg:SetPoint('BOTTOM')
	AFK.AFKMode.countd.bg:Size(326, 56)
	AFK.AFKMode.countd.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
	AFK.AFKMode.countd.bg:SetVertexColor(1, 1, 1, 0.7)

	AFK.AFKMode.countd.lineBottom = AFK.AFKMode.countd:CreateTexture(nil, 'BACKGROUND')
	AFK.AFKMode.countd.lineBottom:SetDrawLayer('BACKGROUND', 2)
	AFK.AFKMode.countd.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
	AFK.AFKMode.countd.lineBottom:SetPoint('BOTTOM')
	AFK.AFKMode.countd.lineBottom:Size(418, 7)
	AFK.AFKMode.countd.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

	-- 30 mins countdown text
	AFK.AFKMode.countd.text = AFK.AFKMode.countd:CreateFontString(nil, 'OVERLAY')
	AFK.AFKMode.countd.text:FontTemplate(nil, 12)
	AFK.AFKMode.countd.text:SetPoint("CENTER", AFK.AFKMode.countd, "CENTER")
	AFK.AFKMode.countd.text:SetJustifyH("CENTER")
	AFK.AFKMode.countd.text:SetFormattedText("%s: |cfff0ff00-30:00|r", L["Logout Timer"])
	AFK.AFKMode.countd.text:SetTextColor(0.7, 0.7, 0.7)

	AFK.AFKMode.bottom.time:Hide()

	local xptxt = GetXPinfo()
	-- XP info
	AFK.AFKMode.xp = T.CreateFrame("Frame", nil, AFK.AFKMode)
	AFK.AFKMode.xp:Size(418, 36)
	AFK.AFKMode.xp:Point("TOP", AFK.AFKMode.countd.lineBottom, "BOTTOM")
	AFK.AFKMode.xp.bg = AFK.AFKMode.xp:CreateTexture(nil, 'BACKGROUND')
	AFK.AFKMode.xp.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
	AFK.AFKMode.xp.bg:SetPoint('BOTTOM')
	AFK.AFKMode.xp.bg:Size(326, 56)
	AFK.AFKMode.xp.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
	AFK.AFKMode.xp.bg:SetVertexColor(1, 1, 1, 0.7)
	AFK.AFKMode.xp.lineBottom = AFK.AFKMode.xp:CreateTexture(nil, 'BACKGROUND')
	AFK.AFKMode.xp.lineBottom:SetDrawLayer('BACKGROUND', 2)
	AFK.AFKMode.xp.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
	AFK.AFKMode.xp.lineBottom:SetPoint('BOTTOM')
	AFK.AFKMode.xp.lineBottom:Size(418, 7)
	AFK.AFKMode.xp.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)
	AFK.AFKMode.xp.text = AFK.AFKMode.xp:CreateFontString(nil, 'OVERLAY')
	AFK.AFKMode.xp.text:FontTemplate(nil, 12)
	AFK.AFKMode.xp.text:SetPoint("CENTER", AFK.AFKMode.xp, "CENTER")
	AFK.AFKMode.xp.text:SetJustifyH("CENTER")
	AFK.AFKMode.xp.text:SetText(xptxt)
	AFK.AFKMode.xp.text:SetTextColor(0.7, 0.7, 0.7)

	-- Random stats frame
	AFK.AFKMode.statMsg.info = AFK.AFKMode.statMsg:CreateFontString(nil, 'OVERLAY')
	AFK.AFKMode.statMsg.info:FontTemplate(nil, 18)
	AFK.AFKMode.statMsg.info:Point("CENTER", AFK.AFKMode.statMsg, "CENTER", 0, -2)
	AFK.AFKMode.statMsg.info:SetText(T.string_format("|cffb3b3b3%s|r", L["Random Stats"]))
	AFK.AFKMode.statMsg.info:SetJustifyH("CENTER")
	AFK.AFKMode.statMsg.info:SetTextColor(0.7, 0.7, 0.7)
end
hooksecurefunc(AFK, "Initialize", Initialize)