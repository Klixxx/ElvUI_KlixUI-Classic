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
f:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
f:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("UNIT_ENTERED_VEHICLE")
f:RegisterEvent("UNIT_ENTERING_VEHICLE")
f:RegisterEvent("UNIT_EXITED_VEHICLE")
f:RegisterEvent("UNIT_EXITING_VEHICLE")
f:RegisterEvent("PLAYER_GAINS_VEHICLE_DATA")
f:RegisterEvent("PLAYER_LOSES_VEHICLE_DATA")
f:RegisterEvent("UNIT_MODEL_CHANGED")
f:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent(event)
		PlayerFrame = ElvUF_Player --Set reference now that ElvUF_Player has been created
		hooksecurefunc(UF, "ToggleResourceBar", Reposition) --Add hook
		UF.ToggleResourceBar(ElvUF_Player.ClassPower) --Force update
	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
		UF.ToggleResourceBar(ElvUF_Player.ClassPower) --Force update
	elseif event == "UPDATE_SHAPESHIFT_FORM" then
		UF.ToggleResourceBar(ElvUF_Player.ClassPower) --Force update
	elseif event == "PLAYER_LOGIN" then
		UF.ToggleResourceBar(ElvUF_Player.ClassPower) --Force update
	elseif event == "UNIT_ENTERED_VEHICLE" or "UNIT_ENTERING_VEHICLE" or "UNIT_EXITED_VEHICLE" or "UNIT_EXITING_VEHICLE" then
		UF.ToggleResourceBar(ElvUF_Player.ClassPower) --Force update
	elseif event == "PLAYER_GAINS_VEHICLE_DATA" or "PLAYER_LOSES_VEHICLE_DATA" then
		UF.ToggleResourceBar(ElvUF_Player.ClassPower) --Force update
	elseif event == "UNIT_MODEL_CHANGED" or "UNIT_PORTRAIT_CHANGED" then
		UF.ToggleResourceBar(ElvUF_Player.ClassPower) --Force update
	end
end)

