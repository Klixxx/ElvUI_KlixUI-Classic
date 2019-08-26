local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins");

local function styleOrderHall()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.orderhall ~= true or E.private.KlixUI.skins.blizzard.orderhall ~= true then return end


	local OrderHallTalentFrame = _G.OrderHallTalentFrame

	OrderHallTalentFrame:HookScript("OnShow", function(self)
		if self.styled then return end
		self:Styling()
		self.styled = true
	end)
end

S:AddCallbackForAddon("Blizzard_OrderHallUI", "KuiOrderHall", styleOrderHall)