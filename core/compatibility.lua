local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local COMP = KUI:NewModule("KuiCompatibility")

function COMP:IsAddOnEnabled(addon) -- Credit: Azilroka
	return T.GetAddOnEnableState(E.myname, addon) == 2
end

-- Check other addons
COMP.BUI = KUI:IsAddOnEnabled('ElvUI_BenikUI')
COMP.LL = KUI:IsAddOnEnabled('ElvUI_LocLite')
COMP.LP = KUI:IsAddOnEnabled('ElvUI_LocPlus')
COMP.MER = KUI:IsAddOnEnabled('ElvUI_MerathilisUI')
COMP.PA = KUI:IsAddOnEnabled("ProjectAzilroka")
COMP.SLE = KUI:IsAddOnEnabled('ElvUI_SLE')

local function Disable(tbl, key)
	key = key or 'enable'
	if (tbl[key]) then
		tbl[key] = false
		return true
	end
	return false
end

-- Incompatibility print
function COMP:Print(addon, feature)
	if (E.private.KlixUI.comp and E.private.KlixUI.comp[addon] and E.private.KlixUI.comp[addon][feature]) then
		return
	end

	T.print(KUI.Title..L["has |cffff2020disabled|r "]..feature..L[" from "]..addon..L[" due to incompatiblities."])

	E.private.KlixUI.comp = E.private.KlixUI.comp or {}
	E.private.KlixUI.comp[addon] = E.private.KlixUI.comp[addon] or {}
	E.private.KlixUI.comp[addon][feature] = true
end

-- Print for disable my modules
function COMP:ModulePrint(addon, module)
	if (E.private.KlixUI.comp and E.private.KlixUI.comp[addon] and E.private.KlixUI.comp[addon][module]) then
		return
	end

	T.print(KUI.Title..L["has |cffff2020disabled|r "]..module..L[" due to incompatiblities with: "]..addon)

	E.private.KlixUI.comp = E.private.KlixUI.comp or {}
	E.private.KlixUI.comp[addon] = E.private.KlixUI.comp[addon] or {}
	E.private.KlixUI.comp[addon][module] = true
end

function COMP:BenikUICompatibility()
	local BUI = E:GetModule("BenikUI")

	if COMP.BUI and BUI then
		E:StaticPopup_Show("BUI_KUI_INCOMPATIBLE")
		return true
	end
end

function COMP:LocationPlusCompatibility()
	local LP = E:GetModule("LocationPlus")

	if COMP.LP and LP then
		E:StaticPopup_Show("LOCPLUS_KUI_INCOMPATIBLE")
		return true
	end
end

function COMP:LocationLiteCompatibility()
	local LLB = E:GetModule("LocationLite")

	if COMP.LL and LLB then
		E:StaticPopup_Show("LOCLITE_KUI_INCOMPATIBLE")
		return true
	end
end

function COMP:MerathilisUICompatibility()
	local MER = ElvUI_MerathilisUI[1]

	if COMP.MER and MER then
		E:StaticPopup_Show("MUI_KUI_INCOMPATIBLE")
		return true
	end
end

function COMP:ProjectAzilrokaCompatibility()
	if Disable(_G.ProjectAzilrokaDB, "EFL") then
		self:Print("ProjectAzilroka", "EnhancedFriendsList")
	end

	if Disable(_G.ProjectAzilrokaDB, "SMB" and E.db.KlixUI.maps.minimap.buttons) then
		self:Print("ProjectAzilroka", "SquareMinimapButtons")
	end
	
	if Disable(_G.ProjectAzilrokaDB, "stAM") then
		self:Print("ProjectAzilroka", "stAddonManager")
	end
end

function COMP:SLECompatibility()
	local SLE = ElvUI_SLE[1]

	-- Equipment Manager
	if Disable(E.private.sle["equip"]) then
		self:Print(SLE.Title, "Equipment Manager")
	end
	
	-- Location Panel
	if Disable(E.db.sle["minimap"]["locPanel"]) then
		self:Print(SLE.Title, "Location Panel")
	end

	-- Merchant
	if Disable(E.private.sle["skins"]["merchant"]) then
		self:Print(SLE.Title, "Merchant skin")
	end

	-- Minimap Buttons
	if Disable(E.private.sle["minimap"]["mapicons"]) then
		self:Print(SLE.Title, "Minimap Buttons")
	end
	
	-- Minimap Coordinates
	if Disable(E.db.sle["minimap"]["coords"]) then
		self:Print(SLE.Title, "Minimap Coordinates")
	end
	
	-- Objective Tracker
	if Disable(E.private.sle["skins"]["objectiveTracker"]) then
		self:Print(SLE.Title, "ObjectiveTracker skin")
	end
	
	-- Progression
	if Disable(E.db.sle["tooltip"]["RaidProg"]) then
		self:Print(SLE.Title, "Raid Progress")
	end
	
	-- Quest Tracker
	if Disable(E.db.sle["quests"]["visibility"]) then
		self:Print(SLE.Title, "Quest Tracker")
	end
	
	-- Raid Markers
	if Disable(E.db.sle["raidmarkers"]) then
		self:Print(SLE.Title, "Raid Markers")
	end
end

COMP.CompatibilityFunctions = {};

function COMP:RegisterCompatibilityFunction(addonName, compatFunc)
	COMP.CompatibilityFunctions[addonName] = compatFunc
end

COMP:RegisterCompatibilityFunction("BUI", "BenikUICompatibility")
COMP:RegisterCompatibilityFunction("LP", "LocationPlusCompatibility")
COMP:RegisterCompatibilityFunction("LL", "LocationLiteCompatibility")
COMP:RegisterCompatibilityFunction("MER", "MerathilisUICompatibility")
COMP:RegisterCompatibilityFunction("PA", "ProjectAzilrokaCompatibility")
COMP:RegisterCompatibilityFunction("SLE", "SLECompatibility")

function COMP:RunCompatibilityFunctions()
	for key, compatFunc in T.pairs(COMP.CompatibilityFunctions) do
		if (COMP[key]) then
			self[compatFunc](self)
		end
	end
end

function COMP:Initialize()
end

hooksecurefunc(E, "CheckIncompatible", function(self)
	COMP:RunCompatibilityFunctions()
end)

KUI:RegisterModule(COMP:GetName())