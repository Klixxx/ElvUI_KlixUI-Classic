local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local B = KUI:NewModule("Blizzard", 'AceHook-3.0', 'AceEvent-3.0')

--Frames to move
B.Frames = {
	"AddonList",
	"AudioOptionsFrame",
	"BankFrame",
	"CharacterFrame",
	"ChatConfigFrame",
	"DressUpFrame",
	"FriendsFrame",
	"FriendsFriendsFrame",
	"GameMenuFrame",
	"GossipFrame",
	"GuildRegistrarFrame",
	"HelpFrame",
	"InterfaceOptionsFrame",
	"ItemTextFrame",
	"LootFrame",
	"MailFrame",
	"MerchantFrame",
	"OpenMailFrame",
	"PetStableFrame",
	"PetitionFrame",
	"QuestFrame",
	"QuestLogFrame",
	"RaidInfoFrame",
	"RaidParentFrame",
	"ReadyCheckFrame",
	"ReportCheatingDialog",
	"ScrollOfResurrectionSelectionFrame",
	"SpellBookFrame",
	"StackSplitFrame",
	"StaticPopup1",
	"StaticPopup2",
	"StaticPopup3",
	"StaticPopup4",
	"TabardFrame",
	"TaxiFrame",
	"TimeManagerFrame",
	"TradeFrame",
	"TutorialFrame",
	"VideoOptionsFrame",
	"WorldMapFrame",
}

--These should be only temporary movable due to complications
B.TempOnly = {
	["BonusRollFrame"] = true,
	["BonusRollLootWonFrame"] = true,
	["BonusRollMoneyWonFrame"] = true,
}

--Blizz addons that load later
B.AddonsList = {
	["Blizzard_AchievementUI"] = { "AchievementFrame" },
	["Blizzard_AlliedRacesUI"] = { "AlliedRacesFrame" },
	["Blizzard_ArchaeologyUI"] = { "ArchaeologyFrame" },
	["Blizzard_AuctionUI"] = { "AuctionFrame" },
	["Blizzard_AzeriteUI"] = { "AzeriteEmpoweredItemUI" },
	["Blizzard_BarberShopUI"] = { "BarberShopFrame" },
	["Blizzard_BindingUI"] = { "KeyBindingFrame" },
	["Blizzard_BlackMarketUI"] = { "BlackMarketFrame" },
	["Blizzard_Calendar"] = { "CalendarCreateEventFrame", "CalendarFrame" },
	["Blizzard_ChallengesUI"] = { "ChallengesKeystoneFrame" }, -- 'ChallengesLeaderboardFrame'
	["Blizzard_Collections"] = { "CollectionsJournal", "WardrobeFrame" },
	["Blizzard_Communities"] = { "CommunitiesFrame" },
	["Blizzard_CraftUI"] = { "CraftFrame" },
	["Blizzard_EncounterJournal"] = { "EncounterJournal" },
	["Blizzard_GarrisonUI"] = {
		"GarrisonLandingPage", "GarrisonMissionFrame", "GarrisonCapacitiveDisplayFrame",
		"GarrisonBuildingFrame", "GarrisonRecruiterFrame", "GarrisonRecruitSelectFrame",
		"GarrisonShipyardFrame", "OrderHallMissionFrame", "BFAMissionFrame",
	},
	["Blizzard_GMChatUI"] = { "GMChatStatusFrame" },
	["Blizzard_GMSurveyUI"] = { "GMSurveyFrame" },
	["Blizzard_GuildBankUI"] = { "GuildBankFrame" },
	["Blizzard_GuildControlUI"] = { "GuildControlUI" },
	["Blizzard_GuildUI"] = { "GuildFrame", "GuildLogFrame" },
	["Blizzard_InspectUI"] = { "InspectFrame" },
	["Blizzard_ItemAlterationUI"] = { "TransmogrifyFrame" },
	["Blizzard_ItemSocketingUI"] = { "ItemSocketingFrame" },
	["Blizzard_ItemUpgradeUI"] = { "ItemUpgradeFrame" },
	["Blizzard_LookingForGuildUI"] = { "LookingForGuildFrame" },
	["Blizzard_MacroUI"] = { "MacroFrame" },
	["Blizzard_OrderHallUI"] = { "OrderHallTalentFrame" },
	["Blizzard_QuestChoice"] = { "QuestChoiceFrame" },
	["Blizzard_ScrappingMachineUI"] = { "ScrappingMachineFrame" },
	["Blizzard_TalentUI"] = { "TalentFrame" },
	["Blizzard_TradeSkillUI"] = { "TradeSkillFrame" },
	["Blizzard_TrainerUI"] = { "ClassTrainerFrame" },
	["Blizzard_VoidStorageUI"] = { "VoidStorageFrame" },
}

