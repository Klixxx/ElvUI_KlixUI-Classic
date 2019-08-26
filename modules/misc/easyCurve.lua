-------------------------------------------------------------------------------
-- Credits: Ahead of the Curve - Pigletoos
-------------------------------------------------------------------------------
local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KEC = KUI:NewModule("KuiEasyCurve", "AceEvent-3.0", "AceHook-3.0")
local KS = KUI:GetModule("KuiSkins")

KEC.achievementSearchList = {}
local keyStoneLink

KEC.instances = {
	{
	ids = {502, 504, 507, 510, 514, 518, 522, 526, 530, 534, 659, 661},
	name = 'Mythic Plus (BfA)',
	achievements = {13078, 13449, 13448, 13075},
	highestCompleted = nil,
	},
	{
	ids = {494, 495, 496},
	name = 'Uldir',
	achievements = {12535, 12533, 12536, 12523},
	highestCompleted = nil,
	},
	{
	ids = {663, 664, 665},
	name = 'Battle of Dazaralor',
	achievements = {13323, 13314, 13313, 13312, 13311, 13299, 13300, 13295, 13293, 13292, 13322, 13291 or 13288, 13290, 13289},
	highestCompleted = nil,
	},
	{
	ids = {666, 667, 668},
	name = 'Crucible of Storms',
	achievements = {13414, 13418, 13419, 13416, 13417, 13419},
	highestCompleted = nil,
	},
	{
	ids = {671, 672, 673},
	name = 'Eternal Palace',
	achievements = {13725, 13784, 13785, 13726, 13728, 13727, 13730, 13731, 13732, 13733, 13785},
	highestCompleted = nil,
	},
	{
	ids = {657},
	name = 'World Bosses',
	achievements = {},
	highestCompleted = nil,
	},
}

function KEC:CreatePanel()
	if not KEC.container then
        KEC.container = T.CreateFrame("Frame", "KuiEasyCurveDialog", _G.LFGListApplicationDialog)
        KEC.container:SetSize(306, 50)
        KEC.container:SetPoint("BOTTOM", 0, -55)
		KEC.container:SetTemplate("Transparent")
    end
    
    if not KEC.checkButtonAchievement then
        KEC.checkButtonAchievement = T.CreateFrame("CheckButton", "KuiEasyCurveCheckBoxAchievement", KEC.container, "UICheckButtonTemplate")
        KEC.checkButtonAchievement:SetSize(24, 24)
        KEC.checkButtonAchievement:SetPoint("CENTER", -85, 0)
        KEC.checkButtonAchievement:SetChecked(KEC.db.whispersAchievement)
    end

    if not KEC.checkButtonKeystone then
        KEC.checkButtonKeystone = T.CreateFrame("CheckButton", "KuiEasyCurveCheckBoxKeystone", KEC.container, "UICheckButtonTemplate")
        KEC.checkButtonKeystone:SetSize(24, 24)
        KEC.checkButtonKeystone:SetPoint("CENTER", -85, -11)
        KEC.checkButtonKeystone:SetChecked(KEC.db.whispersKeystone)
        KEC.checkButtonKeystone.text:SetText("Send Mythic Plus Keystone")
        KEC.checkButtonKeystone.text:SetWidth(145)
    end
    
    KEC.container:Show()
    KEC.checkButtonAchievement:Show()
    KEC.checkButtonKeystone:Hide()
end

function KEC:ACHIEVEMENT_SEARCH_UPDATED()
    local numFiltered = T.GetNumFilteredAchievements()

    if numFiltered < 500 then
        for index in pairs(KEC.achievementSearchList) do
            KEC.achievementSearchList[index] = nil
        end
        
        for index = 1, numFiltered do
            local achievementId = T.GetFilteredAchievementID(index)
            local _, name, _, completed = T.GetAchievementInfo(achievementId)
            
            if completed then
                KEC.achievementSearchList[achievementId] = name
            end
        end
    end
    
    --AceConfigRegistry:NotifyChange("KuiEasyCurve")
end

function KEC:ACHIEVEMENT_EARNED()
    KEC:GetHighestDefaultAchievement()
    --AceConfigRegistry:NotifyChange("KuiEasyCurve")
