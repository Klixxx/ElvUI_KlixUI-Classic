-------------------------------------------------------------------------------
-- Credits: Already Known? - ahak
-------------------------------------------------------------------------------
local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KAK = KUI:NewModule('KuiAlreadyKnown', "AceHook-3.0");

local r, g, b
local knownTable = {} -- Save known items for later use
local questItems = { -- Quest items and matching quests
	-- Equipment Blueprint: Tuskarr Fishing Net
	[128491] = 39359, -- Alliance
	[128251] = 39359, -- Horde
	-- Equipment Blueprint: Unsinkable
	[128250] = 39358, -- Alliance
	[128489] = 39358, -- Horde
}
local specialItems = { -- Items needing special treatment
	-- Krokul Flute -> Flight Master's Whistle
	[152964] = { 141605, 11, 269 } -- 269 for Flute applied Whistle, 257 (or anything else than 269) for pre-apply Whistle
}

-- Tooltip and scanning by Phanx @ http://www.wowinterface.com/forums/showthread.php?p=271406
-- Search string by Phanx @ https://github.com/Phanx/BetterBattlePetTooltip/blob/master/Addon.lua
local S_PET_KNOWN = T.string_match(_G.ITEM_PET_KNOWN, "[^%(]+")

local scantip = T.CreateFrame("GameTooltip", "AKScanningTooltip", nil, "GameTooltipTemplate")
scantip:SetOwner(UIParent, "ANCHOR_NONE")

local function _checkIfKnown(itemLink)
	if knownTable[itemLink] then -- Check if we have scanned this item already and it was known then
		return true
	end
	local itemID = T.tonumber(itemLink:match("item:(%d+)"))
	if itemID and questItems[itemID] then -- Check if item is a quest item.
		if T.IsQuestFlaggedCompleted(questItems[itemID]) then -- Check if the quest for item is already done.
			knownTable[itemLink] = true -- Mark as known for later use
			return true -- This quest item is already known
		end
		return false -- Quest item is uncollected... or something went wrong
	elseif itemID and specialItems[itemID] then -- Check if we need special handling, this is most likely going to break with then next item we add to this
		local specialData = specialItems[itemID]
		local _, specialLink = T.GetItemInfo(specialData[1])
		if specialLink then
			local specialTbl = { T.string_split(":", specialLink) }
			local specialInfo = T.tonumber(specialTbl[specialData[2]])
			if specialInfo == specialData[3] then
				knownTable[itemLink] = true -- Mark as known for later use
				return true -- This specialItem is already known
			end
		end
		return false -- Item is specialItem, but data isn't special
	end

	if itemLink:match("|H(.-):") == "battlepet" then -- Check if item is Caged Battlepet (dummy item 82800)
		local _, battlepetID = T.string_split(":", itemLink)
		if T.C_PetJournal_GetNumCollectedInfo(battlepetID) > 0 then
			knownTable[itemLink] = true -- Mark as known for later use
			return true -- Battlepet is collected
		end
		return false -- Battlepet is uncollected... or something went wrong
	end

	scantip:ClearLines()
	scantip:SetHyperlink(itemLink)

	--for i = 2, scantip:NumLines() do -- Line 1 is always the name so you can skip it.
	local lines = scantip:NumLines()
	for i = 2, lines do -- Line 1 is always the name so you can skip it.
		local text = _G["AKScanningTooltipTextLeft"..i]:GetText()
		if text == _G.ITEM_SPELL_KNOWN or T.string_match(text, S_PET_KNOWN) then
			--knownTable[itemLink] = true -- Mark as known for later use
			--return true -- Item is known and collected
			if lines - i <= 3 then -- Mounts have Riding skill and Reputation requirements under Already Known -line
				knownTable[itemLink] = true -- Mark as known for later use
			end
		elseif text == _G.TOY and _G["AKScanningTooltipTextLeft"..i + 2] and _G["AKScanningTooltipTextLeft"..i + 2]:GetText() == _G.ITEM_SPELL_KNOWN then
			-- Check if items is Toy already known
			knownTable[itemLink] = true
		end
	end
	--return false -- Item is not known, uncollected... or something went wrong
	return knownTable[itemLink] and true or false
