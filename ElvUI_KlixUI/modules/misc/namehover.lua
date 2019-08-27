local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local MI = KUI:GetModule("KuiMisc")
local LSM = E.LSM or E.Libs.LSM

local UIParent = UIParent
local UNKNOWN = UNKNOWN

local function Getcolor()
	local reaction = T.UnitReaction("mouseover", "player") or 5

	if T.UnitIsPlayer("mouseover") then
		local _, class = T.UnitClass("mouseover")
		local color = (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class]) or (RAID_CLASS_COLORS and RAID_CLASS_COLORS[class])
		return color.r, color.g, color.b
	elseif T.UnitCanAttack("player", "mouseover") then
		if T.UnitIsDead("mouseover") then
			return 136/255, 136/255, 136/255
		else
			if reaction < 4 then
				return 1, 68/255, 68/255
			elseif reaction == 4 then
				return 1, 1, 68/255
			end
		end
	else
		if reaction < 4 then
			return 48/255, 113/255, 191/255
		else
			return 1, 1, 1
		end
	end
end

function MI:LoadnameHover()
	if not E.db.KlixUI.nameHover.enable then return end

	local db = E.db.KlixUI.nameHover
	local tooltip = T.CreateFrame("frame", nil)
	tooltip:SetFrameStrata("TOOLTIP")
	tooltip.text = tooltip:CreateFontString(nil, "OVERLAY")
	tooltip.text:FontTemplate(LSM:Fetch('font', db.font) or "Expressway", db.fontSize or 7, db.fontOutline or "OUTLINE")

	-- Show unit name at mouse
	tooltip:SetScript("OnUpdate", function(tt)
		if T.GetMouseFocus() and T.GetMouseFocus():IsForbidden() then tt:Hide() return end
		if T.GetMouseFocus() and T.GetMouseFocus():GetName() ~= "WorldFrame" then tt:Hide() return end
		if not T.UnitExists("mouseover") then tt:Hide() return end

		local x, y = T.GetCursorPosition()
		local scale = UIParent:GetEffectiveScale()
		tt.text:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y+15)
	end)

	tooltip:SetScript("OnEvent", function(tt)
		if T.GetMouseFocus():GetName() ~= "WorldFrame" then return end
		
		local localeClass, class = T.UnitClass("mouseover")
		local name = T.UnitName("mouseover") or UNKNOWN
		local guildName, guildRankName, _, guildRealm = T.GetGuildInfo("mouseover")
		local pvpName = T.UnitPVPName("mouseover")
		local relationship = T.UnitRealmRelationship("mouseover");
		local level = T.UnitLevel("mouseover")
		local race, englishRace = T.UnitRace("mouseover")
		local _, factionGroup = T.UnitFactionGroup("mouseover")
		if(factionGroup and englishRace == "Pandaren") then
			race = factionGroup.." "..race
		end
		local genders = {"", L["Male"], L["Female"]};
		local gender = genders[T.UnitSex("mouseover")];
		local AFK = T.UnitIsAFK("mouseover")
		local DND = T.UnitIsDND("mouseover")
		local prefix = ""
		local infix = ""

		if (pvpName and db.titles) then
			name = pvpName
		end
		
		if (race) then
			if (db.race and T.IsShiftKeyDown()) then
				infix = level.." "..gender.." "..race.." "..localeClass
			else
				infix = level.." "..race.." "..localeClass
			end
		else
			infix = ""
		end
		
		if (guildName) then
			if (guildName and db.guild) then
				suffix = "|cfff960d9["..guildName.."]|r"
			else
				suffix = ""
			end
		
			if db.guildRank and db.guild then
				suffix = "|cfff960d9["..guildName.."]|r\n|cffffffff<"..guildRankName..">|r"
			elseif db.guild then
				suffix = "|cfff960d9["..guildName.."]|r"
			else
				suffix = ""
			end
		else
			suffix = ""
		end
		
		if AFK then prefix = "|cffff0000<AFK>|r " end
		if DND then prefix = "|cffffce00<DND>|r " end

		tt.text:SetTextColor(Getcolor())
		if db.guild and db.race then
			tt.text:SetText(prefix..name.."\n"..infix.."\n"..suffix)
		elseif db.guild then
			tt.text:SetText(prefix..name.."\n"..suffix)
		elseif db.race then
			tt.text:SetText(prefix..name.."\n"..infix)
		else
			tt.text:SetText(prefix..name)
		end

		tt:Show()
	end)

	tooltip:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
end