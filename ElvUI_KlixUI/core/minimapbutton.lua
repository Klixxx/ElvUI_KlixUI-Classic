local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KMB = KUI:NewModule("KuiMinimapButton")
local LDB = LibStub("LibDataBroker-1.1")
local LDBI = LibStub("LibDBIcon-1.0")

local Broker_KlixUI

function KMB:IconChange()
	if Broker_KlixUI.icon == KUI.MBL then
		Broker_KlixUI.icon = KUI.MBL1
	else
		Broker_KlixUI.icon = KUI.MBL
	end
end

Broker_KlixUI = LDB:NewDataObject(KUI.Title, {
	type = "launcher",
	text = KUI.Title,
	icon = KUI.MBL,
	OnClick = function(_, button)
		if button == "LeftButton" then
			KMB:IconChange()
			KUI:DasOptions()
		elseif button == "RightButton" then
			KMB:IconChange()
			T.ReloadUI()
		end
	end,
	OnTooltipShow = function(tooltip)
		-- build the tooltip
		tooltip:ClearLines()
		tooltip:AddDoubleLine(KUI.Title, "|cfff960d9v"..KUI.Version);
		tooltip:AddLine(" ")
		
		-- hints
		tooltip:AddDoubleLine(L["Left Click"], L["Open KlixUI Config"], 1, 1, 1, 0.98, 0.38, 0.85)
		tooltip:AddDoubleLine(L["Right Click"], L["ReloadUI"], 1, 1, 1, 0.98, 0.38, 0.85)
		
		tooltip:Show()		
	end,
})

function KMB:Initialize()
	LDBI:Register(KUI.Title, Broker_KlixUI, E.db.KlixUI.general.minimap)
end

KUI:RegisterModule(KMB:GetName())