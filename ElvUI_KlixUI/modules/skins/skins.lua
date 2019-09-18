-------------------------------------------------------------------------------
-- Credits: Ray, Merathilis
-------------------------------------------------------------------------------
local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:NewModule("KuiSkins", "AceHook-3.0", "AceEvent-3.0")
local S = E:GetModule("Skins")
local LSM = E.LSM or E.Libs.LSM

local alpha
local backdropcolorr, backdropcolorg, backdropcolorb
local backdropfadecolorr, backdropfadecolorg, backdropfadecolorb
local unitFrameColorR, unitFrameColorG, unitFrameColorB
local rgbValueColorR, rgbValueColorG, rgbValueColorB
local bordercolorr, bordercolorg, bordercolorb

local r, g, b = T.unpack(E.media.rgbvaluecolor)

KUI_NORMAL_QUEST_DISPLAY = "|cffffffff%s|r"
KUI_TRIVIAL_QUEST_DISPLAY = TRIVIAL_QUEST_DISPLAY:gsub("000000", "ffffff")

local buttons = {
	"UI-Panel-MinimizeButton-Disabled",
	"UI-Panel-MinimizeButton-Up",
	"UI-Panel-SmallerButton-Up",
	"UI-Panel-BiggerButton-Up",
}

KS.ArrowRotation = {
	['UP'] = 3.14,
	['DOWN'] = 0,
	['LEFT'] = -1.57,
	['RIGHT'] = 1.57,
}

KS.BlizzardRegions = {
	'Left',
	'Middle',
	'Right',
	'Mid',
	'LeftDisabled',
	'MiddleDisabled',
	'RightDisabled',
	'TopLeft',
	'TopRight',
	'BottomLeft',
	'BottomRight',
	'TopMiddle',
	'MiddleLeft',
	'MiddleRight',
	'BottomMiddle',
	'MiddleMiddle',
	'TabSpacer',
	'TabSpacer1',
	'TabSpacer2',
	'_RightSeparator',
	'_LeftSeparator',
	'Cover',
	'Border',
	'Background',
}

-- Underlines
function KS:Underline(frame, shadow, height)
	local line = T.CreateFrame("Frame", nil, frame)
	if line then
		line:SetPoint("BOTTOM", frame, -1, 1)
		line:SetSize(frame:GetWidth(), height or 1)
		line.Texture = line:CreateTexture(nil, "OVERLAY")
		line.Texture:SetTexture([[Interface\AddOns\ElvUI_KlixUI\media\textures\Klix]])
		line.Texture:SetVertexColor(r, g, b)
		if shadow then
			if shadow == "backdrop" then
				line:CreateShadow()
			else
				line:CreateBackdrop()
			end
		end
		line.Texture:SetAllPoints(line)
	end
	return line
end

-- Create shadow for textures
function KS:CreateSD(parent, size, r, g, b, alpha, offset)
	local sd = T.CreateFrame("Frame", nil, parent)
	sd.size = size or 5
	sd.offset = offset or 0
	sd:SetBackdrop({
		bgFile =  LSM:Fetch("background", "ElvUI Blank"),
		edgeFile = LSM:Fetch("border", "ElvUI GlowBorder"),
		edgeSize = sd.size,
	})
	sd:SetPoint("TOPLEFT", parent, -sd.size - 1 - sd.offset, sd.size + 1 + sd.offset)
	sd:SetPoint("BOTTOMRIGHT", parent, sd.size + 1 + sd.offset, -sd.size - 1 - sd.offset)
	sd:SetBackdropBorderColor(r or 0, g or 0, b or 0)
	sd:SetBackdropColor(r or 0, g or 0, b or 0, alpha or 0)

	return sd
end

function KS:CreateBG(frame)
	T.assert(frame, "doesn't exist!")

	local f = frame
	if frame:IsObjectType('Texture') then f = frame:GetParent() end

	local bg = f:CreateTexture(nil, "BACKGROUND")
	bg:Point("TOPLEFT", frame, -E.mult, E.mult)
	bg:Point("BOTTOMRIGHT", frame, E.mult, -E.mult)
	bg:SetTexture(E.media.blankTex)
	bg:SetSnapToPixelGrid(false)
	bg:SetTexelSnappingBias(0)
	bg:SetVertexColor(0, 0, 0)

	return bg
end

-- frame text
function KS:CreateFS(f, size, text, classcolor, anchor, x, y)
	local fs = f:CreateFontString(nil, "OVERLAY")
	fs:FontTemplate(nil, nil, 'OUTLINE')
	fs:SetText(text)
	fs:SetWordWrap(false)
	if classcolor then
		fs:SetTextColor(r, g, b)
	end
	if (anchor and x and y) then
		fs:SetPoint(anchor, x, y)
	else
		fs:SetPoint("CENTER", 1, 0)
	end
	return fs
end

-- Gradient Frame
function KS:CreateGF(f, w, h, o, r, g, b, a1, a2)
	T.assert(f, "doesn't exist!")

	f:SetSize(w, h)
	f:SetFrameStrata("BACKGROUND")
	local gf = f:CreateTexture(nil, "BACKGROUND")
	gf:ClearAllPoints()
	gf:SetPoint("TOPLEFT", f, -E.mult, E.mult)
	gf:SetPoint("BOTTOMRIGHT", f, E.mult, -E.mult)
	gf:SetTexture(E["media"].normTex)
	gf:SetVertexColor(r, g, b)
	gf:SetSnapToPixelGrid(false)
	gf:SetTexelSnappingBias(0)
	gf:SetGradientAlpha(o, r, g, b, a1, r, g, b, a2)
end

-- Gradient Texture
function KS:CreateGradient(f)
	T.assert(f, "doesn't exist!")
	
	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:ClearAllPoints()
	tex:SetPoint("TOPLEFT", 1, -1)
	tex:SetPoint("BOTTOMRIGHT", -1, 1)
	tex:SetTexture([[Interface\AddOns\ElvUI_KlixUI\media\textures\gradient.tga]])
	tex:SetVertexColor(.3, .3, .3, .15)
	tex:SetSnapToPixelGrid(false)
	tex:SetTexelSnappingBias(0)

	return tex
end

function KS:CreateBackdrop(frame)
	if frame.backdrop then return end

	local parent = frame.IsObjectType and frame:IsObjectType("Texture") and frame:GetParent() or frame

	local backdrop = T.CreateFrame("Frame", nil, parent)
	backdrop:SetOutside(frame)
	backdrop:SetTemplate("Transparent")

	if (parent:GetFrameLevel() - 1) >= 0 then
		backdrop:SetFrameLevel(parent:GetFrameLevel() - 1)
	else
		backdrop:SetFrameLevel(0)
	end

	frame.backdrop = backdrop
