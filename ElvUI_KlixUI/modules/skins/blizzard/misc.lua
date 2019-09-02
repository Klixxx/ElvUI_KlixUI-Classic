local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local MAX_STATIC_POPUPS = 4

local function styleMisc()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.misc ~= true then return end

	local GameMenuFrame = _G.GameMenuFrame
	_G.GameMenuFrame:Styling()

	-- GameMenu Header Color
	for i = 1, GameMenuFrame:GetNumRegions() do
		local Region = T.select(i, GameMenuFrame:GetRegions())
		if Region.IsObjectType and Region:IsObjectType('FontString') then
			Region:SetTextColor(1, 1, 1)
		end
	end

	-- Tooltips
	local tooltips = {
		GameTooltip,
		FriendsTooltip,
		ItemRefTooltip,
		ItemRefShoppingTooltip1,
		ItemRefShoppingTooltip2,
		ItemRefShoppingTooltip3,
		AutoCompleteBox,
		ShoppingTooltip1,
		ShoppingTooltip2,
		ShoppingTooltip3,
		FloatingBattlePetTooltip,
		FloatingPetBattleAbilityTooltip,
		FloatingGarrisonFollowerTooltip,
		FloatingGarrisonFollowerAbilityTooltip,
		PetBattlePrimaryUnitTooltip,
		PetBattlePrimaryAbilityTooltip,
		EventTraceTooltip,
		FrameStackTooltip,
		DatatextTooltip
	}

	for _, frame in T.pairs(tooltips) do
		if frame and not frame.style then
			frame:Styling()
		end
	end
	
	local skins = {
		"StaticPopup1",
		"StaticPopup2",
		"StaticPopup3",
		"StaticPopup4",
		"InterfaceOptionsFrame",
		"VideoOptionsFrame",
		"AudioOptionsFrame",
		"AutoCompleteBox",
		"ReadyCheckFrame",
	}

	for i = 1, T.table_getn(skins) do
		_G[skins[i]]:Styling()
	end
	
	-- ElvUI StaticPopups
	for i = 1, MAX_STATIC_POPUPS do
		local frame = _G["ElvUI_StaticPopup"..i]
		frame:Styling()
	end
	
	-- DropDownMenu
	hooksecurefunc("UIDropDownMenu_CreateFrames", function(level, index)
		local listFrame = _G["DropDownList"..level]
		local listFrameName = listFrame:GetName()

		local Backdrop = _G[listFrameName.."Backdrop"]
		if Backdrop and not Backdrop.IsSkinned then
			Backdrop:Styling()
			Backdrop.IsSkinned = true
		end
		local menuBackdrop = _G[listFrameName.."MenuBackdrop"]
		if menuBackdrop and not menuBackdrop.IsSkinned then
			menuBackdrop:Styling()
			menuBackdrop.IsSkinned = true
		end
	end)
	
	--DropDownMenu library support
	if _G.LibStub("LibUIDropDownMenu", true) then
		_G.L_DropDownList1Backdrop:Styling()
		_G.L_DropDownList1MenuBackdrop:Styling()
		hooksecurefunc("L_UIDropDownMenu_CreateFrames", function()
			if not _G["L_DropDownList".._G.L_UIDROPDOWNMENU_MAXLEVELS.."Backdrop"].template then
				_G["L_DropDownList".._G.L_UIDROPDOWNMENU_MAXLEVELS.."Backdrop"]:Styling()
				_G["L_DropDownList".._G.L_UIDROPDOWNMENU_MAXLEVELS.."MenuBackdrop"]:Styling()
			end
		end)
	end

	if _G.TalentMicroButtonAlert then
		_G.TalentMicroButtonAlert:Styling()
	end
	
	if _G.GearManagerDialogPopup then
		_G.GearManagerDialogPopup:Styling()
	end
	
	-- ElvUI things!
	_G.LeftMiniPanel:Styling()
	_G.RightMiniPanel:Styling()
	
	_G.MirrorTimer1StatusBar:Styling()
	_G.MirrorTimer2StatusBar:Styling()
	_G.MirrorTimer3StatusBar:Styling()
	
	_G.ElvUIVendorGraysFrame.backdrop:Styling()
	
	--_G.SplashFrame:Styling()

	_G.ChatConfigFrame:Styling()
	
	if _G.CopyChatFrame then
		_G.CopyChatFrame:Styling()
	end
	
	if _G.RaidUtilityPanel then
		_G.RaidUtilityPanel:Styling()
	end
	
	if _G.ChatMenu then
		_G.ChatMenu:Styling()
	end
	if _G.EmoteMenu then
		_G.EmoteMenu:Styling()
	end
	if _G.LanguageMenu then
		_G.LanguageMenu:Styling()
	end
	if _G.VoiceMacroMenu then
		_G.VoiceMacroMenu:Styling()
	end
	
	if E:SpawnTutorialFrame() then
		_G.ElvUITutorialWindow:Styling()
	end
	
	if _G.ElvUIBindPopupWindow then
		_G.ElvUIBindPopupWindow:Styling()
	end
	
	if _G.ColorPickerFrame then
		_G.ColorPickerFrame:Styling()
	end
	
end

S:AddCallback("KuiMisc", styleMisc)