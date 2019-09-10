local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local SCT = KUI:NewModule("ScrollingCombatText", "AceEvent-3.0", "AceTimer-3.0")
local LE = LibStub("LibEasing-1.0")
local LSM = E.LSM or E.Libs.LSM

SCT.frame = T.CreateFrame("Frame", nil, UIParent)

-- Locals
local _
local animating = {}

local playerGUID = T.UnitGUID("player")
local unitToGuid = {}
local guidToUnit = {}

local targetFrames = {}
for level = 1, 3 do
    targetFrames[level] = T.CreateFrame("Frame", nil, UIParent)
end

local offTargetFrames = {}
for level = 1, 3 do
    offTargetFrames[level] = T.CreateFrame("Frame", nil, UIParent)
end

-- local constants
local SMALL_HIT_EXPIRY_WINDOW = 30
local SMALL_HIT_MULTIPIER = 0.5

local ANIMATION_VERTICAL_DISTANCE = 75

local ANIMATION_ARC_X_MIN = 50
local ANIMATION_ARC_X_MAX = 150
local ANIMATION_ARC_Y_TOP_MIN = 10
local ANIMATION_ARC_Y_TOP_MAX = 50
local ANIMATION_ARC_Y_BOTTOM_MIN = 10
local ANIMATION_ARC_Y_BOTTOM_MAX = 50

-- local ANIMATION_SHAKE_DEFLECTION = 15
-- local ANIMATION_SHAKE_NUM_SHAKES = 4

local ANIMATION_RAINFALL_X_MAX = 75
local ANIMATION_RAINFALL_Y_MIN = 50
local ANIMATION_RAINFALL_Y_MAX = 100
local ANIMATION_RAINFALL_Y_START_MIN = 5
local ANIMATION_RAINFALL_Y_START_MAX = 15

local ANIMATION_LENGTH = 1

local DAMAGE_TYPE_COLORS = {
    [SCHOOL_MASK_PHYSICAL] = "FFFF00",
    [SCHOOL_MASK_HOLY] = "FFE680",
    [SCHOOL_MASK_FIRE] = "FF8000",
    [SCHOOL_MASK_NATURE] = "4DFF4D",
    [SCHOOL_MASK_FROST] = "80FFFF",
    [SCHOOL_MASK_SHADOW] = "8080FF",
    [SCHOOL_MASK_ARCANE] = "FF80FF",
	[SCHOOL_MASK_FIRE + SCHOOL_MASK_FROST + SCHOOL_MASK_ARCANE + SCHOOL_MASK_NATURE + SCHOOL_MASK_SHADOW] = "A330C9", -- Chromatic
	[SCHOOL_MASK_FIRE + SCHOOL_MASK_FROST + SCHOOL_MASK_ARCANE + SCHOOL_MASK_NATURE + SCHOOL_MASK_SHADOW + SCHOOL_MASK_HOLY] = "A330C9", -- Magic
	[SCHOOL_MASK_PHYSICAL + SCHOOL_MASK_FIRE + SCHOOL_MASK_FROST + SCHOOL_MASK_ARCANE + SCHOOL_MASK_NATURE + SCHOOL_MASK_SHADOW + SCHOOL_MASK_HOLY] = "A330C9", -- Chaos
	["melee"] = "FFFFFF",
	["pet"] = "CC8400"
};

local MISS_EVENT_STRINGS = {
    ["ABSORB"] = L["Absorbed"],
    ["BLOCK"] = L["Blocked"],
    ["DEFLECT"] = L["Deflected"],
    ["DODGE"] = L["Dodged"],
    ["EVADE"] = L["Evaded"],
    ["IMMUNE"] = L["Immune"],
    ["MISS"] = L["Missed"],
    ["PARRY"] = L["Parried"],
    ["REFLECT"] = L["Reflected"],
    ["RESIST"] = L["Resisted"],
};

local FRAME_LEVEL_OVERLAY = 3
local FRAME_LEVEL_ABOVE = 2
local FRAME_LEVEL_BELOW = 1

