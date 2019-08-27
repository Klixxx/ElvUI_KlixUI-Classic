local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local MM = KUI:NewModule("KuiMinimap", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local KS = KUI:GetModule("KuiSkins")
local M = E:GetModule('Minimap')
local LCG = LibStub('LibCustomGlow-1.0')
local LSM = E.LSM or E.Libs.LSM

local Minimap = _G.Minimap
local MiniMapMailFrame = _G.MiniMapMailFrame
local cluster = _G.MinimapCluster
local r, g, b = unpack(E.media.rgbvaluecolor)

function MM:CheckMail()
	local mail = MiniMapMailFrame:IsShown() and true or false
	if mail then
		if E.db.KlixUI.maps.minimap.glowAlways then
			LCG.PixelGlow_Start(Minimap.backdrop, {0/255, 255/255, 0/255, 1}, nil, -0.25, nil, 1)
		else
			LCG.PixelGlow_Start(Minimap.backdrop, {r, g, b, 1}, nil, -0.25, nil, 1)
		end
	else
		if E.db.KlixUI.maps.minimap.glowAlways then
			LCG.PixelGlow_Start(Minimap.backdrop, {r, g, b, 1}, nil, -0.25, nil, 1)
		else
			LCG.PixelGlow_Stop(Minimap.backdrop) -- None of the above
		end
	end
end

function MM:MiniMapPing()
	if E.db.KlixUI.maps.minimap.ping.enable ~= true then return end

	local pos = E.db.KlixUI.maps.minimap.ping.position or "TOP"
	local xOffset = E.db.KlixUI.maps.minimap.ping.xOffset or 0
	local yOffset = E.db.KlixUI.maps.minimap.ping.yOffset or 0
	
	MM.pingpanel = T.CreateFrame('Frame', "KUI_PingPanel", Minimap)
	MM.pingpanel:SetAllPoints()
	MM.pingpanel.text = KS:CreateFS(MM.pingpanel, 10, "", false, pos, xOffset, yOffset)

	local anim = MM.pingpanel:CreateAnimationGroup()
	anim:SetScript("OnPlay", function() MM.pingpanel:SetAlpha(1) end)
	anim:SetScript("OnFinished", function() MM.pingpanel:SetAlpha(0) end)

	anim.fader = anim:CreateAnimation("Alpha")
	anim.fader:SetFromAlpha(1)
	anim.fader:SetToAlpha(0)
	anim.fader:SetDuration(3)
	anim.fader:SetSmoothing("OUT")
	anim.fader:SetStartDelay(3)

	KUI:RegisterEvent("MINIMAP_PING", function(_, unit)
		local _, unitClass = T.UnitClass(unit)
		local class = ElvUF.colors.class[unitClass]
		local name = T.GetUnitName(unit)

		anim:Stop()
		MM.pingpanel.text:SetText(name)
		MM.pingpanel.text:SetTextColor(class[1], class[2], class[3])
		anim:Play()
	end)
end

function MM:UpdateCoords(elapsed)
	MM.coordspanel.elapsed = (MM.coordspanel.elapsed or 0) + elapsed
	if MM.coordspanel.elapsed < E.db.KlixUI.maps.minimap.coords.throttle then return end
	if E.MapInfo then
		local x, y = E.MapInfo.x, E.MapInfo.y
		if x then x = T.string_format(E.db.KlixUI.maps.minimap.coords.format, x * 100) else x = "0" end
		if y then y = T.string_format(E.db.KlixUI.maps.minimap.coords.format, y * 100) else y = "0" end
		if x == "0" or x == "0.0" or x == "0.00" then x = "-" end
		if y == "0" or y == "0.0" or y == "0.00" then y = "-" end
		MM.coordspanel.Text:SetText(x.." , "..y)
	else 
		MM.coordspanel.Text:SetText("-")
	end
	MM:CoordsSize()
	MM.coordspanel.elapsed = 0
end

function MM:CoordFont()
	MM.coordspanel.Text:SetFont(E.LSM:Fetch('font', E.db.KlixUI.maps.minimap.coords.font), E.db.KlixUI.maps.minimap.coords.fontSize, E.db.KlixUI.maps.minimap.coords.fontOutline)
end

function MM:CoordsSize()
	local size = MM.coordspanel.Text:GetStringWidth()
	if size ~= MM.coordspanel.WidthValue then
		MM.coordspanel:Size(size + 4, E.db.KlixUI.maps.minimap.coords.fontSize + 2)
		MM.coordspanel.WidthValue = size + 4
	end
end

function MM:UpdateCoordinatesPosition()
	MM.coordspanel:ClearAllPoints()
	MM.coordspanel:SetPoint(E.db.KlixUI.maps.minimap.coords.position, E.db.KlixUI.maps.minimap.coords.xOffset, E.db.KlixUI.maps.minimap.coords.yOffset, _G["Minimap"])
end

function MM:CreateCoordsFrame()
	MM.coordspanel = T.CreateFrame('Frame', "KUI_CoordsPanel", _G["Minimap"])
	MM.coordspanel:Point("BOTTOM", _G["Minimap"], "BOTTOM", 0, 0)
	MM.coordspanel.WidthValue = 0

	MM.coordspanel.Text = MM.coordspanel:CreateFontString(nil, "OVERLAY")
	MM.coordspanel.Text:SetPoint("CENTER", MM.coordspanel)
	MM.coordspanel.Text:SetWordWrap(false)

	Minimap:HookScript('OnEnter', function(self)
		if E.db.KlixUI.maps.minimap.coords.display ~= 'MOUSEOVER' or not E.private.general.minimap.enable or not E.db.KlixUI.maps.minimap.coords.enable then return; end
		MM.coordspanel:Show()
	end)

	Minimap:HookScript('OnLeave', function(self)
		if E.db.KlixUI.maps.minimap.coords.display ~= 'MOUSEOVER' or not E.private.general.minimap.enable or not E.db.KlixUI.maps.minimap.coords.enable then return; end
		MM.coordspanel:Hide()
	end)

	MM:UpdateCoordinatesPosition()
end

function MM:SetCoordsColor()
	local color = E.db.KlixUI.maps.minimap.coords.color
	MM.coordspanel.Text:SetTextColor(color.r, color.g, color.b)
end

function MM:UpdateSettings()
	if not MM.coordspanel then
		MM:CreateCoordsFrame()
	end
	MM:CoordFont()
	MM:SetCoordsColor()
	MM:CoordsSize()

	MM.coordspanel:SetPoint(E.db.KlixUI.maps.minimap.coords.position, _G["Minimap"])
	MM.coordspanel:SetScript('OnUpdate', MM.UpdateCoords)

	MM:UpdateCoordinatesPosition()
	if E.db.KlixUI.maps.minimap.coords.display ~= 'SHOW' or not E.private.general.minimap.enable or not E.db.KlixUI.maps.minimap.coords.enable then
		MM.coordspanel:Hide()
	else
		MM.coordspanel:Show()
	end
end

function MM:CreateCardinalFrame()
	local cardinals = T.CreateFrame("Frame", "MMD_Frame", _G["Minimap"]);
	cardinals:SetAllPoints();
	cardinals:SetFrameStrata("HIGH")
	
	cardinals.n = cardinals:CreateFontString("$parentText","ARTWORK","GameFontNormal");
	cardinals.n:SetText("N")
	if E.db.KlixUI.maps.minimap.rectangle then
		cardinals.n:SetPoint("CENTER", cardinals, "TOP", 0, -(E.MinimapSize/8))
	else
		cardinals.n:SetPoint("CENTER", cardinals, "TOP")
	end
	
	cardinals.e = cardinals:CreateFontString("$parentText","ARTWORK","GameFontNormal");
	cardinals.e:SetText("E")
	cardinals.e:SetPoint("CENTER", cardinals, "RIGHT", 3, 0)

	cardinals.s = cardinals:CreateFontString("$parentText","ARTWORK","GameFontNormal");
	cardinals.s:SetText("S")
	if E.db.KlixUI.maps.minimap.rectangle then
		cardinals.s:SetPoint("CENTER", cardinals, "BOTTOM", 0, (E.MinimapSize/8))
	else
		cardinals.s:SetPoint("CENTER", cardinals, "BOTTOM")
	end
	
	cardinals.w = cardinals:CreateFontString("$parentText","ARTWORK","GameFontNormal");
	cardinals.w:SetText("W")
	cardinals.w:SetPoint("CENTER", cardinals, "LEFT", 0, 0)
end

function MM:UpdateCardinalFrame()
	if not E.db.KlixUI.maps.minimap.cardinalPoints.enable then
		MMD_Frame:Hide()
	else
		MMD_Frame:Show()
	end
	
	if not E.db.KlixUI.maps.minimap.cardinalPoints.north then
		MMD_Frame.n:Hide()
	else
		MMD_Frame.n:Show()
	end
	
	if not E.db.KlixUI.maps.minimap.cardinalPoints.east then
		MMD_Frame.e:Hide()
	else
		MMD_Frame.e:Show()
	end
	
	if not E.db.KlixUI.maps.minimap.cardinalPoints.south then
		MMD_Frame.s:Hide()
	else
		MMD_Frame.s:Show()
	end
	
	if not E.db.KlixUI.maps.minimap.cardinalPoints.west then
		MMD_Frame.w:Hide()
	else
		MMD_Frame.w:Show()
	end
end

function MM:ColorCardinalFrame()
	if E.db.KlixUI.maps.minimap.cardinalPoints.color == 1 then
		MMD_Frame.n:SetTextColor(KUI.r, KUI.g, KUI.b)
		MMD_Frame.e:SetTextColor(KUI.r, KUI.g, KUI.b)
		MMD_Frame.s:SetTextColor(KUI.r, KUI.g, KUI.b)
		MMD_Frame.w:SetTextColor(KUI.r, KUI.g, KUI.b)
	elseif E.db.KlixUI.maps.minimap.cardinalPoints.color == 2 then
		MMD_Frame.n:SetTextColor(KUI:unpackColor(E.db.KlixUI.maps.minimap.cardinalPoints.customColor))
		MMD_Frame.e:SetTextColor(KUI:unpackColor(E.db.KlixUI.maps.minimap.cardinalPoints.customColor))
		MMD_Frame.s:SetTextColor(KUI:unpackColor(E.db.KlixUI.maps.minimap.cardinalPoints.customColor))
		MMD_Frame.w:SetTextColor(KUI:unpackColor(E.db.KlixUI.maps.minimap.cardinalPoints.customColor))
	else
		MMD_Frame.n:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
		MMD_Frame.e:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
		MMD_Frame.s:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
		MMD_Frame.w:SetTextColor(KUI:unpackColor(E.db.general.valuecolor))
	end
end

function MM:FontCardinalFrame()
	MMD_Frame.n:FontTemplate(E.LSM:Fetch("font", E.db.KlixUI.maps.minimap.cardinalPoints.Font), E.db.KlixUI.maps.minimap.cardinalPoints.FontSize, E.db.KlixUI.maps.minimap.cardinalPoints.FontOutline)
	MMD_Frame.e:FontTemplate(E.LSM:Fetch("font", E.db.KlixUI.maps.minimap.cardinalPoints.Font), E.db.KlixUI.maps.minimap.cardinalPoints.FontSize, E.db.KlixUI.maps.minimap.cardinalPoints.FontOutline)
	MMD_Frame.s:FontTemplate(E.LSM:Fetch("font", E.db.KlixUI.maps.minimap.cardinalPoints.Font), E.db.KlixUI.maps.minimap.cardinalPoints.FontSize, E.db.KlixUI.maps.minimap.cardinalPoints.FontOutline)
	MMD_Frame.w:FontTemplate(E.LSM:Fetch("font", E.db.KlixUI.maps.minimap.cardinalPoints.Font), E.db.KlixUI.maps.minimap.cardinalPoints.FontSize, E.db.KlixUI.maps.minimap.cardinalPoints.FontOutline)
end

-- Hide/fade minimap in combat
local function FadeFrame(frame, direction, startAlpha, endAlpha, time, func)
	T.UIFrameFade(frame, {
		mode = direction,
		finishedFunc = func,
		startAlpha = startAlpha,
		endAlpha = endAlpha,
		timeToFade = time,
	})
end

local function HideMinimap()
	cluster:Hide()
end

local function FadeInMinimap()
	if not T.InCombatLockdown() then
		FadeFrame(cluster, "IN", 0, 1, .5, function() if not T.InCombatLockdown() then cluster:Show() end end)
	end
end

local function ShowMinimap()
	if E.db.KlixUI.maps.minimap.fadeindelay == 0 then
		FadeInMinimap()		
	else
		E:Delay(E.db.KlixUI.maps.minimap.fadeindelay, FadeInMinimap)
	end
end

function MM:HideMinimapRegister()
	if E.db.KlixUI.maps.minimap.hideincombat then
		M:RegisterEvent("PLAYER_REGEN_DISABLED", HideMinimap)	
		M:RegisterEvent("PLAYER_REGEN_ENABLED", ShowMinimap)
	else
		M:UnregisterEvent("PLAYER_REGEN_DISABLED")	
		M:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end
end

function MM:SkinMiniMap()
	local frames = {
        'MinimapBorderTop',
		'MinimapNorthTag',
		'MinimapBorder',
		'MinimapZoomOut',
		'MinimapZoomIn',
		'MiniMapWorldMapButton',
		'MiniMapMailBorder',

    }
    for i in T.pairs(frames) do
        _G[frames[i]]:Kill()
    end
	
	Minimap:SetMaskTexture('Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\rectangle')
	Minimap:SetHitRectInsets(0, 0, (E.MinimapSize/8)*E.mult, (E.MinimapSize/8)*E.mult)
	Minimap:SetClampRectInsets(0, 0, 0, 0)
	
	if Minimap.backdrop then
		Minimap.backdrop:SetOutside(Minimap, E.mult, -(E.MinimapSize/8*E.mult))
	end
	
	if Minimap.location then
		Minimap.location:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, -(E.MinimapSize/8+10))
		Minimap.location:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 0, -(E.MinimapSize/8+10))
	end
	
	if Minimap.mshadow then
		Minimap.mshadow:SetOutside(Minimap, E.mult, -(E.MinimapSize/8*E.mult))
	end
	
	local BottomMiniPanel = _G.BottomMiniPanel
	BottomMiniPanel:ClearAllPoints()
	BottomMiniPanel:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, E.MinimapSize/8)
	
	local TopMiniPanel = _G.TopMiniPanel
	TopMiniPanel:ClearAllPoints()
	TopMiniPanel:SetPoint("TOP", Minimap, "TOP", 0, -E.MinimapSize/8)
	
	local TopLeftMiniPanel = _G.TopLeftMiniPanel
	TopLeftMiniPanel:ClearAllPoints()
	TopLeftMiniPanel:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, -E.MinimapSize/8)
	
	local TopRightMiniPanel = _G.TopRightMiniPanel
	TopRightMiniPanel:ClearAllPoints()
	TopRightMiniPanel:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 0, -E.MinimapSize/8)
	
	local BottomLeftMiniPanel = _G.BottomLeftMiniPanel
	BottomLeftMiniPanel:ClearAllPoints()
	BottomLeftMiniPanel:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 0, E.MinimapSize/8)
	
	local BottomRightMiniPanel = _G.BottomRightMiniPanel
	BottomRightMiniPanel:ClearAllPoints()
	BottomRightMiniPanel:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 0, E.MinimapSize/8)