-- These should not be on screen at the same time
B.ExlusiveFrames = {
	["QuestFrame"] = { "GossipFrame", },
	["GossipFrame"] = { "QuestFrame", },
	["GameMenuFrame"] = { "VideoOptionsFrame", "InterfaceOptionsFrame", "HelpFrame",},
	["VideoOptionsFrame"] = { "GameMenuFrame",},
	["InterfaceOptionsFrame"] = { "GameMenuFrame",},
	["HelpFrame"] = { "GameMenuFrame",},
}

B.FramesAreaAlter = {
	["GarrisonMissionFrame"] = "left",
	["OrderHallMissionFrame"] = "left",
	["BFAMissionFrame"] = "left",
}

B.SpecialDefaults = {
	["GarrisonMissionFrame"] = { "CENTER", _G.UIParent, "CENTER", 0, 0 },
	["OrderHallMissionFrame"] = { "CENTER", _G.UIParent, "CENTER", 0, 0 },
	["BFAMissionFrame"] = { "CENTER", _G.UIParent, "CENTER", 0, 0 },
}

B.OriginalDefaults = {}

local function OnDragStart(self)
	if T.UnitAffectingCombat("player") then return end -- Not allowed to move in combat, cause reasons.
	local Name = self:GetName()
	if not E.private.KlixUI.module.blizzmove.remember and not B.OriginalDefaults[Name] then
		local a, _, c, d, e = self:GetPoint()
		local b = self:GetParent():GetName() or _G.UIParent
		B.OriginalDefaults[Name] = {a, b, c, d, e}
	end
	self.IsMoving = true
	self:StartMoving()
end

--When stop moving (or hiding), remember frame's positions.
local function OnDragStop(self)
	self:StopMovingOrSizing()
	local Name = self:GetName()
	if E.private.KlixUI.module.blizzmove.remember and not B.TempOnly[Name] then -- Saving positions only if option is enabled and frame is not temporary movable
		local a, _, c, d, e = self:GetPoint()
		local b = self:GetParent():GetName() or _G.UIParent
		if Name == "QuestFrame" or Name == "GossipFrame" then -- These 2 frames should always be in the same place. So having coordinates for them at the same time
			E.private.KlixUI.module.blizzmove.points["GossipFrame"] = {a, b, c, d, e}
			E.private.KlixUI.module.blizzmove.points["QuestFrame"] = {a, b, c, d, e}
		else
			E.private.KlixUI.module.blizzmove.points[Name] = {a, b, c, d, e}
		end
		self:SetUserPlaced(true)
	elseif self:IsUserPlaced() then --Unfuck the game
		self:ClearAllPoints()
		self:SetUserPlaced(false)
	end
	self.IsMoving = false
end

-- On show set saved position
local function LoadPosition(self)
	if self.IsMoving == true then return end
	local Name = self:GetName()
	if not self:GetPoint() then -- Some frames don't have set positions when show script runs (e.g. CharacterFrame). For those set default position and save that.
		if B.SpecialDefaults[Name] then
			local a,b,c,d,e = T.unpack(B.SpecialDefaults[Name])
			self:SetPoint(a,b,c,d,e, true)
		elseif B.OriginalDefaults[Name] then
			local a,b,c,d,e = T.unpack(B.OriginalDefaults[Name])
			self:SetPoint(a,b,c,d,e, true)
		else
			self:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', 16, -116, true)
		end
		OnDragStop(self)
	end

	if E.private.KlixUI.module.blizzmove.remember and E.private.KlixUI.module.blizzmove.points[Name] then
		self:ClearAllPoints()
		local a,b,c,d,e = T.unpack(E.private.KlixUI.module.blizzmove.points[Name])
		self:SetPoint(a,b,c,d,e, true)
	end

	if B.ExlusiveFrames[Name] then for _, name in T.pairs(B.ExlusiveFrames[Name]) do _G[name]:Hide() end end -- If this frame has others that should not be shown at the same time, hide those
end

--Hooking this to movable frames' SetPoint.
--Blizz love to move some frames when stuff happens, so if SetPoint is not passing an additional arg we call SetPoint again with saved position.
function B:RewritePoint(anchor, parent, point, x, y, KUIcalled)
	if not KUIcalled then LoadPosition(self) end
end

function B:MakeMovable(Name)
	local frame = _G[Name]
	if not frame then --Frame in the list was removed since the last time I checked
		KUI:Print("Frame to move doesn't exist: "..(Name or "Unknown"), "error")
		return
	end

	if Name == "AchievementFrame" then _G.AchievementFrameHeader:EnableMouse(false) end --Cause achievement frame is a bitch

	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetClampedToScreen(true)
	frame:RegisterForDrag("LeftButton")

	frame:HookScript("OnShow", LoadPosition)
	frame:HookScript("OnDragStart", OnDragStart)
	frame:HookScript("OnDragStop", OnDragStop)
	frame:HookScript("OnHide", OnDragStop)
	hooksecurefunc(frame, "SetPoint", B.RewritePoint)
end

