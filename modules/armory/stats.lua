local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KA = KUI:GetModule("KuiArmory")

if T.IsAddOnLoaded("DejaCharacterStats") or T.IsAddOnLoaded('ElvUI_SLE') then return end

local LE_UNIT_STAT_STRENGTH, LE_UNIT_STAT_AGILITY, LE_UNIT_STAT_INTELLECT = LE_UNIT_STAT_STRENGTH, LE_UNIT_STAT_AGILITY, LE_UNIT_STAT_INTELLECT
local STAT_ATTACK_SPEED_BASE_TOOLTIP = STAT_ATTACK_SPEED_BASE_TOOLTIP
local FONT_COLOR_CODE_CLOSE, HIGHLIGHT_FONT_COLOR_CODE = FONT_COLOR_CODE_CLOSE, HIGHLIGHT_FONT_COLOR_CODE
local ATTACK_SPEED = ATTACK_SPEED
local PAPERDOLLFRAME_TOOLTIP_FORMAT = PAPERDOLLFRAME_TOOLTIP_FORMAT
local WEAPON_SPEED = WEAPON_SPEED
local STAT_LIFESTEAL, CR_LIFESTEAL_TOOLTIP, CR_LIFESTEAL = STAT_LIFESTEAL, CR_LIFESTEAL_TOOLTIP, CR_LIFESTEAL
local STAT_CRITICAL_STRIKE, CR_CRIT_SPELL, CR_CRIT_RANGED, CR_CRIT_MELEE, CR_CRIT_TOOLTIP = STAT_CRITICAL_STRIKE, CR_CRIT_SPELL, CR_CRIT_RANGED, CR_CRIT_MELEE, CR_CRIT_TOOLTIP
local CR_CRIT_PARRY_RATING_TOOLTIP, CR_PARRY = CR_CRIT_PARRY_RATING_TOOLTIP, CR_PARRY
local CR_HASTE_MELEE, STAT_HASTE, STAT_HASTE_TOOLTIP, STAT_HASTE_BASE_TOOLTIP = CR_HASTE_MELEE, STAT_HASTE, STAT_HASTE_TOOLTIP, STAT_HASTE_BASE_TOOLTIP
local STAT_BLOCK, BLOCK_CHANCE, CR_BLOCK_TOOLTIP = STAT_BLOCK, BLOCK_CHANCE, CR_BLOCK_TOOLTIP
local STAT_PARRY, PARRY_CHANCE, CR_PARRY_TOOLTIP = STAT_PARRY, PARRY_CHANCE, CR_PARRY_TOOLTIP
local STAT_DODGE, DODGE_CHANCE, CR_DODGE_TOOLTIP, CR_DODGE = STAT_DODGE, DODGE_CHANCE, CR_DODGE_TOOLTIP, CR_DODGE
local STAT_AVOIDANCE, CR_AVOIDANCE_TOOLTIP, CR_AVOIDANCE = STAT_AVOIDANCE, CR_AVOIDANCE_TOOLTIP, CR_AVOIDANCE
local CR_VERSATILITY_DAMAGE_DONE, CR_VERSATILITY_DAMAGE_TAKEN, STAT_VERSATILITY, VERSATILITY_TOOLTIP_FORMAT, CR_VERSATILITY_TOOLTIP = CR_VERSATILITY_DAMAGE_DONE, CR_VERSATILITY_DAMAGE_TAKEN, STAT_VERSATILITY, VERSATILITY_TOOLTIP_FORMAT, CR_VERSATILITY_TOOLTIP
local SHOW_MASTERY_LEVEL, STAT_MASTERY = SHOW_MASTERY_LEVEL, STAT_MASTERY
local MAX_SPELL_SCHOOLS = MAX_SPELL_SCHOOLS
local RED_FONT_COLOR_CODE = RED_FONT_COLOR_CODE

local totalShown = 0

