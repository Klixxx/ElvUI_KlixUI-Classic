local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local function styleBattlenet()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.misc ~= true then return end

	local BNToastFrame = _G.BNToastFrame
	BNToastFrame:Styling()
	
	local ReportFrame = _G.PlayerReportFrame
	
	if ReportFrame.backdrop then
		ReportFrame.backdrop:Styling()
	end
	
	local ReportCheatingDialog = _G.ReportCheatingDialog
	if ReportCheatingDialog.backdrop then
		ReportCheatingDialog.backdrop:Styling()
	end
	
	local BattleTagInviteFrame = _G.BattleTagInviteFrame
	if BattleTagInviteFrame.backdrop then
		BattleTagInviteFrame.backdrop:Styling()
	end
end

S:AddCallback("KuiBattlenet", styleBattlenet)