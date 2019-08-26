local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local ABS = KUI:NewModule("AutoButtons", "AceEvent-3.0")
local LSM = E.LSM or E.Libs.LSM

local QuestItemList = {}
local garrisonsmv = {118897, 118903}
local garrisonsc = {114116, 114119, 114120, 120301, 120302}

BINDING_HEADER_KLIXUI_AutoSlotButton = KUI.Title.. L["Auto InventoryItem Button"]
BINDING_HEADER_KLIXUI_AutoQuestButton = KUI.Title.. L["Auto QuestItem Button"]

for i = 1, 12 do
	_G["BINDING_NAME_CLICK AutoSlotButton"..i..":LeftButton"] = L["Auto InventoryItem Button"]..i
	_G["BINDING_NAME_CLICK AutoQuestButton"..i..":LeftButton"] = L["Auto QuestItem Button"]..i
end

local function GetQuestItemList()
    T.table_wipe(QuestItemList)
    for i = 1, T.GetNumQuestWatches() do
        local questID, title, questLogIndex, numObjectives, requiredMoney, isComplete, startEvent, isAutoComplete, failureTime, timeElapsed, questType, isTask, isStory, isOnMap, hasLocalPOI = T.GetQuestWatchInfo(i)
        if questLogIndex then
            local link, item, charges, showItemWhenComplete = T.GetQuestLogSpecialItemInfo(questLogIndex)
            if link then
                local itemID = T.tonumber(link:match(":(%d+):"))
                QuestItemList[itemID] = {
                    ["isComplete"] = isComplete,
                    ["showItemWhenComplete"] = showItemWhenComplete,
                    ["questLogIndex"] = questLogIndex,
                }
            end
        end
    end
    
    ABS:ScanItem("QUEST")
end

local function GetWorldQuestItemList(toggle)
    local mapID = T.C_Map_GetBestMapForUnit("player") or 0
    local taskInfo = T.C_TaskQuest_GetQuestsForPlayerByMapID(mapID)
    
    if (taskInfo and #taskInfo > 0) then
        for i, info in T.pairs(taskInfo) do
            local questID = info.questId
            local questLogIndex = T.GetQuestLogIndexByID(questID)
            if questLogIndex then
                local link, item, charges, showItemWhenComplete = T.GetQuestLogSpecialItemInfo(questLogIndex)
                if link then
                    local itemID = T.tonumber(link:match(":(%d+):"))
                    QuestItemList[itemID] = {
                        ["isComplete"] = isComplete,
                        ["showItemWhenComplete"] = showItemWhenComplete,
                        ["questLogIndex"] = questLogIndex,
                    }
                end
            end
        end
    end
    
    if (toggle ~= "init") then
        ABS:ScanItem("QUEST")
    end
end

local function haveIt(num, spellName)
    if not spellName then return false end
    
    for i = 1, num do
        local AutoButton = _G["AutoQuestButton" .. i]
        if not AutoButton then break end
        if AutoButton.spellName == spellName then
            return false
        end
    end
    return true
end

local function IsUsableItem(itemId)
    local itemSpell = T.GetItemSpell(itemId)
    if not itemSpell then return false end
    
    return itemSpell
end

local function IsSlotItem(itemId)
    local itemSpell = IsUsableItem(itemId)
    local itemName = T.GetItemInfo(itemId)
    
    return itemSpell
end

local function AutoButtonHide(AutoButton)
    if not AutoButton then return end
    AutoButton:SetAlpha(0)
    if not T.InCombatLockdown() then
        AutoButton:EnableMouse(false)
    else
        AutoButton:RegisterEvent("PLAYER_REGEN_ENABLED")
        AutoButton:SetScript("OnEvent", function(self, event)
            if event == "PLAYER_REGEN_ENABLED" then
                self:EnableMouse(false)
                self:UnregisterEvent("PLAYER_REGEN_ENABLED")
            end
        end)
    end
end

local function HideAllButton(event)
    local i, k = 1, 1

    for i = k, 12 do
        AutoButtonHide(_G["AutoQuestButton" .. i])
    end
    for i = 1, 12 do
        AutoButtonHide(_G["AutoSlotButton" .. i])
    end
end

local function AutoButtonShow(AutoButton)
    if not AutoButton then return end
    AutoButton:SetAlpha(1)
    AutoButton:SetScript("OnEnter", function(self)
        if T.InCombatLockdown() then return end
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 0, -2)
        GameTooltip:ClearLines()
        if self.slotID then
            GameTooltip:SetInventoryItem("player", self.slotID)
        else
            GameTooltip:SetItemByID(self.itemID)
        end
        GameTooltip:Show()
    end)
    AutoButton:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
    
    if not T.InCombatLockdown() then
        AutoButton:EnableMouse(true)
        if AutoButton.slotID then
            AutoButton:SetAttribute("type", "macro")
            AutoButton:SetAttribute("macrotext", "/use " .. AutoButton.slotID)
        elseif AutoButton.itemName then
            AutoButton:SetAttribute("type", "item")
            AutoButton:SetAttribute("item", AutoButton.itemName)
        end
    else
        AutoButton:RegisterEvent("PLAYER_REGEN_ENABLED")
        AutoButton:SetScript("OnEvent", function(self, event)
            if event == "PLAYER_REGEN_ENABLED" then
                self:EnableMouse(true)
                if self.slotID then
                    self:SetAttribute("type", "macro")
                    self:SetAttribute("macrotext", "/use " .. self.slotID)
                elseif self.itemName then
                    self:SetAttribute("type", "item")
                    self:SetAttribute("item", self.itemName)
                end
                self:UnregisterEvent("PLAYER_REGEN_ENABLED")
            end
        end)
    end
