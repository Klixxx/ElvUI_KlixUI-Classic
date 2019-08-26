local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function StylePawn()
	if not E.db.KlixUI.armory.enable or E.db.general.displayCharacterInfo or T.IsAddOnLoaded('ElvUI_SLE') or E.private.KlixUI.skins.addonSkins.pw ~= true then return end
	hooksecurefunc('PawnUI_InventoryPawnButton_Move', function()
		if _G["PawnUI_InventoryPawnButton"] then
			if PawnCommon.ButtonPosition == PawnButtonPositionRight then
				_G["PawnUI_InventoryPawnButton"]:ClearAllPoints()
				_G["PawnUI_InventoryPawnButton"]:SetPoint('BOTTOMRIGHT', _G["PaperDollFrame"], 'BOTTOMRIGHT', 0, 0)
			elseif PawnCommon.ButtonPosition == PawnButtonPositionLeft then
				_G["PawnUI_InventoryPawnButton"]:ClearAllPoints()
				_G["PawnUI_InventoryPawnButton"]:SetPoint('BOTTOMLEFT', _G["PaperDollFrame"], 'BOTTOMLEFT', 0, 0)
			end
		end
	end)
end

S:AddCallbackForAddon("Pawn", "Pawn", StylePawn)