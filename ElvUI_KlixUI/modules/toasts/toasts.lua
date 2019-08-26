-------------------------------------------------------------------------------
-- Based on: Ls_Toasts - Lightspark
-------------------------------------------------------------------------------
local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KT = KUI:NewModule('KuiToasts', "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")

local TITLE_NEED_TEMPLATE = "%s |cff00ff00%s|r|TInterface\\Buttons\\UI-GroupLoot-Dice-Up:0:0:0:0:32:32:0:32:0:31|t"
local TITLE_GREED_TEMPLATE = "%s |cff00ff00%s|r|TInterface\\Buttons\\UI-GroupLoot-Coin-Up:0:0:0:0:32:32:0:32:0:31|t"
local TITLE_DE_TEMPLATE = "%s |cff00ff00%s|r|TInterface\\Buttons\\UI-GroupLoot-DE-Up:0:0:0:0:32:32:0:32:0:31|t"
local anchorFrame
local itemToasts = {}
local missonToasts = {}
local followerToasts = {}
local achievementToasts = {}
local abilityToasts = {}
local scenarioToasts = {}
local miscToasts = {}
local activeToasts = {}
local queuedToasts = {}
local textsToAnimate = {}
local toastCounter = 0

local EQUIP_SLOTS = {
    ["INVTYPE_HEAD"] = {_G.INVSLOT_HEAD},
    ["INVTYPE_NECK"] = {_G.INVSLOT_NECK},
    ["INVTYPE_SHOULDER"] = {_G.INVSLOT_SHOULDER},
    ["INVTYPE_CHEST"] = {_G.INVSLOT_CHEST},
    ["INVTYPE_ROBE"] = {_G.INVSLOT_CHEST},
    ["INVTYPE_WAIST"] = {_G.INVSLOT_WAIST},
    ["INVTYPE_LEGS"] = {_G.INVSLOT_LEGS},
    ["INVTYPE_FEET"] = {_G.INVSLOT_FEET},
    ["INVTYPE_WRIST"] = {_G.INVSLOT_WRIST},
    ["INVTYPE_HAND"] = {_G.INVSLOT_HAND},
    ["INVTYPE_FINGER"] = {_G.INVSLOT_FINGER1, _G.INVSLOT_FINGER2},
    ["INVTYPE_TRINKET"] = {_G.INVSLOT_TRINKET1, _G.INVSLOT_TRINKET1},
    ["INVTYPE_CLOAK"] = {_G.INVSLOT_BACK},
    ["INVTYPE_WEAPON"] = {_G.INVSLOT_MAINHAND, _G.INVSLOT_OFFHAND},
    ["INVTYPE_2HWEAPON"] = {_G.INVSLOT_MAINHAND},
    ["INVTYPE_WEAPONMAINHAND"] = {_G.INVSLOT_MAINHAND},
    ["INVTYPE_HOLDABLE"] = {_G.INVSLOT_OFFHAND},
    ["INVTYPE_SHIELD"] = {_G.INVSLOT_OFFHAND},
    ["INVTYPE_WEAPONOFFHAND"] = {_G.INVSLOT_OFFHAND},
    ["INVTYPE_RANGED"] = {_G.INVSLOT_RANGED},
    ["INVTYPE_RANGEDRIGHT"] = {_G.INVSLOT_RANGED},
    ["INVTYPE_RELIC"] = {_G.INVSLOT_RANGED},
    ["INVTYPE_THROWN"] = {_G.INVSLOT_RANGED},
}

local BLACKLISTED_EVENTS = {
	["ACHIEVEMENT_EARNED"] = true,
	["AZERITE_EMPOWERED_ITEM_LOOTED"] = true,
	["CRITERIA_EARNED"] = true,
	["GARRISON_BUILDING_ACTIVATABLE"] = true,
	["GARRISON_FOLLOWER_ADDED"] = true,
	["GARRISON_MISSION_FINISHED"] = true,
	["GARRISON_RANDOM_MISSION_ADDED"] = true,
	["GARRISON_TALENT_COMPLETE"] = true,
	["LFG_COMPLETION_REWARD"] = true,
	["LOOT_ITEM_ROLL_WON"] = true,
	["NEW_MOUNT_ADDED"] = true,
	["NEW_PET_ADDED"] = true,
	["NEW_RECIPE_LEARNED"] = true,
	["NEW_TOY_ADDED"] = true,
	["QUEST_LOOT_RECEIVED"] = true,
	["QUEST_TURNED_IN"] = true,
	["SCENARIO_COMPLETED"] = true,
	["SHOW_LOOT_TOAST"] = true,
	["SHOW_LOOT_TOAST_LEGENDARY_LOOTED"] = true,
	["SHOW_LOOT_TOAST_UPGRADE"] = true,
	["SHOW_PVP_FACTION_LOOT_TOAST"] = true,
	["SHOW_RATED_PVP_REWARD_TOAST"] = true,
	["STORE_PRODUCT_DELIVERED"] = true,
}

-- Export
function KT:SkinToast() end

-- Parameters:
-- toast
-- toastType - types: "item", "mission", "follower", "achievement", "ability", "scenario", "misc"

-- Utilities 
local function ParseLink(link)
    if not link or link == "[]" or link == "" then
        return
    end

    local name
    link, name = T.string_match(link, "|H(.+)|h%[(.+)%]|h")
    local linkTable = {T.string_split(":", link)}

    if linkTable[1] ~= "item" then
        return link, linkTable[1], name
    end

    if linkTable[12] ~= "" then
        linkTable[12] = ""

        T.table_remove(linkTable, 15 + (T.tonumber(linkTable[14]) or 0))
    end

    return T.table_concat(linkTable, ":"), linkTable[1], name
end

-- XXX: Remove it, when it's implemented by Blizzard
local function IsItemAnUpgrade(itemLink)
    if not T.IsUsableItem(itemLink) then return false end

    local _, _, _, _, _, _, _, _, itemEquipLoc = T.GetItemInfo(itemLink)
    local itemLevel = T.GetDetailedItemLevelInfo(itemLink)
    local slot1, slot2 = T.unpack(EQUIP_SLOTS[itemEquipLoc] or {})

    if slot1 then
        local itemLinkInSlot1 = T.GetInventoryItemLink("player", slot1)

        if itemLinkInSlot1 then
            local itemLevelInSlot1 = T.GetDetailedItemLevelInfo(itemLinkInSlot1)

            if itemLevel > itemLevelInSlot1 then
                return true
            end
        else
            -- XXX: Make sure that slot is empty
            if not T.GetInventoryItemID("player", slot1) then
                return true
            end
        end
    end

    if slot2 then
        local isSlot2Equippable = itemEquipLoc ~= "INVTYPE_WEAPON" and true or CanDualWield()

        if isSlot2Equippable then
            local itemLinkInSlot2 = T.GetInventoryItemLink("player", slot2)

            if itemLinkInSlot2 then
                local itemLevelInSlot2 = T.GetDetailedItemLevelInfo(itemLinkInSlot2)

                if itemLevel > itemLevelInSlot2 then
                    return true
                end
            else
                -- XXX: Make sure that slot is empty
                if not T.GetInventoryItemID("player", slot2) then
                    return true
                end
            end
        end
    end

    return false
end

-- Text Animation
--[[local function ProcessAnimatedText()
    for text, targetValue in T.pairs(textsToAnimate) do
        local newValue

        if text._value >= targetValue then
            newValue = T.math_floor(Lerp(text._value, targetValue, 0.25))
        else
            newValue = T.math_ceil(Lerp(text._value, targetValue, 0.25))
        end

        if newValue == targetValue then
            text._value = nil
            textsToAnimate[text] = nil
        end

        text:SetText(newValue)
        text._value = newValue
    end
end

local function SetAnimatedText(self, value)
    self._value = T.tonumber(self:GetText()) or 1
    textsToAnimate[self] = value
end

T.C_Timer_NewTicker(0.05, ProcessAnimatedText)]]

T.C_Timer_NewTicker(0.05, function()
	for text, targetValue in T.next, textsToAnimate do
		local newValue

		text._elapsed = text._elapsed + 0.05

		if text._value >= targetValue then
			newValue = T.math_floor(Lerp(text._value, targetValue, text._elapsed / 0.6))
		else
			newValue = T.math_ceil(Lerp(text._value, targetValue, text._elapsed / 0.6))
		end

		if newValue == targetValue then
			textsToAnimate[text] = nil
		end

		text._value = newValue

		if text.PostSetAnimatedValue then
			text:PostSetAnimatedValue(newValue)
		else
			text:SetText(newValue)
		end
	end
end)

local function text_SetAnimatedValue(self, value, skip)
	if skip then
		self._value = value
		self._elapsed = 0

		if self.PostSetAnimatedValue then
			self:PostSetAnimatedValue(value)
		else
			self:SetText(value)
		end
	else
		self._value = self._value or 1
		self._elapsed = 0

		textsToAnimate[self] = value
	end
end

-- Main
local function IsDNDEnabled()
    local counter = 0

    for k in T.pairs(KT.db.dnd) do
        if k then
            counter = counter + 1
        end
    end

    return counter > 0
end

local function HasNonDNDToast()
    for i, queuedToast in T.pairs(queuedToasts) do
        if not queuedToast.dnd then
            -- XXX: I don't want to ruin non-DND toasts' order, k?
            T.table_insert(queuedToasts, 1, T.table_remove(queuedToasts, i))

            return true
        end
    end

    return false
end

