local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KUF = KUI:GetModule("KuiUnits")
local UF = E:GetModule("UnitFrames")

function KUF:Construct_PlayerFrame()
	local frame = _G["ElvUF_Player"]

	self:ArrangePlayer()
end

function KUF:ArrangePlayer()
	local frame = _G["ElvUF_Player"]
	local db = E.db["unitframe"]["units"].player

    frame:UpdateAllElements("KUI_UpdateAllElements")
end

function KUF:InitPlayer()
	if not E.db.unitframe.units.player.enable then return end

	self:Construct_PlayerFrame()
end