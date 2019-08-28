local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KSR = KUI:NewModule("KuiSoloReminder", "AceEvent-3.0", "AceTimer-3.0")
local S = E:GetModule("Skins")
local LCG = LibStub('LibCustomGlow-1.0')

_Reminder = KSR
_CreatedReminders = {}

function KSR:PlayerHasFilteredBuff(frame, db, checkPersonal)
	for buff, value in T.pairs(db) do
		if value == true then
			local name = T.GetSpellInfo(buff)
			local _, icon, _, _, _, _, unitCaster, _, _, _ = T.AuraUtil_FindAuraByName(name, "player", "HELPFUL")

			if checkPersonal then
				if (name and icon and unitCaster == "player") then
					return true
				end
			else
				if (name and icon) then
					return true
				end
			end
		end
	end
	return false
end

function KSR:PlayerHasFilteredDebuff(frame, db)
	for debuff, value in T.pairs(db) do
		if value == true then
			local name = T.GetSpellInfo(debuff)
			local _, icon, _, _, _, _, unitCaster, _, _, _ = T.AuraUtil_FindAuraByName(name, "player", "HAKSRFUL")

			if (name and icon) then
				return true
			end
		end
	end
	return false
end

function KSR:CanSpellBeUsed(id)
	local name = T.GetSpellInfo(id)
	local start, duration, enabled = T.GetSpellCooldown(name)
	if enabled == 0 or start == nil or duration == nil then
		return false
	elseif start > 0 and duration > 1.5 then	--On Cooldown
		return false
	else --Off Cooldown
		return true
	end
end

function KSR:ReminderIcon_OnUpdate(elapsed)
	if self.ForceShow and self.icon:GetTexture() then return; end
	if(self.elapsed and self.elapsed > 0.2) then
		local db = KUI.ReminderList[E.myclass][self.groupName]
		if not db or not db.enable or T.UnitIsDeadOrGhost("player") then return; end
		if db.CDSpell then
			local filterCheck = KSR:FilterCheck(self)
			local name = T.GetSpellInfo(db.CDSpell)
			local start, duration, enabled = T.GetSpellCooldown(name)
			if(duration and duration > 0) then
				self.cooldown:SetCooldown(start, duration)
				self.cooldown:Show()
			else
				self.cooldown:Hide()
			end

			if KSR:CanSpellBeUsed(db.CDSpell) and filterCheck then
				if db.OnCooldown == "HIDE" then
					KSR:UpdateColors(self, db.CDSpell)
					KSR.ReminderIcon_OnEvent(self)
				else
					self:SetAlpha(db.cdFade or 0)
				end
			elseif filterCheck then
				if db.OnCooldown == "HIDE" then
					self:SetAlpha(db.cdFade or 0)
				else
					KSR:UpdateColors(self, db.CDSpell)
					KSR.ReminderIcon_OnEvent(self)
				end
			else
				self:SetAlpha(0)
			end

			self.elapsed = 0
			return
		end

		if db.spellGroup then
			for buff, value in T.pairs(db.spellGroup) do
				if value == true and KSR:CanSpellBeUsed(buff) then
					self:SetScript("OnUpdate", nil)
					KSR.ReminderIcon_OnEvent(self)
				end
			end
		end

		self.elapsed = 0
	else
		self.elapsed = (self.elapsed or 0) + elapsed
	end
end

function KSR:FilterCheck(frame, isReverse)
	local _, instanceType = T.IsInInstance()
	local roleCheck, treeCheck, combatCheck, instanceCheck, PVPCheck, talentCheck

	local db = KUI.ReminderList[E.myclass][frame.groupName]

	if db.role then
		if db.role == E:GetPlayerRole() or db.role == "ANY" then
			roleCheck = true
		else
			roleCheck = nil
		end
	else
		roleCheck = true
	end

	if db.tree then
		if db.tree == T.GetSpecialization() or db.tree == "ANY" then
			treeCheck = true
		else
			treeCheck = nil
		end
	else
		treeCheck = true
	end

	if db.combat then
		if T.InCombatLockdown() then
			combatCheck = true
		else
			combatCheck = nil
		end
	else
		combatCheck = true
	end

	if db.instance and (instanceType == "party" or instanceType == "raid") then
		instanceCheck = true
	else
		instanceCheck = nil
	end

	if db.pvp and (instanceType == "arena" or instanceType == "pvp") then
		PVPCheck = true
	else
		PVPCheck = nil
	end

	if not db.pvp and not db.instance then
		PVPCheck = true
		instanceCheck = true
	end

	if isReverse and (combatCheck or instanceCheck or PVPCheck) then
		return true
	elseif roleCheck and treeCheck and (combatCheck or instanceCheck or PVPCheck) then
		return true
	else
		return false
	end
