local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local function stylePaperDollFrame()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.character ~= true or E.private.KlixUI.skins.blizzard.character ~= true then return end

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
		'RangedSlot',
		'AmmoSlot'
	}

	for _, slot in pairs(slots) do
		local slot = _G['Character'..slot]
		
		slot:CreateIconShadow()
	end
end

S:AddCallback("KuiPaperDoll", stylePaperDollFrame)