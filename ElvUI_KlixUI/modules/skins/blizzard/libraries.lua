local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleLibraries()
	if not T.IsAddOnLoaded("AddOnSkins") then return end

	local DBIcon = LibStub("LibDBIcon-1.0", true)
	if DBIcon and DBIcon.tooltip and DBIcon.tooltip:IsObjectType('GameTooltip') then
		DBIcon.tooltip:HookScript("OnShow", function(self) self:Styling() end)
	end
	
	local LQT = LibStub("LibQTip-1.0", true)
	if LQT then
		hooksecurefunc(LQT, 'Acquire', function()
			for _, Tooltip in LQT:IterateTooltips() do
				Tooltip:Styling()
			end
		end)
	end
end

S:AddCallback("KuiLibraries", styleLibraries)