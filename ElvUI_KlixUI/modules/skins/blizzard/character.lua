local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local r, g, b = T.unpack(E.media.rgbvaluecolor)

local function UpdateReputationDetails()
	local ReputationDetailFrame = _G.ReputationDetailFrame
	
	if ReputationDetailFrame then
		ReputationDetailFrame:StripTextures()
		ReputationDetailFrame:CreateBackdrop('Transparent')
		ReputationDetailFrame.backdrop:Styling()
	end
	
	ReputationDetailFrame:ClearAllPoints()
	ReputationDetailFrame:Point("TOPLEFT", _G.ReputationFrame, "TOPRIGHT", -30, -13)
end

local function styleCharacter()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.character ~= true or E.private.KlixUI.skins.blizzard.character ~= true then return end

	local CharacterFrame = _G.CharacterFrame
	local CharacterModelFrame = _G.CharacterModelFrame
	CharacterFrame.backdrop:Styling()

	if CharacterModelFrame and CharacterModelFrame.BackgroundTopLeft and CharacterModelFrame.BackgroundTopLeft:IsShown() then
		CharacterModelFrame.BackgroundTopLeft:Hide()
		CharacterModelFrame.BackgroundTopRight:Hide()
		CharacterModelFrame.BackgroundBotLeft:Hide()
		CharacterModelFrame.BackgroundBotRight:Hide()
		_G.CharacterModelFrameBackgroundOverlay:Hide()
		
		if CharacterModelFrame.backdrop then
			CharacterModelFrame.backdrop:Hide()
		end
	end
	
	-- Reputation
	hooksecurefunc("ExpandFactionHeader", UpdateReputationDetails)
	hooksecurefunc("CollapseFactionHeader", UpdateReputationDetails)
	hooksecurefunc("ReputationFrame_Update", UpdateReputationDetails)
end

S:AddCallback("KuiCharacter", styleCharacter)