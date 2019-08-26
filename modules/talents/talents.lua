-------------------------------------------------------------------------------
-- ElvUI_BetterTalentFrame
-- Copyright (C) Arwic-Frostmourne, All rights reserved.
-------------------------------------------------------------------------------
local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KBT = KUI:NewModule("KuiBetterTalents", "AceHook-3.0", "AceEvent-3.0")
local LCG = LibStub('LibCustomGlow-1.0')

-- Config
local activateButtonWidth = 200
local activateButtonHeight = 20
local tabDim = 30
local tabSep = 10
local tabXOffset = 2
local specTabPrefix = "KUI_KBT_SpecTab"
local talentRowCount = 7
local talentColCount = 3
local r, g, b = T.unpack(E.media.rgbvaluecolor)

-- ensures the db is valid
function KBT:VerifyDB()
    if KUIDataPerCharDB == nil then
         KUIDataPerCharDB = {}
    end
    if KUIDataPerCharDB["talents"] == nil then
        KUIDataPerCharDB["talents"] = {}
    end
    if KUIDataPerCharDB["talents"]["pve"] == nil then
        KUIDataPerCharDB["talents"]["pve"] = {}
    end
end

-- returns the pve talent info for a given spec at the given row and column
function KBT:GetCachedTalentInfo(specIndex, row, col)
    -- VerifyDB only guarantees us ["talents"]["pve"], not our spec table
    if KUIDataPerCharDB["talents"]["pve"][specIndex] == nil then
        return nil
    end
    return KUIDataPerCharDB["talents"]["pve"][specIndex][row][col]
end

-- returns the talent button frame at the given row and column
function KBT:GetTalentButtonFrame(row, col)
    return _G["PlayerTalentFrameTalentsTalentRow" .. row .. "Talent" .. col]
end

-- returns the texture widget of the talent button at the given row and column
function KBT:GetTalentButtonTexture(row, col)
    return _G["PlayerTalentFrameTalentsTalentRow" .. row .. "Talent" .. col .. "IconTexture"]
end

-- caches the current specs talent configuration
function KBT:UpdateTalentCache()
    -- always recreate the currents specs talent table
    self:VerifyDB()
    KUIDataPerCharDB["talents"]["pve"][T.GetSpecialization()] = {}

    -- save the current specs talents
    local curSpec =KUIDataPerCharDB["talents"]["pve"][T.GetSpecialization()]
    for i = 1, talentRowCount do
        curSpec[i] = {}
        for j = 1, talentColCount do
            curSpec[i][j] = {}
            curSpec[i][j].talentID, 
            curSpec[i][j].name, 
            curSpec[i][j].texture, 
            curSpec[i][j].selected, 
            curSpec[i][j].available, 
            curSpec[i][j].spellid, 
            curSpec[i][j].tier, 
            curSpec[i][j].column = T.GetTalentInfo(i, j, T.GetActiveSpecGroup())
        end
    end
end

function KBT:GetSpecTabIcon(index)
    return _G[specTabPrefix .. index]
end

---------- UPDATE ----------

function KBT:UpdateActivateButton()
	PlayerTalentFrame_UpdateSpecFrame(_G.PlayerTalentFrameSpecialization, KBT.selectedSpec)
    for i = 1, T.GetNumSpecializations() do
        _G["PlayerTalentFrameSpecializationSpecButton"..i]:SetScript("OnClick", function()
            KBT.selectedSpec = i
            self:Update()
        end)
    end
end

function KBT:UpdateSpecTab()
    -- enable the activate button if the selected spec is not currently active
    _G.PlayerTalentFrameSpecializationLearnButton:SetEnabled(KBT.selectedSpec ~= T.GetSpecialization())
    for i = 1, T.GetNumSpecializations(), 1 do
        local icon = self:GetSpecTabIcon(i)
        if icon and icon.overlay then
            icon.overlay:SetShown(KBT.selectedSpec == i)
        end
    end
end

