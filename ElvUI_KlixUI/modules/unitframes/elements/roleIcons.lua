local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KUF = KUI:GetModule('KuiUnits')
local UF = E:GetModule('UnitFrames')

--Role icons
KUI.rolePaths = {
	["ElvUI"] = {
		TANK = [[Interface\AddOns\ElvUI\media\textures\tank]],
		HEALER = [[Interface\AddOns\ElvUI\media\textures\healer]],
		DAMAGER = [[Interface\AddOns\ElvUI\media\textures\dps]]
	},
	["SupervillainUI"] = {
		TANK = [[Interface\AddOns\ElvUI_KlixUI\media\textures\roleIcons\svui-tank]],
		HEALER = [[Interface\AddOns\ElvUI_KlixUI\media\textures\roleIcons\svui-healer]],
		DAMAGER = [[Interface\AddOns\ElvUI_KlixUI\media\textures\roleIcons\svui-dps]]
	},
	["Blizzard"] = {
		TANK = [[Interface\AddOns\ElvUI_KlixUI\media\textures\roleIcons\blizz-tank]],
		HEALER = [[Interface\AddOns\ElvUI_KlixUI\media\textures\roleIcons\blizz-healer]],
		DAMAGER = [[Interface\AddOns\ElvUI_KlixUI\media\textures\roleIcons\blizz-dps]]
	},
	["MiirGui"] = {
		TANK = [[Interface\AddOns\ElvUI_KlixUI\media\textures\roleIcons\mg-tank]],
		HEALER = [[Interface\AddOns\ElvUI_KlixUI\media\textures\roleIcons\mg-healer]],
		DAMAGER = [[Interface\AddOns\ElvUI_KlixUI\media\textures\roleIcons\mg-dps]]
	},
	["Lyn"] = {
		TANK = [[Interface\AddOns\ElvUI_KlixUI\media\textures\roleIcons\lyn-tank]],
		HEALER = [[Interface\AddOns\ElvUI_KlixUI\media\textures\roleIcons\lyn-healer]],
		DAMAGER = [[Interface\AddOns\ElvUI_KlixUI\media\textures\roleIcons\lyn-dps]]
	},
}

local specNameToRole = {}
for i = 1, T.GetNumClasses() do
	local _, class, classID = T.GetClassInfo(i)
	specNameToRole[class] = {}
	for j = 1, T.GetNumSpecializationsForClassID(classID) do
		local _, spec, _, _, _, role = T.GetSpecializationInfoForClassID(classID, j)
		specNameToRole[class][spec] = role
	end
end

local function GetBattleFieldIndexFromUnitName(name)
	local nameFromIndex
	for index = 1, T.GetNumBattlefieldScores() do
		nameFromIndex = T.GetBattlefieldScore(index)
		if nameFromIndex == name then
			return index
		end
	end
	return nil
end

function KUF:UpdateRoleIcon()
	local lfdrole = self.GroupRoleIndicator
	if not self.db then return; end
	local db = self.db.roleIcon;
	if (not db) or (db and not db.enable) then
		lfdrole:Hide()
		return
	end

	local isInstance, instanceType = T.IsInInstance()
	local role
	if isInstance and instanceType == "pvp" then
		local name = T.GetUnitName(self.unit, true)
		local index = GetBattleFieldIndexFromUnitName(name)
		if index then
		local _, _, _, _, _, _, _, _, classToken, _, _, _, _, _, _, talentSpec = T.GetBattlefieldScore(index)
			if classToken and talentSpec then
				role = specNameToRole[classToken][talentSpec]
			else
				role = T.UnitGroupRolesAssigned(self.unit) --Fallback
			end
		else
			role = T.UnitGroupRolesAssigned(self.unit) --Fallback
		end
	else
		role = T.UnitGroupRolesAssigned(self.unit)
		if self.isForced and role == 'NONE' then
		local rnd = T.math_random(1, 3)
			role = rnd == 1 and "TANK" or (rnd == 2 and "HEALER" or (rnd == 3 and "DAMAGER"))
		end
	end
	if (self.isForced or T.UnitIsConnected(self.unit)) and ((role == "DAMAGER" and db.damager) or (role == "HEALER" and db.healer) or (role == "TANK" and db.tank)) then
		lfdrole:SetTexture(KUI.rolePaths[E.db.KlixUI.unitframes.icons.role][role])
		lfdrole:Show()
		lfdrole:Show()
	else
		lfdrole:Hide()
	end
end

local function SetRoleIcons()
	for _, header in T.pairs(UF.headers) do
		local name = header.groupName

		for i = 1, header:GetNumChildren() do
			local group = T.select(i, header:GetChildren())
			for j = 1, group:GetNumChildren() do
				local unitbutton = T.select(j, group:GetChildren())
				if unitbutton.GroupRoleIndicator and unitbutton.GroupRoleIndicator.Override then
					unitbutton.GroupRoleIndicator.Override = KUF.UpdateRoleIcon
					unitbutton:UnregisterEvent("UNIT_CONNECTION")
					unitbutton:RegisterEvent("UNIT_CONNECTION", KUF.UpdateRoleIcon)
				end
			end
		end
	end
	UF:UpdateAllHeaders()
end

local f = T.CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent(event)
	
	SetRoleIcons()
end)