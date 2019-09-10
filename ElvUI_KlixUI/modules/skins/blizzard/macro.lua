local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local function styleMacro()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.macro ~= true or E.private.KlixUI.skins.blizzard.macro ~= true then return end
	
	local MacroFrame = _G.MacroFrame
	if MacroFrame.backdrop then
		MacroFrame.backdrop:Styling()
	end

	for i = 1, _G.MAX_ACCOUNT_MACROS do
		local b = _G['MacroButton'..i]

		if b then
			b:CreateIconShadow()
		end
	end
	
	-- Popout Frame
	local MacroPopupFrame = _G.MacroPopupFrame
	MacroPopupFrame.BorderBox.OkayButton:SetPoint("BOTTOMRIGHT", MacroPopupFrame, "BOTTOMRIGHT", -8, 5)
	MacroPopupFrame.BorderBox.CancelButton:SetPoint("BOTTOMRIGHT", MacroPopupFrame, "BOTTOMRIGHT", -13, 5)
	
	KS:ReskinIconSelectionFrame(_G.MacroPopupFrame, _G.NUM_MACRO_ICONS_SHOWN, 'MacroPopupButton', 'MacroPopup')
end

S:AddCallbackForAddon("Blizzard_MacroUI", "KuiMacro", styleMacro)