function KT:SpawnToast(toast, isDND)
    if not toast then return end

    if #activeToasts >= KT.db.max_active_toasts or (T.InCombatLockdown() and isDND) then
        if T.InCombatLockdown() and isDND then
            toast.dnd = true
        end

        T.table_insert(queuedToasts, toast)

        return false
    end

    if #activeToasts > 0 then
        if KT.db.growth_direction == "DOWN" then
            toast:SetPoint("TOP", activeToasts[#activeToasts], "BOTTOM", 0, -4)
        elseif KT.db.growth_direction == "UP" then
            toast:SetPoint("BOTTOM", activeToasts[#activeToasts], "TOP", 0, 4)
        elseif KT.db.growth_direction == "LEFT" then
            toast:SetPoint("RIGHT", activeToasts[#activeToasts], "LEFT", -8, 0)
        elseif KT.db.growth_direction == "RIGHT" then
            toast:SetPoint("LEFT", activeToasts[#activeToasts], "RIGHT", 8, 0)
        end
    else
        toast:SetPoint("TOPLEFT", anchorFrame, "TOPLEFT", 0, 0)
    end

    T.table_insert(activeToasts, toast)

    KT:SkinToast(toast, toast.type)

    toast:Show()

    return true
end

local function RefreshToasts()
    for i = 1, #activeToasts do
        local activeToast = activeToasts[i]

        activeToast:ClearAllPoints()

        if i == 1 then
            activeToast:SetPoint("TOPLEFT", anchorFrame, "TOPLEFT", 0, 0)
        else
            if KT.db.growth_direction == "DOWN" then
                activeToast:SetPoint("TOP", activeToasts[i - 1], "BOTTOM", 0, -4)
            elseif KT.db.growth_direction == "UP" then
                activeToast:SetPoint("BOTTOM", activeToasts[i - 1], "TOP", 0, 4)
            elseif KT.db.growth_direction == "LEFT" then
                activeToast:SetPoint("RIGHT", activeToasts[i - 1], "LEFT", -8, 0)
            elseif KT.db.growth_direction == "RIGHT" then
                activeToast:SetPoint("LEFT", activeToasts[i - 1], "RIGHT", 8, 0)
            end
        end
    end

    local queuedToast = T.table_remove(queuedToasts, 1)

    if queuedToast then
        if T.InCombatLockdown() and queuedToast.dnd then
            T.table_insert(queuedToasts, queuedToast)

            if HasNonDNDToast() then
                RefreshToasts()
            end
        else
            KT:SpawnToast(queuedToast)
        end
    end
end

local function ResetToast(toast)
    toast.id = nil
    toast.dnd = nil
    toast.chat = nil
    toast.link = nil
    toast.itemCount = nil
    toast.soundFile = nil
    toast.usedRewards = nil
    toast:ClearAllPoints()
    toast:Hide()
    toast.BG:SetTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\toasts\\toast-bg-default")
    toast.Icon:SetPoint("TOPLEFT", 7, -7)
    toast.Icon:SetSize(44, 44)
    toast.Title:SetText("")
    toast.Text:SetText("")
    toast.Text:SetTextColor(1, 1, 1)
	toast.Text.PostSetAnimatedValue = nil
    toast.TextBG:SetVertexColor(0, 0, 0)
    toast.AnimIn:Stop()
    toast.AnimOut:Stop()

    if toast.IconBorder then
        toast.IconBorder:Show()
        toast.IconBorder:SetVertexColor(1, 1, 1)
    end

    if toast.Count then
        toast.Count:SetText("")
    end

    if toast.Dragon then
        toast.Dragon:Hide()
    end

    if toast.UpgradeIcon then
        toast.UpgradeIcon:Hide()
    end

    if toast.Level then
        toast.Level:SetText("")
    end

    if toast.Points then
        toast.Points:SetText("")
    end

    if toast.Rank then
        toast.Rank:SetText("")
    end

    if toast.RankBG then
		toast.RankBG:Hide()
	end

    if toast.IconText then
        toast.IconText:SetText("")
    end

    if toast.Bonus then
        toast.Bonus:Hide()
    end

    if toast.Heroic then
        toast.Heroic:Hide()
    end

    if toast.Arrows then
        toast.Arrows.Anim:Stop()
    end

    if toast.Reward1 then
        for i = 1, 5 do
            toast["Reward"..i]:Hide()
        end
    end
end

local function RecycleToast(toast)
    for i, activeToast in T.pairs(activeToasts) do
        if toast == activeToast then
            T.table_remove(activeToasts, i)

            if toast.type == "item" then
                T.table_insert(itemToasts, toast)
            elseif toast.type == "mission" then
                T.table_insert(missonToasts, toast)
            elseif toast.type == "follower" then
                T.table_insert(followerToasts, toast)
            elseif toast.type == "achievement" then
                T.table_insert(achievementToasts, toast)
            elseif toast.type == "ability" then
                T.table_insert(abilityToasts, toast)
            elseif toast.type == "scenario" then
                T.table_insert(scenarioToasts, toast)
            elseif toast.type == "misc" then
                T.table_insert(miscToasts, toast)
            end

            ResetToast(toast)
        end
    end

    RefreshToasts()
end

local function GetToastToUpdate(id, toastType)
    for _, toast in T.pairs(activeToasts) do
        if not toast.chat and toastType == toast.type and (id == toast.id or id == toast.link) then
            return toast, false
        end
    end

    for _, toast in T.pairs(queuedToasts) do
        if not toast.chat and toastType == toast.type and (id == toast.id or id == toast.link) then
            return toast, true
        end
    end

    return
end

local function UpdateToast(id, toastType, itemLink)
    local toast, isQueued = GetToastToUpdate(id, toastType)

    if toast then
        toast.usedRewards = toast.usedRewards + 1
        local reward = toast["Reward"..toast.usedRewards]

        if reward then
            local _, _, _, _, texture = T.GetItemInfoInstant(itemLink)
            local isOK = T.pcall(T.SetPortraitToTexture, reward.Icon, texture)

            if not isOK then
                T.SetPortraitToTexture(reward.Icon, "Interface\\Icons\\INV_Box_02")
            end

            reward.item = itemLink
            reward:Show()
        end

        if not isQueued then
            toast.AnimOut:Stop()
            toast.AnimOut:Play()
        end
    end
end

local function ToastButton_OnShow(self)
    local soundFile = self.soundFile

    if KT.db.sfx_enabled and soundFile then
        T.PlaySound(soundFile)
    end

    self.AnimIn:Play()
    self.AnimOut:Play()
end

local function ToastButton_OnClick(self, button)
    if button == "RightButton" then
        RecycleToast(self)
    elseif button == "LeftButton" then
        if self.id then
            if self.type == "achievement" then
                if not _G.AchievementFrame then
                    T.AchievementFrame_LoadUI()
                end
                T.ShowUIPanel(_G.AchievementFrame)
                T.AchievementFrame_SelectAchievement(self.id)
            elseif self.type == "follower" then
                if not _G.GarrisonLandingPage then
                    T.Garrison_LoadUI()
                end

                if _G.GarrisonLandingPage then
                    T.ShowGarrisonLandingPage(_G.GarrisonFollowerOptions[T.C_Garrison_GetFollowerInfo(self.id).followerTypeID].garrisonType)
                end
            elseif self.type == "misc" then
                if self.link then
                    if T.string_sub(self.link, 1, 18) == "transmogappearance" then
                        if not _G.CollectionsJournal then
                            T.CollectionsJournal_LoadUI()
                        end

                        if _G.CollectionsJournal then
                            T.WardrobeCollectionFrame_OpenTransmogLink(self.link)
                        end
                    end
                end
            end
        end
    end
end

local function ToastButton_OnEnter(self)
    if self.id then
        if self.type == "item" then
            _G.GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", -2, 2)
            _G.GameTooltip:SetItemByID(self.id)
            _G.GameTooltip:Show()
        elseif self.type == "follower" then
            local isOK, link = T.pcall(T.C_Garrison_GetFollowerLink, self.id)

            if not isOK then
                isOK, link = T.pcall(T.C_Garrison_GetFollowerLinkByID, self.id)
            end

            if isOK and link then
                local _, garrisonFollowerID, quality, level, itemLevel, ability1, ability2, ability3, ability4, trait1, trait2, trait3, trait4, spec1 = T.string_split(":", link)
                local followerType = T.C_Garrison_GetFollowerTypeByID(T.tonumber(garrisonFollowerID))
                T.GarrisonFollowerTooltip_Show(T.tonumber(garrisonFollowerID), false, T.tonumber(quality), T.tonumber(level), 0, 0, T.tonumber(itemLevel), T.tonumber(spec1), T.tonumber(ability1), T.tonumber(ability2), T.tonumber(ability3), T.tonumber(ability4), T.tonumber(trait1), T.tonumber(trait2), T.tonumber(trait3), T.tonumber(trait4))

                if followerType == LE_FOLLOWER_TYPE_SHIPYARD_6_2 then
                    _G.GarrisonShipyardFollowerTooltip:ClearAllPoints()
                    _G.GarrisonShipyardFollowerTooltip:SetPoint("TOPLEFT", self, "BOTTOMRIGHT", -2, 2)
                else
                    _G.GarrisonFollowerTooltip:ClearAllPoints()
                    _G.GarrisonFollowerTooltip:SetPoint("TOPLEFT", self, "BOTTOMRIGHT", -2, 2)
                end
            end
        elseif self.type == "ability" then
            _G.GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", -2, 2)
            _G.GameTooltip:SetSpellByID(self.id)
            _G.GameTooltip:Show()
        end
    elseif self.link then
        if self.type == "item" then
            if T.string_find(self.link, "battlepet:") then
                local _, speciesID, level, breedQuality, maxHealth, power, speed = T.string_split(":", self.link)
                _G.GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", -2, 2)
                _G.GameTooltip:Show()
                T.BattlePetToolTip_Show(T.tonumber(speciesID), T.tonumber(level), T.tonumber(breedQuality), T.tonumber(maxHealth), T.tonumber(power), T.tonumber(speed))
            else
                _G.GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", -2, 2)
                _G.GameTooltip:SetHyperlink(self.link)
                _G.GameTooltip:Show()
            end
        end
    end

    self.AnimOut:Stop()

    KT:RegisterEvent("MODIFIER_STATE_CHANGED")
end

local function ToastButton_OnLeave(self)
    _G.GameTooltip:Hide()
    _G.GarrisonFollowerTooltip:Hide()
    _G.GarrisonShipyardFollowerTooltip:Hide()
    _G.BattlePetTooltip:Hide()

    self.AnimOut:Play()

    KT:UnregisterEvent("MODIFIER_STATE_CHANGED")
end

function KT:MODIFIER_STATE_CHANGED()
    if T.IsModifiedClick("COMPAREITEMS") or T.GetCVarBool("alwaysCompareItems") then
        T.GameTooltip_ShowCompareItem()
    else
        _G.ShoppingTooltip1:Hide()
        _G.ShoppingTooltip2:Hide()
    end
end

local function ToastButtonAnimIn_OnStop(self)
    local frame = self:GetParent()

    if frame.Arrows then
        frame.Arrows.requested = false
    end
end

local function ToastButtonAnimIn_OnFinished(self)
    local frame = self:GetParent()

    if frame.Arrows and frame.Arrows.requested then
        --- XXX: Parent translation anims affect child's translation anims
        T.C_Timer_After(0.1, function() frame.Arrows.Anim:Play() end)

        frame.Arrows.requested = false
    end
end

local function ToastButtonAnimOut_OnFinished(self)
    RecycleToast(self:GetParent())
end

local function CreateBaseToastButton()
    toastCounter = toastCounter + 1

    local toast = T.CreateFrame("Button", "KTToast"..toastCounter, E.UIParent)
    toast:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    toast:Hide()
    toast:SetScript("OnShow", ToastButton_OnShow)
    toast:SetScript("OnClick", ToastButton_OnClick)
    toast:SetScript("OnEnter", ToastButton_OnEnter)
    toast:SetScript("OnLeave", ToastButton_OnLeave)
    toast:SetSize(234, 58)
    toast:SetScale(KT.db.scale)
    toast:SetFrameStrata("DIALOG")

    local bg = toast:CreateTexture(nil, "BACKGROUND", nil, 0)
    bg:SetPoint("TOPLEFT", 5, -5)
    bg:SetPoint("BOTTOMRIGHT", -5, 5)
    bg:SetTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\toasts\\toast-bg-default")
    bg:SetTexCoord(1 / 256, 225 / 256, 1 / 64, 49 / 64)
    toast.BG = bg

    local border = toast:CreateTexture(nil, "BACKGROUND", nil, 1)
    border:SetAllPoints()
    border:SetTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\toasts\\toast-border")
    border:SetTexCoord(1 / 256, 235 / 256, 1 / 64, 59 / 64)
    toast.Border = border

    local icon = toast:CreateTexture(nil, "BACKGROUND", nil, 2)
    icon:SetPoint("TOPLEFT", 7, -7)
    icon:SetSize(44, 44)
    toast.Icon = icon

    local title = toast:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    title:SetPoint("TOPLEFT", 55, -12)
    title:SetWidth(170)
    title:SetJustifyH("CENTER")
    title:SetWordWrap(false)
    title:SetText("Toast Title")
    toast.Title = title

    local text = toast:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    text:SetPoint("BOTTOMLEFT", 55, 12)
    text:SetWidth(170)
    text:SetJustifyH("CENTER")
    text:SetWordWrap(false)
    text:SetText(toast:GetDebugName())
	text.SetAnimatedValue = text_SetAnimatedValue
    toast.Text = text

    local textBG = toast:CreateTexture(nil, "BACKGROUND", nil, 2)
    textBG:SetSize(174, 44)
    textBG:SetPoint("BOTTOMLEFT", 53, 7)
    textBG:SetTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\toasts\\toast-text-bg")
    textBG:SetTexCoord(1 / 256, 175 / 256, 1 / 64, 45 / 64)
    textBG:SetVertexColor(0, 0, 0)
    toast.TextBG = textBG

    local glow = toast:CreateTexture(nil, "OVERLAY", nil, 2)
    glow:SetSize(310, 148)
    glow:SetPoint("CENTER")
    glow:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Alert-Glow")
    glow:SetTexCoord(0, 0.78125, 0, 0.66796875)
    glow:SetBlendMode("ADD")
    glow:SetAlpha(0)
    toast.Glow = glow

    local shine = toast:CreateTexture(nil, "OVERLAY", nil, 1)
    shine:SetSize(67, 54)
    shine:SetPoint("BOTTOMLEFT", 0, 2)
    shine:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Alert-Glow")
    shine:SetTexCoord(400 / 512, 467 / 512, 11 / 256, 65 / 256)
    shine:SetBlendMode("ADD")
    shine:SetAlpha(0)
    toast.Shine = shine

    local animIn = toast:CreateAnimationGroup()
    animIn:SetScript("OnStop", ToastButtonAnimIn_OnStop)
    animIn:SetScript("OnFinished", ToastButtonAnimIn_OnFinished)
    toast.AnimIn = animIn

    local anim1 = animIn:CreateAnimation("Alpha")
    anim1:SetChildKey("Glow")
    anim1:SetOrder(1)
    anim1:SetFromAlpha(0)
    anim1:SetToAlpha(1)
    anim1:SetDuration(0.2)

    local anim2 = animIn:CreateAnimation("Alpha")
    anim2:SetChildKey("Glow")
    anim2:SetOrder(2)
    anim2:SetFromAlpha(1)
    anim2:SetToAlpha(0)
    anim2:SetDuration(0.5)

    local anim3 = animIn:CreateAnimation("Alpha")
    anim3:SetChildKey("Shine")
    anim3:SetOrder(1)
    anim3:SetFromAlpha(0)
    anim3:SetToAlpha(1)
    anim3:SetDuration(0.2)

    local anim4 = animIn:CreateAnimation("Translation")
    anim4:SetChildKey("Shine")
    anim4:SetOrder(2)
    anim4:SetOffset(168, 0)
    anim4:SetDuration(0.85)

    local anim5 = animIn:CreateAnimation("Alpha")
    anim5:SetChildKey("Shine")
    anim5:SetOrder(2)
    anim5:SetFromAlpha(1)
    anim5:SetToAlpha(0)
    anim5:SetStartDelay(0.35)
    anim5:SetDuration(0.5)

    local animOut = toast:CreateAnimationGroup()
    animOut:SetScript("OnFinished", ToastButtonAnimOut_OnFinished)
    toast.AnimOut = animOut

    anim1 = animOut:CreateAnimation("Alpha")
    anim1:SetOrder(1)
    anim1:SetFromAlpha(1)
    anim1:SetToAlpha(0)
    anim1:SetStartDelay(KT.db.fadeout_delay)
    anim1:SetDuration(1.2)
    animOut.Anim1 = anim1

    return toast
end

local ARROW_CFG = {
    [1] = {startDelay1 = 0.9, startDelay2 = 1.2, point = {"TOP", "$parent", "CENTER", 8, 0}},
    [2] = {startDelay1 = 1.0, startDelay2 = 1.3, point = {"CENTER", "$parentArrow1", 16, 0}},
    [3] = {startDelay1 = 1.1, startDelay2 = 1.4, point = {"CENTER", "$parentArrow1", -16, 0}},
    [4] = {startDelay1 = 1.3, startDelay2 = 1.6, point = {"CENTER", "$parentArrow1", 5, 0}},
    [5] = {startDelay1 = 1.5, startDelay2 = 1.8, point = {"CENTER", "$parentArrow1", -12, 0}},
}

local function ShowArrows(self)
    self:GetParent():Show()
end

local function HideArrows(self)
    self:GetParent():Hide()
end

local function CreateUpdateArrowsAnim(parent)
    local frame = T.CreateFrame("Frame", "$parentUpgradeArrows", parent)
    frame:SetSize(48, 48)
    frame:Hide()

    local ag = frame:CreateAnimationGroup()
    ag:SetScript("OnPlay", ShowArrows)
    ag:SetScript("OnFinished", HideArrows)
    ag:SetScript("OnStop", HideArrows)
    frame.Anim = ag

    for i = 1, 5 do
        frame["Arrow"..i] = frame:CreateTexture("$parentArrow"..i, "ARTWORK", "LootUpgradeFrame_ArrowTemplate")
        frame["Arrow"..i]:ClearAllPoints()
        frame["Arrow"..i]:SetPoint(T.unpack(ARROW_CFG[i].point))

        local anim = ag:CreateAnimation("Alpha")
        anim:SetChildKey("Arrow"..i)
        anim:SetDuration(0)
        anim:SetOrder(1)
        anim:SetFromAlpha(1)
        anim:SetToAlpha(0)

        anim = ag:CreateAnimation("Alpha")
        anim:SetChildKey("Arrow"..i)
        anim:SetStartDelay(ARROW_CFG[i].startDelay1)
        anim:SetSmoothing("IN")
        anim:SetDuration(0.2)
        anim:SetOrder(2)
        anim:SetFromAlpha(0)
        anim:SetToAlpha(1)

        anim = ag:CreateAnimation("Alpha")
        anim:SetChildKey("Arrow"..i)
        anim:SetStartDelay(ARROW_CFG[i].startDelay2)
        anim:SetSmoothing("OUT")
        anim:SetDuration(0.2)
        anim:SetOrder(2)
        anim:SetFromAlpha(1)
        anim:SetToAlpha(0)

        anim = ag:CreateAnimation("Translation")
        anim:SetChildKey("Arrow"..i)
        anim:SetStartDelay(ARROW_CFG[i].startDelay1)
        anim:SetDuration(0.5)
        anim:SetOrder(2)
        anim:SetOffset(0, 60)

        anim = ag:CreateAnimation("Alpha")
        anim:SetChildKey("Arrow"..i)
        anim:SetDuration(0)
        anim:SetOrder(3)
        anim:SetFromAlpha(1)
        anim:SetToAlpha(0)
    end

    return frame
end

local function Reward_OnEnter(self)
    self:GetParent().AnimOut:Stop()

    _G.GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")

    if self.item then
        _G.GameTooltip:SetHyperlink(self.item)
    elseif self.xp then
        _G.GameTooltip:AddLine(YOU_RECEIVED)
        _G.GameTooltip:AddLine(T.string_format(BONUS_OBJECTIVE_EXPERIENCE_FORMAT, self.xp), 1, 1, 1)
    elseif self.money then
        _G.GameTooltip:AddLine(YOU_RECEIVED)
        _G.GameTooltip:AddLine(T.GetMoneyString(self.money), 1, 1, 1)
    elseif self.item then
        _G.GameTooltip:SetHyperlink(self.item)
    elseif self.currency then
        _G.GameTooltip:SetQuestLogCurrency("reward", self.currency, self:GetParent().id)
    end

    _G.GameTooltip:Show()
end

local function Reward_OnLeave(self)
    self:GetParent().AnimOut:Play()
    _G.GameTooltip:Hide()
end

local function Reward_OnHide(self)
    self.rewardID = nil
    self.currency = nil
    self.money = nil
    self.item = nil
    self.xp = nil
end

local function CreateToastReward(parent, index)
    local reward = T.CreateFrame("Frame", "$parent"..index, parent)
    reward:SetSize(30, 30)
    reward:SetScript("OnEnter", Reward_OnEnter)
    reward:SetScript("OnLeave", Reward_OnLeave)
    reward:SetScript("OnHide", Reward_OnHide)
    reward:Hide()
    parent["Reward"..index] = reward

    local icon = reward:CreateTexture(nil, "BACKGROUND")
    icon:SetPoint("TOPLEFT", 5, -4)
    icon:SetPoint("BOTTOMRIGHT", -7, 8)
    reward.Icon = icon

    local border = reward:CreateTexture(nil, "BORDER")
    border:SetAllPoints()
    border:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-REWARDRING")
    border:SetTexCoord(0 / 64, 40 / 64, 0 / 64, 40 / 64)

    return reward
end

local function GetToast(toastType)
    local toast

    if toastType == "item" then
        toast = T.table_remove(itemToasts, 1)

        if not toast then
            toast = CreateBaseToastButton()

            local arrows = CreateUpdateArrowsAnim(toast)
            arrows:SetPoint("TOPLEFT", -5, 5)
            toast.Arrows = arrows

            local iconBorder = toast:CreateTexture(nil, "ARTWORK", nil, 2)
            iconBorder:SetPoint("TOPLEFT", 7, -7)
            iconBorder:SetSize(44, 44)
            iconBorder:SetTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\toasts\\toast-icon-border")
            iconBorder:SetTexCoord(1 / 64, 45 / 64, 1 / 64, 45 / 64)
            toast.IconBorder = iconBorder

            local count = toast:CreateFontString(nil, "ARTWORK", "GameFontHighlightOutline")
            count:SetPoint("BOTTOMRIGHT", toast.Icon, "BOTTOMRIGHT", 0, 2)
            count:SetJustifyH("RIGHT")
			--count.SetAnimatedText = SetAnimatedText
            count.SetAnimatedValue = text_SetAnimatedValue
            toast.Count = count

            local countUpdate = toast:CreateFontString(nil, "ARTWORK", "GameFontHighlightOutline")
            countUpdate:SetPoint("BOTTOMRIGHT", toast.Count, "TOPRIGHT", 0, 2)
            countUpdate:SetJustifyH("RIGHT")
            countUpdate:SetAlpha(0)
            toast.CountUpdate = countUpdate

            local upgradeIcon = toast:CreateTexture(nil, "ARTWORK", nil, 3)
            upgradeIcon:SetAtlas("bags-greenarrow", true)
            upgradeIcon:SetPoint("TOPLEFT", 4, -4)
            upgradeIcon:Hide()
            toast.UpgradeIcon = upgradeIcon

            local ag = toast:CreateAnimationGroup()
            toast.CountUpdateAnim = ag

            local anim1 = ag:CreateAnimation("Alpha")
            anim1:SetChildKey("CountUpdate")
            anim1:SetOrder(1)
            anim1:SetFromAlpha(0)
            anim1:SetToAlpha(1)
            anim1:SetDuration(0.2)

            local anim2 = ag:CreateAnimation("Alpha")
            anim2:SetChildKey("CountUpdate")
            anim2:SetOrder(2)
            anim2:SetFromAlpha(1)
            anim2:SetToAlpha(0)
            anim2:SetStartDelay(0.4)
            anim2:SetDuration(0.8)

            local dragon = toast:CreateTexture(nil, "OVERLAY", nil, 0)
            dragon:SetPoint("TOPLEFT", -23, 13)
            dragon:SetSize(88, 88)
            dragon:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Gold-Dragon")
            dragon:SetVertexColor(250 / 255, 200 / 255, 0 / 255)
            dragon:Hide()
            toast.Dragon = dragon

            toast.type = "item"
        end
    elseif toastType == "mission" then
        toast = T.table_remove(missonToasts, 1)

        if not toast then
            toast = CreateBaseToastButton()

            local level = toast:CreateFontString(nil, "ARTWORK", "GameFontHighlightOutline")
            level:SetPoint("BOTTOMRIGHT", toast.Icon, "BOTTOMRIGHT", 0, 2)
            level:SetJustifyH("RIGHT")
            toast.Level = level

            toast.type = "mission"
        end
    elseif toastType == "follower" then
        toast = T.table_remove(followerToasts, 1)

        if not toast then
            toast = CreateBaseToastButton()

            local arrows = CreateUpdateArrowsAnim(toast)
            arrows:SetPoint("TOPLEFT", -5, 5)
            toast.Arrows = arrows

            local level = toast:CreateFontString(nil, "ARTWORK", "GameFontHighlightOutline")
            level:SetPoint("BOTTOMRIGHT", toast.Icon, "BOTTOMRIGHT", 0, 2)
            level:SetJustifyH("RIGHT")
            toast.Level = level

            toast.type = "follower"
        end
    elseif toastType == "achievement" then
        toast = T.table_remove(achievementToasts, 1)

        if not toast then
            toast = CreateBaseToastButton()

            local iconBorder = toast:CreateTexture(nil, "ARTWORK", nil, 2)
            iconBorder:SetPoint("TOPLEFT", 7, -7)
            iconBorder:SetSize(44, 44)
            iconBorder:SetTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\toasts\\toast-icon-border")
            iconBorder:SetTexCoord(1 / 64, 45 / 64, 1 / 64, 45 / 64)
            toast.IconBorder = iconBorder

            local points = toast:CreateFontString(nil, "ARTWORK", "GameFontHighlightOutline")
            points:SetPoint("BOTTOMRIGHT", toast.Icon, "BOTTOMRIGHT", 0, 2)
            points:SetJustifyH("RIGHT")
            toast.Points = points

            toast.type = "achievement"
        end
    elseif toastType == "ability" then
        toast = T.table_remove(abilityToasts, 1)

        if not toast then
            toast = CreateBaseToastButton()

            local iconBorder = toast:CreateTexture(nil, "ARTWORK", nil, 2)
            iconBorder:SetPoint("TOPLEFT", 7, -7)
            iconBorder:SetSize(44, 44)
            iconBorder:SetTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\toasts\\toast-icon-border")
            iconBorder:SetTexCoord(1 / 64, 45 / 64, 1 / 64, 45 / 64)
            toast.IconBorder = iconBorder

            local rank = toast:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
            rank:SetPoint("BOTTOMRIGHT", toast.Icon, "BOTTOMRIGHT", -2, 2)
            rank:SetJustifyH("RIGHT")
            toast.Rank = rank

            local rankBG = toast:CreateTexture(nil, "ARTWORK", nil, 1)
			rankBG:SetPoint("BOTTOMLEFT", toast.Icon, "BOTTOMLEFT", 2, 2)
			rankBG:SetPoint("BOTTOMRIGHT", toast.Icon, "BOTTOMRIGHT", -2, 2)
			rankBG:SetHeight(12)
			rankBG:SetColorTexture(0, 0, 0, 0.6)
			toast.RankBG = rankBG

            toast.type = "ability"
        end
    elseif toastType == "scenario" then
        toast = T.table_remove(scenarioToasts, 1)

        if not toast then
            toast = CreateBaseToastButton()

            local iconBorder = toast:CreateTexture(nil, "ARTWORK", nil, 2)
            iconBorder:SetPoint("TOPLEFT", 7, -7)
            iconBorder:SetSize(44, 44)
            iconBorder:SetTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\toasts\\toast-icon-border")
            iconBorder:SetTexCoord(1 / 64, 45 / 64, 1 / 64, 45 / 64)
            toast.IconBorder = iconBorder

            for i = 1, 5 do
                local reward = CreateToastReward(toast, i)

                if i == 1 then
                    reward:SetPoint("TOPRIGHT", -2, 10)
                else
                    reward:SetPoint("RIGHT", toast["Reward"..(i - 1)], "LEFT", -2 , 0)
                end
            end

            local bonus = toast:CreateTexture(nil, "ARTWORK")
            bonus:SetAtlas("Bonus-ToastBanner", true)
            bonus:SetPoint("TOPRIGHT", -4, 0)
            bonus:Hide()
            toast.Bonus = bonus

            local heroic = toast:CreateTexture(nil, "ARTWORK", nil, 2)
            heroic:SetSize(16, 20)
            heroic:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-HEROIC")
            heroic:SetTexCoord(0 / 32, 16 / 32, 0 / 32, 20 / 32)
            heroic:SetPoint("BOTTOMRIGHT", toast.Icon, "BOTTOMRIGHT", -2, 0)
            heroic:Hide()
            toast.Heroic = heroic

            toast.type = "scenario"
        end
    elseif toastType == "misc" then
        toast = T.table_remove(miscToasts, 1)

        if not toast then
            toast = CreateBaseToastButton()

            local iconBorder = toast:CreateTexture(nil, "ARTWORK", nil, 2)
            iconBorder:SetPoint("TOPLEFT", 7, -7)
            iconBorder:SetSize(44, 44)
            iconBorder:SetTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\toasts\\toast-icon-border")
            iconBorder:SetTexCoord(1 / 64, 45 / 64, 1 / 64, 45 / 64)
            toast.IconBorder = iconBorder

            local text = toast:CreateFontString(nil, "ARTWORK", "GameFontHighlightOutline")
            text:SetPoint("BOTTOMRIGHT", toast.Icon, "BOTTOMRIGHT", 0, 2)
            text:SetJustifyH("RIGHT")
            toast.IconText = text

            toast.type = "misc"
        end
    end

    return toast
end

-- DND
function KT:PLAYER_REGEN_ENABLED()
    if IsDNDEnabled() and #queuedToasts > 0 then
        for _ = 1, KT.db.max_active_toasts - #activeToasts do
            RefreshToasts()
        end
    end
end

-- Achievement
local function AchievementToast_SetUp(achievementID, flag, isCriteria)
    local toast = GetToast("achievement")
    local _, name, points, _, _, _, _, _, _, icon = T.GetAchievementInfo(achievementID)

    if isCriteria then
        toast.Title:SetText(ACHIEVEMENT_PROGRESSED)
        toast.Text:SetText(flag)

        toast.Border:SetVertexColor(1, 1, 1)
        toast.IconBorder:SetVertexColor(1, 1, 1)
        toast.Points:SetText("")
    else
        toast.Title:SetText(ACHIEVEMENT_UNLOCKED)
        toast.Text:SetText(name)

        -- alreadyEarned
        if flag then
            toast.Border:SetVertexColor(1, 1, 1)
            toast.IconBorder:SetVertexColor(1, 1, 1)
            toast.Points:SetText("")
        else
            toast.Border:SetVertexColor(0.9, 0.75, 0.26)
            toast.IconBorder:SetVertexColor(0.9, 0.75, 0.26)
            toast.Points:SetText(points == 0 and "" or points)
        end
    end

    toast.Icon:SetTexture(icon)
    toast.id = achievementID

    KT:SpawnToast(toast, KT.db.dnd.achievement)
end

function KT:ACHIEVEMENT_EARNED(...)
    local _, achievementID, alreadyEarned = ...

    AchievementToast_SetUp(achievementID, alreadyEarned, nil)

end

function KT:CRITERIA_EARNED(...)
    local _, achievementID, criteriaString = ...

    AchievementToast_SetUp(achievementID, criteriaString, true)
end

local function EnableAchievementToasts()
    if KT.db.achievement_enabled then
        KT:RegisterEvent("ACHIEVEMENT_EARNED")
        KT:RegisterEvent("CRITERIA_EARNED")
    end
end

local function DisableAchievementToasts()
    KT:UnregisterEvent("ACHIEVEMENT_EARNED")
    KT:UnregisterEvent("CRITERIA_EARNED")
end

-- Archaeology
function KT:ARTIFACT_DIGSITE_COMPLETE(...)
    local _, researchFieldID = ...
    local raceName, raceTexture = T.GetArchaeologyRaceInfoByID(researchFieldID)
    local toast = GetToast("misc")

    toast.Border:SetVertexColor(0.9, 0.4, 0.1)
    toast.Title:SetText(ARCHAEOLOGY_DIGSITE_COMPLETE_TOAST_FRAME_TITLE)
    toast.Text:SetText(raceName)
    toast.BG:SetTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\toasts\\toast-bg-archaeology")
    toast.IconBorder:Hide()
    toast.Icon:SetPoint("TOPLEFT", 7, -3)
    toast.Icon:SetSize(76, 76)
    toast.Icon:SetTexture(raceTexture)
    toast.soundFile = SOUNDKIT.UI_DIG_SITE_COMPLETION_TOAST

    KT:SpawnToast(toast, KT.db.dnd.archaeology)
end

local function ArcheologyProgressBarAnimOut_OnFinished(self)
    self:GetParent():Hide()
end

local function EnableArchaeologyToasts()
    if not _G.ArchaeologyFrame then
        local hooked = false

        hooksecurefunc("ArchaeologyFrame_LoadUI", function()
                if not hooked then
                    _G.ArcheologyDigsiteProgressBar.AnimOutAndTriggerToast:SetScript("OnFinished", ArcheologyProgressBarAnimOut_OnFinished)

                    hooked = true
                end
            end)
    else
        _G.ArcheologyDigsiteProgressBar.AnimOutAndTriggerToast:SetScript("OnFinished", ArcheologyProgressBarAnimOut_OnFinished)
    end

    if KT.db.archaeology_enabled then
        KT:RegisterEvent("ARTIFACT_DIGSITE_COMPLETE")
    end
end

local function DisableArchaeologyToasts()
    KT:UnregisterEvent("ARTIFACT_DIGSITE_COMPLETE")
end

-- Garrison
local function GetGarrisonTypeByFollowerType(followerType)
	if followerType == LE_FOLLOWER_TYPE_GARRISON_8_0 then
		return LE_GARRISON_TYPE_8_0
    elseif followerType == LE_FOLLOWER_TYPE_GARRISON_7_0 then
        return LE_GARRISON_TYPE_7_0
    elseif followerType == LE_FOLLOWER_TYPE_GARRISON_6_0 or followerType == LE_FOLLOWER_TYPE_SHIPYARD_6_2 then
        return LE_GARRISON_TYPE_6_0
    end
end

local function GarrisonMissionToast_SetUp(followerType, garrisonType, missionID, isAdded)
    local toast = GetToast("mission")
    local missionInfo = T.C_Garrison_GetBasicMissionInfo(missionID)
    local color = missionInfo.isRare and ITEM_QUALITY_COLORS[3] or ITEM_QUALITY_COLORS[1]
    local level = missionInfo.iLevel == 0 and missionInfo.level or missionInfo.iLevel

    if isAdded then
        toast.Title:SetText(GARRISON_MISSION_ADDED_TOAST1)
    else
        toast.Title:SetText(GARRISON_MISSION_COMPLETE)
    end

    if KT.db.colored_names_enabled then
        toast.Text:SetTextColor(color.r, color.g, color.b)
    end

    toast.Text:SetText(missionInfo.name)
    toast.Level:SetText(level)
    toast.Border:SetVertexColor(color.r, color.g, color.b)
    toast.Icon:SetAtlas(missionInfo.typeAtlas, false)
    toast.soundFile = SOUNDKIT.UI_GARRISON_TOAST_MISSION_COMPLETE
    toast.id = missionID
	
	if garrisonType == LE_GARRISON_TYPE_8_0 then
		KT:SpawnToast(toast, KT.db.dnd.garrison_8_0)
	elseif garrisonType == LE_GARRISON_TYPE_7_0 then
		KT:SpawnToast(toast, KT.db.dnd.garrison_7_0)
	elseif garrisonType == LE_GARRISON_TYPE_6_0 then
		KT:SpawnToast(toast, KT.db.dnd.garrison_6_0)
	end
end

function KT:GARRISON_MISSION_FINISHED(...)
    local _, followerType, missionID = ...
    local garrisonType = GetGarrisonTypeByFollowerType(followerType)

    if (garrisonType == LE_GARRISON_TYPE_8_0 and not KT.db.garrison_8_0_enabled)
		or (garrisonType == LE_GARRISON_TYPE_7_0 and not KT.db.garrison_7_0_enabled)
		or (garrisonType == LE_GARRISON_TYPE_6_0 and not KT.db.garrison_6_0_enabled) then
		return
	end

    local _, instanceType = T.GetInstanceInfo()
    local validInstance = false

    if instanceType == "none" or T.C_Garrison_IsOnGarrisonMap() then
        validInstance = true
    end

    if validInstance then
        GarrisonMissionToast_SetUp(followerType, garrisonType, missionID)
    end
end

function KT:GARRISON_RANDOM_MISSION_ADDED(...)
    local _, followerType, missionID = ...
    local garrisonType = GetGarrisonTypeByFollowerType(followerType)

    if (garrisonType == LE_GARRISON_TYPE_8_0 and not KT.db.garrison_8_0_enabled)
		or (garrisonType == LE_GARRISON_TYPE_7_0 and not KT.db.garrison_7_0_enabled)
		or (garrisonType == LE_GARRISON_TYPE_6_0 and not KT.db.garrison_6_0_enabled) then
		return
	end

    GarrisonMissionToast_SetUp(followerType, garrisonType, missionID, true)
end

local function GarrisonFollowerToast_SetUp(followerType, garrisonType, followerID, name, texPrefix, level, quality, isUpgraded)
    local toast = GetToast("follower")
    local followerInfo = T.C_Garrison_GetFollowerInfo(followerID)
    local followerStrings = _G.GarrisonFollowerOptions[followerType].strings
    local upgradeTexture = LOOTUPGRADEFRAME_QUALITY_TEXTURES[quality] or LOOTUPGRADEFRAME_QUALITY_TEXTURES[2]
    local color = ITEM_QUALITY_COLORS[quality]

    if followerType == LE_FOLLOWER_TYPE_SHIPYARD_6_2 then
        toast.Icon:SetSize(84, 44)
        toast.Icon:SetAtlas(texPrefix.."-List", false)
        toast.Level:SetText("")
    else
        local portrait

        if followerInfo.portraitIconID and followerInfo.portraitIconID ~= 0 then
            portrait = followerInfo.portraitIconID
        else
            portrait = "Interface\\Garrison\\Portraits\\FollowerPortrait_NoPortrait"
        end

        toast.Icon:SetSize(44, 44)
        toast.Icon:SetTexture(portrait)
        toast.Level:SetText(level)
    end

    if isUpgraded then
        toast.Title:SetText(followerStrings.FOLLOWER_ADDED_UPGRADED_TOAST)
        toast.BG:SetTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\toasts\\toast-bg-upgrade")

        for i = 1, 5 do
            toast.Arrows["Arrow"..i]:SetAtlas(upgradeTexture.arrow, true)
        end

        toast.Arrows.requested = true
    else
        toast.Title:SetText(followerStrings.FOLLOWER_ADDED_TOAST)
    end

    if KT.db.colored_names_enabled then
        toast.Text:SetTextColor(color.r, color.g, color.b)
    end

    toast.Text:SetText(name)
    toast.Border:SetVertexColor(color.r, color.g, color.b)
    toast.soundFile = SOUNDKIT.UI_GARRISON_TOAST_FOLLOWER_GAINED
    toast.id = followerID

    if garrisonType == LE_GARRISON_TYPE_8_0 then
		KT:SpawnToast(toast, KT.db.dnd.garrison_8_0)
	elseif garrisonType == LE_GARRISON_TYPE_7_0 then
		KT:SpawnToast(toast, KT.db.dnd.garrison_7_0)
	elseif garrisonType == LE_GARRISON_TYPE_6_0 then
		KT:SpawnToast(toast, KT.db.dnd.garrison_6_0)
	end
end

function KT:GARRISON_FOLLOWER_ADDED(...)
    local _, followerID, name, _, level, quality, isUpgraded, texPrefix, followerType = ...
    local garrisonType = GetGarrisonTypeByFollowerType(followerType)

    if (garrisonType == LE_GARRISON_TYPE_8_0 and not KT.db.garrison_8_0_enabled)
		or (garrisonType == LE_GARRISON_TYPE_7_0 and not KT.db.garrison_7_0_enabled)
		or (garrisonType == LE_GARRISON_TYPE_6_0 and not KT.db.garrison_6_0_enabled) then
		return
	end

    GarrisonFollowerToast_SetUp(followerType, garrisonType, followerID, name, texPrefix, level, quality, isUpgraded)
end

function KT:GARRISON_BUILDING_ACTIVATABLE(...)
    local _, buildingName = ...
    local toast = GetToast("misc")

    toast.Title:SetText(GARRISON_UPDATE)
    toast.Text:SetText(buildingName)
    toast.Icon:SetTexture("Interface\\Icons\\Garrison_Build")
    toast.soundFile = SOUNDKIT.UI_GARRISON_TOAST_BUILDING_COMPLETE

    KT:SpawnToast(toast, KT.db.dnd.garrison_6_0)
end

function KT:GARRISON_TALENT_COMPLETE(...)
    local _, garrisonType = ...
    local talentID = T.C_Garrison_GetCompleteTalent(garrisonType)
    local talent = T.C_Garrison_GetTalent(talentID)
    local toast = GetToast("misc")

    toast.Title:SetText(GARRISON_TALENT_ORDER_ADVANCEMENT)
    toast.Text:SetText(talent.name)
    toast.Icon:SetTexture(talent.icon)
    toast.soundFile = SOUNDKIT.UI_ORDERHALL_TALENT_READY_TOAST
	
    if garrisonType == LE_GARRISON_TYPE_8_0 then
		KT:SpawnToast(toast, KT.db.dnd.garrison_8_0)
	elseif garrisonType == LE_GARRISON_TYPE_7_0 then
		KT:SpawnToast(toast, KT.db.dnd.garrison_7_0)
	end
end

local function EnableGarrisonToasts()
    if KT.db.garrison_8_0_enabled or KT.db.garrison_7_0_enabled or KT.db.garrison_6_0_enabled then
        KT:RegisterEvent("GARRISON_FOLLOWER_ADDED")
        KT:RegisterEvent("GARRISON_MISSION_FINISHED")
        KT:RegisterEvent("GARRISON_RANDOM_MISSION_ADDED")

        if KT.db.garrison_6_0_enabled then
            KT:RegisterEvent("GARRISON_BUILDING_ACTIVATABLE")
        end

        if KT.db.garrison_8_0_enabled or KT.db.garrison_7_0_enabled then
            KT:RegisterEvent("GARRISON_TALENT_COMPLETE")
        end
    end
end

local function DisableGarrisonToasts()
    if not KT.db.garrison_8_0_enabled and not KT.db.garrison_7_0_enabled or not KT.db.garrison_6_0_enabled then
        KT:UnregisterEvent("GARRISON_FOLLOWER_ADDED")
        KT:UnregisterEvent("GARRISON_MISSION_FINISHED")
        KT:UnregisterEvent("GARRISON_RANDOM_MISSION_ADDED")
    end

    if not KT.db.garrison_6_0_enabled then
        KT:UnregisterEvent("GARRISON_BUILDING_ACTIVATABLE")
    end

    if not KT.db.garrison_8_0_enabled or not KT.db.garrison_7_0_enabled then
        KT:UnregisterEvent("GARRISON_TALENT_COMPLETE")
    end
end

-- Instance
local function LFGToast_SetUp(isScenario)
    local toast = GetToast("scenario")
    -- local name, _, subtypeID, textureFilename, moneyBase, moneyVar, experienceBase, experienceVar, numStrangers, numRewards = T.GetLFGCompletionReward()
    local name, _, subtypeID, iconTextureFile, moneyBase, moneyVar, experienceBase, experienceVar, numStrangers, numRewards = T.GetLFGCompletionReward()
    -- local name, typeID, subtypeID, textureFilename, moneyBase, moneyVar, experienceBase, experienceVar, numStrangers, numRewards =
    -- "The Vortex Pinnacle", 1, 2, "THEVORTEXPINNACLE", 308000, 0, 0, 0, 0, 0
    local money = moneyBase + moneyVar * numStrangers
    local xp = experienceBase + experienceVar * numStrangers
    local title = DUNGEON_COMPLETED
    local usedRewards = 0

    if money > 0 then
        usedRewards = usedRewards + 1
        local reward = toast["Reward"..usedRewards]

        if reward then
            T.SetPortraitToTexture(reward.Icon, "Interface\\Icons\\inv_misc_coin_02")
            reward.money = money
            reward:Show()
        end
    end

    if xp > 0 and T.UnitLevel("player") < MAX_PLAYER_LEVEL then
        usedRewards = usedRewards + 1
        local reward = toast["Reward"..usedRewards]

        if reward then
            T.SetPortraitToTexture(reward.Icon, "Interface\\Icons\\xp_icon")
            reward.xp = xp
            reward:Show()
        end
    end

    for i = 1, numRewards do
        usedRewards = usedRewards + 1
        local reward = toast["Reward"..usedRewards]

        if reward then
            local icon = T.GetLFGCompletionRewardItem(i)
            local isOK = T.pcall(T.SetPortraitToTexture, reward.Icon, icon)

            if not isOK then
                T.SetPortraitToTexture(reward.Icon, "Interface\\Icons\\INV_Box_02")
            end

            reward.rewardID = i
            reward:Show()

            usedRewards = i
        end
    end

    if isScenario then
        local _, _, _, _, hasBonusStep, isBonusStepComplete = T.C_Scenario_GetInfo()

        if hasBonusStep and isBonusStepComplete then
            toast.Bonus:Show()
        end

        title = SCENARIO_COMPLETED
    end

    if subtypeID == LFG_SUBTYPEID_HEROIC then
        toast.Heroic:Show()
    end

    toast.Title:SetText(title)
    toast.Text:SetText(name)
    toast.BG:SetTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\toasts\\toast-bg-dungeon")
    -- toast.Icon:SetTexture("Interface\\LFGFrame\\LFGIcon-"..textureFilename)
    toast.Icon:SetTexture(iconTextureFile)
    toast.usedRewards = usedRewards

    if isScenario then
        toast.soundFile = SOUNDKIT.UI_SCENARIO_ENDING
    else
        toast.soundFile = SOUNDKIT.LFG_REWARDS
    end

    KT:SpawnToast(toast, KT.db.dnd.instance)
end

function KT:LFG_COMPLETION_REWARD()
    if T.C_Scenario_IsInScenario() and not T.C_Scenario_TreatScenarioAsDungeon() then

        if T.select(10, T.C_Scenario_GetInfo()) ~= LE_SCENARIO_TYPE_LEGION_INVASION then
            LFGToast_SetUp(true)
        end
    else
        LFGToast_SetUp()
    end
end

local function EnableInstanceToasts()
    if KT.db.instance_enabled then
        KT:RegisterEvent("LFG_COMPLETION_REWARD")
    end
end

local function DisableInstanceToasts()
    KT:UnregisterEvent("LFG_COMPLETION_REWARD")
end

-- Loot
local function LootWonToast_Setup(itemLink, quantity, rollType, roll, showFaction, isItem, isMoney, lessAwesome, isUpgraded, isPersonal)
    local toast

    if isItem then
        if itemLink then
            toast = GetToast("item")
            itemLink = ParseLink(itemLink)
            local title = YOU_WON_LABEL
            local soundFile = SOUNDKIT.UI_EPICLOOT_TOAST
            local name, _, quality, _, _, _, _, _, _, icon = T.GetItemInfo(itemLink)

            if isPersonal or lessAwesome then
                title = YOU_RECEIVED_LABEL

                if lessAwesome then
                    soundFile = SOUNDKIT.UI_RAID_LOOT_TOAST_LESSER_ITEM_WON
                end
            end

            if isUpgraded then
                soundFile = SOUNDKIT.UI_WARFORGED_ITEM_LOOT_TOAST
                title = ITEM_UPGRADED_LABEL
                local upgradeTexture = LOOTUPGRADEFRAME_QUALITY_TEXTURES[quality or 2]

                for i = 1, 5 do
                    toast.Arrows["Arrow"..i]:SetAtlas(upgradeTexture.arrow, true)
                end

                toast.Arrows.requested = true

                toast.BG:SetTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\toasts\\toast-bg-upgrade")
            end

            if rollType == LOOT_ROLL_TYPE_NEED then
                title = TITLE_NEED_TEMPLATE:format(title, roll)
            elseif rollType == LOOT_ROLL_TYPE_GREED then
                title = TITLE_GREED_TEMPLATE:format(title, roll)
            elseif rollType == LOOT_ROLL_TYPE_DISENCHANT then
                title = TITLE_DE_TEMPLATE:format(title, roll)
            end

            if showFaction then
                -- local factionGroup = "Horde"
                local factionGroup = T.UnitFactionGroup("player")

                toast.BG:SetTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\toasts\\toast-bg-"..factionGroup)
            end

            local color = ITEM_QUALITY_COLORS[quality or 1]

            if KT.db.colored_names_enabled then
                toast.Text:SetTextColor(color.r, color.g, color.b)
            end

            toast.Title:SetText(title)
            toast.Text:SetText(name)
            toast.Count:SetText(quantity > 1 and quantity or "")
            toast.Border:SetVertexColor(color.r, color.g, color.b)
            toast.IconBorder:SetVertexColor(color.r, color.g, color.b)
            toast.Icon:SetTexture(icon)
            toast.UpgradeIcon:SetShown(IsItemAnUpgrade(itemLink))
            toast.link = itemLink

            if lessAwesome then
                toast.soundFile = SOUNDKIT.UI_RAID_LOOT_TOAST_LESSER_ITEM_WON
            elseif isUpgraded then
                toast.soundFile = SOUNDKIT.UI_WARFORGED_ITEM_LOOT_TOAST
            else
                toast.soundFile = SOUNDKIT.UI_EPICLOOT_TOAST
            end
        end
    elseif isMoney then
        toast = GetToast("misc")

        toast.Border:SetVertexColor(0.9, 0.75, 0.26)
        toast.IconBorder:SetVertexColor(0.9, 0.75, 0.26)
        toast.Title:SetText(YOU_WON_LABEL)
        toast.Text:SetText(T.GetMoneyString(quantity))
        toast.Icon:SetTexture("Interface\\Icons\\INV_Misc_Coin_02")
        toast.soundFile = SOUNDKIT.UI_EPICLOOT_TOAST
    end

    if toast then
        KT:SpawnToast(toast, KT.db.dnd.loot_special)
    end
end

local function BonusRollFrame_FinishedFading_Disabled(self)
    local frame = self:GetParent()

    T.GroupLootContainer_RemoveFrame(_G.GroupLootContainer, frame)
end

local function BonusRollFrame_FinishedFading_Enabled(self)
    local frame = self:GetParent()

    LootWonToast_Setup(frame.rewardLink, frame.rewardQuantity, nil, nil, nil, frame.rewardType == "item", frame.rewardType == "money")
    T.GroupLootContainer_RemoveFrame(_G.GroupLootContainer, frame)
end

function KT:LOOT_ITEM_ROLL_WON(...)
    local _, itemLink, quantity, rollType, roll, isUpgraded = ...

    LootWonToast_Setup(itemLink, quantity, rollType, roll, nil, true, nil, nil, isUpgraded)
end

function KT:SHOW_LOOT_TOAST(...)
    local _, typeID, itemLink, quantity, _, _, isPersonal, _, lessAwesome, isUpgraded = ...

    LootWonToast_Setup(itemLink, quantity, nil, nil, nil, typeID == "item", typeID == "money", lessAwesome, isUpgraded, isPersonal)
end

function KT:SHOW_LOOT_TOAST_LEGENDARY_LOOTED(...)
    local _, itemLink = ...

    if itemLink then
        local toast = GetToast("item")
        itemLink = ParseLink(itemLink)
        local name, _, quality, _, _, _, _, _, _, icon = T.GetItemInfo(itemLink)
        local color = ITEM_QUALITY_COLORS[quality or 1]

        if KT.db.colored_names_enabled then
            toast.Text:SetTextColor(color.r, color.g, color.b)
        end

        toast.Title:SetText(LEGENDARY_ITEM_LOOT_LABEL)
        toast.Text:SetText(name)
        toast.BG:SetTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\toasts\\toast-bg-legendary")
        toast.Border:SetVertexColor(color.r, color.g, color.b)
        toast.IconBorder:SetVertexColor(color.r, color.g, color.b)
        toast.Count:SetText("")
        toast.Icon:SetTexture(icon)
        toast.UpgradeIcon:SetShown(IsItemAnUpgrade(itemLink))
        toast.Dragon:Show()
        toast.soundFile = SOUNDKIT.UI_LEGENDARY_LOOT_TOAST
        toast.link = itemLink

        KT:SpawnToast(toast, KT.db.dnd.loot_special)
    end
end

function KT:SHOW_LOOT_TOAST_UPGRADE(...)
    local _, itemLink, quantity = ...

    if itemLink then
        local toast = GetToast("item")
        itemLink = ParseLink(itemLink)
        local name, _, quality, _, _, _, _, _, _, icon = T.GetItemInfo(itemLink)
        local upgradeTexture = LOOTUPGRADEFRAME_QUALITY_TEXTURES[quality or 2]
        local color = ITEM_QUALITY_COLORS[quality or 1]

        if KT.db.colored_names_enabled then
            toast.Text:SetTextColor(color.r, color.g, color.b)
        end

        toast.Title:SetText(color.hex..T.string_format(LOOTUPGRADEFRAME_TITLE, _G["ITEM_QUALITY"..quality.."_DESC"]).."|r")
        toast.Text:SetText(name)
        toast.Count:SetText(quantity > 1 and quantity or "")
        toast.BG:SetTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\toasts\\toast-bg-upgrade")
        toast.Border:SetVertexColor(color.r, color.g, color.b)
        toast.IconBorder:SetVertexColor(color.r, color.g, color.b)
        toast.Icon:SetTexture(icon)
        toast.UpgradeIcon:SetShown(IsItemAnUpgrade(itemLink))
        toast.soundFile = SOUNDKIT.UI_WARFORGED_ITEM_LOOT_TOAST
        toast.link = itemLink

        for i = 1, 5 do
            toast.Arrows["Arrow"..i]:SetAtlas(upgradeTexture.arrow, true)
        end

        toast.Arrows.requested = true

        KT:SpawnToast(toast, KT.db.dnd.loot_special)
    end
end

function KT:SHOW_PVP_FACTION_LOOT_TOAST(...)
    local _, typeID, itemLink, quantity, _, _, isPersonal, lessAwesome = ...

    LootWonToast_Setup(itemLink, quantity, nil, nil, true, typeID == "item", typeID == "money", lessAwesome, nil, isPersonal)
end

function KT:SHOW_RATED_PVP_REWARD_TOAST(...)
    local _, typeID, itemLink, quantity, _, _, isPersonal, lessAwesome = ...

    LootWonToast_Setup(itemLink, quantity, nil, nil, true, typeID == "item", typeID == "money", lessAwesome, nil, isPersonal)
end

function KT:STORE_PRODUCT_DELIVERED(...)
    local _, _, icon, _, payloadID = ...
    local name, _, quality = T.GetItemInfo(payloadID)
    local color = ITEM_QUALITY_COLORS[quality or 4]
    local toast = GetToast("item")

    if KT.db.colored_names_enabled then
        toast.Text:SetTextColor(color.r, color.g, color.b)
    end

    toast.Title:SetText(BLIZZARD_STORE_PURCHASE_COMPLETE)
    toast.Text:SetText(name)
    toast.BG:SetTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\toasts\\toast-bg-store")
    toast.Border:SetVertexColor(color.r, color.g, color.b)
    toast.IconBorder:SetVertexColor(color.r, color.g, color.b)
    toast.Icon:SetTexture(icon)
    toast.soundFile = SOUNDKIT.UI_IG_STORE_PURCHASE_DELIVERED_TOAST_01
    toast.id = payloadID

    KT:SpawnToast(toast, KT.db.dnd.loot_special)
end

local function EnableSpecialLootToasts()
    if KT.db.loot_special_enabled then
        KT:RegisterEvent("LOOT_ITEM_ROLL_WON")
        KT:RegisterEvent("SHOW_LOOT_TOAST")
        KT:RegisterEvent("SHOW_LOOT_TOAST_LEGENDARY_LOOTED")
        KT:RegisterEvent("SHOW_LOOT_TOAST_UPGRADE")
        KT:RegisterEvent("SHOW_PVP_FACTION_LOOT_TOAST")
        KT:RegisterEvent("SHOW_RATED_PVP_REWARD_TOAST")
        KT:RegisterEvent("STORE_PRODUCT_DELIVERED")

        _G.BonusRollFrame.FinishRollAnim:SetScript("OnFinished", BonusRollFrame_FinishedFading_Enabled)
    else
        _G.BonusRollFrame.FinishRollAnim:SetScript("OnFinished", BonusRollFrame_FinishedFading_Disabled)
    end
end

local function DisableSpecialLootToasts()
    KT:UnregisterEvent("LOOT_ITEM_ROLL_WON")
    KT:UnregisterEvent("SHOW_LOOT_TOAST")
    KT:UnregisterEvent("SHOW_LOOT_TOAST_LEGENDARY_LOOTED")
    KT:UnregisterEvent("SHOW_LOOT_TOAST_UPGRADE")
    KT:UnregisterEvent("SHOW_PVP_FACTION_LOOT_TOAST")
    KT:UnregisterEvent("SHOW_RATED_PVP_REWARD_TOAST")
    KT:UnregisterEvent("STORE_PRODUCT_DELIVERED")

    _G.BonusRollFrame.FinishRollAnim:SetScript("OnFinished", BonusRollFrame_FinishedFading_Disabled)
end

local LOOT_ITEM_PATTERN = (LOOT_ITEM_SELF):gsub("%%s", "(.+)")
local LOOT_ITEM_PUSHED_PATTERN = (LOOT_ITEM_PUSHED_SELF):gsub("%%s", "(.+)")
local LOOT_ITEM_MULTIPLE_PATTERN = (LOOT_ITEM_SELF_MULTIPLE):gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)")
local LOOT_ITEM_PUSHED_MULTIPLE_PATTERN = (LOOT_ITEM_PUSHED_SELF_MULTIPLE):gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)")

local function LootCommonToast_Setup(itemLink, quantity)
    itemLink = ParseLink(itemLink)

    if not GetToastToUpdate(itemLink, "item") then
        local name, quality, icon, _

        if T.string_find(itemLink, "battlepet:") then
            local _, speciesID, _, breedQuality = T.string_split(":", itemLink)
            name, icon = T.C_PetJournal_GetPetInfoBySpeciesID(speciesID)
            quality = T.tonumber(breedQuality)
        else
            name, _, quality, _, _, _, _, _, _, icon = T.GetItemInfo(itemLink)
        end

        if quality >= KT.db.loot_common_quality_threshold then
            local toast = GetToast("item")
            local color = ITEM_QUALITY_COLORS[quality or 4]

            if KT.db.colored_names_enabled then
                toast.Text:SetTextColor(color.r, color.g, color.b)
            end

            toast.Title:SetText(YOU_RECEIVED_LABEL)
            toast.Text:SetText(name)
            toast.Count:SetText(quantity > 1 and quantity or "")
            toast.Border:SetVertexColor(color.r, color.g, color.b)
            toast.IconBorder:SetVertexColor(color.r, color.g, color.b)
            toast.Icon:SetTexture(icon)
            toast.link = itemLink
            toast.chat = true

            KT:SpawnToast(toast, KT.db.dnd.loot_common)
        end
    end
end

function KT:CHAT_MSG_LOOT(event, message)
    local itemLink, quantity = message:match(LOOT_ITEM_MULTIPLE_PATTERN)

    if not itemLink then
        itemLink, quantity = message:match(LOOT_ITEM_PUSHED_MULTIPLE_PATTERN)

        if not itemLink then
            quantity, itemLink = 1, message:match(LOOT_ITEM_PATTERN)

            if not itemLink then
                quantity, itemLink = 1, message:match(LOOT_ITEM_PUSHED_PATTERN)

                if not itemLink then
                    return
                end
            end
        end
    end

    quantity = T.tonumber(quantity) or 0

    T.C_Timer_After(0.125, function() LootCommonToast_Setup(itemLink, quantity) end)
end

local function EnableCommonLootToasts()
    if KT.db.loot_common_enabled then
        KT:RegisterEvent("CHAT_MSG_LOOT")
    end
end

local function DisableCommonLootToasts()
    KT:UnregisterEvent("CHAT_MSG_LOOT")
end

local CURRENCY_GAINED_PATTERN = (CURRENCY_GAINED):gsub("%%s", "(.+)")
local CURRENCY_GAINED_MULTIPLE_PATTERN = (CURRENCY_GAINED_MULTIPLE):gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)")

function KT:CHAT_MSG_CURRENCY(event, message)
    local itemLink, quantity = message:match(CURRENCY_GAINED_MULTIPLE_PATTERN)

    if not itemLink then
        quantity, itemLink = 1, message:match(CURRENCY_GAINED_PATTERN)

        if not itemLink then
            return
        end
    end

    itemLink = T.string_match(itemLink, "|H(.+)|h.+|h")
    quantity = T.tonumber(quantity) or 0

    local toast, isQueued = GetToastToUpdate(itemLink, "item")
    local isUpdated = true

    if not toast then
        toast = GetToast("item")
        isUpdated = false
    end

    if not isUpdated then
        local name, _, icon, _, _, _, _, quality = T.GetCurrencyInfo(itemLink)
        local color = ITEM_QUALITY_COLORS[quality or 1]

        if KT.db.colored_names_enabled then
            toast.Text:SetTextColor(color.r, color.g, color.b)
        end

        toast.Title:SetText(YOU_RECEIVED_LABEL)
        toast.Text:SetText(name)
        toast.Count:SetText(quantity > 1 and quantity or "")
        toast.Border:SetVertexColor(color.r, color.g, color.b)
        toast.IconBorder:SetVertexColor(color.r, color.g, color.b)
        toast.Icon:SetTexture(icon)
        toast.soundFile = SOUNDKIT.UI_EPICLOOT_TOAST
        toast.itemCount = quantity
        toast.link = itemLink

        KT:SpawnToast(toast, KT.db.dnd.loot_currency)
    else
        if isQueued then
            toast.itemCount = toast.itemCount + quantity
            toast.Count:SetText(toast.itemCount)
        else
            toast.itemCount = toast.itemCount + quantity
			--toast.Count:SetAnimatedText(toast.itemCount)
            toast.Count:SetAnimatedValue(toast.itemCount)

            toast.CountUpdate:SetText("+"..quantity)
            toast.CountUpdateAnim:Stop()
            toast.CountUpdateAnim:Play()

            toast.AnimOut:Stop()
            toast.AnimOut:Play()
        end
    end
end

local function EnableCurrencyLootToasts()
    if KT.db.loot_currency_enabled then
        KT:RegisterEvent("CHAT_MSG_CURRENCY")
    end
end

local function DisableCurrencyLootToasts()
    KT:UnregisterEvent("CHAT_MSG_CURRENCY")
end

--[[
local old -- Start gold
local function PostSetAnimatedValue(self, value)
	self:SetText(GetMoneyString(value, true))
end

local function LootGoldToast_SetUp(event, quantity)
	
	local toast, isQueued = GetToastToUpdate(itemLink, "item")
    local isUpdated = true

    if not toast then
        toast = GetToast("item")
        isUpdated = false
    end

    if not isUpdated then
		if quantity >= KT.db.loot_gold_threshold then
			toast.Text.PostSetAnimatedValue = PostSetAnimatedValue

			toast.Title:SetText(L["You Received"])
			toast.Text:SetAnimatedValue(quantity, true)
			toast.Icon:SetTexture("Interface\\Icons\\INV_Misc_Coin_02")
			toast.IconBorder:Show()

			toast.count = quantity
			toast.event = event

			KT:SpawnToast(toast, KT.db.dnd.loot_gold)
		else
			RecycleToast()
		end
	else
		if isQueued then
			toast.count = toast.count + quantity
			toast.Text:SetAnimatedValue(toast.count, true)
		else
			toast.count = toast.count + quantity
			toast.Text:SetAnimatedValue(toast.count)

			toast.AnimOut:Stop()
			toast.AnimOut:Play()
		end
	end
end

function KT:PLAYER_MONEY()
	local cur = T.GetMoney()

	if cur - old > 0 then
		LootGoldToast_SetUp("PLAYER_MONEY", cur - old)
	end

	old = cur
end

local function EnableGoldLootToasts()
    if KT.db.loot_gold_enabled then
		old = T.GetMoney()
		
        KT:RegisterEvent("PLAYER_MONEY")
    end
end

local function DisableGoldLootToasts()
    KT:UnregisterEvent("PLAYER_MONEY")
end
]]
-- Recipe
function KT:NEW_RECIPE_LEARNED(...)
    local _, recipeID = ...
    local tradeSkillID = T.C_TradeSkillUI_GetTradeSkillLineForRecipe(recipeID)

    if tradeSkillID then
        local recipeName = T.GetSpellInfo(recipeID)

        if recipeName then
            local toast = GetToast("ability")
            local rank = T.GetSpellRank(recipeID)
            local rankTexture = ""

            if rank == 1 then
                rankTexture = "|TInterface\\LootFrame\\toast-star:12:12:0:0:32:32:0:21:0:21|t"
            elseif rank == 2 then
                rankTexture = "|TInterface\\LootFrame\\toast-star-2:12:24:0:0:64:32:0:42:0:21|t"
            elseif rank == 3 then
                rankTexture = "|TInterface\\LootFrame\\toast-star-3:12:36:0:0:64:32:0:64:0:21|t"
            end

            toast.Title:SetText(rank and rank > 1 and UPGRADED_RECIPE_LEARNED_TITLE or NEW_RECIPE_LEARNED_TITLE)
            toast.Text:SetText(recipeName)
            toast.BG:SetTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\toasts\\toast-bg-recipe")
            toast.Rank:SetText(rankTexture)
            toast.RankBG:SetShown(not not rank)
            toast.Icon:SetTexture(T.C_TradeSkillUI_GetTradeSkillTexture(tradeSkillID))
            toast.soundFile = SOUNDKIT.UI_PROFESSIONS_NEW_RECIPE_LEARNED_TOAST
            toast.id = recipeID

            KT:SpawnToast(toast, KT.db.dnd.recipe)
        end
    end
end

local function EnableRecipeToasts()
    if KT.db.recipe_enabled then
        KT:RegisterEvent("NEW_RECIPE_LEARNED")
    end
end

local function DisableRecipeToasts()
    KT:UnregisterEvent("NEW_RECIPE_LEARNED")
end

-- World
local function InvasionToast_SetUp(questID, name, moneyReward, xpReward, numCurrencyRewards, isInvasion, isInvasionBonusComplete)
    if GetToastToUpdate(questID, "scenario") then
        return
    end

    local toast = GetToast("scenario")
    local usedRewards = 0

    if moneyReward and moneyReward > 0 then
        usedRewards = usedRewards + 1
        local reward = toast["Reward"..usedRewards]

        if reward then
            T.SetPortraitToTexture(reward.Icon, "Interface\\Icons\\inv_misc_coin_02")
            reward.money = moneyReward
            reward:Show()
        end
    end

    if xpReward and xpReward > 0 and T.UnitLevel("player") < MAX_PLAYER_LEVEL then
        usedRewards = usedRewards + 1
        local reward = toast["Reward"..usedRewards]

        if reward then
            T.SetPortraitToTexture(reward.Icon, "Interface\\Icons\\xp_icon")
            reward.xp = xpReward
            reward:Show()
        end
    end

    for i = 1, numCurrencyRewards or 0 do
			usedRewards = usedRewards + 1
			local reward = toast["Reward"..usedRewards]

			if reward then
				local _, texture = T.GetQuestLogRewardCurrencyInfo(i, questID)
				local isOK = T.pcall(T.SetPortraitToTexture, reward.Icon, texture)

				if not isOK then
					T.SetPortraitToTexture(reward.Icon, "Interface\\Icons\\INV_Box_02")
				end

				reward.currency = i
				reward:Show()
			end
		end

    if isInvasionBonusComplete then
        toast.Bonus:Show()
    end

    toast.Title:SetText(SCENARIO_INVASION_COMPLETE)
    toast.Text:SetText(name)
    toast.BG:SetTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\toasts\\toast-bg-legion")
    toast.Icon:SetTexture("Interface\\Icons\\Ability_Warlock_DemonicPower")
    toast.Border:SetVertexColor(60 / 255, 255 / 255, 38 / 255) -- fel green #3cff26
    toast.IconBorder:SetVertexColor(60 / 255, 255 / 255, 38 / 255) -- fel green #3cff26
    toast.usedRewards = usedRewards
    toast.soundFile = SOUNDKIT.UI_SCENARIO_ENDING
    toast.id = questID

    KT:SpawnToast(toast, KT.db.dnd.world)
end

local function WorldQuestToast_SetUp(questID)
    -- XXX: To avoid possible spam
    if GetToastToUpdate(questID, "scenario") then
        return
    end

    local toast = GetToast("scenario")
    local _, _, _, taskName = T.GetTaskInfo(questID)
    local _, _, worldQuestType, rarity, _, tradeskillLineIndex = T.GetQuestTagInfo(questID)
    local color = WORLD_QUEST_QUALITY_COLORS[rarity] or WORLD_QUEST_QUALITY_COLORS[1]
    local money = T.GetQuestLogRewardMoney(questID)
    local xp = T.GetQuestLogRewardXP(questID)
    local usedRewards = 0
    local icon = "Interface\\Icons\\Achievement_Quests_Completed_TwilightHighlands"

    if money > 0 then
        usedRewards = usedRewards + 1
        local reward = toast["Reward"..usedRewards]

        if reward then
            T.SetPortraitToTexture(reward.Icon, "Interface\\Icons\\inv_misc_coin_02")
            reward.money = money
            reward:Show()
        end
    end

    if xp > 0 and T.UnitLevel("player") < MAX_PLAYER_LEVEL then
        usedRewards = usedRewards + 1
        local reward = toast["Reward"..usedRewards]

        if reward then
            T.SetPortraitToTexture(reward.Icon, "Interface\\Icons\\xp_icon")
            reward.xp = xp
            reward:Show()
        end
    end

    for i = 1, T.GetNumQuestLogRewardCurrencies(questID) do
        usedRewards = usedRewards + 1
        local reward = toast["Reward"..usedRewards]

        if reward then
            local _, texture = T.GetQuestLogRewardCurrencyInfo(i, questID)
            local isOK = T.pcall(T.SetPortraitToTexture, reward.Icon, texture)

            if not isOK then
                T.SetPortraitToTexture(reward.Icon, "Interface\\Icons\\INV_Box_02")
            end

            reward.currency = i
            reward:Show()
        end
    end

    if worldQuestType == LE_QUEST_TAG_TYPE_PVP then
		toast.Icon:SetTexture("Interface\\Icons\\achievement_arena_2v2_1")
	elseif worldQuestType == LE_QUEST_TAG_TYPE_PET_BATTLE then
		toast.Icon:SetTexture("Interface\\Icons\\INV_Pet_BattlePetTraining")
	elseif worldQuestType == LE_QUEST_TAG_TYPE_PROFESSION and tradeskillLineIndex then
		toast.Icon:SetTexture(T.select(2, T.GetProfessionInfo(tradeskillLineIndex)))
	elseif worldQuestType == LE_QUEST_TAG_TYPE_DUNGEON or worldQuestType == LE_QUEST_TAG_TYPE_RAID then
		toast.Icon:SetTexture("Interface\\Icons\\INV_Misc_Bone_Skull_02")
	else
		toast.Icon:SetTexture("Interface\\Icons\\Achievement_Quests_Completed_TwilightHighlands")
	end
	
    if KT.db.colored_names_enabled then
        toast.Text:SetTextColor(color.r, color.g, color.b)
    end

    toast.Title:SetText(WORLD_QUEST_COMPLETE)
    toast.Text:SetText(taskName)
    toast.BG:SetTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\toasts\\toast-bg-worldquest")
    toast.Icon:SetTexture(icon)
    toast.Border:SetVertexColor(color.r, color.g, color.b)
    toast.IconBorder:SetVertexColor(color.r, color.g, color.b)
    toast.usedRewards = usedRewards
    toast.soundFile = SOUNDKIT.UI_WORLDQUEST_COMPLETE
    toast.id = questID

    KT:SpawnToast(toast, KT.db.dnd.world)
end

function KT:SCENARIO_COMPLETED(...)
    if T.select(10, T.C_Scenario.GetInfo()) == LE_SCENARIO_TYPE_LEGION_INVASION then
        local _, questID = ...

        if questID then
            InvasionToast_SetUp(questID)
        end
    end
end

function KT:QUEST_TURNED_IN(...)
    local _, questID = ...

    if T.QuestUtils_IsQuestWorldQuest(questID) then
        WorldQuestToast_SetUp(questID)
    end
end

function KT:QUEST_LOOT_RECEIVED(...)
    local _, questID, itemLink = ...

    --- XXX: QUEST_LOOT_RECEIVED may fire before QUEST_TURNED_IN
    if T.QuestUtils_IsQuestWorldQuest(questID) then
        if not GetToastToUpdate(questID, "scenario") then
            WorldQuestToast_SetUp(questID)
        end
    end

    UpdateToast(questID, "scenario", itemLink)
end

local function EnableWorldToasts()
    if KT.db.world_enabled then
        KT:RegisterEvent("SCENARIO_COMPLETED")
        KT:RegisterEvent("QUEST_TURNED_IN")
        KT:RegisterEvent("QUEST_LOOT_RECEIVED")
    end
end

local function DisableWorldToasts()
    KT:UnregisterEvent("SCENARIO_COMPLETED")
    KT:UnregisterEvent("QUEST_TURNED_IN")
    KT:UnregisterEvent("QUEST_LOOT_RECEIVED")
end

-- Transmog
local function IsAppearanceKnown(sourceID)
    local data = T.C_TransmogCollection_GetSourceInfo(sourceID)
    local sources = T.C_TransmogCollection_GetAppearanceSources(data.visualID)

    if sources then
        for i = 1, #sources do
            if sources[i].isCollected and sourceID ~= sources[i].sourceID then
                return true
            end
        end
    else
        return nil
    end

    return false
end

local function TransmogToast_SetUp(sourceID, isAdded)
    local _, _, _, icon, _, _, transmogLink = T.C_TransmogCollection_GetAppearanceSourceInfo(sourceID)
    local name
    transmogLink, name = T.string_match(transmogLink, "|H(.+)|h%[(.+)%]|h")

    if not transmogLink then
        return T.C_Timer_After(0.25, function() TransmogToast_SetUp(sourceID, isAdded) end)
    end

    local toast = GetToast("misc")

    if isAdded then
        toast.Title:SetText("Appearance Added")
    else
        toast.Title:SetText("Appearance Removed")
    end

    toast.Text:SetText(name)
    toast.BG:SetTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\toasts\\toast-bg-transmog")
    toast.Border:SetVertexColor(1, 128 / 255, 1)
    toast.IconBorder:SetVertexColor(1, 128 / 255, 1)
    toast.Icon:SetTexture(icon)
    toast.soundFile = SOUNDKIT.UI_DIG_SITE_COMPLETION_TOAST
    toast.id = sourceID
    toast.link = transmogLink

    KT:SpawnToast(toast, KT.db.dnd.transmog)
end

function KT:TRANSMOG_COLLECTION_SOURCE_ADDED(event, sourceID)
    local isKnown = IsAppearanceKnown(sourceID)

    if isKnown == false then
        TransmogToast_SetUp(sourceID, true)
    elseif isKnown == nil then
        T.C_Timer_After(0.25, function() KT:TRANSMOG_COLLECTION_SOURCE_ADDED("", sourceID) end)
    end
end

function KT:TRANSMOG_COLLECTION_SOURCE_REMOVED(event, sourceID)
    local isKnown = IsAppearanceKnown(sourceID)

    if isKnown == false then
        TransmogToast_SetUp(sourceID)
    elseif isKnown == nil then
        T.C_Timer_After(0.25, function() KT:TRANSMOG_COLLECTION_SOURCE_REMOVED("", sourceID) end)
    end
end

local function EnableTransmogToasts()
    if KT.db.transmog_enabled then
        KT:RegisterEvent("TRANSMOG_COLLECTION_SOURCE_ADDED")
        KT:RegisterEvent("TRANSMOG_COLLECTION_SOURCE_REMOVED")
    end
end

local function DisableTransmogToasts()
    KT:UnregisterEvent("TRANSMOG_COLLECTION_SOURCE_ADDED")
    KT:UnregisterEvent("TRANSMOG_COLLECTION_SOURCE_REMOVED")
end

-- Tests
local function SpawnTestGarrisonToast()
    -- follower
    local followers = T.C_Garrison_GetFollowers(LE_FOLLOWER_TYPE_GARRISON_6_0)
    local follower = followers and followers[1]

    if follower then
        GarrisonFollowerToast_SetUp(follower.followerTypeID, LE_GARRISON_TYPE_6_0, follower.followerID, follower.name, nil, follower.level, follower.quality, false)
    end

    -- ship
    followers = T.C_Garrison_GetFollowers(LE_FOLLOWER_TYPE_SHIPYARD_6_2)
    follower = followers and followers[1]

    if follower then
        GarrisonFollowerToast_SetUp(follower.followerTypeID, LE_GARRISON_TYPE_6_0, follower.followerID, follower.name, follower.texPrefix, follower.level, follower.quality, false)
    end

    -- garrison mission
    local missions = T.C_Garrison_GetAvailableMissions(LE_FOLLOWER_TYPE_GARRISON_6_0)
    local id = missions and (missions[1] and missions[1].missionID or nil) or nil

    if id then
        GarrisonMissionToast_SetUp(LE_FOLLOWER_TYPE_GARRISON_6_0, LE_GARRISON_TYPE_6_0, id)
    end

    -- shipyard mission
    missions = T.C_Garrison_GetAvailableMissions(LE_FOLLOWER_TYPE_SHIPYARD_6_2)
    id = missions and (missions[1] and missions[1].missionID or nil) or nil

    if id then
        GarrisonMissionToast_SetUp(LE_FOLLOWER_TYPE_SHIPYARD_6_2, LE_GARRISON_TYPE_6_0, id)
    end

    -- garrison building
    KT:GARRISON_BUILDING_ACTIVATABLE("Storehouse")
end

local function SpawnTestClassHallToast()
    -- champion
    local followers = T.C_Garrison_GetFollowers(LE_FOLLOWER_TYPE_GARRISON_7_0)
    local follower = followers and followers[1]

    if follower then
        GarrisonFollowerToast_SetUp(follower.followerTypeID, LE_GARRISON_TYPE_7_0, follower.followerID, follower.name, nil, follower.level, follower.quality, false)
    end

    -- order hall mission
    local missions = T.C_Garrison_GetAvailableMissions(LE_FOLLOWER_TYPE_GARRISON_7_0)
    local id = missions and (missions[1] and missions[1].missionID or nil) or nil

    if id then
        GarrisonMissionToast_SetUp(LE_FOLLOWER_TYPE_GARRISON_7_0, LE_GARRISON_TYPE_7_0, id)
    end
end

local function SpawnTestWarEffortToast()
    -- champion
    local followers = T.C_Garrison_GetFollowers(LE_FOLLOWER_TYPE_GARRISON_8_0)
    local follower = followers and followers[1]

    if follower then
        GarrisonFollowerToast_SetUp(follower.followerTypeID, LE_GARRISON_TYPE_8_0, follower.followerID, follower.name, nil, follower.level, follower.quality, false)
    end

    -- war effort mission
    local missions = T.C_Garrison_GetAvailableMissions(LE_FOLLOWER_TYPE_GARRISON_8_0)
    local id = missions and (missions[1] and missions[1].missionID or nil) or nil

    if id then
        GarrisonMissionToast_SetUp(LE_FOLLOWER_TYPE_GARRISON_8_0, LE_GARRISON_TYPE_8_0, id)
    end
end

local function SpawnTestAchievementToast()
    -- new
    KT:ACHIEVEMENT_EARNED("", 545, false)

    -- already earned
    KT:ACHIEVEMENT_EARNED("", 9828, true)
end

local function SpawnTestRecipeToast()
    KT:NEW_RECIPE_LEARNED("", 7183)
end

local function SpawnTestArchaeologyToast()
    KT:ARTIFACT_DIGSITE_COMPLETE("", 408)
end

local function SpawnTestWorldEventToast()
    -- invasion in Azshara
    local _, link = T.GetItemInfo(139049)

    if link then
        WorldQuestToast_SetUp(41662)
        UpdateToast(41662, "scenario", link)
    else
        T.C_Timer_After(0.25, SpawnTestWorldEventToast)
    end
end

local function SpawnTestLootToast()
    -- money
    KT:SHOW_LOOT_TOAST("", "money", nil, 12345678, 0, 2, false, 0, false, false)

    -- legendary
    local _, link = T.GetItemInfo(132452)

    if link then
        KT:SHOW_LOOT_TOAST_LEGENDARY_LOOTED("", link)
    end

    _, link = T.GetItemInfo(140715)

    -- faction
    if link then
        KT:SHOW_PVP_FACTION_LOOT_TOAST("", "item", link, 1)
    end

    -- roll won
    if link then
        KT:LOOT_ITEM_ROLL_WON("", link, 1, 1, 58, false)
    end

    _, link = T.GetItemInfo("|cffa335ee|Hitem:121641::::::::110:70:512:11:2:664:1737:108:::|h[Radiant Charm of Elune]|h|r")

    -- upgrade
    if link then
        KT:SHOW_LOOT_TOAST_UPGRADE("", link, 1)
    end

    -- store
    KT:STORE_PRODUCT_DELIVERED("", 1, 915544, T.GetItemInfo(105911), 105911)
end

local function SpawnTestCurrencyToast()
    -- currency
    local link, _ = T.GetCurrencyLink(824)

    if link then
        KT:CHAT_MSG_CURRENCY("", T.string_format(CURRENCY_GAINED_MULTIPLE, link, T.math_random(300, 600)))
    end
end

local function SpawnTestTransmogToast()
    local appearance = T.C_TransmogCollection_GetCategoryAppearances(1) and T.C_TransmogCollection_GetCategoryAppearances(1)[1]
    local source = T.C_TransmogCollection_GetAppearanceSources(appearance.visualID) and T.C_TransmogCollection_GetAppearanceSources(appearance.visualID)[1]

    TransmogToast_SetUp(source.sourceID, true)
    TransmogToast_SetUp(source.sourceID)
end

-- Loading
local function SpawnTestToast()
    if not T.DevTools_Dump then
        T.UIParentLoadAddOn("Blizzard_DebugTools")
    end

    SpawnTestGarrisonToast()

    SpawnTestAchievementToast()

    SpawnTestRecipeToast()

    SpawnTestArchaeologyToast()

    SpawnTestLootToast()

    SpawnTestWorldEventToast()

    SpawnTestTransmogToast()
end

function KT:PostAlertMove()
    _G.AlertFrame:ClearAllPoints()
    _G.AlertFrame:SetPoint("CENTER", E.UIParent, "CENTER", 0, 60)
end

function KT:Initialize()
	if not E.db.KlixUI.toasts.enable or T.IsAddOnLoaded('ls_Toasts') then return end

	KT.db = E.db.KlixUI.toasts
	
	KUI:RegisterDB(self, "toasts")
	
	anchorFrame = T.CreateFrame("Frame", nil, E.UIParent)
	anchorFrame:SetSize(234 * KT.db.scale, 58 * KT.db.scale)
	anchorFrame:SetPoint("TOP", 0, -215)
	E:CreateMover(anchorFrame, "Toast Mover", L["Toasts"], nil, nil, nil, "ALL,SOLO,KLIXUI", nil, "KlixUI,modules,toasts")
	
    UIPARENT_MANAGED_FRAME_POSITIONS["GroupLootContainer"] = nil
    self:SecureHook(_G.AlertFrame, "UpdateAnchors", "PostAlertMove")
    self:PostAlertMove()
    _G.GroupLootContainer:ClearAllPoints()
    _G.GroupLootContainer:SetPoint("CENTER", E.UIParent, "CENTER", 0, 100)

    EnableAchievementToasts()
    EnableArchaeologyToasts()
    EnableGarrisonToasts()
    EnableInstanceToasts()
    EnableSpecialLootToasts()
    EnableCommonLootToasts()
    EnableCurrencyLootToasts()
	--EnableGoldLootToasts()
    EnableRecipeToasts()
    EnableWorldToasts()
    EnableTransmogToasts()

    for event in T.next, BLACKLISTED_EVENTS do
		_G.AlertFrame:UnregisterEvent(event)
    end

    hooksecurefunc(_G.AlertFrame, "RegisterEvent", function(self, event)
        if event and BLACKLISTED_EVENTS[event] then
			self:UnregisterEvent(event)
		end
    end)

    KT:RegisterEvent("PLAYER_REGEN_ENABLED")
	
    _G.SLASH_KTADDTOAST1 = "/testtoasts"
	_G.SLASH_KTADDTOAST2 = "/tt"
    _G.SlashCmdList["KTADDTOAST"] = SpawnTestToast
end

local function InitializeCallback()
	KT:Initialize()
end

KUI:RegisterModule(KT:GetName(), InitializeCallback)