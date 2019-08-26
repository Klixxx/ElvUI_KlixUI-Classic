-------------------------------------------------------------------------------
-- ElvUI_BetterTalentFrame
-- Copyright (C) Arwic-Frostmourne, All rights reserved.
-------------------------------------------------------------------------------
local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KBTP = KUI:NewModule("KuiBetterTalentsProfiles", "AceHook-3.0", "AceEvent-3.0")
local KBT = KUI:GetModule("KuiBetterTalents")
local S = E:GetModule("Skins")

-- Config
local btn_sepX = 10
local btn_width = 80
local btn_height = 23

---------- Helpers ----------

function KBTP:Print(s)
    KUI:Print("" .. s)
end

-- Returns the talent info for each talent the user currently has available
function KBTP:GetTalentInfos()
    local talentInfos = {}
    local k = 1
    for i = 1, T.GetMaxTalentTier() do
        for j = 1, 3 do
            local talentID, name, texture, selected, available, spellid, tier, column = T.GetTalentInfo(i, j, T.GetActiveSpecGroup())
            talentInfos[k] = {}
            talentInfos[k].talentID = talentID
            talentInfos[k].name = name
            talentInfos[k].texture = texture
            talentInfos[k].selected = selected
            talentInfos[k].available = available
            talentInfos[k].spellid = spellid
            talentInfos[k].tier = tier
            talentInfos[k].column = column
            k = k + 1
        end
    end
    return talentInfos
end

-- Returns the talent info for each talent the user currently has available
function KBTP:GetPvpTalentInfos()
    return T.C_SpecializationInfo_GetAllSelectedPvpTalentIDs()
end

---------- Database ----------

-- ensures the db is valid
function KBTP:VerifyDB()
    -- Make sure the base DB table exists
    if KUIDataDB == nil then KUIDataDB = {} end
    -- Make sure the current class DB exists
    if KUIDataDB[self.playerClass] == nil then KUIDataDB[self.playerClass] = {} end
    -- Make sure the current class' specs table exists
    if KUIDataDB[self.playerClass].specs == nil then KUIDataDB[self.playerClass].specs = {} end
    -- Make sure each spec exists
    for i = 1, T.GetNumSpecializations() do
        -- Make sure the current spec's table exists
        if KUIDataDB[self.playerClass].specs[i] == nil then KUIDataDB[self.playerClass].specs[i] = {} end
        -- Make sure the profiles DB exists
        if KUIDataDB[self.playerClass].specs[i].profiles == nil then KUIDataDB[self.playerClass].specs[i].profiles = {} end
    end
end

-- Returns a profile at the given index
function KBTP:GetProfile(index)
    return KUIDataDB[self.playerClass].specs[T.GetSpecialization()].profiles[index]
end

-- Returns a list of all profiles for the current spec
function KBTP:GetAllProfiles()
    return KUIDataDB[self.playerClass].specs[T.GetSpecialization()].profiles
end

-- Inserts a new profile into the current spec's DB
function KBTP:InsertProfile(profile)
    T.table_insert(KUIDataDB[self.playerClass].specs[T.GetSpecialization()].profiles, profile)
end

-- Removes the profile at the given index from the current spec's DB
function KBTP:RemoveProfile(index)
    T.table_remove(KUIDataDB[self.playerClass].specs[T.GetSpecialization()].profiles, index)
end

---------- Action Buttons (Add, Apply, Save, Remove) ----------

-- Dialogue that enables the user to name a new profile
StaticPopupDialogs["TALENTPROFILES_ADD_PROFILE"] = {
    text = "Enter Profile Name:",
    button1 = "Save",
    button2 = "Cancel",
    OnAccept = function(sender)
        local name = sender.editBox:GetText()
        -- Ensure the database is ready
        KBTP:VerifyDB()
        -- Get basic info
        local talentInfos = KBTP:GetTalentInfos()
        local profile = {}
        profile.name = name
        profile.talents = {}
		profile.pvpTalents = KBTP:GetPvpTalentInfos()
        -- Get the currently selected talents
        local i = 1
        for k, v in T.pairs(talentInfos) do
            if v.selected == true then
                profile.talents[i] = v.talentID
                i = i + 1
            end
        end
        -- Make sure the data is valid
        if i > 8 then
            KBTP:Print("Error: Too many talents selected")
        end
        -- Save the profile to the database
        KBTP:InsertProfile(profile)
        -- Rebuild the frame with the new data
        KBTP:BuildFrame()
        -- Inform the user a profile was added
        KBTP:Print("Added a new profile: '" .. profile.name .. "'")
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
    hasEditBox = true,
}
function KBTP:StaticPopupShow_Add()
    T.StaticPopup_Show("TALENTPROFILES_ADD_PROFILE")
end

