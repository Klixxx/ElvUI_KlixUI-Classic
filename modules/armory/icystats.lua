local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KA = KUI:GetModule('KuiArmory')
local S = E:GetModule('Skins')
local LSM = E.LSM or E.Libs.LSM

-- Stats updated on Ice-Veins.com as of 09th of Februrary.
local StatTable = {
	["DEATHKNIGHT-250"] = L["Ilvl > Versatility > Haste > Critical Strike > Mastery"],
	["DEATHKNIGHT-251"] = L["Strength > Mastery > Critical Strike > Versatility > Haste"],
	["DEATHKNIGHT-252"] = L["Strength > Haste > Critical Strike = Versatility > Mastery"],

	["DRUID-102"] = L["Intellect > Haste > Mastery > Critical Strike > Versatility"],
	["DRUID-103"] = L["Critical Strike > Mastery > Haste > Agility > Versatility"],
	["DRUID-104"] = L["Survival: Armor = Agility = Stam > Mastery > Versatility > Haste > Critical Strike \n Damage: Agility > Haste > Critical Strike > Versatility > Mastery"],
	["DRUID-105"] = L["Raid: Intellect > Haste = Critical Strike = Versatility > Mastery \n Dungeon: Mastery = Haste > Intellect > Versatility > Critical Strike"],

	["HUNTER-253"] = L["Solo: Agility > Critical Strike > Haste > Mastery > Versatility \n Multi: Agility > Mastery > Haste > Critical Strike > Versatility"],
	["HUNTER-254"] = L["Solo: Agility > Mastery > Haste> Critical Strike > Versatility \n Multi: Agility > Mastery > Critical Strike > Versatility > Haste"],
	["HUNTER-255"] = L["Solo: Agility > Haste > Critical Strike > Versatility > Mastery \n Multi: Agility > Haste > Critical Strike > Versatility > Mastery"],

	["MAGE-62"] = L["Intellect > Critical Strike > Haste > Mastery > Versatility"],
	["MAGE-63"] = L["Intellect > Mastery > Versatility > Haste > Critical Strike"],
	["MAGE-64"] = L["Intellect > Critical Strike 33% > Haste > Versatility > Mastery > Critical Strike 33+"],

	["MONK-268"] = L["Agility > Critical Strike = Versatility = Mastery > Haste"],
	["MONK-269"] = L["Weapon Damage > Agility > Versatility > Mastery > Critical Strike > Haste"],
	["MONK-270"] = L["Raid: Intellect > Critical Strike > Mastery = Versatility > Haste \n Dungeon: Intellect > Mastery = Haste > Versatility > Critical Strike"],

	["PALADIN-65"] = L["Standard: Intellect > Critical Strike > Mastery > Haste > Versatility \n Avenging Crusader: Intellect > Critical Strike > Haste > Versatility > Mastery \n Awakening: Intellect > Haste > Critical Strike > Versatility > Mastery"],
	["PALADIN-66"] = L["Strength > Haste > Mastery > Versatility > Critical Strike"],
	["PALADIN-70"] = L["Strength > Haste > Critical Strike = Versatility = Mastery"],

	["PRIEST-256"] = L["Intellect > Haste > Critical Strike > Mastery > Versatility"],
	["PRIEST-257"] = L["Raid: (Leech = Avoid) > Intellect > Mastery = Critical Strike > Versatility > Haste \n Dungeon: (Leech = Avoid) > Intellect > Critical Strike > Haste > Versatility > Mastery"],
	["PRIEST-258"] = L["Haste = Critical Strike > Intellect > Mastery > Versatility"],

	["ROGUE-259"] = L["Agility > Haste > Critical Strike > Mastery > Versatility"],
	["ROGUE-260"] = L["Agility > Haste > Versatility > Critical Strike > Mastery"],
	["ROGUE-261"] = L["Solo: Agility > Versatility > Critical Strike > Mastery > Haste \n Multi: Agility > Mastery > Critical Strike > Versatility > Haste"],

	["SHAMAN-262"] = L["Intellect > Critical Strike > Haste > Versatility > Mastery"],
	["SHAMAN-263"] = L["Standard: Haste > Critical Strike = Versatility > Mastery > Agility \n Primal: Mastery > Haste > Critical Strike = Versatility > Agility \n Strength Earth: Haste > Critical Strike > Mastery > Versatility > Agility"],
	["SHAMAN-264"] = L["(Leech = Avoidance) > Intellect > Critical Strike > Versatility > Haste = Mastery"], 

	["WARLOCK-265"] = L["Mastery > Intellect > Haste > Critical Strike = Versatility"],
	["WARLOCK-266"] = L["Standard: Intellect > Haste > Critical Strike > Versatility > Mastery \n Explosive Potential: Critical Strike = Mastery > Intellect > Versatility > Haste"],
	["WARLOCK-267"] = L["Intellect > Haste > Critical Strike = Mastery > Versatility"],

	["WARRIOR-71"] = L["Haste > Critical Strike > Mastery > Versatility > Strength"],
	["WARRIOR-72"] = L["Critical Strike > Mastery > Haste > Versatility > Strength"],
	["WARRIOR-73"] = L["Haste > Armor > Versatility > Mastery > Critical Strike > Strength"],

	["DEMONHUNTER-577"] = L["Agility > Versatility > Critical Strike = Haste > Mastery"],
	["DEMONHUNTER-581"] = L["Agility > Haste > Versatility > Mastery > Critical Strike"],
}