end

function KSR:ReminderIcon_OnEvent(event, unit)
	if (event == "UNIT_AURA" and unit ~= "player") then return end

	local db = KUI.ReminderList[E.myclass][self.groupName]

	self.cooldown:Hide()
	self:SetAlpha(0)
	self.icon:SetTexture(nil)

	if not db or not db.enable or (not db.spellGroup and not db.weaponCheck and not db.CDSpell) or T.UnitIsDeadOrGhost("player") then
		self:SetScript("OnUpdate", nil)
		self:SetAlpha(0)
		self.icon:SetTexture(nil)

		if not db then
			_CreatedReminders[self.groupName] = nil
		end
		return
	end

	--Level Check
	if db.level and T.UnitLevel("player") < db.level and not self.ForceShow then return end

	--Negate Spells Check
	if db.negateGroup and KSR:PlayerHasFilteredBuff(self, db.negateGroup) and not self.ForceShow then return end

	local hasOffhandWeapon = T.C_PaperDollInfo_OffhandHasWeapon()
	local hasMainHandEnchant, _, _, hasOffHandEnchant, _, _ = T.GetWeaponEnchantInfo()
	local hasBuff, hasDebuff
	if db.spellGroup and not db.CDSpell then
		for buff, value in T.pairs(db.spellGroup) do
			if value == true then
				local name = T.GetSpellInfo(buff)
				local usable, nomana = T.IsUsableSpell(name)
				if usable and not KSR:CanSpellBeUsed(buff) then
					self:SetScript("OnUpdate", KSR.ReminderIcon_OnUpdate)
					return
				end

				if (usable or nomana) or not db.strictFilter or self.ForceShow then
					self.icon:SetTexture(T.select(3, T.GetSpellInfo(db.spellGroup.defaultIcon)))
					break
				end
			end
		end

		if (not self.icon:GetTexture() and event == "PLAYER_ENTERING_WORLD") then
			self:UnregisterAllEvents()
			self:RegisterEvent("UNIT_AURA")
			self:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
			if db.combat then
				self:RegisterEvent("PLAYER_REGEN_ENABLED")
				self:RegisterEvent("PLAYER_REGEN_DISABLED")
			end

			if db.instance or db.pvp then
				self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
			end

			if db.role then
				self:RegisterEvent("UNIT_INVENTORY_CHANGED")
			end
			return
		end

		hasBuff, hasDebuff = KSR:PlayerHasFilteredBuff(self, db.spellGroup, db.personal), KSR:PlayerHasFilteredDebuff(self, db.spellGroup)
	end

	if db.weaponCheck then
		self:UnregisterAllEvents()
		self:RegisterEvent("UNIT_INVENTORY_CHANGED")

		if not hasOffhandWeapon and hasMainHandEnchant then
			self.icon:SetTexture(T.GetInventoryItemTexture("player", 16))
		else
			if not hasOffHandEnchant then
				self.icon:SetTexture(T.GetInventoryItemTexture("player", 17))
			end

			if not hasMainHandEnchant then
				self.icon:SetTexture(T.GetInventoryItemTexture("player", 16))
			end
		end

		if db.combat then
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
			self:RegisterEvent("PLAYER_REGEN_DISABLED")
		end

		if db.instance or db.pvp then
			self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		end

		if db.role then
			self:RegisterEvent("UNIT_INVENTORY_CHANGED")
		end
	end

	if db.CDSpell then
		if T.type(db.CDSpell) == "boolean" then return end
		local name = T.GetSpellInfo(db.CDSpell)
		local usable, nomana = T.IsUsableSpell(name)
		if not usable then return end

		self:SetScript("OnUpdate", KSR.ReminderIcon_OnUpdate)

		self.icon:SetTexture(T.select(3, T.GetSpellInfo(db.CDSpell)))

		self:UnregisterAllEvents()
	end

	if self.ForceShow and self.icon:GetTexture() then
		self:SetAlpha(1)
		return
	elseif self.ForceShow then
		KUI:Print("Attempted to show a reminder icon that does not have any spells. You must add a spell first.")
		return
	end

	if not self.icon:GetTexture() then return end

	local filterCheck = KSR:FilterCheck(self)
	local reverseCheck = KSR:FilterCheck(self, true)

	if db.CDSpell then
		if filterCheck then
			self:SetAlpha(1)
		end
		return
	end

	if db.spellGroup and not db.weaponCheck then
		if filterCheck and ((not hasBuff) and (not hasDebuff)) and not db.reverseCheck then
			self:SetAlpha(1)
		elseif reverseCheck and db.reverseCheck and (hasBuff or hasDebuff) then
			self:SetAlpha(1)
		elseif reverseCheck and db.reverseCheck and ((not hasBuff) and (not hasDebuff)) then
			self:SetAlpha(1)
		end
	elseif db.weaponCheck then
		if filterCheck then
			if not hasOffhandWeapon and not hasMainHandEnchant then
				self:SetAlpha(1)
				self.icon:SetTexture(T.GetInventoryItemTexture("player", 16))
			elseif hasOffhandWeapon and (not hasMainHandEnchant or not hasOffHandEnchant) then
				if not hasMainHandEnchant then
					self.icon:SetTexture(T.GetInventoryItemTexture("player", 16))
				else
					self.icon:SetTexture(T.GetInventoryItemTexture("player", 17))
				end
				self:SetAlpha(1)
			end
		end
	end

	local r, g, b = T.unpack(E["media"].rgbvaluecolor)
	local color = {r, g, b, 1}
	if self:GetAlpha() == 1 and KSR.db.glow then
		LCG.PixelGlow_Start(self.overlay, color, nil, -0.25, nil, 1)
	else
		LCG.PixelGlow_Stop(self.overlay)
	end