end

function KS:CreateBDFrame(f, a, left, right, top, bottom)
	T.assert(f, "doesn't exist!")
	
	local frame
	if f:GetObjectType() == "Texture" then
		frame = f:GetParent()
	else
		frame = f
	end

	local lvl = frame:GetFrameLevel()

	local bg = T.CreateFrame("Frame", nil, frame)
	bg:SetPoint("TOPLEFT", f, left or -1, top or 1)
	bg:SetPoint("BOTTOMRIGHT", f, right or 1, bottom or -1)
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)

	KS:CreateBD(bg, a or .5)

	return bg
end

function KS:CreateBD(f, a)
	T.assert(f, "doesn't exist!")

	f:SetBackdrop({
		bgFile = E["media"].normTex,
		edgeFile = E["media"].normTex,
		edgeSize = E.mult*1.1, -- latest Pixel Stuff changes 10.02.2019
		insets = {left = 0, right = 0, top = 0, bottom = 0},
	})

	f:SetBackdropColor(E.media.backdropfadecolor.r, E.media.backdropfadecolor.g, E.media.backdropfadecolor.b, a or alpha)
	f:SetBackdropBorderColor(T.unpack(E.media.bordercolor))
end

function KS:SetBD(x, y, x2, y2)
	local bg = T.CreateFrame("Frame", nil, self)
	if not x then
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT")
	else
		bg:SetPoint("TOPLEFT", x, y)
		bg:SetPoint("BOTTOMRIGHT", x2, y2)
	end
	bg:SetFrameLevel(self:GetFrameLevel() - 1)
	KS:CreateBD(bg)
	KS:CreateSD(bg)
end

function KS:SkinBackdropFrame(frame, template, override, kill, setpoints)
	if not override then KS:StripTextures(frame, kill) end
	KS:CreateBackdrop(frame, template)
	if setpoints then
		frame.Backdrop:SetAllPoints()
	end
end

function KS:StripTextures(Object, Kill, Alpha)
	for i = 1, Object:GetNumRegions() do
		local Region = T.select(i, Object:GetRegions())
		if Region and Region:GetObjectType() == "Texture" then
			if Kill then
				Region:Hide()
				Region.Show = KUI.dummy
			elseif Alpha then
				Region:SetAlpha(0)
			else
				Region:SetTexture(nil)
			end
		end
	end
end

-- ClassColored ScrollBars
local function GrabScrollBarElement(frame, element)
	local FrameName = frame:GetDebugName()
	return frame[element] or FrameName and (_G[FrameName..element] or T.string_find(FrameName, element)) or nil
end

function KS:ReskinScrollBar(frame, thumbTrimY, thumbTrimX)
	local parent = frame:GetParent()

	local Thumb = GrabScrollBarElement(frame, 'ThumbTexture') or GrabScrollBarElement(frame, 'thumbTexture') or frame.GetThumbTexture and frame:GetThumbTexture()

	if Thumb and Thumb.backdrop then
		Thumb.backdrop:SetBackdropColor(T.unpack(E.media.rgbvaluecolor))
	end
end

function KS:ReskinScrollSlider(Slider, thumbTrim)
	local parent = Slider:GetParent()
	
	if Slider.trackbg and Slider.trackbg.SetTemplate then
		Slider.trackbg:SetTemplate("Transparent", true, true)
	end
	
	if Slider.thumbbg then
		Slider.thumbbg.backdropTexture.SetVertexColor = nil
		Slider.thumbbg.backdropTexture:SetVertexColor(rgbValueColorR, rgbValueColorG, rgbValueColorB)
		Slider.thumbbg.backdropTexture.SetVertexColor = E.noop
	end
end

-- Overwrite ElvUI Tabs function to be transparent
function KS:ReskinTab(tab)
	if not tab then return end

	if tab.backdrop then
		tab.backdrop:SetTemplate("Transparent")
		tab.backdrop:Styling()
	end
end

function KS:ColorButton()
	if self.backdrop then self = self.backdrop end

	self:SetBackdropColor(r, g, b, .3)
	self:SetBackdropBorderColor(r, g, b)
end

function KS:ClearButton()
	if self.backdrop then self = self.backdrop end

	self:SetBackdropColor(0, 0, 0, 0)

	if self.isUnitFrameElement then
		self:SetBackdropBorderColor(T.unpack(E.media.unitframeBorderColor))
	else
		self:SetBackdropBorderColor(bordercolorr, bordercolorg, bordercolorb)
	end
end

function KS:SkinFrame(frame, template, override, kill)
	if not template then template = "Transparent" end
	if not override then KS:StripTextures(frame, kill) end
	KS:SetTemplate(frame, template)
end

local function StartGlow(f)
	if not f:IsEnabled() then return end
	f:SetBackdropBorderColor(r, g ,b)
	f.glow:SetAlpha(1)
	KUI:CreatePulse(f.glow)
end

local function StopGlow(f)
	f.glow:SetScript("OnUpdate", nil)
	f:SetBackdropBorderColor(bordercolorr, bordercolorg, bordercolorb)
	f.glow:SetAlpha(0)
end

-- Buttons
function KS:Reskin(button, strip, noGlow)
	T.assert(button, "doesn't exist!")

	if strip then button:StripTextures() end

	if button.template then
		button:SetTemplate("Transparent", true)
	end

	KS:CreateGradient(button)
	
	if button.Icon then
		local Texture = button.Icon:GetTexture()
		if Texture and T.string_find(Texture, [[Interface\ChatFrame\ChatFrameExpandArrow]]) then
			button.Icon:SetTexture([[Interface\AddOns\ElvUI_KlixUI\media\textures\Arrow]])
			button.Icon:SetVertexColor(1, 1, 1)
			button.Icon:SetRotation(KS.ArrowRotation['RIGHT'])
		end
	end
	
	if not noGlow then
		button.glow = T.CreateFrame("Frame", nil, button)
		button.glow:SetBackdrop({
			edgeFile = LSM:Fetch("statusbar", "Klix"), edgeSize = E:Scale(2),
			insets = {left = E:Scale(2), right = E:Scale(2), top = E:Scale(2), bottom = E:Scale(2)},
		})
		button.glow:SetPoint("TOPLEFT", -1, 1)
		button.glow:SetPoint("BOTTOMRIGHT", 1, -1)
		button.glow:SetBackdropBorderColor(r, g, b)
		button.glow:SetAlpha(0)

		button:HookScript("OnEnter", StartGlow)
		button:HookScript("OnLeave", StopGlow)
	end