end

function KEC:GetHighestDefaultAchievement()
    for index, instance in T.pairs(KEC.instances) do
        for _, id in T.pairs(instance.achievements) do
            local _, _, _, completed = T.GetAchievementInfo(id)
            
            if completed then
                KEC.instances[index].highestCompleted = id
                break
            end
        end
    end
end

function KEC:DisplayHighestDefaultAchievement(index)
    if KEC.instances[index].highestCompleted then
        local _, name, _, _, _, _, _, _, _, iconPath = T.GetAchievementInfo(KEC.instances[index].highestCompleted)
        return name, iconPath
    else
        return nil, nil
    end
end

function KEC:GetLFGCategory(findAGroupButton)
    local category = findAGroupButton:GetParent().selectedCategory;
    
    if category ~= 2 or category ~= 3 then
        KEC.container:Hide()
        KEC.checkButtonAchievement:Hide()
    else
        KEC.container:Show()
        KEC.checkButtonAchievement:Show()
    end

    if category == 2 then
        KEC:ScanBagsForKeystone()
    end
end

function KEC:GetLFGInstance(signUpButton)
	if not E.db.KlixUI.misc.easyCurve.enable then return end
    local searchResultInfo = T.C_LFGList_GetSearchResultInfo(signUpButton:GetParent().selectedResult)
    local highestCompleted = KEC:GetLFGAchievement(searchResultInfo.activityID)
    local isMythicDungeon = KEC:IsMythicDungeon(searchResultInfo.activityID)
    local checkButtonAchievementText, checkButtonAchievementWidth, checkButtonAchievementPoint = KEC:GetCheckButtonAchievementData(isMythicDungeon)
    local worldBosses = KEC.instances[3].ids[1]

    if not highestCompleted and not KEC.db.override or not KEC.db.override and searchResultInfo.activityID == worldBosses then
        KEC.container:Hide()
        KEC.checkButtonAchievement:Hide()
    else
        KEC.container:Show()
        KEC.checkButtonAchievement:Show()
        KEC.checkButtonAchievement:SetChecked(KEC.db.whispersAchievement)
        KEC.checkButtonAchievement.text:SetText(checkButtonAchievementText)
        KEC.checkButtonAchievement.text:SetWidth(checkButtonAchievementWidth)
        KEC.checkButtonAchievement:SetPoint('CENTER', checkButtonAchievementPoint, 0)      
    end

    if isMythicDungeon and keyStoneLink then
        KEC:ShowMythicPlusOption(highestCompleted)
    else
        KEC.container:SetPoint('BOTTOM', 0, -55)
        KEC.container:SetSize(306, 50)
        KEC.checkButtonAchievement:SetPoint('CENTER', checkButtonAchievementPoint, 0)
        KEC.checkButtonKeystone:Hide()
        KEC.checkButtonKeystone:SetChecked(false)
    end
end

function KEC:GetCheckButtonAchievementData(isMythicDungeon)
	if not E.db.KlixUI.misc.easyCurve.enable then return end
    if KEC.db.override then
        return 'Send Override Achievement', 158, -85
    end

    if isMythicDungeon then
        return 'Send Mythic Plus Achievement', 170, -85
    end

    return 'Send Ahead of the Curve Achievement', 205, -100
end

function KEC:GetLFGAchievement(instanceId)
    for _, instance in pairs(KEC.instances) do
        for _, id in pairs(instance.ids) do
            if id == instanceId then
                return instance.highestCompleted
            end
        end
    end
end

function KEC:SendWhisper(signUpButton)
    local searchResultInfo = T.C_LFGList_GetSearchResultInfo(signUpButton:GetParent().resultID)

    if KEC.checkButtonAchievement:GetChecked() or KEC.checkButtonKeystone:GetChecked() then
        local achievementId
        
        if KEC.db.override and KEC.db.overrideAchievement then
            achievementId = KEC.db.overrideAchievement
        else
            achievementId = KEC:GetLFGAchievement(searchResultInfo.activityID)
        end
        
        if achievementId then
            local success = T.pcall(T.SendChatMessage, KEC:BuildWhisper(achievementId), 'WHISPER', nil, searchResultInfo.leaderName)
            
            if not success then
                KUI:Print(L["There was an error sending your whisper."])
            end
        end
    end
