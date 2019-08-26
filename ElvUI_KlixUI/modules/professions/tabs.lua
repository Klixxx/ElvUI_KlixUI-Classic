local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local TTabs = KUI:NewModule("TradeTabs", "AceEvent-3.0")

local whitelist = {
    [171] = true, -- Alchemy
    [164] = true, -- Blacksmithing
    [185] = true, -- Cooking
    [333] = true, -- Enchanting
    [129] = true, -- First Aid
    [182] = true, -- Herbalism
    [773] = true, -- Inscription
    [755] = true, -- Jewelcrafting
    [165] = true, -- Leatherworking
    [186] = true, -- Mining
    [197] = true, -- Tailoring
    [202] = true, -- Engineering
    [393] = true, -- Skinning
}

local onlyPrimary = {
    [171] = true, -- Alchemy
    [182] = true, -- Herbalism
}

local RUNEFORGING = 53428 -- Runeforging spellid

local function buildSpellList()
    local p1, p2, arch, fishing, cooking, firstaid = T.GetProfessions()
    local profs = {p1, p2, cooking, firstaid}

    local tradeSpells = {}
    local extras = 0

    for _, prof in T.pairs(profs) do
        local name, icon, _, _, abilities, offset, skillLine = T.GetProfessionInfo(prof)
        if whitelist[skillLine] then

            if onlyPrimary[skillLine] then
                abilities = 1
            end

            for i = 1, abilities do
                if not T.IsPassiveSpell(i + offset, BOOKTYPE_PROFESSION) then
                    -- if more than one ability per profession, stick anything after the first
                    -- at the end of the list, and keep track of how many are back there to insert
                    -- other 'primary' skills before them
                    if i > 1 then
                        T.table_insert(tradeSpells, i + offset)
                        extras = extras + 1
                    else
                        T.table_insert(tradeSpells, #tradeSpells + 1 - extras, i + offset)
                    end
                end
            end
        end
    end

    return tradeSpells
end

local function onEnter(self)
    _G.GameTooltip:SetOwner(self, "ANCHOR_RIGHT") _G.GameTooltip:SetText(self.tooltip)
    self:GetParent():LockHighlight()
end

local function onLeave(self)
    _G.GameTooltip:Hide()
    self:GetParent():UnlockHighlight()
end

local function updateSelection(self)
    if T.IsCurrentSpell(self.spell) then
        self:SetChecked(true)
        self.clickStopper:Show()
    else
        self:SetChecked(false)
        self.clickStopper:Hide()
    end
end

local function createClickStopper(button)
    local f = T.CreateFrame("Frame",nil,button)
    f:SetAllPoints(button)
    f:EnableMouse(true)
    f:SetScript("OnEnter",onEnter)
    f:SetScript("OnLeave",onLeave)
    button.clickStopper = f
    f.tooltip = button.tooltip
    f:Hide()
end

function TTabs:CreateTab(i, parent, spellID)
    local spell, _, texture = T.GetSpellInfo(spellID)
    local button = T.CreateFrame("CheckButton","TradeTabsTab"..i, parent, "SpellBookSkillLineTabTemplate,SecureActionButtonTemplate")
    button.tooltip = spell
    button.spellID = spellID
    button.spell = spell

    button:Show()
    button:SetAttribute("type", "spell")
    button:SetAttribute("spell", spell)

    button:SetNormalTexture(texture)

    button:SetScript("OnEvent", updateSelection)
    button:RegisterEvent("TRADE_SKILL_SHOW")
    button:RegisterEvent("TRADE_SKILL_CLOSE")
    button:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")

    createClickStopper(button)
    updateSelection(button)

    button:GetRegions():Kill()
    button.pushed = true
	button:CreateBackdrop("Default")
    button:StyleButton(true)
	button:CreateIconShadow()
	if E.db.KlixUI.general.iconShadow and not T.IsAddOnLoaded("Masque") then
		button.ishadow:SetInside(button, 0, 0)
	end
    T.select(4, button:GetRegions()):SetTexCoord(.08, .92, .08, .92)
    return button
end

function TTabs:Initialize()
    if not E.db.KlixUI.professions.tabs or not T.IsAddOnLoaded("Blizzard_TradeSkillUI") then return end

    local parent = _G.TradeSkillFrame

    local tradeSpells = buildSpellList()
    local i = 1
    local prev

    -- if player is a DK, insert runeforging at the top
    if T.select(2, T.UnitClass("player")) == "DEATHKNIGHT" then
        prev = self:CreateTab(i, parent, RUNEFORGING)
        prev:SetPoint("TOPLEFT", parent, "TOPRIGHT", 10, -44)
        i = i + 1
    end

    for i, slot in T.ipairs(tradeSpells) do
        local _, spellID = T.GetSpellBookItemInfo(slot, BOOKTYPE_PROFESSION)
        local tab = self:CreateTab(i, parent, spellID)
        i = i + 1

        local point, relPoint, x, y = "TOPLEFT", "BOTTOMLEFT", 0, -17
        if not prev then
            prev, relPoint, x, y = parent, "TOPRIGHT", E.Border + 1, -44
        end
        tab:SetPoint(point, prev, relPoint, x, y)

        prev = tab
    end
end

KUI:RegisterModule(TTabs:GetName())