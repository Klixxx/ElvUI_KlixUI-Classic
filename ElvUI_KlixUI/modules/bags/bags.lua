local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KB = KUI:NewModule("KuiBags", 'AceHook-3.0', 'AceEvent-3.0');
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")
local B = E:GetModule('Bags')
local Pr

-- Styling
function KB:SkinBags()
	if ElvUI_ContainerFrame then
		ElvUI_ContainerFrame:Styling()
		ElvUI_ContainerFrameContainerHolder:Styling()
	end

	if ElvUIBags then
		ElvUIBags.backdrop:Styling()
	end
end

function KB:SkinBank()
	if ElvUI_BankContainerFrame then
		ElvUI_BankContainerFrame:Styling()
		ElvUI_BankContainerFrameContainerHolder:Styling()
	end
end

function KB:AllInOneBags()
	self:SkinBags()
	hooksecurefunc(B, "OpenBank", KB.SkinBank)
end

function KB:SkinBlizzBags()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.bags ~= true or E.private.bags.enable then return end

	for i = 1, NUM_CONTAINER_FRAMES, 1 do
		local container = _G['ContainerFrame'..i]
		if container.backdrop then
			container.backdrop:Styling()
		end
	end
	if BankFrame then
		BankFrame:Styling()
	end
end

function KB:AUCTION_HOUSE_SHOW()
	T.OpenAllBags()
end

function KB:AUCTION_HOUSE_CLOSED()
	ContainerFrame1.backpackWasOpen = nil
	T.CloseAllBags()
end

function KB:TRADE_SHOW()
	T.OpenAllBags()
end

function KB:TRADE_CLOSED()
	ContainerFrame1.backpackWasOpen = nil
	T.CloseAllBags()
end

function KB:HookBags(isBank)
	local slot
	for _, bagFrame in T.pairs(B.BagFrames) do
		-- Applying shadow for all current slots
		for _, bagID in pairs(bagFrame.BagIDs) do
			for slotID = 1, T.GetContainerNumSlots(bagID) do
				if bagFrame.Bags[bagID] then
					slot = bagFrame.Bags[bagID][slotID]
					slot:CreateIconShadow()
				end
			end
		end
	end
end

function KB:Initialize()
	if not E.private.bags.enable then return end
	
	function KB:ForUpdateAll()
		KB.db = E.db.KlixUI.bags
	end
	
	KB:ForUpdateAll()
	
	self:AllInOneBags()
	self:SkinBlizzBags()
	self:SkinBank()
	
	KB:RegisterEvent("AUCTION_HOUSE_SHOW")
	KB:RegisterEvent("AUCTION_HOUSE_CLOSED")
	KB:RegisterEvent("TRADE_SHOW")
	KB:RegisterEvent("TRADE_CLOSED")

	self:HookBags()
	hooksecurefunc(B, "Layout", function(self, isBank)
		KB:HookBags(isBank)
	end)
end

KUI:RegisterModule(KB:GetName())