--Replacing broken Blizz function and adding some decimals
--Atteack speed
function PaperDollFrame_SetAttackSpeed(statFrame, unit)
	local meleeHaste = T.GetMeleeHaste();
	local speed, offhandSpeed = T.UnitAttackSpeed(unit);
	local displaySpeedxt

	local displaySpeed = T.string_format("%.2f", speed);
	if ( offhandSpeed ) then
		offhandSpeed = T.string_format("%.2f", offhandSpeed);
	end
	if ( offhandSpeed ) then
		displaySpeedxt =  T.BreakUpLargeNumbers(displaySpeed).." / ".. offhandSpeed;
	else
		displaySpeedxt =  T.BreakUpLargeNumbers(displaySpeed);
	end
	T.PaperDollFrame_SetLabelAndText(statFrame, WEAPON_SPEED, displaySpeed, false, speed);

	statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..T.string_format(PAPERDOLLFRAME_TOOLTIP_FORMAT, ATTACK_SPEED).." "..displaySpeed..FONT_COLOR_CODE_CLOSE;
	statFrame.tooltip2 = T.string_format(STAT_ATTACK_SPEED_BASE_TOOLTIP, T.BreakUpLargeNumbers(meleeHaste));

	statFrame:Show();
end

--Moving speed
function PaperDollFrame_SetMovementSpeed(statFrame, unit)
	statFrame.wasSwimming = nil;
	statFrame.unit = unit;
	T.MovementSpeed_OnUpdate(statFrame);

	statFrame.onEnterFunc = T.MovementSpeed_OnEnter;
	-- TODO: Fix if we decide to show movement speed
	-- statFrame:SetScript("OnUpdate", MovementSpeed_OnUpdate);

	statFrame:Show();
end

-- Versatility
function PaperDollFrame_SetVersatility(statFrame, unit)
	if ( unit ~= "player" ) then
		statFrame:Hide();
		return;
	end

	local versatility = T.GetCombatRating(CR_VERSATILITY_DAMAGE_DONE);
	local versatilityDamageBonus = T.GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + T.GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE);
	local versatilityDamageTakenReduction = T.GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_TAKEN) + T.GetVersatilityBonus(CR_VERSATILITY_DAMAGE_TAKEN);
-- PaperDollFrame_SetLabelAndText Format Change
	T.PaperDollFrame_SetLabelAndText(statFrame, STAT_VERSATILITY, T.string_format("%.2f%%", versatilityDamageBonus) .. " / " .. T.string_format("%.2f%%", versatilityDamageTakenReduction), false, versatilityDamageBonus);

	statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. T.string_format(VERSATILITY_TOOLTIP_FORMAT, STAT_VERSATILITY, versatilityDamageBonus, versatilityDamageTakenReduction) .. FONT_COLOR_CODE_CLOSE;
	statFrame.tooltip2 = T.string_format(CR_VERSATILITY_TOOLTIP, versatilityDamageBonus, versatilityDamageTakenReduction, T.BreakUpLargeNumbers(versatility), versatilityDamageBonus, versatilityDamageTakenReduction);

	statFrame:Show();
end

-- Mastery
function PaperDollFrame_SetMastery(statFrame, unit)
	if ( unit ~= "player" ) then
		statFrame:Hide();
		return;
	end
	if (T.UnitLevel("player") < SHOW_MASTERY_LEVEL) then
		statFrame:Hide();
		return;
	end

	local mastery = T.GetMasteryEffect();
-- PaperDollFrame_SetLabelAndText Format Change
	T.PaperDollFrame_SetLabelAndText(statFrame, STAT_MASTERY, T.string_format("%.2f%%", mastery), false, mastery);
	statFrame.onEnterFunc = T.Mastery_OnEnter;
	statFrame:Show();
end

-- Leech (Lifesteal)
function PaperDollFrame_SetLifesteal(statFrame, unit)
	if ( unit ~= "player" ) then
		statFrame:Hide();
		return;
	end

	local lifesteal = T.GetLifesteal();
-- PaperDollFrame_SetLabelAndText Format Change
	T.PaperDollFrame_SetLabelAndText(statFrame, STAT_LIFESTEAL, T.string_format("%.2f%%", lifesteal), false, lifesteal);
	statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. T.string_format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_LIFESTEAL) .. " " .. T.string_format("%.2f%%", lifesteal) .. FONT_COLOR_CODE_CLOSE;

	statFrame.tooltip2 = T.string_format(CR_LIFESTEAL_TOOLTIP, T.BreakUpLargeNumbers(T.GetCombatRating(CR_LIFESTEAL)), T.GetCombatRatingBonus(CR_LIFESTEAL));

	statFrame:Show();
end