-- Fontstring
local function getFontPath(fontName)
    local fontPath = LSM:Fetch("font", fontName)

    if (fontPath == nil) then
        fontPath = "Interface\\AddOns\\ElvUI_KlixUI\\media\\fonts\\Expressway.ttf"
    end

    return fontPath
end

local fontStringCache = {}
local function getFontString()
    local fontString;

    if (T.next(fontStringCache)) then
        fontString = T.table_remove(fontStringCache)
    else
        fontString = SCT.frame:CreateFontString()
    end

    fontString:SetParent(SCT.frame);
    fontString:SetFont(getFontPath(SCT.db.font), 15, SCT.db.fontFlag)
    if SCT.db.fontShadow then fontString:SetShadowOffset(1,-1) end
    fontString:SetAlpha(1)
    fontString:SetDrawLayer("OVERLAY")
    fontString:SetText("")
    fontString:Show()

    return fontString
end

local function recycleFontString(fontString)
    fontString:SetAlpha(0)
    fontString:Hide()

    animating[fontString] = nil

    fontString.distance = nil
    fontString.arcTop = nil
    fontString.arcBottom = nil
    fontString.arcXDist = nil
    fontString.deflection = nil
    fontString.numShakes = nil
    fontString.animation = nil
    fontString.animatingDuration = nil
    fontString.animatingStartTime = nil
    fontString.anchorFrame = nil

    fontString.unit = nil
    fontString.guid = nil

    fontString.pow = nil
    fontString.startHeight = nil
    fontString.SCTFontSize = nil
    fontString:SetFont(getFontPath(SCT.db.font), 15, SCT.db.fontFlag)
    if SCT.db.fontShadow then fontString:SetShadowOffset(1,-1) end
    fontString:SetParent(SCT.frame)
	fontString:ClearAllPoints()

    T.table_insert(fontStringCache, fontString);
end

local function setNameplateFrameLevels()
    for _, frame in T.pairs(targetFrames) do
        frame:SetFrameStrata("LOW")
    end
    targetFrames[FRAME_LEVEL_OVERLAY]:SetFrameLevel(1001)
    targetFrames[FRAME_LEVEL_ABOVE]:SetFrameLevel(1000)
    targetFrames[FRAME_LEVEL_BELOW]:SetFrameLevel(999)

    for _, frame in T.pairs(offTargetFrames) do
        frame:SetFrameStrata("LOW")
    end
    offTargetFrames[FRAME_LEVEL_OVERLAY]:SetFrameLevel(901)
    offTargetFrames[FRAME_LEVEL_ABOVE]:SetFrameLevel(900)
    offTargetFrames[FRAME_LEVEL_BELOW]:SetFrameLevel(899)
end

-- Animation
local function verticalPath(elapsed, duration, distance)
    return 0, LE.InQuad(elapsed, 0, distance, duration);
end

local function arcPath(elapsed, duration, xDist, yStart, yTop, yBottom)
    local x, y;
    local progress = elapsed/duration;

    x = progress * xDist;

    -- progress 0 to 1
    -- at progress 0, y = yStart
    -- at progress 0.5 y = yTop
    -- at progress 1 y = yBottom

    -- -0.25a + .5b + yStart = yTop
    -- -a + b + yStart = yBottom

    -- -0.25a + .5b + yStart = yTop
    -- .5b + yStart - yTop = 0.25a
    -- 2b + 4yStart - 4yTop = a

    -- -(2b + 4yStart - 4yTop) + b + yStart = yBottom
    -- -2b - 4yStart + 4yTop + b + yStart = yBottom
    -- -b - 3yStart + 4yTop = yBottom

    -- -3yStart + 4yTop - yBottom = b

    -- 2(-3yStart + 4yTop - yBottom) + 4yStart - 4yTop = a
    -- -6yStart + 8yTop - 2yBottom + 4yStart - 4yTop = a
    -- -2yStart + 4yTop - 2yBottom = a

    -- -3yStart + 4yTop - yBottom = b
    -- -2yStart + 4yTop - 2yBottom = a

    local a = -2 * yStart + 4 * yTop - 2 * yBottom;
    local b = -3 * yStart + 4 * yTop - yBottom;

    y = -a * T.math_pow(progress, 2) + b * progress + yStart;

    return x, y;