-- Activates the profile at the given index
function KBTP:ActivateProfile(index)
    -- Don't activate the placeholder profile
    if index ~= "new" then
        -- Get the profile, checking for errors on the way
        local profile = self:GetProfile(index)
        if profile == nil or profile.talents == nil then
            self:Print("Unable to load talent configuration for the selected profile")
            return
        end
        for i = 1, T.GetMaxTalentTier() do
            T.LearnTalent(profile.talents[i])
        end
        -- make sure pvp talents table exists
        if profile.pvpTalents == nil then
            profile.pvpTalents = {}
        end
        -- only attempt to learn pvp talents if the profile has any
        if table.length(profile.pvpTalents) == 4 then
            for i = 1, 4 do
                T.LearnPvpTalent(profile.pvpTalents[i], i)
            end
        end
        -- Inform the user a profile was activated
        self:Print("Activated profile: '" .. profile.name .. "'")
    end
end

function KLIXKBTP_ActivateProfile(index) -- global for macros
    KBTP:ActivateProfile(index)
end

-- Saves the current talent configuration to the current profile
function KBTP:SaveProfile(index)
    -- Don't try and save a profile that doesn't exist
    if table.length(self:GetAllProfiles()) == 0 then
        return
    end
    -- Don't activate the placeholder profile
    if index ~= "new" then
        -- Get the profile, checking for errors on the way
        local profile = self:GetProfile(index)
        if profile == nil then
            self:Print("Unable to load the selected profile")
            return
        end
        -- Update the selected talents
        local talentInfos = self:GetTalentInfos()
        profile.pvpTalents = KBTP:GetPvpTalentInfos()
        local i = 1
        for k, v in T.pairs(talentInfos) do
            if v.selected == true then
                profile.talents[i] = v.talentID
                i = i + 1
            end
        end
        -- Inform the user a profile was activated
        self:Print("Saved profile: '" .. profile.name .. "'")
    end
end

-- Dialogue that enables the user to confirm the removal of a profile
StaticPopupDialogs["TALENTPROFILES_REMOVE_PROFILE"] = {
    text = "Do you want to remove the profile '%s'?",
    button1 = "Yes",
    button2 = "No",
    OnAccept = function(sender)
        local key = nil
        local i = 1
        for k, v in T.pairs(KBTP:GetProfile(TalentProfiles_profilesDropDown.selectedID)) do
            if i == TalentProfiles_profilesDropDown.selectedID then
                key = k
            end
            i = i + 1
        end
        -- Cache the name
        local name = KBTP:GetProfile(TalentProfiles_profilesDropDown.selectedID).name
        -- Remove the profile
        KBTP:RemoveProfile(TalentProfiles_profilesDropDown.selectedID)
        KBTP:BuildFrame()
        -- Inform the user a profile was removed
        KBTP:Print("Removed a profile: '" .. name .. "'")
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}
function KBTP:StaticPopupShow_Remove()
    local index = TalentProfiles_profilesDropDown.selectedID
    local name = self:GetProfile(index).name
    StaticPopup_Show("TALENTPROFILES_REMOVE_PROFILE", name)
end

-------------------- Initialisation --------------------