-- Avoidance
function PaperDollFrame_SetAvoidance(statFrame, unit)
	if ( unit ~= "player" ) then
		statFrame:Hide();
		return;
	end

	local avoidance = T.GetAvoidance();
-- PaperDollFrame_SetLabelAndText Format Change
	T.PaperDollFrame_SetLabelAndText(statFrame, STAT_AVOIDANCE, T.string_format("%.2f%%", avoidance), false, avoidance);
	statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. T.string_format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_AVOIDANCE) .. " " .. T.string_format("%.2f%%", avoidance) .. FONT_COLOR_CODE_CLOSE;

	statFrame.tooltip2 = T.string_format(CR_AVOIDANCE_TOOLTIP, T.BreakUpLargeNumbers(T.GetCombatRating(CR_AVOIDANCE)), T.GetCombatRatingBonus(CR_AVOIDANCE));

	statFrame:Show();
end

-- Dodge Chance
function PaperDollFrame_SetDodge(statFrame, unit)
	if (unit ~= "player") then
		statFrame:Hide();
		return;
	end

	local chance = T.GetDodgeChance();
-- PaperDollFrame_SetLabelAndText Format Change
	T.PaperDollFrame_SetLabelAndText(statFrame, STAT_DODGE, T.string_format("%.2f%%", chance), false, chance);
	statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..T.string_format(PAPERDOLLFRAME_TOOLTIP_FORMAT, DODGE_CHANCE).." "..T.string_format("%.2f", chance).."%"..FONT_COLOR_CODE_CLOSE;
	statFrame.tooltip2 = T.string_format(CR_DODGE_TOOLTIP, T.GetCombatRating(CR_DODGE), T.GetCombatRatingBonus(CR_DODGE));
	statFrame:Show();
end

-- Parry Chance
function PaperDollFrame_SetParry(statFrame, unit)
	if (unit ~= "player") then
		statFrame:Hide();
		return;
	end

	local chance = T.GetParryChance();
-- PaperDollFrame_SetLabelAndText Format Change
	T.PaperDollFrame_SetLabelAndText(statFrame, STAT_PARRY, T.string_format("%.2f%%", chance), false, chance);
	statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..T.string_format(PAPERDOLLFRAME_TOOLTIP_FORMAT, PARRY_CHANCE).." "..T.string_format("%.2f", chance).."%"..FONT_COLOR_CODE_CLOSE;
	statFrame.tooltip2 = T.string_format(CR_PARRY_TOOLTIP, T.GetCombatRating(CR_PARRY), T.GetCombatRatingBonus(CR_PARRY));
	statFrame:Show();
end

-- Block Chance
-- function PaperDollFrame_SetBlock(statFrame, unit)
	-- if (unit ~= "player") then
		-- statFrame:Hide();
		-- return;
	-- end

	-- local chance = GetBlockChance();
-- PaperDollFrame_SetLabelAndText Format Change
	-- PaperDollFrame_SetLabelAndText(statFrame, STAT_BLOCK, T.format("%.2f%%", chance), false, chance);
	-- statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..T.format(PAPERDOLLFRAME_TOOLTIP_FORMAT, BLOCK_CHANCE).." "..T.format("%.2f", chance).."%"..FONT_COLOR_CODE_CLOSE;
	-- statFrame.tooltip2 = T.format(CR_BLOCK_TOOLTIP, GetShieldBlock());
	-- statFrame:Show();
-- end

-- Crit Chance
function PaperDollFrame_SetCritChance(statFrame, unit)
	if ( unit ~= "player" ) then
		statFrame:Hide();
		return;
	end

	local rating;
	local spellCrit, rangedCrit, meleeCrit;
	local critChance;

	-- Start at 2 to skip physical damage
	local holySchool = 2;
	local minCrit = T.GetSpellCritChance(holySchool);
	statFrame.spellCrit = {};
	statFrame.spellCrit[holySchool] = minCrit;
	local spellCrit;
	for i=(holySchool+1), MAX_SPELL_SCHOOLS do
		spellCrit = T.GetSpellCritChance(i);
		minCrit = T.math_min(minCrit, spellCrit);
		statFrame.spellCrit[i] = spellCrit;
	end
	spellCrit = minCrit
	rangedCrit = T.GetRangedCritChance();
	meleeCrit = T.GetCritChance();

	if (spellCrit >= rangedCrit and spellCrit >= meleeCrit) then
		critChance = spellCrit;
		rating = CR_CRIT_SPELL;
	elseif (rangedCrit >= meleeCrit) then
		critChance = rangedCrit;
		rating = CR_CRIT_RANGED;
	else
		critChance = meleeCrit;
		rating = CR_CRIT_MELEE;
	end
