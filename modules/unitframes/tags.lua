local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local ElvUF = ElvUI.oUF
T.assert(ElvUF, "ElvUI was unable to locate oUF.")


--All credits belongs to Merathilis, Blazeflack and Rehok for this mod

-- Cache global variables
local abs = math.abs
local format, match, sub, gsub, len = string.format, string.match, string.sub, string.gsub, string.len
local assert, tonumber, type = assert, tonumber, type
-- WoW API / Variables
local UnitIsDead = UnitIsDead
local UnitClass = UnitClass
local UnitIsGhost = UnitIsGhost
local UnitIsConnected = UnitIsConnected
local UnitHealth, UnitHealthMax = UnitHealth, UnitHealthMax
local UnitName = UnitName
local UnitFactionGroup = UnitFactionGroup
local UnitPower = UnitPower
local IsResting = IsResting

-- GLOBALS: Hex, _COLORS

local textFormatStyles = {
	["CURRENT"] = "%.1f",
	["CURRENT_MAX"] = "%.1f - %.1f",
	["CURRENT_PERCENT"] =  "%.1f - %.1f%%",
	["CURRENT_MAX_PERCENT"] = "%.1f - %.1f | %.1f%%",
	["PERCENT"] = "%.1f%%",
	["DEFICIT"] = "-%.1f"
}

local textFormatStylesNoDecimal = {
	["CURRENT"] = "%s",
	["CURRENT_MAX"] = "%s - %s",
	["CURRENT_PERCENT"] =  "%s - %.0f%%",
	["CURRENT_MAX_PERCENT"] = "%s - %s | %.0f%%",
	["PERCENT"] = "%.0f%%",
	["DEFICIT"] = "-%s"
}

local shortenNumber = function(number)
    if T.type(number) ~= "number" then
        number = T.tonumber(number)
    end
    if not number then
        return
    end

    local affixes = {
        "",
        "k",
        "m",
        "b",
    }

    local affix = 1
    local dec = 0
    local num1 = T.math_abs(number)
    while num1 >= 1000 and affix < #affixes do
        num1 = num1 / 1000
        affix = affix + 1
    end
    if affix > 1 then
        dec = 2
        local num2 = num1
        while num2 >= 10 do
            num2 = num2 / 10
            dec = dec - 1
        end
    end
    if number < 0 then
        num1 = -num1
    end

    return T.string_format("%."..dec.."f"..affixes[affix], num1)
end

-- Displays CurrentHP --(2.04b)--
_G["ElvUF"].Tags.Events['health:current-kui'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED'
_G["ElvUF"].Tags.Methods['health:current-kui'] = function(unit)
	local status = T.UnitIsDead(unit) and L["RIP"] or T.UnitIsGhost(unit) and L["Ghost"] or not T.UnitIsConnected(unit) and L["Offline"]
	
	if (status) then
		return status
	else
		local CurrentHealth = T.UnitHealth(unit)
		return shortenNumber(CurrentHealth)
	end
end

-- Displays Percent --(100%)--
_G["ElvUF"].Tags.Events['health:percent-kui'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED'
_G["ElvUF"].Tags.Methods['health:percent-kui'] = function(unit)
	local status = T.UnitIsDead(unit) and L["RIP"] or T.UnitIsGhost(unit) and L["Ghost"] or not T.UnitIsConnected(unit) and L["Offline"]
	
	if (status) then
		return status
	else
		local CurrentPercent = (T.UnitHealth(unit)/T.UnitHealthMax(unit))*100
		if CurrentPercent > 99.9 then
			return T.string_format("%.0f%%", CurrentPercent)
		else
			return T.string_format("%.1f%%", CurrentPercent)
		end
	end
end

-- Displays CurrentHP | Percent --(2.04b | 100)--
_G["ElvUF"].Tags.Events['health:current-percent-kui'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED'
_G["ElvUF"].Tags.Methods['health:current-percent-kui'] = function(unit)
	local status = T.UnitIsDead(unit) and L["RIP"] or T.UnitIsGhost(unit) and L["Ghost"] or not T.UnitIsConnected(unit) and L["Offline"]
	
	if (status) then
		return status
	else
		local CurrentHealth = T.UnitHealth(unit)
		local CurrentPercent = (T.UnitHealth(unit)/T.UnitHealthMax(unit))*100
		if CurrentPercent > 99.9 then
			return shortenNumber(CurrentHealth) .. " | " .. T.string_format("%.0f%%", CurrentPercent)
		else
			return shortenNumber(CurrentHealth) .. " | " .. T.string_format("%.1f%%", CurrentPercent)
		end
	end
end

-- Displays CurrentHP | Percent --(2.04b | 100)--
_G["ElvUF"].Tags.Events['health:current-percent1-kui'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED'
_G["ElvUF"].Tags.Methods['health:current-percent1-kui'] = function(unit)
	local status = T.UnitIsDead(unit) and L["RIP"] or T.UnitIsGhost(unit) and L["Ghost"] or not T.UnitIsConnected(unit) and L["Offline"]
	
	if (status) then
		return status
	else
		local CurrentHealth = T.UnitHealth(unit)
		local CurrentPercent = (T.UnitHealth(unit)/T.UnitHealthMax(unit))*100
		if CurrentPercent > 99.9 then
			return T.string_format("%.0f%%", CurrentPercent) .. " | " .. shortenNumber(CurrentHealth)
		else
			return T.string_format("%.1f%%", CurrentPercent) .. " | " .. shortenNumber(CurrentHealth)
		end
	end
end

-- Displays current deficit
_G["ElvUF"].Tags.Events['health:deficit-kui'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED'
_G["ElvUF"].Tags.Methods['health:deficit-kui'] = function(unit)
	local status = T.UnitIsDead(unit) and L["RIP"] or T.UnitIsGhost(unit) and L["Ghost"] or not T.UnitIsConnected(unit) and L["Offline"]

	if (status) then
		return status
	else
		return E:GetFormattedText('DEFICIT', T.UnitHealth(unit), T.UnitHealthMax(unit))
	end
end

-- Displays current power and 0 when no power instead of hiding when at 0, Also formats it like HP tag
_G["ElvUF"].Tags.Events['power:current-kui'] = 'UNIT_DISPLAYPOWER UNIT_POWER_UPDATE UNIT_POWER_FREQUENT'
_G["ElvUF"].Tags.Methods['power:current-kui'] = function(unit)
	local CurrentPower = T.UnitPower(unit)
	return shortenNumber(CurrentPower)
end

 -- Displays Power Percent without any decimals
_G["ElvUF"].Tags.Events['power:percent-kui'] = 'UNIT_DISPLAYPOWER UNIT_POWER_UPDATE UNIT_POWER_FREQUENT'
_G["ElvUF"].Tags.Methods['power:percent-kui'] = function(unit)
	local CurrentPercent = (T.UnitPower(unit)/T.UnitPowerMax(unit))*100
	local min = T.UnitPower(unit, SPELL_POWER_MANA)
	
	if min == 0 then
		return nil
	else
		if CurrentPercent > 99.9 then
			return T.string_format("%.0f%%", CurrentPercent)
		else
			return T.string_format("%.0f%%", CurrentPercent)
		end
	end
end