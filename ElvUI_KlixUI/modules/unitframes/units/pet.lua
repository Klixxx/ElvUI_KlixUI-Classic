local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KUF = KUI:GetModule("KuiUnits")
local UF = E:GetModule("UnitFrames")

function KUF:Construct_PetFrame()
	local frame = _G["ElvUF_Pet"]

	self:ArrangePet()
end

function KUF:ArrangePet()
	local frame = _G["ElvUF_Pet"]
	
    frame:UpdateAllElements("KUI_UpdateAllElements")
end

function KUF:InitPet()
	if not E.db.unitframe.units.pet.enable then return end

	self:Construct_PetFrame()
end