end

local function CreateButton(name, size)
    if _G[name] then
		_G[name]:Size(size)
		_G[name].Count:FontTemplate(LSM:Fetch("font", ABS.db.countFont), ABS.db.countFontSize, "OUTLINE")
		_G[name].HotKey:FontTemplate(LSM:Fetch("font", ABS.db.bindFont), ABS.db.bindFontSize, "OUTLINE")
		return _G[name]
    end
    
    local AutoButton = T.CreateFrame("Button", name, E.UIParent, "SecureActionButtonTemplate")
    AutoButton:Size(size)
    AutoButton:SetTemplate("Default")
    AutoButton:StyleButton()
    AutoButton:SetClampedToScreen(true)
    AutoButton:SetAttribute("type", "item")
    AutoButton:SetAlpha(0)
    AutoButton:EnableMouse(false)
    AutoButton:RegisterForClicks("AnyUp")
    
	-- Used for Glow
	AutoButton.Overlay = T.CreateFrame("Button", nil, AutoButton)
	AutoButton.Overlay:CreateIconShadow()
	AutoButton.Overlay:SetOutside(AutoButton, 0, 0)
	AutoButton.Overlay:EnableMouse(false)
	
    AutoButton.Texture = AutoButton:CreateTexture(nil, "OVERLAY", nil)
    AutoButton.Texture:Point("TOPLEFT", AutoButton, "TOPLEFT", 2, -2)
    AutoButton.Texture:Point("BOTTOMRIGHT", AutoButton, "BOTTOMRIGHT", -2, 2)
    AutoButton.Texture:SetTexCoord(unpack(E.TexCoords))
    
    AutoButton.Count = AutoButton:CreateFontString(nil, "OVERLAY")
    AutoButton.Count:FontTemplate(LSM:Fetch("font", ABS.db.countFont), ABS.db.countFontSize, "OUTLINE")
    AutoButton.Count:SetTextColor(1, 1, 1, 1)
    AutoButton.Count:Point("BOTTOMRIGHT", AutoButton, "BOTTOMRIGHT", 0, 2)
    AutoButton.Count:SetJustifyH("CENTER")
    
    AutoButton.HotKey = AutoButton:CreateFontString(nil, "OVERLAY")
    AutoButton.HotKey:FontTemplate(LSM:Fetch("font", ABS.db.bindFont), ABS.db.bindFontSize, "OUTLINE")
    AutoButton.HotKey:SetTextColor(1, 1, 1)
    AutoButton.HotKey:Point("TOPRIGHT", AutoButton, "TOPRIGHT", 0, 0)
    AutoButton.HotKey:SetJustifyH("RIGHT")
    
    AutoButton.Cooldown = T.CreateFrame("Cooldown", nil, AutoButton, "CooldownFrameTemplate")
    AutoButton.Cooldown:Point("TOPLEFT", AutoButton, "TOPLEFT", 2, -2)
    AutoButton.Cooldown:Point("BOTTOMRIGHT", AutoButton, "BOTTOMRIGHT", -2, 2)
    AutoButton.Cooldown:SetSwipeColor(1, 1, 1, 1)
    AutoButton.Cooldown:SetDrawBling(false)
    
    E:RegisterCooldown(AutoButton.Cooldown)
    
    E.FrameLocks[name] = true
    return AutoButton