function KBT:UpdateTalentsTab()
    -- update the talent cache
    self:UpdateTalentCache()
    -- replace the talent buttons with the selected specs talents
    for i = 1, talentRowCount do
        for j = 1, talentColCount do
            -- get vars
            local btn = self:GetTalentButtonFrame(i, j)
            local talentInfo = self:GetCachedTalentInfo(KBT.selectedSpec, i, j)
            local btnTexture = self:GetTalentButtonTexture(i, j)

            -- this is new in BFA and it messes with how we display non active spec talents
            if btn.ShadowedTexture ~= nil then
                btn.ShadowedTexture:Hide()
            end

            if talentInfo ~= nil then
                -- we have a talent cached for this button
                -- update the button with new talent info
                btn.name:SetText(talentInfo.name)
                btn.icon:SetTexture(talentInfo.texture)
                -- highlight the button if it is for a selected talent
                btnTexture:SetDesaturated(not (talentInfo.selected and KBT.selectedSpec == T.GetSpecialization()))
                -- update the button's tooltip
                btn:SetScript("OnEnter", function(self)
                    _G.GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
                    _G.GameTooltip:SetTalent(talentInfo.talentID)
                    _G.GameTooltip:Show()
                end)
                btn:SetScript("OnLeave", function(self)
                    T.GameTooltip_Hide()
                end)

                if KBT.selectedSpec == T.GetSpecialization() then
                    -- this is the currently active spec, we need to enable full functionality so the user can select talents
                    -- enable the buttons click event
                    btn:SetScript("OnClick", PlayerTalentButton_OnClick)
                    local _, classId = T.UnitClass("player")
                    local color = RAID_CLASS_COLORS[classId]
                    btn.bg.SelectedTexture:SetColorTexture(r, g, b, 0.5)
                    -- show the selected texture if the talent is selected
                    btn.bg.SelectedTexture:SetShown(talentInfo.selected)
					if E.db.KlixUI.talents.borderGlow then 
						if talentInfo.selected then 
							LCG.PixelGlow_Start(btn.bg, {r, g, b, 1}, nil, -0.25, nil, 1)
						else
							LCG.PixelGlow_Stop(btn.bg)
						end
					end
                else 
                    -- we arnt viewing the active spec
                    -- disable the buttons click event
                    btn:SetScript("OnClick", function(...) end)
                    -- non active specs have light grey highlighs
                    btn.bg.SelectedTexture:SetColorTexture(75/255, 75/255, 75/255, 0.5)
                    -- show the selected texture if the talent is selected
                    btn.bg.SelectedTexture:SetShown(talentInfo.selected)
					if E.db.KlixUI.talents.borderGlow then
						if talentInfo.selected then 
							LCG.PixelGlow_Start(btn.bg, {75/255, 75/255, 75/255, 1}, nil, -0.25, nil, 1)
						else
							LCG.PixelGlow_Stop(btn.bg)
						end
					end
                end
            else
                -- we dont have a talent cached for this button
                -- show unknown message and advise user to switch spec to update their data
                btn.name:SetText("Unknown Talent")
                btn.icon:SetTexture(0)
                btn.bg.SelectedTexture:SetShown(false)
				LCG.PixelGlow_Stop(btn.bg)
                btn:SetScript("OnEnter", function(self)
                    _G.GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
                    _G.GameTooltip:SetText("Unknown Talent", 1, 0, 0)
                    _G.GameTooltip:AddLine("Activate this specialization to update this talent.", nil, nil, nil, true)
                    _G.GameTooltip:Show()
                end)
                btn:SetScript("OnLeave", function(self)
                    T.GameTooltip_Hide()
                end)
            end
        end
    end
end

function KBT:Update()
    self:UpdateActivateButton()
    self:UpdateSpecTab()
    self:UpdateTalentsTab()
end

---------- INIT ----------

function KBT:InitActivateButton()
    -- make the activate button appear on every tab
    local btn = _G.PlayerTalentFrameSpecializationLearnButton
    if btn ~= nil then
        btn:SetText("Activate Specialization")
        btn:SetSize(activateButtonWidth, activateButtonHeight)
        btn:SetParent(_G.PlayerTalentFrame)
        btn:SetScript("OnClick", function(self, button) 
            T.SetSpecialization(KBT.selectedSpec)
        end)
        btn:SetEnabled(KBT.selectedSpec ~= T.GetSpecialization())
    end
