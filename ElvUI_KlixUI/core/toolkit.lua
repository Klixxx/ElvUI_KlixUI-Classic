local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local LSM = E.LSM or E.Libs.LSM

local _G = _G
T.AbbreviateNumbers = AbbreviateNumbers
T.abs = abs
T.AcceptQuest = AcceptQuest
T.AchievementFrame_DisplayComparison = AchievementFrame_DisplayComparison
T.AchievementFrame_LoadUI = AchievementFrame_LoadUI
T.AchievementFrame_SelectAchievement = AchievementFrame_SelectAchievement
T.ActionButton_HideOverlayGlow = ActionButton_HideOverlayGlow
T.ActionButton_ShowOverlayGlow = ActionButton_ShowOverlayGlow
T.AddQuestWatch = AddQuestWatch
T.Ambiguate = Ambiguate
T.AnimateTexCoords = AnimateTexCoords
T.assert = assert
T.AuraUtil_FindAuraByName = AuraUtil.FindAuraByName
T.AutoCastShine_AutoCastStart = AutoCastShine_AutoCastStart
T.AutoCastShine_AutoCastStop = AutoCastShine_AutoCastStop
T.BattlePetToolTip_Show = BattlePetToolTip_Show
T.bit_band = bit.band
T.bit_bor = bit.bor
T.bit_lshift = bit.lshift
T.BNConnected = BNConnected
T.BNet_GetClientTexture = BNet_GetClientTexture
T.BNet_GetValidatedCharacterName = BNet_GetValidatedCharacterName
T.BNGetFriendGameAccountInfo = BNGetFriendGameAccountInfo
T.BNGetFriendIndex = BNGetFriendIndex
T.BNGetFriendInfo = BNGetFriendInfo
T.BNGetGameAccountInfo = BNGetGameAccountInfo
T.BNGetNumFriendGameAccounts = BNGetNumFriendGameAccounts
T.BNGetNumFriends = BNGetNumFriends
T.BossBanner_BeginAnims = BossBanner_BeginAnims
T.BreakUpLargeNumbers = BreakUpLargeNumbers
T.BuyMerchantItem = BuyMerchantItem
T.BuyTrainerService = BuyTrainerService
T.C_FriendList_GetFriendInfo = C_FriendList.GetFriendInfo
T.C_FriendList_GetNumFriends = C_FriendList.GetNumFriends
T.C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit
T.C_Map_GetMapArtID = C_Map.GetMapArtID
T.C_Map_GetMapArtLayers = C_Map.GetMapArtLayers
T.C_Map_GetMapInfo = C_Map.GetMapInfo
T.C_Map_GetPlayerMapPosition = C_Map.GetPlayerMapPosition
T.C_MapExplorationInfo_GetExploredMapTextures = C_MapExplorationInfo.GetExploredMapTextures
T.C_NamePlate_GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit
T.C_PaperDollInfo_OffhandHasWeapon = C_PaperDollInfo.OffhandHasWeapon
T.C_Timer_After = C_Timer.After
T.C_Timer_NewTicker = C_Timer.NewTicker
T.CanAffordMerchantItem = CanAffordMerchantItem
T.CancelAuction = CancelAuction
T.CancelDuel = CancelDuel
T.CanCooperateWithGameAccount = CanCooperateWithGameAccount
T.CanEditOfficerNote = CanEditOfficerNote
T.CanEditPublicNote = CanEditPublicNote
T.CanInspect = CanInspect
T.CastSpellByName = CastSpellByName
T.ChatEdit_ActivateChat = ChatEdit_ActivateChat
T.ChatEdit_ChooseBoxForSend = ChatEdit_ChooseBoxForSend
T.ChatEdit_GetActiveWindow = ChatEdit_GetActiveWindow
T.ChatEdit_InsertLink = ChatEdit_InsertLink
T.ChatFrame_AddChannel = ChatFrame_AddChannel
T.ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter
T.ChatFrame_RemoveChannel = ChatFrame_RemoveChannel
T.ChatFrame_TimeBreakDown = ChatFrame_TimeBreakDown
T.CheckInteractDistance = CheckInteractDistance
T.CinematicFrame_CancelCinematic = CinematicFrame_CancelCinematic
T.ClearAchievementComparisonUnit = ClearAchievementComparisonUnit
T.ClearAllLFGDungeons = ClearAllLFGDungeons
T.ClearCursor = ClearCursor
T.CloseAllBags = CloseAllBags
T.CloseLoot = CloseLoot
T.CloseQuest = CloseQuest
T.CollectionsJournal_LoadUI = CollectionsJournal_LoadUI
T.CombatLog_Object_IsA = CombatLog_Object_IsA
T.CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
T.CompleteLFGRoleCheck = CompleteLFGRoleCheck
T.CompleteQuest = CompleteQuest
T.ConfirmAcceptQuest = ConfirmAcceptQuest
T.ConvertToRaid = ConvertToRaid
T.CooldownFrame_Set = CooldownFrame_Set
T.CraftRecipe = CraftRecipe
T.CreateFrame = CreateFrame
T.CreateMacro = CreateMacro
T.date = date
T.DeleteCursorItem = DeleteCursorItem
T.DepositReagentBank = DepositReagentBank
T.DevTools_Dump = DevTools_Dump
T.difftime = difftime
T.DisableAddOn = DisableAddOn
T.DisableAllAddOns = DisableAllAddOns
T.EasyMenu = EasyMenu
T.EditMacro = EditMacro
T.EJ_GetCurrentTier = EJ_GetCurrentTier
T.EJ_GetEncounterInfoByIndex = EJ_GetEncounterInfoByIndex
T.EJ_GetInstanceByIndex = EJ_GetInstanceByIndex
T.EJ_GetNumSearchResults = EJ_GetNumSearchResults
T.EJ_GetNumTiers = EJ_GetNumTiers
T.EJ_SelectTier = EJ_SelectTier
T.EnableAddOn = EnableAddOn
T.EnableAllAddOns = EnableAllAddOns
T.EquipItemByName = EquipItemByName
T.EquipmentManager_RunAction = EquipmentManager_RunAction
T.EquipmentManager_UnequipItemInSlot = EquipmentManager_UnequipItemInSlot
T.EquipmentManager_UnpackLocation = EquipmentManager_UnpackLocation
T.error = error
T.ExpandCurrencyList = ExpandCurrencyList
T.FauxScrollFrame_GetOffset = FauxScrollFrame_GetOffset
T.FCF_GetChatWindowInfo = FCF_GetChatWindowInfo
T.FCF_GetCurrentChatFrameID = FCF_GetCurrentChatFrameID
T.FlipCameraYaw = FlipCameraYaw
T.FriendsFrame_GetLastOnline = FriendsFrame_GetLastOnline
T.FriendsFrame_UpdateFriends = FriendsFrame_UpdateFriends
T.FriendsFrameTooltip_SetLine = FriendsFrameTooltip_SetLine
T.floor = floor
T.GameMovieFinished = GameMovieFinished
T.GameTooltip = GameTooltip
T.GameTooltip_AddQuestRewardsToTooltip = GameTooltip_AddQuestRewardsToTooltip
T.GameTooltip_Hide = GameTooltip_Hide
T.GameTooltip_SetDefaultAnchor = GameTooltip_SetDefaultAnchor
T.GameTooltip_ShowCompareItem = GameTooltip_ShowCompareItem
T.Garrison_LoadUI = Garrison_LoadUI
T.GarrisonFollowerTooltip_Show = GarrisonFollowerTooltip_Show
T.GarrisonLandingPageMinimapButton_OnClick = GarrisonLandingPageMinimapButton_OnClick
T.GetAchievementInfo = GetAchievementInfo
T.GetAchievementLink = GetAchievementLink
T.GetAchievementNumCriteria = GetAchievementNumCriteria
T.GetActionInfo = GetActionInfo
T.GetActiveSpecGroup = GetActiveSpecGroup
T.GetActiveTitle = GetActiveTitle
T.GetAddOnCPUUsage = GetAddOnCPUUsage
T.GetAddOnEnableState = GetAddOnEnableState
T.GetAddOnDependencies = GetAddOnDependencies
T.GetAddOnInfo = GetAddOnInfo
T.GetAddOnMemoryUsage = GetAddOnMemoryUsage
T.GetAddOnMetadata = GetAddOnMetadata
T.GetAddOnOptionalDependencies = GetAddOnOptionalDependencies
T.GetArchaeologyRaceInfoByID = GetArchaeologyRaceInfoByID
T.GetAuctionItemInfo = GetAuctionItemInfo
T.GetAuctionItemLink = GetAuctionItemLink
T.GetAutoCompleteRealms = GetAutoCompleteRealms
T.GetAutoQuestPopUp = GetAutoQuestPopUp
T.GetAvailableBandwidth = GetAvailableBandwidth
T.GetAverageItemLevel = GetAverageItemLevel
T.GetAvoidance = GetAvoidance
T.GetBackpackCurrencyInfo = GetBackpackCurrencyInfo
T.GetBattlefieldScore = GetBattlefieldScore
T.GetBattlefieldStatus = GetBattlefieldStatus
T.GetBindingKey = GetBindingKey
T.GetBindingText = GetBindingText
T.GetBindLocation = GetBindLocation
T.GetBlockChance = GetBlockChance
T.GetBuildInfo = GetBuildInfo
T.GetBuybackItemLink = GetBuybackItemLink
T.GetCameraZoom = GetCameraZoom
T.GetChannelList = GetChannelList
T.GetChannelName = GetChannelName
T.GetChatWindowInfo = GetChatWindowInfo
T.GetChatWindowSavedPosition = GetChatWindowSavedPosition
T.GetClampedCurrentExpansionLevel = GetClampedCurrentExpansionLevel
T.GetClassInfo = GetClassInfo
T.GetCombatRating = GetCombatRating
T.GetCombatRatingBonus = GetCombatRatingBonus
T.GetCombatRatingBonusForCombatRatingValue = GetCombatRatingBonusForCombatRatingValue
T.GetComparisonAchievementPoints = GetComparisonAchievementPoints
T.GetComparisonStatistic = GetComparisonStatistic
T.GetContainerItemEquipmentSetInfo = GetContainerItemEquipmentSetInfo
T.GetContainerItemID = GetContainerItemID
T.GetContainerItemInfo = GetContainerItemInfo
T.GetContainerItemLink = GetContainerItemLink
T.GetContainerItemQuestInfo = GetContainerItemQuestInfo
T.GetContainerNumSlots = GetContainerNumSlots
T.GetCritChance = GetCritChance
T.GetCritChanceProvidesParryEffect = GetCritChanceProvidesParryEffect
T.GetCurrencyInfo = GetCurrencyInfo
T.GetCurrencyListInfo = GetCurrencyListInfo
T.GetCurrencyListSize = GetCurrencyListSize
T.GetCurrentRegion = GetCurrentRegion
T.GetCurrentTitle = GetCurrentTitle
T.GetCursorInfo = GetCursorInfo
T.GetCursorPosition = GetCursorPosition
T.GetCVar = GetCVar
T.GetCVarBool = GetCVarBool
T.GetDetailedItemLevelInfo = GetDetailedItemLevelInfo
T.GetDifficultyInfo = GetDifficultyInfo
T.GetDistanceSqToQuest = GetDistanceSqToQuest
T.GetDodgeChance = GetDodgeChance
T.GetDownloadedPercentage = GetDownloadedPercentage
T.GetDungeonDifficultyID = GetDungeonDifficultyID
T.GetExpansionDisplayInfo = GetExpansionDisplayInfo
T.GetExpansionLevel = GetExpansionLevel
T.GetFactionInfo = GetFactionInfo
T.GetFactionInfoByID = GetFactionInfoByID
T.GetFilteredAchievementID = GetFilteredAchievementID
T.GetFramerate = GetFramerate
T.GetFriendInfo = GetFriendInfo
T.GetFriendshipReputation = GetFriendshipReputation
T.GetFriendshipReputationRanks = GetFriendshipReputationRanks
T.GetGameTime = GetGameTime
T.getglobal = getglobal
T.GetGossipActiveQuests = GetGossipActiveQuests
T.GetGossipAvailableQuests = GetGossipAvailableQuests
T.GetGuildInfo = GetGuildInfo
T.GetGuildLogoInfo = GetGuildLogoInfo
T.GetGuildRosterInfo = GetGuildRosterInfo
T.GetGuildRosterMOTD = GetGuildRosterMOTD
T.GetGuildTradeSkillInfo = GetGuildTradeSkillInfo
T.GetHaste = GetHaste
T.GetHitModifier = GetHitModifier
T.GetInboxHeaderInfo = GetInboxHeaderInfo
T.GetInboxInvoiceInfo = GetInboxInvoiceInfo
T.GetInboxNumItems = GetInboxNumItems
T.GetInboxText = GetInboxText
T.GetInspectArenaData = GetInspectArenaData
T.GetInspectGuildInfo = GetInspectGuildInfo
T.GetInspectHonorData = GetInspectHonorData
T.GetInspectRatedBGData = GetInspectRatedBGData
T.GetInspectSpecialization = GetInspectSpecialization
T.GetInstanceInfo = GetInstanceInfo
T.GetInventoryItemCooldown = GetInventoryItemCooldown
T.GetInventoryItemDurability = GetInventoryItemDurability
T.GetInventoryItemID = GetInventoryItemID
T.GetInventoryItemLink = GetInventoryItemLink
T.GetInventoryItemQuality = GetInventoryItemQuality
T.GetInventoryItemTexture = GetInventoryItemTexture
T.GetInventorySlotInfo = GetInventorySlotInfo
T.GetItemClassInfo = GetItemClassInfo
T.GetItemCooldown = GetItemCooldown
T.GetItemCount = GetItemCount
T.GetItemGem = GetItemGem
T.GetItemIcon = GetItemIcon
T.GetItemInfo = GetItemInfo
T.GetItemInfoFromHyperlink = GetItemInfoFromHyperlink
T.GetItemInfoInstant = GetItemInfoInstant
T.GetItemLevelColor = GetItemLevelColor
T.GetItemQualityColor = GetItemQualityColor
T.GetItemSpell = GetItemSpell
T.GetLatestThreeSenders = GetLatestThreeSenders
T.GetLFGCompletionReward = GetLFGCompletionReward
T.GetLFGCompletionRewardItem = GetLFGCompletionRewardItem
T.GetLFGDungeonEncounterInfo = GetLFGDungeonEncounterInfo
T.GetLFGDungeonInfo = GetLFGDungeonInfo
T.GetLFGDungeonNumEncounters = GetLFGDungeonNumEncounters
T.GetLFGDungeonRewardInfo = GetLFGDungeonRewardInfo
T.GetLFGDungeonRewards = GetLFGDungeonRewards
T.GetLFGDungeonShortageRewardInfo = GetLFGDungeonShortageRewardInfo
T.GetLFGRandomDungeonInfo = GetLFGRandomDungeonInfo
T.GetLFGRoleShortageRewards = GetLFGRoleShortageRewards
T.GetLifesteal = GetLifesteal
T.GetLocale = GetLocale
T.GetLootMethod = GetLootMethod
T.GetLootRollItemInfo = GetLootRollItemInfo
T.GetLootRollItemLink = GetLootRollItemLink
T.GetLootSlotInfo = GetLootSlotInfo
T.GetLootSlotLink = GetLootSlotLink
T.GetLootSlotType = GetLootSlotType
T.GetLootSpecialization = GetLootSpecialization
T.GetLootThreshold = GetLootThreshold
T.GetMacroInfo = GetMacroInfo
T.GetManaRegen = GetManaRegen
T.GetMapInfo = GetMapInfo
T.GetMasteryEffect = GetMasteryEffect
T.GetMaxBattlefieldID = GetMaxBattlefieldID
T.GetMaxLevelForExpansionLevel = GetMaxLevelForExpansionLevel
T.GetMaxPlayerHonorLevel = GetMaxPlayerHonorLevel
T.GetMaxPlayerLevel = GetMaxPlayerLevel
T.GetMaxTalentTier = GetMaxTalentTier
T.GetMeleeHaste = GetMeleeHaste
T.GetMerchantItemID = GetMerchantItemID
T.GetMerchantItemInfo = GetMerchantItemInfo
T.GetMerchantItemLink = GetMerchantItemLink
T.GetMerchantItemMaxStack = GetMerchantItemMaxStack
T.GetMerchantNumItems = GetMerchantNumItems
T.getmetatable = getmetatable
T.GetMinimapZoneText = GetMinimapZoneText
T.GetModResilienceDamageReduction = GetModResilienceDamageReduction
T.GetMoney = GetMoney
T.GetMoneyString = GetMoneyString
T.GetMouseFocus = GetMouseFocus
T.GetNetIpTypes = GetNetIpTypes
T.GetNetStats = GetNetStats
T.GetNumActiveQuests = GetNumActiveQuests
T.GetNumAuctionItems = GetNumAuctionItems
T.GetNumAddOns = GetNumAddOns
T.GetNumAutoQuestPopUps = GetNumAutoQuestPopUps
T.GetNumAvailableQuests = GetNumAvailableQuests
T.GetNumBattlefieldScores = GetNumBattlefieldScores
T.GetNumBuybackItems = GetNumBuybackItems
T.GetNumClasses = GetNumClasses
T.GetNumFactions = GetNumFactions
T.GetNumFilteredAchievements = GetNumFilteredAchievements
T.GetNumFriends = GetNumFriends
T.GetNumGossipActiveQuests = GetNumGossipActiveQuests
T.GetNumGossipAvailableQuests = GetNumGossipAvailableQuests
T.GetNumGossipOptions = GetNumGossipOptions
T.GetNumGroupMembers = GetNumGroupMembers
T.GetNumGuildMembers = GetNumGuildMembers
T.GetNumLootItems = GetNumLootItems
T.GetNumMacros = GetNumMacros
T.GetNumQuestChoices = GetNumQuestChoices
T.GetNumQuestItems = GetNumQuestItems
T.GetNumQuestLeaderBoards = GetNumQuestLeaderBoards
T.GetNumQuestLogEntries = GetNumQuestLogEntries
T.GetNumQuestLogRewardCurrencies = GetNumQuestLogRewardCurrencies
T.GetNumQuestLogRewardSpells = GetNumQuestLogRewardSpells
T.GetNumQuestWatches = GetNumQuestWatches
T.GetNumRandomDungeons = GetNumRandomDungeons
T.GetNumRewardSpells = GetNumRewardSpells
T.GetNumRFDungeons = GetNumRFDungeons
T.GetNumSavedInstances = GetNumSavedInstances
T.GetNumSavedWorldBosses = GetNumSavedWorldBosses
T.GetNumSpecGroups = GetNumSpecGroups
T.GetNumSpecializations = GetNumSpecializations
T.GetNumSpecializationsForClassID = GetNumSpecializationsForClassID
T.GetNumSubgroupMembers = GetNumSubgroupMembers
T.GetNumTitles = GetNumTitles
T.GetNumTrackingTypes = GetNumTrackingTypes
T.GetNumTrainerServices = GetNumTrainerServices
T.GetNumWatchedTokens = GetNumWatchedTokens
T.GetNumWorldPVPAreas = GetNumWorldPVPAreas
T.GetOverrideBarIndex = GetOverrideBarIndex
T.GetParryChance = GetParryChance
T.GetPersonalRatedInfo = GetPersonalRatedInfo
T.GetPetActionInfo = GetPetActionInfo
T.GetPlayerInfoByGUID = GetPlayerInfoByGUID
T.GetPlayerTradeMoney = GetPlayerTradeMoney
T.GetProfessionInfo = GetProfessionInfo
T.GetProfessions = GetProfessions
T.GetPVPLifetimeStats = GetPVPLifetimeStats
T.GetQuestDifficultyColor = GetQuestDifficultyColor
T.GetQuestItemInfo = GetQuestItemInfo
T.GetQuestItemLink = GetQuestItemLink
T.GetQuestLink = GetQuestLink
T.GetQuestLogCompletionText = GetQuestLogCompletionText
T.GetQuestLogIndexByID = GetQuestLogIndexByID
T.GetQuestLogLeaderBoard = GetQuestLogLeaderBoard
T.GetQuestLogSelection = GetQuestLogSelection
T.GetQuestLogSpecialItemCooldown = GetQuestLogSpecialItemCooldown
T.GetQuestLogSpecialItemInfo = GetQuestLogSpecialItemInfo
T.GetQuestLogRewardInfo = GetQuestLogRewardInfo
T.GetQuestLogRewardMoney = GetQuestLogRewardMoney
T.GetQuestLogRewardXP = GetQuestLogRewardXP
T.GetQuestLogTitle = GetQuestLogTitle
T.GetQuestObjectiveInfo = GetQuestObjectiveInfo
T.GetQuestReward = GetQuestReward
T.GetQuestLogRewardCurrencyInfo = GetQuestLogRewardCurrencyInfo
T.GetQuestTagInfo = GetQuestTagInfo
T.GetQuestUiMapID = GetQuestUiMapID
T.GetQuestWatchInfo = GetQuestWatchInfo
T.GetRaidDifficultyID = GetRaidDifficultyID
T.GetRaidRosterInfo = GetRaidRosterInfo
T.GetRaidTargetIndex = GetRaidTargetIndex
T.GetRangedCritChance = GetRangedCritChance
T.GetRangedHaste = GetRangedHaste
T.GetRealmName = GetRealmName
T.GetRealZoneText = GetRealZoneText
T.GetRecipeInfo = GetRecipeInfo
T.GetRFDungeonInfo = GetRFDungeonInfo
T.GetSavedInstanceInfo = GetSavedInstanceInfo
T.GetSavedWorldBossInfo = GetSavedWorldBossInfo
T.GetScreenHeight = GetScreenHeight
T.GetScreenWidth = GetScreenWidth
T.GetSelectedFaction = GetSelectedFaction
T.GetShapeshiftForm = GetShapeshiftForm
T.GetSortedSelfResurrectOptions = GetSortedSelfResurrectOptions
T.GetSpecialization = GetSpecialization
T.GetSpecializationInfo = GetSpecializationInfo
T.GetSpecializationInfoByID = GetSpecializationInfoByID
T.GetSpecializationInfoForClassID = GetSpecializationInfoForClassID
T.GetSpecializationRole = GetSpecializationRole
T.GetSpecializationRoleByID = GetSpecializationRoleByID
T.GetSpecializationSpells = GetSpecializationSpells
T.GetSpellAvailableLevel = GetSpellAvailableLevel
T.GetSpellBonusDamage = GetSpellBonusDamage
T.GetSpellBonusHealing = GetSpellBonusHealing
T.GetSpellBookItemInfo = GetSpellBookItemInfo
T.GetSpellCharges = GetSpellCharges
T.GetSpellCooldown = GetSpellCooldown
T.GetSpellCritChance = GetSpellCritChance
T.GetSpellHitModifier = GetSpellHitModifier
T.GetSpellInfo = GetSpellInfo
T.GetSpellLink = GetSpellLink
T.GetSpellRank = GetSpellRank
T.GetSpellTexture = GetSpellTexture
T.GetStatistic = GetStatistic
T.GetSubZoneText = GetSubZoneText
T.GetTalentInfo = GetTalentInfo
T.GetTalentInfoByID = GetTalentInfoByID
T.GetTalentLink = GetTalentLink
T.GetTargetTradeMoney = GetTargetTradeMoney
T.GetTaskInfo = GetTaskInfo
T.GetThreatStatusColor = GetThreatStatusColor
T.GetTime = GetTime
T.GetTitleName = GetTitleName
T.GetTrackingInfo = GetTrackingInfo
T.GetTradeSkillLine = GetTradeSkillLine
T.GetTradeSkillNumReagents = GetTradeSkillNumReagents
T.GetTradeSkillReagentInfo = GetTradeSkillReagentInfo
T.GetTradeTargetItemLink = GetTradeTargetItemLink
T.GetTrainerServiceInfo = GetTrainerServiceInfo
T.GetUnitName = GetUnitName
T.GetVehicleBarIndex = GetVehicleBarIndex
T.GetVersatilityBonus = GetVersatilityBonus
T.GetWatchedFactionInfo = GetWatchedFactionInfo
T.GetWeaponEnchantInfo = GetWeaponEnchantInfo
T.GetWhoInfo = GetWhoInfo
T.GetWorldPVPAreaInfo = GetWorldPVPAreaInfo
T.GetXPExhaustion = GetXPExhaustion
T.GetZonePVPInfo = GetZonePVPInfo
T.GetZoneText = GetZoneText
T.GroupFinderFrame_ShowGroupFrame = GroupFinderFrame_ShowGroupFrame
T.GroupLootContainer_AddFrame = GroupLootContainer_AddFrame
T.GroupLootContainer_RemoveFrame = GroupLootContainer_RemoveFrame
T.GuildControlGetNumRanks = GuildControlGetNumRanks
T.GuildControlGetRankName = GuildControlGetRankName
T.GuildInvite = GuildInvite
T.GuildRoster = GuildRoster
T.HasExtraActionBar = HasExtraActionBar
T.HasInspectHonorData = HasInspectHonorData
T.HasNewMail = HasNewMail
T.HaveQuestRewardData = HaveQuestRewardData
T.HideUIPanel = HideUIPanel
T.hooksecurefunc = hooksecurefunc
T.HybridScrollFrame_GetOffset = HybridScrollFrame_GetOffset
T.InCombatLockdown = InCombatLockdown
T.InviteToGroup = InviteToGroup
T.InviteUnit = InviteUnit
T.ipairs = ipairs
T.IsAddOnLoaded = IsAddOnLoaded
T.IsAltKeyDown = IsAltKeyDown
T.IsArtifactPowerItem = IsArtifactPowerItem
T.IsArtifactRelicItem = IsArtifactRelicItem
T.IsAvailableQuestTrivial = IsAvailableQuestTrivial
T.IsContainerItemAnUpgrade = IsContainerItemAnUpgrade
T.IsControlKeyDown = IsControlKeyDown
T.IsCurrentSpell = IsCurrentSpell
T.IsDressableItem = IsDressableItem
T.IsEquippableItem = IsEquippableItem
T.IsEveryoneAssistant = IsEveryoneAssistant
T.IsFactionInactive = IsFactionInactive
T.IsIndoors = IsIndoors
T.IsInGroup = IsInGroup
T.IsInGuild = IsInGuild
T.IsInInstance = IsInInstance
T.IsInLFGDungeon = IsInLFGDungeon
T.IsInRaid = IsInRaid
T.IsItemInRange = IsItemInRange
T.IsLFGDungeonJoinable = IsLFGDungeonJoinable
T.IsLoggedIn = IsLoggedIn
T.IsModifiedClick = IsModifiedClick
T.IsModifierKeyDown = IsModifierKeyDown
T.IsMounted = IsMounted
T.IsMouseButtonDown = IsMouseButtonDown
T.IsMouselooking = IsMouselooking
T.IsPartyLFG = IsPartyLFG
T.IsPassiveSpell = IsPassiveSpell
T.IsQuestBounty = IsQuestBounty
T.IsQuestFlaggedCompleted = IsQuestFlaggedCompleted
T.IsQuestTask = IsQuestTask
T.IsQuestWatched = IsQuestWatched
T.IsResting = IsResting
T.IsShiftKeyDown = IsShiftKeyDown
T.IsSpellKnown = IsSpellKnown
T.IsSpellOverlayed = IsSpellOverlayed
T.IsTitleKnown = IsTitleKnown
T.IsTradeSkillGuild = IsTradeSkillGuild
T.IsTradeSkillLinked = IsTradeSkillLinked
T.IsUsableItem = IsUsableItem
T.IsUsableSpell = IsUsableSpell
T.IsXPUserDisabled = IsXPUserDisabled
T.ItemHasRange = ItemHasRange
T.JoinLFG = JoinLFG
T.JoinTemporaryChannel = JoinTemporaryChannel
T.LE_TRANSMOG_TYPE_APPEARANCE = LE_TRANSMOG_TYPE_APPEARANCE
T.LE_TRANSMOG_TYPE_ILLUSION = LE_TRANSMOG_TYPE_ILLUSION
T.LearnPvpTalent = LearnPvpTalent
T.LearnTalent = LearnTalent
T.LFDQueueFrame_SetType = LFDQueueFrame_SetType
T.LFGListSearchEntryUtil_GetFriendList = LFGListSearchEntryUtil_GetFriendList
T.LFGListUtil_GetQuestDescription = LFGListUtil_GetQuestDescription
T.LoadAddOn = LoadAddOn
T.LoggingCombat = LoggingCombat
T.LootSlot = LootSlot
T.Mastery_OnEnter = Mastery_OnEnter
T.math_abs = math.abs
T.math_ceil = math.ceil
T.math_floor = math.floor
T.math_max = math.max
T.math_min = math.min
T.math_modf = math.modf
T.math_pi = math.pi
T.math_pow = math.pow
T.math_random = math.random
T.math_sqrt = math.sqrt
T.MerchantFrame_UpdateAltCurrency = MerchantFrame_UpdateAltCurrency
T.MerchantFrameItem_UpdateQuality = MerchantFrameItem_UpdateQuality
T.MinimapMailFrameUpdate = MinimapMailFrameUpdate
T.mod = mod
T.MoneyFrame_SetMaxDisplayWidth = MoneyFrame_SetMaxDisplayWidth
T.MoneyFrame_Update = MoneyFrame_Update
T.MouselookStop = MouselookStop
T.MovementSpeed_OnEnter = MovementSpeed_OnEnter
T.MovementSpeed_OnUpdate = MovementSpeed_OnUpdate
T.next = next
T.ObjectiveTracker_Collapse = ObjectiveTracker_Collapse
T.ObjectiveTracker_Expand = ObjectiveTracker_Expand
T.ObjectiveTracker_Update = ObjectiveTracker_Update
T.OpenAllBags = OpenAllBags
T.OpenAzeriteEmpoweredItemUIFromItemLocation = OpenAzeriteEmpoweredItemUIFromItemLocation
T.pairs = pairs
T.PanelTemplates_DeselectTab = PanelTemplates_DeselectTab
T.PanelTemplates_GetSelectedTab = PanelTemplates_GetSelectedTab
T.PanelTemplates_TabResize = PanelTemplates_TabResize
T.PaperDollFrame_SetItemLevel = PaperDollFrame_SetItemLevel
T.PaperDollFrame_SetLabelAndText = PaperDollFrame_SetLabelAndText
T.pcall = pcall
T.PickupContainerItem = PickupContainerItem
T.PickupMacro = PickupMacro
T.PlaceAuctionBid = PlaceAuctionBid
T.PlayerHasToy = PlayerHasToy
T.PlaySound = PlaySound
T.PlaySoundFile = PlaySoundFile
T.print = print
T.PVEFrame_ToggleFrame = PVEFrame_ToggleFrame
T.QuestFlagsPVP = QuestFlagsPVP
T.QuestGetAutoAccept = QuestGetAutoAccept
T.QuestHasPOIInfo = QuestHasPOIInfo
T.QuestInfo_GetRewardButton = QuestInfo_GetRewardButton
T.QuestIsFromAreaTrigger = QuestIsFromAreaTrigger
T.QuestUtils_IsQuestWorldQuest = QuestUtils_IsQuestWorldQuest
T.QueueStatusMinimapButton_OnLeave = QueueStatusMinimapButton_OnLeave
T.RaiseFrameLevel = RaiseFrameLevel
T.random = random
T.RegisterStateDriver = RegisterStateDriver
T.ReloadUI = ReloadUI
T.RemoveFriend = RemoveFriend
T.RemoveQuestWatch = RemoveQuestWatch
T.RepopMe = RepopMe
T.RequestRaidInfo = RequestRaidInfo
T.RequestTimePlayed = RequestTimePlayed
T.Screenshot = Screenshot
T.SearchLFGGetResults = SearchLFGGetResults
T.SecondsToTime = SecondsToTime
T.select = select
T.SelectActiveQuest = SelectActiveQuest
T.SelectAvailableQuest = SelectAvailableQuest
T.SelectGossipActiveQuest = SelectGossipActiveQuest
T.SelectGossipAvailableQuest = SelectGossipAvailableQuest
T.SelectGossipOption = SelectGossipOption
T.SendChatMessage = SendChatMessage
T.SendWho = SendWho
T.SetAchievementComparisonUnit = SetAchievementComparisonUnit
T.SetAchievementSearchString = SetAchievementSearchString
T.SetCurrentTitle = SetCurrentTitle
T.SetCVar = SetCVar
T.SetItemButtonCount = SetItemButtonCount
T.SetItemButtonNameFrameVertexColor = SetItemButtonNameFrameVertexColor
T.SetItemButtonNormalTextureVertexColor = SetItemButtonNormalTextureVertexColor
T.SetItemButtonSlotVertexColor = SetItemButtonSlotVertexColor
T.SetItemButtonStock = SetItemButtonStock
T.SetItemButtonTexture = SetItemButtonTexture
T.SetItemButtonTextureVertexColor = SetItemButtonTextureVertexColor
T.SetItemRef = SetItemRef
T.SetLFGDungeon = SetLFGDungeon
T.SetLFGRoles = SetLFGRoles
T.SetLootSpecialization = SetLootSpecialization
T.setmetatable = setmetatable
T.SetMoneyFrameColor = SetMoneyFrameColor
T.SetOverrideBindingClick = SetOverrideBindingClick
T.SetPortraitToTexture = SetPortraitToTexture
T.SetRaidTarget = SetRaidTarget
T.SetSpecialization = SetSpecialization
T.SetWatchedFactionIndex = SetWatchedFactionIndex
T.ShouldShowILevelInFollowerList = ShouldShowILevelInFollowerList
T.ShowFriends = ShowFriends
T.ShowGarrisonLandingPage = ShowGarrisonLandingPage
T.ShowQuestComplete = ShowQuestComplete
T.ShowUIPanel = ShowUIPanel
T.SlashCmdList = SlashCmdList
T.SocialQueueUtil_GetQueueName = SocialQueueUtil_GetQueueName
T.SocialQueueUtil_GetRelationshipInfo = SocialQueueUtil_GetRelationshipInfo
T.SocketInventoryItem = SocketInventoryItem
T.SortQuestWatches = SortQuestWatches
T.SpellBook_GetSpellBookSlot = SpellBook_GetSpellBookSlot
T.StaticPopup_Hide = StaticPopup_Hide
T.StaticPopup_Show = StaticPopup_Show
T.StaticPopupSpecial_Hide = StaticPopupSpecial_Hide
T.string_byte = string.byte
T.string_find = string.find
T.string_format = string.format
T.string_gmatch = string.gmatch
T.string_gsub = string.gsub
T.string_join = string.join
T.string_len = string.len
T.string_lower = string.lower
T.string_match = string.match
T.string_split = string.split
T.string_sub = string.sub
T.string_upper = string.upper
T.string_utf8sub = string.utf8sub
T.strtrim = strtrim
T.table_concat = table.concat
T.table_copy = table.copy
T.table_getn = table.getn
T.table_insert = table.insert
T.table_maxn = table.maxn
T.table_sort = table.sort
T.table_wipe = table.wipe
T.table_remove = table.remove
T.TakeTaxiNode = TakeTaxiNode
T.TalentFrame_LoadUI = TalentFrame_LoadUI
T.TalkingHead_LoadUI = TalkingHead_LoadUI
T.tContains = tContains
T.time = time
T.ToggleAllBags = ToggleAllBags
T.ToggleCharacter = ToggleCharacter
T.ToggleCommunitiesFrame = ToggleCommunitiesFrame
T.ToggleDropDownMenu = ToggleDropDownMenu
T.ToggleFrame = ToggleFrame
T.ToggleGuildFrame = ToggleGuildFrame
T.ToggleTalentFrame = ToggleTalentFrame
T.ToggleWorldMap = ToggleWorldMap
T.TokenFrame_Update = TokenFrame_Update
T.TopBannerManager_Show = TopBannerManager_Show
T.tonumber = tonumber
T.tostring = tostring
T.type = type
T.UIDropDownMenu_AddButton = UIDropDownMenu_AddButton
T.UIDropDownMenu_AddSeparator = UIDropDownMenu_AddSeparator
T.UIDropDownMenu_CreateInfo = UIDropDownMenu_CreateInfo
T.UIDropDownMenu_Initialize = UIDropDownMenu_Initialize
T.UIDropDownMenu_SetSelectedID = UIDropDownMenu_SetSelectedID
T.UIErrorsFrame = UIErrorsFrame
T.UIFrameFade = UIFrameFade
T.UIFrameFadeIn = UIFrameFadeIn
T.UIFrameFadeOut = UIFrameFadeOut
T.UIParent = UIParent
T.UIParentLoadAddOn = UIParentLoadAddOn
T.UISpecialFrames = UISpecialFrames
T.UnitAffectingCombat = UnitAffectingCombat
T.UnitArmor = UnitArmor
T.UnitAttackPower = UnitAttackPower
T.UnitAttackSpeed = UnitAttackSpeed
T.UnitAura = UnitAura
T.UnitBattlePetSpeciesID = UnitBattlePetSpeciesID
T.UnitBattlePetType = UnitBattlePetType
T.UnitBuff = UnitBuff
T.UnitCanAttack = UnitCanAttack
T.UnitCastingInfo = UnitCastingInfo
T.UnitChannelInfo = UnitChannelInfo
T.UnitClass = UnitClass
T.UnitClassification = UnitClassification
T.UnitDamage = UnitDamage
T.UnitDebuff = UnitDebuff
T.UnitDetailedThreatSituation = UnitDetailedThreatSituation
T.UnitExists = UnitExists
T.UnitFactionGroup = UnitFactionGroup
T.UnitFullName = UnitFullName
T.UnitGroupRolesAssigned = UnitGroupRolesAssigned
T.UnitGUID = UnitGUID
T.UnitHealth = UnitHealth
T.UnitHealthMax = UnitHealthMax
T.UnitHonor = UnitHonor
T.UnitHonorLevel = UnitHonorLevel
T.UnitHonorMax = UnitHonorMax
T.UnitInParty = UnitInParty
T.UnitInRaid = UnitInRaid
T.UnitInVehicle = UnitInVehicle
T.UnitIsAFK = UnitIsAFK
T.UnitIsBattlePet = UnitIsBattlePet
T.UnitIsConnected = UnitIsConnected
T.UnitIsDead = UnitIsDead
T.UnitIsDeadOrGhost = UnitIsDeadOrGhost
T.UnitIsDND = UnitIsDND
T.UnitIsGhost = UnitIsGhost
T.UnitIsGroupAssistant = UnitIsGroupAssistant
T.UnitIsGroupLeader = UnitIsGroupLeader
T.UnitIsInMyGuild = UnitIsInMyGuild
T.UnitIsPlayer = UnitIsPlayer
T.UnitIsTapDenied = UnitIsTapDenied
T.UnitIsUnit = UnitIsUnit
T.UnitIsVisible = UnitIsVisible
T.UnitLevel = UnitLevel
T.UnitName = UnitName
T.UnitOnTaxi = UnitOnTaxi
T.UnitPlayerOrPetInParty = UnitPlayerOrPetInParty
T.UnitPlayerOrPetInRaid = UnitPlayerOrPetInRaid
T.UnitPowerBarAltStatus_UpdateText = UnitPowerBarAltStatus_UpdateText
T.UnitPower = UnitPower
T.UnitPowerMax = UnitPowerMax
T.UnitPowerType = UnitPowerType
T.UnitPVPName = UnitPVPName
T.UnitRace = UnitRace
T.UnitRangedAttackPower = UnitRangedAttackPower
T.UnitRangedDamage = UnitRangedDamage
T.UnitReaction = UnitReaction
T.UnitRealmRelationship = UnitRealmRelationship
T.UnitSetRole = UnitSetRole
T.UnitSex = UnitSex
T.UnitSpellHaste = UnitSpellHaste
T.UnitStat = UnitStat
T.UnitVehicleSeatCount = UnitVehicleSeatCount
T.UnitXP = UnitXP
T.UnitXPMax = UnitXPMax
T.unpack = unpack
T.UnregisterStateDriver = UnregisterStateDriver
T.UpdateAddOnCPUUsage = UpdateAddOnCPUUsage
T.UpdateAddOnMemoryUsage = UpdateAddOnMemoryUsage
T.UseContainerItem = UseContainerItem
T.UseItemByName = UseItemByName
T.VehicleSeatIndicator_SetUpVehicle = VehicleSeatIndicator_SetUpVehicle
T.WardrobeCollectionFrame_OpenTransmogLink = WardrobeCollectionFrame_OpenTransmogLink
T.WrapTextInColorCode = WrapTextInColorCode

