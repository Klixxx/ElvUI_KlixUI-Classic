local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local KA = KUI:NewModule('KuiArmory', 'AceEvent-3.0', 'AceTimer-3.0', 'AceHook-3.0')
local LCG = LibStub('LibCustomGlow-1.0')
local LSM = E.LSM or E.Libs.LSM

local initialized = false
local updateTimer

local slots = {
	["HeadSlot"] = { true, true },
	["NeckSlot"] = { true, false },
	["ShoulderSlot"] = { true, true },
	["BackSlot"] = { true, false },
	["ChestSlot"] = { true, true },
	["WristSlot"] = { true, true },
	["MainHandSlot"] = { true, true },
	["SecondaryHandSlot"] = { true, true },
	["RangedSlot"] = { true, true },
	["AmmoSlot"] = { true, true },
	["HandsSlot"] = { true, true },
	["WaistSlot"] = { true, true },
	["LegsSlot"] = { true, true },
	["FeetSlot"] = { true, true },
	["Finger0Slot"] = { true, false },
	["ShirtSlot"] = { false, false },
	["Finger1Slot"] = { true, false },
	["TabardSlot"] = { false, false },
	["Trinket0Slot"] = { true, false },
	["Trinket1Slot"] = { true, false },
	
}

local slotIDs = {
	[1] = "HeadSlot",
	[2] = "NeckSlot",
	[3] = "ShoulderSlot",
	[5] = "ChestSlot",
	[6] = "ShirtSlot",
	[7] = "TabardSlot",
	[8] = "WaistSlot",
	[9] = "LegsSlot",
	[10] = "FeetSlot",
	[11] = "WristSlot",
	[12] = "HandsSlot",
	[13] = "Finger0Slot",
	[14] = "Finger1Slot",
	[15] = "Trinket0Slot",
	[16] = "Trinket1Slot",
	[17] = "BackSlot",
	[18] = "MainHandSlot",
	[19] = "SecondaryHandSlot",
	[20] = "RangedSlot",
	[21] = "AmmoSlot",
}

local levelColors = {
	[0] = "|cffff0000",
	[1] = "|cff00ff00",
	[2] = "|cffffff88",
}