end

function KBT:InitSpecIcons()
    -- add new spec spellbook style tabs to the top right of the talent frame
    for i = 1, T.GetNumSpecializations() do
        local spedID, specName, specDesc, specIcon = T.GetSpecializationInfo(i)
        -- create the button
        btn = T.CreateFrame("Button", specTabPrefix .. i, PlayerTalentFrame)
        btn:SetFrameStrata("LOW")
        btn:SetPoint("TOPLEFT", _G.PlayerTalentFrame, "TOPRIGHT", tabXOffset, -((tabSep + tabDim) * i))
        btn:SetSize(tabDim, tabDim)
        btn:CreateBackdrop("Default") -- ElvUI func
		btn:CreateIconShadow()
		if E.db.KlixUI.general.iconShadow and not T.IsAddOnLoaded("Masque") then
			btn.ishadow:SetInside(btn, 0, 0)
		end 
        -- add a tooltip containing the specs description
        btn:SetScript("OnEnter", function(self)
            _G.GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            _G.GameTooltip:SetText(specName, 1, 1, 1) -- This sets the top line of text, in gold.
            _G.GameTooltip:AddLine(specDesc, nil, nil, nil, true)
            _G.GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", function(self)
            _G.GameTooltip:Hide()
        end)
        -- set a click action
        btn:SetScript("OnClick", function(self, button)
            KBT.selectedSpec = i
            KBT:SendMessage("KLIX_KBT_SPEC_SELECTION_CHANGED", KBT.selectedSpec)
            KBT:Update()
        end)
        -- give it an icon
        if btn.icon == nil then
            btn.icon = btn:CreateTexture()
            btn.icon:SetSize(tabDim, tabDim)
            btn.icon:SetPoint("TOPLEFT")
            btn.icon:SetTexture(specIcon)
            btn.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
        end
        btn.icon:SetShown(true)
        -- give the icon an overlay to indicate the currently selected spec
        if btn.overlay == nil then
            btn.overlay = btn:CreateTexture(nil, "OVERLAY")
            btn.overlay:SetSize(tabDim, tabDim)
            btn.overlay:SetPoint("TOPLEFT")
            btn.overlay:SetColorTexture(1.0, 1.0, 1.0, 0.51)
        end
        btn.overlay:SetShown(KBT.selectedSpec == i)
    end
end

function KBT:PLAYER_SPECIALIZATION_CHANGED()
    self:UpdateTalentCache()
end

function KBT:PLAYER_LOGOUT()
    self:UpdateTalentCache()
end

function KBT:PLAYER_ENTERING_WORLD()
    if not self.hasRunOneTime then
        T.TalentFrame_LoadUI() -- make sure the talent frame is loaded
        self:VerifyDB() -- make sure the db exists
        self:UpdateTalentCache() -- update the currently selected spec and talents
        KBT.selectedSpec = T.GetSpecialization() -- select the players current spec by default
        self:InitActivateButton() -- initialise the activate button
        self:InitSpecIcons() -- initialise the spec spellbook icons
        self:SecureHook("PlayerTalentFrame_Update", "Update")

        -- default to talents tab if required
        if E.db.KlixUI.talents.DefaultToTalentsTab then
            _G.PlayerTalentFrameTab2:Click()
        end
        -- hide the pvp talents flyout if required
        if E.db.KlixUI.talents.AutoHidePvPTalents then
            _G.PlayerTalentFrameTalentsPvpTalentButton:Click()
        end

        self.hasRunOneTime = true
    end
end

---------- MAIN ----------

function KBT:Initialize()
	if not E.db.KlixUI.talents.enable then return end
    -- register events
    self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    self:RegisterEvent("PLAYER_LOGOUT")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

KUI:RegisterModule(KBT:GetName())