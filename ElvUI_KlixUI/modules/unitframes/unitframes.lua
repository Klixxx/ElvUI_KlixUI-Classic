local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KUF = KUI:NewModule("KuiUnits", 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
local UF = E:GetModule('UnitFrames')

function KUF:UpdateUF()
	if E.db.unitframe.units.player.enable then
		KUF:ArrangePlayer()
	end

	if E.db.unitframe.units.target.enable then
		KUF:ArrangeTarget()
	end

	if E.db.unitframe.units.party.enable then
		UF:CreateAndUpdateHeaderGroup("party")
	end
end

function KUF:Configure_ReadyCheckIcon(frame)
	local tex = frame.ReadyCheckIndicator

	if E.db.KlixUI.unitframes.icons.rdy == "Default" then
	tex.readyTexture = [[Interface\RaidFrame\ReadyCheck-Ready]]
	tex.notReadyTexture = [[Interface\RaidFrame\ReadyCheck-NotReady]]
	tex.waitingTexture = [[Interface\RaidFrame\ReadyCheck-Waiting]]
	elseif E.db.KlixUI.unitframes.icons.rdy == "BenikUI" then
    tex.readyTexture = [[Interface\AddOns\ElvUI_KlixUI\media\textures\readycheckIcons\bui-ready]]
	tex.notReadyTexture = [[Interface\AddOns\ElvUI_KlixUI\media\textures\readycheckIcons\bui-notready]]
	tex.waitingTexture = [[Interface\AddOns\ElvUI_KlixUI\media\textures\readycheckIcons\bui-waiting]]
	elseif E.db.KlixUI.unitframes.icons.rdy == "Smiley" then
	tex.readyTexture = [[Interface\AddOns\ElvUI_KlixUI\media\textures\readycheckIcons\smiley-ready]]
	tex.notReadyTexture = [[Interface\AddOns\ElvUI_KlixUI\media\textures\readycheckIcons\smiley-notready]]
	tex.waitingTexture = [[Interface\AddOns\ElvUI_KlixUI\media\textures\readycheckIcons\smiley-waiting]]
	end
end

--Credits: Darth Predator
function KUF:Configure_RaidIcon(frame)
    if E.db.KlixUI.unitframes.icons.klixri == false then return end
    local tex = frame.RaidTargetIndicator
    if tex.KlixReplace then return end
    tex.SetTexture = SetTexture

	if E.db.KlixUI.raidmarkers.raidicons == "Classic" then
		tex:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
	elseif E.db.KlixUI.raidmarkers.raidicons == "Anime" then
		tex:SetTexture([[Interface\AddOns\ElvUI_KlixUI\media\textures\raidmarkers\anime\UI-RaidTargetingIcons]])
	elseif E.db.KlixUI.raidmarkers.raidicons == "Aurora" then
		tex:SetTexture([[Interface\AddOns\ElvUI_KlixUI\media\textures\raidmarkers\aurora\UI-RaidTargetingIcons]])
	elseif E.db.KlixUI.raidmarkers.raidicons == "Myth" then
		tex:SetTexture([[Interface\AddOns\ElvUI_KlixUI\media\textures\raidmarkers\myth\UI-RaidTargetingIcons]])
	end
    tex.KlixReplace = true
    tex.SetTexture = E.noop
end

function KUF:AddShouldIAttackIcon(frame)
	if not frame then return end
	
	local tag = T.CreateFrame("Frame", nil, frame)
	
	tag.db = E.db.KlixUI.unitframes.attackicon
	
	tag:SetFrameStrata(T.string_sub(tag.db.strata or "3-MEDIUM", 3))
	tag:SetFrameLevel(tag.db.level or 12)
	tag:EnableMouse(false)
	
	tag:Size(tag.db.size or 18, tag.db.size or 18)
	tag:SetAlpha(1)

	tag.tx = tag:CreateTexture(nil, "OVERLAY")
	tag.tx:SetTexture("Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\Skull.blp")
	tag.tx:SetAllPoints()
	
	tag:RegisterEvent("PLAYER_TARGET_CHANGED")
	tag:RegisterEvent("UNIT_COMBAT")
	
	tag:SetScript("OnEvent", function()
		if tag.db.enable and not T.UnitIsDeadOrGhost("target") and T.UnitCanAttack("player", "target") and T.UnitIsTapDenied("target") then
			tag:ClearAllPoints()
			tag:SetPoint(tag.db.point or "TOPLEFT", frame, tag.db.relativePoint or "CENTER", tag.db.xOffset or 1, tag.db.yOffset or 0)
			tag:Show()
		else
			tag:Hide()
		end	
	end)
end

-- Credits: BenikUI
-- Unit Shadows
function KUF:UnitShadows()
	for _, unitName in T.pairs(UF.units) do
		local frameNameUnit = E:StringTitle(unitName)
		frameNameUnit = frameNameUnit:gsub("t(arget)", "T%1")

		local unitframe = _G["ElvUF_"..frameNameUnit]
		if unitframe then
			unitframe.Buffs.PostUpdateIcon = KUF.PostUpdateAura
			unitframe.Debuffs.PostUpdateIcon = KUF.PostUpdateAura
		end
	end
end

-- Party Shadows
function KUF:PartyShadows()
	local header = _G['ElvUF_Party']
	for i = 1, header:GetNumChildren() do
		local group = T.select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = T.select(j, group:GetChildren())
			if unitbutton then
				unitbutton.Buffs.PostUpdateIcon = KUF.PostUpdateAura
				unitbutton.Debuffs.PostUpdateIcon = KUF.PostUpdateAura
			end
		end
	end
end

-- Raid Shadows
function KUF:RaidShadows()
	local header = _G['ElvUF_Raid']

	for i = 1, header:GetNumChildren() do
		local group = T.select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = T.select(j, group:GetChildren())
			if unitbutton then
				unitbutton.Buffs.PostUpdateIcon = KUF.PostUpdateAura
				unitbutton.Debuffs.PostUpdateIcon = KUF.PostUpdateAura
			end
		end
	end
end

-- Raid-40 Shadows
function KUF:Raid40Shadows()
	local header = _G['ElvUF_Raid40']

	for i = 1, header:GetNumChildren() do
		local group = T.select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = T.select(j, group:GetChildren())
			if unitbutton then
				unitbutton.Buffs.PostUpdateIcon = KUF.PostUpdateAura
				unitbutton.Debuffs.PostUpdateIcon = KUF.PostUpdateAura
			end
		end
	end
end

-- Boss shadows
function KUF:BossShadows()
	for i = 1, 5 do
		local unitbutton = _G["ElvUF_Boss"..i]
		if unitbutton then
			unitbutton.Buffs.PostUpdateIcon = KUF.PostUpdateAura
			unitbutton.Debuffs.PostUpdateIcon = KUF.PostUpdateAura
		end
	end
end

-- Arena shadows
function KUF:ArenaShadows()
	for i = 1, 5 do
		local unitbutton = _G["ElvUF_Arena"..i]
		if unitbutton then
			unitbutton.Buffs.PostUpdateIcon = KUF.PostUpdateAura
			unitbutton.Debuffs.PostUpdateIcon = KUF.PostUpdateAura
		end
	end
end

-- Tank shadows
function KUF:TankShadows()
	for i = 1, 2 do
		local unitbutton = _G["ElvUF_TankUnitButton"..i]
		if unitbutton then
			unitbutton.Buffs.PostUpdateIcon = KUF.PostUpdateAura
			unitbutton.Debuffs.PostUpdateIcon = KUF.PostUpdateAura
		end
	end
end

function KUF:PostUpdateAura(unit, button)
	button:CreateIconShadow()

	if button.isDebuff then
		if(not button.isFriend and not button.isPlayer) then --[[and (not E.isDebuffWhiteList[name])]]
			button:SetBackdropBorderColor(0.9, 0.1, 0.1)
			button.icon:SetDesaturated((unit and not T.string_find(unit, 'arena%d')) and true or false)
		else
			local color = (button.dtype and _G.DebuffTypeColor[button.dtype]) or _G.DebuffTypeColor.none
			if button.name and (button.name == "Unstable Affliction" or button.name == "Vampiric Touch") and E.myclass ~= "WARLOCK" then
				button:SetBackdropBorderColor(0.05, 0.85, 0.94)
			else
				button:SetBackdropBorderColor(color.r * 0.6, color.g * 0.6, color.b * 0.6)
			end
			button.icon:SetDesaturated(false)
		end
	else
		if button.isStealable and not button.isFriend then
			button:SetBackdropBorderColor(0.93, 0.91, 0.55, 1.0)
		else
			button:SetBackdropBorderColor(T.unpack(E.media.unitframeBorderColor))
		end
	end

	if button.needsUpdateCooldownPosition and (button.cd and button.cd.timer and button.cd.timer.text) then
		UF:UpdateAuraCooldownPosition(button)
	end
end

function KUF:ADDON_LOADED(event, addon)
	if addon ~= "ElvUI_Config" then return end

	KUF:UnregisterEvent(event)
end

function KUF:Initialize()
	if not E.private.unitframe.enable then return end

	self:InitPlayer()
	self:InitTarget()
	self:InitPet()

	self:ChangeHealthBarTexture()

	self:UnitShadows()
	self:PartyShadows()
	self:RaidShadows()
	self:Raid40Shadows()
	self:BossShadows()
	self:ArenaShadows()
	self:TankShadows()
	
	KUF:ScheduleTimer("AddShouldIAttackIcon", 8, _G["ElvUF_Target"])
	
	hooksecurefunc(UF, "Configure_ReadyCheckIcon", KUF.Configure_ReadyCheckIcon)
	hooksecurefunc(UF, "Configure_RaidIcon", KUF.Configure_RaidIcon)
	self:RegisterEvent("ADDON_LOADED")
end

local function InitializeCallback()
	KUF:Initialize()
end

KUI:RegisterModule(KUF:GetName(), InitializeCallback)