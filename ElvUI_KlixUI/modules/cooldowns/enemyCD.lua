local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local EC = KUI:NewModule('EnemyCooldown', "AceEvent-3.0", "AceConsole-3.0")

local enemy_spells = {
	-- Interrupts and Silences
	[57994] = 12,	-- Wind Shear
	[47528] = 15,	-- Mind Freeze
	[106839] = 15,	-- Skull Bash
	[116705] = 15,	-- Spear Hand Strike
	[96231] = 15,	-- Rebuke
	[1766] = 15,	-- Kick
	[6552] = 15,	-- Pummel
	[147362] = 24,	-- Counter Shot
	[2139] = 24,	-- Counterspell
	[19647] = 24,	-- Spell Lock
	[115781] = 24,	-- Optical Blast
	[15487] = 45,	-- Silence
	[47476] = 60,	-- Strangulate
	[78675] = 60,	-- Solar Beam
	-- Crowd Controls
	[115078] = 15,	-- Paralysis
	[20066] = 15,	-- Repentance
	[187650] = 30,	-- Freezing Trap
	[8122] = 30,	-- Psychic Scream
	[30283] = 30,	-- Shadowfury
	[107570] = 30,	-- Storm Bolt
	[51514] = 30,	-- Hex
	[5484] = 40,	-- Howl of Terror
	[108194] = 45,	-- Asphyxiate
	[19386] = 45,	-- Wyvern Sting
	[113724] = 45,	-- Ring of Frost
	[119381] = 45,	-- Leg Sweep
	[64044] = 45,	-- Psychic Horror
	[6789] = 45,	-- Mortal Coil
	[853] = 60,		-- Hammer of Justice
	-- Defense abilities
	[48707] = 60,	-- Anti-Magic Shell
	[31224] = 90,	-- Cloak of Shadows
	[46924] = 90,	-- Bladestorm
	[287081] = 60,	-- Lichborne
	[213664] = 120,	-- Nimble Brew
	[47585] = 120,	-- Dispersion
	[1856] = 120,	-- Vanish
	[7744] = 120,	-- Will of the Forsaken (Racial)
	[186265] = 180,	-- Aspect of the Turtle
	[33206] = 180,	-- Pain Suppression
}

local _, type = T.IsInInstance();
local icons = {}

local EnemyCDAnchor = T.CreateFrame("Frame", "EnemyCDAnchor", UIParent)

local OnEnter = function(self)
	if T.IsShiftKeyDown() then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetSpellByID(self.sID)
		GameTooltip:SetClampedToScreen(true)
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(DONE_BY.." "..self.name)
		GameTooltip:Show()
	end
end

local function sortByExpiration(a, b)
	return a.endTime < b.endTime
end

local UpdatePositions = function()
	for i = 1, #icons do
		icons[i]:ClearAllPoints()
		if i == 1 then
			icons[i]:SetPoint("BOTTOMLEFT", EnemyCDAnchor, "BOTTOMLEFT", 0, 0)
		elseif i < (E.db.actionbar.bar1.buttonsize * 12)/EC.db.size then
			if EC.db.direction == "UP" then
				icons[i]:SetPoint("BOTTOM", icons[i-1], "TOP", 0, 3)
			elseif EC.db.direction == "DOWN" then
				icons[i]:SetPoint("TOP", icons[i-1], "BOTTOM", 0, -3)
			elseif EC.db.direction == "RIGHT" then
				icons[i]:SetPoint("LEFT", icons[i-1], "RIGHT", 3, 0)
			elseif EC.db.direction == "LEFT" then
				icons[i]:SetPoint("RIGHT", icons[i-1], "LEFT", -3, 0)
			else
				icons[i]:SetPoint("LEFT", icons[i-1], "RIGHT", 3, 0)
			end

		end
		if i < (E.db.actionbar.bar1.buttonsize * 12)/EC.db.size then
			icons[i]:SetAlpha(1)
		else
			icons[i]:SetAlpha(0)
		end
		icons[i]:CreateIconShadow()
		icons[i].id = i
	end
end

local StopTimer = function(icon)
	icon:SetScript("OnUpdate", nil)
	icon:Hide()
	T.table_remove(icons, icon.id)
	UpdatePositions()
