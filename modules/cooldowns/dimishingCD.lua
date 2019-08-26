local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local DR = KUI:NewModule('DimishingReturns', "AceConsole-3.0")
local UF = E:GetModule('UnitFrames')
local LSM = E.LSM or E.Libs.LSM

local frameposition
frameposition = {"TOPRIGHT", "TOPLEFT", -43, 1, "RIGHT", "LEFT", -3, 0}

local framelist = {
	--[FRAME NAME] = {UNITID, SIZE, ANCHOR, ANCHORFRAME, X, Y, "ANCHORNEXT", "ANCHORPREVIOUS", nextx, nexty},
	--["ElvUF_Player"] = {"player", _G["ElvUF_Player"]:GetHeight(), "TOPRIGHT", "TOPLEFT", -5, 2, "RIGHT", "LEFT", -3, 0},
	["ElvUF_Arena1"] = {"arena1", _G["ElvUF_Arena1"]:GetHeight(), T.unpack(frameposition)},
	["ElvUF_Arena2"] = {"arena2", _G["ElvUF_Arena2"]:GetHeight(), T.unpack(frameposition)},
	["ElvUF_Arena3"] = {"arena3", _G["ElvUF_Arena3"]:GetHeight(), T.unpack(frameposition)},
	["ElvUF_Arena4"] = {"arena4", _G["ElvUF_Arena4"]:GetHeight(), T.unpack(frameposition)},
	["ElvUF_Arena5"] = {"arena5", _G["ElvUF_Arena5"]:GetHeight(), T.unpack(frameposition)},
}

function UpdateDRTracker(self)
	local time = self.start + 18 - T.GetTime()

	if time < 0 then
		local frame = self:GetParent()
		frame.actives[self.cat] = nil
		self:SetScript("OnUpdate", nil)
		DisplayDrActives(frame)
	end
end

function DisplayDrActives(self, test)
	local _, instanceType = T.IsInInstance()
	if instanceType ~= "arena" and not test then return end

	if not self.actives then return end
	if not self.auras then self.auras = {} end
	local index
	local previous = nil
	index = 1

	for _, _ in pairs(self.actives) do
		local aura = self.auras[index]
		if not aura then
			aura = T.CreateFrame("Frame", "DrFrame"..self.target..index, self)
			aura:SetTemplate("Default")
			aura:SetSize(self.size, self.size)
			if index == 1 then
				aura:SetPoint(self.anchor, self:GetParent().Health, self.anchorframe, self.x, self.y)
			else
				aura:SetPoint(self.nextanchor, previous, self.nextanchorframe, self.nextx, self.nexty)
			end

			aura.icon = aura:CreateTexture("$parentIcon", "ARTWORK")
			aura.icon:SetPoint("TOPLEFT", 2, -2)
			aura.icon:SetPoint("BOTTOMRIGHT", -2, 2)
			aura.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			
			aura.cooldown = T.CreateFrame("Cooldown", "$parentCD", aura, "CooldownFrameTemplate")
			aura.cooldown:SetAllPoints(aura.icon)
			aura.cooldown:SetReverse(true)

			aura.count = aura:CreateFontString("$parentCount", "OVERLAY")
			aura.count:FontTemplate(LSM:Fetch("font", DR.db.text.font) or E["media"].normFont, DR.db.text.fontSize or 12, DR.db.text.fontOutline or "OUTLINE")
			aura.count:SetPoint("CENTER", 0, 0)
			--aura.count:SetJustifyH("CENTER")
			aura.cat = "cat"
			aura.start = 0

			self.auras[index] = aura
		end

		previous = aura
		index = index + 1
	end

	index = 1
	for cat, value in pairs(self.actives) do
		aura = self.auras[index]
		aura.icon:SetTexture(value.icon)
		aura.count:SetText(value.dr)
		if DR.db.text.enable then
			aura.count:Show()
		else
			aura.count:Hide()
		end
		if value.dr == 1 then
			aura:SetBackdropBorderColor(1, 1, 0, 1)
		elseif value.dr == 2 then
			aura:SetBackdropBorderColor(1, 0.5, 0, 1)
		else
			aura:SetBackdropBorderColor(1, 0, 0, 1)
		end
		aura:CreateIconShadow()
		T.CooldownFrame_Set(aura.cooldown, value.start, 18, 1)
		aura.start = value.start
		aura.cat = cat
		aura:SetScript("OnUpdate", UpdateDRTracker)
		aura.cooldown:Show()

		aura:Show()
		index = index + 1
	end

	for i = index, #self.auras, 1 do
		local aura = self.auras[i]
		aura:SetScript("OnUpdate", nil)
		aura:Hide()
	end
end

local spell = KUI.DiminishingSpells
local icon = KUI.DiminishingIcons
local eventRegistered = {
	["SPELL_AURA_APPLIED"] = true,
	["SPELL_AURA_REFRESH"] = true,
	["SPELL_AURA_REMOVED"] = true
}

