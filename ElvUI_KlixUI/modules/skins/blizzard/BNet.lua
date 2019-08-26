local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KS = KUI:GetModule("KuiSkins")
local S = E:GetModule("Skins")

local function styleBNet()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.misc ~= true then return end

	local BNToastFrame = _G.BNToastFrame
	BNToastFrame:Styling()
end

S:AddCallback("KuiBNet", styleBNet)
