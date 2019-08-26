local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local IS = KUI:NewModule('ItemSelect', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
local B = E:GetModule('Bags')
local LCG = LibStub("LibCustomGlow-1.0")

---------------------------------------------------------------------------------------------------
--- ItemSelector specific values:
---------------------------------------------------------------------------------------------------

local VendorColor 			= { 0.95, 0.95, 0.32, 1.0 };
local HoveredSlotColor		= { 0.7, 0.7, 0.7, 1.0 };
local SelectedSlotColor		= { 1.0, 0.0, 0.0, 1.0 };
local SelectionActiveColor	= { 1.0, 1.0, 0.0, 1.0 };

---------------------------------------------------------------------------------------------------
--- WoW API specific values:
---------------------------------------------------------------------------------------------------

local BindTypeBoE			= 2;

local ItemRaritycommon		= 1;
local ItemRarityUncommon	= 2;
local ItemRarityRare		= 3;
local ItemRarityEpic		= 4;
local ItemRarityLegendary	= 5;
local ItemRarityArtifact	= 6;

---------------------------------------------------------------------------------------------------
--- Helper functions:
---------------------------------------------------------------------------------------------------

local GetSelectionString = function()
	return IS.SelectionActive and L["|cff00FF00Enabled|r"] or L["|cffFF0000Disabled|r"];
end

---------------------------------------------------------------------------------------------------

local UpdateTooltip = function()
	_G["ElvUI_ContainerFrame"].vendorGraysButton.ttText2 = T.string_format(L["|cffffffffClick to vendor grays. Shift-Click to activate item\nselection for vendoring. Currently:|r %s"], GetSelectionString());
end

---------------------------------------------------------------------------------------------------

local ConvertThreshold = function(ThresholdSetting)
	-- Separately convert the indices to WoW API's item rarity, could've
	-- been achieved by setting the rarity level as the index but that's
	-- hacky and workaround-ish.
	if(ThresholdSetting == 0) then return ItemRarityUncommon;
	elseif(ThresholdSetting == 1) then return ItemRarityRare;
	elseif(ThresholdSetting == 2) then return ItemRarityEpic;
	elseif(ThresholdSetting == 3) then return ItemRarityLegendary;
	end
end

---------------------------------------------------------------------------------------------------

local IsBindOnEquip = function(BindType)
	return (BindType and BindType == BindTypeBoE);
end

---------------------------------------------------------------------------------------------------

local IsQuestItem = function(Type)
	return (Type and Type == "Quest");
end

---------------------------------------------------------------------------------------------------

local HasAppearance = function(Type, EquipLoc)
	-- Ignore further queries for non-armor items.
	if(Type ~= "Armor") then
		return false;
	end

	-- Ignore equippable items that don't have visual appearance.
	if(EquipLoc) then
		if(EquipLoc == _G["INVTYPE_AMMO"] or
		   EquipLoc == _G["INVTYPE_NECK"] or
		   EquipLoc == _G["INVTYPE_FINGER"] or
		   EquipLoc == _G["INVTYPE_TRINKET"] or
		   EquipLoc == _G["INVTYPE_RELIC"] or
		   EquipLoc == _G["INVTYPE_BAG"] or
		   EquipLoc == _G["INVTYPE_QUIVER"]) then
			return false;
		end
	end

	-- Uncovered slots, basic armor, cloak etc. have visual appearance.
	return true;
end

---------------------------------------------------------------------------------------------------
--- Hooked functions:
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------

function IS:OnHide()
	T.ActionButton_HideOverlayGlow(_G["ElvUI_ContainerFrame"].vendorGraysButton);
	IS.SelectionHover:OnLeave();
	IS.ProcessFrame:Hide();
	IS:Reset();
end

---------------------------------------------------------------------------------------------------

function IS:OnShow()
	UpdateTooltip();
end

---------------------------------------------------------------------------------------------------

function IS:ProcessItemCheck()
	-- If Shift was held toggle the selection to either state,
	-- however allow disabling even when shift is not being held.
	if(T.IsShiftKeyDown() or IS.SelectionActive) then
		IS:ToggleSelect();
	else
		B:VendorGrayCheck();
	end
end

---------------------------------------------------------------------------------------------------
--- Main functions:
---------------------------------------------------------------------------------------------------

function IS:CreateProgressFrame()
	-- Frame:
	IS.ProcessFrame = T.CreateFrame("Frame", "KuiProgressFrame", E.UIParent);
	IS.ProcessFrame:Size(200,40);
	IS.ProcessFrame:Point("CENTER", E.UIParent);
	IS.ProcessFrame:CreateBackdrop("Transparent");
	IS.ProcessFrame.Title = IS.ProcessFrame:CreateFontString(nil, "OVERLAY");
	IS.ProcessFrame.Title:FontTemplate(nil, 12, "OUTLINE");
	IS.ProcessFrame.Title:Point('TOP', IS.ProcessFrame, 'TOP', 0, -2);
	IS.ProcessFrame.Title:SetText(L["Processing selected items:"]);
	IS.ProcessFrame:SetAlpha(IS.db.displayProgressFrame and 1 or 0);

	-- Status bar:
	IS.ProcessFrame.StatusBar = T.CreateFrame("StatusBar", "KuiProgressFrameStatusBar", IS.ProcessFrame);
	IS.ProcessFrame.StatusBar:Size(180, 16);
	IS.ProcessFrame.StatusBar:Point("BOTTOM", IS.ProcessFrame, "BOTTOM", 0, 4);
	IS.ProcessFrame.StatusBar:SetStatusBarTexture(E.media.normTex);
	IS.ProcessFrame.StatusBar:SetStatusBarColor(1, 0, 0);
	IS.ProcessFrame.StatusBar:CreateBackdrop("Transparent");

	-- Animation:
	IS.ProcessFrame.StatusBar.Animation = CreateAnimationGroup(IS.ProcessFrame.StatusBar);
	IS.ProcessFrame.StatusBar.Animation.Progress = IS.ProcessFrame.StatusBar.Animation:CreateAnimation("Progress");
	IS.ProcessFrame.StatusBar.Animation.Progress:SetSmoothing("Out");
	IS.ProcessFrame.StatusBar.Animation.Progress:SetDuration(0.3);

	-- Value text:
	IS.ProcessFrame.StatusBar.ValueText = IS.ProcessFrame.StatusBar:CreateFontString(nil, "OVERLAY");
	IS.ProcessFrame.StatusBar.ValueText:FontTemplate(nil, 12, "OUTLINE");
	IS.ProcessFrame.StatusBar.ValueText:Point("CENTER", IS.ProcessFrame.StatusBar);

	-- Our own variables, these will get set every time items are
	-- processed. The interval is queried
	IS.ProcessFrame.Info = {
		Delete = false,
		ProgressTimer = 0,
		SellInterval = IS.db.processInterval,
		ItemsTotal = 0,
		ItemsProcessed = 0,
		SelectedValue = 0,
		SelectedItems = {},
	};

	IS.ProcessFrame:SetScript("OnUpdate", IS.ProcessFrameUpdate);
	IS.ProcessFrame:Hide();
end

---------------------------------------------------------------------------------------------------

function IS:CreateSelectionOverlay()
	-- Create the frame that'll be responsible for responding to the user's clicks.
	IS.SelectionHover = T.CreateFrame("Button", nil, E.UIParent, "SecureActionButtonTemplate", "AutoCastShineTemplate");
	IS.SelectionHover:RegisterForClicks("AnyUp");
	IS.SelectionHover:SetFrameStrata("TOOLTIP");
	IS.SelectionHover.TipLines = {};

	---
	--- Set / Hook scripts:
	---

	-- OnClick, select start and end slots which will then be handled
	-- accordingly. If the MerchantFrame is open they will be added to it,
	-- otherwise they will get deleted.
	IS.SelectionHover:HookScript("OnClick", function(Frame)
		-- Retrieve the actual frame from ElvUI to add the pixel glow effect to it.
		if(T.next(IS.SelectedStartSlot) == nil) then
			IS.SelectedStartSlot.Frame = _G["ElvUI_ContainerFrame"].Bags[IS.SelectionHover.Bag][IS.SelectionHover.Slot];
			IS.SelectedStartSlot.Bag = IS.SelectionHover.Bag;
			IS.SelectedStartSlot.Slot = IS.SelectionHover.Slot;
			LCG.PixelGlow_Stop(IS.SelectionHover);
			LCG.PixelGlow_Start(IS.SelectedStartSlot.Frame, SelectedSlotColor, nil, -0.25, nil, 1);
		elseif(T.next(IS.SelectedEndSlot) == nil) then
			IS.SelectedEndSlot.Frame = _G["ElvUI_ContainerFrame"].Bags[IS.SelectionHover.Bag][IS.SelectionHover.Slot];
			IS.SelectedEndSlot.Bag = IS.SelectionHover.Bag;
			IS.SelectedEndSlot.Slot = IS.SelectionHover.Slot;
			LCG.PixelGlow_Start(IS.SelectedEndSlot.Frame, SelectedSlotColor, nil, -0.25, nil, 1);

			-- Get the selected slots and their vendor value here
			-- to avoid double queries and having to pass the data
			-- through the static popup dialog.
			local DeleteItems;
			IS.SelectedValue, IS.Selected, DeleteItems = IS:GetSelectedItemsInfo();

			-- Process the slots accordingly, if at merchant pass the items
			-- to it. Otherwise check if items without the merchant-only
			-- flag were added to be processed.
			if(not MerchantFrame or not MerchantFrame:IsShown()) then
				if(DeleteItems) then
					E.PopupDialogs["DELETE_SELECTED"].Money = IS.SelectedValue;
					E:StaticPopup_Show("DELETE_SELECTED");
				else
					KUI:Print(L["No deletable items were found, please check your configuration."]);
					IS:Reset();
				end
			else
				IS:ProcessSelected(false);
			end
		end
	end);

	-- OnLeave:
	IS.SelectionHover.OnLeave = function(self)
		if(T.InCombatLockdown()) then
			self:SetAlpha(0);
			self:RegisterEvent("PLAYER_REGEN_ENABLED");
		else
			self:ClearAllPoints();
			self:SetAlpha(1);
			if(_G["GameTooltip"]) then
				_G["GameTooltip"]:Hide();
			end
			self:Hide();
		end
	end

	-- SetTip:
	IS.SelectionHover.SetTip = function(self)
		_G["GameTooltip"]:SetOwner(self, "ANCHOR_LEFT", 0, 4);
		_G["GameTooltip"]:ClearLines();
		_G["GameTooltip"]:SetBagItem(self.Bag, self.Slot);

		-- If neither start nor end slot have been selected create the hover effect.
		if(T.next(IS.SelectedStartSlot) == nil and next(IS.SelectedEndSlot) == nil) then
			LCG.PixelGlow_Start(self, HoveredSlotColor, nil, -0.25, nil, 1);
		-- If start slot has been selected apply the hover effect only for the other slots.
		elseif(T.next(IS.SelectedStartSlot) and (IS.SelectedStartSlot.Bag ~= self.Bag or IS.SelectedStartSlot.Slot ~= self.Slot)) then
			LCG.PixelGlow_Start(self, HoveredSlotColor, nil, -0.25, nil, 1);
		else
			LCG.PixelGlow_Stop(self);
		end
	end

	-- OnEnter & OnLeave.
	IS.SelectionHover:SetScript("OnEnter", IS.SelectionHover.SetTip);
	IS.SelectionHover:SetScript("OnLeave", function() IS.SelectionHover:OnLeave(); end);

	function IS.SelectionHover:PLAYER_REGEN_ENABLED()
		self:UnregisterEvent("PLAYER_REGEN_ENABLED");
		IS.SelectionHover:OnLeave();
	end

	-- Hide the frame, it will only be displayed once we have ongoing selection.
	IS.SelectionHover:Hide();
end

---------------------------------------------------------------------------------------------------

function IS:GetSelectedItemsInfo()
	-- Return values.
	local TotalValue = 0;
	local Selected = {};
	local DeleteItems = false;

	for Bag = IS.SelectedStartSlot.Bag, IS.SelectedEndSlot.Bag do
		-- For first and last bags use the selected slots, bag size for the rest.
		local StartSlot = (Bag == IS.SelectedStartSlot.Bag) and IS.SelectedStartSlot.Slot or 1;
		local EndSlot = (Bag == IS.SelectedEndSlot.Bag) and IS.SelectedEndSlot.Slot or T.GetContainerNumSlots(Bag);
		-- If all chosen slots were from the same bag and the selection was done
		-- in reverse, end slot being chosen first, swap the slots here.
		if(StartSlot > EndSlot) then StartSlot, EndSlot = EndSlot, StartSlot; end

		-- Go through the slots between and including selected ones and add them to
		-- a the list of selected slots as well as store their vendor price.
		for Slot = StartSlot, EndSlot do
			local Link, Rarity, Type, EquipLoc, Price, BindType, IsCraftingReagent, ItemID, StackSize, _;

			-- Note:
			-- Use GetContainerItemInfo( ... ) instead of GetContainerItemID to obtain both
			-- link and item id with a single call as items share item id between difficulties
			-- yet the link is unique and needed for appearance queries.
			_, _, _, _, _, _, Link, _, _, ItemID = T.GetContainerItemInfo(Bag, Slot);
			if(ItemID) then
				-- Setting independent shared variables.
				local AddEntry = false;
				local MerchantOnly = false;

				-- Query the item information and store the items which match with the user-defined settings.
				_, _, Rarity, _, _, Type, _, _, EquipLoc, _, Price, _, _, BindType, _, _, IsCraftingReagent = T.GetItemInfo(ItemID)
				-- Quest items:
				if(IsQuestItem(Type)) then
					if(IS.db.processQuestItems ~= 0) then
						-- Setup the merchant-only flag.
						MerchantOnly = IS.db.processQuestItems == 1 and true or false;
						AddEntry = true;
					end
				-- BoE items:
				elseif(IsBindOnEquip(BindType)) then
					if(IS.db.processBoEItems ~= 0) then
						-- Compare the item's rarity to the BoE vendor quality threshold, if the threshold
						-- allows the vendoring/deletion of items of this rarity proceed with the item.
						if(ConvertThreshold(IS.db.thresholdBoE) >= Rarity) then
							-- Setup the merchant-only only flag and ensure that the threshold is respected.
							MerchantOnly = IS.db.processBoEItems == 1 and true or false;

							-- Check if we should not process BoE items that have unlockable appearance.
							if(not IS.db.processMissingMogBoE) then
								-- Check if we have collected the appearance of this item.
								if(IS:IsAppearanceCollected(ItemID, Link, Type, EquipLoc)) then
									AddEntry = true;
								else
									KUI:Print(T.string_format(L["Skipping %s due to missing appearance."], Link));
								end
							-- If BoE items with unlockable appearances have been enabled
							-- for processing add the entry without further checks.
							else
								AddEntry = true;
							end
						end
					end
				-- Crafting reagents:
				elseif(IsCraftingReagent) then
					if(IS.db.processCraftingReagents) then
						AddEntry = true;
					end
				-- Remaining items:
				else
					AddEntry = true;
				end

				if(AddEntry) then
					StackSize = T.select(2, T.GetContainerItemInfo(Bag, Slot));
					TotalValue = TotalValue + Price * StackSize;
					T.table_insert(Selected, {Bag, Slot, Link, StackSize, Price, MerchantOnly});

					-- Set the deletion flag if an item was added
					-- that can also be deleted.
					if(not MerchantOnly) then DeleteItems = true; end
				end
			end
		end
	end

	return TotalValue, Selected, DeleteItems;
end

---------------------------------------------------------------------------------------------------

function IS:HandleNextSelected()
	-- Retrieve the first item
	local Item = IS.ProcessFrame.Info.SelectedItems[1];
	if(not Item) then return true; end

	-- Unpack the entry array.
	local Bag, Slot, Link, StackSize, Price, MerchantOnly = T.unpack(Item);

	-- Print out the item link, stack size and vendor value
	-- in the following format: '[Link] (StackSize), vendor value: 0g 0s 0c'.
	if(IS.db.listHandledItems and Link) then
		KUI:Print(format(L["%s (%d), vendor value: %s."], Link, StackSize, B:FormatMoney(StackSize * Price)));
	end

	-- Delete the current item if no merchant frame was open
	if(IS.ProcessFrame.Info.Delete) then
		-- Check if the current item entry was marked to only be
		-- interated with at a vendor.
		if(not MerchantOnly) then
			T.PickupContainerItem(Bag, Slot);
			T.DeleteCursorItem();
		end
	elseif(Price and Price > 0) then
		T.UseContainerItem(Bag, Slot);
	end

	-- Remove the processed entry from the table and increment the items processed counter.
	T.table_remove(IS.ProcessFrame.Info.SelectedItems, 1);
	IS.ProcessFrame.Info.ItemsProcessed = IS.ProcessFrame.Info.ItemsProcessed + 1;

	return false;
end

---------------------------------------------------------------------------------------------------

function IS:HandleSelection(Tooltip)
	-- Check that selection has been enabled.
	if(not IS.SelectionActive) then return; end

	local SelectedSlot = T.GetMouseFocus();
	local BagFrame = SelectedSlot:GetParent();

	-- Check that the slot exists in the ElvUI container frame.
	if(not SelectedSlot or SelectedSlot == IS.SelectionHover) then return; end
	if(not _G["ElvUI_ContainerFrame"].Bags[BagFrame:GetID()]) then return; end
	-- Cover the case of hovering item links from the chat.
	if(not SelectedSlot.GetID) then return; end

	IS.SelectionHover.Bag = BagFrame:GetID();
	IS.SelectionHover.Slot = SelectedSlot:GetID();

	-- Set the frame to be under the cursor and display it.
	IS.SelectionHover:SetAllPoints(SelectedSlot);
	IS.SelectionHover:Show();
end

---------------------------------------------------------------------------------------------------

function IS:IsAppearanceCollected(ID, Link, Type, EquipLoc)
	local IsCollected, SourceID, _;
	
	-- Validate the item type to be armor of transmogrifiable type.
	if(not HasAppearance(Type, EquipLoc)) then
		return true;
	end

	-- Get the source ID of the item.
	local SourceID = T.select(2, T.C_TransmogCollection_GetItemInfo(Link));

	-- If valid source ID was found check if the appearance has been collected.
	if(SourceID and SourceID ~= NO_TRANSMOG_SOURCE_ID) then
        IsCollected = T.select(5, T.C_TransmogCollection_GetAppearanceSourceInfo(SourceID));
    end

    return IsCollected;
end

---------------------------------------------------------------------------------------------------

function IS:OverrideVendorGrays()
	-- Set the OnClick to go through our function instead,
	-- however we still allow the usage of the original function.
	_G["ElvUI_ContainerFrame"].vendorGraysButton:SetScript("OnClick", IS.ProcessItemCheck);
end

---------------------------------------------------------------------------------------------------

function IS:ProcessFrameUpdate(Elapsed)
	-- Update the timer.
	IS.ProcessFrame.Info.ProgressTimer = IS.ProcessFrame.Info.ProgressTimer - Elapsed;
	if(IS.ProcessFrame.Info.ProgressTimer > 0) then return; end
	IS.ProcessFrame.Info.ProgressTimer = IS.ProcessFrame.Info.SellInterval;

	-- Process the next item.
	local LastItem = IS:HandleNextSelected();

	IS.ProcessFrame.StatusBar:SetValue(IS.ProcessFrame.Info.ItemsProcessed);
	IS.ProcessFrame.StatusBar.ValueText:SetText(T.string_format(L["%d/%d"], IS.ProcessFrame.Info.ItemsProcessed, IS.ProcessFrame.Info.ItemsTotal));
	if(LastItem) then
		IS.ProcessFrame:Hide();
		if(IS.ProcessFrame.Info.Delete) then
			KUI:Print(T.string_format(L["Deleted the selected %d items."], IS.ProcessFrame.Info.ItemsProcessed));
		-- Only print the vendored message if items of value were sold.
		elseif(IS.ProcessFrame.Info.SelectedValue > 0) then
			KUI:Print(T.string_format(L["Vendored selected items for %s."], B:FormatMoney(IS.ProcessFrame.Info.SelectedValue)));
		end
	end
end

---------------------------------------------------------------------------------------------------

function IS:ProcessSelected(DeleteItems)
	-- Check that we aren't already processing items.
	if(IS.ProcessFrame:IsShown()) then return; end

	-- Display the process frame.
	IS:ShowProcessFrame(DeleteItems);

	-- Reset the selected slots value etc.
	IS:Reset();
end

---------------------------------------------------------------------------------------------------

function IS:Reset()
	-- Go through the stored slots and hide their glow effects.
	if(IS.SelectionActive) then
		LCG.PixelGlow_Stop(_G["ElvUI_ContainerFrame"].vendorGraysButton);
		IS.SelectionHover:Hide();
	end
	if(T.next(IS.SelectedStartSlot) ~= nil) then
		LCG.PixelGlow_Stop(IS.SelectedStartSlot.Frame);
	end
	if(T.next(IS.SelectedEndSlot) ~= nil) then
		LCG.PixelGlow_Stop(IS.SelectedEndSlot.Frame);
	end

	-- Reset the flag, slots and update the tooltip
	-- as it contains the 'enabled/disabled' string.
	IS.SelectionActive = false;
	IS.SelectedStartSlot = {};
	IS.SelectedEndSlot = {};
	IS.SelectedValue = 0;
	IS.Selected = {};
	UpdateTooltip();
end

---------------------------------------------------------------------------------------------------

function IS:ShowProcessFrame(DeleteItems)
	-- Copy the array of selected slots to the processing frame.
	IS.ProcessFrame.Info.SelectedItems = IS.Selected;
	IS.ProcessFrame.Info.SelectedValue = IS.SelectedValue;

	if(not IS.ProcessFrame.Info.SelectedItems) then return; end
	if(T.table_maxn(IS.ProcessFrame.Info.SelectedItems) < 1) then return; end

	-- Initialize the remaining fields of the info table.
	IS.ProcessFrame.Info.Delete = DeleteItems or false;
	IS.ProcessFrame.Info.ProgressTimer = 0;
	IS.ProcessFrame.Info.SellInterval = IS.db.processInterval;
	IS.ProcessFrame.Info.ItemsTotal = T.table_maxn(IS.ProcessFrame.Info.SelectedItems);
	IS.ProcessFrame.Info.ItemsProcessed = 0;

	IS.ProcessFrame.StatusBar:SetValue(0);
	IS.ProcessFrame.StatusBar:SetMinMaxValues(0, IS.ProcessFrame.Info.ItemsTotal);
	IS.ProcessFrame.StatusBar.ValueText:SetText(T.string_format("0/%d"), IS.ProcessFrame.Info.ItemsTotal);

	-- Ensure that the frame remains hidden if the user has
	-- chosen to not display the progress during the process.
	if(not IS.db.displayProgressFrame) then
		IS.ProcessFrame:SetAlpha(0);
	else
		IS.ProcessFrame:SetAlpha(1);
	end

	-- Show the frame to the user.
	IS.ProcessFrame:Show();
end

---------------------------------------------------------------------------------------------------

function IS:ToggleSelect(Button, ...)
	-- Toggle the active flag.
	IS.SelectionActive = not IS.SelectionActive;

	-- Handle the glow effect and print out info upon activation
	-- and reset the environment upon deactivation.
	if(IS.SelectionActive) then
		KUI:Print(L["Select start and end slots, everything in between them will be vendored, including the items at selected slots."]);
		LCG.PixelGlow_Start(_G["ElvUI_ContainerFrame"].vendorGraysButton, VendorColor, nil, -0.25, nil, 1);
	else
		LCG.PixelGlow_Stop(_G["ElvUI_ContainerFrame"].vendorGraysButton);
		IS:Reset();
	end

	-- Update the tooltip as it contains the colored 'enabled/disabled' string.
	UpdateTooltip();
	B.Tooltip_Show(_G["ElvUI_ContainerFrame"].vendorGraysButton);
end

---------------------------------------------------------------------------------------------------


function IS:Initialize()
	if not E.private.bags.enable or not E.db.KlixUI.bags.itemSelect.enable then return end
	
	IS.db = E.db.KlixUI.bags.itemSelect
	
	-- Initialize our values.
	IS.SelectionActive = false;
	IS.SelectedStartSlot = {};
	IS.SelectedEndSlot = {};

	-- Override the ElvUI VendorGrayButton's default script, we'll
	-- still call it ourselves if our conditions aren't met.
	IS:OverrideVendorGrays();

	-- Create the hover overlay button and the frame for displaying
	-- selected item processing progress, e.g. vendoring.
	IS:CreateSelectionOverlay();
	IS:CreateProgressFrame();

	-- Hook for both OnShow and OnHide functions of the ElvUI's container frame.
	_G["ElvUI_ContainerFrame"]:HookScript("OnShow", IS.OnShow);
	_G["ElvUI_ContainerFrame"]:HookScript("OnHide", IS.OnHide);
	self:SecureHookScript(GameTooltip, "OnTooltipSetItem", "HandleSelection");
end

KUI:RegisterModule(IS:GetName())