T.GetSpell = function(id)
	local name = T.GetSpellInfo(id)
	return name
end

T.SafeHookScript = function (frame, handlername, newscript)
	local oldValue = frame:GetScript(handlername)
	frame:SetScript(handlername, newscript)
	return oldValue
end

KUI.IsDev = {
	["Klix"] = true,
	["Klixi"] = true,
	["Klixx"] = true,
}

KUI.IsDevRealm = {
	["Twisting Nether"] = true,
}

function KUI:IsDeveloper()
	return KUI.IsDev[E.myname] or false
end

function KUI:IsDeveloperRealm()
	return KUI.IsDevRealm[E.myrealm] or false
end

function KUI:Print(...)
	T.print("|cfff960d9".."KlixUI:|r", ...)
end

function KUI:PrintURL(url) -- Credits: Azilroka
	return T.string_format("|cfff960d9[|Hurl:%s|h%s|h]|r", url, url)
end

function KUI:ErrorPrint(msg)
	T.print("|cffFF0000KlixUI Error:|r", msg)
end

function KUI:cOption(name)
	local color = '|cfff960d9%s |r'
	return (color):format(name)
end

function KUI:MismatchText()
	local text = T.string_format(L["MSG_KUI_ELV_OUTDATED"], KUI.ElvUIV, KUI.ElvUIX)
	return text
