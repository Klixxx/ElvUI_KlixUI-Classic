local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local function styleInspect()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.inspect ~= true or E.private.KlixUI.skins.blizzard.inspect ~= true then return end
	
	local InspectFrame = _G.InspectFrame
	if InspectFrame.backdrop then
		InspectFrame.backdrop:Styling()
	end
	
	_G.InspectModelFrame:DisableDrawLayer("OVERLAY")

	if _G.InspectModelFrame.backdrop then
		_G.InspectModelFrame.backdrop:Hide()
	end

	local slots = {
		'HeadSlot',
		'NeckSlot',
		'ShoulderSlot',
		'BackSlot',
		'ChestSlot',
		'ShirtSlot',
		'TabardSlot',
		'WristSlot',
		'HandsSlot',
		'WaistSlot',
		'LegsSlot',
		'FeetSlot',
		'Finger0Slot',
		'Finger1Slot',
		'Trinket0Slot',
		'Trinket1Slot',
		'MainHandSlot',
		'SecondaryHandSlot',
		'RangedSlot'
	}
	
	for _, slot in pairs(slots) do
		local slot = _G['Inspect'..slot]
		
		slot:CreateIconShadow()
	end
	
	hooksecurefunc("InspectPaperDollItemSlotButton_Update", function(button)
		button.IconBorder:SetTexture(E.media.normTex)
		button.icon:SetShown(button.hasItem)
	end)
end

S:AddCallbackForAddon("Blizzard_InspectUI", "KuiInspect", styleInspect)