end

function ABS:ScanItem(event)
    HideAllButton(event)
    GetWorldQuestItemList("init")
    
    local questItemIDList = {}
    local minimapZoneText = T.GetMinimapZoneText()
    if minimapZoneText == L["Alliance Mine"] or minimapZoneText == L["Horde Mine"] then
        for i = 1, #garrisonsmv do
            local count = T.GetItemCount(garrisonsmv[i])
            if count and (count > 0) and (not ABS.db.blackList[garrisonsmv[i]]) then
                tinsert(questItemIDList, garrisonsmv[i])
            end
        end
    elseif minimapZoneText == L["Salvage Yard"] then
        for i = 1, #garrisonsc do
            local count = T.GetItemCount(garrisonsc[i])
            if count and (count > 0) and (not ABS.db.blackList[garrisonsc[i]]) then
                tinsert(questItemIDList, garrisonsc[i])
            end
        end
    else
        for k, v in T.pairs(QuestItemList) do
            if (not QuestItemList[k].isComplete) or (QuestItemList[k].isComplete and QuestItemList[k].showItemWhenComplete) then
                if not ABS.db.blackList[k] then
                    T.table_insert(questItemIDList, k)
                end
            end
        end
        for k, v in T.pairs(ABS.db.whiteList) do
            local count = T.GetItemCount(k)
            if count and (count > 0) and v and (not ABS.db.blackList[k]) then
                T.table_insert(questItemIDList, k)
            end
        end
        if T.GetItemCount(123866) and (T.GetItemCount(123866) >= 5) and (not ABS.db.blackList[123866]) and (T.C_Map_GetBestMapForUnit("player") == 945) then
            T.table_insert(questItemIDList, 123866)
        end
    end
    
    sort(questItemIDList, function(v1, v2)
        local itemType1 = T.select(7, T.GetItemInfo(v1))
        local itemType2 = T.select(7, T.GetItemInfo(v2))
        if itemType1 and itemType2 then
            return itemType1 > itemType2
        else
            return v1 > v2
        end
    end)
    
    if ABS.db.questAutoButtons.enable == true and ABS.db.questAutoButtons.questNum > 0 then
        for i = 1, #questItemIDList do
            local itemID = questItemIDList[i]
            local itemName, _, rarity = T.GetItemInfo(itemID)
            
            if i > ABS.db.questAutoButtons.questNum then break end
            
            local AutoButton = _G["AutoQuestButton" .. i]
            local count = T.GetItemCount(itemID, nil, 1)
            local itemIcon = T.GetItemIcon(itemID)
            
            if not AutoButton then break end
            AutoButton.Texture:SetTexture(itemIcon)
            AutoButton.itemName = itemName
            AutoButton.itemID = itemID
            AutoButton.ap = false
            AutoButton.questLogIndex = QuestItemList[itemID] and QuestItemList[itemID].questLogIndex or -1
            AutoButton.spellName = IsUsableItem(itemID)
            --AutoButton:SetBackdropBorderColor(nil)
			AutoButton:SetBackdropBorderColor(1.0, 0.3, 0.3) -- color no border red!
            local r, g, b
            if ABS.db.questAutoButtons.questBBColorByItem then
                if rarity and rarity > LE_ITEM_QUALITY_COMMON then
                    r, g, b = T.GetItemQualityColor(rarity)
                    AutoButton:SetBackdropBorderColor(r, g, b)
                end
            else
                colorDB = ABS.db.questAutoButtons.questBBColor
                r, g, b = colorDB.r, colorDB.g, colorDB.b
                AutoButton:SetBackdropBorderColor(r, g, b)
            end
            
            if count and count > 1 then
                AutoButton.Count:SetText(count)
            else
                AutoButton.Count:SetText("")
            end
            
            AutoButton:SetScript("OnUpdate", function(self, elapsed)
                local start, duration, enable
                if self.questLogIndex > 0 then
                    start, duration, enable = T.GetQuestLogSpecialItemCooldown(self.questLogIndex)
                else
                    start, duration, enable = T.GetItemCooldown(self.itemID)
                end
                T.CooldownFrame_Set(self.Cooldown, start, duration, enable)
                if (duration and duration > 0 and enable and enable == 0) then
                    self.Texture:SetVertexColor(0.4, 0.4, 0.4)
                elseif T.IsItemInRange(itemID, "target") == 0 then
                    self.Texture:SetVertexColor(1, 0, 0)
                else
                    self.Texture:SetVertexColor(1, 1, 1)
                end
            end)
            AutoButtonShow(AutoButton)
        end
    end
    
    local num = 0
    if ABS.db.soltAutoButtons.enable == true and ABS.db.soltAutoButtons.slotNum > 0 then
        for w = 1, 18 do
            local slotID = T.GetInventoryItemID("player", w)
            if slotID and IsSlotItem(slotID) and not ABS.db.blackList[slotID] then
                local itemName, _, rarity = T.GetItemInfo(slotID)
                local itemIcon = T.GetInventoryItemTexture("player", w)
                num = num + 1
                if num > ABS.db.soltAutoButtons.slotNum then break end
                
                local AutoButton = _G["AutoSlotButton" .. num]
                if not AutoButton then break end
				
				AutoButton:SetBackdropBorderColor(nil)
				
                if rarity and rarity > 1 and ABS.db.soltAutoButtons.slotBBColorByItem then
					local r, g, b = T.GetItemQualityColor(rarity);
					AutoButton:SetBackdropBorderColor(r, g, b);
                else
                    local colorDB = ABS.db.soltAutoButtons.slotBBColor
                    local r, g, b = colorDB.r, colorDB.g, colorDB.b
                    AutoButton:SetBackdropBorderColor(r, g, b)
                end

                AutoButton.Texture:SetTexture(itemIcon)
                AutoButton.Count:SetText("")
                AutoButton.slotID = w
                AutoButton.itemID = slotID
                AutoButton.spellName = IsUsableItem(slotID)
                
                AutoButton:SetScript("OnUpdate", function(self, elapsed)
                    local cd_start, cd_finish, cd_enable = T.GetInventoryItemCooldown("player", self.slotID)
                    T.CooldownFrame_Set(AutoButton.Cooldown, cd_start, cd_finish, cd_enable)
                end)
                AutoButtonShow(AutoButton)
            end
        end
    end