local function CombatLogCheck(self)
	local _, instanceType = T.IsInInstance()
	if instanceType ~= "arena" then return end
	local _, eventType, _, _, _, _, _, destGUID, _, _, _, spellID, _, _, auraType = T.CombatLogGetCurrentEventInfo()
	if not eventRegistered[eventType] then return end
	if destGUID ~= T.UnitGUID(self.target) then return end

	local needupdate = false
	if eventType == "SPELL_AURA_APPLIED" then
		if auraType == "DEBUFF" and spell[spellID] then
			if not self.actives then self.actives = {} end
			for _, cat in T.pairs(spell[spellID]) do
				if self.actives[cat] then
					if self.actives[cat].start + 18 < T.GetTime() then
						self.actives[cat].start = T.GetTime()
						self.actives[cat].dr = 1
						self.actives[cat].icon = icon[cat]
					else
						self.actives[cat].start = T.GetTime()
						self.actives[cat].dr = 2 * self.actives[cat].dr
						self.actives[cat].icon = icon[cat]
					end
				else
					self.actives[cat] = {}
					self.actives[cat].start = T.GetTime()
					self.actives[cat].dr = 1
					self.actives[cat].icon = icon[cat]
				end
			end
			needupdate = true
		end
	elseif eventType == "SPELL_AURA_REFRESH" then
		if auraType == "DEBUFF" and spell[spellID] then
			if not self.actives then self.actives = {} end
			for _, cat in T.pairs(spell[spellID]) do
				if not self.actives[cat] then
					self.actives[cat] = {}
					self.actives[cat].dr = 1
				end
				self.actives[cat].start = T.GetTime()
				self.actives[cat].dr = 2 * self.actives[cat].dr
				self.actives[cat].icon = icon[cat]
			end
			needupdate = true
		end
	elseif eventType == "SPELL_AURA_REMOVED" then
		if auraType == "DEBUFF" and spell[spellID] then
			if not self.actives then self.actives = {} end
			for _, cat in T.pairs(spell[spellID]) do
				if self.actives[cat] then
					if self.actives[cat].start + 18 < T.GetTime() then
						self.actives[cat].start = T.GetTime()
						self.actives[cat].dr = 1
						self.actives[cat].icon = icon[cat]
					else
						self.actives[cat].start = T.GetTime()
						self.actives[cat].dr = self.actives[cat].dr
						self.actives[cat].icon = icon[cat]
					end
				else
					self.actives[cat] = {}
					self.actives[cat].start = T.GetTime()
					self.actives[cat].dr = 1
					self.actives[cat].icon = icon[cat]
				end
			end
			needupdate = true
		end
	end

	if needupdate then DisplayDrActives(self) end
end

local function testDimishingReturns()
	if T.InCombatLockdown() then KUI:Print("|cffffff00"..ERR_NOT_IN_COMBAT.."|r") return end

	local testlist = {"stun", "root", "silence"}

	for frame in pairs(framelist) do
		self = _G[frame].DrTracker
		if not self.actives then self.actives = {} end
		local dr = 1
		for _, cat in pairs(testlist) do
			if not self.actives[cat] then self.actives[cat] = {} end
			self.actives[cat].dr = dr
			self.actives[cat].start = T.GetTime()
			self.actives[cat].icon = icon[cat]
			dr = dr * 2
		end
		DisplayDrActives(self, true)
	end
	
	UF:ToggleForceShowGroupFrames('arena', 5)
end

function DR:Initialize()
	if not E.private.unitframe.enable or not E.db.unitframe.units.arena.enable or not E.db.KlixUI.cooldowns.dimishing.enable then return end
	
	DR.db = E.db.KlixUI.cooldowns.dimishing
	
	for frame, target in T.pairs(framelist) do
		self = _G[frame]
		local DrTracker = T.CreateFrame("Frame", nil, self)
		DrTracker:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		DrTracker:SetScript("OnEvent", CombatLogCheck)
		DrTracker.target = target[1]
		DrTracker.size = target[2]
		DrTracker.anchor = target[3]
		DrTracker.anchorframe = target[4]
		DrTracker.x = target[5]
		DrTracker.y = target[6]
		DrTracker.nextanchor = target[7]
		DrTracker.nextanchorframe = target[8]
		DrTracker.nextx = target[9]
		DrTracker.nexty = target[10]
		self.DrTracker = DrTracker
	end
	
	for spell in pairs(KUI.DiminishingSpells) do
		local name = T.GetSpellInfo(spell)
		if not name then
			KUI:Print("|cffff0000WARNING: spell ID ["..T.tostring(spell).."] no longer exists! Please report this in my Discord.|r")
		end
	end
	
	_G.SLASH_DIMINISHINGCD1 = "/testdr"
	_G.SLASH_DIMINISHINGCD2 = "/tdr"
	T.SlashCmdList["DIMINISHINGCD"] = testDimishingReturns
end

local function InitializeCallback()
	DR:Initialize()
end

KUI:RegisterModule(DR:GetName(), InitializeCallback)