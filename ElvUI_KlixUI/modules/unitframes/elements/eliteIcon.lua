local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KEI = KUI:NewModule("KuiEliteIcon", "AceEvent-3.0")

function KEI:SetEliteIcon()
	self.frame:SetSize(KEI.db.size or 18, KEI.db.size or 18)
	self.frame.Texture:SetTexture("Interface\\TARGETINGFRAME\\Nameplates")
	local c = T.UnitClassification("target")
	if c == 'elite' or c == "worldboss" then
		self.frame.Texture:Show()
		self.frame.Texture:SetAtlas("nameplates-icon-elite-gold")
	elseif c == 'rareelite' or c == 'rare' then
		self.frame.Texture:Show()
		self.frame.Texture:SetAtlas("nameplates-icon-elite-silver")
	else
		self.frame.Texture:Hide()
	end
	
	if _G["ElvUF_Target"] then
		self.frame:ClearAllPoints()
		self.frame:SetPoint(KEI.db.point or "CENTER", _G["ElvUF_Target"].Health, KEI.db.relativePoint or "TOPRIGHT", KEI.db.xOffset or -1, KEI.db.yOffset or 0)
		self.frame:SetParent("ElvUF_Target")
		self.frame:SetFrameStrata(T.string_sub(KEI.db.strata or "3-MEDIUM", 3))
		self.frame:SetFrameLevel(KEI.db.level or 12)
	end
end

function KEI:Initialize()
	if not E.db.KlixUI.unitframes.eliteicon.enable then return end
	
	KEI.db = E.db.KlixUI.unitframes.eliteicon
	
	local frame = T.CreateFrame("Frame", "EliteIconFrame", E.UIParent)
	frame.Texture = frame:CreateTexture(nil, "OVERLAY")
	frame.Texture:SetAllPoints()
	KEI.frame = frame
	
	KEI:RegisterEvent("PLAYER_TARGET_CHANGED", "SetEliteIcon")
end

KUI:RegisterModule(KEI:GetName())