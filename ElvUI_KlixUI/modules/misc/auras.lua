local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local A = E:GetModule("Auras")

if E.private.auras.enable ~= true then return end

-- Create styling for the auras
A.CreateIconKui = A.CreateIcon
function A:CreateIcon(button)
	self:CreateIconKui(button)
	if not button.ishadow then
		button:CreateIconShadow()
	end
end