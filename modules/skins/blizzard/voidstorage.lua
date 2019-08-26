local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleVoidstorage()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.voidstorage ~= true or E.private.KlixUI.skins.blizzard.voidstorage ~= true then return end
	
	local VoidStorageFrame = _G.VoidStorageFrame
	VoidStorageFrame:Styling()

	VoidStorageFrame.Page1:ClearAllPoints()
	VoidStorageFrame.Page1:SetPoint("LEFT", VoidStorageFrame, "TOPRIGHT", 2, -60)
	
	for i = 1, 2 do
		local tab = VoidStorageFrame["Page"..i]
		tab:CreateButtonShadow()
	end
	
	for StorageType, NumSlots  in T.pairs({ ['Deposit'] = 9, ['Withdraw'] = 9, ['Storage'] = 80 }) do
		for i = 1, NumSlots do
			local Button = _G["VoidStorage"..StorageType.."Button"..i]
			Button:CreateIconShadow()
		end
	end
end

S:AddCallbackForAddon("Blizzard_VoidStorageUI", "KuiVoidStorage", styleVoidstorage)