end

local function powSizing(elapsed, duration, start, middle, finish)
    local size = finish;
    if (elapsed < duration) then
        if (elapsed/duration < 0.5) then
            size = LE.OutQuint(elapsed, start, middle - start, duration/2);
        else
            size = LE.InQuint(elapsed - elapsed/2, middle, finish - middle, duration/2);
        end
    end
    return size;
end

local function AnimationOnUpdate()
    if (T.next(animating)) then
        -- setNameplateFrameLevels();

        for fontString, _ in T.pairs(animating) do
            local elapsed = T.GetTime() - fontString.animatingStartTime;
            if (elapsed > fontString.animatingDuration) then
                -- the animation is over
                recycleFontString(fontString);
            else
                local isTarget = false
                if fontString.unit then
                  isTarget = T.UnitIsUnit(fontString.unit, "target");
                else
                  fontString.unit = "player"
                end
                -- frame level
                if (fontString.frameLevel) then
                    if (isTarget) then
                        if (fontString:GetParent() ~= targetFrames[fontString.frameLevel]) then
                            fontString:SetParent(targetFrames[fontString.frameLevel])
                        end
                    else
                        if (fontString:GetParent() ~= offTargetFrames[fontString.frameLevel]) then
                            fontString:SetParent(offTargetFrames[fontString.frameLevel])
                        end
                    end
                end

                -- alpha
                local startAlpha = SCT.db.formatting.alpha;
                if (SCT.db.useOffTarget and not isTarget and fontString.unit ~= "player") then
                    startAlpha = SCT.db.offTargetFormatting.alpha;
                end

                local alpha = LE.InExpo(elapsed, startAlpha, -startAlpha, fontString.animatingDuration);
                fontString:SetAlpha(alpha);

                -- sizing
                if (fontString.pow) then
                    if (elapsed < fontString.animatingDuration/6) then
                        fontString:SetText(fontString.SCTTextWithoutIcons);

                        local size = powSizing(elapsed, fontString.animatingDuration/6, fontString.startHeight/2, fontString.startHeight*2, fontString.startHeight);
                        fontString:SetTextHeight(size);
                    else
                        fontString.pow = nil;
                        fontString:SetTextHeight(fontString.startHeight);
                        fontString:SetFont(getFontPath(SCT.db.font), fontString.SCTFontSize, SCT.db.fontFlag);
                        if SCT.db.fontShadow then fontString:SetShadowOffset(1,-1) end
                        fontString:SetText(fontString.SCTText);
                    end
                end

                -- position
                local xOffset, yOffset = 0, 0;
                if (fontString.animation == "verticalUp") then
                    xOffset, yOffset = verticalPath(elapsed, fontString.animatingDuration, fontString.distance);
                elseif (fontString.animation == "verticalDown") then
                    xOffset, yOffset = verticalPath(elapsed, fontString.animatingDuration, -fontString.distance);
                elseif (fontString.animation == "fountain") then
                    xOffset, yOffset = arcPath(elapsed, fontString.animatingDuration, fontString.arcXDist, 0, fontString.arcTop, fontString.arcBottom);
                elseif (fontString.animation == "rainfall") then
                    _, yOffset = verticalPath(elapsed, fontString.animatingDuration, -fontString.distance);
                    xOffset = fontString.rainfallX;
                    yOffset = yOffset + fontString.rainfallStartY;
                -- elseif (fontString.animation == "shake") then
                    -- TODO
                end

                if (not UnitIsDead(fontString.unit) and fontString.anchorFrame and fontString.anchorFrame:IsShown()) then
                    if fontString.unit == "player" then -- player frame
						fontString:SetPoint("CENTER", fontString.anchorFrame, "CENTER", SCT.db.xOffsetPersonal + xOffset, SCT.db.yOffsetPersonal + yOffset); -- Only allows for adjusting vertical offset
                    else -- nameplate frames
						fontString:SetPoint("CENTER", fontString.anchorFrame, "CENTER", SCT.db.xOffset + xOffset, SCT.db.yOffset + yOffset);
                    end
                    -- remember the last position of the nameplate
                else
                    recycleFontString(fontString);
                end
            end
        end
    else
        -- nothing in the animation list, so just kill the onupdate
        SCT.frame:SetScript("OnUpdate", nil);
    end