end

function KS:ReskinCheckBox(frame, noBackdrop, noReplaceTextures)
	assert(frame, "does not exist.")

	frame:StripTextures()

	if noBackdrop then
		frame:SetTemplate("Default")
		frame:Size(16)
	else
		KS:CreateBackdrop(frame)
		frame.backdrop:SetInside(nil, 4, 4)
	end

	if not noReplaceTextures then
		if frame.SetCheckedTexture then
			frame:SetCheckedTexture(LSM:Fetch("statusbar", "Klix"))
			frame:GetCheckedTexture():SetVertexColor(r, g, b)
			frame:GetCheckedTexture():SetInside(frame.backdrop)
		end

		if frame.SetDisabledTexture then
			frame:SetDisabledTexture(LSM:Fetch("statusbar", "Klix"))
			frame:GetDisabledTexture():SetVertexColor(r, g, b, 0.5)
			frame:GetDisabledTexture():SetInside(frame.backdrop)
		end

		frame:HookScript('OnDisable', function(checkbox)
			if not checkbox.SetDisabledTexture then return; end
			if checkbox:GetChecked() then
				checkbox:SetDisabledTexture(LSM:Fetch("statusbar", "Klix"))
				checkbox:GetDisabledTexture():SetVertexColor(r, g, b, 0.5)
				checkbox:GetDisabledTexture():SetInside(frame.backdrop)
			else
				checkbox:SetDisabledTexture("")
			end
		end)
	end
end

function KS:StyleButton(button)
	if button.isStyled then return end

	if button.SetHighlightTexture then
		button:SetHighlightTexture(E.media.blankTex)
		button:GetHighlightTexture():SetVertexColor(1, 1, 1, .2)
		button:GetHighlightTexture():SetInside()
		button.SetHighlightTexture = E.noop
	end

	if button.SetPushedTexture then
		button:SetPushedTexture(E["media"].blankTex)
		button:GetPushedTexture():SetVertexColor(.9, .8, .1, .5)
		button:GetPushedTexture():SetInside()
		button.SetPushedTexture = E.noop
	end

	if button.GetCheckedTexture then
		button:SetPushedTexture(E["media"].blankTex)
		button:GetCheckedTexture():SetVertexColor(0, 1, 0, .5)
		button:GetCheckedTexture():SetInside()
		button.GetCheckedTexture = E.noop
	end

	local Cooldown = button:GetName() and _G[button:GetName()..'Cooldown'] or button.Cooldown or button.cooldown or nil

	if Cooldown then
		Cooldown:SetInside()
		if Cooldown.SetSwipeColor then
			Cooldown:SetSwipeColor(0, 0, 0, 1)
		end
	end

	button.isStyled = true
end

function KS:ReskinIcon(icon, backdrop)
	T.assert(icon, "doesn't exist!")

	icon:SetTexCoord(T.unpack(E.TexCoords))
	icon:SetSnapToPixelGrid(false)
	icon:SetTexelSnappingBias(0)
	if backdrop then
		KS:CreateBackdrop(icon)
	end
end

function KS:ReskinItemFrame(frame)
	T.assert(frame, "doesn't exist!")

	local icon = frame.Icon
	frame._KuiIconBorder = KS:ReskinIcon(icon)

	local nameFrame = frame.NameFrame
	nameFrame:SetAlpha(0)

	local bg = T.CreateFrame("Frame", nil, frame)
	bg:SetPoint("TOP", icon, 0, 1)
	bg:SetPoint("BOTTOM", icon, 0, -1)
	bg:SetPoint("LEFT", icon, "RIGHT", 2, 0)
	bg:SetPoint("RIGHT", nameFrame, -4, 0)
	KS:CreateBD(bg, .2)
	frame._KuiNameBG = bg
end

function KS:ItemButtonTemplate(button)
	T.assert(button, "doesn't exist!")

	button:SetNormalTexture("")
	button:SetHighlightTexture("")
	button:SetPushedTexture("")
	button._KuiIconBorder = KS:ReskinIcon(button.icon)
end

function KS:SimplePopupButtonTemplate(checkbutton)
	T.select(2, checkbutton:GetRegions()):Hide()
end

function KS:PopupButtonTemplate(checkbutton)
	KS:SimplePopupButtonTemplate(checkbutton)
end

function KS:LargeItemButtonTemplate(button)
	T.assert(button, "doesn't exist!")

	local iconBG = T.CreateFrame("Frame", nil, button)
	iconBG:SetFrameLevel(button:GetFrameLevel() - 1)
	iconBG:SetPoint("TOPLEFT", button.Icon, -1, 1)
	iconBG:SetPoint("BOTTOMRIGHT", button.Icon, 1, -1)
	button._KuiIconBorder = iconBG

	button.NameFrame:SetAlpha(0)

	local nameBG = T.CreateFrame("Frame", nil, button)
	nameBG:SetPoint("TOPLEFT", iconBG, "TOPRIGHT", 1, 0)
	nameBG:SetPoint("BOTTOMRIGHT", -3, 1)
	KS:CreateBD(nameBG, .2)
	button._KuiNameBG = nameBG
end

function KS:SmallItemButtonTemplate(button)
	T.assert(button, "doesn't exist!")

	button.Icon:SetSize(29, 29)

	local iconBG = T.CreateFrame("Frame", nil, button)
	iconBG:SetFrameLevel(button:GetFrameLevel() - 1)
	iconBG:SetPoint("TOPLEFT", button.Icon, -1, 1)
	iconBG:SetPoint("BOTTOMRIGHT", button.Icon, 1, -1)
	button._KuiIconBorder = iconBG

	button.NameFrame:SetAlpha(0)

	local nameBG = T.CreateFrame("Frame", nil, button)
	nameBG:SetPoint("TOPLEFT", iconBG, "TOPRIGHT", 1, 0)
	nameBG:SetPoint("BOTTOMRIGHT", button.NameFrame, 0, -1)
	KS:CreateBD(nameBG, .2)
	button._KuiINameBG = nameBG
end

function KS:SkinPanel(panel)
	panel.tex = panel:CreateTexture(nil, "ARTWORK")
	panel.tex:SetAllPoints()
	panel.tex:SetTexture(E.media.Klix)
	panel.tex:SetGradient("VERTICAL", T.unpack(E.media.rgbvaluecolor))
	panel.tex:SetSnapToPixelGrid(false)
	panel.tex:SetTexelSnappingBias(0)
	KS:CreateSD(panel, 2, 0, 0, 0, 0, -1)