-- PaperDollFrame_SetLabelAndText Format Change
	T.PaperDollFrame_SetLabelAndText(statFrame, STAT_CRITICAL_STRIKE, T.string_format("%.2f%%", critChance), false, critChance);

	statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..T.string_format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_CRITICAL_STRIKE).." "..T.string_format("%.2f%%", critChance)..FONT_COLOR_CODE_CLOSE;
	local extraCritChance = T.GetCombatRatingBonus(rating);
	local extraCritRating = T.GetCombatRating(rating);
	if (T.GetCritChanceProvidesParryEffect()) then
		statFrame.tooltip2 = T.string_format(CR_CRIT_PARRY_RATING_TOOLTIP, T.BreakUpLargeNumbers(extraCritRating), extraCritChance, T.GetCombatRatingBonusForCombatRatingValue(CR_PARRY, extraCritRating));
	else
		statFrame.tooltip2 = T.string_format(CR_CRIT_TOOLTIP, T.BreakUpLargeNumbers(extraCritRating), extraCritChance);
	end
	statFrame:Show();
end

-- Haste
function PaperDollFrame_SetHaste(statFrame, unit)
	if ( unit ~= "player" ) then
		statFrame:Hide();
		return;
	end

	local haste = T.GetHaste();
	local rating = CR_HASTE_MELEE;

	local hasteFormatString;
	if (haste < 0) then
		hasteFormatString = RED_FONT_COLOR_CODE.."%s"..FONT_COLOR_CODE_CLOSE;
	else
		hasteFormatString = "%s";
	end
-- PaperDollFrame_SetLabelAndText Format Change
	T.PaperDollFrame_SetLabelAndText(statFrame, STAT_HASTE, T.string_format(hasteFormatString, T.string_format("%.2f%%", haste)), false, haste);
	statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. T.string_format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_HASTE) .. " " .. T.string_format(hasteFormatString, T.string_format("%.2f%%", haste)) .. FONT_COLOR_CODE_CLOSE;

	local _, class = T.UnitClass(unit);
	statFrame.tooltip2 = _G["STAT_HASTE_"..class.."_TOOLTIP"];
	if (not statFrame.tooltip2) then
		statFrame.tooltip2 = STAT_HASTE_TOOLTIP;
	end
	statFrame.tooltip2 = statFrame.tooltip2 .. T.string_format(STAT_HASTE_BASE_TOOLTIP, T.BreakUpLargeNumbers(T.GetCombatRating(rating)), T.GetCombatRatingBonus(rating));

	statFrame:Show();
end

function KA:CreateStatCategory(catName, text, noop)
	if not _G["CharacterStatsPane"][catName] then
		_G["CharacterStatsPane"][catName] = T.CreateFrame("Frame", nil, _G["CharacterStatsPane"], "CharacterStatFrameCategoryTemplate")
		_G["CharacterStatsPane"][catName].Title:SetText(text)
		_G["CharacterStatsPane"][catName]:StripTextures()
		_G["CharacterStatsPane"][catName]:CreateBackdrop("Transparent")
		_G["CharacterStatsPane"][catName].backdrop:ClearAllPoints()
		_G["CharacterStatsPane"][catName].backdrop:SetPoint("CENTER")
		_G["CharacterStatsPane"][catName].backdrop:SetWidth(150)
		_G["CharacterStatsPane"][catName].backdrop:SetHeight(18)
	end
	return catName
end

