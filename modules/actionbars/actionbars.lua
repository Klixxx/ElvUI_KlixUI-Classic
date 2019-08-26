local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KAB = KUI:NewModule('KUIActionbars', 'AceEvent-3.0', "AceHook-3.0", "AceBucket-3.0")
local AB = LibStub("LibActionButton-1.0-ElvUI")
local LCG = LibStub('LibCustomGlow-1.0')

if E.private.actionbar.enable ~= true then return; end

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])
local availableActionbars = availableActionbars or 6

local styleOtherBacks = {ElvUI_BarPet, ElvUI_StanceBar}

local ActiveButtons = AB.activeButtons
local OverlayedSpellID = {
    ["ROGUE"] = {5171, 193316, 199804, 2098, 1943, 32645, 408, 196819, 195452, 206237, 26679},
    ["DRUID"] = {52610, 1079, 22568, 22570},
}

local HearthStoneList = {
	54452,		-- Ethereal Portal
	64488,		-- The Innkeeper's Daughter
	93672,		-- Dark Portal
	142542,		-- Tome of Town Portal
	162973,		-- Greatfather Winter's Hearthstone
	163045,		-- Headless Horseman's Hearthstone
	165669,		-- Lunar Elder's Hearthstone
	165670,		-- Peddlefeet's Lovely Hearthstone
	165802,		-- Noble Gardener"s Hearthstone
	166746, 	-- Fire Eater"s Hearthstone
	166747, 	-- Brewfest Reveler"s Hearthstone
	168907, 	-- Holographic Digitalization Hearthstone
}

local function CheckExtraAB()
	if T.IsAddOnLoaded('ElvUI_ExtraActionBars') then
		availableActionbars = 10
	else
		availableActionbars = 6
	end
end

local r, g, b = 0, 0, 0

-- from ElvUI_TrasparentBackdrops plugin
function KAB:TransparentBackdrops()
	-- Actionbar backdrops
	local db = E.db.KlixUI.actionbars
	for i = 1, availableActionbars do
		local transBars = {_G['ElvUI_Bar'..i]}
		for _, frame in T.pairs(transBars) do
			if frame.backdrop then
				if db.transparent then
					frame.backdrop:SetTemplate('Transparent')
				else
					frame.backdrop:SetTemplate('Default')
				end
			end
		end

		-- Buttons
		for k = 1, 12 do
			local buttonBars = {_G["ElvUI_Bar"..i.."Button"..k]}
			for _, button in T.pairs(buttonBars) do
				if button.backdrop then
					button.backdrop:Styling()
					if db.transparent then
						button.backdrop:SetTemplate("Transparent")
					else
						button.backdrop:SetTemplate("Default", true)
					end
				end
				button:CreateIconShadow()
			end
		end
	end

	-- Other bar backdrops
	for _, frame in T.pairs(styleOtherBacks) do
		if frame.backdrop then
			if db.transparent then
				frame.backdrop:SetTemplate('Transparent')
			else
				frame.backdrop:SetTemplate('Default')
			end
		end
	end

	-- Pet Buttons
	for i = 1, NUM_PET_ACTION_SLOTS do
		local petButtons = {_G['PetActionButton'..i]}
		for _, button in T.pairs(petButtons) do
			if button.backdrop then
				if db.transparent then
					button.backdrop:SetTemplate('Transparent')
				else
					button.backdrop:SetTemplate('Default', true)
				end
			end
		end
	end
end

function KAB:StyleBackdrops()
	-- Actionbar backdrops
	for i = 1, availableActionbars do
		local styleBacks = {_G['ElvUI_Bar'..i]}
		for _, frame in T.pairs(styleBacks) do
			if frame.backdrop then
				frame.backdrop:Styling()
			end
		end
	end

	-- Other bar backdrops
	for _, frame in T.pairs(styleOtherBacks) do
		if frame.backdrop then
			frame.backdrop:Styling()
		end
	end
	
	-- Pet Buttons
	for i = 1, NUM_PET_ACTION_SLOTS do
		local petButtons = {_G['PetActionButton'..i]}
		for _, button in T.pairs(petButtons) do
			if button.backdrop then
				button.backdrop:Styling()
			end
		end
	end
end

