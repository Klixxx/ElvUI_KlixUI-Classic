local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local UF = E.UnitFrames

local PlayerFrame = _G.PlayerFrame

local function Reposition(classbar)
	if not E.db.unitframe.units.player.power.detachFromFrame then return end
	if E.db.KlixUI.unitframes.powerBar ~= true or E.db.unitframe.units.player.enable ~= true or E.db.unitframe.units.player.power.enable ~= true then return end
	
	if not PlayerFrame.CLASSBAR_DETACHED then
		return --No need to reposition
	end
	
	local height = (PlayerFrame.CLASSBAR_SHOWN and 20 or 31)
	if T.IsAddOnLoaded("Masque") and T.IsAddOnLoaded("Masque_KlixUI") then
		ElvUF_Player.Power:Size(244, height)
	else
		ElvUF_Player.Power:Size(245, height)
	end
end

local f = T.CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("UNIT_MODEL_CHANGED")
f:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent(event)
		PlayerFrame = ElvUF_Player --Set reference now that ElvUF_Player has been created
		hooksecurefunc(UF, "ToggleResourceBar", Reposition) --Add hook
		UF.ToggleResourceBar(ElvUF_Player.ClassPower) --Force update
	elseif event == "UPDATE_SHAPESHIFT_FORM" then
		UF.ToggleResourceBar(ElvUF_Player.ClassPower) --Force update
	elseif event == "PLAYER_LOGIN" then
		UF.ToggleResourceBar(ElvUF_Player.ClassPower) --Force update
	elseif event == "UNIT_MODEL_CHANGED" or "UNIT_PORTRAIT_CHANGED" then
		UF.ToggleResourceBar(ElvUF_Player.ClassPower) --Force update
	end
end)