end

-- SCT.AnimationOnUpdate = AnimationOnUpdate;

local arcDirection = 1;
function SCT:Animate(fontString, anchorFrame, duration, animation)
    animation = animation or "verticalUp";

    fontString.animation = animation;
    fontString.animatingDuration = duration;
    fontString.animatingStartTime = T.GetTime();
    fontString.anchorFrame = anchorFrame == player and UIParent or anchorFrame;

    if (animation == "verticalUp") then
        fontString.distance = ANIMATION_VERTICAL_DISTANCE;
    elseif (animation == "verticalDown") then
        fontString.distance = ANIMATION_VERTICAL_DISTANCE;
    elseif (animation == "fountain") then
        fontString.arcTop = T.math_random(ANIMATION_ARC_Y_TOP_MIN, ANIMATION_ARC_Y_TOP_MAX);
        fontString.arcBottom = -T.math_random(ANIMATION_ARC_Y_BOTTOM_MIN, ANIMATION_ARC_Y_BOTTOM_MAX);
        fontString.arcXDist = arcDirection * T.math_random(ANIMATION_ARC_X_MIN, ANIMATION_ARC_X_MAX);

        arcDirection = arcDirection * -1;
    elseif (animation == "rainfall") then
        fontString.distance = T.math_random(ANIMATION_RAINFALL_Y_MIN, ANIMATION_RAINFALL_Y_MAX);
        fontString.rainfallX = T.math_random(-ANIMATION_RAINFALL_X_MAX, ANIMATION_RAINFALL_X_MAX);
        fontString.rainfallStartY = -T.math_random(ANIMATION_RAINFALL_Y_START_MIN, ANIMATION_RAINFALL_Y_START_MAX);
    -- elseif (animation == "shake") then
    --     fontString.deflection = ANIMATION_SHAKE_DEFLECTION;
    --     fontString.numShakes = ANIMATION_SHAKE_NUM_SHAKES;
    end

    animating[fontString] = true;

    -- start onupdate if it's not already running
    if (SCT.frame:GetScript("OnUpdate") == nil) then
        SCT.frame:SetScript("OnUpdate", AnimationOnUpdate);
    end
end


-- Events
function SCT:NAME_PLATE_UNIT_ADDED(event, unitID)
    local guid = T.UnitGUID(unitID)

    unitToGuid[unitID] = guid
    guidToUnit[guid] = unitID
end

function SCT:NAME_PLATE_UNIT_REMOVED(event, unitID)
    local guid = unitToGuid[unitID]

    unitToGuid[unitID] = nil
    guidToUnit[guid] = nil

    -- clear any fontStrings attachedk to this unit
   for fontString, _ in T.pairs(animating) do
		if fontString.unit == unitID then
			recycleFontString(fontString)
		end
	end
end