function KA:CreateIcyStatFrame()
    if _G["PaperDollFrame"]:IsVisible() then
        if not IcyVeinStatFrame then
            local IcyVeinStatFrame = T.CreateFrame("Frame", "IcyVeinStatFrame", E.UIParent)
            IcyVeinStatFrame:SetTemplate("Transparent")
            IcyVeinStatFrame:SetFrameStrata("TOOLTIP")
            IcyVeinStatFrame:SetWidth(_G["PaperDollFrame"]:GetWidth()) 
			IcyVeinStatFrame:Styling()
			
    	    IcyVeinStatFrame.Text = IcyVeinStatFrame:CreateFontString(nil, "OVERLAY")
			IcyVeinStatFrame.Text:FontTemplate(LSM:Fetch('font', E.db.KlixUI.armory.stats.statFonts.font), E.db.KlixUI.armory.stats.statFonts.size, E.db.KlixUI.armory.stats.statFonts.outline)
			IcyVeinStatFrame.Text:SetTextColor(KUI.r, KUI.g, KUI.b)
			IcyVeinStatFrame.Text:ClearAllPoints()
			IcyVeinStatFrame.Text:SetAllPoints(IcyVeinStatFrame)
			IcyVeinStatFrame.Text:SetJustifyH("CENTER")
			IcyVeinStatFrame.Text:SetJustifyV("CENTER")

			local Close = T.CreateFrame("Button", "ISCloseButton", IcyVeinStatFrame)
			Close:SetPoint("TOPRIGHT", 0, 0)
			Close:SetSize(16 + ((E.PixelMode and 4) or 8), 16 + ((E.PixelMode and 4) or 8))
			S:HandleCloseButton(Close)
			Close:SetScript('OnClick', function(self) IcyVeinStatFrame:Hide(); KUI:Print(L["If you want to retoggle the stats panel, please do a reload or relog."]) end)
        end
        return true
    end
    return false
end

function KA:UpdateIcyStatFrame()
    if KA:CreateIcyStatFrame() then
        local _, className = T.UnitClass("player")
        local sId, specName = T.GetSpecializationInfo(T.GetSpecialization())
        local s = StatTable[className .. "-" .. sId]
        if E.db.KlixUI.armory.statsPanel.customStats ~= "" then
			IcyVeinStatFrame.Text:SetText(E.db.KlixUI.armory.statsPanel.customStats)
		else
            s = T.string_gsub(s, "Strength", "Strength")
            s = T.string_gsub(s, "Agility", "Agility")
            s = T.string_gsub(s, "Intelligence", "Intellect")
            s = T.string_gsub(s, "Stamina", "Stamina")
            IcyVeinStatFrame.Text:SetText(s) 
        end               
    end
end

function KA:UpdatePanel()
	KA:UpdateIcyStatFrame(E.db.KlixUI.armory.statsPanel.customStats)
	IcyVeinStatFrame:SetHeight(E.db.KlixUI.armory.statsPanel.height)
	
	if E.db.KlixUI.armory.statsPanel.position == "TOP" then
		IcyVeinStatFrame:ClearAllPoints()
		IcyVeinStatFrame:SetPoint("BOTTOMRIGHT", _G["PaperDollFrame"], "TOPRIGHT", 0, 1)
        IcyVeinStatFrame:SetParent(_G["PaperDollFrame"])
        IcyVeinStatFrame:Show()
	else
		IcyVeinStatFrame:ClearAllPoints()
		IcyVeinStatFrame:SetPoint("TOPRIGHT", _G["PaperDollFrame"], "BOTTOMRIGHT", 0, -1)
		IcyVeinStatFrame:SetParent(_G["PaperDollFrame"])
        IcyVeinStatFrame:Show()
	end
end

function KA:SPELLS_CHANGED()
	KA:UpdateIcyStatFrame(E.db.KlixUI.armory.statsPanel.customStats)
end