function KA:UpdatePaperDoll()
	if not E.db.KlixUI.armory.enable then return end

	local unit = "player"
	if not unit then return end

	local frame, slot, current, maximum, r, g, b
	local itemLink, itemLevel, itemLevelMax, enchantInfo
	local _, numBonuses, affixes
	local EnchantGlowColor = {KA.db.indicators.enchant.glow.color.r, KA.db.indicators.enchant.glow.color.g, KA.db.indicators.enchant.glow.color.b, KA.db.indicators.enchant.glow.color.a or 1}
	local SocketGlowColor = {KA.db.indicators.socket.glow.color.r, KA.db.indicators.socket.glow.color.g, KA.db.indicators.socket.glow.color.b, KA.db.indicators.socket.glow.color.a or 1}

	for k, _ in T.pairs(slots) do
		frame = _G[("Character")..k]
		slot = T.GetInventorySlotInfo(k)
		if slot and slot ~= '' then
			-- Reset Data first
			--[[if not E.db.general.itemLevel.displayCharacterInfo then
				frame.ItemLevel:SetText("")
			end]]
			frame.DurabilityInfo:SetText("")
			--[[if not E.db.general.itemLevel.displayCharacterInfo then
				if KA.db.indicators.enchant.glow.enable then
					frame.EnchantInfo:Hide()
				else
					frame.EnchantInfo:SetText("")
				end
			end]]
			frame.Gradiation:Hide()

			itemLink = T.GetInventoryItemLink(unit, slot)
			if (itemLink and itemLink ~= nil) then
				if T.type(itemLink) ~= "string" then return end
				_, _, _, _, _, _, _, _, _, _, _, _, _, numBonuses, affixes = T.string_split(":", itemLink, 15)
				numBonuses = T.tonumber(numBonuses) or 0

				local _, _, itemRarity, _, _, _, _, _, itemEquipLoc = T.GetItemInfo(itemLink)
				-- Item Level
				--[[if not E.db.general.itemLevel.displayCharacterInfo then
					if KA.db.ilvl.enable then
						if ((slot == 16 or slot == 17) and T.GetInventoryItemQuality(unit, slot) == LE_ITEM_QUALITY_ARTIFACT) then
							local itemLevelMainHand = 0
							local itemLevelOffHand = 0
							local itemLinkMainHand = T.GetInventoryItemLink(unit, 16)
							local itemLinkOffhand = T.GetInventoryItemLink(unit, 17)
							if itemLinkMainHand then itemLevelMainHand = self:GetItemLevel(unit, itemLinkMainHand or 0) end
							if itemLinkOffhand then itemLevelOffHand = self:GetItemLevel(unit, itemLinkOffhand or 0) end
							itemLevel = T.math_max(itemLevelMainHand or 0, itemLevelOffHand or 0)
						else
							itemLevel = self:GetItemLevel(unit, itemLink)
						end
						if itemLevel and avgEquipItemLevel then
							frame.ItemLevel:SetText(itemLevel)
						end
						if (slot == 4 or slot == 19) then
							frame.ItemLevel:SetText("")
						end
						if itemRarity and KA.db.ilvl.colorStyle == "RARITY" then
							local r, g, b = T.GetItemQualityColor(itemRarity)
							frame.ItemLevel:SetTextColor(r, g, b)
						elseif KA.db.ilvl.colorStyle == "LEVEL" then
							frame.ItemLevel:SetFormattedText("%s%d|r", levelColors[(itemLevel < avgEquipItemLevel-10 and 0 or (itemLevel > avgEquipItemLevel + 10 and 1 or (2)))], itemLevel)
						else
							frame.ItemLevel:SetTextColor(KUI:unpackColor(KA.db.ilvl.color))
						end
					end

					-- Enchants
					if KA.db.indicators.enchant.enable then
						if KA.db.indicators.enchant.glow.enable then
							local enchantInfo = self:CheckEnchants(itemLink)
							if enchantInfo then
								if (slot == 11 or slot == 12 or slot == 16 or (slot == 17 and itemEquipLoc ~= 'INVTYPE_SHIELD' and itemEquipLoc ~= 'INVTYPE_HOLDABLE')) then
									frame.EnchantInfo:Show()
									frame.EnchantInfo:SetBackdropColor(0, 0, 0, 0)
									LCG.AutoCastGlow_Stop(frame.EnchantInfo)
									LCG.ButtonGlow_Stop(frame.EnchantInfo)
									LCG.PixelGlow_Stop(frame.EnchantInfo)
								end	
							else
								if (slot == 11 or slot == 12 or slot == 16 or (slot == 17 and itemEquipLoc ~= 'INVTYPE_SHIELD' and itemEquipLoc ~= 'INVTYPE_HOLDABLE')) then
									frame.EnchantInfo:Show()
									frame.EnchantInfo:SetBackdropColor(0, 0, 0, 0)
									if KA.db.indicators.enchant.glow.style == "Button" then
										LCG.PixelGlow_Stop(frame.EnchantInfo)
										LCG.AutoCastGlow_Stop(frame.EnchantInfo)
										LCG.ButtonGlow_Start(frame.EnchantInfo, EnchantGlowColor, 0.25)
									elseif KA.db.indicators.enchant.glow.style == "Pixel" then
										LCG.ButtonGlow_Stop(frame.EnchantInfo)
										LCG.AutoCastGlow_Stop(frame.EnchantInfo)
										LCG.PixelGlow_Start(frame.EnchantInfo, EnchantGlowColor, nil, 0.25, nil, 2)
									elseif KA.db.indicators.enchant.glow.style == "AutoCast" then
										LCG.ButtonGlow_Stop(frame.EnchantInfo)
										LCG.PixelGlow_Stop(frame.EnchantInfo)
										LCG.AutoCastGlow_Start(frame.EnchantInfo, EnchantGlowColor, 6, 0.25, 1.5)
									end
								end
							end
						else
							local enchantInfo = self:GetEnchants(itemLink)
							if enchantInfo then
								if (slot == 11 or slot == 12 or slot == 16 or (slot == 17 and itemEquipLoc ~= 'INVTYPE_SHIELD' and itemEquipLoc ~= 'INVTYPE_HOLDABLE')) then
									frame.EnchantInfo:SetText(enchantInfo)
								end
							end
						end
					end]]

				-- Durability
				if KA.db.durability.enable then
					frame.DurabilityInfo:SetText()
					current, maximum = T.GetInventoryItemDurability(slot)
					if current and maximum and (not KA.db.durability.onlydamaged or current < maximum) then
						r, g, b = E:ColorGradient((current / maximum), 1, 0, 0, 1, 1, 0, 0, 1, 0)
						frame.DurabilityInfo:SetFormattedText("%s%.0f%%|r", E:RGBToHex(r, g, b), (current / maximum) * 100)
					end
				end
				
				-- Gradiation
				if KA.db.gradient.enable then
					frame.Gradiation:Show()
					frame.Gradiation:SetAlpha(KA.db.gradient.alpha)
					if itemRarity and KA.db.gradient.colorStyle == "RARITY" then
						local r, g, b = T.GetItemQualityColor(itemRarity)
						frame.Gradiation.Texture:SetVertexColor(r, g, b)
					elseif KA.db.gradient.colorStyle == "VALUE" then
						frame.Gradiation.Texture:SetVertexColor(T.unpack(E.media.rgbvaluecolor))
					else
						frame.Gradiation.Texture:SetVertexColor(KUI:unpackColor(KA.db.gradient.color))
					end
				end
			end
		end
	end
