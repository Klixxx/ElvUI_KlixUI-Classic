local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local RC = KUI:NewModule('RaidCooldown', "AceEvent-3.0", "AceConsole-3.0")
local LSM = E.LSM or E.Libs.LSM

local raid_spells = {
	-- Battle resurrection
	[20484] = 600,	-- Rebirth
	[61999] = 600,	-- Raise Ally
	[20707] = 600,	-- Soulstone
	-- Heroism
	[32182] = 300,	-- Heroism
	[2825] = 300,	-- Bloodlust
	[80353] = 300,	-- Time Warp
	[264667] = 300,	-- Primal Rage [Hunter's pet]
	-- Healing
	[633] = 600,	-- Lay on Hands
	[740] = 180,	-- Tranquility
	[115310] = 180,	-- Revival
	[64843] = 180,	-- Divine Hymn
	[108280] = 180,	-- Healing Tide Totem
	[15286] = 180,	-- Vampiric Embrace
	[108281] = 120,	-- Ancestral Guidance
	-- Defense
	[62618] = 180,	-- Power Word: Barrier
	[33206] = 180,	-- Pain Suppression
	[47788] = 180,	-- Guardian Spirit
	[31821] = 180,	-- Aura Mastery
	[98008] = 180,	-- Spirit Link Totem
	[97462] = 180,	-- Rallying Cry
	[88611] = 180,	-- Smoke Bomb
	[51052] = 120,	-- Anti-Magic Zone
	[116849] = 120,	-- Life Cocoon
	[6940] = 120,	-- Blessing of Sacrifice
	[114030] = 120,	-- Vigilance
	[102342] = 60,	-- Ironbark
	-- Other
	[106898] = 120,	-- Stampeding Roar
}

local _, type = T.IsInInstance();

local filter = COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_MINE
local currentNumResses = 0
local charges = nil
local inBossCombat = nil
local timer = 0
local Ressesbars = {}
local bars = {}

local RaidCDAnchor = T.CreateFrame("Frame", "RaidCDAnchor", E.UIParent)

local FormatTime = function(T.time)
	if T.time >= 60 then
		return T.string_format("%.2d:%.2d", T.math_floor(T.time / 60), T.time % 60)
	else
		return T.string_format("%.2d", T.time)
	end
end

local function sortByExpiration(a, b)
	return a.endTime > b.endTime
end

local CreateFS = function(frame, fsize, fstyle)
	local fstring = frame:CreateFontString(nil, "OVERLAY")
	fstring:FontTemplate(LSM:Fetch("font", RC.db.text.font) or E["media"].normFont, RC.db.text.fontSize or 12, RC.db.text.fontOutline or "OUTLINE")
	fstring:SetShadowOffset(RC.db.text.shadow and 1 or 0, RC.db.text.shadow and -1 or 0)
	return fstring
end

local UpdatePositions = function()
	if charges and Ressesbars[1] then
		Ressesbars[1]:SetPoint("TOPRIGHT", RaidCDAnchor, "TOPRIGHT", 0, 0)
		Ressesbars[1].id = 1
		for i = 1, #bars do
			bars[i]:ClearAllPoints()
			if i == 1 then
				if RC.db.upwards == true then
					bars[i]:SetPoint("BOTTOMRIGHT", Ressesbars[1], "TOPRIGHT", 0, 13)
				else
					bars[i]:SetPoint("TOPRIGHT", Ressesbars[1], "BOTTOMRIGHT", 0, -13)
				end
			else
				if RC.db.upwards == true then
					bars[i]:SetPoint("BOTTOMRIGHT", bars[i-1], "TOPRIGHT", 0, 13)
				else
					bars[i]:SetPoint("TOPRIGHT", bars[i-1], "BOTTOMRIGHT", 0, -13)
				end
			end
			bars[i].id = i
		end
	else
		for i = 1, #bars do
			bars[i]:ClearAllPoints()
			if i == 1 then
				bars[i]:SetPoint("TOPRIGHT", RaidCDAnchor, "TOPRIGHT", 0, 0)
			else
				if RC.db.upwards == true then
					bars[i]:SetPoint("BOTTOMRIGHT", bars[i-1], "TOPRIGHT", 0, 13)
				else
					bars[i]:SetPoint("TOPRIGHT", bars[i-1], "BOTTOMRIGHT", 0, -13)
				end
			end
			bars[i].id = i
		end
	end
end

local StopTimer = function(bar)
	bar:SetScript("OnUpdate", nil)
	bar:Hide()
	if bar.isResses then
		T.table_remove(Ressesbars, bar.id)
	else
		T.table_remove(bars, bar.id)
	end
	UpdatePositions()
end

local UpdateCharges = function(bar)
	local curCharges, maxCharges, start, duration = T.GetSpellCharges(20484)
	if curCharges == maxCharges then
		bar.startTime = 0
		bar.endTime = T.GetTime()
	else
		bar.startTime = start
		bar.endTime = start + duration
	end
	if curCharges ~= currentNumResses then
		currentNumResses = curCharges
		bar.left:SetText(bar.name.." : "..currentNumResses)
	end
end

local BarUpdate = function(self, elapsed)
	local curTime = T.GetTime()
	if self.endTime < curTime then
		if self.isResses then
			UpdateCharges(self)
		else
			StopTimer(self)
			return
		end
	end
	self:SetValue(100 - (curTime - self.startTime) / (self.endTime - self.startTime) * 100)
	self.right:SetText(FormatTime(self.endTime - curTime))
end

local OnEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetSpellByID(self.spellId)
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine(self.left:GetText(), self.right:GetText())
	GameTooltip:SetClampedToScreen(true)
	GameTooltip:Show()
end

local OnLeave = function(self)
	GameTooltip:Hide()
end

local OnMouseDown = function(self, button)
	if button == "LeftButton" then
		if self.isResses then
			T.SendChatMessage(T.string_format(L["Battle Resurrection: "].."%d, "..L["Next time: "].."%s.", currentNumResses, self.right:GetText()), KUI.CheckChat())
		else
			T.SendChatMessage(T.string_format(L["CD: "].."%s - %s: %s", self.name, T.GetSpellLink(self.spellId), self.right:GetText()), KUI.CheckChat())
		end
	elseif button == "RightButton" then
		StopTimer(self)
	end
end

local CreateBar = function()
	local bar = T.CreateFrame("Statusbar", nil, E.UIParent)
	bar:SetFrameStrata("MEDIUM")
	if RC.db.show_icon == true then
		bar:SetSize(RC.db.width, RC.db.height)
	else
		bar:SetSize(RC.db.width + 28, RC.db.height)
	end
	bar:SetStatusBarTexture(E["media"].normTex)
	bar:SetMinMaxValues(0, 100)
	bar:CreateBackdrop("Default")

	bar.bg = bar:CreateTexture(nil, "BACKGROUND")
	bar.bg:SetAllPoints(bar)
	bar.bg:SetTexture(E["media"].normTex)

	bar.left = CreateFS(bar)
	bar.left:SetPoint("LEFT", 2, 0)
	bar.left:SetJustifyH("LEFT")
	bar.left:SetSize(RC.db.width - 30, RC.db.text.fontSize)

	bar.right = CreateFS(bar)
	bar.right:SetPoint("RIGHT", 1, 0)
	bar.right:SetJustifyH("RIGHT")

	if RC.db.show_icon == true then
		bar.icon = T.CreateFrame("Button", nil, bar)
		bar.icon:SetWidth(bar:GetHeight() + 6)
		bar.icon:SetHeight(bar.icon:GetWidth())
		bar.icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -7, 0)
		bar.icon:CreateBackdrop("Default")
	end
	return bar