function SCT:CombatFilter(_, clue, _, sourceGUID, _, sourceFlags, _, destGUID, _, _, _, ...)
	if playerGUID == sourceGUID or (SCT.db.personal and playerGUID == destGUID) then -- Player events
		local destUnit = guidToUnit[destGUID];
		if (destUnit) or (destGUID == playerGUID and SCT.db.personal) then
			if (T.string_find(clue, "_DAMAGE")) then
				local spellID, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand;
				if (T.string_find(clue, "SWING")) then
					spellName, amount, overkill, school_ignore, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = "melee", ...;
				elseif (T.string_find(clue, "ENVIRONMENTAL")) then
					spellName, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = ...;
				else
					spellID, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = ...;
				end
				self:DamageEvent(destGUID, spellID, amount, school, critical, spellName);
			elseif(T.string_find(clue, "_MISSED")) then
				local spellID, spellName, spellSchool, missType, isOffHand, amountMissed;

				if (T.string_find(clue, "SWING")) then
					if destGUID == playerGUID then
					  missType, isOffHand, amountMissed = ...;
					else
					  missType, isOffHand, amountMissed = "melee", ...;
					end
				else
					spellID, spellName, spellSchool, missType, isOffHand, amountMissed = ...;
				end
				self:MissEvent(destGUID, nil, missType);
			end
		end
	elseif (T.bit_band(sourceFlags, COMBATLOG_OBJECT_TYPE_GUARDIAN) > 0 or T.bit_band(sourceFlags, COMBATLOG_OBJECT_TYPE_PET) > 0)	and T.bit_band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 then -- Pet/Guardian events
		local destUnit = guidToUnit[destGUID];
		if (destUnit) or (destGUID == playerGUID and SCT.db.personal) then
			if (T.string_find(clue, "_DAMAGE")) then
				local spellID, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand;
				if (T.string_find(clue, "SWING")) then
					spellName, amount, overkill, school_ignore, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = "pet", ...;
				elseif (T.string_find(clue, "ENVIRONMENTAL")) then
					spellName, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = ...;
				else
					spellID, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = ...;
				end
				self:DamageEvent(destGUID, nil, amount, "pet", critical, spellName);
			-- elseif(T.string_find(clue, "_MISSED")) then -- Don't show pet MISS events for now.
				-- local spellID, spellName, spellSchool, missType, isOffHand, amountMissed;

				-- if (T.string_find(clue, "SWING")) then
					-- if destGUID == playerGUID then
					  -- missType, isOffHand, amountMissed = ...;
					-- else
					  -- missType, isOffHand, amountMissed = "pet", ...;
					-- end
				-- else
					-- spellID, spellName, spellSchool, missType, isOffHand, amountMissed = ...;
				-- end
				-- self:MissEvent(destGUID, spellID, missType);
			end
		end
	end
end

function SCT:COMBAT_LOG_EVENT_UNFILTERED()
	return SCT:CombatFilter(T.CombatLogGetCurrentEventInfo())
end

-- Display
local function commaSeperate(number)
    -- https://stackoverflow.com/questions/10989788/lua-format-integer
    local _, _, minus, int, fraction = T.tostring(number):find('([-]?)(%d+)([.]?%d*)');
    int = int:reverse():gsub("(%d%d%d)", "%1,");
    return minus..int:reverse():gsub("^,", "")..fraction;
end

