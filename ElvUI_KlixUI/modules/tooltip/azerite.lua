-------------------------------------------------------------------------------
-- Credits: AzeriteTooltip - jokair9
-------------------------------------------------------------------------------
local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local AT = KUI:NewModule("AT", "AceHook-3.0")

local addText = ""

function AT_GetSpellID(powerID)
	local powerInfo = T.C_AzeriteEmpoweredItem_GetPowerInfo(powerID)
  	if (powerInfo) then
    	local azeriteSpellID = powerInfo["spellID"]
    	return azeriteSpellID
  	end
end

function AT_HasUnselectedPower(tooltip)
	local AzeriteUnlock = T.string_split("%d", AZERITE_POWER_UNLOCKED_AT_LEVEL)
	for i = 8, tooltip:NumLines() do
		local left = _G[tooltip:GetName().."TextLeft"..i]
		local text = left:GetText()
        if text and ( text:find(AzeriteUnlock) or text:find(NEW_AZERITE_POWER_AVAILABLE) ) then
        	return true
        end
    end
end

function AT_ScanSelectedTraits(tooltip, powerName)
	local empowered = T.GetSpellInfo(263978)
	for i = 8, tooltip:NumLines() do
		local left = _G[tooltip:GetName().."TextLeft"..i]
		local text = left:GetText()
		local newText
		local newPowerName
		if text and text:find("-") then
			newText = T.string_gsub(text, "-", " ")
		end
		if powerName:find("-") then
			newPowerName = T.string_gsub(powerName, "-", " ")
		end
        if text and text:find(powerName) then
        	return true
       	elseif (newText and newPowerName and newText:match(newPowerName)) then
       		return true
        elseif (powerName == empowered and not AT_HasUnselectedPower(tooltip)) then
         	return true
        end
    end
end

function AT_GetAzeriteLevel()
	local level
	local azeriteItemLocation = T.C_AzeriteItem_FindActiveAzeriteItem()
	if azeriteItemLocation then
		level = T.C_AzeriteItem_GetPowerLevel(azeriteItemLocation)
	else
		level = 0
	end
	return level
end		

function AT_ClearBlizzardText(tooltip)
	local textLeft = tooltip.textLeft
	if not textLeft then
		local tooltipName = tooltip:GetName()
		textLeft = T.setmetatable({}, { __index = function(t, i)
			local line = _G[tooltipName .. "TextLeft" .. i]
			t[i] = line
			return line
		end })
		tooltip.textLeft = textLeft
	end
	for i = 1, tooltip:NumLines() do
		if textLeft then
			local line = textLeft[i]		
			local text = line:GetText()
			local r, g, b = line:GetTextColor()
			if text then
				local ActiveAzeritePowers = T.string_split("(%d/%d)", CURRENTLY_SELECTED_AZERITE_POWERS) -- Active Azerite Powers (%d/%d)
				local AzeritePowers = T.string_split("(0/%d)", TOOLTIP_AZERITE_UNLOCK_LEVELS) -- Azerite Powers (0/%d)
				local AzeriteUnlock = T.string_split("%d", AZERITE_POWER_UNLOCKED_AT_LEVEL) -- Unlocked at Heart of Azeroth Level %d
				local Durability = T.string_split("%d / %d", DURABILITY_TEMPLATE)
				local AzeriteViewable = T.string_split("<", ITEM_AZERITE_EMPOWERED_VIEWABLE)
				local ReqLevel = T.string_split("%d", ITEM_MIN_LEVEL) 
				if text:match(NEW_AZERITE_POWER_AVAILABLE) then
					line:SetText("")
				end

				if text:find(AzeriteUnlock) then
					line:SetText("")
				end

				if text:find(Durability) or text:find(ReqLevel) then
					textLeft[i-1]:SetText("")
				end

				if text:find(ActiveAzeritePowers) then
                    textLeft[i-1]:SetText("")
                    line:SetText("")
					textLeft[i+1]:SetText(addText)
				elseif (text:find(AzeritePowers) and not text:find(">")) then
                    textLeft[i-1]:SetText("")
                    line:SetText("")
					textLeft[i+1]:SetText(addText)
				-- 8.1 FIX --
				elseif text:find(AZERITE_EMPOWERED_ITEM_FULLY_UPGRADED) then
					textLeft[i-1]:SetText("")
					line:SetText(addText)
					textLeft[i+1]:SetText("")
				end
			end
		end
	end
