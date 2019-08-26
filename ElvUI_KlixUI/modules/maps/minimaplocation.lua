local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local M = E:GetModule('Minimap')

local init = false
local cluster, panel, location, xMap, yMap
local inRestrictedArea = false

local SPACING = (E.PixelMode and 1 or 3)

local digits ={
	[0] = { .5, '%.0f' },
	[1] = { .2, '%.1f' },
	[2] = { .1, '%.2f' },
}

local function setRestricted(zone)
	if zone then
		inRestrictedArea = true
	end
	xMap.text:SetText("-")
	yMap.text:SetText("-")
	return
end

local function getPos(zone)
	local mapID = T.C_Map_GetBestMapForUnit("player")
	if not mapID then 
		setRestricted(zone)
		return 
	end
	local pos = T.C_Map_GetPlayerMapPosition(mapID, "player")
	if not pos then 
		setRestricted(zone)
		return 
	end
	inRestrictedArea = false
	return pos 
end

local function UpdateLocation(self, elapsed)
	if inRestrictedArea then return; end
	
	location.elapsed = (location.elapsed or 0) + elapsed
	if location.elapsed < digits[E.db.KlixUI.maps.minimap.topbar.locationdigits][1] then return end

	local pos = getPos()
	if not pos then return end
	xMap.pos, yMap.pos = pos:GetXY()

	xMap.text:SetFormattedText(digits[E.db.KlixUI.maps.minimap.topbar.locationdigits][2], xMap.pos * 100)
	yMap.text:SetFormattedText(digits[E.db.KlixUI.maps.minimap.topbar.locationdigits][2], yMap.pos * 100)

	location.elapsed = 0
end

local function CreateKuiMaplocation()
	cluster = _G.MinimapCluster

	panel = T.CreateFrame('Frame', 'KuiLocationPanel', _G['MinimapCluster'])
	panel:SetFrameStrata("BACKGROUND")
	panel:Point("CENTER", E.UIParent, "CENTER", 0, 0)
	panel:Size(206, 22)

	xMap = T.CreateFrame('Frame', "MapCoordinatesX", panel)
	xMap:SetTemplate('Transparent')
	xMap:Point('LEFT', panel, 'LEFT', 2, 0)
	xMap:Size(38, 22)
	xMap:Styling()
	
	xMap.text = xMap:CreateFontString(nil, "OVERLAY")
	xMap.text:FontTemplate(E.media.font, 12, "OUTLINE")
	xMap.text:SetAllPoints(xMap)

	location = T.CreateFrame('Frame', "KuiLocationText", panel)
	location:SetTemplate('Transparent')
	location:Point('CENTER', panel, 'CENTER', 0, 0)
	location:Size(126, 22)
	location:Styling()
	
	location.text = location:CreateFontString(nil, "OVERLAY")
	location.text:FontTemplate(E.media.font, 12, "OUTLINE")
	location.text:SetAllPoints(location)

	yMap = T.CreateFrame('Frame', "MapCoordinatesY", panel)
	yMap:SetTemplate('Transparent')
	yMap:Point('RIGHT', panel, 'RIGHT', -2, 0)
	yMap:Size(38, 22)
	yMap:Styling()

	yMap.text = yMap:CreateFontString(nil, "OVERLAY")
	yMap.text:FontTemplate(E.media.font, 12, "OUTLINE")
	yMap.text:SetAllPoints(yMap)	
end

hooksecurefunc(M, 'Update_ZoneText', function()
	if E.db.KlixUI.maps.minimap.topbar.locationtext == "LOCATION" then
		location.text:SetTextColor(M:GetLocTextColor())
		location.text:SetText(T.string_sub(T.GetMinimapZoneText(), 1, 25))
	elseif E.db.KlixUI.maps.minimap.topbar.locationtext == "VERSION" then
		location.text:SetText(KUI.Title.. "v"..KUI.Version)
	end

	getPos(1)
end)

hooksecurefunc(M, 'UpdateSettings', function()
	if not E.private.general.minimap.enable then return end

	if not init then
		init = true
		CreateKuiMaplocation()
	end

	local holder = _G.MMHolder
	panel:ClearAllPoints()
	if E.db.KlixUI.maps.minimap.rectangle then
		panel:SetPoint('BOTTOMLEFT', holder, 'TOPLEFT', -3, -(E.MinimapSize/8))
	else
		panel:SetPoint('BOTTOMLEFT', holder, 'TOPLEFT', -3, SPACING)
	end
	panel:Size(holder:GetWidth() + (E.PixelMode and 5 or 7), 22) 
	panel:Show()
	location:Width(holder:GetWidth() - 77)

	local point, relativeTo, relativePoint, xOfs, yOfs = holder:GetPoint()
	if E.db.general.minimap.locationText == "ABOVE" then
		holder:SetPoint(point, relativeTo, relativePoint, 0, -19)
		holder:Height(holder:GetHeight() + 22)
		panel:SetScript('OnUpdate', UpdateLocation)
		panel:Show()
	else
		holder:SetPoint(point, relativeTo, relativePoint, 0, 0)
		panel:SetScript('OnUpdate', nil)
		panel:Hide()
	end
end)