local numDamageEvents = 0;
local lastDamageEventTime;
local runningAverageDamageEvents = 0;
function SCT:DamageEvent(guid, spellID, amount, school, crit, spellName)
    local text, textWithoutIcons, animation, pow, size, icon, alpha
    local frameLevel = FRAME_LEVEL_ABOVE
    local autoattack = not spellID
	
	-- select an animation
    if (autoattack and crit) then
        frameLevel = FRAME_LEVEL_OVERLAY;
        animation = guid ~= playerGUID and SCT.db.animations.autoattackcrit or SCT.db.animationsPersonal.crit;
        pow = true;
    elseif (autoattack) then
        animation = guid ~= playerGUID and SCT.db.animations.autoattack or SCT.db.animationsPersonal.normal;
        pow = false;
    elseif (crit) then
        frameLevel = FRAME_LEVEL_OVERLAY;
        animation = guid ~= playerGUID and SCT.db.animations.crit or SCT.db.animationsPersonal.crit;
        pow = true;
    elseif (not autoattack and not crit) then
        animation = guid ~= playerGUID and SCT.db.animations.ability or SCT.db.animationsPersonal.normal;
        pow = false;
	else
		KUI:Print("woops")
    end
	
    -- skip if this damage event is disabled
    if (animation == "disabled") then
        return;
    end;
	
    local unit = guidToUnit[guid];
    local isTarget = unit and T.UnitIsUnit(unit, "target");

    if (SCT.db.useOffTarget and not isTarget and playerGUID ~= guid) then
        size = SCT.db.offTargetFormatting.size;
        icon = SCT.db.offTargetFormatting.icon;
        alpha = SCT.db.offTargetFormatting.alpha;
    else
        size = SCT.db.formatting.size;
        icon = SCT.db.formatting.icon;
        alpha = SCT.db.formatting.alpha;
    end

    if (icon ~= "only") then
        -- truncate
        if (SCT.db.truncate and amount >= 1000000 and SCT.db.truncateLetter) then
            text = T.string_format("%.1fM", amount / 1000000);
		elseif (SCT.db.truncate and amount >= 10000) then
            text = T.string_format("%.0f", amount / 1000);

            if (SCT.db.truncateLetter) then
                text = text.."k";
            end
        elseif (SCT.db.truncate and amount >= 1000) then
            text = T.string_format("%.1f", amount / 1000);

            if (SCT.db.truncateLetter) then
                text = text.."k";
            end
        else
            if (SCT.db.commaSeperate) then
                text = commaSeperate(amount);
            else
                text = T.tostring(amount);
            end
        end

        -- color text
		if guid ~= playerGUID then
			if SCT.db.damageColor and school and DAMAGE_TYPE_COLORS[school] then
				text = "|Cff"..DAMAGE_TYPE_COLORS[school]..text.."|r";
			elseif SCT.db.damageColor and spellName == "melee" and DAMAGE_TYPE_COLORS[spellName] then
				text = "|Cff"..DAMAGE_TYPE_COLORS[spellName]..text.."|r";
			else
				text = "|Cff"..SCT.db.defaultColor..text.."|r";
			end
		else
			if SCT.db.damageColorPersonal and school and DAMAGE_TYPE_COLORS[school] then
				text = "|Cff"..DAMAGE_TYPE_COLORS[school]..text.."|r";
			elseif SCT.db.damageColorPersonal and spellName == "melee" and DAMAGE_TYPE_COLORS[spellName] then
				text = "|Cff"..DAMAGE_TYPE_COLORS[spellName]..text.."|r";
			else
				text = "|Cff"..SCT.db.defaultColorPersonal..text.."|r";
			end
		end
	
		-- add icons
        textWithoutIcons = text;
        if (icon ~= "none" and spellName) then
			local _, _, iconTexture = GetSpellInfo(spellName)
			if iconTexture then
				local iconText = "|T"..iconTexture..":14:14:0:0:64:64:4:60:4:60|t"

				if (icon == "both") then
					text = iconText..text..iconText
				elseif (icon == "left") then
					text = iconText..text
				elseif (icon == "right") then
					text = text..iconText
				end
			end
        end
    else
        -- showing only icons
        if (not spellID) then
            return
        end

        text = "|T"..GetSpellTexture(spellID)..":14:14:0:0:64:64:4:60:4:60|t"
        textWithoutIcons = text; -- since the icon is by itself, the fontString won't have the strange scaling bug
    end
	
    -- shrink small hits
    if (SCT.db.sizing.smallHits or SCT.db.sizing.smallHitsHide) and playerGUID ~= guid then
        if (not lastDamageEventTime or (lastDamageEventTime + SMALL_HIT_EXPIRY_WINDOW < T.GetTime())) then
            numDamageEvents = 0;
            runningAverageDamageEvents = 0;
        end

        runningAverageDamageEvents = ((runningAverageDamageEvents*numDamageEvents) + amount)/(numDamageEvents + 1);
        numDamageEvents = numDamageEvents + 1;
        lastDamageEventTime = T.GetTime();

        if ((not crit and amount < SMALL_HIT_MULTIPIER*runningAverageDamageEvents)
            or (crit and amount/2 < SMALL_HIT_MULTIPIER*runningAverageDamageEvents)) then
            if (SCT.db.sizing.smallHitsHide) then
                -- skip this damage event, it's too small
                return;
            else
                size = size * SCT.db.sizing.smallHitsScale;
            end
        end
    end

    -- embiggen crit's size
    if (SCT.db.sizing.crits and crit) and playerGUID ~= guid then
        if (autoattack and not SCT.db.sizing.autoattackcritsizing) then
            -- don't embiggen autoattacks
            pow = false;
        else
            size = size * SCT.db.sizing.critsScale;
        end
    end

    -- make sure that size is larger than 5
    if (size < 5) then
        size = 5;
    end

    self:DisplayText(guid, text, textWithoutIcons, size, animation, frameLevel, pow);