end

-- from http://www.wowinterface.com/forums/showthread.php?p=284771 by PhanX
-- Construct your search pattern based on the existing global string:
-- local S_UPGRADE_LEVEL   = "^" .. T.string_gsub(ITEM_UPGRADE_TOOLTIP_FORMAT, "%%d", "(%%d+)")
local S_ITEM_LEVEL      = "^" .. T.string_gsub(ITEM_LEVEL, "%%d", "(%%d+)")

-- Create the tooltip:
local scantip = T.CreateFrame("GameTooltip", "MyScanningTooltip", nil, "GameTooltipTemplate")
scantip:SetOwner(E.UIParent, "ANCHOR_NONE")

local function GetRealItemLevel(itemLink)
	if not itemLink then return end
	
	-- Pass the item link to the tooltip
	scantip:ClearLines()
	scantip:SetHyperlink(itemLink)

	-- Scan the tooltip:
	for i = 2, scantip:NumLines() do -- Line 1 is always the name so you can skip it.
		local text = _G["MyScanningTooltipTextLeft"..i]:GetText()
		if text and text ~= "" then
			local currentLevel = T.string_match(text, S_ITEM_LEVEL)
			if currentLevel then
				return currentLevel
			end
		end
	end
end

function KA:GetItemLevel(unit, itemLink)
	if not itemLink then return end

	local rarity, itemLevel = T.select(3, T.GetItemInfo(itemLink))
	if rarity == 7 then -- heirloom adjust
		itemLevel = self:HeirLoomLevel(unit, itemLink)
	end

	itemLevel = GetRealItemLevel(itemLink)
	itemLevel = T.tonumber(itemLevel)
	return itemLevel
end

-- Check missing enchants
--[[function KA:CheckEnchants(itemLink)
	if not itemLink then return end
	
	-- Pass the item link to the tooltip
	scantip:ClearLines()
	scantip:SetHyperlink(itemLink)

	for i = 1, scantip:NumLines() do
		local enchant = _G["MyScanningTooltipTextLeft"..i]:GetText():match(ENCHANTED_TOOLTIP_LINE:gsub("%%s", "(.+)"))
		if enchant then
			return enchant
		end
	end
end

function KA:GetEnchants(itemLink)
	if not itemLink then return end

	local enchantInfo = self:CheckEnchants(itemLink)

	if enchantInfo then
		enchantInfo = "|cff00ff00E|r"
	else
		enchantInfo = "|cffff0000E|r"
	end

	return enchantInfo
end]]

function KA:InitialUpdatePaperDoll()
	KA:UnregisterEvent("PLAYER_ENTERING_WORLD")

	self:BuildInformation()

	-- update player info
	self:ScheduleTimer("UpdatePaperDoll", 2)

	initialized = true
end

local function UpdateiLvLPoints(id)
	if not id then return end
	
	if id <= 7 or id == 17 or id == 11 then 		-- Left side
		return "BOTTOMLEFT", "BOTTOMLEFT", 1, 2
	elseif id <= 16 then 							-- Right side
		return "BOTTOMRIGHT", "BOTTOMRIGHT", 2, 2
	else											-- Weapon slots
		if KA.db.indicators.illusion.enable then
			return "BOTTOM", "BOTTOM", 2, 6
		else
			return "BOTTOM", "BOTTOM", 2, 1
		end
	end
end

local function UpdateDurabilityPoints(id)
	if not id then return end
	
	if id <= 7 or id == 17 or id == 11 then 		-- Left side
		return "TOPRIGHT", "TOPRIGHT", 0, -3
	elseif id <= 16 then 							-- Right side
		return "TOPLEFT", "TOPLEFT", 2, -3
	else											-- Weapon slots
		return "TOPLEFT", "TOPLEFT", 2, -3
	end