-- Code taken from CleanBossButton, thanks Blazeflack.
local function RemoveTexture(self, texture, stopLoop)
	if not E.db.KlixUI.actionbars.cleanButton then return end
	if stopLoop then return end

	self:SetTexture("", true) --2nd argument is to stop endless loop
end

-- Glow
function KAB:SpellActivationGlow()
	if not E.db.KlixUI.actionbars.glow.enable or T.IsAddOnLoaded("CoolGlow") then return end
	T.C_Timer_After(0,function()
		if LibStub then
			local lib = LibStub:GetLibrary("LibButtonGlow-1.0",4)
			if lib then
				function lib.ShowOverlayGlow(button)
					if button:GetAttribute("type") == "action" then
						local actionType,actionID = T.GetActionInfo(button:GetAttribute("action"))
						local color = {E.db.KlixUI.actionbars.glow.color.r, E.db.KlixUI.actionbars.glow.color.g, E.db.KlixUI.actionbars.glow.color.b, E.db.KlixUI.actionbars.glow.color.a or 1}
						LCG.PixelGlow_Start(button, color, E.db.KlixUI.actionbars.glow.number, E.db.KlixUI.actionbars.glow.frequency, E.db.KlixUI.actionbars.glow.length, E.db.KlixUI.actionbars.glow.thickness, E.db.KlixUI.actionbars.glow.xOffset, E.db.KlixUI.actionbars.glow.yOffset, nil)
					end
					function lib.HideOverlayGlow(button)
						LCG.PixelGlow_Stop(button)
					end
				end
			end
		end
	end)
end

-- Finishing Move Glow!
local function ShowOverlayGlow(self)
	local color = {E.db.KlixUI.actionbars.glow.color.r, E.db.KlixUI.actionbars.glow.color.g, E.db.KlixUI.actionbars.glow.color.b, E.db.KlixUI.actionbars.glow.color.a or 1}
    LCG.PixelGlow_Start(self, color, E.db.KlixUI.actionbars.glow.number, E.db.KlixUI.actionbars.glow.frequency, E.db.KlixUI.actionbars.glow.length, E.db.KlixUI.actionbars.glow.thickness, E.db.KlixUI.actionbars.glow.xOffset, E.db.KlixUI.actionbars.glow.yOffset, nil)
end

local function HideOverlayGlow(self)
    LCG.PixelGlow_Stop(self)
end

local function IsOverlayedSpell(spellID)
    local _, class = T.UnitClass("player")
    if (not OverlayedSpellID[class]) then return false end
    local points = T.UnitPower("player", Enum.PowerType.ComboPoints)
    local maxPoints = T.UnitPowerMax("player", Enum.PowerType.ComboPoints)
    for i = 1, #OverlayedSpellID[class] do
        if spellID == OverlayedSpellID[class][i] and points == maxPoints then
            return true
        end
    end
    return false;
end

local function UpdateOverlayGlow(self)
    local spellId = self:GetSpellId()
    if spellId and (IsOverlayedSpell(spellId) or T.IsSpellOverlayed(spellId)) then
        ShowOverlayGlow(self)
    else
        HideOverlayGlow(self)
    end
end

function KAB:OnEvent()
    if ElvUI and E.db.KlixUI.actionbars.glow.enable and E.db.KlixUI.actionbars.glow.finishMove and not T.IsAddOnLoaded("CoolGlow") then
        for button in T.next, ActiveButtons do
            UpdateOverlayGlow(button)
        end
    end
end

-- Random Hearthstone
local HearthStoneListChecked = {}
local HearthStoneName = {}

local function HearthStoneToUse_UpdateList()
	for k, v in T.ipairs(HearthStoneList) do
		if T.PlayerHasToy(v) then
			T.table_insert(HearthStoneListChecked, v)
		end
	end
	local num = #HearthStoneListChecked
	if num and num >=1 then
		for k, v in T.ipairs(HearthStoneListChecked) do
			local name = T.GetItemInfo(v)
			if name then
				T.table_insert(HearthStoneName, name)
				T.table_remove(HearthStoneListChecked, k)
			end
		end
	end
end