end

function MM:Initialize()
	if E.private.general.minimap.enable ~= true then return end

	-- Add a check if the backdrop is there
	if not Minimap.backdrop then
		Minimap:CreateBackdrop("Default", true)
		Minimap.backdrop:SetBackdrop({
			edgeFile = E.LSM:Fetch("statusbar", "KlixGradient"), edgeSize = E:Scale(2),
			insets = {left = E:Scale(2), right = E:Scale(2), top = E:Scale(2), bottom = E:Scale(2)},
		})
	end
	
	hooksecurefunc(M, 'UpdateSettings', MM.UpdateSettings)
	
	if E.db.KlixUI.maps.minimap.rectangle and not T.IsAddOnLoaded("ElvUI_RectangleMinimap") then
		MM:SkinMiniMap()
	end
	
	MM:UpdateSettings()
	MM:MiniMapPing()
	MM:HideMinimapRegister()
	if not T.IsAddOnLoaded("ElvUI_CompassPoints") then
		MM:CreateCardinalFrame()
		MM:UpdateCardinalFrame()
		MM:ColorCardinalFrame()
		MM:FontCardinalFrame()
	end
	
	if E.db.KlixUI.maps.minimap.glow then
		self:RegisterEvent("UPDATE_PENDING_MAIL", "CheckMail")
		self:RegisterEvent("PLAYER_ENTERING_WORLD", "CheckMail")
		self:HookScript(MiniMapMailFrame, "OnHide", "CheckMail")
		self:HookScript(MiniMapMailFrame, "OnShow", "CheckMail")
	end
end

KUI:RegisterModule(MM:GetName())