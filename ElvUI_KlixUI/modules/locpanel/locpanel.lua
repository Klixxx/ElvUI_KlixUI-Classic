local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local M = E:GetModule("Minimap")
local DD = KUI:GetModule("Dropdown")
local DT = E:GetModule('DataTexts')
local LP = KUI:NewModule("LocPanel", "AceTimer-3.0", "AceEvent-3.0", 'AceHook-3.0')
local LSM = E.LSM or E.Libs.LSM

local UNKNOWN, GARRISON_LOCATION_TOOLTIP, ITEMS, SPELLS, CLOSE, BACK = UNKNOWN, GARRISON_LOCATION_TOOLTIP, ITEMS, SPELLS, CLOSE, BACK
local DUNGEON_FLOOR_DALARAN1 = DUNGEON_FLOOR_DALARAN1
local CHALLENGE_MODE = CHALLENGE_MODE
local RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS
local GameTooltip, WorldMapFrame = _G.GameTooltip, _G.WorldMapFrame

local loc_panel
local faction

LP.ReactionColors = {
	["sanctuary"] = {r = 0.41, g = 0.8, b = 0.94},
	["arena"] = {r = 1, g = 0.1, b = 0.1},
	["friendly"] = {r = 0.1, g = 1, b = 0.1},
	["hostile"] = {r = 1, g = 0.1, b = 0.1},
	["contested"] = {r = 1, g = 0.7, b = 0.10},
	["combat"] = {r = 1, g = 0.1, b = 0.1},
}

local function GetDirection()
	local y = _G["KUI_LocPanel"]:GetCenter()
	local screenHeight = T.GetScreenHeight()
	local anchor, point = "TOP", "BOTTOM"
	if y and y < (screenHeight / 2) then
		anchor = "BOTTOM"
		point = "TOP"
	end
	return anchor, point
end

local function CreateCoords()
	local x, y = 0, 0
	local playerPosition = T.C_Map_GetPlayerMapPosition( T.C_Map_GetBestMapForUnit("player"), "player" )
	if playerPosition then x, y = playerPosition:GetXY() end
	x = T.string_format(LP.db.format, x * 100)
	y = T.string_format(LP.db.format, y * 100)

	return x, y
end

local function Bar_OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -4)
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint("BOTTOM", self, "BOTTOM", 0, 0)
	
	if T.InCombatLockdown() and LP.db.ttcombathide then
		GameTooltip:Hide()
	else
		LP:UpdateTooltip()
	end
	if LP.db.mouseover then
	T.UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
	end
end

local function Bar_OnLeave(self)
	GameTooltip:Hide()
	if LP.db.mouseover then
	T.UIFrameFadeOut(self, 0.2, self:GetAlpha(), LP.db.malpha)
	end
end

