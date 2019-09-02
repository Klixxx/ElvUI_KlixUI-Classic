local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleBattlenet()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.misc ~= true then return end

	local BNToastFrame = _G.BNToastFrame
	BNToastFrame:Styling()
	
	local ReportFrame = _G.PlayerReportFrame
	ReportFrame.backdrop:Styling()
	
	local ReportCheatingDialog = _G.ReportCheatingDialog
	ReportCheatingDialog.backdrop:Styling()
	
	local BattleTagInviteFrame = _G.BattleTagInviteFrame
	BattleTagInviteFrame.backdrop:Styling()
end

S:AddCallback("KuiBattlenet", styleBattlenet)