end

function SCT:MissEvent(guid, spellID, missType)
    local text, animation, pow, size, icon, alpha
    local unit = guidToUnit[guid]
    local isTarget = unit and T.UnitIsUnit(unit, "target")

    if (SCT.db.useOffTarget and not isTarget and playerGUID ~= guid) then
        size = SCT.db.offTargetFormatting.size
        icon = SCT.db.offTargetFormatting.icon
        alpha = SCT.db.offTargetFormatting.alpha
    else
        size = SCT.db.formatting.size
        icon = SCT.db.formatting.icon
        alpha = SCT.db.formatting.alpha
    end

    -- embiggen miss size
    if SCT.db.sizing.miss and playerGUID ~= guid then
        size = size * SCT.db.sizing.missScale;
    end

    if (icon == "only") then
        return;
    end

    if playerGUID ~= guid then
		animation = SCT.db.animations.miss
		color = SCT.db.defaultColor
	else
		animation = SCT.db.animationsPersonal.miss
		color = SCT.db.defaultColorPersonal
	end
	
    pow = true

    text = MISS_EVENT_STRINGS[missType] or "Missed"
    text = "|Cff"..SCT.db.defaultColor..text.."|r"

    -- add icons
    local textWithoutIcons = text
    if (icon ~= "none" and spellName) then
		local _, _, iconTexture = GetSpellInfo(spellName)
		if iconTexture then
			local iconText = "|T"..iconTexture..":14:14:0:0:64:64:4:60:4:60|t"

			if (icon == "both") then
				text = iconText..text..iconText
			elseif (icon == "left") then
				text = iconText..text
			elseif (icon == "right") then
				text = text..iconText
			end
		end
    end

    self:DisplayText(guid, text, textWithoutIcons, size, animation, FRAME_LEVEL_ABOVE, pow)
end

function SCT:DisplayText(guid, text, textWithoutIcons, size, animation, frameLevel, pow)
    local fontString;
    local unit = guidToUnit[guid];
    local nameplate;

    if (unit) then
        nameplate = T.C_NamePlate_GetNamePlateForUnit(unit);
    end

    -- if there isn't an anchor frame, make sure that there is a guidNameplatePosition cache entry
    if playerGUID == guid and not unit then
          nameplate = player
    elseif (not nameplate) then
        return;
    end

    fontString = getFontString();

    fontString.SCTText = text;
    fontString.SCTTextWithoutIcons = textWithoutIcons;
    fontString:SetText(fontString.SCTText);

    fontString.SCTFontSize = size;
    fontString:SetFont(getFontPath(SCT.db.font), fontString.SCTFontSize, SCT.db.fontFlag);
    if SCT.db.fontShadow then fontString:SetShadowOffset(1,-1) end
    fontString.startHeight = fontString:GetStringHeight();
    fontString.pow = pow;
    fontString.frameLevel = frameLevel;

    if (fontString.startHeight <= 0) then
        fontString.startHeight = 5;
    end

    fontString.unit = unit;
    fontString.guid = guid;

    -- if there is no nameplate,
    self:Animate(fontString, nameplate, ANIMATION_LENGTH, animation);
end

function SCT:Initialize()
	if not E.db.KlixUI.combattext.enable or T.IsAddOnLoaded("NameplateSCT") or T.IsAddOnLoaded("ElvUI_FCT") then return end
	
	SCT.db = E.db.KlixUI.combattext

	KUI:RegisterDB(self, "combattext")

	function SCT:ForUpdateAll()
		SCT.db = E.db.KlixUI.combattext
	end

	self:ForUpdateAll()
	
	setNameplateFrameLevels();
	
    SCT:RegisterEvent("NAME_PLATE_UNIT_ADDED");
    SCT:RegisterEvent("NAME_PLATE_UNIT_REMOVED");
    SCT:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
end

local function InitializeCallback()
	SCT:Initialize()
end

KUI:RegisterModule(SCT:GetName(), InitializeCallback)