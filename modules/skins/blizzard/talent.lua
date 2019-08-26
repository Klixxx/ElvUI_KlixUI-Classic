local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local r, g, b = T.unpack(E.media.rgbvaluecolor)

local function styleTalents()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.talent ~= true or E.private.KlixUI.skins.blizzard.talent ~= true then return end
	
	_G.PlayerTalentFrame.backdrop:Styling()

	-- Specc
	for i = 1, T.GetNumSpecializations(false, nil) do
		local bu = _G.PlayerTalentFrameSpecialization["specButton"..i]
		local _, _, _, icon = T.GetSpecializationInfo(i, false, nil)

		bu.ring:Hide()

		bu.specIcon:SetTexture(icon)
		bu.specIcon:SetTexCoord(T.unpack(E.TexCoords))
		bu.specIcon:SetSize(50, 50)
		bu.specIcon:SetPoint("LEFT", bu, "LEFT", 15, 0)

		bu.SelectedTexture = bu:CreateTexture(nil, "BACKGROUND")
		bu.SelectedTexture:SetColorTexture(r, g, b, .5)
	end

	-- Talents
	for i = 1, _G.MAX_TALENT_TIERS do
		local row = _G.PlayerTalentFrameTalents['tier'..i]
		for j = 1, _G.NUM_TALENT_COLUMNS do
			local bu = row['talent'..j]
			if bu.bg then
				KS:CreateGradient(bu.bg)
				bu.bg.backdrop:SetTemplate("Transparent")
				bu.bg.SelectedTexture:SetColorTexture(r, g, b, .5)
			end
		end
	end

	for _, frame in T.pairs({ _G.PlayerTalentFrameSpecialization, _G.PlayerTalentFramePetSpecialization }) do
		local scrollChild = frame.spellsScroll.child

		scrollChild.ring:Hide()
		scrollChild.specIcon:SetTexCoord(T.unpack(E.TexCoords))
		scrollChild.specIcon:Size(70, 70)

		local roleIcon = scrollChild.roleIcon

		roleIcon:SetTexture(E.media.roleIcons)

		local left = scrollChild:CreateTexture(nil, "OVERLAY")
		left:SetWidth(1)
		left:SetTexture(E["media"].normTex)
		left:SetVertexColor(0, 0, 0)
		left:SetPoint("TOPLEFT", roleIcon, 3, -3)
		left:SetPoint("BOTTOMLEFT", roleIcon, 3, 4)

		local right = scrollChild:CreateTexture(nil, "OVERLAY")
		right:SetWidth(1)
		right:SetTexture(E["media"].normTex)
		right:SetVertexColor(0, 0, 0)
		right:SetPoint("TOPRIGHT", roleIcon, -3, -3)
		right:SetPoint("BOTTOMRIGHT", roleIcon, -3, 4)

		local top = scrollChild:CreateTexture(nil, "OVERLAY")
		top:SetHeight(1)
		top:SetTexture(E["media"].normTex)
		top:SetVertexColor(0, 0, 0)
		top:SetPoint("TOPLEFT", roleIcon, 3, -3)
		top:SetPoint("TOPRIGHT", roleIcon, -3, -3)

		local bottom = scrollChild:CreateTexture(nil, "OVERLAY")
		bottom:SetHeight(1)
		bottom:SetTexture(E["media"].normTex)
		bottom:SetVertexColor(0, 0, 0)
		bottom:SetPoint("BOTTOMLEFT", roleIcon, 3, 4)
		bottom:SetPoint("BOTTOMRIGHT", roleIcon, -3, 4)
	end

	hooksecurefunc("PlayerTalentFrame_UpdateSpecFrame", function(self, spec)
		local playerTalentSpec = T.GetSpecialization(nil, self.isPet, _G.PlayerSpecTab2:GetChecked() and 2 or 1)
		local shownSpec = spec or playerTalentSpec or 1
		local numSpecs = T.GetNumSpecializations(nil, self.isPet);

		local sex = self.isPet and T.UnitSex("pet") or T.UnitSex("player")
		local id, _, _, icon = T.GetSpecializationInfo(shownSpec, nil, self.isPet, nil, sex)
		local scrollChild = self.spellsScroll.child

		scrollChild.specIcon:SetTexture(icon)

		local index = 1
		local bonuses
		local bonusesIncrement = 1;
		if self.isPet then
			bonuses = {T.GetSpecializationSpells(shownSpec, nil, self.isPet, true)}
			bonusesIncrement = 2;
		else
			bonuses = T.C_SpecializationInfo_GetSpellsDisplay(id)
		end

		if bonuses then
			for i = 1, #bonuses, bonusesIncrement do
				local frame = scrollChild["abilityButton"..index]
				local _, spellIcon = T.GetSpellTexture(bonuses[i])

				frame.icon:SetTexture(spellIcon)
				frame.subText:SetTextColor(.75, .75, .75)

				if not frame.styled and not frame.backdrop then
					frame.ring:Hide()
					frame.icon:SetTexCoord(T.unpack(E.TexCoords))
					KS:CreateBG(frame.icon)

					frame.styled = true
				end
				index = index + 1
			end
		end

		for i = 1, numSpecs do
			local bu = self["specButton"..i]

			if bu.disabled then
				bu.roleName:SetTextColor(.5, .5, .5)
			else
				bu.roleName:SetTextColor(1, 1, 1)
			end
		end
	end)

	local buttons = {"PlayerTalentFrameSpecializationSpecButton", "PlayerTalentFramePetSpecializationSpecButton"}

	for _, name in T.pairs(buttons) do
		for i = 1, 4 do
			local bu = _G[name..i]

			if bu and bu.backdrop then
				bu.backdrop:SetTemplate("Transparent")
				KS:CreateGradient(bu.backdrop)
			end
		end
	end

	-- PvP Talents
	local PlayerTalentFrameTalentsPvpTalentFrameTalentList = _G.PlayerTalentFrameTalentsPvpTalentFrameTalentList
	PlayerTalentFrameTalentsPvpTalentFrameTalentList.backdrop:Styling()

	for i = 1, 10 do
		local bu = _G["PlayerTalentFrameTalentsPvpTalentFrameTalentListScrollFrameButton"..i]
		local icon = bu.Icon
		if bu then
			-- Hide ElvUI backdrop
			if bu.backdrop then
				bu.backdrop:Hide()
			end

			KS:Reskin(bu)

			if bu.Selected then
				bu.Selected:SetTexture(nil)

				bu.selectedTexture = bu:CreateTexture(nil, "ARTWORK")
				bu.selectedTexture:SetInside(bu)
				bu.selectedTexture:SetColorTexture(r, g, b, .5)
				bu.selectedTexture:SetShown(bu.Selected:IsShown())

				hooksecurefunc(bu, "Update", function(selectedHere)
					if not bu.selectedTexture then return end
					if bu.Selected:IsShown() then
						bu.selectedTexture:SetShown(selectedHere)
					else
						bu.selectedTexture:Hide()
					end
				end)
			end

			bu.backdrop:SetAllPoints()

			if bu.Icon then
				bu.Icon:SetTexCoord(T.unpack(E.TexCoords))
				bu.Icon:SetDrawLayer("ARTWORK", 1)
			end
		end
	end
end

S:AddCallbackForAddon("Blizzard_TalentUI", "KuiTalents", styleTalents)