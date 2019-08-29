local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local AFK = E:GetModule('AFK')

local lower = string.lower
local TIMEMANAGER_TOOLTIP_LOCALTIME, TIMEMANAGER_TOOLTIP_REALMTIME, MAX_PLAYER_LEVEL_TABLE = TIMEMANAGER_TOOLTIP_LOCALTIME, TIMEMANAGER_TOOLTIP_REALMTIME, MAX_PLAYER_LEVEL_TABLE
local LEVEL, NONE = LEVEL, NONE
local ITEM_UPGRADE_STAT_AVERAGE_ITEM_LEVEL, MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY = ITEM_UPGRADE_STAT_AVERAGE_ITEM_LEVEL, MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY

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
	local date = C_Calendar_GetDate()
	local presentWeekday = date.weekday
	local presentMonth = date.month
	local presentDay = date.monthDay
	local presentYear = date.year
	AFK.AFKMode.top.date:SetFormattedText("%s, %s %d, %d", daysAbr[presentWeekday], monthAbr[presentMonth], presentDay, presentYear)
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
	--createDate()

	-- Don't need the default timer
	AFK.AFKMode.bottom.time:SetText(nil)
end
hooksecurefunc(AFK, "UpdateTimer", UpdateTimer)

-- XP string
local M = E:GetModule('DataBars')
local function GetXPinfo()
	local maxLevel = MAX_PLAYER_LEVEL_TABLE[T.GetExpansionLevel()]
	if(T.UnitLevel('player') == maxLevel) then return end

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
		self.AFKMode.top:SetHeight(0)
		self.AFKMode.top.anim.height:Play()
		self.AFKMode.bottom:SetHeight(0)
		self.AFKMode.bottom.anim.height:Play()
		self.startTime = T.GetTime()
		self.logoffTimer = self:ScheduleRepeatingTimer("UpdateLogOff", 1)
		if xptxt then
			self.AFKMode.xp:Show()
			self.AFKMode.xp.text:SetText(xptxt)
		else
			self.AFKMode.xp:Hide()
			self.AFKMode.xp.text:SetText("")
		end
		self.AFKMode.bottom.name:SetFormattedText("%s - %s\n%s %s %s %s", E.myname, E.myrealm, LEVEL, level, race, localizedClass)
		
		self.isAFK = true
	else
		self:CancelTimer(self.statsTimer)
		self:CancelTimer(self.logoffTimer)

		self.AFKMode.countd.text:SetFormattedText("%s: |cfff0ff00-30:00|r", L["Logout Timer"])
		self.isAFK = false
	end
end

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
	AFK.AFKMode.bottom.name:SetFormattedText("%s - %s\n%s %s %s %s", E.myname, E.myrealm, LEVEL, level, race, localizedClass)
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
end
hooksecurefunc(AFK, "Initialize", Initialize)