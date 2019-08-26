local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleProjectAzilroka()
	if E.private.KlixUI.skins.addonSkins.pa ~= true or not T.IsAddOnLoaded("ProjectAzilroka") then return end

	local f = T.CreateFrame("Frame")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", function(self, event)
		if event then
			local stFrame = _G["stAMFrame"]
			local StProfile = _G["stAMProfileMenu"]
			if stFrame or StProfile then
				stFrame:Styling()
				StProfile:Styling()
				stFrame.AddOns:SetTemplate("Transparent")
			end
			f:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end
	end)
end

S:AddCallbackForAddon("ProjectAzilroka", "ADDON_LOADED", styleProjectAzilroka)