end

function KS:ReskinGarrisonPortrait(self)
	self.Portrait:ClearAllPoints()
	self.Portrait:SetPoint("TOPLEFT", 4, -4)
	self.PortraitRing:Hide()
	self.PortraitRingQuality:SetTexture("")
	if self.Highlight then self.Highlight:Hide() end

	self.LevelBorder:SetScale(.0001)
	self.Level:ClearAllPoints()
	self.Level:SetPoint("BOTTOM", self, 0, 12)

	self.squareBG = KS:CreateBDFrame(self, 1)
	self.squareBG:SetFrameLevel(self:GetFrameLevel())
	self.squareBG:SetPoint("TOPLEFT", 3, -3)
	self.squareBG:SetPoint("BOTTOMRIGHT", -3, 11)

	if self.PortraitRingCover then
		self.PortraitRingCover:SetColorTexture(0, 0, 0)
		self.PortraitRingCover:SetAllPoints(self.squareBG)
	end

	if self.Empty then
		self.Empty:SetColorTexture(0, 0, 0)
		self.Empty:SetAllPoints(self.Portrait)
	end
end

-- Copied from ElvUI to change the icon shadow
function KS:ReskinIconSelectionFrame(frame, numIcons, buttonNameTemplate, frameNameOverride)
	assert(frame, "ReskinIconSelectionFrame: frame argument missing")
	assert(numIcons and type(numIcons) == "number", "ReskinIconSelectionFrame: numIcons argument missing or not a number")
	assert(buttonNameTemplate and type(buttonNameTemplate) == "string", "ReskinIconSelectionFrame: buttonNameTemplate argument missing or not a string")

	frame:Styling()

	for i = 1, numIcons do
		local button = _G[buttonNameTemplate..i]
		if button then
			button:CreateIconShadow()
		end
	end
end

local buttons = {
	"ElvUIMoverNudgeWindowUpButton",
	"ElvUIMoverNudgeWindowDownButton",
	"ElvUIMoverNudgeWindowLeftButton",
	"ElvUIMoverNudgeWindowRightButton",
}

local function replaceConfigArrows(button)
	-- remove the default icons
	local tex = _G[button:GetName().."Icon"]
	if tex then
		tex:SetTexture(nil)
	end

	-- add the new icon
	if not button.img then
		button.img = button:CreateTexture(nil, 'ARTWORK')
		button.img:SetTexture('Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\arrow')
		button.img:SetSize(12, 12)
		button.img:Point('CENTER')
		button.img:SetVertexColor(1, 1, 1)
		button.img:SetSnapToPixelGrid(false)
		button.img:SetTexelSnappingBias(0)

		button:HookScript('OnMouseDown', function(btn)
			if btn:IsEnabled() then
				btn.img:Point("CENTER", -1, -1);
			end
		end)

		button:HookScript('OnMouseUp', function(btn)
			btn.img:Point("CENTER", 0, 0);
		end)
	end
end

function KS:ApplyConfigArrows()
	for _, btn in T.pairs(buttons) do
		replaceConfigArrows(_G[btn])
	end

	-- Apply the rotation
	_G["ElvUIMoverNudgeWindowUpButton"].img:SetRotation(KS.ArrowRotation['UP'])
	_G["ElvUIMoverNudgeWindowDownButton"].img:SetRotation(KS.ArrowRotation['DOWN'])
	_G["ElvUIMoverNudgeWindowLeftButton"].img:SetRotation(KS.ArrowRotation['LEFT'])
	_G["ElvUIMoverNudgeWindowRightButton"].img:SetRotation(KS.ArrowRotation['RIGHT'])

end
hooksecurefunc(E, "CreateMoverPopup", KS.ApplyConfigArrows)

function KS:ReskinAS(AS)
	-- Reskin AddOnSkins
	function AS:SkinTab(Tab, Strip)
		if Tab.isSkinned then return end
		local TabName = Tab:GetName()

		if TabName then
			for _, Region in T.pairs(KS.BlizzardRegions) do
				if _G[TabName..Region] then
					_G[TabName..Region]:SetTexture(nil)
				end
			end
		end

		for _, Region in T.pairs(KS.BlizzardRegions) do
			if Tab[Region] then
				Tab[Region]:SetAlpha(0)
			end
		end

		if Tab.GetHighlightTexture and Tab:GetHighlightTexture() then
			Tab:GetHighlightTexture():SetTexture(nil)
		else
			Strip = true
		end

		if Strip then
			AS:StripTextures(Tab)
		end

		AS:CreateBackdrop(Tab)

		if AS:CheckAddOn("ElvUI") and AS:CheckOption("ElvUISkinModule") then
			-- Check if ElvUI already provides the backdrop. Otherwise we have two backdrops (e.g. Auctionhouse)
			if Tab.backdrop then
				Tab.Backdrop:Hide()
			else
				AS:SetTemplate(Tab.Backdrop, "Transparent") -- Set it to transparent
				Tab.Backdrop:Styling()
			end
		end

		Tab.Backdrop:Point("TOPLEFT", 10, AS.PixelPerfect and -1 or -3)
		Tab.Backdrop:Point("BOTTOMRIGHT", -10, 3)

		Tab.isSkinned = true
	end
end

-- Replace the Recap button script re-set function
function S:UpdateRecapButton()
	if self and self.button4 and self.button4:IsEnabled() then
		self.button4:SetScript("OnEnter", KS.ColorButton)
		self.button4:SetScript("OnLeave", KS.ClearButton)
	end
end

--[[ HOOK TO THE UIWIDGET TYPES ]]
function KS:ReskinSkinTextWithStateWidget(widgetFrame)
	local text = widgetFrame.Text;
	if text then
		text:SetTextColor(1, 1, 1)
	end
end

-- hook the skin functions
hooksecurefunc(S, "HandleTab", KS.ReskinTab)
hooksecurefunc(S, "HandleButton", KS.Reskin)
hooksecurefunc(S, "HandleCheckBox", KS.ReskinCheckBox)
hooksecurefunc(S, "HandleScrollBar", KS.ReskinScrollBar)
-- New Widget Types
hooksecurefunc(S, "SkinTextWithStateWidget", KS.ReskinSkinTextWithStateWidget)

