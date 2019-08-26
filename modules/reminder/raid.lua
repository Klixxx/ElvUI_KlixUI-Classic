local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KRR = KUI:NewModule("KuiRaidReminder")
local LCG = LibStub('LibCustomGlow-1.0')
KRR.modName = L["Raid Buff Reminder"]

KRR.VisibilityStates = {
	["DEFAULT"] = "[noexists, nogroup] hide; show",
	["INPARTY"] = "[combat] hide; [group] show; [petbattle] hide; hide",
	["ALWAYS"] = "[petbattle] hide; show",
}

KRR.ReminderBuffs = {
	Flask = {
									-- Legion --
		188034,			-- Flask of the Countless Armies (59 str)
		188035,			-- Flask of the Thousand Scars (88 sta)
		188033,			-- Flask of the Seventh Demon (59 agi)
		188031,			-- Flask of the Whispered Pact (59 int)
		242551,			-- Fel Focus Str, Agi and Int +23, stam + 34

								-- Battle for Azeroth --
		251837,			-- Flask of Endless Fathoms (238 int)
		251838,			-- Flask of the Vast Horizon (357 sta)
		251839,			-- Flask of the Undertow (238 str)
		251836,			-- Flask of the Currents (238 agi)
		298836,			-- Greater Flask of the Currents
		298837,			-- Greater Flask of Endless Fathoms
		298839,			-- Greater Flask of the Vast Horizon
		298841,			-- Greater Flask of the Undertow
	},
	DefiledAugmentRune = {
		270058,			-- Battle Scarred Augmentation (60 primary stat)
		224001,			-- Defiled Augumentation (15 primary stat)
	},
	Food = {
		104280,	-- Well Fed
	},
	Intellect = {
		264760, -- War-Scroll of Intellect
		1459, -- Arcane Intellect
	},
	Stamina = {
		6307, -- Blood Pact
		264764, -- War-Scroll of Fortitude
		21562, -- Power Word: Fortitude
	},
	AttackPower = {
		264761, -- War-Scroll of Battle
		6673, -- Battle Shout
	},
}

local flaskbuffs = KRR.ReminderBuffs["Flask"]
local foodbuffs = KRR.ReminderBuffs["Food"]
local darunebuffs = KRR.ReminderBuffs["DefiledAugmentRune"]
local intellectbuffs = KRR.ReminderBuffs["Intellect"]
local staminabuffs = KRR.ReminderBuffs["Stamina"]
local attackpowerbuffs = KRR.ReminderBuffs["AttackPower"]

local r, g, b = T.unpack(E.media.rgbvaluecolor)
local color = {r, g, b, 1}