end

local function _hookAH() -- Most of this found from AddOns/Blizzard_AuctionUI/Blizzard_AuctionUI.lua
	local offset = T.FauxScrollFrame_GetOffset(_G.BrowseScrollFrame)

	for i=1, _G.NUM_BROWSE_TO_DISPLAY do
		if (_G["BrowseButton"..i.."Item"] and _G["BrowseButton"..i.."ItemIconTexture"]) or _G["BrowseButton"..i].id then -- Something to do with ARL?
			local itemLink
			if _G["BrowseButton"..i].id then
				itemLink = T.GetAuctionItemLink('list', _G["BrowseButton"..i].id)
			else
				itemLink = T.GetAuctionItemLink('list', offset + i)
			end

			if itemLink and _checkIfKnown(itemLink) then
				if _G["BrowseButton"..i].id then
					_G["BrowseButton"..i].Icon:SetVertexColor(r, g, b)
				else
					_G["BrowseButton"..i.."ItemIconTexture"]:SetVertexColor(r, g, b)
				end
			else
				if _G["BrowseButton"..i].id then
					_G["BrowseButton"..i].Icon:SetVertexColor(1, 1, 1)
					_G["BrowseButton"..i].Icon:SetDesaturated(false)
				else
					_G["BrowseButton"..i.."ItemIconTexture"]:SetVertexColor(1, 1, 1)
					_G["BrowseButton"..i.."ItemIconTexture"]:SetDesaturated(false)
				end
			end
		end
	end
end

local function _hookMerchant() -- Most of this found from FrameXML/MerchantFrame.lua
	for i = 1, _G.MERCHANT_ITEMS_PER_PAGE do
		local index = (((_G.MerchantFrame.page - 1) * _G.MERCHANT_ITEMS_PER_PAGE) + i)
		local itemButton = _G["MerchantItem"..i.."ItemButton"]
		local merchantButton = _G["MerchantItem"..i]
		local itemLink = T.GetMerchantItemLink(index)

		if itemLink and _checkIfKnown(itemLink) then
			T.SetItemButtonNameFrameVertexColor(merchantButton, r, g, b)
			T.SetItemButtonSlotVertexColor(merchantButton, r, g, b)
			T.SetItemButtonTextureVertexColor(itemButton, .8*r, .8*g, .8*b)
			T.SetItemButtonNormalTextureVertexColor(itemButton, .8*r, .8*g, .8*b)
		else
			_G["MerchantItem"..i.."ItemButtonIconTexture"]:SetDesaturated(false)
		end
	end
end

function KAK:Initialize()
	if not E.db.KlixUI.misc.alreadyknown.enable then return end
	
	-- Color
	r, g, b = E.db.KlixUI.misc.alreadyknown.color.r, E.db.KlixUI.misc.alreadyknown.color.g, E.db.KlixUI.misc.alreadyknown.color.b
	
	-- Merchant
	hooksecurefunc("MerchantFrame_UpdateMerchantInfo", _hookMerchant)
	
	-- Auction House
	if T.IsAddOnLoaded("Blizzard_AuctionUI") then
		if T.IsAddOnLoaded("Auc-Advanced") and _G.AucAdvanced.Settings.GetSetting("util.compactui.activated") then
			hooksecurefunc("GetNumAuctionItems", _hookAH)
		else
			hooksecurefunc("AuctionFrameBrowse_Update", _hookAH)
		end
	else
		local f = T.CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(self, event, ...)
			if event == "ADDON_LOADED" and (...) == "Blizzard_AuctionUI" then
				self:UnregisterEvent(event)
				if T.IsAddOnLoaded("Auc-Advanced") and _G.AucAdvanced.Settings.GetSetting("util.compactui.activated") then
					hooksecurefunc("GetNumAuctionItems", _hookAH)
				else
					hooksecurefunc("AuctionFrameBrowse_Update", _hookAH)
				end
			end
		end)
	end
end

local function InitializeCallback()
	KAK:Initialize()
end

KUI:RegisterModule(KAK:GetName(), InitializeCallback)