local function ReskinVehicleExit()
	if not E.private.KlixUI.skins.vehicleButton then return end
	local f = _G["LeaveVehicleButton"]
	if f then
		f:SetNormalTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\arrow")
		f:SetPushedTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\arrow")
		f:SetHighlightTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\arrow")
	end
end

-- keep the colors updated
local function updateMedia()
	rgbValueColorR, rgbValueColorG, rgbValueColorB = T.unpack(E.media.rgbvaluecolor)
	unitFrameColorR, unitFrameColorG, unitFrameColorB = T.unpack(E.media.unitframeBorderColor)
	backdropfadecolorr, backdropfadecolorg, backdropfadecolorb, alpha = T.unpack(E.media.backdropfadecolor)
	backdropcolorr, backdropcolorg, backdropcolorb = T.unpack(E.media.backdropcolor)
	bordercolorr, bordercolorg, bordercolorb = T.unpack(E.media.bordercolor)
end
hooksecurefunc(E, "UpdateMedia", updateMedia)

------------------ SharedXML -----------------
--[[ SharedXML\HybridScrollFrame.xml ]]
function KS:HybridScrollBarTemplate(Slider)
	local parent = Slider:GetParent()
	Slider:SetPoint("TOPLEFT", parent, "TOPRIGHT", 0, -17)
	Slider:SetPoint("BOTTOMLEFT", parent, "BOTTOMRIGHT", 0, 17)

	Slider.trackBG:SetAlpha(0)

	Slider.ScrollBarTop:Hide()
	Slider.ScrollBarMiddle:Hide()
	Slider.ScrollBarBottom:Hide()

	parent.scrollUp:SetPoint("BOTTOM", Slider, "TOP")
	KS:UIPanelScrollUpButtonTemplate(parent.scrollUp)

	parent.scrollDown:SetPoint("TOP", Slider, "BOTTOM")
	KS:UIPanelScrollDownButtonTemplate(parent.scrollDown)

	Slider.thumbTexture:SetAlpha(0)
	Slider.thumbTexture:SetSize(17, 24)

	local thumb = T.CreateFrame("Frame", nil, Slider)
	thumb:SetPoint("TOPLEFT", Slider.thumbTexture, 0, -2)
	thumb:SetPoint("BOTTOMRIGHT", Slider.thumbTexture, 0, 2)
	Slider._KuiThumb = thumb

	Slider:SetSize(Slider:GetSize())
end

--[[ SharedXML\SecureUIPanelTemplate.xml ]]
function KS:UIPanelScrollBarButton(Button)
	Button:SetSize(17, 17)
	Button:SetNormalTexture("")
	Button:SetPushedTexture("")
	Button:SetHighlightTexture("")
end

function KS:UIPanelScrollUpButtonTemplate(Button)
	KS:UIPanelScrollBarButton(Button)

	local arrow = Button:CreateTexture(nil, "ARTWORK")
	arrow:SetPoint("TOPLEFT", 4, -6)
	arrow:SetPoint("BOTTOMRIGHT", -5, 7)

	Button._KuiHighlight = {arrow}
end

function KS:UIPanelScrollDownButtonTemplate(Button)
	KS:UIPanelScrollBarButton(Button)

	local arrow = Button:CreateTexture(nil, "ARTWORK")
	arrow:SetPoint("TOPLEFT", 4, -7)
	arrow:SetPoint("BOTTOMRIGHT", -5, 6)

	Button._KuiHighlight = {arrow}
end

function KS:UIPanelScrollBarTemplate(Slider)
	KS:UIPanelScrollUpButtonTemplate(Slider.ScrollUpButton)
	KS:UIPanelScrollDownButtonTemplate(Slider.ScrollDownButton)

	Slider.ThumbTexture:SetAlpha(0)
	Slider.ThumbTexture:SetSize(17, 24)

	local thumb = T.CreateFrame("Frame", nil, Slider)
	thumb:SetPoint("TOPLEFT", Slider.ThumbTexture, 0, -2)
	thumb:SetPoint("BOTTOMRIGHT", Slider.ThumbTexture, 0, 2)
	Slider._KuiThumb = thumb

	Slider:SetWidth(Slider:GetWidth())
end

function KS:NumericInputSpinnerTemplate(EditBox)
	EditBox:DisableDrawLayer("BACKGROUND")
end

function KS:UIPanelStretchableArtScrollBarTemplate(Slider)
	KS:UIPanelScrollBarTemplate(Slider)

	Slider.Top:Hide()
	Slider.Bottom:Hide()
	Slider.Middle:Hide()

	Slider.Background:Hide()
end

function KS:PortraitFrameTemplateNoCloseButton(Frame)
	local name = Frame:GetName()

	Frame.Bg:Hide()
	_G[name.."TitleBg"]:Hide()
	Frame.portrait:SetAlpha(0)
	Frame.PortraitFrame:SetTexture("")
	Frame.TopRightCorner:Hide()
	Frame.TopLeftCorner:SetTexture("")
	Frame.TopBorder:SetTexture("")

	Frame.TopTileStreaks:SetTexture("")
	Frame.BotLeftCorner:Hide()
	Frame.BotRightCorner:Hide()
	Frame.BottomBorder:Hide()
	Frame.LeftBorder:Hide()
	Frame.RightBorder:Hide()

	Frame:SetSize(Frame:GetSize())
end

function KS:PortraitFrameTemplate(Frame)
	KS:PortraitFrameTemplateNoCloseButton(Frame)
	Frame.CloseButton:SetPoint("TOPRIGHT", -5, -5)
end

--[[function KS:InsetFrameTemplate(Frame)
	Frame.Bg:Hide()

	Frame.InsetBorderTopLeft:Hide()
	Frame.InsetBorderTopRight:Hide()

	Frame.InsetBorderBottomLeft:Hide()
	Frame.InsetBorderBottomRight:Hide()

	Frame.InsetBorderTop:Hide()
	Frame.InsetBorderBottom:Hide()
	Frame.InsetBorderLeft:Hide()
	Frame.InsetBorderRight:Hide()
end]]

function KS:ButtonFrameTemplate(Frame)
	KS:PortraitFrameTemplate(Frame)
	local name = Frame:GetName()

	_G[name.."BtnCornerLeft"]:SetTexture("")
	_G[name.."BtnCornerRight"]:SetTexture("")
	_G[name.."ButtonBottomBorder"]:SetTexture("")
	--KS:InsetFrameTemplate(Frame.Inset)

	--[[ Scale ]]--
	Frame.Inset:SetPoint("TOPLEFT", 4, -60)
	Frame.Inset:SetPoint("BOTTOMRIGHT", -6, 26)
