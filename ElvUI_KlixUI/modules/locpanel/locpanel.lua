local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local LP = KUI:NewModule("LocPanel", "AceTimer-3.0", "AceEvent-3.0", 'AceHook-3.0')
local M = E:GetModule("Minimap")
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

local function UpdateTooltipStatus(color)
	local status = ""
	local statusText
	local r, g, b = 1, 1, 0
	local pvpType = T.GetZonePVPInfo()
	local inInstance, _ = T.IsInInstance()

	if (pvpType == "sanctuary") then
		status = SANCTUARY_TERRITORY
		r, g, b = 0.41, 0.8, 0.94
	elseif(pvpType == "arena") then
		status = ARENA
		r, g, b = 1, 0.1, 0.1
	elseif(pvpType == "friendly") then
		status = FRIENDLY
		r, g, b = 0.1, 1, 0.1
	elseif(pvpType == "hostile") then
		status = HOSTILE
		r, g, b = 1, 0.1, 0.1
	elseif(pvpType == "contested") then
		status = CONTESTED_TERRITORY
		r, g, b = 1, 0.7, 0.10
	elseif(pvpType == "combat" ) then
		status = COMBAT
		r, g, b = 1, 0.1, 0.1
	elseif inInstance then
		status = AGGRO_WARNING_IN_INSTANCE
		r, g, b = 1, 0.1, 0.1
	else
		status = CONTESTED_TERRITORY
	end

	statusText = T.string_format("|cff%02x%02x%02x%s|r", r*255, g*255, b*255, status)

	if color then
		return r, g, b
	else
		return statusText
	end
end

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
	local x, y = E.MapInfo.x or 0, E.MapInfo.y or 0
	if x then x = T.string_format(LP.db.format, x * 100) else x = "0" or " " end
	if y then y = T.string_format(LP.db.format, y * 100) else y = "0" or " " end

	return x, y
end

local function Bar_OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -4)
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint("BOTTOM", self, "BOTTOM", 0, 0)
	
	if T.InCombatLockdown() and LP.db.tooltip.combathide then
		GameTooltip:Hide()
	else
		GameTooltip:ClearLines()
		GameTooltip:AddDoubleLine(HOME.." :", T.GetBindLocation(), 1, 1, 1, 0.41, 0.8, 0.94)
		
		if LP.db.tooltip.status then
			GameTooltip:AddDoubleLine(STATUS.." :", UpdateTooltipStatus(false), 1, 1, 1)
		end
		
		if LP.db.tooltip.enable then
			if LP.db.tooltip.hint then
				GameTooltip:AddLine(" ")
				GameTooltip:AddDoubleLine(L["Left Click: "], L["Toggle WorldMap"], 0.7, 0.7, 1, 0.7, 0.7, 1)
				GameTooltip:AddDoubleLine(L["Right Click: "], L["Send position to chat"],0.7, 0.7, 1, 0.7, 0.7, 1)
			end
			GameTooltip:Show()
		else
			GameTooltip:Hide()
		end
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
	
	LP:Resize()
	
	-- Mover
	E:CreateMover(loc_panel, "KUI_LocPanel_Mover", L["Location Panel"], nil, nil, nil, "ALL,SOLO,KLIXUI", nil, "KlixUI,modules,locPanel")
end

function LP:OnClick(btn)
	local zoneText = T.GetRealZoneText() or UNKNOWN;
	if btn == "LeftButton" then
		if LP.db.linkcoords then
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
		end
	else
		T.ToggleFrame(_G["WorldMapFrame"])
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
	
	if (LP.db.hidecoords) or (LP.db.hidecoordsInInstance and T.IsInInstance()) then
		KUI_LocPanel_X:Hide()
		KUI_LocPanel_Y:Hide()		
	else
		KUI_LocPanel_X:Show()
		KUI_LocPanel_Y:Show()		
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

function LP:Resize()
	if LP.db.autowidth then
		loc_panel:Size(loc_panel.Text:GetStringWidth() + 10, LP.db.height)
	else
		loc_panel:Size(LP.db.width, LP.db.height)
	end
	loc_panel.Text:Width(LP.db.width - 18)
	loc_panel.Xcoord:Size(LP.db.fontSize * 3, LP.db.height)
	loc_panel.Ycoord:Size(LP.db.fontSize * 3, LP.db.height)
end

function LP:Fonts()
	loc_panel.Text:SetFont(LSM:Fetch('font', LP.db.font), LP.db.fontSize, LP.db.fontOutline)
	loc_panel.Xcoord.Text:SetFont(LSM:Fetch('font', LP.db.font), LP.db.fontSize, LP.db.fontOutline)
	loc_panel.Ycoord.Text:SetFont(LSM:Fetch('font', LP.db.font), LP.db.fontSize, LP.db.fontOutline)
end

function LP:Template()
	loc_panel:SetTemplate(LP.db.template)
	loc_panel.Xcoord:SetTemplate(LP.db.template)
	loc_panel.Ycoord:SetTemplate(LP.db.template)
end

function LP:Style()
	local db = LP.db

	if E.db.KlixUI.general.style then
		if db.style then
			loc_panel:Styling()
			loc_panel.Xcoord:Styling()
			loc_panel.Ycoord:Styling()
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
	if T.IsAddOnLoaded("ElvUI_LocationPlus") then return end
	
	LP.db = E.db.KlixUI.locPanel
	
	KUI:RegisterDB(self, "locPanel")
	
	faction = T.UnitFactionGroup('player')
	
	LP.elapsed = 0
	LP:CreateLocationPanel()
	LP:Template()
	LP:Style()
	LP:Fonts()
	LP:Toggle()
	LP:HideCoords()
	LP:ToggleBlizZoneText()
	
	function LP:ForUpdateAll()
		LP.db = E.db.KlixUI.locPanel
		LP:Resize()
		LP:Template()
		LP:Style()
		LP:Fonts()
		LP:Toggle()
		LP:HideCoords()
		LP:ToggleBlizZoneText()
	end

	LP:RegisterEvent("PLAYER_REGEN_DISABLED")
	LP:RegisterEvent("PLAYER_REGEN_ENABLED")
end

KUI:RegisterModule(LP:GetName())