end

-- Inform us of the patch info we play on.
_G.SLASH_WOWVERSION1, _G.SLASH_WOWVERSION2 = "/patch", "/version"
SlashCmdList["WOWVERSION"] = function()
	KUI:Print("Patch:", KUI.WoWPatch..", ".. "Build:", KUI.WoWBuild..", ".. "Released", KUI.WoWPatchReleaseDate..", ".. "Interface:", KUI.TocVersion)
end

-- Register KlixUI media here
function KUI:RegisterKuiMedia()
	--Fonts
	E.media.CGB = LSM:Fetch('font', 'Century Gothic Bold')
	E.media.Days = LSM:Fetch('font', 'Days')
	E.media.Expressway = LSM:Fetch('font', 'Expressway')

	--Textures
	E.media.Empty = LSM:Fetch('statusbar', 'Empty')
	E.media.Klix = LSM:Fetch('statusbar', 'Klix')
	E.media.Klix1 = LSM:Fetch('statusbar', 'Klix1')
	E.media.Klix2 = LSM:Fetch('statusbar', 'Klix2')
	E.media.Klix3 = LSM:Fetch('statusbar', 'Klix3')
	E.media.KlixRainbow1 = LSM:Fetch('statusbar', 'KlixRainbow1')
	E.media.KlixRainbow2 = LSM:Fetch('statusbar', 'KlixRainbow2')
	E.media.KlixGradient = LSM:Fetch("statusbar", "KlixGradient")
	E.media.KuiOnePixel = LSM:Fetch('statusbar', 'KuiOnePixel')
	E.media.KlixBlank = LSM:Fetch('statusbar', 'KlixBlank')
	
	-- Custom Textures
	E.media.roleIcons = [[Interface\AddOns\ElvUI_KlixUI\media\textures\UI-LFG-ICON-ROLES]]