function LP:CreateLocationPanel()
	loc_panel = T.CreateFrame('Frame', "KUI_LocPanel", E.UIParent)
	loc_panel:Point("TOP", E.UIParent, "TOP", 0, -40)
	loc_panel:SetFrameStrata('LOW')
	loc_panel:SetFrameLevel(2)
	loc_panel:EnableMouse(true)
	loc_panel:SetScript('OnMouseUp', LP.OnClick)
	loc_panel:SetScript("OnUpdate", LP.UpdateCoords)
	loc_panel:SetScript('OnEnter', Bar_OnEnter) 
	loc_panel:SetScript('OnLeave', Bar_OnLeave)
	E.FrameLocks[loc_panel] = true
	
	-- Location Text
	loc_panel.Text = loc_panel:CreateFontString(nil, "LOW")
	loc_panel.Text:Point("CENTER", 0, 0)
	loc_panel.Text:SetWordWrap(false)
	E.FrameLocks[loc_panel] = true

	--Coords
	loc_panel.Xcoord = T.CreateFrame('Frame', "KUI_LocPanel_X", loc_panel)
	loc_panel.Xcoord:SetPoint("RIGHT", loc_panel, "LEFT", 1 - 2*E.Spacing, 0)
	loc_panel.Xcoord.Text = loc_panel.Xcoord:CreateFontString(nil, "LOW")
	loc_panel.Xcoord.Text:Point("CENTER", 0, 0)

	loc_panel.Ycoord = T.CreateFrame('Frame', "KUI_LocPanel_Y", loc_panel)
	loc_panel.Ycoord:SetPoint("LEFT", loc_panel, "RIGHT", -1 + 2*E.Spacing, 0)
	loc_panel.Ycoord.Text = loc_panel.Ycoord:CreateFontString(nil, "LOW")
	loc_panel.Ycoord.Text:Point("CENTER", 0, 0)
	
	-- Left coords Datatext panel
	left_dtp = T.CreateFrame('Frame', 'LeftCoordDtPanel', E.UIParent)
	left_dtp:SetPoint("RIGHT", loc_panel.Xcoord, "LEFT", 1 - 2*E.Spacing, 0)
	left_dtp:SetParent(KUI_LocPanel)

	-- Right coords Datatext panel
	right_dtp = T.CreateFrame('Frame', 'RightCoordDtPanel', E.UIParent)
	right_dtp:SetPoint("LEFT", loc_panel.Ycoord, "RIGHT", -1 + 2*E.Spacing, 0)
	right_dtp:SetParent(KUI_LocPanel)
	
	DT:RegisterPanel(LeftCoordDtPanel, 1, 'ANCHOR_BOTTOM', 0, -4)
	DT:RegisterPanel(RightCoordDtPanel, 1, 'ANCHOR_BOTTOM', 0, -4)

	L['RightCoordDtPanel'] = KUI:cOption(L["LocationPanel Right Panel"]);
	L['LeftCoordDtPanel'] = KUI:cOption(L["LocationPanel Left Panel"]);
	
	LP:Resize()
	-- Mover
	E:CreateMover(loc_panel, "KUI_LocPanel_Mover", L["Location Panel"], nil, nil, nil, "ALL,SOLO,KLIXUI", nil, "KlixUI,modules,locPanel")
end

function LP:OnClick(btn)
	local zoneText = T.GetRealZoneText() or UNKNOWN;
	if btn == "LeftButton" then
		if T.IsShiftKeyDown() and LP.db.linkcoords then
			local edit_box = T.ChatEdit_ChooseBoxForSend()
			local x, y = CreateCoords()
			local message
			local coords = x..", "..y
				if zoneText ~= T.GetSubZoneText() then
					message = T.string_format("%s: %s (%s)", zoneText, T.GetSubZoneText(), coords)
				else
					message = format("%s (%s)", zoneText, coords)
				end
			T.ChatEdit_ActivateChat(edit_box)
			edit_box:Insert(message) 
		else
			if T.IsControlKeyDown() then
				left_dtp:SetScript("OnShow", function(self) LP.db.dtshow = true; end)
				left_dtp:SetScript("OnHide", function(self) LP.db.dtshow = false; end)
				T.ToggleFrame(left_dtp)
				T.ToggleFrame(right_dtp)
			else 
			T.ToggleFrame(_G["WorldMapFrame"])
			end
		end
	end
end