end

local lastUpdate = 0
function ABS:ScanItemCount(elapsed)
    lastUpdate = lastUpdate + elapsed
    if lastUpdate < 0.5 then
        return
    end
    lastUpdate = 0
    for i = 1, ABS.db.questAutoButtons.questNum do
        local f = _G["AutoQuestButton" .. i]
        if f and f.itemName then
            local count = T.GetItemCount(f.itemID, nil, 1)
            
            if count and count > 1 then
                f.Count:SetText(count)
            else
                f.Count:SetText("")
            end
        end
    end
end

function ABS:UpdateBind()
    if not ABS.db.autoButtons then return end
    if ABS.db.questAutoButtons.enable == true then
        for i = 1, ABS.db.questAutoButtons.questNum do
            local bindButton = "CLICK AutoQuestButton" .. i .. ":LeftButton"
            local button = _G["AutoQuestButton" .. i]
            local bindText = T.GetBindingKey(bindButton)
            if not bindText then
                bindText = ""
            else
                bindText = T.string_gsub(bindText, "SHIFT--", "S")
                bindText = T.string_gsub(bindText, "CTRL--", "C")
                bindText = T.string_gsub(bindText, "ALT--", "A")
            end
            
            if button then button.HotKey:SetText(bindText) end
        end
    end

    if ABS.db.soltAutoButtons.enable == true then
        for i = 1, ABS.db.soltAutoButtons.slotNum do
            local bindButton = "CLICK AutoSlotButton" .. i .. ":LeftButton"
            local button = _G["AutoSlotButton" .. i]
            local bindText = T.GetBindingKey(bindButton)
            if not bindText then
                bindText = ""
            else
                bindText = T.string_gsub(bindText, "SHIFT--", "S")
                bindText = T.string_gsub(bindText, "CTRL--", "C")
                bindText = T.string_gsub(bindText, "ALT--", "A")
            end
            
            if button then button.HotKey:SetText(bindText) end
        end
    end
