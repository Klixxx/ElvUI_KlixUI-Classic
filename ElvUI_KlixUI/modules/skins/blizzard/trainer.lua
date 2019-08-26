local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule('Skins')

local r, g, b = T.unpack(E.media.rgbvaluecolor)

local function styleTrainer()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.trainer ~= true or E.private.KlixUI.skins.blizzard.trainer ~= true then return end

	local ClassTrainerFrame = _G.ClassTrainerFrame
	ClassTrainerFrame:Styling()

	_G.ClassTrainerStatusBarSkillRank:ClearAllPoints()
	_G.ClassTrainerStatusBarSkillRank:SetPoint("CENTER", _G.ClassTrainerStatusBar, "CENTER", 0, 0)

	local bg = T.CreateFrame("Frame", nil, _G.ClassTrainerFrameSkillStepButton)
	bg:SetPoint("TOPLEFT", 42, -2)
	bg:SetPoint("BOTTOMRIGHT", 0, 2)
	bg:SetFrameLevel(_G.ClassTrainerFrameSkillStepButton:GetFrameLevel()-1)
	KS:CreateBD(bg, .25)

	_G.ClassTrainerFrameSkillStepButton.selectedTex:SetPoint("TOPLEFT", 43, -3)
	_G.ClassTrainerFrameSkillStepButton.selectedTex:SetPoint("BOTTOMRIGHT", -1, 3)
	_G.ClassTrainerFrameSkillStepButton.selectedTex:SetTexture(E["media"].normTex)
	_G.ClassTrainerFrameSkillStepButton.selectedTex:SetVertexColor(r, g, b, .2)

	hooksecurefunc("ClassTrainerFrame_Update", function()
		for _, bu in T.next, ClassTrainerFrame.scrollFrame.buttons do
			if not bu.styled then
				local bg = T.CreateFrame("Frame", nil, bu)
				bg:SetPoint("TOPLEFT", 42, -6)
				bg:SetPoint("BOTTOMRIGHT", 0, 6)
				bg:SetFrameLevel(bu:GetFrameLevel()-1)
				KS:CreateBD(bg, .25)

				bu.name:SetParent(bg)
				bu.name:SetPoint("TOPLEFT", bu.icon, "TOPRIGHT", 6, -2)
				bu.subText:SetParent(bg)
				bu.money:SetParent(bg)
				bu.money:SetPoint("TOPRIGHT", bu, "TOPRIGHT", 5, -8)
				bu:SetNormalTexture("")
				bu:SetHighlightTexture("")
				bu.disabledBG:Hide()
				bu.disabledBG.Show = KUI.dummy

				bu.selectedTex:SetPoint("TOPLEFT", 43, -6)
				bu.selectedTex:SetPoint("BOTTOMRIGHT", -1, 7)
				bu.selectedTex:SetTexture(E.media.normTex)
				bu.selectedTex:SetVertexColor(r, g, b, .2)

				bu.icon:SetTexCoord(T.unpack(E.TexCoords))
				KS:CreateBG(bu.icon)

				bu.styled = true
			end
		end
	end)

	local bd = T.CreateFrame("Frame", nil, _G.ClassTrainerStatusBar)
	bd:SetPoint("TOPLEFT", -1, 1)
	bd:SetPoint("BOTTOMRIGHT", 1, -1)
	bd:SetFrameLevel(_G.ClassTrainerStatusBar:GetFrameLevel()-1)
	KS:CreateBD(bd, .25)
end

S:AddCallbackForAddon("Blizzard_TrainerUI", "KuiTrainer", styleTrainer)