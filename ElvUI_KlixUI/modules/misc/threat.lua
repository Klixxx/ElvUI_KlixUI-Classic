local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KT = KUI:NewModule('KuiThreat', 'AceHook-3.0')
local THREAT = E:GetModule('Threat')
local LO = E:GetModule('Layout')

function KT:UpdateThreatPosition()
	local bar = _G.ElvUI_ThreatBar
	bar:SetStatusBarTexture(E.media.Klix)
	if E.db.general.threat.position == 'RIGHTCHAT' then
		if E.db.datatexts.rightChatPanel then
			bar:SetInside(_G.RightChatDataPanel)
			bar:SetParent(_G.RightChatDataPanel)
		else
			bar:SetInside(_G.KuiDummyThreat)
			bar:SetParent(_G.KuiDummyThreat)
		end
	else
		if E.db.datatexts.leftChatPanel then
			bar:SetInside(_G.LeftChatDataPanel)
			bar:SetParent(_G.LeftChatDataPanel)
		else
			bar:SetInside(_G.KuiDummyChat)
			bar:SetParent(_G.KuiDummyChat)
		end
	end
	bar:SetFrameStrata('MEDIUM')
end

function KT:Initialize()
	self:UpdateThreatPosition()
	hooksecurefunc(LO, 'ToggleChatPanels', KT.UpdateThreatPosition)
	hooksecurefunc(THREAT, 'UpdatePosition', KT.UpdateThreatPosition)
end

local function InitializeCallback()
	KT:Initialize()
end

KUI:RegisterModule(KT:GetName(), InitializeCallback)