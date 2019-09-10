local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleTimeManager()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.timemanager ~= true or E.private.KlixUI.skins.blizzard.timemanager ~= true then return end

	local TimeManagerFrame = _G.TimeManagerFrame
	if TimeManagerFrame.backdrop then
		TimeManagerFrame.backdrop:Styling()
	end

	local StopwatchFrame = _G.StopwatchFrame
	if StopwatchFrame.backdrop then
		StopwatchFrame.backdrop:Styling()
	end
end

S:AddCallbackForAddon("Blizzard_TimeManager", "KuiTimeManager", styleTimeManager)