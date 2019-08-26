local KUI, T, E, L, V, P, G = unpack(select(2, ...))

if T.IsAddOnLoaded("KeystoneHelper") then return end

local function GetModifiers(linkType, ...)
	if T.type(linkType) ~= 'string' then return end
	local modifierOffset = 4
	local instanceID, mythicLevel, notDepleted, _ = ...
	if linkType:find('item') then
		_, _, _, _, _, _, _, _, _, _, _, _, _, instanceID, mythicLevel = ...
		if ... == '138019' then
			modifierOffset = 16
		else
			return
		end
	elseif not linkType:find('keystone') then
		return
	end

	local modifiers = {}
	for i = modifierOffset, T.select('#', ...) do
		local num = T.string_match(T.select(i, ...) or '', '^(%d+)')
		if num then
			local modifierID = T.tonumber(num)
			if modifierID then
				T.table_insert(modifiers, modifierID)
			end
		end
	end
	
	local numModifiers = #modifiers
	if modifiers[numModifiers] and modifiers[numModifiers] < 2 then
		T.table_remove(modifiers, numModifiers)
	end
	
	return modifiers, instanceID, mythicLevel
end

local function DecorateTooltip(self, link, _)
	if not E.db.KlixUI.tooltip.keystone then return end

	if not link then
		_, link = self:GetItem()
	end
	
	self:AddLine(" ")
	
	if type(link) == 'string' then
		local modifiers, instanceID, mythicLevel = GetModifiers(strsplit(':', link))
		if modifiers then
			for _, modifierID in T.ipairs(modifiers) do
				local modifierName, modifierDescription = T.C_ChallengeMode_GetAffixInfo(modifierID)
				if modifierName and modifierDescription then
					self:AddLine(T.string_format('|cff00ff00%s|r - %s', modifierName, modifierDescription), 0, 1, 0, true)
				end
			end
			self:Show()
		end
	end
end
hooksecurefunc(_G.ItemRefTooltip, 'SetHyperlink', DecorateTooltip) 
--_G.ItemRefTooltip:HookScript('OnTooltipSetItem', DecorateTooltip)
_G.GameTooltip:HookScript('OnTooltipSetItem', DecorateTooltip)