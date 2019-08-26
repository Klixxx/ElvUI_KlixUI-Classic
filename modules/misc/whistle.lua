-------------------------------------------------------------------------------
-- Credits: WhistledAway - Dethanyel
-------------------------------------------------------------------------------
local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local WM = KUI:NewModule("WhistleMaster", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
local HBD = LibStub("HereBeDragons-2.0")
local HBDPins = LibStub("HereBeDragons-Pins-2.0")


local match, find = string.match, string.find
local FlightPointDataProviderMixin, Enum, WorldMapFrame, GameTooltip = _G.FlightPointDataProviderMixin, _G.Enum, _G.WorldMapFrame, _G.GameTooltip
local BACKPACK_CONTAINER, NUM_BAG_SLOTS = _G.BACKPACK_CONTAINER, _G.NUM_BAG_SLOTS

-- Flight Master's Whistle Item ID
WM.FMW_ID = 141605

-- Continents where the FMW can be used
WM.SupportedZones = {
  -- Legion
  [630] = { name = "Azsuna", reqLevel = 110 },
  [634] = { name = "Stormheim", reqLevel = 110 },
  [641] = { name = "Val'sharah", reqLevel = 110 },
  [646] = { name = "Broken Shore", reqLevel = 110 },
  [650] = { name = "Highmountain", reqLevel = 110 },
  [680] = { name = "Suramar", reqLevel = 110 },
  [830] = { name = "Krokuun", reqLevel = 110 },
  [882] = { name = "Mac'Aree", reqLevel = 110 },
  [885] = { name = "Antoran Wastes", reqLevel = 110 },

  -- BFA
  [862] = { name = "Zuldazar", reqLevel = 120 },
  [863] = { name = "Nazmir", reqLevel = 120 },
  [864] = { name = "Vol'dun", reqLevel = 120 },
  [895] = { name = "Tiragarde Sound", reqLevel = 120 },
  [896] = { name = "Drustvar", reqLevel = 120 },
  [942] = { name = "Stormsong Valley", reqLevel = 120 },
  [1355] = { name = "Nazjatar", reqLevel = 120 },
  [1462] = { name = "Mechagon Island", reqLevel = 120 }
}

-- Variables
local currentMapID = -1     -- map where the player is, such as Boralus
local currentZoneMapID = -1 -- map of the actual zone, such as Tiragarde Sound
local playerHasWhistle = false
local pinsNeedUpdate = false
local taxiNodeCache = {}
local nearestTaxis = {}

local whistleMaster = T.CreateFrame("Frame", KUI.Title.."WhistleMaster")

local function colorText(s)
  return T.string_format("|cfff960d9%s|r", s)
end

-- Returns true if the player can use the flight master's whistle.
local function whistleCanBeUsed()
  local zoneInfo = currentZoneMapID and WM.SupportedZones[currentZoneMapID]
  return
    playerHasWhistle and
    not T.IsIndoors() and
    zoneInfo and
    zoneInfo.reqLevel <= T.UnitLevel("PLAYER")
end

local timer = 0
local function OnUpdateHandler(whistleMaster, elapsed)
    timer = timer + elapsed
    if (timer >= 1) then
      WM:UpdateTaxis()
      timer = 0
    end
    WM:UpdatePins()
end
whistleMaster:SetScript("OnUpdate", OnUpdateHandler)

function WM:BAG_UPDATE()
	for bag = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
        for slot = 1, T.GetContainerNumSlots(bag) do
			local itemID = T.GetContainerItemID(bag, slot)
			if itemID and (itemID == WM.FMW_ID) then
				playerHasWhistle = true
				return
			end
        end
	end
	playerHasWhistle = false
end

function WM:HereBeDragonsCall()
  -- Ignore nodes with these textureKitPrefix entries
  local TEXTURE_KIT_PREFIX_IGNORE = {
    FlightMaster_Ferry = true
  }

	-- Returns the map info of the parent zone based on a uiMapID.
	local function getZoneMapInfo(uiMapID)
    local mapInfo = T.C_Map_GetMapInfo(uiMapID)
    if not mapInfo then return end

    -- Return if current map will not have a parent zone
    if (mapInfo.mapType < Enum.UIMapType.Zone) then return end

    -- Crawl back through maps to get parent zone
    while mapInfo.mapType >= Enum.UIMapType.Zone do
      local parentInfo = T.C_Map_GetMapInfo(mapInfo.parentMapID)
      if not parentInfo then return end

      -- break if parent map is < zone type
      if parentInfo.mapType >= Enum.UIMapType.Zone then
        mapInfo = parentInfo
      else
        break
      end
    end

    if mapInfo.mapType == Enum.UIMapType.Zone then return mapInfo end
  end

  local function updateTaxiNodeCache(mapInfo)
    local nodes = T.C_TaxiMap_GetTaxiNodesForMap(mapInfo.mapID)
    if not nodes or (#nodes == 0) then return end

    local factionGroup = T.UnitFactionGroup("PLAYER")

    for _, node in T.next, nodes do
      if FlightPointDataProviderMixin:ShouldShowTaxiNode(factionGroup, node) then
        if
          -- Only add nodes in the current zone
          node.name:find(mapInfo.name, 1, true) and
          -- Ignore nodes with certain textureKitPrefix entries
          not TEXTURE_KIT_PREFIX_IGNORE[node.textureKitPrefix]
        then
          taxiNodeCache[#taxiNodeCache+1] = node
        end
      end
    end
  end

  -- HBD Callback
  HBD.RegisterCallback(WM, "PlayerZoneChanged", function(_, mapID)
    for k in next, taxiNodeCache do taxiNodeCache[k] = nil end
    for k in next, nearestTaxis do nearestTaxis[k] = nil end

    if not mapID then return end
    currentMapID = mapID

    local mapInfo = getZoneMapInfo(mapID)
    if not mapInfo then return end

    -- Return if zone not supported
    if not WM.SupportedZones[mapInfo.mapID] then return end
    currentZoneMapID = mapInfo.mapID

    updateTaxiNodeCache(mapInfo)
  end)
end

-- ============================================================================
-- Pin Pool
-- ============================================================================

local getPin, clearPins, hidePins do
  local TITLE = colorText(KUI.Title)
  local FMW_TEXTURE_ID = "Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\whistle"
  local pins = {}
  local pool = {}
  local count = 0

  local function onEnter(self)
	--[[if E.db.KlixUI.maps.worldmap.flightQ then
		self:EnableMouse(false)
	else]]
		-- Show highlight
		self.highlight:SetAlpha(0.4)
		-- Show tooltip
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(TITLE)
		GameTooltip:AddLine(self.name, 1, 1, 1)
		GameTooltip:Show()
	--end
  end

  local function onLeave(self)
    self.highlight:SetAlpha(0)
    GameTooltip:Hide()
  end

  getPin = function(name)
    local pin = T.next(pool)
    
    if pin then
      pool[pin] = nil
    else
      count = count + 1
      pin = T.CreateFrame("Button", KUI.Title.."Pin"..count, WorldMapFrame)
      pin:SetSize(25, 25)
	  
	  --[[if E.db.KlixUI.maps.worldmap.flightQ then
		pin:SetFrameStrata("HIGH")
	  end]]

      pin.texture = pin:CreateTexture(KUI.Title.."PinTexture"..count, "BACKGROUND")
      pin.texture:SetTexture(FMW_TEXTURE_ID)
      pin.texture:SetAllPoints()

      pin.highlight = pin:CreateTexture(pin:GetName().."Hightlight", "HIGHLIGHT")
      pin.highlight:SetTexture(FMW_TEXTURE_ID)
      pin.highlight:SetBlendMode("ADD")
      pin.highlight:SetAlpha(0)
      pin.highlight:SetAllPoints(pin.texture)

      pin:SetScript("OnEnter", onEnter)
      pin:SetScript("OnLeave", onLeave)

      pins[#pins+1] = pin
    end

    pin.name = name
    pin:Show()
    return pin
  end

  clearPins = function()
    for _, pin in T.next, pins do
      pin:Hide()
      pool[pin] = true
    end
    HBDPins:RemoveAllWorldMapIcons(WM)
  end

  hidePins = function()
    for _, pin in T.next, pins do pin:Hide() end
  end
end

-- ============================================================================
-- General Functions
-- ============================================================================

function WM:UpdateTaxis()
  local THRESHOLD = 40 -- yards
  local last_x, last_y = -1, -1
  
	if not whistleCanBeUsed() then
		for k in T.next, nearestTaxis do nearestTaxis[k] = nil end
	return
	end

    local x, y, mapID = HBD:GetPlayerZonePosition()
    if not (x and y and mapID) then return end

    -- Return if player hasn't moved
    if (last_x == x) and (last_y == y) then return end
    last_x, last_y = x, y

    -- Clear data
    for k in T.next, nearestTaxis do nearestTaxis[k] = nil end

    -- If no taxis, return
    if (#taxiNodeCache == 0) then return end

    -- Calculate nearest taxis
    local currentNearest = taxiNodeCache[1]
    local currentDistance = HBD:GetZoneDistance(
      currentMapID,
      x,
      y,
      currentZoneMapID,
      currentNearest.position.x,
      currentNearest.position.y
    )
    nearestTaxis[1] = currentNearest

    for i = 2, #taxiNodeCache do
      local taxi = taxiNodeCache[i]
      local distance = HBD:GetZoneDistance(
        currentMapID,
        x,
        y,
        currentZoneMapID,
        taxi.position.x,
        taxi.position.y
      )

      -- If closer outside threshold
      if (distance <= (currentDistance - THRESHOLD)) then -- wipe and add
        for k in T.next, nearestTaxis do nearestTaxis[k] = nil end
        nearestTaxis[#nearestTaxis+1] = taxi
        currentDistance = distance
      -- If within threshold
      elseif (distance <= (currentDistance + THRESHOLD)) then -- add
        nearestTaxis[#nearestTaxis+1] = taxi
      end
    end

    clearPins()
    pinsNeedUpdate = true
end

function WM:UpdatePins()
  if not whistleCanBeUsed() then clearPins() return end
  if not WorldMapFrame:IsVisible() then hidePins() return end
  if not pinsNeedUpdate then return end
  pinsNeedUpdate = false

  -- Add pins to map
  for _, taxi in T.next, nearestTaxis do
    HBDPins:AddWorldMapIconMap(
      WM,
      getPin(taxi.name),
      currentZoneMapID,
      taxi.position.x,
      taxi.position.y
    )
  end
end

-- ============================================================================
-- Tooltip Hook
-- ============================================================================

local LEFT_TEXT = colorText("|cfff960d9The nearest flightmaster is:|r")
local DELIMITER = colorText(" | ")
local taxiNameBuffer = {}

local function sortFunc(a, b) return a.name < b.name end

-- "Tradewinds Market, Tiragarde Sound" -> "Tradewinds Market"
local function getTaxiName(taxi)
  local name = taxi.name:match("(.+),")
  return name or taxi.name
end

local function getTaxiNames()
  if (#nearestTaxis == 1) then return getTaxiName(nearestTaxis[1]) end
  T.table_sort(nearestTaxis, sortFunc)
  for k in T.next, taxiNameBuffer do taxiNameBuffer[k] = nil end
  for i=1, #nearestTaxis do
    taxiNameBuffer[#taxiNameBuffer+1] = getTaxiName(nearestTaxis[i])
  end
  return T.table_concat(taxiNameBuffer, DELIMITER)
end

local function onTooltipSetItem(self)
  if (#nearestTaxis == 0) or not whistleCanBeUsed() then return end

  -- Verify the item is the Flight Master's Whistle
  local _, link = self:GetItem()
  if not link then return end
  local id = T.tonumber(link:match("item:(%d+)") or "")
  if not id or (id ~= WM.FMW_ID) then return end

  self:AddLine(" ") -- Blank Line
  self:AddDoubleLine(
    LEFT_TEXT,
    getTaxiNames(),
    1, 1, 1,
    1, 1, 1
  )
end
GameTooltip:HookScript("OnTooltipSetItem", onTooltipSetItem)

function WM:Initialize()
	if not E.db.KlixUI.misc.whistleLocation or T.IsAddOnLoaded("WhistledAway") then return end
	
	WM:BAG_UPDATE()
	WM:HereBeDragonsCall()
	WM:UpdateTaxis()
	WM:UpdatePins()
	
	WM:RegisterEvent("BAG_UPDATE")
end

KUI:RegisterModule(WM:GetName())