end

local IconUpdate = function(self, elapsed)
	if (self.endTime < T.GetTime()) then
		StopTimer(self)
	end
end

local CreateIcon = function()
	local icon = T.CreateFrame("Frame", nil, UIParent)
	icon:SetSize(EC.db.size, EC.db.size)
	icon:SetTemplate("Default")
	icon.Cooldown = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
	icon.Cooldown:SetPoint("TOPLEFT", 0, 0)
	icon.Cooldown:SetPoint("BOTTOMRIGHT", 0, 0)
	icon.Cooldown:SetReverse(true)
	icon.Texture = icon:CreateTexture(nil, "BORDER")
	icon.Texture:SetInside()
	return icon
end

local StartTimer = function(name, sID)
	local _, _, texture = T.GetSpellInfo(sID)
	local icon = CreateIcon()
	icon.Texture:SetTexture(texture)
	icon.Texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	icon.endTime = T.GetTime() + enemy_spells[sID]
	local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[T.select(2, T.UnitClass(name))]
	if color then
		name = T.string_format("|cff%02x%02x%02x%s|r", color.r * 255, color.g * 255, color.b * 255, name)
	end
	icon.name = name
	icon.sID = sID
	icon:Show()
	icon:SetScript("OnUpdate", IconUpdate)
	icon:SetScript("OnEnter", OnEnter)
	icon:SetScript("OnLeave", T.GameTooltip_Hide)
	T.CooldownFrame_Set(icon.Cooldown, T.GetTime(), enemy_spells[sID], 1)
	T.table_insert(icons, icon)
	T.table_sort(icons, sortByExpiration)
	UpdatePositions()
end

local OnEvent = function(self, event)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, eventType, _, _, sourceName, sourceFlags, _, _, _, _, _, spellID = T.CombatLogGetCurrentEventInfo()

		if eventType == "SPELL_CAST_SUCCESS" and T.bit_band(sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE then
			if sourceName ~= T.UnitName("player") then
				if enemy_spells[spellID] and ((EC.db.show_always and type == "none") or (EC.db.show_inpvpshow and type == "pvp") or (EC.db.show_inarena and type == "arena")) then
					StartTimer(sourceName, spellID)
				end
			end
		end
	elseif event == "ZONE_CHANGED_NEW_AREA" then
		for k, v in T.pairs(icons) do
			v.endTime = 0
		end
	end
end

function EC:Initialize()
	if not E.db.KlixUI.cooldowns.enemy.enable then return end
	
	EC.db = E.db.KlixUI.cooldowns.enemy
	
	local addon = T.CreateFrame("Frame")
	addon:SetScript("OnEvent", OnEvent)
	addon:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	addon:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	
	for spell in T.pairs(enemy_spells) do
		local name = T.GetSpellInfo(spell)
		if not name then
			T.print("|cffff0000WARNING: spell ID ["..T.tostring(spell).."] no longer exists! Report this to Shestak.|r")
		end
	end
	
	EnemyCDAnchor:SetPoint("BOTTOM", UIParent, "BOTTOM", 221, 341)
	
	if EC.db.direction == "UP" or EC.db.direction == "DOWN" then
		EnemyCDAnchor:SetSize(EC.db.size, (EC.db.size * 5) + 12)
	else
		EnemyCDAnchor:SetSize((EC.db.size * 5) + 12, EC.db.size)
	end
	
	E:CreateMover(EnemyCDAnchor, "KUI_EnemyCDMover", L["Enemy Cooldown"], nil, nil, nil, 'ALL,GENERAL,PARTY,ARENA,KLIXUI', nil, "KlixUI,modules,cooldowns,enemy")
	
	_G.SLASH_EnemyCD1 = "/testecd"
	_G.SLASH_EnemyCD2 = "/tecd"
	T.SlashCmdList.EnemyCD = function()
		StartTimer(T.UnitName("player"), 47528)
		StartTimer(T.UnitName("player"), 19647)
		StartTimer(T.UnitName("player"), 47476)
		StartTimer(T.UnitName("player"), 51514)
	end
end


local function InitializeCallback()
	EC:Initialize()
end

KUI:RegisterModule(EC:GetName(), InitializeCallback)