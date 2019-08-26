local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleHekili()
	if not E.db.KlixUI.general.iconShadow or not T.IsAddOnLoaded("Hekili") or T.IsAddOnLoaded("Masque") then return end

	for i = 1, 10 do
		if _G["Hekili_Primary_B"..i] then
			_G["Hekili_Primary_B"..i]:CreateIconShadow()
		end
		if _G["Hekili_AOE_B"..i] then
			_G["Hekili_AOE_B"..i]:CreateIconShadow()
		end
			
		local shadowPrimary = _G["Hekili_Primary_B"..i].ishadow
		local shadowAOE = _G["Hekili_AOE_B"..i].ishadow
		if shadowPrimary then
			shadowPrimary:SetInside(_G["Hekili_Primary_B"..i], 0, 0)
		end
		if shadowAOE then
			shadowAOE:SetInside(_G["Hekili_AOE_B"..i], 0, 0)
		end
	end
	
	if _G["HekiliDisplayInterrupts"] then
		_G["HekiliDisplayInterrupts"]:CreateIconShadow()
	end
	if _G["HekiliDisplayDefensives"] then
		_G["HekiliDisplayDefensives"]:CreateIconShadow()
	end
		
	local shadowInt = _G["HekiliDisplayInterrupts"].ishadow
	local shadowDef = _G["HekiliDisplayDefensives"].ishadow
	if shadowInt then
		shadowInt:SetInside(_G["HekiliDisplayInterrupts"], 0, 0)
	end
	if shadowDef then
		shadowDef:SetInside(_G["HekiliDisplayDefensives"], 0, 0)
	end
end

S:AddCallbackForAddon("Hekili", "KuiHekili", styleHekili)