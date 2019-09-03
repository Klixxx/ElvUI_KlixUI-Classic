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

local function ResizeCharacterFrame()
	if _G["PaperDollFrame"]:IsShown() then
		_G["CharacterFrame"]:SetWidth(415)
		_G["CharacterFrame"]:SetHeight(530)

		_G.CharacterHandsSlot:ClearAllPoints()
		_G.CharacterHandsSlot:SetPoint("TOPRIGHT", _G.CharacterFrame.backdrop, "TOPRIGHT", -10, -62)
		
		_G.CharacterMainHandSlot:ClearAllPoints()
		_G.CharacterMainHandSlot:SetPoint("BOTTOMLEFT", _G.CharacterFrame.backdrop, "BOTTOMLEFT", 125, 10)
		
		_G.CharacterModelFrame:SetSize(250, 250)
		_G.CharacterModelFrame:ClearAllPoints()
		_G.CharacterModelFrame:SetPoint("CENTER", _G.CharacterFrame.backdrop, "CENTER", 0, 30)
		
		_G.CharacterModelFrameRotateLeftButton:ClearAllPoints()
		_G.CharacterModelFrameRotateLeftButton:SetPoint("TOPLEFT", _G.CharacterHeadSlot, "TOPRIGHT", 10, 0)
		
		_G.CharacterAttributesFrame:ClearAllPoints()
		_G.CharacterAttributesFrame:SetPoint("CENTER", _G.CharacterFrame.backdrop, "CENTER", 0, -120)
		
		_G.CharacterNameFrame:ClearAllPoints()
		_G.CharacterNameFrame:SetPoint("TOP", _G.CharacterFrame.backdrop, "TOP", 0, -10)
		
		_G.MagicResFrame1:ClearAllPoints()
		_G.MagicResFrame1:SetPoint("TOPRIGHT", _G.CharacterHandsSlot, "TOPLEFT", -10, 0)
	end
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
	
	ResizeCharacterFrame()
	
	-- Reputation
	hooksecurefunc("ExpandFactionHeader", UpdateReputationDetails)
	hooksecurefunc("CollapseFactionHeader", UpdateReputationDetails)
	hooksecurefunc("ReputationFrame_Update", UpdateReputationDetails)
end

S:AddCallback("KuiCharacter", styleCharacter)