end

function ABS:ToggleAutoButton()
    if ABS.db.enable then
		self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", "ScanItem")
        self:RegisterEvent("UNIT_INVENTORY_CHANGED", "ScanItem")
        self:RegisterEvent("ZONE_CHANGED", "ScanItem")
        self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "ScanItem")
        self:RegisterEvent("UPDATE_BINDINGS", "UpdateBind")
        self:RegisterEvent("QUEST_WATCH_LIST_CHANGED", GetQuestItemList)
        self:RegisterEvent("QUEST_LOG_UPDATE", GetQuestItemList)
        self:RegisterEvent("QUEST_ACCEPTED", GetWorldQuestItemList)
        self:RegisterEvent("QUEST_TURNED_IN", GetWorldQuestItemList)
        if not ABS.Update then ABS.Update = T.CreateFrame("Frame") end
        self.Update:SetScript("OnUpdate", ABS.ScanItemCount)
        self:ScanItem("FIRST")
        self:UpdateBind()
    else
        HideAllButton()
		self:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED")
        self:UnregisterEvent("UNIT_INVENTORY_CHANGED")
        self:UnregisterEvent("ZONE_CHANGED")
        self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
        self:UnregisterEvent("UPDATE_BINDINGS")
        self:UnregisterEvent("QUEST_WATCH_LIST_CHANGED")
        self:UnregisterEvent("QUEST_LOG_UPDATE")
        if self.Update then self.Update:SetScript("OnUpdate", nil) end
    end
end