end

function AT_RemovePowerText(tooltip, powerName)
	local textLeft = tooltip.textLeft
	if not textLeft then
		local tooltipName = tooltip:GetName()
		textLeft = T.setmetatable({}, { __index = function(t, i)
			local line = _G[tooltipName .. "TextLeft" .. i]
			t[i] = line
			return line
		end })
		tooltip.textLeft = textLeft
	end
	for i = 7, tooltip:NumLines() do
		if textLeft then
			local enchanted = T.string_split("%d", ENCHANTED_TOOLTIP_LINE)
			local line = textLeft[i]		
			local text = line:GetText()
			local r, g, b = line:GetTextColor()
			local newText
			local newPowerName
			if text and text:find("-") then
				newText = T.string_gsub(text, "-", " ")
			end
			if powerName:find("-") then
				newPowerName = T.string_gsub(powerName, "-", " ")
			end
			if text then				
				if text:match(CURRENTLY_SELECTED_AZERITE_POWERS_INSPECT) then return end
				if text:find("- "..powerName) then
					line:SetText("")
				elseif (newText and newPowerName and newText:match(newPowerName)) then
       				line:SetText("")
				end
				if ( r < 0.1 and g > 0.9 and b < 0.1 and not text:find(">") and not text:find(ITEM_SPELL_TRIGGER_ONEQUIP) and not text:find(enchanted) ) then
					line:SetText("")
				end
			end
		end
	end
end