function LP:UpdateCoords(elapsed)
	LP.elapsed = LP.elapsed + elapsed
	if LP.elapsed < (LP.db.throttle or 0.2) then return end
	
	if not LP.RestrictedArea then
	if T.tonumber(E.version) >= 10.78 and E.MapInfo then
		local x, y = E.MapInfo.x, E.MapInfo.y
		if x then x = T.string_format(LP.db.format, x * 100) else x = "0" end
		if y then y = T.string_format(LP.db.format, y * 100) else y = "0" end
		if x == "0" or x == "0.0" or x == "0.00" then x = "-" end
		if y == "0" or y == "0.0" or y == "0.00" then y = "-" end
		loc_panel.Xcoord.Text:SetText(x)
		loc_panel.Ycoord.Text:SetText(y)
	elseif T.tonumber(E.version) < 10.78 then
		local x, y = CreateCoords()
		if x == "0" or x == "0.0" or x == "0.00" then x = "-" end
		if y == "0" or y == "0.0" or y == "0.00" then y = "-" end
		loc_panel.Xcoord.Text:SetText(x)
		loc_panel.Ycoord.Text:SetText(y)
	end
	else
	loc_panel.Xcoord.Text:SetText("-")
	loc_panel.Ycoord.Text:SetText("-")
	end

	--Coords coloring
	local colorC = {r = 1, g = 1, b = 1}
	if LP.db.colorType_Coords == "REACTION" then
		local inInstance, _ = T.IsInInstance()
		if inInstance then
			colorC = {r = 1, g = 0.1,b =  0.1}
		else
			local pvpType = T.GetZonePVPInfo()
			colorC = LP.ReactionColors[pvpType] or {r = 1, g = 1, b = 0}
		end
	elseif LP.db.colorType_Coords == "CUSTOM" then
		colorC = LP.db.customColor_Coords
	elseif LP.db.colorType_Coords == "CLASS" then
		colorC = RAID_CLASS_COLORS[E.myclass]
	end
	loc_panel.Xcoord.Text:SetTextColor(colorC.r, colorC.g, colorC.b)
	loc_panel.Ycoord.Text:SetTextColor(colorC.r, colorC.g, colorC.b)

	--Location
	local subZoneText = T.GetMinimapZoneText() or ""
	local zoneText = T.GetRealZoneText() or UNKNOWN;
	local displayLine
	if LP.db.zoneText then
		if (subZoneText ~= "") and (subZoneText ~= zoneText) then
			displayLine = zoneText .. ": " .. subZoneText
		else
			displayLine = subZoneText
		end
	else
		displayLine = subZoneText
	end
	loc_panel.Text:SetText(displayLine)
	if LP.db.autowidth then
		loc_panel:Width(loc_panel.Text:GetStringWidth() + 10)
	end
	
	--Location Colorings
	if displayLine ~= "" then
		local color = {r = 1, g = 1, b = 1}
		if LP.db.colorType == "REACTION" then
			local inInstance, _ = T.IsInInstance()
			if inInstance then
				color = {r = 1, g = 0.1,b =  0.1}
			else
				local pvpType = T.GetZonePVPInfo()
				color = LP.ReactionColors[pvpType] or {r = 1, g = 1, b = 0}
			end
		elseif LP.db.colorType == "CUSTOM" then
			color = LP.db.customColor
		elseif LP.db.colorType == "CLASS" then
			color = RAID_CLASS_COLORS[E.myclass]
		end
		loc_panel.Text:SetTextColor(color.r, color.g, color.b)
	end

	LP.elapsed = 0
end

-- Show/Hide coord frames
function LP:HideCoords()
	KUI_LocPanel_X:Point('RIGHT', loc_panel, 'LEFT', -LP.db.spacing, 0)
	KUI_LocPanel_Y:Point('LEFT', loc_panel, 'RIGHT', LP.db.spacing, 0)
	
	left_dtp:ClearAllPoints()
	right_dtp:ClearAllPoints()
	
	if (LP.db.hidecoords) or (LP.db.hidecoordsInInstance and T.IsInInstance()) then
		KUI_LocPanel_X:Hide()
		KUI_LocPanel_Y:Hide()
		left_dtp:Point('RIGHT', loc_panel, 'LEFT', -LP.db.spacing, 0)
		right_dtp:Point('LEFT', loc_panel, 'RIGHT', LP.db.spacing, 0)		
	else
		KUI_LocPanel_X:Show()
		KUI_LocPanel_Y:Show()
		left_dtp:Point('RIGHT', KUI_LocPanel_X, 'LEFT', -LP.db.spacing, 0)
		right_dtp:Point('LEFT', KUI_LocPanel_Y, 'RIGHT', LP.db.spacing, 0)			
	end
end

-- mouse over option
function LP:MouseOver()
	if LP.db.mouseover then
		loc_panel:SetAlpha(LP.db.malpha)
	else
		loc_panel:SetAlpha(1)
	end
end

