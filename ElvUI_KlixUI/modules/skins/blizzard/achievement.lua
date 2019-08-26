local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local r, g, b = T.unpack(E.media.rgbvaluecolor)

local function styleAchievement()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.achievement ~= true or E.private.KlixUI.skins.blizzard.achievement ~= true then return end

	_G.AchievementFrame.backdrop:Styling()

	-- Hide the ElvUI default backdrop
	if _G.AchievementFrameCategoriesContainer.backdrop then
		_G.AchievementFrameCategoriesContainer.backdrop:Hide()
	end

	for i = 1, 7 do
		local bu = _G["AchievementFrameAchievementsContainerButton"..i]
		-- Hide ElvUI's backdrop
		if bu.backdrop then bu.backdrop:SetTemplate("Transparent") end

		bu:DisableDrawLayer("BORDER")
		bu:CreateBackdrop("Transparent")
		bu.backdrop:SetInside(bu, 2, 2)
		bu.backdrop:SetBackdropBorderColor(r, g, b)
		KS:CreateGradient(bu)

		bu.background:SetTexture(E.media.normTex)
		bu.background:SetVertexColor(0, 0, 0, .25)

		bu.description:SetTextColor(.6, .6, .6)
		bu.description.SetTextColor = KUI.dummy
		bu.description:SetShadowOffset(1, -1)
		bu.description.SetShadowOffset = KUI.dummy

		_G["AchievementFrameAchievementsContainerButton"..i.."TitleBackground"]:Hide()
		_G["AchievementFrameAchievementsContainerButton"..i.."Glow"]:Hide()
		_G["AchievementFrameAchievementsContainerButton"..i.."RewardBackground"]:SetAlpha(0)
		_G["AchievementFrameAchievementsContainerButton"..i.."PlusMinus"]:SetAlpha(0)
		_G["AchievementFrameAchievementsContainerButton"..i.."Highlight"]:SetAlpha(0)
		_G["AchievementFrameAchievementsContainerButton"..i.."IconOverlay"]:Hide()
		_G["AchievementFrameAchievementsContainerButton"..i.."GuildCornerL"]:SetAlpha(0)
		_G["AchievementFrameAchievementsContainerButton"..i.."GuildCornerR"]:SetAlpha(0)

		S:HandleIcon(bu.icon.texture)
	end

	hooksecurefunc("AchievementButton_DisplayAchievement", function(button, category, achievement)
		local _, _, _, completed = T.GetAchievementInfo(category, achievement)
		if completed then
			if button.accountWide then
				button.label:SetTextColor(0, .6, 1)
			else
				button.label:SetTextColor(.9, .9, .9)
			end
		else
			if button.accountWide then
				button.label:SetTextColor(0, .3, .5)
			else
				button.label:SetTextColor(.65, .65, .65)
			end
		end
	end)

	hooksecurefunc("AchievementObjectives_DisplayCriteria", function(objectivesFrame, id)
		for i = 1, T.GetAchievementNumCriteria(id) do
			local name = _G["AchievementFrameCriteria"..i.."Name"]
			if name and T.select(2, name:GetTextColor()) == 0 then
				name:SetTextColor(1, 1, 1)
			end

			local bu = _G["AchievementFrameMeta"..i]
			if bu and T.select(2, bu.label:GetTextColor()) == 0 then
				bu.label:SetTextColor(1, 1, 1)
			end
		end
	end)

	hooksecurefunc("AchievementFrameSummary_UpdateAchievements", function()
		for i = 1, ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS do
			local bu = _G["AchievementFrameSummaryAchievement"..i]
			if not bu.reskinned then
				-- Hide ElvUI's backdrop
				if bu.backdrop then bu.backdrop:SetTemplate("Transparent") end

				bu:CreateBackdrop("Transparent")
				bu.backdrop:SetInside(bu, 2, 2)
				KS:CreateGradient(bu)
				bu:DisableDrawLayer("BORDER")

				local bd = _G["AchievementFrameSummaryAchievement"..i.."Background"]

				bd:SetTexture(E["media"].normTex)
				bd:SetVertexColor(0, 0, 0, .25)

				_G["AchievementFrameSummaryAchievement"..i.."TitleBackground"]:Hide()
				_G["AchievementFrameSummaryAchievement"..i.."Glow"]:Hide()
				_G["AchievementFrameSummaryAchievement"..i.."Highlight"]:SetAlpha(0)
				_G["AchievementFrameSummaryAchievement"..i.."IconOverlay"]:Hide()

				local text = _G["AchievementFrameSummaryAchievement"..i.."Description"]
				text:SetTextColor(.6, .6, .6)
				text.SetTextColor = KUI.dummy
				text:SetShadowOffset(1, -1)
				text.SetShadowOffset = KUI.dummy

				local ic = _G["AchievementFrameSummaryAchievement"..i.."IconTexture"]
				ic:SetTexCoord(T.unpack(E.TexCoords))
				KS:CreateBG(ic)

				bu.reskinned = true
			end
		end
	end)

	_G.AchievementFrame:HookScript("OnShow", function()
		for i = 1, 20 do
			local frame = _G["AchievementFrameCategoriesContainerButton"..i]

			--frame:StyleButton()
			frame:GetHighlightTexture():Point("TOPLEFT", 0, -4)
			frame:GetHighlightTexture():Point("BOTTOMRiGHT", 0, -3)
			frame:GetPushedTexture():Point("TOPLEFT", 0, -4)
			frame:GetPushedTexture():Point("BOTTOMRiGHT", 0, -3)
		end
	end)

	for i = 1, 12 do
		local bu = _G["AchievementFrameSummaryCategoriesCategory"..i]
		local label = _G["AchievementFrameSummaryCategoriesCategory"..i.."Label"]

		bu:SetStatusBarTexture(E["media"].normTex)
		label:SetTextColor(1, 1, 1)
		label:Point("LEFT", bu, "LEFT", 6, 0)

		local bg = T.CreateFrame("Frame", nil, bu)
		bg:Point("TOPLEFT", -1, 1)
		bg:Point("BOTTOMRIGHT", 1, -1)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)
		KS:CreateBD(bg, .25)

		_G["AchievementFrameSummaryCategoriesCategory"..i.."Left"]:Hide()
		_G["AchievementFrameSummaryCategoriesCategory"..i.."Middle"]:Hide()
		_G["AchievementFrameSummaryCategoriesCategory"..i.."Right"]:Hide()
		_G["AchievementFrameSummaryCategoriesCategory"..i.."ButtonHighlight"]:SetAlpha(0)
		_G["AchievementFrameSummaryCategoriesCategory"..i.."Text"]:SetPoint("RIGHT", bu, "RIGHT", -5, 0)
	end

	for i = 1, 20 do
		local bu = _G["AchievementFrameStatsContainerButton"..i]
		bu:StripTextures()
		bu:GetHighlightTexture():SetColorTexture(r, g, b, .2)
		bu:GetHighlightTexture():SetBlendMode("BLEND")
	end

	_G.AchievementFrame.searchBox:Point("BOTTOMRIGHT", _G.AchievementFrameAchievementsContainer, "TOPRIGHT", -2, -2)
	_G.AchievementFrame.searchBox:SetSize(100, 20)

	-- Font width fix
	hooksecurefunc("AchievementObjectives_DisplayProgressiveAchievement", function()
		local index = 1
		local mini = _G["AchievementFrameMiniAchievement"..index]
		while mini do
			if not mini.fontStyled then
				mini.points:SetWidth(22)
				mini.points:ClearAllPoints()
				mini.points:SetPoint("BOTTOMRIGHT", 2, 2)
				mini.fontStyled = true
			end
			index = index + 1
			mini = _G["AchievementFrameMiniAchievement"..index]
		end
	end)
end

S:AddCallbackForAddon("Blizzard_AchievementUI", "KuiAchievement", styleAchievement)