function KA:ResetAllStats()
	PAPERDOLL_STATCATEGORIES = {
		[1] = {
			categoryFrame = "AttributesCategory",
			stats = {
				[1] = { stat = "STRENGTH", primary = LE_UNIT_STAT_STRENGTH },
				[2] = { stat = "AGILITY", primary = LE_UNIT_STAT_AGILITY },
				[3] = { stat = "INTELLECT", primary = LE_UNIT_STAT_INTELLECT },
				[4] = { stat = "STAMINA" },
				[5] = { stat = "HEALTH", option = true },
				[6] = { stat = "POWER", option = true },
				[7] = { stat = "ALTERNATEMANA", option = true, classes = {"PRIEST", "SHAMAN", "DRUID"} },
				[8] = { stat = "MOVESPEED", option = true },
			},
		},
		[2] = {
			categoryFrame = KA:CreateStatCategory("OffenseCategory", STAT_CATEGORY_ATTACK),
			stats = {
				[1] = { stat = "ATTACK_DAMAGE", option = true, hideAt = 0 },
				[2] = { stat = "ATTACK_AP", option = true, hideAt = 0 },
				[3] = { stat = "ATTACK_ATTACKSPEED", option = true, hideAt = 0 },
				[4] = { stat = "SPELLPOWER", option = true, hideAt = 0 },
				[5] = { stat = "MANAREGEN", power = "MANA" },
				[6] = { stat = "ENERGY_REGEN", power = "ENERGY", hideAt = 0, roles = {"TANK", "DAMAGER"},  classes = {"ROUGE", "DRUID", "MONK"} },
				[7] = { stat = "FOCUS_REGEN", power = "FOCUS", hideAt = 0, classes = {"HUNTER"} },
				[8] = { stat = "RUNE_REGEN", power = "RUNIC_POWER", hideAt = 0, classes = {"DEATHKNIGHT"} },
			},
		},
		[3] = {
			categoryFrame = "EnhancementsCategory",
			stats = {
				[1] = { stat = "CRITCHANCE", hideAt = 0 },
				[2] = { stat = "HASTE", hideAt = 0 },
				[3] = { stat = "MASTERY", hideAt = 0 },
				[4] = { stat = "VERSATILITY", hideAt = 0 },
				[5] = { stat = "LIFESTEAL", hideAt = 0 },
			},
		},
		[4] = {
			categoryFrame = KA:CreateStatCategory("DefenceCategory", DEFENSE),
			stats = {
				[1] = { stat = "ARMOR", roles =  { "TANK" } },
				[2] = { stat = "AVOIDANCE", hideAt = 0 },
				[3] = { stat = "DODGE",},
				[4] = { stat = "PARRY", hideAt = 0, },
				[5] = { stat = "BLOCK", hideAt = 0, roles = {"TANK"} },
				[6] = { stat = "STAGGER", hideAt = 0, roles = {"TANK"}, classes = {"MONK"} },
			},
		},
	};
end

function KA:ToggleStats()
	KA:ResetAllStats()
	PaperDollFrame_UpdateStats();
end