end

-- Color and class color stuff
function KUI:unpackColor(color)
	return color.r, color.g, color.b, color.a
end

KUI.ClassColor = E.myclass == "PRIEST" and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])
KUI.ClassColors = {}

KUI.Classes = {}

for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do KUI.Classes[v] = k end
for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do KUI.Classes[v] = k end

local colors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
for class in T.pairs(colors) do
	KUI.ClassColors[class] = {}
	KUI.ClassColors[class].r = colors[class].r
	KUI.ClassColors[class].g = colors[class].g
	KUI.ClassColors[class].b = colors[class].b
	KUI.ClassColors[class].colorStr = colors[class].colorStr
end
KUI.r, KUI.g, KUI.b = KUI.ClassColors[E.myclass].r, KUI.ClassColors[E.myclass].g, KUI.ClassColors[E.myclass].b

function KUI:ClassColor(class)
	local color = KUI.ClassColors[class]
	if not color then return 1, 1, 1 end
	return color.r, color.g, color.b
end

function KUI:ClassColorCode(class)
	local color = class and (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[KUI.Classes[class]] or RAID_CLASS_COLORS[KUI.Classes[class]]) or { r = 1, g = 1, b = 1 }

	return format('FF%02x%02x%02x', color.r * 255, color.g * 255, color.b * 255)