end

------------------------------------------------------------

-------------------- ItemButtonTemplate --------------------

do --[[ FrameXML\ItemButtonTemplate.lua ]]
	local size = 6
	local vertexOffsets = {
		{"TOPLEFT", 4, -size},
		{"BOTTOMLEFT", 3, -size},
		{"TOPRIGHT", 2, size},
		{"BOTTOMRIGHT", 1, size},
	}

	local function SetRelic(button, isRelic, color)
		if isRelic then
			if not button._auroraRelicTex then
				local relic = CreateFrame("Frame", nil, button)
				relic:SetAllPoints(button._auroraIconBorder)

				for i = 1, 4 do
					local tex = relic:CreateTexture(nil, "OVERLAY")
					tex:SetSize(size, size)

					local vertexInfo = vertexOffsets[i]
					tex:SetPoint(vertexInfo[1])
					tex:SetVertexOffset(vertexInfo[2], vertexInfo[3], 0)
					relic[i] = tex
				end

				button._auroraRelicTex = relic
			end

			for i = 1, #button._auroraRelicTex do
				local tex = button._auroraRelicTex[i]
				tex:SetColorTexture(color.r, color.g, color.b)
			end
			button._auroraRelicTex:Show()
		elseif button._auroraRelicTex then
			button._auroraRelicTex:Hide()
		end
	end

	function KS.SetItemButtonQuality(button, quality, itemIDOrLink)
		if button._auroraIconBorder then
			local isRelic = (itemIDOrLink and T.IsArtifactRelicItem(itemIDOrLink))

			if quality then
				local color = T.type(quality) == "table" and quality or _G.BAG_ITEM_QUALITY_COLORS[quality]
				if color and color == quality or quality >= _G.LE_ITEM_QUALITY_COMMON then
					SetRelic(button, isRelic, color)
					button._auroraIconBorder:SetBackdropBorderColor(color.r, color.g, color.b)
					button.IconBorder:Hide()
				else
					SetRelic(button, false)
					button._auroraIconBorder:SetBackdropBorderColor(0, 0, 0)
				end
			else
				SetRelic(button, false)
				button._auroraIconBorder:SetBackdropBorderColor(0, 0, 0)
			end
		end
	end
end
hooksecurefunc("SetItemButtonQuality", KS.SetItemButtonQuality)

------------------------------------------------------------

local function pluginInstaller()
	local PluginInstallFrame = _G["PluginInstallFrame"]
	if PluginInstallFrame then
		PluginInstallFrame:Styling()
		PluginInstallTitleFrame:Styling()
		PluginInstallStatus.backdrop:Styling()
	end
end

