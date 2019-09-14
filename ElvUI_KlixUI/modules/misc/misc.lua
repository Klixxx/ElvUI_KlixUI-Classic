local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local MI = KUI:NewModule("KuiMisc", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local S = E:GetModule("Skins")

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

    _G.GameTooltip:HookScript("OnTooltipSetItem", function(self)
        if not E.db.KlixUI.misc.buyall then return end
        if _G.MerchantFrame:IsShown() then
            for i = 2, _G.GameTooltip:NumLines() do
                local line = _G["GameTooltipTextLeft"..i]:GetText() or ""
                if line:find("<[sS]hift") then
                    _G.GameTooltip:AddLine(L["|cfff960d9<Alt-Click to buy a full stack>|r"])
                end
            end
        end
    end)
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

	self:LoadMisc()
	self:LoadnameHover()
	self:LoadMoverTransparancy()
	self:LoadGMOTD()
	self:MaxStack()
	
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
end

local function InitializeCallback()
	MI:Initialize()
end

KUI:RegisterModule(MI:GetName(), InitializeCallback)