function KBTP:BuildFrame()
    -- Set up main frame, if it doesnt already exist
    local mainFrame = TalentProfiles_main
    if TalentProfiles_main == nil then
        mainFrame = T.CreateFrame("Frame", "TalentProfiles_main", _G.PlayerTalentFrame)
        mainFrame:SetSize(_G.PlayerTalentFrame.NineSlice:GetWidth(), _G.PlayerTalentFrame.NineSlice:GetHeight())
        mainFrame:SetPoint("CENTER", _G.PlayerTalentFrame.NineSlice, "CENTER", 0, -20)
    end

    -- Set up profiles dropdown, if it doesnt already exist
    local dropdown = TalentProfiles_profilesDropDown
    if TalentProfiles_profilesDropDown == nil then
        dropdown = T.CreateFrame("Button", "TalentProfiles_profilesDropDown", TalentProfiles_main, "UIDropDownMenuTemplate")
        dropdown:SetPoint("TOPLEFT", TalentProfiles_main, "TOPLEFT", 100, -13)
        -- elvui dropdown skinning is bugged and makes the arrow button far too wide
        S:HandleDropDownBox(dropdown, 150)
        -- so make it the correct size
        TalentProfiles_profilesDropDownButton:SetWidth(TalentProfiles_profilesDropDownButton:GetHeight())
        -- and allow the user to open the dropdown by clicking anywhere on the control
        TalentProfiles_profilesDropDown:SetScript("OnClick", function(...) TalentProfiles_profilesDropDownButton:Click() end)
        -- make the dropdown the same height as the buttons
        TalentProfiles_profilesDropDown:SetHeight(btn_height)
    end
    -- Repopulate the dropdown, even if it already exists
    T.UIDropDownMenu_Initialize(dropdown, function(sender, level)
        KBTP:VerifyDB()
        local items = KBTP:GetAllProfiles()
        local i = 1
        for k, v in T.pairs(items) do
            local info = T.UIDropDownMenu_CreateInfo()
            info.text = v.name
            info.value = i
            info.func = function(sender)
                T.UIDropDownMenu_SetSelectedID(TalentProfiles_profilesDropDown, sender:GetID())
            end
            T.UIDropDownMenu_AddButton(info, level)
            i = i + 1
        end
        -- Add the new profile item
        local info = T.UIDropDownMenu_CreateInfo()
        info.text = "Add new profile"
        info.value = "new"
        info.func = function(sender)
            KBTP:StaticPopupShow_Add()
        end
        info.rgb = { 1.0, 0.0, 1.0, 1.0 }
        T.UIDropDownMenu_AddButton(info, level)
    end)
    T.UIDropDownMenu_SetSelectedID(dropdown, 1)
    dropdown:Show()

    -- Set up the action buttons
    local btnApply = TalentProfiles_btnApply
    if TalentProfiles_btnApply == nil then
        btnApply = T.CreateFrame("Button", "TalentProfiles_btnApply", TalentProfiles_main, "UIPanelButtonTemplate")
        btnApply:SetSize(btn_width, btn_height)
        btnApply:SetText("Apply")
        btnApply:SetPoint("TOPLEFT", dropdown, "TOPRIGHT", btn_sepX, -2)
        S:HandleButton(btnApply)
        btnApply:SetScript("OnClick", function(sender)
            KBTP:VerifyDB()
            -- Check if any profiles exists
            if table.length(KBTP:GetAllProfiles()) == 0 then
                return
            end
            -- Activate the profile
            KBTP:ActivateProfile(TalentProfiles_profilesDropDown.selectedID)
        end)
        btnApply:Show()
    end
    local btnSave = TalentProfiles_btnSave
    if TalentProfiles_btnSave == nil then
        btnSave = T.CreateFrame("Button", "TalentProfiles_btnSave", TalentProfiles_main, "UIPanelButtonTemplate")
        btnSave:SetSize(btn_width, btn_height) -- was w100
        btnSave:SetText("Save")
        btnSave:SetPoint("TOPLEFT", btnApply, "TOPRIGHT", btn_sepX, 0)
        S:HandleButton(btnSave)
        btnSave:SetScript("OnClick", function(sender)
            KBTP:SaveProfile(TalentProfiles_profilesDropDown.selectedID)
        end)
        btnSave:Show()
    end
    local btnRemove = TalentProfiles_btnRemove
    if TalentProfiles_btnRemove == nil then
        btnRemove = T.CreateFrame("Button", "TalentProfiles_btnRemove", TalentProfiles_main, "UIPanelButtonTemplate")
        btnRemove:SetSize(btn_width, btn_height)
        btnRemove:SetText("Remove")
        btnRemove:SetPoint("TOPLEFT", btnSave, "TOPRIGHT", btn_sepX, 0)
        S:HandleButton(btnRemove)
        btnRemove:SetScript("OnClick", function(sender)
            KBTP:VerifyDB()
            -- Check if any profiles exists
            if table.length(KBTP:GetAllProfiles()) == 0 then
                return
            end
            KBTP:StaticPopupShow_Remove()
        end)
        btnRemove:Show()
    end

    local enabled = KBT.selectedSpec == T.GetSpecialization()
    btnApply:SetEnabled(enabled)
    btnSave:SetEnabled(enabled)
    btnRemove:SetEnabled(enabled)
    dropdown:SetEnabled(enabled)
    TalentProfiles_profilesDropDownButton:SetEnabled(enabled)
end

-------------------- Events/Hooks -------------------- 

function KBTP:TryDisplay()
    -- Don't continue if the player doesn't have a talent frame yet (under level 10)
    if _G.PlayerTalentFrame == nil then
        return
    end
    local selectedTab = T.PanelTemplates_GetSelectedTab(_G.PlayerTalentFrame)
    if selectedTab == 2 then -- Only show when the talents tab is open
        self:BuildFrame()
        TalentProfiles_main:Show()
    else
        if TalentProfiles_main ~= nil then
            TalentProfiles_main:Hide()
        end
    end
end

function KBTP:KLIX_KBT_SPEC_SELECTION_CHANGED()
    self:TryDisplay()
end

function KBTP:PLAYER_SPECIALIZATION_CHANGED()
    self:TryDisplay()
end

function KBTP:PLAYER_ENTERING_WORLD()
    if not self.hasRunOneTime then
        T.TalentFrame_LoadUI() -- make sure the talent frame is loaded
        self.playerClass = T.select(2, T.UnitClass("player")) -- get player class
        self:VerifyDB() -- Load DB
        -- Hook functions
        self:SecureHook("ToggleTalentFrame", "TryDisplay", true)
        self:SecureHook("PanelTemplates_SetTab", "TryDisplay", true)
        self.hasRunOneTime = true
    end
end

---------- MAIN ----------

function KBTP:Initialize()
	if not E.db.KlixUI.talents.enable then return end
    -- register events
    self:RegisterMessage("KLIX_KBT_SPEC_SELECTION_CHANGED")
    self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

KUI:RegisterModule(KBTP:GetName())