local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local MI = KUI:NewModule("KuiMisc", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local S = E:GetModule("Skins")
local COMP = KUI:GetModule("KuiCompatibility")

function MI:LoadMisc()
	-- Force readycheck warning
	local ShowReadyCheckHook = function(_, initiator)
		if initiator ~= "player" then
			T.PlaySound(SOUNDKIT.READY_CHECK or 8960)
		end
	end
	hooksecurefunc("ShowReadyCheck", ShowReadyCheckHook)

	-- Force other warning
	local ForceWarning = T.CreateFrame("Frame")
	ForceWarning:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
	ForceWarning:RegisterEvent("PET_BATTLE_QUEUE_PROPOSE_MATCH")
	ForceWarning:RegisterEvent("LFG_PROPOSAL_SHOW")
	ForceWarning:SetScript("OnEvent", function(_, event)
		if event == "UPDATE_BATTLEFIELD_STATUS" then
			for i = 1, T.GetMaxBattlefieldID() do
				local status = T.GetBattlefieldStatus(i)
				if status == "confirm" then
					T.PlaySound(SOUNDKIT.UI_PET_BATTLES_PVP_THROUGH_QUEUE or 36609)
					break
				end
				i = i + 1
			end
		elseif event == "PET_BATTLE_QUEUE_PROPOSE_MATCH" then
			T.PlaySound(SOUNDKIT.UI_PET_BATTLES_PVP_THROUGH_QUEUE or 36609)
		elseif event == "LFG_PROPOSAL_SHOW" then
			T.PlaySound(SOUNDKIT.READY_CHECK or 8960)
		end
	end)

	-- Misclicks for some popups
	_G.StaticPopupDialogs.RESURRECT.hideOnEscape = nil
	_G.StaticPopupDialogs.AREA_SPIRIT_HEAL.hideOnEscape = nil
	_G.StaticPopupDialogs.PARTY_INVITE.hideOnEscape = nil
	_G.StaticPopupDialogs.CONFIRM_SUMMON.hideOnEscape = nil
	_G.StaticPopupDialogs.ADDON_ACTION_FORBIDDEN.button1 = nil
	_G.StaticPopupDialogs.TOO_MANY_LUA_ERRORS.button1 = nil
	_G.PetBattleQueueReadyFrame.hideOnEscape = nil
	if _G.PVPReadyDialog then
		_G.PVPReadyDialog.leaveButton:Hide()
		_G.PVPReadyDialog.enterButton:ClearAllPoints()
		_G.PVPReadyDialog.enterButton:SetPoint("BOTTOM", _G.PVPReadyDialog, "BOTTOM", 0, 25)
		_G.PVPReadyDialog.label:SetPoint("TOP", 0, -22)
	end

	-- Auto select current event boss from LFD tool(EventBossAutoSelect by Nathanyel)
	local firstLFD
	_G.LFDParentFrame:HookScript("OnShow", function()
		if not firstLFD then
			firstLFD = 1
			for i = 1, T.GetNumRandomDungeons() do
				local id = T.GetLFGRandomDungeonInfo(i)
				local isHoliday = T.select(15, T.GetLFGDungeonInfo(id))
				if isHoliday and not T.GetLFGDungeonRewards(id) then
					T.LFDQueueFrame_SetType(id)
				end
			end
		end
	end)

	-- Always show the Text on the PlayerPowerBarAlt
	_G.PlayerPowerBarAlt:HookScript("OnShow", function()
		local statusFrame = _G.PlayerPowerBarAlt.statusFrame
		if statusFrame.enabled then
			statusFrame:Show()
			T.UnitPowerBarAltStatus_UpdateText(statusFrame)
		end
	end)

	-- Try to fix JoinBattleField taint
	T.CreateFrame("Frame"):SetScript("OnUpdate", function(self, elapsed)
		if _G.LFRBrowseFrame.timeToClear then
			_G.LFRBrowseFrame.timeToClear = nil
		end
	end)

	-- Pet Journal Fix
	T.C_PetJournal_SetFilterChecked(LE_PET_JOURNAL_FILTER_COLLECTED, true)
	T.C_PetJournal_SetFilterChecked(LE_PET_JOURNAL_FILTER_NOT_COLLECTED, true)
	T.C_PetJournal_SetAllPetTypesChecked(true)
	T.C_PetJournal_SetAllPetSourcesChecked(true)
	
	-- WorldMapFrame Zoom Bug
	local WorldMapFrame = _G.WorldMapFrame
	local WorldMapFrame_OnHide = _G.WorldMapFrame_OnHide
	local WorldMapLevelButton_OnClick = _G.WorldMapLevelButton_OnClick

	local frame = T.CreateFrame("Frame", nil, UIParent)
	frame:RegisterEvent("PLAYER_REGEN_ENABLED") 
	frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	frame:SetScript("OnEvent", function(self)
		if event == "PLAYER_REGEN_DISABLED" then
			WorldMapFrame:UnregisterEvent("WORLD_MAP_UPDATE")
			WorldMapFrame:SetScript("OnHide", nil)
			WorldMapLevelButton:SetScript("OnClick", nil)
		elseif event == "PLAYER_REGEN_ENABLED" then
			WorldMapFrame:RegisterEvent("WORLD_MAP_UPDATE")
			WorldMapFrame:SetScript("OnHide", WorldMapFrame_OnHide)
			WorldMapLevelButton:SetScript("OnClick", WorldMapLevelButton_OnClick)
		end
	end)
	
	--[[
	-- Garbage collection is being overused and misused,
	-- and it's causing lag and performance drops.
	do
		local oldcollectgarbage = collectgarbage
		oldcollectgarbage("setpause", 110)
		oldcollectgarbage("setstepmul", 200)

		collectgarbage = function(opt, arg)
			if (opt == "collect") or (opt == nil) then
			elseif (opt == "count") then
				return oldcollectgarbage(opt, arg)
			elseif (opt == "setpause") then
				return oldcollectgarbage("setpause", 110)
			elseif opt == "setstepmul" then
				return oldcollectgarbage("setstepmul", 200)
			elseif (opt == "stop") then
			elseif (opt == "restart") then
			elseif (opt == "step") then
				if (arg ~= nil) then
					if (arg <= 10000) then
						return oldcollectgarbage(opt, arg)
					end
				else
					return oldcollectgarbage(opt, arg)
				end
			else
				return oldcollectgarbage(opt, arg)
			end
		end

		-- Memory usage is unrelated to performance, and tracking memory usage does not track "bad" addons.
		-- Developers can uncomment this line to enable the functionality when looking for memory leaks,
		-- but for the average end-user this is a completely pointless thing to track.
		UpdateAddOnMemoryUsage = KUI.dummy
	end
	]]
end

function MI:RUReset()
	local a = E.db.KlixUI.misc.rumouseover and 0 or 1
	_G.RaidUtility_ShowButton:SetAlpha(a)
end

function MI:SetRole()
	local spec = T.GetSpecialization()
	if T.UnitLevel("player") >= 10 and not T.InCombatLockdown() then
		if spec == nil and T.UnitGroupRolesAssigned("player") ~= "NONE" then
			T.UnitSetRole("player", "NONE")
		elseif spec ~= nil then
			if T.GetNumGroupMembers() > 0 then
				if T.UnitGroupRolesAssigned("player") ~= E:GetPlayerRole() then
					T.UnitSetRole("player", E:GetPlayerRole())
				end
			end
		end
	end
end

function MI:MaxStack()
    hooksecurefunc("MerchantItemButton_OnModifiedClick", function(self, ...)
        if not E.db.KlixUI.misc.buyall then return end
        if T.IsAltKeyDown() then
            local maxStack = T.select(8, T.GetItemInfo(T.GetMerchantItemLink(self:GetID())))

            local numAvailable = T.select(5, T.GetMerchantItemInfo(self:GetID()))

            -- -1 means an item has unlimited supply.
            if numAvailable ~= -1 then
                T.BuyMerchantItem(self:GetID(), numAvailable)
            else
                T.BuyMerchantItem(self:GetID(), T.GetMerchantItemMaxStack(self:GetID()))
            end
        end
    end)

    -- Add a hint to the tooltip.
    local function IsMerchantButtonOver()
        return T.GetMouseFocus():GetName() and T.GetMouseFocus():GetName():find("MerchantItem%d")
    end

    _G.GameTooltip:HookScript("OnTooltipSetItem", function(self)
        if not E.db.KlixUI.misc.buyall then return end
        if _G.MerchantFrame:IsShown() and IsMerchantButtonOver() then
            for i = 2, _G.GameTooltip:NumLines() do
                local line = _G["GameTooltipTextLeft"..i]:GetText() or ""
                if line:find("<[sS]hift") then
                    _G.GameTooltip:AddLine(L["|cfff960d9<Alt-Click to buy a full stack>|r"])
                end
            end
        end
    end)
end

-- Auto insert keystones when in a mythic+ dungeon.
function MI:insertKeystone()
	for bag = 0, NUM_BAG_SLOTS do
		for slot = 1, T.GetContainerNumSlots(bag) do
			local name = T.GetContainerItemLink(bag,slot)
			if (name and T.string_find(name, "Keystone:")) then
				T.UseContainerItem(bag,slot)
				KUI:Print("Inserting keystone: " .. name .. ".")
			end
		end
	end
end

-- Auto insert keystones
function MI:CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN()
	if E.db.KlixUI.misc.auto.keystones then
		T.C_Timer_After(0.5, function()
			MI:insertKeystone()
		end)
	end
end

-- Auto close the popup window you get after joining a raid group that shows your role (custom group finder etc).
function MI:LFG_LIST_JOINED_GROUP()
	-- If group leader or not in group the popup looks different (same frame name though).
	if (T.UnitIsGroupLeader("player") or not T.IsInGroup()) then
		return
	end
	if E.db.KlixUI.misc.auto.rolecheck.confirm then
		local roleText = _G.LFGListInviteDialog.Role:GetText()
		if (roleText and roleText ~= "") then
			KUI:Print("Joined group as role:|cffFFFF00 " .. roleText)
		end
		_G.LFGListInviteDialog:Hide()
	end
end

-- Auto accept role check
local roleCheckMsg = true
function MI:LFG_ROLE_CHECK_SHOW()
	local queueText = _G.LFDRoleCheckPopupDescriptionText:GetText()
	local doQueue = false
	if E.db.KlixUI.misc.auto.rolecheck.enable then --Global setting
		doQueue = true
	elseif (T.string_find(queueText, "The Crown Chemical Co") and E.db.KlixUI.misc.auto.rolecheck.love) then -- Love is in the air
		doQueue = true
	elseif (T.string_find(queueText, "The Headless Horseman") and E.db.KlixUI.misc.auto.rolecheck.halloween) then -- Halloween
		doQueue = true	-- (untested, hopefully this is the dungeon name)
	elseif (T.string_find(queueText, "Timewalking") and E.db.KlixUI.misc.auto.rolecheck.timewalking) then -- Timewalking
		doQueue = true	-- (untested, hopefully timewalking is in the queue name)
	end
	leader, tank, healer, damage = GetLFGRoles()
	if (tank == true) then
		tankMsg = "Tank "
	else
		tankMsg = ""
	end
	if (healer == true) then
		healerMsg = "Healer "
	else
		healerMsg = ""
	end
	if (damage == true) then
		damageMsg = "Damage"
	else
		damageMsg = ""
	end
	if (doQueue and roleCheckMsg == true) then
		T.CompleteLFGRoleCheck(true)
		KUI:Print("Auto completed role check as:|cffFFFF00 " .. tankMsg .. healerMsg .. damageMsg)
		-- Turn off the msg for a few seconds, LFG_ROLE_CHECK_SHOW seems to trigger when anyone in group signs up so it spams.
		-- There's probably a better event to make it only trigger on myself somehow, will work it out later.
		roleCheckMsg = false
		T.C_Timer_After(5, function()
			resetRoleCheckMsg()
		end)
	end
end

function resetRoleCheckMsg()
	roleCheckMsg = true
end

function MI:FlightMasterWhistle()
	if not E.db.KlixUI.misc.whistleSound then return end

	-- Plays a soundbite from DJ Alligator - Blow my Whistle B*** after Flight Master's Whistle is used.
	local flightMastersWhistle_SpellID1 = 227334
	local flightMastersWhistle_SpellID2 = 253937
	
	local casting = false
	
	local f = T.CreateFrame("frame")
	f:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

	function f:UNIT_SPELLCAST_SUCCEEDED(unit, lineID, spellID)
		if (unit == "player" and (spellID == flightMastersWhistle_SpellID1 or spellID == flightMastersWhistle_SpellID2)) then
			if casting then
				casting = false
				return
			end
			
			if E.db.KlixUI.misc.toggleSoundCustom and E.db.KlixUI.misc.whistleSoundCustom then
				T.PlaySoundFile(E.db.KlixUI.misc.whistleSoundCustom, "Master")
			else
				T.PlaySoundFile("Interface\\AddOns\\ElvUI_KlixUI\\media\\sounds\\blowmywhistle.mp3", "Master")
			end
		end
	end
	function f:UNIT_SPELLCAST_START(event, castGUID, spellID)
		if spellID == flightMastersWhistle_SpellID1 then
			casting = true
		end
	end
	f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	f:RegisterEvent("UNIT_SPELLCAST_START")
end

function MI:LootOpen()
	if not E.db.KlixUI.misc.lootSound then return end
	
	local Owensounds = {}
	Owensounds[#Owensounds+1] = 'Interface\\AddOns\\ElvUI_KlixUI\\media\\sounds\\Owen\\wow1.mp3'
	Owensounds[#Owensounds+1] = 'Interface\\AddOns\\ElvUI_KlixUI\\media\\sounds\\Owen\\wow2.mp3'
	Owensounds[#Owensounds+1] = 'Interface\\AddOns\\ElvUI_KlixUI\\media\\sounds\\Owen\\Kachow.mp3'
	
	local soundLength = #Owensounds
	local lootFrame = T.CreateFrame("Frame")
	lootFrame:SetScript("OnEvent", function(self, event, ...) end)
	
	function lootFrame:LOOT_OPENED()
	local g = T.math_random(soundLength)
		T.PlaySoundFile(Owensounds[g], "Master")
	end
	lootFrame:RegisterEvent("LOOT_OPENED")
end

function MI:SHIPMENT_CRAFTER_OPENED()
	local startOrders = false
	local npcName = T.UnitName("target")
	local zoneName = T.GetZoneText()
	local subZoneName = T.GetSubZoneText()
	if E.db.KlixUI.misc.auto.workorder.orderhall then
		if COMP.SLE and (E.db.sle.legacy.warwampaign.autoOrder.enable or E.db.sle.legacy.orderhall.autoOrder.enable) then return end
		if zoneName == "Dreadscar Rift" then -- Warlock
			startOrders = true
		elseif zoneName == "Acherus: The Ebon Hold" then -- Death Knight
			startOrders = true
		elseif zoneName == "Hall of the Guardian" then -- Mage
			startOrders = true
		elseif zoneName == "Skyhold" then -- Warrior
			startOrders = true
		elseif zoneName == "Trueshot Lodge" then -- Hunter
			startOrders = true
		elseif zoneName == "Mardum, the Shattered Abyss" then -- Demon Hunter
			startOrders = true
		elseif subZoneName == "The Hall of Shadows" or subZoneName == "Den of Thieves" then -- Rogue
			startOrders = true
		elseif zoneName == "Netherlight Temple" then -- Priest
			startOrders = true
		elseif zoneName == "The Maelstrom" then -- Shaman
			startOrders = true
		elseif zoneName == "The Wandering Isle" then -- Monk
			startOrders = true
		elseif zoneName == "Light's Hope Chapel" then -- Paladin
			startOrders = true
		elseif zoneName == "The Dreamgrove" then -- Druid
			startOrders = true
		elseif zoneName == "Wind's Redemption" then -- Boralus alliance ship.
			startOrders = true
		elseif zoneName == "The Banshee's Wail" then -- Horde ship.
			startOrders = true
		end
	end
	if E.db.KlixUI.misc.auto.workorder.nomi and npcName == "Nomi" then
		startOrders = true
	end
	if startOrders then
		-- We need a 1 second delay before doing anything, the game client doesn't get the frame info instantly on load.
		-- On rare occasions it still doesn't get the info even with a 1 second delay.
		T.C_Timer_After(1, function()
			MI:StartAllWorkOrders()
		end)
	end
end

function MI:StartAllWorkOrders()
	if T.IsModifierKeyDown() then return end
	local buttonState = _G.GarrisonCapacitiveDisplayFrame.CreateAllWorkOrdersButton:GetButtonState()
	if buttonState == "NORMAL" then
		local workOrderType = _G.GarrisonCapacitiveDisplayFrame.CapacitiveDisplay.ShipmentIconFrame.ShipmentName:GetText()
		local workOrdersAvailable = _G.GarrisonCapacitiveDisplayFrame.CapacitiveDisplay.ShipmentIconFrame.ShipmentsAvailable:GetText()
		if workOrderType ~= nil and workOrderType ~= '' and workOrdersAvailable ~= nil and workOrdersAvailable ~= '' then
			local workOrderCount = {}
			workOrderCount[1], workOrderCount[2] = workOrdersAvailable:match("(%w+)(.+)")
			_G.GarrisonCapacitiveDisplayFrame.CreateAllWorkOrdersButton:Click()
			KUI:Print("Started|cffFFFF00 " .. workOrderCount[1] .. " |cffffffffwork orders for|cffFFFF00 " .. 
					workOrderType .. "|cffffffff.")
		else
			_G.GarrisonCapacitiveDisplayFrame.CreateAllWorkOrdersButton:Click()
			KUI:Print("Starting all work orders.")
		end
	end
end

function MI:PARTY_LEADER_CHANGED()
	if T.UnitIsGroupLeader("Player") and E.db.KlixUI.misc.leaderSound then
		T.PlaySoundFile("Interface\\AddOns\\ElvUI_KlixUI\\media\\sounds\\leader.ogg", "Master")
	end
end

function MI:HivemindMountSeatIndicator()
	if not E.db.KlixUI.misc.vehicleSeat.missing then return end
	
	hooksecurefunc("VehicleSeatIndicator_SetUpVehicle", function (vehicleIndicatorID)
		if (vehicleIndicatorID == 0) then
			vehicleIndicatorID = ({224, 226, 222, 223})[(T.IsMounted() or T.GetShapeshiftForm() ~= 0) and T.UnitVehicleSeatCount("player") or T.UnitIsPlayer("vehicle") and T.UnitVehicleSeatCount("vehicle")]
			if (vehicleIndicatorID) then
				T.VehicleSeatIndicator_SetUpVehicle(vehicleIndicatorID)
			end
		end
	end)
end

function MI:TakeScreen()
	if not E.db.KlixUI.misc.auto.screenshot.enable then return end
	
	E:ScheduleTimer(T.Screenshot, 1)
end

local MAX_BUYOUT_PRICE = 10000000
function MI:ADDON_LOADED(event, addon)
	--Shift + rightclick auto buy auctions
    if addon == "Blizzard_AuctionUI" and E.db.KlixUI.misc.auto.auction then
		for i = 1, 20 do
			local f = _G["BrowseButton"..i]
			if f then
				f:RegisterForClicks("LeftButtonUp", "RightButtonUp")
				f:HookScript("OnClick", function(self, button)
						if button == "RightButton" and T.IsShiftKeyDown() then
							local index = self:GetID() + T.FauxScrollFrame_GetOffset(_G.BrowseScrollFrame)
							local name, _, _, _, _, _, _, _, _, buyoutPrice = T.GetAuctionItemInfo("list", index)
							if name then
								if buyoutPrice < MAX_BUYOUT_PRICE then
									T.PlaceAuctionBid("list", index, buyoutPrice)
								end
							end
						end
					end)
			end
		end
		for i = 1, 20 do
			local f = _G["AuctionsButton"..i]
			if f then
				f:RegisterForClicks("LeftButtonUp", "RightButtonUp")
				f:HookScript("OnClick", function(self, button)
					local index = self:GetID() + T.FauxScrollFrame_GetOffset(_G.AuctionsScrollFrame)
					if button == "RightButton" and T.IsShiftKeyDown() then
						local name = T.GetAuctionItemInfo("owner", index)
						if name then
							T.CancelAuction(index)
						end
					end
				end)
			end
		end
		
		self:UnregisterEvent("ADDON_LOADED")
	end
	
	-- Show BID and highlight price
	if addon == 'Blizzard_AuctionUI' then
		hooksecurefunc('AuctionFrameBrowse_Update', function()
			local numBatchAuctions = T.GetNumAuctionItems('list')
			local offset = T.FauxScrollFrame_GetOffset(_G.BrowseScrollFrame)
			local name, buyoutPrice, bidAmount, hasAllInfo
			for i = 1, NUM_BROWSE_TO_DISPLAY do
				local index = offset + i + (NUM_AUCTION_ITEMS_PER_PAGE * _G.AuctionFrameBrowse.page)
				local shouldHide = index > (numBatchAuctions + (NUM_AUCTION_ITEMS_PER_PAGE * _G.AuctionFrameBrowse.page))
				if not shouldHide then
					name, _, _, _, _, _, _, _, _, buyoutPrice, bidAmount, _, _, _, _, _, _, hasAllInfo = T.GetAuctionItemInfo('list', offset + i)
					if not hasAllInfo then shouldHide = true end
				end
				if not shouldHide then
					local alpha = .5
					local color = 'yellow'
					local buttonName = 'BrowseButton'..i
					local itemName = _G[buttonName..'Name']
					local moneyFrame = _G[buttonName..'MoneyFrame']
					local buyoutMoney = _G[buttonName..'BuyoutFrameMoney']
					if buyoutPrice >= 5*1e7 then color = 'red' end
					if bidAmount > 0 then
						name = name..' |cffffff00'..BID..'|r'
						alpha = 1.0
					end
					itemName:SetText(name)
					moneyFrame:SetAlpha(alpha)
					T.SetMoneyFrameColor(buyoutMoney:GetName(), color)
				end
			end
		end)
		
		self:UnregisterEvent("ADDON_LOADED")
	end
	
	-- TrainAll
	if addon == "Blizzard_TrainerUI" then
		local button = T.CreateFrame("Button", "ClassTrainerTrainAllButton", _G.ClassTrainerFrame, "UIPanelButtonTemplate")
		button:SetText(ACHIEVEMENTFRAME_FILTER_ALL)
		S:HandleButton(button)
		button:SetPoint("TOPRIGHT", _G.ClassTrainerTrainButton, "TOPLEFT", -3, 0)
		button:SetWidth(T.math_min(50, button:GetTextWidth() + 15))
		button:SetScript("OnClick", function()
			for i = 1, T.GetNumTrainerServices() do
				if T.select(2, T.GetTrainerServiceInfo(i)) == "available" then
					T.BuyTrainerService(i)
				end
			end
		end)
		
		hooksecurefunc("ClassTrainerFrame_Update", function()
			for i = 1, T.GetNumTrainerServices() do
				if 
				_G.ClassTrainerTrainButton:IsEnabled() and select(2, T.GetTrainerServiceInfo(i)) == "available" then
					button:Enable()
					return
				end
			end
			
			button:Disable()
		end)
		
		self:UnregisterEvent("ADDON_LOADED")
	end
end

function MI:Initialize()
	E.RegisterCallback(MI, "RoleChanged", "SetRole")
	self:RegisterEvent("GROUP_ROSTER_UPDATE", "SetRole")
	_G.RolePollPopup:SetScript("OnShow", function() T.StaticPopupSpecial_Hide(_G.RolePollPopup) end)

	self:LoadMisc()
	self:LoadMoverTransparancy()
	self:LoadGMOTD()
	self:MaxStack()
	self:FlightMasterWhistle()
	self:LootOpen()
	self:HivemindMountSeatIndicator()
	self:LoadnameHover()
	self:LoadInviteGroup()
	
	MI:RegisterEvent("CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN")
	MI:RegisterEvent("LFG_LIST_JOINED_GROUP")
	MI:RegisterEvent("LFG_ROLE_CHECK_SHOW")
	MI:RegisterEvent("SHIPMENT_CRAFTER_OPENED")
	MI:RegisterEvent("PARTY_LEADER_CHANGED")
	MI:RegisterEvent("ACHIEVEMENT_EARNED", "TakeScreen")
	MI:RegisterEvent("SHOW_LOOT_TOAST_LEGENDARY_LOOTED", "TakeScreen")
	MI:RegisterEvent("ADDON_LOADED")
	
	-- Auto gossip when visiting BfA mission ship and rogue order hall doors in legion.
	if E.db.KlixUI.misc.auto.gossip then
		_G.GossipFrame:HookScript("OnShow",function()
		local targetid = T.tonumber(T.string_match(T.tostring(T.UnitGUID("target")), "-([^-]+)-[^-]+$"))

		-- Stop if modifier key is held down
			if
			(
				T.IsModifierKeyDown()
			)
			then 
				return
			end 

		-- Stop if NPC has quests or quest turn-ins
			if
			(
				T.GetNumGossipActiveQuests() > 0						
				or T.GetNumGossipAvailableQuests() > 0						
			)
			then 
				return
			end 

		-- Auto select option if only 1 is available	
			if
				(
					T.GetNumGossipOptions() == 1						
				)
			then 
				T.SelectGossipOption(1)
				KUI:Print("Gossip option automatically chosen")
				KUI:Print("Hold any modifier key whilst clicking NPC to choose manually")
			end

		-- Auto select option 1 if more than one option is available for the listed NPCs	
			if
			(
				T.GetNumGossipOptions() > 1							
			)
			then
				if
				(
					targetid == 39188		-- Mongar (Legion Dalaran)
					or targetid == 96782		-- Lucian Trias (Legion Dalaran)
					or targetid == 97004		-- "Red" Jack Findle (Legion Dalaran)
					or targetid == 138708		-- Garona Halforcen (BFA)
					or targetid == 135614		-- Master Mathias Shaw (BFA)
					or targetid == 131287		-- Natal'hakata (Horde Zandalari Emissary)
					or targetid == 138097		-- Muka Stormbreaker (Stormsong Valley Horde flight master)
					or targetid == 35642		-- Jeeves
				)
				then
					T.SelectGossipOption(1)
					KUI:Print("Gossip option automatically chosen")
					KUI:Print("Hold any modifier key whilst clicking NPC to choose manually")
				end
			end
		end)
	end
	
	--- Mover Creation ---
	if not T.IsAddOnLoaded('ElvUI_SLE') then
		_G.UIErrorsFrame:ClearAllPoints()
		_G.UIErrorsFrame:SetPoint("TOP", 0, -130)
		E:CreateMover(_G.UIErrorsFrame, "UIErrorsFrameMover", L["Error Frame"], nil, nil, nil, "ALL,GENERAL,KLIXUI")

		--GhostFrame Mover.
		T.ShowUIPanel(_G.GhostFrame)
		_G.GhostFrame:ClearAllPoints()
		_G.GhostFrame:SetPoint("TOP", 0, -165)
		E:CreateMover(_G.GhostFrame, "GhostFrameMover", L["Ghost Frame"], nil, nil, nil, "ALL,GENERAL,KLIXUI")
		T.HideUIPanel(_G.GhostFrame)

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
end

local function InitializeCallback()
	MI:Initialize()
end

KUI:RegisterModule(MI:GetName(), InitializeCallback)