local function styleAddons()
	-- AddOnSkins
	if T.IsAddOnLoaded('AddOnSkins') then
		if _G.AddOnSkins_ChangeLog and not _G.AddOnSkins_ChangeLog.IsStyled then
			_G.AddOnSkins_ChangeLog:Styling()
			_G.AddOnSkins_ChangeLog.IsStyled = true
		end
	end
	
	-- Shadow & Light
	if T.IsAddOnLoaded('ElvUI_SLE') and E.private.KlixUI.skins.addonSkins.sle then
		local sleFrames = {
			_G["SLE_BG_1"],
			_G["SLE_BG_2"], 
			_G["SLE_BG_3"], 
			_G["SLE_BG_4"], 
			_G["SLE_DataPanel_1"], 
			_G["SLE_DataPanel_2"], 
			_G["SLE_DataPanel_3"], 
			_G["SLE_DataPanel_4"],
			_G["SLE_DataPanel_5"], 
			_G["SLE_DataPanel_6"],
			_G["SLE_DataPanel_7"], 
			_G["SLE_DataPanel_8"], 
			_G["SLE_RaidMarkerBar"].backdrop,
			_G["SLE_SquareMinimapButtonBar"], 
			_G["SLE_LocationPanel"], 
			_G["SLE_LocationPanel_X"], 
			_G["SLE_LocationPanel_Y"], 
			_G["SLE_LocationPanel_RightClickMenu1"], 
			_G["SLE_LocationPanel_RightClickMenu2"],
			_G["InspectArmory"]
		}
		for _, frame in T.pairs(sleFrames) do
			if frame then
				frame:Styling()
				frame:SetTemplate("Transparent")
			end
		end
	end

	-- ElvUI_DTBars2
	if T.IsAddOnLoaded('ElvUI_DTBars2') and E.private.KlixUI.skins.addonSkins.dtb then
		for panelname, data in T.pairs(E.global.dtbars) do
			if panelname then
				_G[panelname]:Styling()
				if not E.db.dtbars[panelname].transparent then
					_G[panelname]:SetTemplate("Transparent")
				end
			end
		end
	end
	
	-- ElvUI_LocationPlus
	if T.IsAddOnLoaded("ElvUI_LocationPlus") then
		local LPFrames = {
			_G.LocationPlusPanel,
			_G.RightCoordDtPanel,
			_G.LeftCoordDtPanel,
			_G.XCoordsPanel,
			_G.YCoordsPanel
		}
		for _, frame in T.pairs(LPFrames) do
			if frame then
				frame:Styling()
			end
		end
	end
	
	-- CoolGlow
	if T.IsAddOnLoaded("CoolGlow") then
		if CoolGlowTestFrame then
			_G["CoolGlowTestFrame"]:Styling()
		end
	end
	
	-- Simulationcraft
	if T.IsAddOnLoaded("Simulationcraft") then
		if SimcCopyFrame then
			_G["SimcCopyFrame"]:Styling()
		end
	end
	
	-- ElvUI_InfoBar
	if T.IsAddOnLoaded("ElvUI_InfoBar") then
		local IFFrames = {
			_G["IF_InfoBar1"].Background,
			_G["IF_InfoBar2"].Background,
			_G["IF_InfoBar3"].Background,
			_G["IF_InfoBar4"].Background,
			_G["IF_InfoBar5"].Background,
			_G["IF_InfoBar6"].Background,
			_G["IF_InfoBar7"].Background,
			_G["IF_InfoBar8"].Background,
			_G["IF_InfoBar9"].Background,
			_G["IF_InfoBar10"].Background,
			_G["IF_Menu"].Button1.Background,
			_G["IF_Menu"].Button2.Background,
			_G["IF_Menu"].Button3.Background,
			_G["IF_Menu"].Button4.Background,
			_G["IF_Menu"].Button5.Background,
			_G["IF_Menu"].Clear.Background
		}
		for _, frame in T.pairs(IFFrames) do
			if frame then
				frame:Styling()
			end
		end
	end
	
	-- Classic Quest Log
	if T.IsAddOnLoaded("Classic Quest Log") then
		ClassicQuestLog:Styling()
		ClassicQuestLogScrollFrame.BG:Hide()
		ClassicQuestLogDetailScrollFrame.DetailBG:Hide()
	end
	
	-- XToLevel
	if T.IsAddOnLoaded("XToLevel") then
		local frame = _G.XToLevel_AverageFrame_Classic
		if frame then
			frame:StripTextures()
			frame:CreateBackdrop("Transparent")
			frame.backdrop:Styling()
		end
		
		local XToLevelFrames = {
			_G.XToLevel_AverageFrame_Blocky_PlayerFrameCounterKillsBackground,
			_G.XToLevel_AverageFrame_Blocky_PlayerFrameCounterQuestsBackground,
			_G.XToLevel_AverageFrame_Blocky_PlayerFrameCounterDungeonsBackground,
			_G.XToLevel_AverageFrame_Blocky_PlayerFrameCounterBattlesBackground,
			_G.XToLevel_AverageFrame_Blocky_PlayerFrameCounterObjectivesBackground,
			_G.XToLevel_AverageFrame_Blocky_PlayerFrameCounterPetBattlesBackground,
			_G.XToLevel_AverageFrame_Blocky_PlayerFrameCounterGatheringBackground,
			_G.XToLevel_AverageFrame_Blocky_PlayerFrameCounterDigsBackground,
			_G.XToLevel_AverageFrame_Blocky_PlayerFrameCounterProgressBackground,
			_G.XToLevel_AverageFrame_Blocky_PlayerFrameCounterTimerBackground,
			_G.XToLevel_AverageFrame_Blocky_PlayerFrameCounterGuildProgressBackground,
		}

		for _, blockFrame in T.pairs(XToLevelFrames) do
			if blockFrame then
				blockFrame:StripTextures()
				blockFrame:CreateBackdrop("Transparent")
				blockFrame.backdrop:Styling()
			end
		end
	end
	
	-- ClassicThreatMeter
	if T.IsAddOnLoaded("ClassicThreatMeter") then
		local frame = _G.ClassicThreatMeterBarFrame
		if frame then
			frame:StripTextures()
			frame:CreateBackdrop("Transparent")
			frame.backdrop:Styling()
			
			-- header
			if frame.header then
				frame.header.backdrop:Styling()
			end
		end
	end
	
	-- Questie
	if T.IsAddOnLoaded("Questie") then
		local button = _G.Questie_Toggle
		if button then
			S:HandleButton(button)
		end
	end
	
	-- Questie
	if T.IsAddOnLoaded("LFGShout") then
		local frame = _G.LFGShoutFrame
		if frame then
			frame:StripTextures()
			frame:CreateBackdrop("Transparent")
			frame.backdrop:Styling()
			
			-- Options Frame
			if frame.OptionsFrame then
				frame.OptionsFrame:StripTextures()
				frame.OptionsFrame:CreateBackdrop("Transparent")
				frame.OptionsFrame.backdrop:Styling()
				
				if frame.OptionsFrame.StartText then
					frame.OptionsFrame.StartText:StripTextures()
					frame.OptionsFrame.StartText:CreateBackdrop()
					frame.OptionsFrame.StartText:SetSize(139, 16)
				end
				if frame.OptionsFrame.EndText then
					frame.OptionsFrame.EndText:StripTextures()
					frame.OptionsFrame.EndText:CreateBackdrop()
					frame.OptionsFrame.EndText:SetSize(139, 16)
				end
			end
		end
	end
	
	-- WeaponSwingTimer
	if T.IsAddOnLoaded("WeaponSwingTimer") then
		-- Player
		if _G.WeaponSwingTimerPlayerBackdropFrame then
			_G.WeaponSwingTimerPlayerBackdropFrame:StripTextures()
			_G.WeaponSwingTimerPlayerBackdropFrame:CreateBackdrop("Transparent")
			_G.WeaponSwingTimerPlayerBackdropFrame.backdrop:Point('TOPLEFT', 10, -10)
			_G.WeaponSwingTimerPlayerBackdropFrame.backdrop:Point('BOTTOMRIGHT', -10, 10)
			_G.WeaponSwingTimerPlayerBackdropFrame.backdrop:Styling()
		end
		
		if _G.WeaponSwingTimerPlayerFrame then
			if _G.WeaponSwingTimerPlayerFrame.main_bar:IsShown() then
				_G.WeaponSwingTimerPlayerFrame.main_left_text:ClearAllPoints()
				_G.WeaponSwingTimerPlayerFrame.main_left_text:SetPoint("TOPLEFT", _G.WeaponSwingTimerPlayerFrame, "TOPLEFT", 2, 0)
				_G.WeaponSwingTimerPlayerFrame.main_right_text:ClearAllPoints()
				_G.WeaponSwingTimerPlayerFrame.main_right_text:SetPoint("TOPRIGHT", _G.WeaponSwingTimerPlayerFrame, "TOPRIGHT", -2, 0)
				_G.WeaponSwingTimerPlayerFrame.off_left_text:ClearAllPoints()
				_G.WeaponSwingTimerPlayerFrame.off_left_text:SetPoint("BOTTOMLEFT", _G.WeaponSwingTimerPlayerFrame, "BOTTOMLEFT", 2, 0)
				_G.WeaponSwingTimerPlayerFrame.off_right_text:ClearAllPoints()
				_G.WeaponSwingTimerPlayerFrame.off_right_text:SetPoint("BOTTOMRIGHT", _G.WeaponSwingTimerPlayerFrame, "BOTTOMRIGHT", -2, 0)
			else
				_G.WeaponSwingTimerPlayerFrame.main_left_text:ClearAllPoints()
				_G.WeaponSwingTimerPlayerFrame.main_left_text:SetPoint("LEFT", _G.WeaponSwingTimerPlayerFrame, "LEFT", 2, 0)
				_G.WeaponSwingTimerPlayerFrame.main_right_text:ClearAllPoints()
				_G.WeaponSwingTimerPlayerFrame.main_right_text:SetPoint("RIGHT", _G.WeaponSwingTimerPlayerFrame, "RIGHT", -2, 0)
			end
			
			_G.WeaponSwingTimerPlayerFrame.main_left_text:SetFont(E.media.normFont, 11, "OUTLINE")
			_G.WeaponSwingTimerPlayerFrame.off_left_text:SetFont(E.media.normFont, 11, "OUTLINE")
			_G.WeaponSwingTimerPlayerFrame.main_right_text:SetFont(E.media.normFont, 11, "OUTLINE")
			_G.WeaponSwingTimerPlayerFrame.off_right_text:SetFont(E.media.normFont, 11, "OUTLINE")
		end
		
		-- Target
		if _G.WeaponSwingTimerTargetBackdropFrame then
			_G.WeaponSwingTimerTargetBackdropFrame:StripTextures()
			_G.WeaponSwingTimerTargetBackdropFrame:CreateBackdrop("Transparent")
			_G.WeaponSwingTimerTargetBackdropFrame.backdrop:Point('TOPLEFT', 10, -10)
			_G.WeaponSwingTimerTargetBackdropFrame.backdrop:Point('BOTTOMRIGHT', -10, 10)
			_G.WeaponSwingTimerTargetBackdropFrame.backdrop:Styling()
		end
		
		if _G.WeaponSwingTimerTargetFrame then
			if _G.WeaponSwingTimerTargetFrame.main_bar:IsShown() then
				_G.WeaponSwingTimerTargetFrame.main_left_text:ClearAllPoints()
				_G.WeaponSwingTimerTargetFrame.main_left_text:SetPoint("TOPLEFT", _G.WeaponSwingTimerTargetFrame, "TOPLEFT", 2, 0)
				_G.WeaponSwingTimerTargetFrame.main_right_text:ClearAllPoints()
				_G.WeaponSwingTimerTargetFrame.main_right_text:SetPoint("TOPRIGHT", _G.WeaponSwingTimerTargetFrame, "TOPRIGHT", -2, 0)
				_G.WeaponSwingTimerTargetFrame.off_left_text:ClearAllPoints()
				_G.WeaponSwingTimerTargetFrame.off_left_text:SetPoint("BOTTOMLEFT", _G.WeaponSwingTimerTargetFrame, "BOTTOMLEFT", 2, 0)
				_G.WeaponSwingTimerTargetFrame.off_right_text:ClearAllPoints()
				_G.WeaponSwingTimerTargetFrame.off_right_text:SetPoint("BOTTOMRIGHT", _G.WeaponSwingTimerTargetFrame, "BOTTOMRIGHT", -2, 0)
			else
				_G.WeaponSwingTimerTargetFrame.main_left_text:ClearAllPoints()
				_G.WeaponSwingTimerTargetFrame.main_left_text:SetPoint("LEFT", _G.WeaponSwingTimerTargetFrame, "LEFT", 2, 0)
				_G.WeaponSwingTimerTargetFrame.main_right_text:ClearAllPoints()
				_G.WeaponSwingTimerTargetFrame.main_right_text:SetPoint("RIGHT", _G.WeaponSwingTimerTargetFrame, "RIGHT", -2, 0)
			end
			
			_G.WeaponSwingTimerTargetFrame.main_left_text:SetFont(E.media.normFont, 11, "OUTLINE")
			_G.WeaponSwingTimerTargetFrame.off_left_text:SetFont(E.media.normFont, 11, "OUTLINE")
			_G.WeaponSwingTimerTargetFrame.main_right_text:SetFont(E.media.normFont, 11, "OUTLINE")
			_G.WeaponSwingTimerTargetFrame.off_right_text:SetFont(E.media.normFont, 11, "OUTLINE")
		end
		
		-- Hunter
		if _G.WeaponSwingTimerHunterBackdropFrame then
			_G.WeaponSwingTimerHunterBackdropFrame:StripTextures()
			_G.WeaponSwingTimerHunterBackdropFrame:CreateBackdrop("Transparent")
			_G.WeaponSwingTimerHunterBackdropFrame.backdrop:Point('TOPLEFT', 10, -10)
			_G.WeaponSwingTimerHunterBackdropFrame.backdrop:Point('BOTTOMRIGHT', -10, 10)
			_G.WeaponSwingTimerHunterBackdropFrame.backdrop:Styling()
		end
		
		if _G.WeaponSwingTimerHunterFrame then
			_G.WeaponSwingTimerHunterFrame.spell_text_center:ClearAllPoints()
			_G.WeaponSwingTimerHunterFrame.spell_text_center:SetPoint("CENTER", _G.WeaponSwingTimerHunterFrame.shot_bar, "CENTER", 0, 0)
			
			_G.WeaponSwingTimerHunterFrame.spell_text_center:SetFont(E.media.normFont, 11, "OUTLINE")
		end
	end
