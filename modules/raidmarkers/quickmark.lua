local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local QM = KUI:NewModule("QuickMark", "AceHook-3.0")

local menuFrame = T.CreateFrame("Frame", "QuickRaidMarking", E.UIParent, "UIDropDownMenuTemplate")
local menuIcon = "Interface\\Addons\\ElvUI_KlixUI\\media\\textures\\raidmarkers\\anime\\UI-RaidTargetingIcons"
local menuList = {
	{text = RAID_TARGET_NONE, notCheckable = 1, icon = "Interface\\Buttons\\UI-GroupLoot-Pass-Up",
		func = function() T.SetRaidTarget("target", 0) end},
	{text = RAID_TARGET_8, notCheckable = 1, icon = menuIcon, tCoordLeft = 0.75, tCoordRight = 1, tCoordTop = 0.25, tCoordBottom = 0.5,
		func = function() T.SetRaidTarget("target", 8) end},
	{text = "|cffff0000"..RAID_TARGET_7.."|r", notCheckable = 1, icon = menuIcon, tCoordLeft = 0.5, tCoordRight = 0.75, tCoordTop = 0.25, tCoordBottom = 0.5,
		func = function() T.SetRaidTarget("target", 7) end},
	{text = "|cff00ffff"..RAID_TARGET_6.."|r", notCheckable = 1, icon = menuIcon, tCoordLeft = 0.25, tCoordRight = 0.5, tCoordTop = 0.25, tCoordBottom = 0.5,
		func = function() T.SetRaidTarget("target", 6) end},
	{text = "|cffC7C7C7"..RAID_TARGET_5.."|r", notCheckable = 1, icon = menuIcon, tCoordLeft = 0, tCoordRight = 0.25, tCoordTop = 0.25, tCoordBottom = 0.5,
		func = function() T.SetRaidTarget("target", 5) end},
	{text = "|cff00ff00"..RAID_TARGET_4.."|r", notCheckable = 1, icon = menuIcon, tCoordLeft = 0.75, tCoordRight = 1, tCoordTop = 0, tCoordBottom = 0.25,
		func = function() T.SetRaidTarget("target", 4) end},
	{text = "|cff912CEE"..RAID_TARGET_3.."|r", notCheckable = 1, icon = menuIcon, tCoordLeft = 0.5, tCoordRight = 0.75, tCoordTop = 0, tCoordBottom = 0.25,
		func = function() T.SetRaidTarget("target", 3) end},
	{text = "|cffFF8000"..RAID_TARGET_2.."|r", notCheckable = 1, icon = menuIcon, tCoordLeft = 0.25, tCoordRight = 0.5, tCoordTop = 0, tCoordBottom = 0.25,
		func = function() T.SetRaidTarget("target", 2) end},
	{text = "|cffffff00"..RAID_TARGET_1.."|r", notCheckable = 1, icon = menuIcon, tCoordLeft = 0, tCoordRight = 0.25, tCoordTop = 0, tCoordBottom = 0.25,
		func = function() T.SetRaidTarget("target", 1) end},
}

--[[function QM:Icon()
	if E.db.KlixUI.raidmarkers.raidicons == "Classic" then
		icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcons"
	elseif E.db.KlixUI.raidmarkers.raidicons == "Anime" then
		icon = "Interface\\Addons\\ElvUI_KlixUI\\media\\textures\\raidmarkers\\anime\\UI-RaidTargetingIcons"
	elseif E.db.KlixUI.raidmarkers.raidicons == "Aurora" then
		icon = "Interface\\Addons\\ElvUI_KlixUI\\media\\textures\\raidmarkers\\aurora\\UI-RaidTargetingIcons"
	elseif E.db.KlixUI.raidmarkers.raidicons == "Myth" then
		icon = "Interface\\Addons\\ElvUI_KlixUI\\media\\textures\\raidmarkers\\myth\\UI-RaidTargetingIcon"
	end
end]]

function QM:Initialize()
	if not E.db.KlixUI.raidmarkers.quickmark.enable then return end
	
	_G.WorldFrame:HookScript("OnMouseDown", function(self, button)
		local otherkey = false;
		if E.db.KlixUI.raidmarkers.quickmark.markingButton1 == 'alt' and T.IsAltKeyDown() then
			otherkey = true
		end
		if E.db.KlixUI.raidmarkers.quickmark.markingButton1 == 'ctrl' and T.IsControlKeyDown() then
			otherkey = true
		end
		if E.db.KlixUI.raidmarkers.quickmark.markingButton1 == 'shift' and T.IsShiftKeyDown() then
			otherkey = true
		end
		
		if button ~= E.db.KlixUI.raidmarkers.quickmark.markingButton2 then
			otherkey = false
		end
		
		if otherkey and T.UnitExists("mouseover") then
			if ((T.IsInGroup() and not T.IsInRaid()) or T.UnitIsGroupLeader('player') or T.UnitIsGroupAssistant("player")) and not (inInstance and (instanceType == "pvp" or instanceType == "arena")) then
				T.EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 1)
			end
		end
	end)
end

local function InitializeCallback()
	QM:Initialize()
end

KUI:RegisterModule(QM:GetName(), InitializeCallback)