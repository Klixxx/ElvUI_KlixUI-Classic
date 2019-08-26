local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KUF = KUI:GetModule("KuiUnits")
local UF = E:GetModule("UnitFrames")

function KUF:Construct_TargetFrame()
	local frame = _G["ElvUF_Target"]

	self:ArrangeTarget()
end

function KUF:ArrangeTarget()
	local frame = _G["ElvUF_Target"]
	local db = E.db["unitframe"]["units"].target

	if frame then
    frame:UpdateAllElements("KUI_UpdateAllElements")
	end
end

function KUF:InitTarget()
	if not E.db.unitframe.units.target.enable then return end

	self:Construct_TargetFrame()
end