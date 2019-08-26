local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleTimeManager()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.timemanager ~= true or E.private.KlixUI.skins.blizzard.timemanager ~= true then return end

	local TimeManagerFrame = _G.TimeManagerFrame
	TimeManagerFrame:Styling()

	local StopwatchFrame = _G.StopwatchFrame
	StopwatchFrame:Styling()
end

S:AddCallbackForAddon("Blizzard_TimeManager", "KuiTimeManager", styleTimeManager)