end

function KSR:CreateReminder(name, index)
	if _CreatedReminders[name] then return end

	local frame = T.CreateFrame("Button", "KUI_ReminderIcon"..index, E.UIParent)
	frame:Size(KSR.db.size or (_G["ElvUF_Player"]:GetHeight() - 4))
	frame:SetFrameStrata(KSR.db.strata or "LOW")
	frame.groupName = name
	if _G["ElvUF_Pet"]:IsShown() then
		frame:SetPoint("BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 445, 282)
	else
		frame:SetPoint("BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 537, 282)
	end
	E:CreateMover(frame, "KUI_ReminderMover", L["Reminders"], nil, nil, nil, "ALL,SOLO,KLIXUI", nil, 'KlixUI,modules,reminder')

	frame.icon = frame:CreateTexture(nil, "OVERLAY")
	frame.icon:SetAllPoints()
	frame.icon:CreateBackdrop()
	S:HandleIcon(frame.icon)
	frame:EnableMouse(false)
	frame:SetAlpha(0)

	-- Used for Glow
	frame.overlay = T.CreateFrame("Button", nil, frame)
	frame.overlay:CreateIconShadow()
	frame.overlay:SetOutside(frame, 0, 0)
	frame.overlay:EnableMouse(false)

	local cd = T.CreateFrame("Cooldown", nil, frame)
	cd:SetAllPoints(frame.icon)
	E:RegisterCooldown(cd)
	frame.cooldown = cd

	frame:RegisterUnitEvent("UNIT_AURA", "player")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:SetScript("OnEvent", KSR.ReminderIcon_OnEvent)

	_CreatedReminders[name] = frame
end

function KSR:CheckForNewReminders()
	local db = KUI.ReminderList[E.myclass]
	if not db then return end

	local index = 0
	for groupName, _ in pairs(db) do
		index = index + 1
		self:CreateReminder(groupName, index)
	end
end

function KSR:Initialize()
	if not E.private.unitframe.enable or not E.db.KlixUI.reminder.solo.enable then return end
	
	KSR.db = E.db.KlixUI.reminder.solo

	self:CheckForNewReminders()
	T.C_Timer_After(1, function() KSR.initialized = true end)
end

local function InitializeCallback()
	KSR:Initialize()
end

KUI:RegisterModule(KSR:GetName(), InitializeCallback)