function ABS:UpdateAutoButton()
    local i = 0
    local lastButton, lastColumnButton, buttonsPerRow
    if ABS.db.questAutoButtons.enable == true then
        for i = 1, ABS.db.questAutoButtons.questNum do
            local f = CreateButton("AutoQuestButton" .. i, ABS.db.questAutoButtons.questSize)
            buttonsPerRow = ABS.db.questAutoButtons.questPerRow
            lastButton = _G["AutoQuestButton" .. i - 1]
            lastColumnButton = _G["AutoQuestButton" .. i - buttonsPerRow]
            
            if ABS.db.questAutoButtons.questNum < ABS.db.questAutoButtons.questPerRow then
                buttonsPerRow = ABS.db.questAutoButtons.questNum
            end
            f:ClearAllPoints()
            
            if i == 1 then
                f:Point("LEFT", AutoButtonAnchor, "LEFT", 0, 0)
            elseif (i - 1) % buttonsPerRow == 0 then
                f:Point("TOP", lastColumnButton, "BOTTOM", 0, -1)
            else
                if ABS.db.questAutoButtons.questDirection == "RIGHT" then
                    f:Point("LEFT", lastButton, "RIGHT", ABS.db.questAutoButtons.questSpace, 0)
                elseif ABS.db.questAutoButtons.questDirection == "LEFT" then
                    f:Point("RIGHT", lastButton, "LEFT", -(ABS.db.questAutoButtons.questSpace), 0)
                end
            end
        end
    end

    if ABS.db.soltAutoButtons.enable == true then
        for i = 1, ABS.db.soltAutoButtons.slotNum do
            local f = CreateButton("AutoSlotButton" .. i, ABS.db.soltAutoButtons.slotSize)
            buttonsPerRow = ABS.db.soltAutoButtons.slotPerRow
            lastButton = _G["AutoSlotButton" .. i - 1]
            lastColumnButton = _G["AutoSlotButton" .. i - buttonsPerRow]
            
            if ABS.db.soltAutoButtons.slotNum < ABS.db.soltAutoButtons.slotPerRow then
                buttonsPerRow = ABS.db.questAutoButtons.questNum
            end
            f:ClearAllPoints()
            
            if i == 1 then
                f:Point("LEFT", AutoButtonAnchor2, "LEFT", 0, 0)
            elseif (i - 1) % buttonsPerRow == 0 then
                f:Point("TOP", lastColumnButton, "BOTTOM", 0, -1)
            else
                if ABS.db.soltAutoButtons.slotDirection == "RIGHT" then
                    f:Point("LEFT", lastButton, "RIGHT", ABS.db.soltAutoButtons.slotSpace, 0)
                elseif ABS.db.soltAutoButtons.slotDirection == "LEFT" then
                    f:Point("RIGHT", lastButton, "LEFT", -(ABS.db.soltAutoButtons.slotSpace), 0)
                end
            end
        end
    end
    self:ToggleAutoButton()
end

function ABS:Initialize()
	if (KUI:IsDeveloper() and KUI:IsDeveloperRealm()) then return end
	
	ABS.db = E.db.KlixUI.actionbars.autoButtons
	
    local AutoButtonAnchor = T.CreateFrame("Frame", "AutoButtonAnchor", E.UIParent)
    AutoButtonAnchor:SetClampedToScreen(true)
    AutoButtonAnchor:Point("BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -375, 194)
    AutoButtonAnchor:Size(ABS.db.questAutoButtons.questSize or 35, ABS.db.questAutoButtons.questSize or 35)
	E:CreateMover(AutoButtonAnchor, "AutoButtonAnchorMover", L["Quest Auto Buttons"], nil, nil, nil, "ALL,ACTIONBARS,KLIXUI", function() return ABS.db.enable end)

    local AutoButtonAnchor2 = T.CreateFrame("Frame", "AutoButtonAnchor2", E.UIParent)
    AutoButtonAnchor2:SetClampedToScreen(true)
    AutoButtonAnchor2:Point("BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -375, 231)
    AutoButtonAnchor2:Size(ABS.db.soltAutoButtons.slotSize or 35, ABS.db.soltAutoButtons.slotSize or 35)
	E:CreateMover(AutoButtonAnchor2, "AutoButtonAnchor2Mover", L["Inventory Auto Buttons"], nil, nil, nil, "ALL,ACTIONBARS,KLIXUI", function() return ABS.db.enable end)

    self:UpdateAutoButton()
end

local function InitializeCallback()
    if not E.db.KlixUI.actionbars.autoButtons.enable then return end
    ABS:Initialize()
end

KUI:RegisterModule(ABS:GetName(), InitializeCallback)