end

KUI.colors = {
	class = {},
}

-- Convert RGB values to Hexdecimal
-- Here is r, g, b valuesbetween 0~1
local function RGBToHex(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return T.string_format("%02x%02x%02x", r*255, g*255, b*255)
end

-- Custom color to string
function KUI:ColorStr(str, r, g, b)
	local hex
	local coloredString
	
	if r and g and b then
		hex = RGBToHex(r, g, b)
	else
		-- Default string is light blue
		hex = RGBToHex(52/255, 152/255, 219/255)
	end
	
	coloredString = "|cff"..hex..str.."|r"
	return coloredString
end

-- Search in a table like {"arg1", "arg2", "arg3"}
function KUI:SimpleTable(table, item)
	for i = 1, #table do
		if table[i] == item then  
			return true 
		end
	end

	return false
end

KUI.CheckChat = function(warning)
	if T.IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		return "INSTANCE_CHAT"
	elseif T.IsInRaid(LE_PARTY_CATEGORY_HOME) then
		if warning and (T.UnitIsGroupLeader("player") or T.UnitIsGroupAssistant("player") or T.IsEveryoneAssistant()) then
			return "RAID_WARNING"
		else
			return "RAID"
		end
	elseif T.IsInGroup(LE_PARTY_CATEGORY_HOME) then
		return "PARTY"
	end
	return "SAY"
end

function KUI:IsAddOnEnabled(addon, character)
	if (T.type(character) == 'boolean' and character == true) then
		character = nil
	end
	return T.GetAddOnEnableState(character, addon) == 2
end

function KUI:IsAddOnPartiallyEnabled(addon, character)
	if (T.type(character) == 'boolean' and character == true) then
		character = nil
	end
	return T.GetAddOnEnableState(character, addon) == 1
end

function KUI:PairsByKeys(t, f)
	local a = {}
	for n in T.pairs(t) do T.table_insert(a, n) end
	T.table_sort(a, f)
	local i = 0
	local iter = function()
		i = i + 1
		if a[i] == nil then return nil
			else return a[i], t[a[i]]
		end
	end
	return iter
end

-- Movers
function KUI:SetMoverPosition(mover, point, anchor, secondaryPoint, x, y)
	if not _G[mover] then return end
	local frame = _G[mover]

	frame:ClearAllPoints()
	frame:SetPoint(point, anchor, secondaryPoint, x, y)
	E:SaveMoverPosition(mover)
end

function KUI:AddMoverCategories()
	T.table_insert(E.ConfigModeLayouts, #(E.ConfigModeLayouts) + 1, "KLIXUI")
	E.ConfigModeLocalizedStrings["KLIXUI"] = T.string_format("|cfff960d9%s |r", "KlixUI")
end

-- Reset stuff
function KUI:Reset(group)
	if not group then T.print("U wot m8?") end

	if group == "marks" or group == "all" then
		E:CopyTable(E.db.KlixUI.raidmarkers, P.KlixUI.raidmarkers)
		E:ResetMovers(L["Raid Marker Bar"])
	end
	E:UpdateAll()
end

function KUI:GetMapInfo(id, arg)
	if not arg then return end
	local MapInfo = T.C_Map_GetMapInfo(id)
	if not MapInfo then return UNKNOWN end
	-- for k,v in pairs(MapInfo) do print(k,v) end
	if arg == "all" then return MapInfo["name"], MapInfo["mapID"], MapInfo["parentMapID"], MapInfo["mapType"] end
	return MapInfo[arg]
end

function KUI:SetupProfileCallbacks()
	E.data.RegisterCallback(self, "OnProfileChanged", "UpdateAll")
	E.data.RegisterCallback(self, "OnProfileCopied", "UpdateAll")
	E.data.RegisterCallback(self, "OnProfileReset", "UpdateAll")
end

-- Whiro's DB code magic
function KUI:UpdateRegisteredDBs()
	if (not KUI["RegisteredDBs"]) then
		return
	end

	local dbs = KUI["RegisteredDBs"]

	for tbl, path in T.pairs(dbs) do
		self:UpdateRegisteredDB(tbl, path)
	end
end

function KUI:UpdateRegisteredDB(tbl, path)
	local path_parts = {strsplit(".", path)}
	local _db = E.db.KlixUI
	for _, path_part in T.ipairs(path_parts) do
		_db = _db[path_part]
	end
	tbl.db = _db
end

function KUI:RegisterDB(tbl, path)
	if (not KUI["RegisteredDBs"]) then
		KUI["RegisteredDBs"] = {}
	end
	self:UpdateRegisteredDB(tbl, path)
	KUI["RegisteredDBs"][tbl] = path
end

function KUI:UpdateAll()
	self:UpdateRegisteredDBs()
	for _, mod in T.pairs(self["RegisteredModules"]) do
		if mod and mod.ForUpdateAll then
			mod:ForUpdateAll();
		end	
	end
end

-- Create moveable buttons in config
local function MovableButton_Match(s,v)
	local m1, m2, m3, m4 = "^"..v.."$", "^"..v..",", ","..v.."$", ","..v..","
	return (T.string_match(s, m1) and m1) or (T.string_match(s, m2) and m2) or (T.string_match(s, m3) and m3) or (T.string_match(s, m4) and v..",")
end
function KUI:MovableButtonSettings(db, key, value, remove, movehere)
	local str = db[key]
	if not db or not str or not value then return end
	local found = MovableButton_Match(str, E:EscapeString(value))
	if found and movehere then
		local tbl, sv, sm = {T.string_split(",", str)}
		for i in T.ipairs(tbl) do
			if tbl[i] == value then sv = i elseif tbl[i] == movehere then sm = i end
			if sv and sm then break end
		end
		T.table_remove(tbl, sm);
		T.table_insert(tbl, sv, movehere);

		db[key] = T.table_concat(tbl,',')

	elseif found and remove then
		db[key] = T.string_gsub(str, found, "")
	elseif not found and not remove then
		db[key] = (str == '' and value) or (str..","..value)
	end
end

function KUI:CreateMovableButtons(Order, Name, CanRemove, db, key)
	local moveItemFrom, moveItemTo
	local config = {
		order = Order,
		dragdrop = true,
		type = "multiselect",
		name = Name,
		dragOnLeave = function() end, --keep this here
		dragOnEnter = function(info)
			moveItemTo = info.obj.value
		end,
		dragOnMouseDown = function(info)
			moveItemFrom, moveItemTo = info.obj.value, nil
		end,
		dragOnMouseUp = function(info)
			KUI:MovableButtonSettings(db, key, moveItemTo, nil, moveItemFrom) --add it in the new spot
			moveItemFrom, moveItemTo = nil, nil
		end,
		stateSwitchGetText = function(info, TEXT)
			local text = T.GetItemInfo(T.tonumber(TEXT))
			info.userdata.text = text
			return text
		end,
		stateSwitchOnClick = function(info)
			KUI:MovableButtonSettings(db, key, moveItemFrom)
		end,
		values = function()
			local str = db[key]
			if str == "" then return nil end
			return {T.string_split(",",str)}
		end,
		get = function(info, value)
			local str = db[key]
			if str == "" then return nil end
			local tbl = {T.string_split(",",str)}
			return tbl[value]
		end,
		set = function(info, value) end,
	}
	if CanRemove then --This allows to remove shit
		config.dragOnClick = function(info)
			KUI:MovableButtonSettings(db, key, moveItemFrom, true)
		end
	end
	return config
end

-- Create font string
function KUI:CreateText(f, layer, fontsize, flag, justifyh)
	local text = f:CreateFontString(nil, layer)
	text:SetFont(E.media.normFont, fontsize, flag)
	text:SetJustifyH(justifyh or "CENTER")
	return text
end

-- Tooltip scanning stuff
local iLvlDB = {}
local itemLevelString = _G["ITEM_LEVEL"]:gsub("%%d", "")
local tip = T.CreateFrame("GameTooltip", "Kui_iLvlTooltip", nil, "GameTooltipTemplate")

function KUI:GetItemLevel(link, arg1, arg2)
	if iLvlDB[link] then return iLvlDB[link] end

	tip:SetOwner(UIParent, "ANCHOR_NONE")
	if arg1 and T.type(arg1) == "string" then
		tip:SetInventoryItem(arg1, arg2)
	elseif arg1 and T.type(arg1) == "number" then
		tip:SetBagItem(arg1, arg2)
	else
		tip:SetHyperlink(link)
	end

	for i = 2, 5 do
		local text = _G[tip:GetName().."TextLeft"..i]:GetText() or ""
		local found = text:find(itemLevelString)
		if found then
			local level = text:match("(%d+)%)?$")
			iLvlDB[link] = T.tonumber(level)
			break
		end
	end
	return iLvlDB[link]
end

function KUI:GetIconFromID(type, id)
    local path
    if type == "item" then
        path = T.select(10, T.GetItemInfo(id))
    elseif type == "spell" then
        path = T.select(3, T.GetSpellInfo(id))
    elseif type == "achiev" then
        path = T.select(10, T.GetAchievementInfo(id))
    end
    return path or nil
end

function KUI:BagSearch(itemId)
    for container = 0, NUM_BAG_SLOTS do
        for slot = 1, T.GetContainerNumSlots(container) do
            if itemId == T.GetContainerItemID(container, slot) then
                return container, slot
            end
        end
    end
end

-- Talent module stuff
-- Prints all the key value pairs in the given table (See python's dir() function)
function dir(t)
    for k, v in T.pairs(t) do
        T.print(k, v)
    end
end

-- Returns the length of the given table
function table.length(t)
    local count = 0
    for k, v in T.pairs(t) do
        count = count + 1
    end
    return count
end

function KUI:UpdateSoftGlowColor()
	if KUI["softGlow"] == nil then KUI["softGlow"] = {} end

	local sr, sg, sb = KUI:unpackColor(E.db.general.valuecolor)

	for glow, _ in T.pairs(KUI["softGlow"]) do
		if glow then
			glow:SetBackdropBorderColor(sr, sg, sb, 0.6)
		else
			KUI["softGlow"][glow] = nil
		end
	end
end
hooksecurefunc(E, "UpdateMedia", KUI.UpdateSoftGlowColor)

function KUI:CreatePulse(frame, speed, alpha, mult)
	T.assert(frame, "doesn't exist!")
	
	frame.speed = .02
	frame.mult = mult or 1
	frame.alpha = alpha or 1
	frame.tslu = 0
	frame:SetScript("OnUpdate", function(self, elapsed)
		elapsed = elapsed * (speed or 5/4)
		self.tslu = self.tslu + elapsed
		if self.tslu > self.speed then
			self.tslu = 0
			self:SetAlpha(self.alpha*(alpha or 3/5))
		end
		self.alpha = self.alpha - elapsed*self.mult
		if self.alpha < 0 and self.mult > 0 then
			self.mult = self.mult*-1
			self.alpha = 0
		elseif self.alpha > 1 and self.mult < 0 then
			self.mult = self.mult*-1
		end
	end)
end

local function CreateWideShadow(f)
	local borderr, borderg, borderb = 0, 0, 0
	local backdropr, backdropg, backdropb = 0, 0, 0

	local wideshadow = f.wideshadow or T.CreateFrame('Frame', nil, f) -- This way you can replace current shadows.
	wideshadow:SetFrameLevel(1)
	wideshadow:SetFrameStrata('BACKGROUND')
	wideshadow:SetOutside(f, 6, 6)
	wideshadow:SetBackdrop( { 
		edgeFile = LSM:Fetch('border', 'ElvUI GlowBorder'), edgeSize = E:Scale(6),
		insets = {left = E:Scale(8), right = E:Scale(8), top = E:Scale(8), bottom = E:Scale(8)},
	})
	wideshadow:SetBackdropColor(backdropr, backdropg, backdropb, 0)
	wideshadow:SetBackdropBorderColor(borderr, borderg, borderb, 0.5)
	f.wideshadow = wideshadow
end

local function CreateSoftShadow(f)
	local borderr, borderg, borderb = 0, 0, 0
	local backdropr, backdropg, backdropb = 0, 0, 0

	local softshadow = f.softshadow or T.CreateFrame('Frame', nil, f) -- This way you can replace current shadows.
	softshadow:SetFrameLevel(1)
	softshadow:SetFrameStrata('BACKGROUND')
	softshadow:SetOutside(f, 2, 2)
	softshadow:SetBackdrop( { 
		edgeFile = LSM:Fetch('border', 'ElvUI GlowBorder'), edgeSize = E:Scale(2),
		insets = {left = E:Scale(5), right = E:Scale(5), top = E:Scale(5), bottom = E:Scale(5)},
	})
	softshadow:SetBackdropColor(backdropr, backdropg, backdropb, 0)
	softshadow:SetBackdropBorderColor(borderr, borderg, borderb, 0.4)
	f.softshadow = softshadow
end

local function CreateSoftGlow(f)
	if f.sglow then return end

	local r, g, b = KUI:unpackColor(E.db.general.valuecolor)
	local sglow = T.CreateFrame('Frame', nil, f)

	sglow:SetFrameLevel(1)
	sglow:SetFrameStrata(f:GetFrameStrata())
	sglow:SetOutside(f, 3, 3)
	sglow:SetBackdrop( { 
		edgeFile = LSM:Fetch('border', 'ElvUI GlowBorder'), edgeSize = E:Scale(3),
		insets = {left = E:Scale(5), right = E:Scale(5), top = E:Scale(5), bottom = E:Scale(5)},
	})

	sglow:SetBackdropBorderColor(r, g, b, 0.6)

	f.sglow = sglow
	KUI["softGlow"][sglow] = true
end

local function CreateIconShadow(f, alpha)
	if T.IsAddOnLoaded("Masque") then return end
	
	if E.db.KlixUI.general == nil then E.db.KlixUI.general = {} end
	if f.ishadow or E.db.KlixUI.general.iconShadow ~= true then return end
	
	local ishadow = f:CreateTexture(nil, "OVERLAY")
	ishadow:SetInside(f, 1, 1)
	ishadow:SetTexture([[Interface\AddOns\ElvUI_KlixUI\media\textures\overlay]])
	ishadow:SetVertexColor(1, 1, 1, alpha or 1)
	ishadow:SetSize(f:GetSize())

	f.ishadow = ishadow
	
	KUI["iconShadow"][ishadow] = true
end

local function Styling(f, useSquares, useGradient, useShadow, shadowOverlayWidth, shadowOverlayHeight, shadowOverlayAlpha)
	T.assert(f, "doesn't exist!")
	local frameName = f.GetName and f:GetName()
	if E.db.KlixUI.general == nil then E.db.KlixUI.general = {} end
	if f.styling or E.db.KlixUI.general.style == "NONE" then return end

	local style = T.CreateFrame("Frame", frameName or nil, f)

	if not(useSquares) and E.db.KlixUI.general.style == "ALL" or E.db.KlixUI.general.style == "SQUARES" then
		local squares = f:CreateTexture(f:GetName() and f:GetName().."Overlay" or nil, "BORDER", f)
		squares:ClearAllPoints()
		squares:SetPoint("TOPLEFT", 1, -1)
		squares:SetPoint("BOTTOMRIGHT", -1, 1)
		squares:SetTexture([[Interface\AddOns\ElvUI_KlixUI\media\textures\squares]], true, true)
		squares:SetHorizTile(true)
		squares:SetVertTile(true)
		squares:SetBlendMode("ADD")

		f.squares = squares
	end

	if not(useGradient) then
		local gradient = f:CreateTexture(f:GetName() and f:GetName().."Overlay" or nil, "BORDER", f)
		gradient:ClearAllPoints()
		gradient:SetPoint("TOPLEFT", 1, -1)
		gradient:SetPoint("BOTTOMRIGHT", -1, 1)
		gradient:SetTexture([[Interface\AddOns\ElvUI_KlixUI\media\textures\gradient.tga]])
		gradient:SetVertexColor(.3, .3, .3, .15)

		f.gradient = gradient
	end

	if not(useShadow) and E.db.KlixUI.general.style == "ALL" or E.db.KlixUI.general.style == "SHADOW" then
		local mshadow = f:CreateTexture(f:GetName() and f:GetName().."Overlay" or nil, "BORDER", f)
		mshadow:SetInside(f, 0, 0)
		mshadow:SetWidth(shadowOverlayWidth or 33)
		mshadow:SetHeight(shadowOverlayHeight or 33)
		mshadow:SetTexture([[Interface\AddOns\ElvUI_KlixUI\media\textures\overlay]])
		mshadow:SetVertexColor(1, 1, 1, shadowOverlayAlpha or 0.6)

		f.mshadow = mshadow
	end

	style:SetFrameLevel(f:GetFrameLevel() + 1)
	f.styling = style

	KUI["styling"][style] = true
end

local function addapi(object)
	local mt = T.getmetatable(object).__index
	if not object.Styling then mt.Styling = Styling end
	if not object.CreateIconShadow then mt.CreateIconShadow = CreateIconShadow end
	if not object.CreateSoftShadow then mt.CreateSoftShadow = CreateSoftShadow end
	if not object.CreateWideShadow then mt.CreateWideShadow = CreateWideShadow end
	if not object.CreateSoftGlow then mt.CreateSoftGlow = CreateSoftGlow end
end

local handled = {["Frame"] = true}
local object = T.CreateFrame("Frame")
addapi(object)
addapi(object:CreateTexture())
addapi(object:CreateFontString())

object = EnumerateFrames()
while object do
	if not object:IsForbidden() and not handled[object:GetObjectType()] then
		addapi(object)
		handled[object:GetObjectType()] = true
	end
	object = EnumerateFrames(object)
end