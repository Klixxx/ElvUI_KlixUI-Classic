local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KDB = KUI:GetModule("KuiDatabars")
local EDB = E:GetModule("DataBars")

local function UpdateExperience(self)
    local bar = self.expBar
    local status = bar.statusBar
    local rested = bar.rested
    local xpColor = E.db.KlixUI.databars.experienceBar.xpColor
    local restColor = E.db.KlixUI.databars.experienceBar.restColor
    local isMaxLevel = T.UnitLevel("player") == MAX_PLAYER_LEVEL_TABLE[T.GetExpansionLevel()]

    if isMaxLevel then
        status:SetMinMaxValues(0, 1)
        rested:SetMinMaxValues(0, 0)
        status:SetValue(1)
        rested:SetValue(0)
        status:SetAlpha(1)
        rested:SetAlpha(0)

        if E.db.KlixUI.databars.experienceBar.capped then
            bar.text:SetText(L["Capped"])
        end
    end

    status:SetStatusBarColor(xpColor.r, xpColor.g, xpColor.b, xpColor.a)
    rested:SetStatusBarColor(restColor.r, restColor.g, restColor.b, restColor.a)

    if E.db.KlixUI.databars.experienceBar.progress and not isMaxLevel then
        local avg = T.UnitXP("player")/T.UnitXPMax("player")
        avg = KDB:Round(avg, 2)
        bar.statusBar:SetAlpha(avg)
    elseif not E.db.KlixUI.databars.experienceBar.progress or isMaxLevel then
        bar.statusBar:SetAlpha(0.8)
    end
end

local function ExperienceBar_OnEnter()
    local isMaxLevel = T.UnitLevel("player") == MAX_PLAYER_LEVEL_TABLE[T.GetExpansionLevel()]

    if isMaxLevel and E.db.KlixUI.databars.experienceBar.capped then
        GameTooltip:ClearLines()
        GameTooltip:AddLine(L["Experience"])
	    GameTooltip:AddLine(" ")
        GameTooltip:AddDoubleLine(L["XP:"], L["Capped"])
        GameTooltip:Show()
    end
end

-- hook the XP bar text and colour
function KDB:HookXPText()
    if E.db.KlixUI.databars.enable and EDB.expBar then
        if not KDB:IsHooked(EDB, "UpdateExperience") then
            hooksecurefunc(EDB, "UpdateExperience", UpdateExperience)
        end
    elseif not E.db.KlixUI.databars.enable or not EDB.expBar then
        if KDB:IsHooked(EDB, "UpdateExperience") then
            KDB:Unhook(EDB, "UpdateExperience")
        end
        KDB:RestoreXPColours()
    end
    EDB:UpdateExperience()
end

-- hook the GameTooltip of the XP bar
function KDB:HookXPTooltip()
    if E.db.KlixUI.databars.enable and EDB.expBar then
        if not KDB:IsHooked(_G["ElvUI_ExperienceBar"], "OnEnter") then
            KDB:SecureHookScript(_G["ElvUI_ExperienceBar"], "OnEnter", ExperienceBar_OnEnter)
        end
    elseif not E.db.KlixUI.databars.enable or not EDB.expBar then
        if KDB:IsHooked(_G["ElvUI_ExperienceBar"], "OnEnter") then
            KDB:Unhook(_G["ElvUI_ExperienceBar"], "OnEnter")
        end
    end
end

function KDB:RestoreXPColours()
    local bar = EDB.expBar
    if bar then
        bar.statusBar:SetStatusBarColor(0, 0.4, 1, 0.8) -- ElvUI default colour
        bar.statusBar:SetMinMaxValues(0, 0)
        bar.statusBar:SetValue(0)

        bar.rested:SetStatusBarColor(1, 0, 1, 0.2)
        bar.rested:SetMinMaxValues(0, 0)
        bar.rested:SetValue(0)
    end
end
