local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local function QuestPOINumericTemplate(button)
	button:SetSize(20, 20)
	button.Number:SetSize(32, 32)
	button.NormalTexture:SetSize(32, 32)
	button.HighlightTexture:SetSize(32, 32)
	button.PushedTexture:SetSize(32, 32)
end

local function QuestPOICompletedTemplate(button)
	button:SetSize(20, 20)
	button.FullHighlightTexture:SetSize(32, 32)
	button.NormalTexture:SetSize(32, 32)
	button.PushedTexture:SetSize(32, 32)
end

function QuestPOIGetButton(parent, questID, style, index)
	if E.private.skins.blizzard.enable ~= true or E.private.KlixUI.skins.blizzard.questPOI ~= true then return end

	local poiButton
	if style == "numeric" then
		poiButton = parent.poiTable.numeric[index]
		if not poiButton.IsSkinned then
			QuestPOINumericTemplate(poiButton)
		end
	else
		for _, button in T.next, parent.poiTable.completed do
			if button.questID == questID then
				poiButton = button
				break
			end
		end
		if not poiButton.IsSkinned then
			QuestPOICompletedTemplate(poiButton)
		end
	end
end
hooksecurefunc("QuestPOI_GetButton", QuestPOIGetButton)