local function OnAuraChange(self, event, arg1, unit)
	if (event == "UNIT_AURA" and arg1 ~= "player") then return end

	if (flaskbuffs and flaskbuffs[1]) then
		FlaskFrame.t:SetTexture(T.select(3, T.GetSpellInfo(flaskbuffs[1])))
		for i, flaskbuffs in T.pairs(flaskbuffs) do
			local spellname = T.select(1, T.GetSpellInfo(flaskbuffs))
			if T.AuraUtil_FindAuraByName(spellname, "player") then
				FlaskFrame.t:SetTexture(T.select(3, T.GetSpellInfo(flaskbuffs)))
				FlaskFrame:SetAlpha(KRR.db.alpha or 0.3)
				LCG.PixelGlow_Stop(FlaskFrame)
				break
			else
				if KRR.db.glow then
					LCG.PixelGlow_Start(FlaskFrame, color, nil, -0.25, nil, 1)
				end
				FlaskFrame:SetAlpha(1)
				FlaskFrame.t:SetTexture(T.select(3, T.GetSpellInfo(flaskbuffs)))
			end
		end
	end

	if (foodbuffs and foodbuffs[1]) then
		FoodFrame.t:SetTexture(T.select(3, T.GetSpellInfo(foodbuffs[1])))
		for i, foodbuffs in T.pairs(foodbuffs) do
			local spellname = T.select(1, T.GetSpellInfo(foodbuffs))
			if T.AuraUtil_FindAuraByName(spellname, "player") then
				FoodFrame.t:SetTexture(T.select(3, T.GetSpellInfo(foodbuffs)))
				FoodFrame:SetAlpha(KRR.db.alpha or 0.3)
				LCG.PixelGlow_Stop(FoodFrame)
				break
			else
				if KRR.db.glow then
					LCG.PixelGlow_Start(FoodFrame, color, nil, -0.25, nil, 1)
				end
				FoodFrame:SetAlpha(1)
				FoodFrame.t:SetTexture(T.select(3, T.GetSpellInfo(foodbuffs)))
			end
		end
	end

	if (darunebuffs and darunebuffs[1]) then
	DARuneFrame.t:SetTexture(T.select(3, T.GetSpellInfo(darunebuffs[1])))
		for i, darunebuffs in T.pairs(darunebuffs) do
			local spellname = T.select(1, T.GetSpellInfo(darunebuffs))
			if T.AuraUtil_FindAuraByName(spellname, "player") then
				DARuneFrame.t:SetTexture(T.select(3, T.GetSpellInfo(darunebuffs)))
				DARuneFrame:SetAlpha(KRR.db.alpha or 0.3)
				LCG.PixelGlow_Stop(DARuneFrame)
				break
			else
				if KRR.db.glow then
					LCG.PixelGlow_Start(DARuneFrame, color, nil, -0.25, nil, 1)
				end
				DARuneFrame:SetAlpha(1)
				DARuneFrame.t:SetTexture(T.select(3, T.GetSpellInfo(darunebuffs)))
			end
		end
	end
	if KRR.db.class then
		if (intellectbuffs and intellectbuffs[1]) then
		IntellectFrame.t:SetTexture(T.select(3, T.GetSpellInfo(intellectbuffs[1])))
			for i, intellectbuffs in T.pairs(intellectbuffs) do
				local spellname = T.select(1, T.GetSpellInfo(intellectbuffs))
				if T.AuraUtil_FindAuraByName(spellname, "player") then
					IntellectFrame.t:SetTexture(T.select(3, T.GetSpellInfo(intellectbuffs)))
					IntellectFrame:SetAlpha(KRR.db.alpha or 0.3)
					LCG.PixelGlow_Stop(IntellectFrame)
					break
				else
					if KRR.db.glow then
						LCG.PixelGlow_Start(IntellectFrame, color, nil, -0.25, nil, 1)
					end
					IntellectFrame:SetAlpha(1)
					IntellectFrame.t:SetTexture(T.select(3, T.GetSpellInfo(intellectbuffs)))
				end
			end
		end

		if (staminabuffs and staminabuffs[1]) then
		StaminaFrame.t:SetTexture(T.select(3, T.GetSpellInfo(staminabuffs[1])))
			for i, staminabuffs in T.pairs(staminabuffs) do
				local spellname = T.select(1, T.GetSpellInfo(staminabuffs))
				if T.AuraUtil_FindAuraByName(spellname, "player") then
					StaminaFrame.t:SetTexture(T.select(3, T.GetSpellInfo(staminabuffs)))
					StaminaFrame:SetAlpha(KRR.db.alpha or 0.3)
					LCG.PixelGlow_Stop(StaminaFrame)
					break
				else
					if KRR.db.glow then
						LCG.PixelGlow_Start(StaminaFrame, color, nil, -0.25, nil, 1)
					end
					StaminaFrame:SetAlpha(1)
					StaminaFrame.t:SetTexture(T.select(3, T.GetSpellInfo(staminabuffs)))
				end
			end
		end

		if (attackpowerbuffs and attackpowerbuffs[1]) then
		AttackPowerFrame.t:SetTexture(T.select(3, T.GetSpellInfo(attackpowerbuffs[1])))
			for i, attackpowerbuffs in T.pairs(attackpowerbuffs) do
				local spellname = T.select(1, T.GetSpellInfo(attackpowerbuffs))
				if T.AuraUtil_FindAuraByName(spellname, "player") then
					AttackPowerFrame.t:SetTexture(T.select(3, T.GetSpellInfo(attackpowerbuffs)))
					AttackPowerFrame:SetAlpha(KRR.db.alpha or 0.3)
					LCG.PixelGlow_Stop(AttackPowerFrame)
					break
				else
					if KRR.db.glow then
						LCG.PixelGlow_Start(AttackPowerFrame, color, nil, -0.25, nil, 1)
					end
					AttackPowerFrame:SetAlpha(1)
					AttackPowerFrame.t:SetTexture(T.select(3, T.GetSpellInfo(attackpowerbuffs)))
				end
			end
		end
	end
end