end

local StartTimer = function(name, spellId)
	local spell, _, icon = T.GetSpellInfo(spellId)
	if charges and spellId == 20484 then
		for _, v in T.pairs(Ressesbars) do
			UpdateCharges(v)
			return
		end
	end
	for _, v in T.pairs(bars) do
		if v.name == name and v.spell == spell then
			StopTimer(v)
		end
	end
	local bar = CreateBar()
	local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[T.select(2, T.UnitClass(name))]
	if charges and spellId == 20484 then
		local curCharges, _, start, duration = T.GetSpellCharges(20484)
		currentNumResses = curCharges
		bar.startTime = start
		bar.endTime = start + duration
		bar.left:SetText(name.." : "..curCharges)
		bar.right:SetText(FormatTime(duration))
		bar.isResses = true
		bar.name = name
		bar.spell = spell
		bar.spellId = spellId
		if RC.db.show_icon == true then
			bar.icon:SetNormalTexture(icon)
			bar.icon:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
		end
		bar:Show()
		if color then
			bar:SetStatusBarColor(color.r, color.g, color.b)
			bar.bg:SetVertexColor(color.r, color.g, color.b, 0.2)
		else
			bar:SetStatusBarColor(0.3, 0.7, 0.3)
			bar.bg:SetVertexColor(0.3, 0.7, 0.3, 0.2)
		end

		bar:SetScript("OnUpdate", BarUpdate)
		bar:EnableMouse(true)
		bar:SetScript("OnEnter", OnEnter)
		bar:SetScript("OnLeave", OnLeave)
		bar:SetScript("OnMouseDown", OnMouseDown)
		T.table_insert(Ressesbars, bar)
		if RC.db.expiration == true then
			T.table_sort(Ressesbars, sortByExpiration)
		end
	else
		bar.startTime = T.GetTime()
		bar.endTime = T.GetTime() + raid_spells[spellId]
		bar.left:SetText(T.string_format("%s - %s", name:gsub("%-[^|]+", ""), spell))
		bar.right:SetText(FormatTime(raid_spells[spellId]))
		bar.isResses = false
		bar.name = name
		bar.spell = spell
		bar.spellId = spellId
		if RC.db.show_icon == true then
			bar.icon:SetNormalTexture(icon)
			bar.icon:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
		end
		bar:Show()
		if color then
			bar:SetStatusBarColor(color.r, color.g, color.b)
			bar.bg:SetVertexColor(color.r, color.g, color.b, 0.2)
		else
			bar:SetStatusBarColor(0.3, 0.7, 0.3)
			bar.bg:SetVertexColor(0.3, 0.7, 0.3, 0.2)
		end

		bar:SetScript("OnUpdate", BarUpdate)
		bar:EnableMouse(true)
		bar:SetScript("OnEnter", OnEnter)
		bar:SetScript("OnLeave", OnLeave)
		bar:SetScript("OnMouseDown", OnMouseDown)
		T.table_insert(bars, bar)
		if RC.db.expiration == true then
			T.table_sort(bars, sortByExpiration)
		end
	end
	UpdatePositions()
