local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local r, g, b = T.unpack(E.media.rgbvaluecolor)

local function styleSpellBook()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.spellbook ~= true or E.private.KlixUI.skins.blizzard.spellbook ~= true then return end

	local SpellBookFrame = _G.SpellBookFrame
	if SpellBookFrame.backdrop then
		SpellBookFrame.backdrop:Styling()
	end
	
	if SpellBookFrame.pagebackdrop then
		SpellBookFrame.pagebackdrop:Hide()
	end

	for i = 1, SPELLS_PER_PAGE do
		local button = _G['SpellButton'..i]
		button:CreateIconShadow()
		if E.db.KlixUI.general.iconShadow and not T.IsAddOnLoaded("Masque") then
			button.ishadow:SetInside(button, 0, 0)
		end
	end

	_G.SpellBookPageText:SetTextColor(unpack(E.media.rgbvaluecolor))
	
	for i = 1, MAX_SKILLLINE_TABS do
		local tab = _G['SpellBookSkillLineTab'..i]
		tab:CreateIconShadow()
	end
end

S:AddCallback("KuiSpellbook", styleSpellBook)