end

function KA:BuildInformation()
	for id, slotName in T.pairs(slotIDs) do
		if not id then return end
		
		local frame = _G["Character"..slotIDs[id]]
		local iLvLPoint, iLvLParentPoint, x1, y1 = UpdateiLvLPoints(id)
		local DuraPoint, DuraParentPoint, x2, y2 = UpdateDurabilityPoints(id)
		
		-- Item Level
		--[[if not E.db.general.itemLevel.displayCharacterInfo then
			frame.ItemLevel = frame:CreateFontString(nil, "OVERLAY")
			frame.ItemLevel:SetPoint(iLvLPoint, frame, iLvLParentPoint, x1 or 0, y1 or 0)
			frame.ItemLevel:FontTemplate(LSM:Fetch("font", KA.db.ilvl.font), KA.db.ilvl.textSize, KA.db.ilvl.fontOutline)
		end]]

		-- Durability
		frame.DurabilityInfo = frame:CreateFontString(nil, "OVERLAY")
		frame.DurabilityInfo:SetPoint(DuraPoint, frame, DuraParentPoint, x2 or 0, y2 or 0)
		frame.DurabilityInfo:FontTemplate(LSM:Fetch("font", KA.db.durability.font), KA.db.durability.textSize, KA.db.durability.fontOutline)
		
		-- Enchant Info
		--[[if not E.db.general.itemLevel.displayCharacterInfo then
			if KA.db.indicators.enchant.glow.enable then
				frame.EnchantInfo = T.CreateFrame('Frame', nil, frame)
				frame.EnchantInfo:Size(37)
				frame.EnchantInfo:SetBackdrop({
					bgFile = E.media.blankTex,
					edgeFile = E.media.blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				frame.EnchantInfo:SetBackdropBorderColor(0, 0, 0, 0)
				frame.EnchantInfo:SetPoint("CENTER", frame, "CENTER", 0, 0)
			else
				frame.EnchantInfo = frame:CreateFontString(nil, "OVERLAY")
				frame.EnchantInfo:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 1, -1)
				frame.EnchantInfo:FontTemplate(LSM:Fetch("font", KA.db.durability.font), (KA.db.durability.textSize + 1), KA.db.durability.fontOutline)
			end
		end]]
		
		-- Gradiation
		frame.Gradiation = T.CreateFrame('Frame', nil, frame)
		frame.Gradiation:Size(120, 41)
		frame.Gradiation:SetFrameLevel(_G["CharacterModelFrame"]:GetFrameLevel())

		frame.Gradiation.Texture = frame.Gradiation:CreateTexture(nil, "OVERLAY")
		frame.Gradiation.Texture:SetInside()
		frame.Gradiation.Texture:SetTexture('Interface\\AddOns\\ElvUI_KlixUI\\media\\textures\\Gradation')

		if id <= 7 or id == 17 or id == 11 then -- Left Side
			frame.Gradiation:SetPoint("LEFT", _G["Character"..slotName], "RIGHT", -20, 0)
			frame.Gradiation.Texture:SetTexCoord(0, 1, 0, 1)
		elseif id <= 16 then -- Right Side
			frame.Gradiation:SetPoint("RIGHT", _G["Character"..slotName], "LEFT", 20, 0)
			frame.Gradiation.Texture:SetTexCoord(1, 0, 0, 1)
		end
	end
end

function KA:Initialize()
	if not E.db.KlixUI.armory.enable or not E.private.skins.blizzard.character then return end

	KA.db = E.db.KlixUI.armory

	KUI:RegisterDB(self, "armory")
    
    local frame = T.CreateFrame("Frame", "KuiCharacterArmory", _G["PaperDollFrame"])
    frame:SetFrameLevel(CharacterModelFrame:GetFrameLevel() - 1)
    frame.BG = frame:CreateTexture(nil, "OVERLAY")
    frame.BG:SetPoint("TOPLEFT", CharacterModelFrame, 0, 0)
    frame.BG:SetPoint("BOTTOMRIGHT", CharacterModelFrame, 0, 0)
	
	KA:RegisterEvent("UPDATE_INVENTORY_DURABILITY", "UpdatePaperDoll", false)
	KA:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "UpdatePaperDoll", false)
	KA:RegisterEvent("COMBAT_RATING_UPDATE", "UpdatePaperDoll", false)
	KA:RegisterEvent("PLAYER_ENTERING_WORLD", "InitialUpdatePaperDoll")
end

KUI:RegisterModule(KA:GetName())