function KRR:CreateIconBuff(name, relativeTo, firstbutton)
	local button = T.CreateFrame("Frame", name, KRR.frame)
	if firstbutton == true then
		button:Point("RIGHT", relativeTo, "RIGHT", E:Scale(-4), 0)
	else
		button:Point("RIGHT", relativeTo, "LEFT", E:Scale(-4), 0)
	end
	button:Size(KRR.db.size)
	button:SetFrameLevel(self.frame.backdrop:GetFrameLevel() + 2)

	button:CreateBackdrop("Default")
	button.backdrop:SetPoint("TOPLEFT", E:Scale(-1), E:Scale(1))
	button.backdrop:SetPoint("BOTTOMRIGHT", E:Scale(1), E:Scale(-1))
	button.backdrop:SetFrameLevel(button:GetFrameLevel() - 1)

	button.t = button:CreateTexture(name..".t", "OVERLAY")
	button.t:SetTexCoord(T.unpack(E.TexCoords))
	button.t:SetAllPoints(button)
	
	-- Used for Glow
	button.overlay = T.CreateFrame("Button", nil, button)
	button.overlay:SetOutside(button, 0, 0)
	button.overlay:CreateIconShadow()
end

function KRR:Visibility()
	if KRR.db.enable then
		T.RegisterStateDriver(self.frame, "visibility", KRR.db.visibility == "CUSTOM" and KRR.db.customVisibility or KRR.VisibilityStates[KRR.db.visibility])
		E:EnableMover(self.frame.mover:GetName())
	else
		T.UnregisterStateDriver(self.frame, "visibility")
		self.frame:Hide()
		E:DisableMover(self.frame.mover:GetName())
	end
end

function KRR:Backdrop()
	if KRR.db.backdrop then
		self.frame.backdrop:Show()
		self.frame.backdrop:Styling()
	else
		self.frame.backdrop:Hide()
	end
end

function KRR:Initialize()
	KRR.db = E.db.KlixUI.reminder.raid

	self.frame = T.CreateFrame("Frame", "RaidBuffReminder", E.UIParent)
	self.frame:CreateBackdrop('Transparent')
	self.frame:Point("TOP", E.UIParent, "TOP", 0, -67)
	E.FrameLocks[self.frame] = true

	self.frame.backdrop:SetAllPoints()
	
	if KRR.db.class then
		self.frame:Size((KRR.db.size * 6) + 28, KRR.db.size + 8) -- Backdrop + size (still needs some adjustments, LOL :P)
		self:CreateIconBuff("IntellectFrame", RaidBuffReminder, true)
		self:CreateIconBuff("StaminaFrame", IntellectFrame, false)
		self:CreateIconBuff("AttackPowerFrame", StaminaFrame, false)
		self:CreateIconBuff("FlaskFrame", AttackPowerFrame, false)
		self:CreateIconBuff("FoodFrame", FlaskFrame, false)
		self:CreateIconBuff("DARuneFrame", FoodFrame, false)
	else
		self.frame:Size((KRR.db.size * 3) + 16, KRR.db.size + 8) -- Backdrop + size (still needs some adjustments, LOL :P)
		self:CreateIconBuff("FlaskFrame", RaidBuffReminder, true)
		self:CreateIconBuff("FoodFrame", FlaskFrame, false)
		self:CreateIconBuff("DARuneFrame", FoodFrame, false)
	end
	
	self.frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	self.frame:RegisterEvent("UNIT_INVENTORY_CHANGED")
	self.frame:RegisterEvent("UNIT_AURA")
	self.frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	self.frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	self.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	self.frame:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
	self.frame:RegisterEvent("CHARACTER_POINTS_CHANGED")
	self.frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self.frame:RegisterEvent("GROUP_ROSTER_UPDATE")
	self.frame:SetScript("OnEvent", OnAuraChange)

	E:CreateMover(self.frame, "KUI_RaidBuffReminderMover", L["Raid Buffs Reminder"], nil, nil, nil, "ALL,SOLO,PARTY,RAID,KLIXUI", nil, "KlixUI,modules,reminder")

	function KRR:ForUpdateAll()
		KRR.db = E.db.KlixUI.reminder.raid
		self:Backdrop()
		self:Visibility()
	end

	self:ForUpdateAll()
end

local function InitializeCallback()
	KRR:Initialize()
end

KUI:RegisterModule(KRR:GetName(), InitializeCallback)