function B:Addons(event, addon)
	addon = B.AddonsList[addon]
	if not addon then return end
	if T.type(addon) == "table" then
		for i = 1, #addon do
			B:MakeMovable(addon[i])
		end
	else
		B:MakeMovable(addon)
	end
	B.addonCount = B.addonCount + 1
	--If every blizz addon is loaded we don't need to listen to these event
	if B.addonCount == #B.AddonsList then B:UnregisterEvent(event) end
end

local ToDelete = {
	["CalendarViewEventFrame"] = true,
	["CalendarViewHolidayFrame"] = true,
}


function B:ErrorFrameSize()
	_G["UIErrorsFrame"]:SetSize(B.db.errorframe.width, B.db.errorframe.height) --512 x 60
end

function B:RUReset()
	local a = E.db.KlixUI.misc.rumouseover and 0 or 1
	_G.RaidUtility_ShowButton:SetAlpha(a)
end

function B:Initialize()
	if T.IsAddOnLoaded("ElvUI_SLE") then return end
	
	B.db = E.db.KlixUI.blizzard
	
	B.addonCount = 0
	
	--DB conversion
	if E.private.KlixUI.module.blizzmove and type(E.private.KlixUI.module.blizzmove) == "boolean" then E.private.KlixUI.module.blizzmove = V.KlixUI.module.blizzmove end --Old setting conversions
	E.global.KlixUI.pvpreadydialogreset = nil
	if not E.private.KlixUI.pvpreadydialogreset then E.private.KlixUI.module.blizzmove.points["PVPReadyDialog"] = nil; E.private.KlixUI.pvpreadydialogreset = true end
	for Name, _ in T.pairs(ToDelete) do
		if E.private.KlixUI.module.blizzmove.points[Name] then E.private.KlixUI.module.blizzmove.points[Name] = nil end
	end

	if E.private.KlixUI.module.blizzmove.enable then
		for Name, _ in T.pairs(B.TempOnly) do --Remove these from saved variables so the script will not attempt to mess with them, cause they are not ment to be moved permanently
			if E.private.KlixUI.module.blizzmove.points[Name] then E.private.KlixUI.module.blizzmove.points[Name] = nil end
		end
		for i = 1, #B.Frames do
			B:MakeMovable(B.Frames[i])
		end

		self:RegisterEvent("ADDON_LOADED", "Addons")

		-- Check Forced Loaded AddOns
		for AddOn, Table in T.pairs(B.AddonsList) do
			if T.IsAddOnLoaded(AddOn) then
				for _, frame in T.pairs(Table) do
					B:MakeMovable(frame)
				end
			end
		end
	end

	--Removing stuff from auto positioning
	self:Hook('UIParent_ManageFramePosition', function()
		for i = 1, #B.Frames do
			local frame = _G[B.Frames[i]]
			if frame and frame:IsShown() then LoadPosition(frame) end
		end
	end, true)

	B:ErrorFrameSize()
	function B:ForUpdateAll()
		B.db = E.db.KlixUI.blizzard
		B:ErrorFrameSize()
	end
	
	--- Mover Creation ---
	_G.UIErrorsFrame:ClearAllPoints()
	_G.UIErrorsFrame:SetPoint("TOP", 0, -130)
	E:CreateMover(_G.UIErrorsFrame, "UIErrorsFrameMover", L["Error Frame"], nil, nil, nil, "ALL,GENERAL,KLIXUI")
	
	--Raid Utility
	if _G.RaidUtility_ShowButton then
		E:CreateMover(_G.RaidUtility_ShowButton, "RaidUtility_Mover", L["Raid Utility"], nil, nil, nil, "ALL,RAID,KLIXUI")
		local mover = _G.RaidUtility_Mover
		local frame = _G.RaidUtility_ShowButton
		if E.db.movers == nil then E.db.movers = {} end

		mover:HookScript("OnDragStart", function(self) 
			frame:ClearAllPoints()
			frame:SetPoint("CENTER", self)
		end)

		local function Enter(self)
			if not E.db.KlixUI.misc.rumouseover then return end
			self:SetAlpha(1)
		end

		local function Leave(self)
			if not E.db.KlixUI.misc.rumouseover then return end
			self:SetAlpha(0)
		end

		local function dropfix()
			local point, anchor, point2, x, y = mover:GetPoint()
			frame:ClearAllPoints()
			if T.string_find(point, "BOTTOM") then
				frame:SetPoint(point, anchor, point2, x, y)
			else
				frame:SetPoint(point, anchor, point2, x, y)
			end
		end

		mover:HookScript("OnDragStop", dropfix)

		if E.db.movers.RaidUtility_Mover == nil then
			frame:ClearAllPoints()
			frame:SetPoint("TOP", E.UIParent, "TOP", -400, E.Border)
		else
			dropfix()
		end
		frame:RegisterForDrag("")
		frame:HookScript("OnEnter", Enter)
		frame:HookScript("OnLeave", Leave)
		Leave(frame)
	end
end

KUI:RegisterModule(B:GetName())