function KA:PaperDollFrame_UpdateStats()
	totalShown = 0
	local total, equipped = T.GetAverageItemLevel()
	if E.db.KlixUI.armory.stats.IlvlFull then
		if _G["CharacterFrame"].ItemLevelText:IsShown() then
            _G["CharacterFrame"].ItemLevelText:Hide()
        end
        if not _G["CharacterStatsPane"].ItemLevelFrame.Value:IsShown() then
            _G.CharacterStatsPane.ItemLevelFrame.Value:Show()
        end
		if E.db.KlixUI.armory.stats.IlvlColor then
			local R, G, B = E:ColorGradient((equipped / total), 1, 0, 0, 1, 1, 0, 0, 1, 0)
			local avColor = E.db.KlixUI.armory.stats.AverageColor
			_G["CharacterStatsPane"].ItemLevelFrame.Value:SetFormattedText("%s%.2f|r |cffffffff/|r %s%.2f|r", E:RGBToHex(R, G, B), equipped, E:RGBToHex(avColor.r, avColor.g, avColor.b), total)
		else
			_G["CharacterStatsPane"].ItemLevelFrame.Value:SetFormattedText("%.2f |cffffffff/|r %.2f", equipped, total)
		end
	else
		_G["CharacterStatsPane"].ItemLevelFrame.Value:SetTextColor(T.GetItemLevelColor())
		T.PaperDollFrame_SetItemLevel(_G["CharacterStatsPane"].ItemLevelFrame, "player");
	end
	_G["CharacterStatsPane"].ItemLevelCategory:SetPoint("TOP", _G["CharacterStatsPane"], "TOP", 0, 8)
	_G["CharacterStatsPane"].AttributesCategory:SetPoint("TOP", _G["CharacterStatsPane"].ItemLevelFrame, "BOTTOM", 0, 6)

	local categoryYOffset = 8;
	local statYOffset = 0;

	_G["CharacterStatsPane"].ItemLevelCategory:Show();
	_G["CharacterStatsPane"].ItemLevelCategory.Title:FontTemplate(E.LSM:Fetch('font', E.db.KlixUI.armory.stats.catFonts.font), E.db.KlixUI.armory.stats.catFonts.size, E.db.KlixUI.armory.stats.catFonts.outline)
	_G["CharacterStatsPane"].ItemLevelFrame:Show();

	local spec = T.GetSpecialization();
	local role = T.GetSpecializationRole(spec);
	local _, powerType = T.UnitPowerType("player")
	-- print(T.GetSpecializationInfo(spec))

	_G["CharacterStatsPane"].statsFramePool:ReleaseAll();
	-- we need a stat frame to first do the math to know if we need to show the stat frame
	-- so effectively we'll always pre-allocate
	local statFrame = _G["CharacterStatsPane"].statsFramePool:Acquire();

	local lastAnchor;

	for catIndex = 1, #PAPERDOLL_STATCATEGORIES do
		local catFrame = _G["CharacterStatsPane"][PAPERDOLL_STATCATEGORIES[catIndex].categoryFrame];
		catFrame.Title:FontTemplate(E.LSM:Fetch('font', E.db.KlixUI.armory.stats.catFonts.font), E.db.KlixUI.armory.stats.catFonts.size, E.db.KlixUI.armory.stats.catFonts.outline)
		local numStatInCat = 0;
		for statIndex = 1, #PAPERDOLL_STATCATEGORIES[catIndex].stats do
			local stat = PAPERDOLL_STATCATEGORIES[catIndex].stats[statIndex];
			local showStat = true;
			if stat.option and not  E.db.KlixUI.armory.stats.List[stat.stat] then showStat = false end
			if ( showStat and stat.primary ) then
				local primaryStat = T.select(6, T.GetSpecializationInfo(spec, nil, nil, nil, T.UnitSex("player")));
				if ( stat.primary ~= primaryStat ) and E.db.KlixUI.armory.stats.OnlyPrimary then
					showStat = false;
				end
			end
			if ( showStat and stat.roles ) then
				local foundRole = false;
				for _, statRole in T.pairs(stat.roles) do
					if ( role == statRole ) then
						foundRole = true;
						break;
					end
				end
				if foundRole and stat.classes then
					for _, statClass in T.pairs(stat.classes) do
						if ( E.myclass == statClass ) then
							showStat = true;
							break;
						end
					end
				else
					showStat = foundRole;
				end
			end
			if stat.power and stat.power ~= powerType then showStat = false end
			if ( showStat ) then
				statFrame.onEnterFunc = nil;
				PAPERDOLL_STATINFO[stat.stat].updateFunc(statFrame, "player");
				statFrame.Label:FontTemplate(E.LSM:Fetch('font', E.db.KlixUI.armory.stats.statFonts.font), E.db.KlixUI.armory.stats.statFonts.size, E.db.KlixUI.armory.stats.statFonts.outline)
				statFrame.Value:FontTemplate(E.LSM:Fetch('font', E.db.KlixUI.armory.stats.statFonts.font), E.db.KlixUI.armory.stats.statFonts.size, E.db.KlixUI.armory.stats.statFonts.outline)
				if ( not stat.hideAt or stat.hideAt ~= statFrame.numericValue ) then
					if ( numStatInCat == 0 ) then
						if ( lastAnchor ) then
							catFrame:SetPoint("TOP", lastAnchor, "BOTTOM", 0, categoryYOffset);
						end
						lastAnchor = catFrame;
						statFrame:SetPoint("TOP", catFrame, "BOTTOM", 0, 6);
					else
						statFrame:SetPoint("TOP", lastAnchor, "BOTTOM", 0, statYOffset);
					end
					if statFrame:IsShown() then
						totalShown = totalShown + 1
						numStatInCat = numStatInCat + 1;
						-- statFrame.Background:SetShown((numStatInCat % 2) == 0);
						lastAnchor = statFrame;
					end
					-- done with this stat frame, get the next one
					statFrame = _G["CharacterStatsPane"].statsFramePool:Acquire();
				end
			end
		end
		catFrame:SetShown(numStatInCat > 0);
	end
	-- release the current stat frame
	_G["CharacterStatsPane"].statsFramePool:Release(statFrame);
	if totalShown > 12 then
		KA.Scrollbar:Show()
	else
		KA.Scrollbar:Hide()
	end