local function HearthStoneToUse_Random(frame)
	if (#HearthStoneName >= 1) then
		if (not T.InCombatLockdown()) then
			HearthStoneToUse = HearthStoneName[T.random(#HearthStoneName)]
			frame:SetAttribute("item", HearthStoneToUse)
			frame.NeedToRandom = false
		else
			frame.NeedToRandom = true
		end
	end
end

function KAB:Macro_Refresh()
	local name = T.GetMacroInfo("KuiRHS")
	local HSNAME = T.GetItemInfo(6948)
	if (not HSNAME) or (T.InCombatLockdown()) then return end
	if not name then
		local gNum, pNum = T.GetNumMacros()
		if (gNum == 72) then return end
		local macroId = T.CreateMacro("KuiRHS", "inv_misc_rune_01", 
		"#showtooltip "..HSNAME..[[

]]..[[
/rhs check
/click RandomHearthStone]],
		nil, 1)
		KUI:Print("A random hearthstone macro has been created, move it to your actionbar.")
		T.PickupMacro("KuiRHS")
	else
		local macroID = T.EditMacro("KuiRHS", "KuiRHS", "inv_misc_rune_01", 
		"#showtooltip "..HSNAME..[[

]]..[[
/rhs check
/click RandomHearthStone]])
		KUI:Print("A random hearthstone macro has been created, move it to your actionbar.")
		T.PickupMacro("KuiRHS")
	end
end

local HearthStoneToUse = T.GetItemInfo(6948)
local RandomHearthStone = T.CreateFrame("Button", "RandomHearthStone", nil, "SecureActionButtonTemplate")
RandomHearthStone:SetAttribute("type","item")
RandomHearthStone:SetAttribute("item", HearthStoneToUse)
RandomHearthStone.NeedToRandom = false

RandomHearthStone:RegisterEvent("PLAYER_ENTERING_WORLD")
RandomHearthStone:RegisterEvent("PLAYER_REGEN_ENABLED")
RandomHearthStone:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		if not RandomHearthstone_DB then
			RandomHearthstone_DB = {}
			RandomHearthstone_DB.Version = 1 
		end
		if RandomHearthstone_DB.Version < 1 then
			KAB:Macro_Refresh()
		end
		
		HearthStoneToUse_UpdateList()
		HearthStoneToUse_Random(RandomHearthStone)
		T.C_Timer_After(5, function(self2)
			HearthStoneToUse_UpdateList()
			HearthStoneToUse_Random(RandomHearthStone)
		end)
	end
	if event == "PLAYER_REGEN_ENABLED" then
		if self.NeedToRandom == true then
			HearthStoneToUse_UpdateList()
			HearthStoneToUse_Random(RandomHearthStone)
		end
	end
end)

local function DeleteHearthstone()
	if not E.db.KlixUI.actionbars.hearthstone.delete then return end
	
	for bag = 0,4 do
		for slot = 1, 32 do
			local itemID = T.GetContainerItemID(bag,slot)
			if itemID == 6948 then
				T.PickupContainerItem(bag,slot)
				T.DeleteCursorItem()
				KUI:Print("Hearthstone deleted!")
			end
		end
	end
end

function KAB:Initialize()
	CheckExtraAB()
	T.C_Timer_After(1, KAB.StyleBackdrops)
	T.C_Timer_After(1, KAB.TransparentBackdrops)
	if T.IsAddOnLoaded('ElvUI_TB') then T.DisableAddOn('ElvUI_TB') end
	
	hooksecurefunc(_G["ZoneAbilityFrame"].SpellButton.Style, "SetTexture", RemoveTexture)
	hooksecurefunc(_G["ExtraActionButton1"].style, "SetTexture", RemoveTexture)
	
	KAB:SpellActivationGlow()
	
	KAB:RegisterEvent("UNIT_POWER_UPDATE", "OnEvent")
    KAB:RegisterEvent("PLAYER_TARGET_CHANGED", "OnEvent")
	KAB:RegisterBucketEvent("BAG_UPDATE", 0.2, DeleteHearthstone)
	
	if E.db.KlixUI.actionbars.hearthstone.enable then
		SlashCmdList["RHS"] = function(msg)
			if msg == "check" then
				HearthStoneToUse_UpdateList()
				HearthStoneToUse_Random(RandomHearthStone)
			else
				self:Macro_Refresh()
			end
		end
		SLASH_RHS1 = "/rhs"
	end
end

local function InitializeCallback()
	KAB:Initialize()
end

KUI:RegisterModule(KAB:GetName(), InitializeCallback)