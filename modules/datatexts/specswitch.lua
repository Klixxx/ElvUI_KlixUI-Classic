local KUI, T, E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule('DataTexts')

local SELECT_LOOT_SPECIALIZATION, LOOT_SPECIALIZATION_DEFAULT = SELECT_LOOT_SPECIALIZATION, LOOT_SPECIALIZATION_DEFAULT

local lastPanel, active
local displayString = '';
local activeString = T.string_join("", "|cff00FF00" , ACTIVE_PETS, "|r")
local inactiveString = T.string_join("", "|cffFF0000", FACTION_INACTIVE, "|r")

local menuFrame = T.CreateFrame("Frame", "KlixUI_LootSpecializationDatatextClickMenu", E.UIParent, "UIDropDownMenuTemplate")
menuFrame:SetTemplate('Transparent')

local menuList = {
	{ text = SELECT_LOOT_SPECIALIZATION, isTitle = true, notCheckable = true },
	{ notCheckable = true, func = function() T.SetLootSpecialization(0) end },
	{ notCheckable = true },
	{ notCheckable = true },
	{ notCheckable = true },
	{ notCheckable = true }
}

local specList = {
	{ text = SPECIALIZATION, isTitle = true, notCheckable = true },
	{ notCheckable = true },
	{ notCheckable = true },
	{ notCheckable = true },
	{ notCheckable = true }
}

local function OnEvent(self)
	lastPanel = self

	local specIndex = T.GetSpecialization();
	if not specIndex then return end

	active = T.GetActiveSpecGroup()

	local talent = ''
	local i = T.GetSpecialization(false, false, active)
	if i then
		i = T.select(2, T.GetSpecializationInfo(i))
		if(i) then
			talent = T.string_format('%s', i)
		end
	end

	self.text:SetFormattedText('%s', talent)
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	for i = 1, T.GetNumSpecGroups() do
		if T.GetSpecialization(false, false, i) then
			DT.tooltip:AddLine(T.string_join(" ", T.string_format(displayString, T.select(2, T.GetSpecializationInfo(T.GetSpecialization(false, false, i)))), (i == active and activeString or inactiveString)),1,1,1)
		end
	end

	DT.tooltip:AddLine(' ')
	local specialization = T.GetLootSpecialization()
	if specialization == 0 then
		local specIndex = T.GetSpecialization();

		if specIndex then
			local _, name = T.GetSpecializationInfo(specIndex);
			DT.tooltip:AddLine(T.string_format('|cffFFFFFF%s:|r %s', SELECT_LOOT_SPECIALIZATION, T.string_format(LOOT_SPECIALIZATION_DEFAULT, name)))
		end
	else
		local specID, name = T.GetSpecializationInfoByID(specialization);
		if specID then
			DT.tooltip:AddLine(T.string_format('|cffFFFFFF%s:|r %s', SELECT_LOOT_SPECIALIZATION, name))
		end
	end

	DT.tooltip:AddLine(" ")
	DT.tooltip:AddDoubleLine(L["Left Click:"], L["Change Talent Specialization"], 0.7, 0.7, 1.0)
	DT.tooltip:AddDoubleLine(L["Right Click:"], L["Change Loot Specialization"], 0.7, 0.7, 1.0)
	
	DT.tooltip:Show()
end

local function OnClick(self, button)
	local specIndex = T.GetSpecialization();
	if not specIndex then return end

	if button == "LeftButton" then
		if not PlayerTalentFrame then
			T.LoadAddOn("Blizzard_TalentUI")
		end
		for index = 1, 4 do
			local id, name, _, texture = T.GetSpecializationInfo(index);
			if ( id ) then
				specList[index + 1].text = T.string_format('|T%s:14:14:0:0:64:64:4:60:4:60|t  %s', texture, name)
				specList[index + 1].func = function() T.SetSpecialization(index) end
			else
				specList[index + 1] = nil
			end
		end
		EasyMenu(specList, menuFrame, "cursor", -15, -7, "MENU", 2)
	else
		DT.tooltip:Hide()
		local specID, specName = T.GetSpecializationInfo(specIndex);
		menuList[2].text = T.string_format(LOOT_SPECIALIZATION_DEFAULT, specName);

		for index = 1, 4 do
			local id, name = T.GetSpecializationInfo(index);
			if ( id ) then
				menuList[index + 2].text = name
				menuList[index + 2].func = function() T.SetLootSpecialization(id) end
			else
				menuList[index + 2] = nil
			end
		end
		T.EasyMenu(menuList, menuFrame, "cursor", -15, -7, "MENU", 2)
	end
end

local function ValueColorUpdate(hex, r, g, b)
	displayString = T.string_join("", "|cffFFFFFF%s:|r ")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E['valueColorUpdateFuncs'][ValueColorUpdate] = true

DT:RegisterDatatext('Spec Switch (KUI)',{"PLAYER_ENTERING_WORLD", "CHARACTER_POINTS_CHANGED", "PLAYER_TALENT_UPDATE", "ACTIVE_TALENT_GROUP_CHANGED"}, OnEvent, nil, OnClick, OnEnter)