end

--Creating new scroll
--Scrollframe Parent Frame
KA.ScrollframeParentFrame = T.CreateFrame("Frame", nil, CharacterFrameInsetRight)
KA.ScrollframeParentFrame:SetSize(198, 352)
KA.ScrollframeParentFrame:SetPoint("TOP", CharacterFrameInsetRight, "TOP", 0, -4)

--Scrollframe 
KA.ScrollFrame = T.CreateFrame("ScrollFrame", nil, KA.ScrollframeParentFrame)
KA.ScrollFrame:SetPoint("TOP")
KA.ScrollFrame:SetSize(KA.ScrollframeParentFrame:GetSize())

--Scrollbar 
KA.Scrollbar = T.CreateFrame("Slider", nil, KA.ScrollFrame, "UIPanelScrollBarTemplate") 
KA.Scrollbar:SetPoint("TOPLEFT", CharacterFrameInsetRight, "TOPRIGHT", -12, -20) 
KA.Scrollbar:SetPoint("BOTTOMLEFT", CharacterFrameInsetRight, "BOTTOMRIGHT", -12, 18) 
KA.Scrollbar:SetMinMaxValues(1, 2) 
KA.Scrollbar:SetValueStep(1) 
KA.Scrollbar.scrollStep = 1
KA.Scrollbar:SetValue(0) 
KA.Scrollbar:SetWidth(8) 
KA.Scrollbar:SetScript("OnValueChanged", function (self, value) 
	self:GetParent():SetVerticalScroll(value) 
end)
E:GetModule("Skins"):HandleScrollBar(KA.Scrollbar)
KA.Scrollbar:Hide() 

--KA.ScrollChild Frame
KA.ScrollChild = T.CreateFrame("Frame", nil, KA.ScrollFrame)
KA.ScrollChild:SetSize(KA.ScrollFrame:GetSize())
KA.ScrollFrame:SetScrollChild(KA.ScrollChild)

CharacterStatsPane:ClearAllPoints()
CharacterStatsPane:SetParent(KA.ScrollChild)
CharacterStatsPane:SetSize(KA.ScrollChild:GetSize())
CharacterStatsPane:SetPoint("TOP", KA.ScrollChild, "TOP", 0, 0) 

CharacterStatsPane.ClassBackground:ClearAllPoints()
CharacterStatsPane.ClassBackground:SetParent(CharacterFrameInsetRight)
CharacterStatsPane.ClassBackground:SetPoint("CENTER")

-- Enable mousewheel scrolling
KA.ScrollFrame:EnableMouseWheel(true)
KA.ScrollFrame:SetScript("OnMouseWheel", function(self, delta)
	if totalShown > 12 then
		KA.Scrollbar:SetMinMaxValues(1, 45)  
	else
		KA.Scrollbar:SetMinMaxValues(1, 1) 
	end

	local cur_val = KA.Scrollbar:GetValue()
	local min_val, max_val = KA.Scrollbar:GetMinMaxValues()

	if delta < 0 and cur_val < max_val then
		cur_val = T.math_min(max_val, cur_val + 22)
		KA.Scrollbar:SetValue(cur_val)
	elseif delta > 0 and cur_val > min_val then
		cur_val = T.math_max(min_val, cur_val - 22)
		KA.Scrollbar:SetValue(cur_val)
	end
end)

PaperDollSidebarTab1:HookScript("OnShow", function(self,event) 
	KA.ScrollframeParentFrame:Show()
end)

PaperDollSidebarTab1:HookScript("OnClick", function(self,event) 
	KA.ScrollframeParentFrame:Show()
end)

PaperDollSidebarTab2:HookScript("OnClick", function(self,event) 
	KA.ScrollframeParentFrame:Hide()
end)

PaperDollSidebarTab3:HookScript("OnClick", function(self,event) 
	KA.ScrollframeParentFrame:Hide()
end)