end

local function StyleDBM_Options()
	if not E.private.KlixUI.skins.addonSkins.dbm or not T.IsAddOnLoaded("AddOnSkins") then return end

	DBM_GUI_OptionsFrame:HookScript('OnShow', function()
		DBM_GUI_OptionsFrame:Styling()
	end)
end

function KS:LoD_AddOns(_, addon)
	if addon == "DBM-GUI" then
		StyleDBM_Options()
	end
end

-- ElvUI things!
local function StyleElvUIConfig()
	if T.InCombatLockdown() or not E.private.skins.ace3.enable then return end
	
	local frame = _G.ElvUIGUIFrame
	if not frame.IsStyled then
		frame:Styling()
		frame.IsStyled = true
	end
end

local function StyleElvUIInstall()
	if T.InCombatLockdown() then return end
	
	local frame = _G.ElvUIInstallFrame
	if not frame.IsStyled then
		frame:Styling()
		frame.IsStyled = true
	end
end

local function StyleAceTooltip(self)
	if not self or self:IsForbidden() then return end
	if not self.styling then
		self:Styling()
	end
end

function KS:PLAYER_ENTERING_WORLD(...)
	styleAddons()

	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function KS:Initialize()
	self.db = E.private.KlixUI.skins

	ReskinVehicleExit()
	updateMedia()
	pluginInstaller()
	
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("ADDON_LOADED", "LoD_AddOns")
	
	hooksecurefunc(E, 'ToggleOptionsUI', StyleElvUIConfig)
	hooksecurefunc(E, 'Install', StyleElvUIInstall)
	hooksecurefunc(S, "Ace3_StyleTooltip", StyleAceTooltip)
	
	if T.IsAddOnLoaded("AddOnSkins") then
		if AddOnSkins then
			KS:ReskinAS(T.unpack(AddOnSkins))
		end
	end
end

local function InitializeCallback()
	KS:Initialize()
end

KUI:RegisterModule(KS:GetName(), InitializeCallback)