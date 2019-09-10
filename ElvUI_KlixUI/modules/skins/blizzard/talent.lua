local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleTalents()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.talent ~= true or E.private.KlixUI.skins.blizzard.talent ~= true then return end
	
	local TalentFrame = TalentFrame
	if TalentFrame.backdrop then
		TalentFrame.backdrop:Styling()
	end
	
	-- Hide ElvUI Backdrop
	if TalentFrameScrollFrame.backdrop then
		TalentFrameScrollFrame.backdrop:Hide()
	end
	
	TalentFrameBackgroundTopLeft:Hide()
	TalentFrameBackgroundTopRight:Hide()
	TalentFrameBackgroundBottomLeft:Hide()
	TalentFrameBackgroundBottomRight:Hide()
	
	for i = 1, MAX_NUM_TALENTS do
		local talent = _G['TalentFrameTalent'..i]
		local icon = _G['TalentFrameTalent'..i..'IconTexture']
		local rank = _G['TalentFrameTalent'..i..'Rank']

		if talent then
			talent:CreateIconShadow()
		end
	end
end

S:AddCallbackForAddon("Blizzard_TalentUI", "KuiTalents", styleTalents)