end

local f = T.CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
f:RegisterEvent("ENCOUNTER_END")
f:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA" then
		if T.select(2, T.IsInInstance()) == "raid" and T.IsInGroup() then
			self:RegisterEvent("SPELL_UPDATE_CHARGES")
		else
			self:UnregisterEvent("SPELL_UPDATE_CHARGES")
			charges = nil
			inBossCombat = nil
			currentNumResses = 0
			Ressesbars = {}
		end
	end
	if event == "SPELL_UPDATE_CHARGES" then
		charges = T.GetSpellCharges(20484)
		if charges then
			if not inBossCombat then
				inBossCombat = true
			end
			StartTimer(L["BattleRes"], 20484)
		elseif not charges and inBossCombat then
			inBossCombat = nil
			currentNumResses = 0
			for _, v in T.pairs(Ressesbars) do
				StopTimer(v)
			end
		end
	end
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, eventType, _, _, sourceName, sourceFlags = T.CombatLogGetCurrentEventInfo()
		if T.bit_band(sourceFlags, filter) == 0 then return end
		if eventType == "SPELL_RESURRECT" or eventType == "SPELL_CAST_SUCCESS" or eventType == "SPELL_AURA_APPLIED" then
			local spellId = T.select(12, T.CombatLogGetCurrentEventInfo())
			if sourceName then
				sourceName = sourceName:gsub("-.+", "")
			else
				return
			end
			if raid_spells[spellId] and IT.sInGroup() and ((RC.db.show_inraid and type == "raid") or (RC.db.show_inparty and type == "party") or (RC.db.show_inarena and type == "arena")) then
				if (sourceName == T.UnitName("player") and RC.db.show_self == true) or sourceName ~= T.UnitName("player") then
					StartTimer(sourceName, spellId)
				end
			end
		end
	elseif event == "ZONE_CHANGED_NEW_AREA" and T.select(2, T.IsInInstance()) == "arena" or not T.IsInGroup() then
		for _, v in T.pairs(Ressesbars) do
			StopTimer(v)
		end
		for _, v in T.pairs(bars) do
			v.endTime = 0
		end
	elseif event == "ENCOUNTER_END" and T.select(2, T.IsInInstance()) == "raid" then
		for _, v in T.pairs(bars) do
			v.endTime = 0
		end
	end
end)

function RC:Initialize()
	if not E.db.KlixUI.cooldowns.raid.enable then return end
	
	RC.db = E.db.KlixUI.cooldowns.raid
	
	for spell in T.pairs(raid_spells) do
		local name = T.GetSpellInfo(spell)
		if not name then
			KUI:Print("|cffff0000WARNING: spell ID ["..T.tostring(spell).."] no longer exists! Please report this in my Discord.|r")
		end
	end
	
	RaidCDAnchor:SetPoint("BOTTOM", E.UIParent, "BOTTOM", -267, 318)
	if RC.db.show_icon == true then
		RaidCDAnchor:SetSize(RC.db.width + 32, RC.db.height + 10)
	else
		RaidCDAnchor:SetSize(RC.db.width + 32, RC.db.height + 4)
	end
	E:CreateMover(RaidCDAnchor, "KUI_RaidCDMover", L["Raid Cooldown"], nil, nil, nil, 'ALL,RAID,PARTY,ARENA,KLIXUI', nil, "KlixUI,modules,cooldowns,raid")
	
	_G.SLASH_RaidCD1 = "/testrcd"
	_G.SLASH_RaidCD2 = "/trcd"
	T.SlashCmdList["RaidCD"] = function()
		StartTimer(T.UnitName("player"), 20484)	-- Rebirth
		StartTimer(T.UnitName("player"), 20707)	-- Soulstone
		StartTimer(T.UnitName("player"), 108280)	-- Healing Tide Totem
	end
end


local function InitializeCallback()
	RC:Initialize()
end

KUI:RegisterModule(RC:GetName(), InitializeCallback)