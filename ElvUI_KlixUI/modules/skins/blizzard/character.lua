local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local r, g, b = T.unpack(E.media.rgbvaluecolor)

local function UpdateToken()
	local TokenFramePopup = _G.TokenFramePopup
	
	if TokenFramePopup.backdrop then
		if not TokenFramePopup.backdrop.styling then
			TokenFramePopup.backdrop:Styling()
			
			TokenFramePopup.backdrop.styling = true
		end
		
		TokenFramePopup:ClearAllPoints()
		TokenFramePopup:Point("TOPLEFT", _G.TokenFrame, "TOPRIGHT", 4, -1)
	end
end

local function UpdateReputationDetails()
	local ReputationDetailFrame = _G.ReputationDetailFrame
	
	if ReputationDetailFrame.backdrop then
		if not ReputationDetailFrame.backdrop.styling then
			ReputationDetailFrame.backdrop:Styling()

			ReputationDetailFrame.backdrop.styling = true
		end
		
		ReputationDetailFrame:ClearAllPoints()
		ReputationDetailFrame:Point("TOPLEFT", _G.ReputationFrame, "TOPRIGHT", 4, -1)
	end
end

local function styleCharacter()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.character ~= true or E.private.KlixUI.skins.blizzard.character ~= true then return end

	local CharacterFrame = _G.CharacterFrame
	local CharacterModelFrame = _G.CharacterModelFrame
	CharacterFrame:Styling()

	if CharacterModelFrame and CharacterModelFrame.BackgroundTopLeft and CharacterModelFrame.BackgroundTopLeft:IsShown() then
		CharacterModelFrame.BackgroundTopLeft:Hide()
		CharacterModelFrame.BackgroundTopRight:Hide()
		CharacterModelFrame.BackgroundBotLeft:Hide()
		CharacterModelFrame.BackgroundBotRight:Hide()
		if E.db.KlixUI.armory.backdrop.overlay then
            _G.CharacterModelFrameBackgroundOverlay:Show()
        else
            _G.CharacterModelFrameBackgroundOverlay:Hide()
        end
		
		if CharacterModelFrame.backdrop then
			CharacterModelFrame.backdrop:Hide()
		end
	end
	
	-- Reputation
	hooksecurefunc("ExpandFactionHeader", UpdateReputationDetails)
	hooksecurefunc("CollapseFactionHeader", UpdateReputationDetails)
	hooksecurefunc("ReputationFrame_Update", UpdateReputationDetails)
	
	if E.db.KlixUI.armory.naked then
		-- Undress Button
		local function Button_OnEnter(self)
			_G.GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 0, 4)
			_G.GameTooltip:ClearLines()
			_G.GameTooltip:AddLine(L["Instantly remove all your equipped gear."])
			_G.GameTooltip:Show()
		end

		local function Button_OnLeave(self)
			_G.GameTooltip:Hide()
		end
		
		local function UnequipItemInSlot(i)
			if T.InCombatLockdown() then return end
			local action = T.EquipmentManager_UnequipItemInSlot(i)
			T.EquipmentManager_RunAction(action)
		end

		local undress = T.CreateFrame("Button", KUI.Title.."UndressButton", _G.PaperDollFrame, "UIPanelButtonTemplate")
		undress:SetFrameStrata("HIGH")
		undress:SetSize(62, 20)
		if E.db.KlixUI.armory.azeritebtn then
			if T.IsAddOnLoaded("ElvUI_SLE") then
				undress:SetPoint("BOTTOMLEFT", _G.CharacterHeadSlot, "TOPLEFT", -1, 25)
			else
				undress:SetPoint("BOTTOMLEFT", _G.CharacterHeadSlot, "TOPLEFT", 0, 25)
			end
		else
			if T.IsAddOnLoaded("ElvUI_SLE") then
				undress:SetPoint("BOTTOMLEFT", _G.CharacterHeadSlot, "TOPLEFT", -1, 4)
			else
				undress:SetPoint("BOTTOMLEFT", _G.CharacterHeadSlot, "TOPLEFT", 0, 4)
			end
		end

		undress.text = KUI:CreateText(undress, "OVERLAY", 12, nil)
		undress.text:SetPoint("CENTER")
		undress.text:SetText(L["Naked"])

		undress:SetScript('OnEnter', Button_OnEnter)
		undress:SetScript('OnLeave', Button_OnLeave)
		undress:SetScript("OnClick", function()
			for i = 1, 17 do
				local texture = T.GetInventoryItemTexture('player', i)
				if texture then
					UnequipItemInSlot(i)
				end
			end
		end)
		S:HandleButton(undress)
	end
end

S:AddCallback("KuiCharacter", styleCharacter)