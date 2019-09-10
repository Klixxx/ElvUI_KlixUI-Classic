local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule('Skins')

local r, g, b = T.unpack(E.media.rgbvaluecolor)

local function styleTrainer()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.trainer ~= true or E.private.KlixUI.skins.blizzard.trainer ~= true then return end

	local ClassTrainerFrame = _G.ClassTrainerFrame
	if ClassTrainerFrame.backdrop then
		ClassTrainerFrame.backdrop:Styling()
	end
	
	hooksecurefunc('ClassTrainer_SetSelection', function()
		if ClassTrainerSkillIcon then
			ClassTrainerSkillIcon:CreateIconShadow()
		end
	end)
end

S:AddCallbackForAddon("Blizzard_TrainerUI", "KuiTrainer", styleTrainer)