function AT_BuildTooltip(self)
	if not E.db.KlixUI.tooltip.azerite.enable or T.IsAddOnLoaded("AzeriteTooltip") then return end
	local name, link = self:GetItem()
  	if not name then return end

  	if T.C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItemByID(link) then

  		addText = ""
		
		local currentLevel = AT_GetAzeriteLevel()

		local specID = T.GetSpecializationInfo(T.GetSpecialization())
		local allTierInfo = T.C_AzeriteEmpoweredItem_GetAllTierInfoByItemID(link)

		if not allTierInfo then return end

		local activePowers = {}
		local activeAzeriteTrait = false

		if AT.db.Compact then
			for j=1, 5 do
				if not allTierInfo[j] then break end

				local tierLevel = allTierInfo[j]["unlockLevel"]
				local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][1]

				if not allTierInfo[1]["azeritePowerIDs"][1] then return end

				local azeriteTooltipText = " "
				for i, _ in T.pairs(allTierInfo[j]["azeritePowerIDs"]) do
					local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][i]
					local azeriteSpellID = AT_GetSpellID(azeritePowerID)				
					local azeritePowerName, _, icon = T.GetSpellInfo(azeriteSpellID)	

					if tierLevel <= currentLevel then
						if AT_ScanSelectedTraits(self, azeritePowerName) then
							local azeriteIcon = '|T'..icon..':24:24:0:0:64:64:4:60:4:60:255:255:255|t'
							azeriteTooltipText = azeriteTooltipText.."  >"..azeriteIcon.."<"

							T.table_insert(activePowers, {name = azeritePowerName})
							activeAzeriteTrait = true
						elseif T.C_AzeriteEmpoweredItem_IsPowerAvailableForSpec(azeritePowerID, specID) then
							local azeriteIcon = '|T'..icon..':24:24:0:0:64:64:4:60:4:60:255:255:255|t'
							azeriteTooltipText = azeriteTooltipText.."  "..azeriteIcon
						elseif not AT.db.OnlySpec then
							local azeriteIcon = '|T'..icon..':24:24:0:0:64:64:4:60:4:60:150:150:150|t'
							azeriteTooltipText = azeriteTooltipText.."  "..azeriteIcon
						end
					elseif T.C_AzeriteEmpoweredItem_IsPowerAvailableForSpec(azeritePowerID, specID) then						
						local azeriteIcon = '|T'..icon..':24:24:0:0:64:64:4:60:4:60:150:150:150|t'
						azeriteTooltipText = azeriteTooltipText.."  "..azeriteIcon
					elseif not AT.db.OnlySpec then
						local azeriteIcon = '|T'..icon..':24:24:0:0:64:64:4:60:4:60:150:150:150|t'
						azeriteTooltipText = azeriteTooltipText.."  "..azeriteIcon
					end				
				end

				if tierLevel <= currentLevel then
					if j > 1 then 
						addText = addText.."\n \n|cFFffcc00Level "..tierLevel..azeriteTooltipText.."|r"
					else
						addText = addText.."\n|cFFffcc00Level "..tierLevel..azeriteTooltipText.."|r"
					end
				else
					if j > 1 then 
						addText = addText.."\n \n|cFF7a7a7aLevel "..tierLevel..azeriteTooltipText.."|r"
					else
						addText = addText.."\n|cFF7a7a7aLevel "..tierLevel..azeriteTooltipText.."|r"
					end
				end
				
			end
		else
			for j=1, 5 do
				if not allTierInfo[j] then break end

				local tierLevel = allTierInfo[j]["unlockLevel"]
				local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][1]

				if not allTierInfo[1]["azeritePowerIDs"][1] then return end

				if tierLevel <= currentLevel then
					if j > 1 then 
						addText = addText.."\n \n|cFFffcc00 Level "..tierLevel.."|r\n"
					else
						addText = addText.."\n|cFFffcc00 Level "..tierLevel.."|r\n"
					end
				else
					if j > 1 then 
						addText = addText.."\n \n|cFF7a7a7a Level "..tierLevel.."|r\n"
					else
						addText = addText.."\n|cFF7a7a7a Level "..tierLevel.."|r\n"
					end
				end

				for i, v in pairs(allTierInfo[j]["azeritePowerIDs"]) do
					local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][i]
					local azeriteSpellID = AT_GetSpellID(azeritePowerID)
						
					local azeritePowerName, _, icon = T.GetSpellInfo(azeriteSpellID)
					local azeriteIcon = '|T'..icon..':20:20:0:0:64:64:4:60:4:60|t'
					local azeriteTooltipText = "  "..azeriteIcon.."  "..azeritePowerName

					if tierLevel <= currentLevel then
						if AT_ScanSelectedTraits(self, azeritePowerName) then
							T.table_insert(activePowers, {name = azeritePowerName})
							activeAzeriteTrait = true	

							addText = addText.."\n|cFF00FF00"..azeriteTooltipText.."|r"			
						elseif T.C_AzeriteEmpoweredItem_IsPowerAvailableForSpec(azeritePowerID, specID) then
							addText = addText.."\n|cFFFFFFFF"..azeriteTooltipText.."|r"
						elseif not AT.db.OnlySpec then
							addText = addText.."\n|cFF7a7a7a"..azeriteTooltipText.."|r"
						end
					elseif T.C_AzeriteEmpoweredItem_IsPowerAvailableForSpec(azeritePowerID, specID) then
						addText = addText.."\n|cFF7a7a7a"..azeriteTooltipText.."|r"
					elseif not AT.db.OnlySpec then
						addText = addText.."\n|cFF7a7a7a"..azeriteTooltipText.."|r"
					end		
				end	
			end
		end

		if AT.db.RemoveBlizzard then
			if activeAzeriteTrait then
				for k, v in T.pairs(activePowers) do
					AT_RemovePowerText(self, v.name)
				end
			end
			AT_ClearBlizzardText(self)
		else
			self:AddLine(addText)
			self:AddLine(" ")
		end
		T.table_wipe(activePowers)
	end
end

function AT:Initialize()
	if not E.db.KlixUI.tooltip.azerite.enable or T.IsAddOnLoaded("AzeriteTooltip") then return end
	
	AT.db = E.db.KlixUI.tooltip.azerite
	
	_G.GameTooltip:HookScript("OnTooltipSetItem", AT_BuildTooltip)
	_G.ItemRefTooltip:HookScript("OnTooltipSetItem", AT_BuildTooltip)
	_G.ShoppingTooltip1:HookScript("OnTooltipSetItem", AT_BuildTooltip)
	--_G.WorldMapTooltip.ItemTooltip.Tooltip:HookScript('OnTooltipSetItem', AT_BuildTooltip)
	--_G.WorldMapCompareTooltip1:HookScript("OnTooltipSetItem", AT_BuildTooltip)
	_G.EmbeddedItemTooltip.ItemTooltip.Tooltip:HookScript("OnTooltipSetItem", AT_BuildTooltip)
end

KUI:RegisterModule(AT:GetName())