local function HideDT()
	if LP.db.dtshow then
		right_dtp:Show()
		left_dtp:Show()
	else
		left_dtp:Hide()
		right_dtp:Hide()
	end
end

function LP:Resize()
	if LP.db.autowidth then
		loc_panel:Size(loc_panel.Text:GetStringWidth() + 10, LP.db.height)
	else
		loc_panel:Size(LP.db.width, LP.db.height)
	end
	loc_panel.Text:Width(LP.db.width - 18)
	loc_panel.Xcoord:Size(LP.db.fontSize * 3, LP.db.height)
	loc_panel.Ycoord:Size(LP.db.fontSize * 3, LP.db.height)
	left_dtp:Size(LP.db.fontSize * 10, LP.db.height)
	right_dtp:Size(LP.db.fontSize * 10, LP.db.height)
end

function LP:Fonts()
	loc_panel.Text:SetFont(LSM:Fetch('font', LP.db.font), LP.db.fontSize, LP.db.fontOutline)
	loc_panel.Xcoord.Text:SetFont(LSM:Fetch('font', LP.db.font), LP.db.fontSize, LP.db.fontOutline)
	loc_panel.Ycoord.Text:SetFont(LSM:Fetch('font', LP.db.font), LP.db.fontSize, LP.db.fontOutline)
	
	local dtToFont = {left_dtp, right_dtp}
	for _, panel in T.pairs(dtToFont) do
		for i=1, panel.numPoints do
			local pointIndex = DT.PointLocation[i]
			panel.dataPanels[pointIndex].text:FontTemplate(E["media"].font, LP.db.fontSize, LP.db.fontOutline)
			panel.dataPanels[pointIndex].text:SetPoint("CENTER", 0, 1)
		end
	end
end

function LP:Template()
	loc_panel:SetTemplate(LP.db.template)
	loc_panel.Xcoord:SetTemplate(LP.db.template)
	loc_panel.Ycoord:SetTemplate(LP.db.template)
	left_dtp:SetTemplate(LP.db.template)
	right_dtp:SetTemplate(LP.db.template)
end

function LP:Style()
	local db = LP.db

	if E.db.KlixUI.general.style then
		if db.style then
			loc_panel:Styling()
			loc_panel.Xcoord:Styling()
			loc_panel.Ycoord:Styling()
			left_dtp:Styling()
			right_dtp:Styling()
		end
	end
end

function LP:Toggle()
	if LP.db.enable then
		loc_panel:Show()
		E:EnableMover(loc_panel.mover:GetName())
	else
		loc_panel:Hide()
		E:DisableMover(loc_panel.mover:GetName())
	end
end

function LP:ToggleBlizZoneText()
	if LP.db.blizzText then
		ZoneTextFrame:UnregisterAllEvents()
	else
		ZoneTextFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		ZoneTextFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
		ZoneTextFrame:RegisterEvent("ZONE_CHANGED")	
	end
end

function LP:PLAYER_REGEN_DISABLED()
	if LP.db.combathide then
		loc_panel:Hide()
	end
end

function LP:PLAYER_REGEN_ENABLED()
	if LP.db.enable then
		loc_panel:Show()
	end
end

function LP:Initialize()
	LP.db = E.db.KlixUI.locPanel
	
	KUI:RegisterDB(self, "locPanel")
	
	faction = T.UnitFactionGroup('player')
	
	LP.elapsed = 0
	LP:CreateLocationPanel()
	LP:Template()
	LP:Style()
	LP:Fonts()
	LP:Toggle()
	HideDT()
	LP:HideCoords()
	LP:ToggleBlizZoneText()
	
	function LP:ForUpdateAll()
		LP.db = E.db.KlixUI.locPanel
		LP:Resize()
		LP:Template()
		LP:Style()
		LP:Fonts()
		LP:Toggle()
		HideDT()
		LP:HideCoords()
		LP:ToggleBlizZoneText()
	end

	LP:RegisterEvent("PLAYER_REGEN_DISABLED")
	LP:RegisterEvent("PLAYER_REGEN_ENABLED")
end

KUI:RegisterModule(LP:GetName())