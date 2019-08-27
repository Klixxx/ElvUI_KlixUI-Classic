-------------------------------------------------------------------------------
-- Credits for Class Icons: ADDOriN @DevianArt
-- http://addorin.deviantart.com/gallery/43689290/World-of-Warcraft-Class-Logos
-------------------------------------------------------------------------------
local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KGM = KUI:NewModule("KuiGameMenu")
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local GameMenuFrame = _G.GameMenuFrame

local logo = "Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\KlixUILogo.tga"

function KGM:GameMenu()
	-- GameMenu Frame
	if not GameMenuFrame.KuibottomPanel then
		GameMenuFrame.KuibottomPanel = T.CreateFrame("Frame", nil, GameMenuFrame)
		local bottomPanel = GameMenuFrame.KuibottomPanel
		bottomPanel:SetFrameLevel(0)
		bottomPanel:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -E.Border)
		bottomPanel:SetWidth(T.GetScreenWidth() + (E.Border*2))
		KS:CreateBD(bottomPanel, .5)
		bottomPanel:Styling()

		bottomPanel.ignoreFrameTemplates = true
		bottomPanel.ignoreBackdropColors = true
		E["frames"][bottomPanel] = true

		bottomPanel.anim = CreateAnimationGroup(bottomPanel)
		bottomPanel.anim.height = bottomPanel.anim:CreateAnimation("Height")
		bottomPanel.anim.height:SetChange(T.GetScreenHeight() * (1 / 5))
		bottomPanel.anim.height:SetDuration(1.4)
		bottomPanel.anim.height:SetSmoothing("Bounce")

		bottomPanel:SetScript("OnShow", function(self)
			self:SetHeight(0)
			self.anim.height:Play()
		end)
		
		bottomPanel.Logo = bottomPanel:CreateTexture(nil, "ARTWORK")
		bottomPanel.Logo:SetSize(150, 150)
		bottomPanel.Logo:SetPoint("CENTER", bottomPanel, "CENTER", 0, 0)
		bottomPanel.Logo:SetTexture(logo)

		bottomPanel.Version = KUI:CreateText(bottomPanel, "OVERLAY", 18, "OUTLINE")
		bottomPanel.Version:SetText("v"..KUI.Version)
		bottomPanel.Version:SetPoint("TOP", bottomPanel.Logo, "BOTTOM")
		bottomPanel.Version:SetTextColor(T.unpack(E.media.rgbvaluecolor))
	end

	if not GameMenuFrame.KuitopPanel then
		GameMenuFrame.KuitopPanel = T.CreateFrame("Frame", nil, GameMenuFrame)
		local topPanel = GameMenuFrame.KuitopPanel
		topPanel:SetFrameLevel(0)
		topPanel:SetPoint("TOP", E.UIParent, "TOP", 0, 0)
		topPanel:SetWidth(T.GetScreenWidth() + (E.Border*2))
		KS:CreateBD(topPanel, .5)
		topPanel:Styling()

		topPanel.ignoreFrameTemplates = true
		topPanel.ignoreBackdropColors = true
		E["frames"][topPanel] = true

		topPanel.anim = CreateAnimationGroup(topPanel)
		topPanel.anim.height = topPanel.anim:CreateAnimation("Height")
		topPanel.anim.height:SetChange(T.GetScreenHeight() * (1 / 5))
		topPanel.anim.height:SetDuration(1.4)
		topPanel.anim.height:SetSmoothing("Bounce")

		topPanel:SetScript("OnShow", function(self)
			self:SetHeight(0)
			self.anim.height:Play()
		end)

		topPanel.factionLogo = topPanel:CreateTexture(nil, "ARTWORK")
		topPanel.factionLogo:SetPoint("CENTER", topPanel, "CENTER", 0, 0)
		topPanel.factionLogo:SetSize(156, 150)
		topPanel.factionLogo:SetTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\classIcons\\CLASS-"..E.myclass)
	end
end

function KGM:Initialize()
	if E.db.KlixUI.general.GameMenuScreen then
		self:GameMenu()
		E:UpdateBorderColors()
	end
end

local function InitializeCallback()
	KGM:Initialize()
end

KUI:RegisterModule(KGM:GetName(), InitializeCallback)