end

function KEC:BuildWhisper(achievementId)
    if KEC.checkButtonAchievement:GetChecked() and (KEC.checkButtonKeystone:GetChecked() and keyStoneLink) then
        return T.GetAchievementLink(achievementId) .. keyStoneLink
    end

    if KEC.checkButtonAchievement:GetChecked() then
        return T.GetAchievementLink(achievementId)
    end

    if KEC.checkButtonKeystone:GetChecked() and keyStoneLink then
        return keyStoneLink
    end
end

function KEC:ScanBagsForKeystone()
    for bag = 0, 4 do
        local numSlots = T.GetContainerNumSlots(bag)

        for slot = 1, numSlots do
            local _, _, _, _, _, _, link, _, _, itemId = T.GetContainerItemInfo(bag, slot)

            if itemId == 138019 then
                keyStoneLink = link
                break
            end
        end
    end
end

function KEC:IsMythicDungeon(instanceId)
    for _, id in T.pairs(KEC.instances[1].ids) do
        if id == instanceId then
            return true
        end
    end
end

function KEC:ShowMythicPlusOption(highestCompleted)
     if not highestCompleted and not KEC.db.override then
        KEC.checkButtonAchievement:Hide()
        KEC.container:SetPoint('BOTTOM', 0, -55)
        KEC.container:SetSize(306, 50)
        KEC.checkButtonKeystone:SetPoint('CENTER', -75, 0)
        KEC.container:Show()
    else
        KEC.container:SetPoint('BOTTOM', 0, -75)
        KEC.container:SetSize(306, 70)
        KEC.checkButtonAchievement:SetPoint('CENTER', -85, 9)
    end

    KEC.checkButtonKeystone:SetChecked(KEC.db.whispersKeystone)    
    KEC.checkButtonKeystone:Show()
end

function KEC:TableLength(t)
    local count = 0

    for _ in T.pairs(t) do 
        count = count + 1 
    end

    return count
end

function KEC:Initialize()
	if not E.db.KlixUI.misc.easyCurve.enable then return end
	KEC.db = E.db.KlixUI.misc.easyCurve
	
	KEC:RegisterEvent("ACHIEVEMENT_SEARCH_UPDATED")
	KEC:RegisterEvent("ACHIEVEMENT_EARNED")
	
	KEC:SecureHookScript(_G.LFGListFrame.CategorySelection.FindGroupButton, "OnClick", "GetLFGCategory")
    KEC:HookScript(_G.LFGListFrame.SearchPanel.SignUpButton, "OnClick", "GetLFGInstance")
    KEC:HookScript(_G.LFGListApplicationDialog.SignUpButton, "OnClick", "SendWhisper")
    KEC:RegisterEvent("ACHIEVEMENT_SEARCH_UPDATED")
    KEC:RegisterEvent("ACHIEVEMENT_EARNED")
    KEC:GetHighestDefaultAchievement()
	
	KEC:CreatePanel()
	
	if KuiEasyCurveDialog then
		KuiEasyCurveDialog:Styling()
	end
	
	if KuiEasyCurveCheckBoxAchievement then
		KS:ReskinCheckBox(KuiEasyCurveCheckBoxAchievement)
	end
	
	if KuiEasyCurveCheckBoxKeystone then
		KS:ReskinCheckBox(KuiEasyCurveCheckBoxKeystone)
	end
	
    local id = KEC.db.overrideAchievement
    
    if id then
        local _, name = T.GetAchievementInfo(id)
        KEC.achievementSearchList[id] = name
    else
        KEC.achievementSearchList[1] = 'Please search and then select an achievement from the list'
    end
	
	function KEC:ForUpdateAll()
		KEC.db = E.db.KlixUI.misc.easyCurve
	end
end

local function InitializeCallback()
	KEC:Initialize()
end

KUI:RegisterModule(KEC:GetName(), InitializeCallback)